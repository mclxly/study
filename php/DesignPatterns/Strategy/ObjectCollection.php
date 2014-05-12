<?php

namespace DesignPatterns\Strategy;

class ObjectCollection
{
  private $elements; // array
  private $comparator; // ComparatorInterface

  public function __construct(array $elements = array())
  {
    $this->elements = $elements;
  }

  // @return array
  public function sort()
  {
    if (!$this->comparator) {
      throw new \LogicException('Comparator is not set');
    }

    $callback = array($this->comparator, 'compare');
    uasort($this->elements, $callback);

    return $this->elements;
  }

  public function setComparator(ComparatorInterface $comparator)
  {
      $this->comparator = $comparator;
  }
}