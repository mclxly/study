<?php
namespace DesignPatterns\AbstractFactory;

//define('BASE_PATH', realpath(dirname(__FILE__)));
define('BASE_PATH',  '/var/www/html/colin');
function my_autoloader($class)
{
    $filename = BASE_PATH . '/' . str_replace('\\', '/', $class) . '.php';
    include($filename);
}
spl_autoload_register('DesignPatterns\AbstractFactory\my_autoloader');

use DesignPatterns\AbstractFactory;
use DesignPatterns\AbstractFactory\HtmlFactory;

//require('Html/Picture.php');
//require('HtmlFactory.php');

$t = new HtmlFactory();

$a = new Html\Picture('path', 'name');
echo $a->render();

$a = new Html\Text('text');
echo $a->render();

$a = new Json\Picture('path', 'name');
echo $a->render();

$a = new Json\Text('path');
echo $a->render();