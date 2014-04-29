<?php

namespace DesignPatterns\Observer;

class User implements \SplSubject
{
	protected $data = array();

	protected $observers = array();

	public function attach(\SplObserver $observer)
	{
		$this->observers[] = $observer;
	}

	public function detach(\SplObserver $observer)
	{
		$index = array_search($observer, $this->observers);

		if (false !== $index) {
			unset($this->observers[$index]);
		}
	}

	public function notify()
	{
		foreach ($this->observers as $observer) {
			$observer->update($this);
		}
	}

	public function __set($name, $value)
	{
		$this->data[$name] = $value;

		$this->notify();
	}
}