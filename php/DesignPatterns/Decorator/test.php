<?php
namespace DesignPatterns\Decorator;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$data = array("foo" => "bar", 'abc' => true);
$wb = new WebService($data);

$input = new RenderJson($wb);
var_dump($input->renderData());

$input = new RenderXml($wb);
var_dump($input->renderData());
