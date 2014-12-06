package main

import (
  "fmt"
  "time"
)

func say(s string, thread_id int) {
  for i := 0; i < 500; i++ {
    time.Sleep(100 * time.Millisecond)
    // fmt.Println(s)
    fmt.Printf("Hello %d\n", thread_id)
  }  
}

func main() {
  for i := 0; i < 1000; i++ {
    go say("world %d\n", i)
  }  

  say("world %d\n", 999)
}
