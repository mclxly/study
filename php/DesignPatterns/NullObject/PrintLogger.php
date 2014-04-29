<?php

namespace DesignPatterns\NullObject;

class PrintLogger implements LoggerInterface
{
	public function log($str)
	{
		echo 'PrintLogger::log '.$str.PHP_EOL;
	}
}