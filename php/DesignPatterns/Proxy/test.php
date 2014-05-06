<?php

namespace DesignPatterns\Proxy;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$svr = array('server'=>'s1', 'ip'=>'192.168.1.2');

$t = new RecordProxy($svr);
echo 'ip:'.$t->ip . PHP_EOL;
echo 'cpu:'.$t->cpu . PHP_EOL;

$t->cpu = 'xeon';
echo 'cpu:'.$t->cpu . PHP_EOL;

