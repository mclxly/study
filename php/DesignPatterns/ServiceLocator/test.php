<?php

namespace DesignPatterns\ServiceLocator;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$t = new ServiceLocator();
$t->add('LogServiceInterface', 'LogService');

if ($t->has('LogServiceInterface')) {
	$log = $t->get('LogServiceInterface');
	$log->prt();
	var_dump($log);
}
var_dump($t);