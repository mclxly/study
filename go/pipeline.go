package main

import ( 
    // "bytes"
    "fmt"
    // "log"
    // "os/exec"
    // "strings"
    // "fmt" 
    // "os"
    // "os/exec" 
    // "bytes" 
)

func gen(nums ...int) <-chan int {
    out := make(chan int)
    fmt.Println( "gen 1" )
    go func() {
        for _, n := range nums {
            out <- n
        }
        fmt.Println( "go gen 2" )
        close(out)
    }()
    fmt.Println( "gen 2" )
    return out
}

func sq(in <-chan int) <-chan int {
    out := make(chan int)
    fmt.Println( "sq 1" )
    go func() {
        for n := range in {
            out <- n * n
        }
        fmt.Println( "go sq 2" )
    }()
    fmt.Println( "sq 2" )
    return out
}

func main() {
    c := gen(2, 3)
    out := sq(c)

    // consume the output
    fmt.Println( "main 1" )
    fmt.Println(<-out) // 4
    fmt.Println( "main 2" )
    fmt.Println(<-out) // 9
    fmt.Println( "main 3" )
}