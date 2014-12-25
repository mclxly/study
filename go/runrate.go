/*
CREATE TABLE mem_runrate_itm
(  
  `ItmNo` VARCHAR(11) not null,
  `Brand` VARCHAR(10) NULL DEFAULT NULL,
  `Cost` DOUBLE(13,4) NULL DEFAULT NULL,
    `Onhand` BIGINT(7) NULL DEFAULT NULL,
    PRIMARY KEY (`ItmNo`)    
) 
ENGINE = MEMORY;

INSERT INTO `mem_runrate_itm` 
(select `ItmNo`,`Brand`,`Cost`,`Onhand`
from aritm01
where lstno != '')
INSERT INTO `mem_runrate_itm` 
(select `ItmNo`,`Brand`,`Cost`,`Onhand`
from aritm01
where lstno != '' and xrecno > 238217)

select ItmSKU, (onhand * cost) as 'amt1', brand 
from aritm01
where LstNo != ''
group by ItmSKU

 */
package main

import (
  "fmt"
  "time"
  "strings"
  "encoding/csv"
  "strconv"
  "os"
  "database/sql"
  _ "github.com/go-sql-driver/mysql"
  "log"
)

const (
  BIZ_DAYS = 30
  DB_HOST = "tcp(192.168.0.121:3306)"
  DB_NAME = "madev_ma88"
  DB_USER = /*"root"*/ "wh_report_user"
  DB_PASS = /*""*/ "abc3!90"
)

// for report
type Report_Row struct {
  onhand_amt float64
  sale_amt float64
  runrate float64
}

// aritm01
type Aritm01_Row struct {
  pdl string
  onhand_amt float64
  brand string  
}

func main() {
  // 1. connect db
  dsn := DB_USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME + "?charset=utf8"
  db, err := sql.Open("mysql", dsn)
  if err != nil {
      log.Fatal(err)
  }
  defer db.Close()

  // 2. get the date 30 days before today
  t := time.Now()
  today := t.Format("2006-01-02")
  end := today
  start := get_start_dt(db, end, BIZ_DAYS)
  log.Println( "Will scan the databse between " + start + " ~ " + end)

  // 3. get item list
  var (        
      itmSKU string
      //pdl string
      //brand string
      cost float64
      //amt float64
      shipQty int
      ret int
  )

  // sold item list
  var all_item_set map[string]float64
  all_item_set = make( map[string]float64 )

  // aritm01 item list
  var aritm01_item_set map[string]Aritm01_Row
  aritm01_item_set = make( map[string]Aritm01_Row )

  // report data
  var report_pdl_set map[string]*Report_Row
  report_pdl_set = make( map[string]*Report_Row )

  sql := fmt.Sprintf(`select ItmSKU,Cost,ShipQty from all_artrs01 where ItmSKU not in ('XXXX', 'ZZZZ', 'FREIGHT', 'INSURANCE', 'USD$', 'SP-SHP-CHG', 'KEY-RING', 
            'LOGO-FEE', 'THANK YOU', 'SETUP-FEE', 'B-GIFT-BOX', 'DRIVE-CASE', 'FILE-LOAD',
            'CABLE/USB2', 'STRING', 'LABOR') and shipdate between '%s' and '%s'`, 
            start, end)
  rows, err := db.Query(sql)
  if err != nil {
      log.Fatal(err)
  }
  defer rows.Close()

  m1 := map[string]int { "REB-":1,"REBA":1, "RCMS":1, "RCWD":1 }
  m2 := map[string]int { "CREDI":1, "CR-MS":1, "CR-WD":1, "CR-TO":1, 
                        "CR-TA":1, "CR-AC":1, "CR-HT":1, "CR-IN":1, 
                        "CR-LC":1, "CR-LG":1, "CR-NB":1, "CR-PJ":1, 
                        "CR-PR":1, "CR-SM":1 }

  counter := 0
  for rows.Next() {
      counter++

      err := rows.Scan(&itmSKU, &cost, &shipQty)
      if err != nil {
          log.Fatal(err)
      }
      //log.Println(start)
      
      itmSKU = strings.TrimSpace(itmSKU)
      
      // skip invalid item
      sku := itmSKU
      if len(itmSKU) > 4 {
        sku = itmSKU[0:4]        
      } else if len(itmSKU) > 5 {
        sku = itmSKU[0:5]
      }

      if _, ok := m1[ sku ]; ok {
        // fmt.Printf("m1 skip %s;", sku)
        continue
      }
      if _, ok := m2[ sku ]; ok {
        // fmt.Printf("m2 skip %s;", sku)
        continue
      }

      _, ok := all_item_set[itmSKU]
      if ok {
        if itmSKU == "I7-4770K" {
          fmt.Printf("before: %f\n", all_item_set[itmSKU])
        }
        
        all_item_set[itmSKU] += (cost * float64(shipQty))
        if itmSKU == "I7-4770K" {
          fmt.Printf("after: %f\n", all_item_set[itmSKU])
        }
      } else {
        all_item_set[itmSKU] = cost * float64(shipQty)
      }
  }
  err = rows.Err()
  if err != nil {
      log.Fatal(err)
  }

  fmt.Printf("all_item_set# %d / %d \n", len(all_item_set), counter)

  fmt.Printf("all_item_set[] %v \n", all_item_set["I7-4770K"])

  //log.Fatal("err")

  // -----------------------------
  // aritm01
  ret = fill_aritm01_map(db, aritm01_item_set)
  if ret < 0 {
    log.Fatal("err: fill_aritm01_map()")
  }

  fmt.Printf("aritm01_item_set# %d \n", len(aritm01_item_set))

  fmt.Printf("aritm01_item_set[] %v \n", aritm01_item_set["I7-4770K"])

  // -----------------------------
  // sum report
  for sku, value := range all_item_set {
    var aritm Aritm01_Row

    // get aritm01
    _, ok := aritm01_item_set[sku]
    if ok {
      aritm = aritm01_item_set[sku]

      // fill report
      _, ok = report_pdl_set[aritm.pdl]
      if ok {
        // tt := &report_pdl_set[aritm.pdl]
        report_pdl_set[aritm.pdl].onhand_amt += aritm.onhand_amt
        report_pdl_set[aritm.pdl].sale_amt += value
      } else {
        report_pdl_set[aritm.pdl] = &Report_Row{aritm.onhand_amt, value, 0 }
      }

      // debug
      if aritm.pdl == "CPU" {
        fmt.Printf("report debug: %v %v \n", aritm, report_pdl_set[aritm.pdl])
      }
    } else {
      // May be: RMA CREDIT ...
      log.Print("Info: can't locate sku " + sku)
    }
  }

  fmt.Printf("report_pdl_set # %d \n", len(report_pdl_set))

  // ---------------------------------
  // write to csv
  csvfile, err := os.Create("runrate.csv")
  if err != nil {
    fmt.Println("Error:", err)
    return
  }
  defer csvfile.Close()

  writer := csv.NewWriter(csvfile)

  // Headers  
  //var new_headers = []string { "PDL", "Onhand AMT", "Sales AMT", "Daily Avg Run Rate" }
  var new_headers = []string { "PDL", "Onhand AMT", "Daily Avg Run Rate" }
  err = writer.Write(new_headers)
  if err != nil {
      fmt.Println(err)
  }

  for pdl, row := range report_pdl_set {
    new_headers[0] = pdl
    new_headers[1] = strconv.FormatFloat(row.onhand_amt, 'f', 2, 64)
    new_headers[2] = strconv.FormatFloat(row.sale_amt / float64(BIZ_DAYS), 'f', 2, 64)

    err = writer.Write( new_headers )
    if err != nil {
      fmt.Println("Error:", err)
      return
    }
  }

  var sum_info = ""
  sum_info = fmt.Sprintf("Summary: %s ~ %s, %d business days", start, end, BIZ_DAYS)
  
  new_headers = []string { sum_info }
  writer.Write( new_headers )

  writer.Flush()

  return


  var str string
  q := "select itmno from aritm01 limit 1"
  err = db.QueryRow(q).Scan(&str)
  if err != nil {
      log.Fatal(err)
  }
  log.Println(str)
}

// ---------------------------------------------------
// funciton list
// ---------------------------------------------------
func get_start_dt(db *sql.DB, end_dt string, days int) string {
  var start string

  sql := fmt.Sprintf(`select distinct shipdate from all_artrs01 where shipdate <= '%s'
        order by shipdate desc
        limit %d`, end_dt, days)
  rows, err := db.Query(sql)
  if err != nil {
      log.Fatal(err)
  }
  defer rows.Close()

  for rows.Next() {
      err := rows.Scan(&start)
      if err != nil {
          log.Fatal(err)
      }
      //log.Println(start)
  }
  err = rows.Err()
  if err != nil {
      log.Fatal(err)
  }

  return start
}

// return -1 fialed
func fill_aritm01_map(db *sql.DB, aritm01_item_set map[string]Aritm01_Row) int {
  var (        
      itmSKU string
      pdl string
      brand string
      //cost float64
      amt float64
      //shipQty int
      //ret int
  )

  sql := `select pdl, ItmSKU, sum(onhand * cost) as 'amt1', brand 
          from aritm01
          where LstNo != ''
          group by ItmSKU`
  rows_2, err := db.Query(sql)
  if err != nil {
      log.Fatal(err)
      return -1
  }  
  defer rows_2.Close()

  for rows_2.Next() {
    err := rows_2.Scan(&pdl, &itmSKU, &amt, &brand)
    if err != nil {
        log.Fatal(err)
        return -1
    }

    _, ok := aritm01_item_set[itmSKU]
    if ok {
      //aritm01_item_set[itmSKU] += (cost * float64(shipQty))
      log.Fatal("should no duplicated itmSKU")
      return -1
    } else {
      if len(pdl) > 3 {
        pdl = strings.TrimSpace( pdl[0:3] )
      } else {
        pdl = strings.TrimSpace( pdl )
      }
      
      aritm01_item_set[itmSKU] = Aritm01_Row{pdl, amt, brand}
    }
  }

  return 0
}

/*
# get the start date
def get_start_dt(con, end_dt, days=30)
  sql = "select distinct shipdate from all_artrs01 where shipdate <= '#{end_dt}'
        order by shipdate desc
        limit #{days}"
  start = false
  rs = con.query sql

  rs.each_hash do |row|
    start = row['shipdate']
  end

  return start
end
*/