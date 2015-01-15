package main

import (
    "fmt"
    // "time"
    "sync"
)

func say(s int, h map[int]string, wg *sync.WaitGroup) {
    defer wg.Done()

    for i := 0; i < 100; i++ {
        h[s*100 + i] = fmt.Sprintf("%d", s*100 + i)
    }    
}

func main() {  
    var wg sync.WaitGroup

    htbl := make(map[int]string)

    for i := 0; i <= 10000; i++ {
        wg.Add(1)
        go say(i, htbl, &wg)    
    }
    
    // say(100, htbl, wg)

    wg.Wait()

// time.Sleep(1000 * time.Millisecond)
    fmt.Println( len(htbl) )
    fmt.Println( htbl[101] )
    fmt.Println( htbl[2201] )
    fmt.Println( htbl[9601] )
}