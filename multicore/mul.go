package main

import (
    //"fmt"
    //"time"
    "crypto/md5"
    // "fmt"
    // "io"
)

func fexe(s string) {
    data := []byte("http://php.net/manual/en/function.printf.php")
    md5.Sum(data)

    for i := 0; i < 10000; i++ {
        md5.Sum(data)
    }
}

func main() { 
    for i := 1; i < 10000; i++ {
        go fexe("none")
    }
    fexe("none")
}