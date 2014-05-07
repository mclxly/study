<?php
namespace DesignPatterns\Specification;

class Not extends AbstractSpecification
{
    protected $spec;

    public function __construct(SpecificationInterface $spec)
    {
        $this->spec = $spec;
    }

    public function isSatisfiedBy(Item $item)
    {
        return !$this->spec->isSatisfiedBy($item);
    }
}