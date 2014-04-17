<?php
namespace DesignPatterns\FactoryMethod;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$g = new GermanFactory;
$i = new ItalianFactory;

$bike1 = $g->create(1);
$bike2 = $i->create(1);

echo get_class($bike1).PHP_EOL;
echo get_class($bike2).PHP_EOL;

$car1 = $g->create(2);
$car2 = $i->create(2);

echo get_class($car1).PHP_EOL;
echo get_class($car2).PHP_EOL;

$car2 = $i->create(3);