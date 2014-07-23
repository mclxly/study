package main

import ("fmt" 
  "time"
  "sort"
)

func test1(xs []float64) {
  xs[0] = 100
}

func add(args ...int) int {
  total := 0
  for _, v := range args {
    total += v
  }
  return total
}

func makeEvenGenerator() func() uint {
  i := uint(0)
  return func() (ret uint) {
    ret = i
    i += 2
    return
  }  
}

type Circle struct {
  x, y, r float64
}

type Person struct {
  Name string
}

func (p *Person) Talk() {
  fmt.Println("Hi, my name is", p.Name)
}

type Android struct {
  Person // Embedded Types
  Model string
}

func f(n int) {
  for i := 0; i < 10; i++ {
    fmt.Println(n, ":", i)
  }
}

func pinger(c chan string) {
  for i := 0; i<10; i++ {
      c <- "ping"
    }  
}

func printer(c chan string) {
  for {
    msg := <- c
    fmt.Println(msg)
    time.Sleep(time.Second * 1)
  }
}

type Person1 struct {
  Name string
  Age int
}

type ByName []Person1

func (this ByName) Len() int {
  return len(this)
}
func (this ByName) Less(i, j int) bool {
  return this[i].Name < this[j].Name
}
func (this ByName) Swap(i, j int) {
  this[i], this[j] = this[j], this[i]
}

func main() {
  // Sort
  kids := []Person1{
    {"Jill", 9},
    {"Jack", 10},
  }
  sort.Sort(ByName(kids))
  fmt.Println(kids)


  // // select
  // c1 := make(chan string, 10)
  // c2 := make(chan string, 10)

  // go func() {
  //   for {
  //     c1 <- "from 1"
  //     time.Sleep(time.Second * 2)
  //   }
  // }()

  // go func() {
  //   for {
  //     c2 <- "from 2"
  //     time.Sleep(time.Second * 3)
  //   }
  // }()

  // go func() {
  //   for {
  //     select {
  //     case msg1 := <- c1:
  //       fmt.Println(msg1)
  //     case msg2 := <- c2:
  //       fmt.Println(msg2)
  //     case <- time.After(time.Second):
  //       fmt.Println("timeout")  
  //     }
  //   }
  // }()

  // var input string
  // fmt.Scanln(&input)

  // // Channel
  // var c chan string = make(chan string)

  // go pinger(c)
  // go printer(c)

  // var input string
  // fmt.Scanln(&input)

  // // Goroutines
  // go f(0)
  // go f(1)
  // go f(2)
  // go f(3)
  // var input string
  // fmt.Scanln(&input)

  // // Embedded Types
  // a := Android{Person{"sadf"}, "sdf"}
  // a.Person.Talk()
  // a.Talk()

  // // Structs
  // var x = Circle{0,0,5}
  // fmt.Println(x.area())

  // // Panic & Recover
  // defer func() {
  //   str := recover()
  //   fmt.Println(str)
  // }()
  // panic("PANIC")


  // // Closure 2
  // nextEven := makeEvenGenerator()
  // fmt.Println(nextEven())
  // fmt.Println(nextEven())
  // fmt.Println(nextEven())

  // // Closure 1
  // x := 0
  // increment := func() int {
  //   x++
  //   return x
  // }
  // fmt.Println(increment())
  // fmt.Println(increment())

  // // function
  // slice1 := []float64{1,2,3}
  // test1(slice1)
  // fmt.Println(slice1)

  // fmt.Println(add(1,2,3))

  // // maps
  // elements := make(map[string]string)
  // elements["H"] = "hello"
  // name, ok := elements["H"]
  // fmt.Println(name, ok)

  // // Slices
  // // var x []float64
  // slice1 := []int{1,2,3}
  // slice2 := append(slice1, 4, 5)
  // fmt.Println(slice1, slice2)

  // fmt.Println("Hello world")
  // var x [5]int
  // x[4] = 100
  // fmt.Println(x)
}