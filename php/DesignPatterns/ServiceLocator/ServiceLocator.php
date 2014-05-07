<?php

namespace DesignPatterns\ServiceLocator;

class ServiceLocator implements ServiceLocatorInterface
{
	// array: all services
	private $services;

	private $instantiated;

	private $shared;

	public function __construct()
	{
		$this->services = array();
    $this->instantiated = array();
    $this->shared = array();
	}

	public function add($interface, $service, $share = true)
	{
		if (is_object($service) && $share) {
			$this->instantiated[$interface] = $service;
		}

		$this->services[$interface] = (is_object($service) ? get_class($service) : $service);
		$this->shared[$interface] = $share;
	}

	public function has($interface)
  {
      return (isset($this->services[$interface]) || isset($this->instantiated[$interface]));
  }

  public function get($interface)
  {        
    if(isset($this->instantiated[$interface]) && $this->shared[$interface])
        return $this->instantiated[$interface];

    $service = $this->services[$interface];
    $service = __NAMESPACE__.'\\'.$service;
    $object = new $service();
 
    if($this->shared[$interface])
        $this->instantiated[$interface] = $object;

    return $object;
  }
}