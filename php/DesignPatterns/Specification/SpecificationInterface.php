<?php
namespace DesignPatterns\Specification;

interface SpecificationInterface
{
    public function isSatisfiedBy(Item $item);
    public function plus(SpecificationInterface $spec);
    public function either(SpecificationInterface $spec);
    public function not();
}