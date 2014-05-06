<?php

namespace DesignPatterns\Registry;

abstract class Registry
{
	const LOGGER = 'logger';

	protected static $storeValues = array();

	public static function set($key, $value)
	{
		self::$storeValues[$key] = $value;
	}

	public static function get($key)
	{
		return self::$storeValues[$key];
	}
}