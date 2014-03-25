<?php
namespace DesignPatterns\Adapter;

class Kindle implements EBookInterface
{
	public function pressStart() {
		echo get_class() . '::pressStart';
	}

	public function pressNext() {
		echo get_class() . '::pressNext';
	}
}