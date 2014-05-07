<?php
namespace DesignPatterns\Specification;

class PriceSpecification extends AbstractSpecification
{
    protected $maxPrice;
    protected $minPrice;

    public function __construct($min, $max)
    {
    	$this->minPrice = $min;
    	$this->maxPrice = $max;
    }

    public function setMaxPrice($maxPrice)
    {
        $this->maxPrice = $maxPrice;
    }

    public function setMinPrice($minPrice)
    {
        $this->minPrice = $minPrice;
    }

    public function isSatisfiedBy(Item $item)
    {
        if ( !empty($this->maxPrice) && $item->getPrice() > $this->maxPrice) {
            return false;
        }
        if ( !empty($this->minPrice) && $item->getPrice() < $this->minPrice) {
            return false;
        }

        return true;
    }
}