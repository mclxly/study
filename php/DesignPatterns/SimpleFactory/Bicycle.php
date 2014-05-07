<?php

namespace DesignPatterns\SimpleFactory;

class Bicycle implements VehicleInterface
{
    public function driveTo($destination)
    {
    	echo 'Bicycle'.PHP_EOL;
    }
}