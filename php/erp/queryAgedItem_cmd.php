<?php
/* Inserted by Bo Wu upon request from Colin on 3/11/2013 */
//set_time_limit(20);


/************************************************************
 * @project: Ma Labs Aged Item detail - TX History
 * @version: 1.0.6
 * @created date: May 28, 2011
 * @last update: Oct 21, 2011 
 * @last date: 
 * @database: auditq_180
 * @description: . 
 
 select xitmrecno, ohQty, ohDays,agedQ365,cast(ohDays - agedQ365 as signed)  from invctrl_rpt_05
where dt = '2011-05-31' and abs(cast(ohDays - agedQ365 as signed)) > 3 and ohDays < 500
limit 50

ALTER TABLE `auditq_180`  DROP INDEX `dt_time`,  ADD INDEX `dt_time` (`Date`, `Time`);

==============================Known issues=============================
case 1: the same time.
Id,Date,Time,Pgm,User,RefNo,ItmNo,SQty,Qty,EQty,Msg,Flag,RefNo_2
79458,2011-05-05,13:52:51,POX     ,TSUEN,684157,TN-TEGS24G,0,2,2,+rx po item. 0/145            ,1,
79459,2011-05-05,13:52:51,POX     ,TSUEN,XF-OUT,TN-TEGS24G,2,2,0,-XFER#:77189 SJ->MI           ,1,77189 

==============================revise history=============================
1.[2011-07-19]: { ["txid"]=> int(0) ["xitmno"]=> string(8) "KB-MK320" ["qty"]=> int(0) ["ohDays"]=> int(500) ["dt"]=> string(3) "???" 
2.[2011-07-21]: ohdays is not accuracy
3.[2011-07-28]: 07/25/11|698937|     5 +   20 =    25|11:03:45|INV_CTR|TSUEN|RX XFER#:91098 LA->SJ 2
4.[2011-09-13]: Transfer# '98787' != '098787'
5.[2011-10-21]: dead recursion + auditq(XFER_OUT) format changed
6.[2011-11-03]: JSON service
7.[2011-11-19]: order by (date+time)desc, Id desc,
Id,Date,Time,Pgm,User,RefNo,ItmNo,SQty,Qty,EQty,Msg,Flag,RefNo_2
2874707,2011-09-02,13:12:21,INV_CTRL,YAN  ,XFR-IN,RD-GIFTBAGM,510,400,910,+RX XFER#:98401 SJ->MI 0.09/0.,1,98401 
2874706,2011-09-02,13:12:21,INV_CTRL,YAN  ,XFR-IN,RD-GIFTBAGM,0,510,510,+RX XFER#:98400 SJ->MI 0.09/0.,1,98400 
8.[2013-07-16]: In function findItem(), SKIP items that id great than the input parameter;

Warning: file_get_contents(http://intra.malabs.com/api4erp/queryAgedItem.php?itmno=AW500-Z467M&onhand=227&date=2011-10-18): failed to open stream: HTTP request

************************************************************/

class CInQueueItem {
	public $txid = 0;
	public $xitmno = 0;	
	public $qty = 0;
	public $ohDays = 0;
	public $dt;
}
					
/******************************************
	 * Config  
******************************************/
define("HOST", "192.168.0.121");
define("DB", "madev_ma88");
define("USER", "wh_report_user");
define("PWD", "abc3!90");
define("DEBUG", false);

ini_set('memory_limit','256M');
date_default_timezone_set("Asia/Chongqing");

$g_isDetail = 0;
$g_itmno = '';
$today = date('Y-m-d');
$format = '';
$onhand = 0;

if ($argc != 4) {
	echo "Usage: php queryAgedItem_cmd.php item# onhand date";
	exit;
} else {
	$g_itmno = $argv[1];
	$onhand = $argv[2];
	$today = $argv[3];
}

if (DEBUG) echo "Itm#:$g_itmno Onhand:$onhand today:$today\r\n";

// -------------------------------------
/*
if  (isset($_POST['itmno']))
	$g_itmno = $_POST['itmno'];
if  (isset($_POST['date']))
	$today = $_POST['date'];	
if  (isset($_POST['format']))
	$format = $_POST['format'];	
if  (isset($_POST['onhand']))
	$onhand = $_POST['onhand'];	
if  (isset($_POST['isDetail']))
	$g_isDetail = $_POST['isDetail'];	
	
if  (isset($_GET['itmno']))
	$g_itmno = $_GET['itmno'];
if  (isset($_GET['date']))
	$today = $_GET['date'];	
if  (isset($_GET['format']))
	$format = $_GET['format'];	
if  (isset($_GET['onhand']))
	$onhand = $_GET['onhand'];	
if  (isset($_GET['isDetail']))
	$g_isDetail = $_GET['isDetail'];	
	*/

//echo $g_itmno;
//$g_itmno = rawurldecode(trim($g_itmno));
//$g_itmno = rawurldecode(trim($g_itmno));
//echo $g_itmno;

if ($g_itmno == '') {
	if  ($format == 'json')
		echo 'error';		
	else
		echo 'ERROR: you need input an itm#!';
		
	exit;
}

if (!is_date($today))
	$today = date('Y-m-d');
	
//$format = strtolower($_POST['format']) == 'json' ? 'json' : 'xml'; //xml is the default

// -------------------------------------	
$mysqli = new mysqli(HOST, USER, PWD, DB);

$inQueueDetail = array();
$inQueue = array();
$g_nRxQty = 0;
$g_nOnhand = $onhand;
$g_recursion_counter = 0;

findItem($inQueueDetail, $mysqli, $g_itmno, $format, $onhand, $inQueue, $g_nRxQty, $today);

if (count($inQueue) == 0) {
	// find nothing
	if  ($format == 'json')
		echo 'empty';
	else
		echo "500,$onhand,$onhand,$onhand,$onhand,$onhand,$onhand,$onhand,";
		
	exit;
}

if (DEBUG) var_dump($inQueue);
if (DEBUG) do_dump($inQueueDetail); //exit;

if  ($format == 'json' && $g_isDetail == 1) {
	echo json_encode($inQueueDetail);
	exit;
}

if (DEBUG) echo '<hr />';
$cnt = count($inQueue);

// po void qty
foreach ($inQueue as $idx => $inItem) {
	if ($inItem->qty < 0) {
		for ($i = $idx+1; $i < $cnt; ++$i) {
			if ($inQueue[$i]->xitmno == $inItem->xitmno) {
				$inQueue[$i]->qty += $inItem->qty;
				if ($inQueue[$i]->qty == 0) $inQueue[$i] = null;
				$inQueue[$idx] = null;
				break;
			}
		}
	}		
}

// cut off rxQty
$g_nRxQty = 0;
foreach ($inQueue as $idx => $inItem) {
	if ($inItem == null) continue;
		
	if ($g_nRxQty == 0 && $inItem->qty > $onhand) {
		$inQueue[$idx]->qty = $onhand;
		$inQueue = array_slice($inQueue, 0, $idx+1); 
		break;
	}
	
	if ($g_nRxQty + $inItem->qty > $onhand) {
		$inQueue[$idx]->qty = $onhand - $g_nRxQty;
		$inQueue = array_slice($inQueue, 0, $idx+1); 
		break;
	}
	
	$g_nRxQty += $inItem->qty;
}

if (DEBUG) do_dump($inQueue);

$g_nRxQty = 0;
$ohDays = $agedQty30 = $agedQty60 = $agedQty90 = $agedQty120 = $agedQty150 = $agedQty180 = $agedQty365 = 0;
foreach($inQueue as $item) {
	if ($item == null) continue;
	
	$g_nRxQty += $item->qty;
	$ohDays = max($item->ohDays, $ohDays);
		
	if($item->ohDays > 30) $agedQty30 += $item->qty;
	if($item->ohDays > 60) $agedQty60 += $item->qty;
	if($item->ohDays > 90) $agedQty90 += $item->qty;
	if($item->ohDays > 120) $agedQty120 += $item->qty;
	if($item->ohDays > 180) $agedQty180 += $item->qty;
	if($item->ohDays > 365) $agedQty365 += $item->qty;
}

// if rxQty < ohQty, return 500
if ($g_nRxQty < $onhand) {
	$ohDays = 500;
	$agedQty30 += $onhand - $g_nRxQty;	
	$agedQty60 += $onhand - $g_nRxQty;	
	$agedQty90 += $onhand - $g_nRxQty;	
	$agedQty120 += $onhand - $g_nRxQty;	
	$agedQty180 += $onhand - $g_nRxQty;	
	$agedQty365 += $onhand - $g_nRxQty;	
} 

if  ($format == 'json')
	echo json_encode($inQueue);
else
	echo "$ohDays,$agedQty30,$agedQty60,$agedQty90,$agedQty120,$agedQty150,$agedQty180,$agedQty365";

//do_dump(json_decode(json_encode($inQueue)));
exit;

/* -----------------------------------------------------
	function list
----------------------------------------------------- */
function error_sql($mysqli, $sql) {
	echo "\r\n$sql\r\n";
	die($mysqli->error.$sql);
}

function is_date( $str ) 
{ 
  $stamp = strtotime( $str ); 
  
  if (!is_numeric($stamp)) 
  { 
     return FALSE; 
  } 
  $month = date( 'm', $stamp ); 
  $day   = date( 'd', $stamp ); 
  $year  = date( 'Y', $stamp ); 
  
  if (checkdate($month, $day, $year)) 
  { 
     return TRUE; 
  } 
  
  return FALSE; 
} 

function findItem(&$inQueueDetail, $mysqli, $itmno, $format, $onhand, &$inQueue, &$g_nRxQty, $startDate, $startTime = '23:59:59', $id = '') {
	global $g_recursion_counter;	
	
	if (DEBUG) {
		echo '<hr/>';
		echo "<h3>onhand: $onhand</h3>";
	}
	
	if (++$g_recursion_counter > 15) {
		echo '<h3 style="color:red;">Warning: dead recursion</h3>';
		return 0;
	}
		
	//$sql = "select * from auditq_180 where ItmNo = '$itmno' and auditq_180.Date <= '$startDate' 
	$sql = "select * from auditq_180 where ItmNo = '$itmno' 
			and concat(convert(auditq_180.Date,char(10)), ' ', convert(auditq_180.Time,char(8))) <= '$startDate $startTime'
			and Flag = 1
			order by concat(convert(auditq_180.Date,char(10)), ' ', convert(auditq_180.Time,char(8))) desc, id desc";
			//order by auditq_180.Date desc,auditq_180.Time desc";
	//if ($startTime != '')
	//	$sql = "select * from auditq_180 where ItmNo = '$itmno' and Date <= '$startDate' and Time <= '$startTime' order by Date desc,Time desc";
	
	if (DEBUG) echo $sql;//exit;
	$result = $mysqli->query($sql) or OnError($mysqli->error);

	$txList = array();
	if($result->num_rows) {
		while($itm = $result->fetch_assoc()) {
			// date+time must older than $startDate+$startTime
			$s1 = "{$itm['Date']} {$itm['Time']}";
			$s2 = "$startDate $startTime";
						
			if (('' != $id && $itm['Id'] >= $id) || strtotime($s1) > strtotime($s2)) {
				if (DEBUG) {
					echo '<h3>SKIP ';
					echo "{$itm['Id']} <= $id OR ";
					echo $s1.':'.strtotime($s1);
					echo ' | ';
					echo $s2.':'.strtotime($s2);
					echo '</h3>';
				}
				continue;			
			}

			$txList[] = array('tx_itm'=>$itm);
		}
		
		// delete REVOKE,void
		//INV_CTRL,"D32G1333CT ",XFR-IN,"     74","    -74","      0",07/09/10,"-REVOKE RX XFER#: 13617       ",GRACE
		//INV_CTRL,"GA-5870OC L",XF-OUT,"   -150","   -150","      0",07/09/10,"-REVOKE: 14977 410.00/410.00  ","LIAN "
		
		//var_dump($txList);exit;
				
		$newLevel = array();
		$ret = scanTxList($newLevel, $txList, $mysqli, $itmno, $format, $onhand, $inQueue, $g_nRxQty, $startDate, $startTime, $id);
		$inQueueDetail = $newLevel;
		return $ret;
	}
	
	return 0;
}

function scanTxList(&$newLevel, $txList, $mysqli, $itmno, $format, $onhand, &$inQueue, &$g_nRxQty, $startDate, $startTime, $id) {	
	global $today;
	global $g_nOnhand;
	global $g_itmno;
	global $g_recursion_counter;
	
	if (DEBUG) {
		$cnt = count($txList);
		echo "<h3>$itmno : $cnt ; $startDate, $startTime</h3><ol>";
	}
	
	$rxQty = 0;
	$break = false;
	
	foreach($txList as $index => &$itm) {
		if ($break) break;
		
		if(is_array($itm)) {			
			foreach($itm as $key => &$value) {				
				$g_recursion_counter = 0;
				
				//echo "<h3>{$value['Msg']}</h3>";
				if (!isInStock($value)) continue;
				//if (isExistInQueue($inQueue, $value['Id'])) continue;
				if ($value['SQty'] > $value['EQty']) continue;
				
				$remainingQty = $onhand - $rxQty;
				
				if ('+rx po' == substr($value['Msg'],0,6)		
					|| (trim($value['Pgm']) == 'INV_ADJ' && '+RK:BUNDLE' == substr($value['Msg'],0,10))		
					|| (trim($value['Pgm']) == 'INV_ADJ' && '+RK:FROM' == substr($value['Msg'],0,8))				
					|| (trim($value['Pgm']) == 'DOCOMB' && '+RK:Rx' == substr($value['Msg'],0,6))
					|| (trim($value['Pgm']) == 'INV_ADJ' && '+RK:UNKNOWN' == substr($value['Msg'],0,11))		
					|| (trim($value['Pgm']) == 'INV_ADJ' && '+RK:PHYSICAL COUNT' == substr($value['Msg'],0,18))
					|| (trim($value['Pgm']) == 'INV_ADJ' && '+RK:FR BOX' == substr($value['Msg'],0,10))
					|| (trim($value['Pgm']) == 'RMA' && '+RMA RESTOCK' == substr($value['Msg'],0,12))
					|| (trim($value['Pgm']) == 'BXCPUEDT' && '+RK' == substr($value['Msg'],0,3))
					|| (trim($value['Pgm']) == 'INV_ADJ' && '+RK:ADJ' == substr($value['Msg'],0,7))) {					
										
					// whether counted TXID already
					$counted = g_countTXID($inQueue, $value['Id']);
					$value['Qty'] -= $counted;
					if ($value['Qty'] <= 0)  {
						if (DEBUG) echo "<h3>{$value['Id']} has been counted!</h3>";
						continue;
					}
					
					$rxQty += ($value['Qty'] > $remainingQty) ? $remainingQty : $value['Qty'];
					$g_nRxQty += ($value['Qty'] > $remainingQty) ? $remainingQty : $value['Qty'];
					
					// type 1
					$inQueItm = new CInQueueItem();
					$inQueItm->txid = $value['Id'];
					$inQueItm->xitmno = $value['ItmNo'];			
					$inQueItm->qty = $remainingQty < $value['Qty'] ? $remainingQty : $value['Qty'];					
					$inQueItm->dt = $value['Date'];
					$inQueItm->ohDays = floor((strtotime($today) - strtotime($inQueItm->dt) + 12*3600.0) / (24*3600.0));
										
					$inQueue[] = $inQueItm;
					
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 1);
					
					$value['Qty'] -= $inQueItm->qty;
				}
				
				if (DEBUG) {
					if (isNewInStock($value))
						echo "<li><table border='1' bgcolor='#FF0000'><tr>";
					else
						echo "<li><table border='1'><tr>";
						
					if(is_array($value)) {
						//echo $value['Msg'];exit;
						foreach($value as $tag => $val) {
							echo '<td>',htmlentities($val),'</td>';
						}
					}
					echo '</tr></table>';
				}				
				
				//$t_onhand = min($value['Qty'], $onhand) - $rxQty;
				$t_onhand = min($value['Qty'], $onhand);
				if ($value['Qty'] + $rxQty > $onhand)
					$t_onhand = $onhand - $rxQty;
				
				// -------------------------------------------------
				// XFER
				if ('+RX XFER#:' == substr($value['Msg'],0,10)) {	
					$leaf = array();
										
					$xfr_out_itmno = getItmNoXFROut($mysqli, $value, $startDate, $startTime);
					
					$temp1 = $g_nRxQty;
					$temp2 = $rxQty;
					
					if ('NotFound' != $xfr_out_itmno) {				
						if (DEBUG) echo "<h3>$xfr_out_itmno XFER found!</h3>";
						$rxQty += findItem($leaf, $mysqli, $xfr_out_itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $startDate, $startTime, $value['Id']);												
					} else {
						if (DEBUG) echo "<h3>$xfr_out_itmno not found!</h3>";
						continue;
					}
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 0, $leaf);
					//do_dump($newLevel);exit;
					
					if ($g_nRxQty - $temp1 < $t_onhand
						&& $rxQty != $g_nRxQty) {
						// added 500 days item in manually
						//echo "man: $g_nRxQty = $temp1 + {$value['Qty']}";										

						// type 1
						$inQueItm = new CInQueueItem();
						$inQueItm->xitmno = $xfr_out_itmno;					
						$inQueItm->qty = $value['Qty'] - ($g_nRxQty - $temp1);
						$inQueItm->dt = '???-Not Found';
						$inQueItm->ohDays = 500;
						
						$inQueue[] = $inQueItm;
						
						// type 2
						$t = array();
						$t["txid"] = 0;
						$t["xitmno"] = $xfr_out_itmno;			
						$t["qty"] = $inQueItm->qty;					
						$t["dt"] = '???-Not Found';	
						$t["msg"] = '';
						$t["isCount"] = 1;
						$t["leaf"] = null;
						$newLevel[] = $t;
												
						$g_nRxQty = $temp1 + $inQueItm->qty;
						$rxQty = $temp2 + $inQueItm->qty;	
					}
				}				
				
				// -------------------------------------------------
				// CVT
				else if ('+RK:RX by' == substr($value['Msg'],0,9)) {
					$temp1 = $g_nRxQty;
					$temp2 = $rxQty;
					
					$cvt_out_itmno = getItmNoCvtOut($mysqli, $value, $startTime);
					if ('NotFound' != $cvt_out_itmno) {				
						$leaf = array();
						$rxQty += findItem($leaf, $mysqli, $cvt_out_itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $value['Date'], $startTime, $value['Id']);				
						// type 2					
						$newLevel[] = g_fillDetailArray($value, 0, $leaf);
					}
					
					if ($temp1 == $g_nRxQty
						&& $temp2 == $rxQty) {
						// added 500 days item in manually
						//echo "man: $g_nRxQty = $temp1 + {$value['Qty']}";										

						// type 1
						$inQueItm = new CInQueueItem();
						$inQueItm->xitmno = $cvt_out_itmno;					
						$inQueItm->qty = $value['Qty'] - ($g_nRxQty - $temp1);
						$inQueItm->dt = '???-Not Found';
						$inQueItm->ohDays = 500;
						
						$inQueue[] = $inQueItm;
						
						// type 2
						$t = array();
						$t["txid"] = 0;
						$t["xitmno"] = $cvt_out_itmno;			
						$t["qty"] = $inQueItm->qty;					
						$t["dt"] = '???-Not Found';	
						$t["msg"] = '';
						$t["isCount"] = 1;
						$t["leaf"] = null;
						$newLevel[] = $t;
												
						$g_nRxQty = $temp1 + $inQueItm->qty;
						$rxQty = $temp2 + $inQueItm->qty;	
					}
				}
				
				// -------------------------------------------------
				// void invoice from other branch, 3 situations
				//Id,Date,Time,Pgm,User,RefNo,ItmNo,SQty,Qty,EQty,Msg,Flag,RefNo_2
				//99906,2011-04-29,10:04:17,IVSMAINT,YOLAW,KL5354,MS/PDUO4G M,0,50,50,+RK:Xfer by YOLAW Voided item ,1,
				//2506125 2011-06-02 09:21:16 SYSMON  SYSMN KR2319 MB-M4A87-EN 0 3 3 +offset_invoice() 95.0000/96.0 1  
				//not handle yet: 1624963 2010-06-07 15:39:33 SYSMON  SYSMN IU3874 MB-M4A87-EN 0 8 8 +void_ivs 95.0000/95.0000 SAND 1  

				else if ('IVSMAINT' == trim($value['Pgm']) && '+RK:Xfer by' == substr($value['Msg'],0,11)) {
					$br = getIvsBranch1($mysqli, $value['RefNo']);
					$itmno = substr($value['ItmNo'],0,10);
					$itmno .= $br;
					if (DEBUG) echo "<h3>$itmno</h3>";
					
					$leaf = array();					
					$rxQty += findItem($leaf, $mysqli, $itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $value['Date'], $value['Time'], $value['Id']);
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 0, $leaf);
				}				
				else if ('SYSMON' == trim($value['Pgm']) && '+offset_invoice' == substr($value['Msg'],0,15)) {
					$br = getIvsBranch2($mysqli, $value['RefNo']);
					$itmno = substr($value['ItmNo'],0,10);
					$itmno .= $br;
					if (DEBUG) echo "<h3>$itmno</h3>";
					
					if (0 == strcmp(trim($itmno), trim($value['ItmNo']))) {
						if (DEBUG) echo '<h3>+offset_invoice branch is the same as ref_ivs!</h3>';
						break;
					}
					
					$leaf = array();					
					$rxQty += findItem($leaf, $mysqli, $itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $value['Date'], $value['Time'], $value['Id']);
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 0, $leaf);
				}
				
				// -------------------------------------------------
				// void invoice from other branch
				//Id,Date,Time,Pgm,User,RefNo,ItmNo,SQty,Qty,EQty,Msg,Flag,RefNo_2
				//99906,2011-04-29,10:04:17,IVSMAINT,YOLAW,KL5354,MS/PDUO4G M,0,50,50,+RK:Xfer by YOLAW Voided item ,1,
				else if ('IVSMAINT' == trim($value['Pgm']) && '+RK:Xfer by' == substr($value['Msg'],0,11)) {					
					$br = getIvsBranch1($mysqli, $value['RefNo']);
					$itmno = substr($value['ItmNo'],0,10);
					$itmno .= $br;
										
					$leaf = array();
					$rxQty += findItem($leaf, $mysqli, $itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $value['Date'], $value['Time'], $value['Id']);
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 0, $leaf);
				}
				
				// 2011-06-08 14:02:41 SYSMON  SYSMN KR9637 XE-X5670 M 0 0 6 +gen_cr_memo() 0.0000/1070.350 1  
				else if (trim($value['Pgm']) == 'SYSMON' && '+gen_cr_memo' == substr($value['Msg'],0,12)) {
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 0);

					$br = getIvsBranch3($mysqli, $value['RefNo']);
					$itmno = substr($value['ItmNo'],0,10);
					$itmno .= $br;
								
					$leaf = array();
					$rxQty += findItem($leaf, $mysqli, $itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $value['Date'], $value['Time'], $value['Id']);
					// type 2					
					$newLevel[] = g_fillDetailArray($value, 0, $leaf);
				}
				
				/* removed on 2011-11-22
				//  2011-05-18 14:30:51 IVSMAINT YOLAW KO6211 TN-TEGS24GM 0 -2 2 -VoidItem() 145.00/145.00 YOLA 1  
				else if (trim($value['Pgm']) == 'IVSMAINT' && '-VoidItem' == substr($value['Msg'],0,9)) {
					$br = getIvsBranch1($mysqli, $value['RefNo']);
					$itmno = substr($value['ItmNo'],0,10);
					$itmno .= $br;
					
					$t_onhand = -$value['Qty'];
					$rxQty += findItem($mysqli, $itmno, $format, $t_onhand, $inQueue, $g_nRxQty, $value['Date'], $value['Time'], $value['Id']);
				}*/
				
				//echo "<ol><li><table border='1'><tr><td>abc</td></tr></table></li></ol>";
				
				if (DEBUG) echo '</li>';
					
				if ($rxQty >= $onhand) {
					if (DEBUG) echo "<h3>1 break: $rxQty >= $onhand</h3>";
					$break = true; 
					break;
				}
				if ($g_nRxQty >= $g_nOnhand) {
					if (DEBUG) echo "<h3>2 break: $g_nRxQty >= $g_nOnhand</h3>";
					$break = true; 
					break;
				}
			}
		}
	}
	if (DEBUG) {
		echo '</ol>';
		echo "<h3>$rxQty : $g_nRxQty</h3>";
	}
	
	return $rxQty;	
}

function getIvsBranch1($mysqli, $ivsno) {	
	$sql = "select branch from all_arinv01 where invno = '$ivsno'";
	//if (DEBUG) echo $sql;
	
	$result = $mysqli->query($sql) or error_sql($mysqli, $sql);
	
	while ($row = $result->fetch_array(MYSQLI_NUM)) {		
		return $row[0];
	}
	
	return 'NotFound';
}

function getIvsBranch2($mysqli, $ivsno) {	
	$sql = "select ShipVia from all_arinv01 where invno = '$ivsno'";
	//if (DEBUG) echo $sql;
	
	$result = $mysqli->query($sql) or error_sql($mysqli, $sql);
	
	$offset_ivs = 'error';
	while ($row = $result->fetch_array(MYSQLI_NUM)) {		
		$offset_ivs = substr($row[0],7,6);
		break;
	}
	
	return getIvsBranch1($mysqli, $offset_ivs);
}

// PoNo:REF-INV# KP7082
function getIvsBranch3($mysqli, $ivsno) {	
	$sql = "select PoNo from all_arinv01 where invno = '$ivsno'";
	//if (DEBUG) echo $sql;
	
	$result = $mysqli->query($sql) or error_sql($mysqli, $sql);
	
	$offset_ivs = 'error';
	while ($row = $result->fetch_array(MYSQLI_NUM)) {		
		$offset_ivs = substr($row[0],9,6);
		break;
	}
	
	return getIvsBranch1($mysqli, $offset_ivs);
}

function getItmNoXFROut($mysqli, $rxRec, &$startDate, &$startTime) {
	if (DEBUG) echo "<h3>getItmNoXFROut</h3>";
		
	$id = $rxRec['Id'];
	$itmno = trim(substr($rxRec['ItmNo'],0,10));
	$refno = $rxRec['RefNo'];
	$refno_2 = $rxRec['RefNo_2'];
	
	// exception
	// -XFER#:99024 LA->MI           
	// +RX XFER#:099024 LA->MI 0.00/5
	if (substr($rxRec['RefNo_2'], 0, 1) == '0') 
		$refno_2 = substr($rxRec['RefNo_2'], 1);
	
	$sql = "select ItmNo,Date,Time from auditq_180 where ItmNo like '{$itmno}%' and auditq_180.Date <= '{$rxRec['Date']}' 
			and (refno_2 = '{$rxRec['RefNo_2']}' or refno_2 = '$refno_2')
			and (RefNo = 'XF-OUT' or RefNo = '$refno')
			and Id != $id
			and Flag = 1
			order by concat(convert(auditq_180.Date,char(10)), ' ', convert(auditq_180.Time,char(8))) desc, id desc";
			//order by auditq_180.Date desc,auditq_180.Time desc";
	if (DEBUG) echo "<h3>$sql</h3>";	
	$result = $mysqli->query($sql) or error_sql($mysqli, $sql);
	
	while ($row = $result->fetch_array(MYSQLI_NUM)) {
		$startDate = $row[1];
		$startTime = $row[2];
		return $row[0];
	}
	
	// 07/25/11|698937|     5 +   20 =    25|11:03:45|INV_CTR|TSUEN|RX XFER#:91098 LA->SJ 2
	$sql = "select ItmNo,Date,Time from auditq_180 where ItmNo like '{$itmno}%' and auditq_180.Date <= '{$rxRec['Date']}' 
			and (refno_2 = '{$rxRec['RefNo_2']}' or refno_2 = '$refno_2')
			and (pgm = 'POX' or RefNo = '$refno')
			and Id != $id
			and Flag = 1
			order by concat(convert(auditq_180.Date,char(10)), ' ', convert(auditq_180.Time,char(8))) desc, id desc";
	if (DEBUG) echo "<h3>$sql</h3>";			
	$result = $mysqli->query($sql) or error_sql($mysqli, $sql);
	
	while ($row = $result->fetch_array(MYSQLI_NUM)) {
		$startDate = $row[1];
		$startTime = $row[2];
		return $row[0];
	}
	
	return 'NotFound';
}

function getItmNoCvtOut($mysqli, $rxRec, &$startTime) {
	$id = $rxRec['Id'];
	$sql = "select ItmNo,Time from auditq_180 where RefNo = '{$rxRec['RefNo']}' and auditq_180.Date <= '{$rxRec['Date']}' and refno_2 = '{$rxRec['RefNo_2']}' 
			and Msg like '-CO:Cvt by%'
			and Id != $id
			and Flag = 1
			order by concat(convert(auditq_180.Date,char(10)), ' ', convert(auditq_180.Time,char(8))) desc, id desc";
	//echo $sql;exit;
			
	$result = $mysqli->query($sql) or error_sql($mysqli, $sql);
	
	while ($row = $result->fetch_array(MYSQLI_NUM)) {
		$startTime = $row[1];
		return $row[0];
	}
	
	return 'NotFound';
}

function isInStock($rxRec) {
	$pos = strpos($rxRec['Msg'], '-SOLD');
	if($pos !== false) {
		return false;
	}
	
	$pos = strpos($rxRec['Msg'], '-online');
	if($pos !== false) {
		return false;
	}
	
	return true;
}

function isNewInStock($rxRec) {
	if ('+rx po' == substr($rxRec['Msg'],0,6))
		return true;
	
	if (trim($rxRec['Pgm']) == 'BXCPUEDT' && '+RK' == substr($rxRec['Msg'],0,3))
		return true;
	
	if (trim($rxRec['Pgm']) == 'INV_ADJ' && '+RK:ADJ' == substr($rxRec['Msg'],0,7))
		return true;
	
	if (trim($rxRec['Pgm']) == 'RMA' && '+RMA RESTOCK' == substr($rxRec['Msg'],0,12))
		return true;	

	if (trim($rxRec['Pgm']) == 'INV_ADJ' && '+RK:FR BOX' == substr($rxRec['Msg'],0,10))
		return true;	

	if (trim($rxRec['Pgm']) == 'INV_ADJ' && '+RK:PHYSICAL COUNT' == substr($rxRec['Msg'],0,18))
		return true;	

	if (trim($rxRec['Pgm']) == 'INV_ADJ' && '+RK:UNKNOWN' == substr($rxRec['Msg'],0,11))
		return true;	
		
	if (trim($rxRec['Pgm']) == 'DOCOMB' && '+RK:Rx' == substr($rxRec['Msg'],0,6))
		return true;	
		
	if (trim($rxRec['Pgm']) == 'INV_ADJ' && '+RK:FROM' == substr($rxRec['Msg'],0,8))
		return true;		

	if (trim($rxRec['Pgm']) == 'INV_ADJ' && '+RK:BUNDLE' == substr($rxRec['Msg'],0,10))
		return true;			
		
	return false;
}

function isExistInQueue($inQueue, $id) {
	foreach ($inQueue as $idx => $inItem) {
		if ($inItem->txid == $id) return true;
	}
	
	return false;
}

function g_countTXID($inQueue, $txid) {
	$count = 0;
	
	foreach ($inQueue as $inItem) {
		if ($inItem->txid == $txid) $count += $inItem->qty;
	}
	
	return $count;
}

function g_fillDetailArray($value, $isCount, $leaf = null) {
	$t = array();	
	$t["txid"] = $value['Id'];
	$t["xitmno"] = $value['ItmNo'];			
	$t["qty"] = $value['Qty'];					
	$t["dt"] = $value['Date'];					
	$t["msg"] = $value['Msg'];
	$t["isCount"] = $isCount;
	$t["leaf"] = $leaf;
	return $t;
}

/* -----------------------------------------------------
	helper list
----------------------------------------------------- */
/**
 * Better GI than print_r or var_dump -- but, unlike var_dump, you can only dump one variable.  
 * Added htmlentities on the var content before echo, so you see what is really there, and not the mark-up.
 * 
 * Also, now the output is encased within a div block that sets the background color, font style, and left-justifies it
 * so it is not at the mercy of ambient styles.
 *
 * Inspired from:     PHP.net Contributions
 * Stolen from:       [highstrike at gmail dot com]
 * Modified by:       stlawson *AT* JoyfulEarthTech *DOT* com 
 *
 * @param mixed $var  -- variable to dump
 * @param string $var_name  -- name of variable (optional) -- displayed in printout making it easier to sort out what variable is what in a complex output
 * @param string $indent -- used by internal recursive call (no known external value)
 * @param unknown_type $reference -- used by internal recursive call (no known external value)
 */
function do_dump(&$var, $var_name = NULL, $indent = NULL, $reference = NULL)
{
    $do_dump_indent = "<span style='color:#666666;'>|</span> &nbsp;&nbsp; ";
    $reference = $reference.$var_name;
    $keyvar = 'the_do_dump_recursion_protection_scheme'; $keyname = 'referenced_object_name';
    
    // So this is always visible and always left justified and readable
    echo "<div style='text-align:left; background-color:white; font: 100% monospace; color:black;'>";

    if (is_array($var) && isset($var[$keyvar]))
    {
        $real_var = &$var[$keyvar];
        $real_name = &$var[$keyname];
        $type = ucfirst(gettype($real_var));
        echo "$indent$var_name <span style='color:#666666'>$type</span> = <span style='color:#e87800;'>&amp;$real_name</span><br>";
    }
    else
    {
        $var = array($keyvar => $var, $keyname => $reference);
        $avar = &$var[$keyvar];

        $type = ucfirst(gettype($avar));
        if($type == "String") $type_color = "<span style='color:green'>";
        elseif($type == "Integer") $type_color = "<span style='color:red'>";
        elseif($type == "Double"){ $type_color = "<span style='color:#0099c5'>"; $type = "Float"; }
        elseif($type == "Boolean") $type_color = "<span style='color:#92008d'>";
        elseif($type == "NULL") $type_color = "<span style='color:black'>";

        if(is_array($avar))
        {
            $count = count($avar);
            echo "$indent" . ($var_name ? "$var_name => ":"") . "<span style='color:#666666'>$type ($count)</span><br>$indent(<br>";
            $keys = array_keys($avar);
            foreach($keys as $name)
            {
                $value = &$avar[$name];
                do_dump($value, "['$name']", $indent.$do_dump_indent, $reference);
            }
            echo "$indent)<br>";
        }
        elseif(is_object($avar))
        {
            echo "$indent$var_name <span style='color:#666666'>$type</span><br>$indent(<br>";
            foreach($avar as $name=>$value) do_dump($value, "$name", $indent.$do_dump_indent, $reference);
            echo "$indent)<br>";
        }
        elseif(is_int($avar)) echo "$indent$var_name = <span style='color:#666666'>$type(".strlen($avar).")</span> $type_color".htmlentities($avar)."</span><br>";
        elseif(is_string($avar)) echo "$indent$var_name = <span style='color:#666666'>$type(".strlen($avar).")</span> $type_color\"".htmlentities($avar)."\"</span><br>";
        elseif(is_float($avar)) echo "$indent$var_name = <span style='color:#666666'>$type(".strlen($avar).")</span> $type_color".htmlentities($avar)."</span><br>";
        elseif(is_bool($avar)) echo "$indent$var_name = <span style='color:#666666'>$type(".strlen($avar).")</span> $type_color".($avar == 1 ? "TRUE":"FALSE")."</span><br>";
        elseif(is_null($avar)) echo "$indent$var_name = <span style='color:#666666'>$type(".strlen($avar).")</span> {$type_color}NULL</span><br>";
        else echo "$indent$var_name = <span style='color:#666666'>$type(".strlen($avar).")</span> ".htmlentities($avar)."<br>";

        $var = $var[$keyvar];
    }
    
    echo "</div>";
}
?>