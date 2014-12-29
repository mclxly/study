package main

import (
  "fmt"
  "time"
  "reflect"
)

type Hello struct{}

func main() {
  t := time.Now()
  today := t.Format("2006-01-02")
  fmt.Println(t, "=>", today) 
  fmt.Println(reflect.TypeOf(today))

  m := map[string]int { "REB-":0,"REBA":0, "RCMS":0, "RCWD":0 }
  if _, ok := m["REaBA"]; ok {
    fmt.Println("ok")
  }

  a := "gogogogo"
  a = a[0:4]
  fmt.Println(a)
}
