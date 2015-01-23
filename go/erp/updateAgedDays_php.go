/*

Description: update aged days
Usage: go run updateAgedDays.go [date:optional]
*/
package main

import (
	"fmt"
	"time"
	// "strings"
	// "strconv"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
	"log"
	"os"
	"os/exec"
	"runtime"
	"sync"
	// "math"
)

const (
	DEBUG      = true
	BIZ_DAYS   = 30
	DB_HOST    = "tcp(192.168.0.121:3306)"
	DB_NAME    = "madev_ma88"
	DB_USER    = /*"root"*/ "wh_report_user"
	DB_PASS    = /*""*/ "abc3!90"
	WORKER_NUM = 6
)

type Aritm01_Row struct {
	LstNo  string
	ItmNo  string
	ItmSku string
	// pdl string
	// onhand_amt float64
	// brand string
}

type Auditq_Row struct {
	szDate  string
	szTime  string
	Pgm     string
	User    string
	RefNo   string
	ItmNo   string
	Qty     int
	Msg     string
	RefNo_2 string
}

type Aged_Row struct {
	ohDays   int
	agedQ30  int
	agedQ60  int
	agedQ90  int
	agedQ120 int
	agedQ150 int
	agedQ180 int
	agedQ365 int
}

// var counter = struct{
//     sync.RWMutex
//     m map[string]int
// }{m: make(map[string]int)}

// xrecno -> Aritm01_Row
var rec2aritm01_set map[int]Aritm01_Row

// itmsku -> branch item rec
var itmsku2recs_set map[string][]int

// itmno -> item rec
var itmno2rec_set map[string]int

// itmsku -> item rec
var itmsku2rec_set map[string]int

// xrecno -> aged days
// var rec2aged_php_set map[int]string
var rec2aged_lock_php_set = struct {
	sync.RWMutex
	m map[int]string
}{m: make(map[int]string)}

// xrecno -> Aged_Row
var rec2aged_lock_set = struct {
	sync.RWMutex
	m map[int]Aged_Row
}{m: make(map[int]Aged_Row)}

// itmsku -> Auditq_Row
var itmsku2auditq_lock_set = struct {
	sync.RWMutex
	m map[string][]Auditq_Row
}{m: make(map[string][]Auditq_Row)}

var wg sync.WaitGroup
var nsToday time.Time

func main() {
	// Init
	// var szSql string

	// rec2aged_php_set = make(map[int]string)

	// step 1. get the working date
	t := time.Now()
	today := t.Format("2006-01-02")

	if len(os.Args) > 1 {
		today = os.Args[1]
	}

	nsToday, _ = time.Parse("2006-01-02", today)
	start := nsToday.AddDate(0, 0, -365)

	// nsToday = t

	// m := time.Now().Month()
	month := fmt.Sprintf("%02d", time.Now().Month())

	log.Println("Working date is " + today + " month is " + month)
	log.Println(start.Format("2006-01-02") + " between " + today)

	// step 2. connect db
	dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	log_memory()

	// step 4. get valid item list for query
	rec2aritm01_set = make(map[int]Aritm01_Row)
	itmsku2recs_set = make(map[string][]int)
	itmno2rec_set = make(map[string]int)

	var xRecNo int
	var ItmNo, LstNo, ItmSku string

	// ------------------Goroutines 1
	wg.Add(1)
	go func(sql string) {
		defer wg.Done()

		rows, err := db.Query(sql)
		if err != nil {
			log.Fatal(err)
		}

		for rows.Next() {
			err := rows.Scan(&xRecNo, &ItmNo, &LstNo, &ItmSku)
			if err != nil {
				log.Fatal(err)
			}

			_, ok := rec2aritm01_set[xRecNo]
			if !ok {
				rec2aritm01_set[xRecNo] = Aritm01_Row{LstNo, ItmNo, ItmSku}
				itmno2rec_set[ItmNo] = xRecNo
				itmsku2recs_set[ItmSku] = append(itmsku2recs_set[ItmSku], xRecNo)
			}
		}
		rows.Close()
	}("select xRecNo, ItmNo, LstNo, ItmSku from aritm01 where lstno != '' and onhand > 0")

	wg.Wait()
	log.Println("Done Phrase1!")

	log.Println("rec2aritm01_set# ", len(rec2aritm01_set))
	log.Println("itmno2rec_set# ", len(itmno2rec_set))
	log.Println("itmsku2recs_set# ", len(itmsku2recs_set))

	// 5. get item list for upating
	sql := fmt.Sprintf(`select xItmRecNo, ohQty from invctrl_rpt_%s
                      where dt = '%s' limit 2000`,
		month, today)
	logmsg(sql)

	rows, err := db.Query(sql)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var ohQty, counter int

	for rows.Next() {
		err := rows.Scan(&xRecNo, &ohQty)
		if err != nil {
			log.Fatal(err)
		}

		_, ok := rec2aritm01_set[xRecNo]
		if ok {
			fmt.Println(".")
			wg.Add(1)
			arItm := rec2aritm01_set[xRecNo]
			go get_aged_days(xRecNo, ohQty, today, arItm)

			counter++
			if counter%50 == 0 {
				log.Println("waiiiiiiiit!")
				wg.Wait()
				// time.Sleep(4 * time.Second)
			}

			if counter > 1000 {
				break
			}
		}
	}

	wg.Wait()
	log.Println("Done Phrase2!")
	log.Println("The rec2aged_lock_set is %d", len(rec2aged_lock_set.m))
	log.Println("The rec2aged_lock_php_set is %d", len(rec2aged_lock_php_set.m))
	log_memory()

	// update database
	for i, v := range rec2aged_lock_set.m {
		log.Println("aged: %d %d", i, v.ohDays)
		// 2015-01-23: update SQL TODO*********************************************************************
	}

	if DEBUG {
		for key, value := range rec2aged_lock_php_set.m {
			fmt.Println("recno:", key, "aged days:", value)
		}
	}

	// var input string
	//   fmt.Scanln(&input)
	//  log.Println("Done!")
}

// ---------------------------------------------------
// funciton list
// ---------------------------------------------------
func get_aged_days(recno int, onhand int, dt string, arItm Aritm01_Row) {
	defer wg.Done()

	szOnhand := fmt.Sprintf("%d", onhand)
	itmno := arItm.ItmNo

	// run php
	cmd := exec.Command("php", "queryAgedItem_cmd.php", itmno, szOnhand, dt)
	stdout, err := cmd.Output()

	if err != nil {
		println("error: " + err.Error())
		return
	}

	ret := strings.Split(stdout, ",")
	ar := Aged_Row{ret[0], ret[1], ret[2], ret[3], ret[4], ret[5],
		ret[6], ret[7]}

	rec2aged_lock_set.Lock()
	rec2aged_lock_set.m[recno] = ar
	rec2aged_lock_set.Unlock()

	rec2aged_lock_php_set.Lock()
	rec2aged_lock_php_set.m[recno] = string(stdout)
	rec2aged_lock_php_set.Unlock()

	// fmt.Println("php queryAgedItem_cmd.php '%s' %d %s", itmno, onhand, dt)
	// logmsg(string(stdout))

	// return string(stdout), nil

	// cmd := fmt.Sprintf(`/usr/bin/php /var/www/html/colin/github/study/go/erp/queryAgedItem_cmd.php '%s' %d '%s'`,
	//       itmno, onhand, dt)
	// log.Println(cmd)

	// // out, err := exec.Run("/usr/bin/php", []string{"php", "test.php"}, nil, "/var/www/html/colin/github/study/go/erp", exec.DevNull, exec.PassThrough, exec.PassThrough)
	// out, err := exec.Command( cmd, "/var/www/html/colin/github/study/go/erp" ).Output()
	// if err != nil {
	//   log.Fatal(err)
	// }
	// log.Println("The return is %s", out)
}

// --------------------------
// funciton list (debug)
// --------------------------
func logmsg(msg string) {
	if DEBUG {
		log.Println(msg)
	}
}

func log_memory() {
	if DEBUG {
		var mem runtime.MemStats
		runtime.ReadMemStats(&mem)
		log.Println("-----------------------")
		log.Println(fmt.Sprintf("%10.2f Mb mem.Alloc", float64(mem.Alloc)/1024.0/1024.0))
		log.Println(fmt.Sprintf("%10.2f Mb mem.TotalAlloc", float64(mem.TotalAlloc)/1024.0/1024.0))
		log.Println(fmt.Sprintf("%10.2f Mb mem.HeapAlloc", float64(mem.HeapAlloc)/1024.0/1024.0))
		log.Println(fmt.Sprintf("%10.2f Mb mem.HeapSys", float64(mem.HeapSys)/1024.0/1024.0))
		log.Println("-----------------------")
	}
}
