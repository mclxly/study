<?php

namespace DesignPatterns\AbstractFactory\Html;

use DesignPatterns\AbstractFactory\Picture as BasePicture;

class Picture extends BasePicture
{
	public function render()
	{
		return sprintf('<img src="%s" title="%s"/>', $this->path, $this->name);
	}
}