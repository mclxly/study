<?php

namespace DesignPatterns\Registry;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$d1=new \DateTime("2012-07-01 11:14:15.638276");

Registry::set(Registry::LOGGER, new \DateTime("2012-07-08 11:14:15.889342"));

$diff = Registry::get(Registry::LOGGER)->diff($d1);

print_r( $diff );