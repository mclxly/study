<?php

namespace DesignPatterns\Strategy;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$test = array(
    array('id' => '0001', 'date' => '2014/01/10'),
    array('id' => '0015', 'date' => '2014/01/11'),
    array('id' => '0013', 'date' => '2014/01/01'),
    array('id' => '0002', 'date' => '2014/01/01')
  );

$set = new ObjectCollection( $test );
$set->setComparator(new DateComparator());
$set->sort();
var_dump($set);
$set->setComparator(new IdComparator());
$set->sort();
var_dump($set);

