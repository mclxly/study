<?php
namespace DesignPatterns\DependencyInjection;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$data = array("host" => "192.168.1.1", 'abc' => true);

$ac = new ArrayConfig($data);
$conn = new Connection($ac);
$conn->connect();
echo $conn->getHost();
