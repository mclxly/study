<?php
namespace DesignPatterns\Adapter;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$kindle = new Kindle();
$ebook = new EBookAdapter($kindle);

//var_dump($kindle);
//var_dump($ebook);
$ebook->open();