#!/usr/bin/env ruby
# History
# 1. 添加brand;2014-06-20 14:41
# 2. 增加DEBUG模式，去除不必要的信息；2014-07-19 16:33
# 3. 移除Sales Amt, PDL:./REB/REF/RNB
# 
# Focus COST

require 'mysql'
require 'ruby-prof'
require 'csv'
require "date"
require "zip"
require 'fileutils'
require 'mail'

DEBUG = false 

RubyProf.start

# init var
end_dt = Date.today.to_s
#end_dt = '2014-11-22'
business_days = 30
#business_days = 1 

$src_csv_dir = File.expand_path(File.dirname(__FILE__)) + '/csv/'
zipfile_name = "#{end_dt}_runrate.zip"

# init dir
#File.delete(zipfile_name) if File.exist?(zipfile_name)
#FileUtils.rm_rf $src_csv_dir
#Dir.mkdir $src_csv_dir


sql_item_list = "select * from all_artrs01 where ItmSKU not in ('XXXX', 'ZZZZ', 'FREIGHT', 'INSURANCE', 'USD$', 'SP-SHP-CHG', 'KEY-RING', 
            'LOGO-FEE', 'THANK YOU', 'SETUP-FEE', 'B-GIFT-BOX', 'DRIVE-CASE', 'FILE-LOAD',
            'CABLE/USB2', 'STRING', 'LABOR') and shipdate between '2014-04-28' and '2014-06-10'"
sql_item_list = "select * from artrs01 where ItmSKU not in ('XXXX', 'ZZZZ', 'FREIGHT', 'INSURANCE', 'USD$', 'SP-SHP-CHG', 'KEY-RING', 
            'LOGO-FEE', 'THANK YOU', 'SETUP-FEE', 'B-GIFT-BOX', 'DRIVE-CASE', 'FILE-LOAD',
            'CABLE/USB2', 'STRING', 'LABOR') limit 10"

all_item_set = Hash.new
report_pdl_set = Hash.new

#debug purpose
pdl_item_set = Hash.new 

class Report_Row
   attr_accessor :pdl, :onhand_amt, :sales_amt, :run_rate
 
   def initialize(params = {})
     @pdl = params[:pdl]
     @onhand_amt = params[:onhand_amt]
     @sales_amt = params[:sales_amt]
     @run_rate = params[:run_rate]      
   end
end

##########################################
# functions
##########################################
def get_item_amt(row, all_item_set)
  sku = row['ItmSKU'].strip
    
  # item test
  return if ['REB-','REBA', 'RCMS', 'RCWD'].include?( sku.slice(0, 4) )
  return if ['CREDI', 'CR-MS', 'CR-WD', 'CR-TO', 'CR-TA', 'CR-AC', 'CR-HT', 
                    'CR-IN', 'CR-LC', 'CR-LG', 'CR-NB', 'CR-PJ', 'CR-PR', 'CR-SM'].include?( sku.slice(0, 5) )

  puts '.'
  # p sku
  # p row['Cost']
  # p row
  # exit 0
  
  if all_item_set.has_key?(sku)
    puts '+'
    all_item_set[sku] += row['Cost'].to_f * row['ShipQty'].to_i
    # puts all_item_set.length
    # exit
  else
    all_item_set[sku] = row['Cost'].to_f * row['ShipQty'].to_i  
  end
  
  # puts all_item_set.length
  # p row
  # exit 0
end

##########################################
# dump data to CSV
def dump2csv(report_pdl_set, start_dt, end_dt, business_days)
  file = $src_csv_dir + 'runrate.csv'
  
  CSV.open(file, "w") do |csv|
    print 'Writing to ' + file 

    # csv << ["PDL", "Onhand AMT", "Sales AMT", "Daily Avg Run Rate"]  
    csv << ["PDL", "Onhand AMT", "Daily Avg Run Rate"]  
    report_pdl_set.each do |key,value|
      # remove useless PDL: ./REB/REF/RNB
      next if ['.','REB', 'REF', 'RNB', 'RNT'].include?(value.pdl)

      # csv << [value.pdl, value.onhand_amt, value.sales_amt, value.run_rate]
      csv << [value.pdl, value.onhand_amt, value.run_rate]
    end

    csv << ["Summary: #{start_dt} ~ #{end_dt}, #{business_days} business days"]
    
  end
end

##########################################
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


##########################################
# start
##########################################
begin
    con = Mysql.new '192.168.0.121', 'wh_report_user', 'abc3!90', 'madev_ma88'

    # get start date    
    start_dt = get_start_dt(con, end_dt, business_days)

    # get cpu item list
    cpu_pdl_items = Array.new
    sql_item_list = "select ItmSKU from aritm01
                      where pdl like 'CPU%' and lstno != ''"
    rs = con.query sql_item_list
    rs.each_hash{|row|; cpu_pdl_items.push( row['ItmSKU'] );}
    p cpu_pdl_items.length()
    # p cpu_pdl_items
    # exit 0

    # puts con.get_server_info
    sql_item_list = "select * from all_artrs01 where ItmSKU not in ('XXXX', 'ZZZZ', 'FREIGHT', 'INSURANCE', 'USD$', 'SP-SHP-CHG', 'KEY-RING', 
            'LOGO-FEE', 'THANK YOU', 'SETUP-FEE', 'B-GIFT-BOX', 'DRIVE-CASE', 'FILE-LOAD',
            'CABLE/USB2', 'STRING', 'LABOR') and shipdate between '#{start_dt}' and '#{end_dt}'"
    # sql_item_list = "select * from artrs01 where ItmSKU not in ('XXXX', 'ZZZZ', 'FREIGHT', 'INSURANCE', 'USD$', 'SP-SHP-CHG', 'KEY-RING', 
    #         'LOGO-FEE', 'THANK YOU', 'SETUP-FEE', 'B-GIFT-BOX', 'DRIVE-CASE', 'FILE-LOAD',
    #         'CABLE/USB2', 'STRING', 'LABOR') and shipdate between '#{start_dt}' and '#{end_dt}'"
    # sql_item_list = "select * from all_artrs01 where ItmSKU  and shipdate between '#{start_dt}' and '#{end_dt}'"
    rs = con.query sql_item_list
    rs.each_hash{|row|; get_item_amt(row, all_item_set);}    

    # PDL    
    counter = 0
    all_item_set.each do |key,value|
      # skip if it doesn't blong CPU
      # next if !cpu_pdl_items.include?(key)

      print '.' if (++counter % 100 == 0)

      pdl = ''
      tsku = Mysql.escape_string(key)

      rs = con.query "select * from aritm01 where ItmSKU = '#{tsku}' and lstno != ''"
      rs.each_hash do |row|
        pdl = row['Pdl'].slice(0, 3).strip        

        pdl = pdl + '_' + row['Brand'] if row['Brand'] == 'IMICRO'

        # classify items according to PDL
        if pdl_item_set.has_key?(pdl)
          item_set = pdl_item_set[pdl]          
        else
          item_set = pdl_item_set[pdl] = Hash.new
        end

        if item_set.has_key?(key)
          item_set[key]['onhand_amt'] += row['Onhand'].to_i * row['Cost'].to_f            
        else
          item_set[key] = {'sales'=>value, 'onhand_amt'=>row['Onhand'].to_i * row['Cost'].to_f, 'brand'=>row['Brand']}
        end

        # if pdl == 'HD'
        #   # hd_all_item_set[key] = value
        #   if hd_all_item_set.has_key?(key)
        #     hd_all_item_set[key]['onhand_amt'] += row['Onhand'].to_i * row['Cost'].to_f            
        #   else
        #     hd_all_item_set[key] = {'sales'=>value, 'onhand_amt'=>row['Onhand'].to_i * row['Cost'].to_f}
        #   end          
        # end        

        if report_pdl_set.has_key?(pdl)          
          report_pdl_set[pdl].onhand_amt += (row['Onhand'].to_i * row['Cost'].to_f)
        else
          sales_amt = 0
          onhand_amt = row['Onhand'].to_i * row['Cost'].to_f
          run_rate = 0
          report_pdl_set[pdl] = Report_Row.new(pdl: pdl, onhand_amt: onhand_amt, sales_amt: sales_amt, run_rate: run_rate)
        end
      end

      report_pdl_set[pdl].sales_amt += value if pdl != ''
    end

    # calc runrate
    puts 'calc runrate...'
    report_pdl_set.each do |pdl, row|
      print '#'
      report_pdl_set[pdl].run_rate = (report_pdl_set[pdl].sales_amt / business_days).round(2)      
    end

    # save data
    dump2csv(report_pdl_set, start_dt, end_dt, business_days)

    if DEBUG
      puts "output item list according to PDL..."    
      pdl_item_set.each do |pdl, item_list|
        CSV.open($src_csv_dir + "#{pdl}_item_set.csv", "w") do |csv|
          csv << ["SKU", "Cost * ShipQty", "Onhand Amt", "Brand"]  
          item_list.each do |key,value| 
            csv << [key, value['sales'], value['onhand_amt'], value['brand']]
          end

          csv << ["Summary: #{start_dt} ~ #{end_dt}, #{business_days} business days"]
        end
      end
    end    
    
    # threads = pdl_item_set.map do |pdl, item_list|
    #   Thread.new(pdl, item_list) do |pdl, item_list|
    #     CSV.open("#{pdl}_item_set.csv", "w") do |csv|
    #       csv << ["SKU", "Cost * ShipQty", "Onhand Amt"]  
    #       item_list.each do |key,value| 
    #         csv << [key, value['sales'], value['onhand_amt']]
    #       end

    #       csv << ["Summary: #{start_dt} ~ #{end_dt}, #{business_days} business days"]
    #     end
    #   end
    # end

    # threads.each {|thr| thr.join }

rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end

result = RubyProf.stop

p all_item_set
p all_item_set.length
p report_pdl_set
p report_pdl_set.length

if DEBUG
  # zip csv files
  Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Dir[File.join($src_csv_dir, '**', '**')].each do |file|
        zipfile.add(file.sub($src_csv_dir, ''), file)
      end
  end  
end

# send out
Mail.defaults do
  delivery_method :smtp, address: "10.1.3.86", port: 25
  # delivery_method :smtp, address: "192.168.4.8", port: 25
  # delivery_method :smtp, address: "127.0.0.1", port: 1025
end
Mail.deliver do
  from     'colin.lin@newbiiz.com'
  # to       ['Irene Wang <irene.wang@malabs.com>','Maria Wei <maria@malabs.com>','Wuhan Inventory <whinvc@malabs.com>']
  #to	'Wuhan Inventory <whinvc@malabs.com>'
  to       'colin.lin@newbiiz.com'
  cc       'colin.lin@newbiiz.com'
  subject  "Auto: RunRate: #{start_dt} ~ #{end_dt}, #{business_days} business days"
  body     "Auto: RunRate: #{start_dt} ~ #{end_dt}, #{business_days} business days"
  add_file DEBUG ? zipfile_name : $src_csv_dir + "runrate.csv"
end

# summary
puts "Summary: #{start_dt} ~ #{end_dt}, #{business_days} business days"

# Print a flat profile to text
# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)

