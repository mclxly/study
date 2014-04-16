<?php

namespace DesignPatterns\Decorator;

/**
 * Class RenderInJson
 */
class RenderJson extends Decorator
{
	public function renderData()
	{
		$output = $this->wrapped->renderData();
		return json_encode($output);
	}
}