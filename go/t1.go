package main

import (
    "fmt"
    "unsafe"
)

type MyType struct {
    Value1 int
    Value2 string
}

func main() {
    myMap := make(map[string]string)
    myMap["Bill"] = "Jill"

    pointer := unsafe.Pointer(&myMap)
    fmt.Printf("Addr: %v Value : %s len: %d\n", pointer, myMap["Bill"], len(myMap))

    ChangeMyMap(myMap)
    fmt.Printf("Addr: %v Value : %s len: %d\n", pointer, myMap["Bill"], len(myMap))

    ChangeMyMapAddr(&myMap)
    fmt.Printf("Addr: %v Value : %s len: %d\n", pointer, myMap["Bill"], len(myMap))
}

func ChangeMyMap(myMap map[string]string) {
    myMap["Billp"] = "Joan"

    pointer := unsafe.Pointer(&myMap)

    fmt.Printf("Addr: %v Value : %s\n", pointer, myMap["Bill"])
}

// Don't Do This, Just For Use In This Article
func ChangeMyMapAddr(myMapPointer *map[string]string) {
    (*myMapPointer)["Bills"] = "Jenny"

    pointer := unsafe.Pointer(myMapPointer)

    fmt.Printf("Addr: %v Value : %s\n", pointer, (*myMapPointer)["Bill"])
}