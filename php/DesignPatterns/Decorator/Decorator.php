<?php

namespace DesignPatterns\Decorator;

/**
 * the Decorator MUST implement the RendererInterface contract, this is the key-feature
 * of this design pattern. If not, this is no longer a Decorator but just a dumb
 * wrapper.
 */

/**
 * class Decorator
 */
abstract class Decorator implements RendererInterface
{
	protected $wrapped;

	public function __construct(RendererInterface $wrappable)
	{
		$this->wrapped = $wrappable;
	}
}