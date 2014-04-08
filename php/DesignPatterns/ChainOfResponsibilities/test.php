<?php
namespace DesignPatterns\ChainOfResponsibilities;

//use DesignPatterns\ChainOfResponsibilities\Handler;
use DesignPatterns\ChainOfResponsibilities\Responsible\FastStorage;
use DesignPatterns\ChainOfResponsibilities\Responsible\SlowStorage;
use DesignPatterns\ChainOfResponsibilities\Request;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$req = new Request;
$req->verb = 'get';
$req->key = 'abc2';

$data_fs = array('abc'=>'<haha>', 'ccd'=>'<kkkk>');
$data_ss = array('abc2'=>'<haha2>', 'ccd2'=>'<kkkk2>');

$fs = new FastStorage($data_fs);
$ss = new SlowStorage($data_ss);

$fs->append($ss);

if ($fs->handle($req))
  echo 'success'.PHP_EOL;
else
  echo 'failed'.PHP_EOL;

echo $req->forDebugOnly;
