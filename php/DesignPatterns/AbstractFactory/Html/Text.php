<?php

namespace DesignPatterns\AbstractFactory\Html;

use DesignPatterns\AbstractFactory\Text as BaseText;

class Text extends BaseText
{
	public function render()
	{
		return '<p>' . htmlspecialchars($this->text) . '</p>';
	}
}
