<?php

namespace DesignPatterns\Strategy;

interface ComparatorInterface
{
	/*
	*	@param mixed $a
	*	@param mixed $b
	*
	*	@return bool
	*/
	public function compare($a, $b);
}