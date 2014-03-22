<?php

namespace DesignPatterns\AbstractFactory\Json;

use DesignPatterns\AbstractFactory\Text as BaseText;

class Text extends BaseText
{
	public function render()
	{
		return json_encode(array('content' => $this->text));
	}
}