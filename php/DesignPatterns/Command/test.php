<?php
namespace DesignPatterns\Command;

//use DesignPatterns\Command\Invoker;
//use DesignPatterns\Command\HelloCommand;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$vok = new Invoker;
$recv = new Receiver;
$cmd = new HelloCommand($recv);

$vok->setCommand($cmd);
$vok->run();