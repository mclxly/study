<?php

namespace DesignPatterns\Specification;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$item = new Item(220);
$ps = new PriceSpecification(10, 200);
if ( $ps->isSatisfiedBy($item) )
	echo 'good';
else
	echo 'ooohh';
echo PHP_EOL;

$ps1 = new PriceSpecification(10, 200);
$ps2 = new PriceSpecification(500, 800);

$item = new Item(300);
$ei = $ps1->either($ps2);
if ( $ei->isSatisfiedBy($item) )
	echo 'good';
else
	echo 'ooohh';
echo PHP_EOL;