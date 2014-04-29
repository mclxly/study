<?php

namespace DesignPatterns\NullObject;

class NullLogger implements LoggerInterface
{
	public function log($str)
	{
		// do nothing
		echo 'NullLogger::log'.PHP_EOL;
	}
}