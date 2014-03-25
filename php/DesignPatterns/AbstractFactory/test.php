<?php
namespace DesignPatterns\AbstractFactory;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

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