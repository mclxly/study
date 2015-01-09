package main

import ( 
    // "bytes"
    // "fmt"
    // "log"
    "os/exec"
    // "strings"
    // "fmt" 
    // "os"
    // "os/exec" 
    // "bytes" 
)

func main() {
    // 1. set current dir
    // cdir, err := os.Getwd()
    // if err != nil {
    //     println("error: " + err.Error())
    //     return
    // }
    // println("cur: " + cdir)
    
    // os.Chdir(cdir)

    // 2. run php
    cmd := exec.Command("php", "queryAgedItem_cmd.php", "SMTW106", "4500", "2015-01-02")
    stdout, err := cmd.Output()

    if err != nil {
        println("error: " + err.Error())
        return
    }

    print(string(stdout))
    
    // // 2. run php
    // // cmd := exec.Command("php", "info.php", "'SMTW106'", "4500", "'2015-01-02'");//queryAgedItem_cmd.php 'SMTW106' 4500 '2015-01-02'")
    // cmd := exec.Command("php", "queryAgedItem_cmd.php", "SMTW106", "4500", "2015-01-02")
    // var out bytes.Buffer
    // cmd.Stdout = &out
    // err := cmd.Run()
    // if err != nil {
    //     log.Fatal(err)
    // }
    // fmt.Printf("in all caps: %s\n", out.String())

    // cmd, err := exec.Run("/usr/bin/php", []string{"php", "queryAgedItem_cmd.php"}, 
    //     nil, "/var/www/html/colin/github/study/go/erp", exec.DevNull, exec.PassThrough, exec.PassThrough)
    // stdout, err := cmd.Output()

    // if err != nil {
    //     println("error: " + err.Error())
    //     return
    // }
    // print(string(stdout))


    // app := "php"
    // //app := "buah"

    // // arg0 := "-v"
    // arg0 := "queryAgedItem_cmd.php"
    // arg1 := "'SMTW106'"
    // arg2 := "4500"
    // arg3 := "'2015-01-02'"

    // cmd := exec.Command(app, arg0, arg1, arg2, arg3)
    // stdout, err := cmd.Output()

    // if err != nil {
    //     println("error: " + err.Error())
    //     return
    // }

    // print(string(stdout))
}