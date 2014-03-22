<?php

namespace DesignPatterns\AbstractFactory\Json;

use DesignPatterns\AbstractFactory\Picture as BasePicture;

class Picture extends BasePicture
{
	public function render()
	{
		return json_encode(array('title' => $this->name, 'path' => $this->path));
	}
}