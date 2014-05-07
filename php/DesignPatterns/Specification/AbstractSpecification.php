<?php
namespace DesignPatterns\Specification;

abstract class AbstractSpecification implements SpecificationInterface
{
    abstract public function isSatisfiedBy(Item $item);

    public function plus(SpecificationInterface $spec)
    {
        return new Plus($this, $spec);
    }

    public function either(SpecificationInterface $spec)
    {
        return new Either($this, $spec);
    }

    public function not()
    {
        return new Not($this);
    }
}