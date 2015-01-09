package main

import (
    "fmt"
    "log"
    "os/exec"
)

func main() {
    cmd := exec.Cmd{
      Path: "script.sh"
      Args: []string{"script.sh"},
      Dir: "/var/www/html/colin/github/study/go/erp",
    }
    cmd.Run()

    out, err := exec.Command("/usr/bin/php -v").Output()
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("The date is %s\n", out)
}
