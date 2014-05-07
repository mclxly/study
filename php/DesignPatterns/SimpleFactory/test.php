<?php

namespace DesignPatterns\SimpleFactory;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$fac = new ConcreteFactory;
$b = $fac->createVehicle('bicycle');
$b->driveTo('abc');

//$fac->createVehicle('haha');