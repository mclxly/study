<?php
namespace DesignPatterns\Specification;

class Item
{
    protected $price;

    public function __construct($price)
    {
        $this->price = $price;
    }

    public function getPrice()
    {
        return $this->price;
    }
}