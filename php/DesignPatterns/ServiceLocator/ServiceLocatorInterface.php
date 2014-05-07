<?php

namespace DesignPatterns\ServiceLocator;

interface ServiceLocatorInterface
{
	/*
	Desc: Check if registered.

	@param string $interface

	@return bool
	 */
	public function has($interface);

	/*
	Desc: Get the service.

	@param string $interface

	@return mixed
	 */
	public function get($interface);
}