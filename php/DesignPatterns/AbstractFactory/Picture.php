<?php

namespace DesignPatterns\AbstractFactory;

abstract class Picture implements MediaInterface
{
	protected $path;
	protected $name;

	public function __construct($path, $name = '')
	{
		$this->path = (string)$path;
		$this->name = (string)$name;
	}
}