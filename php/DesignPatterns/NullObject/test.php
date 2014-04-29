<?php
namespace DesignPatterns\NullObject;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$log = new NullLogger;
$log = new PrintLogger;
$g = new Service($log);
$g->doSomething();