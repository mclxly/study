<?php

namespace DesignPatterns\Pool;

class Worker
{
  public function __construct()
  {

  }

  public function run($image, array $callback)
  {
    echo 'Worker::run '.$image.PHP_EOL;
    call_user_func($callback, $this);
  }
}
