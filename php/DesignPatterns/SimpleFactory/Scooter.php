<?php

namespace DesignPatterns\SimpleFactory;

class Scooter implements VehicleInterface
{
    public function driveTo($destination)
    {
    	echo 'Scooter'.PHP_EOL;
    }
}