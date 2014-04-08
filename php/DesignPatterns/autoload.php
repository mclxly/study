<?php
namespace DesignPatterns;

//define('BASE_PATH', realpath(dirname(__FILE__)));
define('BASE_PATH',  '/data/samba/github/study/php/');
function my_autoloader($class)
{
    $filename = BASE_PATH . str_replace('\\', '/', $class) . '.php';
    include($filename);
}
spl_autoload_register('DesignPatterns\my_autoloader');
