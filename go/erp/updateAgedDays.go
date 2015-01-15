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
  "os/exec"
  "os"
  "database/sql"
  _ "github.com/go-sql-driver/mysql"
  "log"
  "sync"
  "runtime"
)

const (
  DEBUG = true
  BIZ_DAYS = 30
  DB_HOST = "tcp(192.168.0.121:3306)"
  DB_NAME = "madev_ma88"
  DB_USER = /*"root"*/ "wh_report_user"
  DB_PASS = /*""*/ "abc3!90"
)

type Aritm01_Row struct {
  LstNo string
  ItmNo string
  // pdl string
  // onhand_amt float64
  // brand string  
}

type Auditq_Row struct {
  szDate string
  szTime string
  Pgm string
  User string
  RefNo string
  ItmNo string
  Qty int
  Msg string
  RefNo_2 string
}

// var counter = struct{
//     sync.RWMutex
//     m map[string]int
// }{m: make(map[string]int)}

// xrecno -> Aritm01_Row
var rec2aritm01_set map[int]Aritm01_Row
// lstno -> branch item rec
var lstno2recs_set map[string][]int
// itmno -> item rec
var itmno2rec_set map[string]int
// xrecno -> aged days
var rec2aged_set map[int]string
// lstno -> Auditq_Row
var lstno2auditq_set map[string][]Auditq_Row

var wg sync.WaitGroup

func main() {
  // Init
  rec2aged_set = make( map[int]string )

  // 1. get the working date
  t := time.Now()
  today := t.Format("2006-01-02")

  if len(os.Args) > 1 {
    today = os.Args[1]
  }

  start, _ := time.Parse("2006-01-02", today)
  start = start.AddDate(0, 0, -365)

  // m := time.Now().Month()
  month := fmt.Sprintf("%02d", time.Now().Month())

  log.Println( "Working date is " + today + " month is " + month)
  log.Println( start.Format("2006-01-02") + " between " + today)

  // 2. connect db
  dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
  db, err := sql.Open("mysql", dsn)
  if err != nil {
      log.Fatal(err)
  }
  defer db.Close()

  log_memory()

  // 3. get valid item list for query  
  rec2aritm01_set = make( map[int]Aritm01_Row )
  lstno2recs_set = make( map[string][]int )
  itmno2rec_set = make( map[string]int )

  var xRecNo int
  var ItmNo, LstNo string

  // ------------------Goroutines 1
  wg.Add(1)
  go func(sql string) {
    defer wg.Done()

    rows, err := db.Query(sql)
    if err != nil {
        log.Fatal(err)
    }  

    for rows.Next() {
      err := rows.Scan(&xRecNo, &ItmNo, &LstNo)
      if err != nil {
          log.Fatal(err)
      }

      _, ok := rec2aritm01_set[xRecNo]
      if !ok {
        rec2aritm01_set[xRecNo] = Aritm01_Row{LstNo, ItmNo}
        itmno2rec_set[ItmNo] = xRecNo
        lstno2recs_set[LstNo] = append(lstno2recs_set[LstNo], xRecNo)
      }
    }
    rows.Close()
  }("select xRecNo, ItmNo, LstNo from aritm01 where lstno != '' and onhand > 0")
  
  // ------------------Goroutines 2
  lstno2auditq_set = make( map[string][]Auditq_Row )

  wg.Add(1)
  go func(sql string) {
    defer wg.Done()

    log.Println(sql)

    rows, err := db.Query(sql)
    if err != nil {
        log.Fatal(err)
    }

    for rows.Next() {
      var audit Auditq_Row

      err := rows.Scan(&audit.szDate, &audit.szTime, &audit.Pgm, &audit.User, &audit.RefNo, 
        &audit.ItmNo, &audit.Qty, &audit.Msg, &audit.RefNo_2)
      if err != nil {
          log.Fatal(err)
      }

      _, ok := rec2aritm01_set[xRecNo]
      if !ok {
        lstno := rec2aritm01_set[ itmno2rec_set[audit.ItmNo] ].LstNo
        lstno2auditq_set[lstno] = append(lstno2auditq_set[lstno], audit)
      }
    }
    rows.Close()
  }( fmt.Sprintf(`select A.Date, A.Time, Pgm, A.User, RefNo, ItmNo, Qty, Msg, RefNo_2 
                from auditq_180 as A
                where (A.Date between '%s' and '%s' and Msg like '+%%' and Flag = 1)
                or RefNo_2 != ''`, start.Format("2006-01-02"), today) )

  wg.Wait()

  log.Println("rec2aritm01_set# ", len(rec2aritm01_set))
  log.Println("itmno2rec_set# ", len(itmno2rec_set))
  log.Println("lstno2recs_set# ", len(lstno2recs_set))
  log.Println("lstno2auditq_set# ", len(lstno2auditq_set))

  log_memory()

  return

  // 4. get item list for upating
  sql := fmt.Sprintf(`select xItmRecNo, ohQty from invctrl_rpt_%s
                      where dt = '%s'`, 
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
      wg.Add(1)
      arItm := rec2aritm01_set[xRecNo]
      go get_aged_days(xRecNo, ohQty, today, arItm)

      counter++
      if counter % 250 == 0 {
        log.Println("sleep!")
        wg.Wait()
        // time.Sleep(4 * time.Second)
      }   

      if counter > 10000 {   
        break
      }
    }
  }

  wg.Wait()
  log.Println("Done!")
  log.Println("The rec2aged_set is %d", len(rec2aged_set))

  // if DEBUG {
  //   for key, value := range rec2aged_set {
  //       fmt.Println("recno:", key, "aged days:", value)
  //   }
  // }

  // var input string
  //   fmt.Scanln(&input)
  //  log.Println("Done!")
}

// ---------------------------------------------------
// funciton list
// ---------------------------------------------------
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
    log.Println(fmt.Sprintf("%10.2f Mb mem.Alloc", float64(mem.Alloc) / 1024.0 / 1024.0))
    log.Println(fmt.Sprintf("%10.2f Mb mem.TotalAlloc", float64(mem.TotalAlloc) / 1024.0 / 1024.0))
    log.Println(fmt.Sprintf("%10.2f Mb mem.HeapAlloc", float64(mem.HeapAlloc) / 1024.0 / 1024.0))
    log.Println(fmt.Sprintf("%10.2f Mb mem.HeapSys", float64(mem.HeapSys) / 1024.0 / 1024.0))
    log.Println("-----------------------")
  }
}

func get_aged_days(recno int, onhand int, dt string, arItm Aritm01_Row) {
  defer wg.Done()

  // run php
  ohQty := fmt.Sprintf("%d", onhand)
  itmno := arItm.ItmNo
  cmd := exec.Command("php", "queryAgedItem_cmd.php", itmno, ohQty, dt)
  stdout, err := cmd.Output()

  if err != nil {
      println("error: " + err.Error())
      return
  }

  rec2aged_set[recno] = string(stdout)

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
