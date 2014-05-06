<?php

namespace DesignPatterns\Proxy;

class Record
{
	protected $data;

	public function __construct($data = null)
	{
		$this->data = (array)$data;
	}

	public function __set($name, $value)
	{
		$this->data[(string)$name] = $value;
	}

	public function __get($name)
	{		
		if (array_key_exists($name, $this->data)) {
			return $this->data[(string)$name];
		} else {
			return null;
		}
	}
}