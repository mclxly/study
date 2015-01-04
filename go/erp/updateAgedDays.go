/*

Description: update aged days
Usage: go run updateAgedDays.go [date:optional]
 */
package main

import (
  // "fmt"
  "time"
  // "strings"
  // "strconv"
  "os"
  "database/sql"
  _ "github.com/go-sql-driver/mysql"
  "log"
)

const (
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
  log.Println( "Working data is " + today + " month is " + month)
  return


  // 2. connect db
  dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
  db, err := sql.Open("mysql", dsn)
  if err != nil {
      log.Fatal(err)
  }
  defer db.Close()
  
}

// ---------------------------------------------------
// funciton list
// ---------------------------------------------------
