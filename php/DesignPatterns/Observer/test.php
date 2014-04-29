<?php
namespace DesignPatterns\Observer;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$log = new UserObserver;
$log2 = new SecondObserver;
$g = new User;

$g->attach($log);
$g->attach($log2);
$g->abc = 'test';
