<?php
/******************************************
 * Config  
 ******************************************/
define("HOST", "192.168.0.121");
define("DB", "madev_ma88");
define("USER", "maadmin");
define("PWD", "c0m1ab");
define("LOGFN", "q:/logs/reports/daily_invCtrlGather.log");
define("DEBUG", true);
define("MAXDAYS", 500);
define("MAXLEVEL", 5);
define("OLDESTDT", '2010-10-01'); // database

date_default_timezone_set("Asia/Chongqing");

/******************************************
 * Program start
 ******************************************/
g_time_elapsed();
// ----------------------------------
// connect database
$mysqli = new mysqli(HOST, USER, PWD, DB);
if (mysqli_connect_errno()) {
    echo 'Error: Could not connect to database. Please try again later.'.PHP_EOL;
    exit;
}

// ----------------------------------
// date
$today = date('Y-m-d');

if (isset($argv[1])) {
    $today = date("{$argv[1]}");
}

$month = date_format(date_create($today), 'm');

// ----------------------------------
// get item list
$rows = array();

if ($result = $mysqli->query("select xItmRecNo,OhQty,id from invctrl_rpt_$month as A
                        left join aritm01 as B on A.xItmRecNo = B.xRecNo
                        where dt = '$today' and OhQty > 0")) {
                        //and xitmrecno = 180669")) {
    while ($row = $result->fetch_array(MYSQLI_NUM)) {
        $rows[] = $row;
    }
} else {
    g_log($mysqli->error);
    exit;
} // end else

foreach ($rows as $key => $row) {
    echo $key;
    if ($key > 10) {
        break;
    }

    system(' php queryAgedItem_cmd.php "AS-VE208T C" 65 2015-01-01 ');
}

g_time_elapsed();

/*************************************************************
 * function list
 *************************************************************/
 function g_log($str) {
    echo $str . PHP_EOL;
 }

 function g_time_elapsed()
{
    static $last = null;

    $now = microtime(true);

    if ($last != null) {
        echo '<!-- ' . ($now - $last) . ' -->'.PHP_EOL;
    }

    $last = $now;
}
?>