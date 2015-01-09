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
)

const (
  DEBUG = true
  BIZ_DAYS = 30
  DB_HOST = "tcp(192.168.0.121:3306)"
  DB_NAME = "madev_ma88"
  DB_USER = /*"root"*/ "wh_report_user"
  DB_PASS = /*""*/ "abc3!90"
)

// aritm01
type Aritm01_Row struct {
  pdl string
  onhand_amt float64
  brand string  
}

func main() {
  // 1. get the working date
  t := time.Now()
  today := t.Format("2006-01-02")

  if len(os.Args) > 1 {
    today = os.Args[1]
  }

  // m := time.Now().Month()
  month := fmt.Sprintf("%02d", time.Now().Month())

  log.Println( "Working date is " + today + " month is " + month)

  // 2. connect db
  dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
  db, err := sql.Open("mysql", dsn)
  if err != nil {
      log.Fatal(err)
  }
  defer db.Close()

  // 3. get valid item list for query
  var aritm01_item_set map[int]string
  aritm01_item_set = make( map[int]string )

  sql := "select xRecNo, ItmNo from aritm01 where lstno != '' and onhand > 0"
  rows, err := db.Query(sql)
  if err != nil {
      log.Fatal(err)
  }  
  
  var xRecNo int
  var ItmNo string
  for rows.Next() {
    err := rows.Scan(&xRecNo, &ItmNo)
    if err != nil {
        log.Fatal(err)
    }

    _, ok := aritm01_item_set[xRecNo]
    if !ok {
      aritm01_item_set[xRecNo] = ItmNo
    }
  }
  rows.Close()

  log.Println("aritm01_item_set# ", len(aritm01_item_set))

  // 4. get item list for upating
  sql = fmt.Sprintf(`select xItmRecNo, ohQty from invctrl_rpt_%s
                      where dt = '%s'`, 
            month, today)
  logmsg(sql)

  rows, err = db.Query(sql)
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

    _, ok := aritm01_item_set[xRecNo]
    if ok {
      ItmNo = aritm01_item_set[xRecNo]
      go get_aged_days(ItmNo, ohQty, today)

      counter++
      if counter > 10 {
        break 
      }      
    }
  }

  log.Println("Done!")
  var input string
    fmt.Scanln(&input)
   log.Println("Done!")
}

// ---------------------------------------------------
// funciton list
// ---------------------------------------------------
func logmsg(msg string) {
  if DEBUG {
    log.Println(msg)
  }
}
func get_aged_days(itmno string, onhand int, dt string) {
  // run php
  ohQty := fmt.Sprintf("%d", onhand)
  cmd := exec.Command("php", "queryAgedItem_cmd.php", itmno, ohQty, dt)
  stdout, err := cmd.Output()

  if err != nil {
      println("error: " + err.Error())
      return
  }

  print(string(stdout))

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
