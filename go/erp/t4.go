package main

import (
	"fmt"
	"sync"
	"time"
)

type Auditq_Row struct {
	szDate  string
	szTime  string
	Pgm     string
	User    string
	RefNo   string
	ItmNo   string
	Qty     int
	Msg     string
	RefNo_2 string
}

func main() {
	for pos, char := range "eng日本\x80語" { // \x80 is an illegal UTF-8 encoding
		fmt.Printf("character %#U starts at byte position %d\n", char, pos)
	}
	return

	const sample = "\xbd\xb2\x3d\xbc\x20\xe2\x8c\x98"

	fmt.Println("Println:")
	fmt.Println(sample)

	fmt.Println("Byte loop:")
	for i := 0; i < len(sample); i++ {
		fmt.Printf("%q ", sample[i])
	}
	fmt.Printf("\n")

	fmt.Println("Printf with %x:")
	fmt.Printf("%x\n", sample)

	fmt.Println("Printf with % x:")
	fmt.Printf("% x\n", sample)

	fmt.Println("Printf with %q:")
	fmt.Printf("%q\n", sample)

	fmt.Println("Printf with %+q:")
	fmt.Printf("%+q\n", sample)

	t1, _ := time.Parse("2006-01-02", "2015-01-02")
	t2, _ := time.Parse("2006-01-02", "2014-10-28")
	dd := t2.Sub(t1)
	fmt.Printf("The call took %d to run.\n", dd/time.Hour/24)

	var itmsku2auditq_lock_set = struct {
		sync.RWMutex
		m map[string][]Auditq_Row
	}{m: make(map[string][]Auditq_Row)}

	for i := 50; i < 60; i++ {
		var audit Auditq_Row
		audit.Qty = i
		itmsku2auditq_lock_set.m["A"] = append(itmsku2auditq_lock_set.m["A"], audit)
	}

	for i, v := range itmsku2auditq_lock_set.m["A"] {
		fmt.Printf("a: %d %d", i, v.Qty)
	}
	for i, v := range itmsku2auditq_lock_set.m["A"] {
		itmsku2auditq_lock_set.m["A"][i].Qty = v.Qty - 50
	}
	for i, v := range itmsku2auditq_lock_set.m["A"] {
		fmt.Printf("a: %d %d", i, v.Qty)
	}
}
