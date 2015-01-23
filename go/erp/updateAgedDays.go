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
  // "math"
)

const (
  DEBUG = true
  BIZ_DAYS = 30
  DB_HOST = "tcp(192.168.0.121:3306)"
  DB_NAME = "madev_ma88"
  DB_USER = /*"root"*/ "wh_report_user"
  DB_PASS = /*""*/ "abc3!90"
  WORKER_NUM = 6
)

type Aritm01_Row struct {
  LstNo string
  ItmNo string
  ItmSku string
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

type Aged_Row struct {
  ohDays int
  agedQ30 int
  agedQ60 int
  agedQ90 int
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
var rec2aged_php_set map[int]string

// xrecno -> Aged_Row
var rec2aged_lock_set = struct{
  sync.RWMutex
  m map[int]Aged_Row
} {m: make( map[int]Aged_Row )}
// itmsku -> Auditq_Row
var itmsku2auditq_lock_set = struct{
  sync.RWMutex
  m map[string][]Auditq_Row
} {m: make( map[string][]Auditq_Row )}

var wg sync.WaitGroup
var nsToday  time.Time

func main() {  
  // Init
  var szSql string

  rec2aged_php_set = make( map[int]string )

  // step 1. get the working date
  t := time.Now()
  today := t.Format("2006-01-02")

  if len(os.Args) > 1 {
    today = os.Args[1]
  }

  nsToday, _ := time.Parse("2006-01-02", today)
  start := nsToday.AddDate(0, 0, -365)

  // m := time.Now().Month()
  month := fmt.Sprintf("%02d", time.Now().Month())

  log.Println( "Working date is " + today + " month is " + month)
  log.Println( start.Format("2006-01-02") + " between " + today)

  // step 2. connect db
  dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
  db, err := sql.Open("mysql", dsn)
  if err != nil {
      log.Fatal(err)
  }
  defer db.Close()

  log_memory()

  // step 3. get auditq count
  var totalRows, pageSize int  

  szSql = fmt.Sprintf(`select count(id)
                from auditq_180 as A
                where (A.Date between '%s' and '%s' and Msg like '+%%' and Flag = 1)
                or RefNo_2 != ''`, start.Format("2006-01-02"), today)
  err = db.QueryRow(szSql).Scan(&totalRows)
  switch {
  case err == sql.ErrNoRows:
          log.Fatal("No user with that ID.")
  case err != nil:
          log.Fatal(err)
  default:
          pageSize = totalRows / WORKER_NUM
          fmt.Printf("get auditq total rows is %d / %d\n", totalRows, pageSize)
  }

  // step 4. get valid item list for query  
  rec2aritm01_set = make( map[int]Aritm01_Row )
  itmsku2recs_set = make( map[string][]int )
  itmno2rec_set = make( map[string]int )

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
  
  // ------------------Goroutines 2
  // lstno2auditq_set = make( map[string][]Auditq_Row )

  startid := 0
  for i := 0; i < WORKER_NUM; i++ {
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
        if ok {
          itmsku := rec2aritm01_set[ itmno2rec_set[audit.ItmNo] ].ItmSku
          itmsku2auditq_lock_set.Lock()
          itmsku2auditq_lock_set.m[itmsku] = append(itmsku2auditq_lock_set.m[itmsku], audit)
          itmsku2auditq_lock_set.Unlock()
        }
      }
      rows.Close()
    }( fmt.Sprintf(`select A.Date, A.Time, Pgm, A.User, RefNo, ItmNo, Qty, Msg, RefNo_2 
                  from auditq_180 as A
                  where (A.Date between '%s' and '%s' and Msg like '+%%' and Flag = 1)
                  or RefNo_2 != ''
                  order by A.Date, A.Time
                  limit %d, %d`, start.Format("2006-01-02"), today, startid, pageSize) )
    startid += pageSize
  }  

  wg.Wait()

  log.Println("rec2aritm01_set# ", len(rec2aritm01_set))
  log.Println("itmno2rec_set# ", len(itmno2rec_set))
  log.Println("itmsku2recs_set# ", len(itmsku2recs_set))
  log.Println("itmsku2auditq_lock_set# ", len(itmsku2auditq_lock_set.m))

  log_memory()

  // 5. get item list for upating
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
      fmt.Println(".")
      wg.Add(1)
      arItm := rec2aritm01_set[xRecNo]
      go get_aged_days(xRecNo, ohQty, today, arItm)

      counter++
      if counter % 250 == 0 {
        log.Println("waiiiiiiiit!")
        wg.Wait()
        // time.Sleep(4 * time.Second)
      }   

      if counter > 200 {   
        break
      }
    }
  }

  wg.Wait()
  log.Println("Done!")
  log.Println("The rec2aged_lock_set is %d", len(rec2aged_lock_set.m))
  log.Println("The rec2aged_php_set is %d", len(rec2aged_php_set))

  for i, v := range rec2aged_lock_set.m {
    log.Println("aged: %d %d", i, v.ohDays )
  }

  logAuditq(3086)

  // if DEBUG {
  //   for key, value := range rec2aged_php_set {
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
func get_aged_days(recno int, onhand int, dt string, arItm Aritm01_Row) {
  defer wg.Done()

  szOnhand := fmt.Sprintf("%d", onhand)
  itmno := arItm.ItmNo

/*  type Aged_Row struct {
    ohDays int
    agedQ30 int
    agedQ60 int
    agedQ90 int
    agedQ120 int
    agedQ150 int
    agedQ180 int
    agedQ365 int
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
    t1, _ := time.Parse("2006-01-02", "2015-01-03")
    t2, _ := time.Parse("2006-01-02", "2014-09-02")
    dd := t1.Sub(t2)
    fmt.Printf("The call took %d to run.\n", dd / time.Hour / 24)
*/
  var ar Aged_Row
  var maxDays int

  for i, v := range itmsku2auditq_lock_set.m[arItm.ItmSku] { 
    // --------------------------
    // skip invalid rec
    if v.ItmNo != rec2aritm01_set[recno].ItmNo {
      continue
    }
    
    // --------------------------
    // count  
    t2, _ := time.Parse("2006-01-02", v.szDate)
    days := int(nsToday.Sub(t2) / time.Hour / 24)

    if maxDays < days {
      maxDays = days
    }

    if v.Qty >= onhand {
      itmsku2auditq_lock_set.Lock()  
      itmsku2auditq_lock_set.m[arItm.ItmSku][i].Qty = itmsku2auditq_lock_set.m[arItm.ItmSku][i].Qty - onhand
      itmsku2auditq_lock_set.Unlock()
      break
    } else {
      itmsku2auditq_lock_set.Lock()  
      itmsku2auditq_lock_set.m[arItm.ItmSku][i].Qty = 0
      itmsku2auditq_lock_set.Unlock()

      onhand = onhand - v.Qty
    }
    
    // fmt.Printf("%+v\n", v)
  }

  ar.ohDays = maxDays
  rec2aged_lock_set.Lock()
  rec2aged_lock_set.m[recno] = ar
  rec2aged_lock_set.Unlock()

  //log.Fatal("aged!!")

  return

  // run php  
  cmd := exec.Command("php", "queryAgedItem_cmd.php", itmno, szOnhand, dt)
  stdout, err := cmd.Output()

  if err != nil {
      println("error: " + err.Error())
      return
  }

  rec2aged_php_set[recno] = string(stdout)

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
    log.Println(fmt.Sprintf("%10.2f Mb mem.Alloc", float64(mem.Alloc) / 1024.0 / 1024.0))
    log.Println(fmt.Sprintf("%10.2f Mb mem.TotalAlloc", float64(mem.TotalAlloc) / 1024.0 / 1024.0))
    log.Println(fmt.Sprintf("%10.2f Mb mem.HeapAlloc", float64(mem.HeapAlloc) / 1024.0 / 1024.0))
    log.Println(fmt.Sprintf("%10.2f Mb mem.HeapSys", float64(mem.HeapSys) / 1024.0 / 1024.0))
    log.Println("-----------------------")
  }
}

func logAuditq(recno int) {
  if !DEBUG {
    return
  }

  arItm := rec2aritm01_set[recno]
  for _, v := range itmsku2auditq_lock_set.m[arItm.ItmSku] {
    fmt.Printf("%+v\n", v)
  }
}