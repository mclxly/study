package main

import (
  "database/sql"
  _ "github.com/go-sql-driver/mysql"
  "log"
)

const (
  DB_HOST = "tcp(192.168.0.121:3306)"
  DB_NAME = "madev_ma88"
  DB_USER = /*"root"*/ "wh_report_user"
  DB_PASS = /*""*/ "abc3!90"
)

func main() {
  dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
  db, err := sql.Open("mysql", dsn)
  if err != nil {
      log.Fatal(err)
  }
  defer db.Close()
  var str string
  q := "select itmno from aritm01 limit 1"
  err = db.QueryRow(q).Scan(&str)
  if err != nil {
      log.Fatal(err)
  }
  log.Println(str)
}