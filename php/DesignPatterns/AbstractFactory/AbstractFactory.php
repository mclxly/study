<?php
namespace DesignPatterns\AbstractFactory;

abstract class AbstractFactory
{
	abstract public function createText($content);
	abstract public function createPicture($path, $name = '');
}