<?php

namespace DesignPatterns\ServiceLocator;

class LogService implements LogServiceInterface
{
	public function prt()
	{
		echo 'LogService::prt'.PHP_EOL;
	}
} 