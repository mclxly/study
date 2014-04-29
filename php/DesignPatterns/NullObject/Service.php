<?php

namespace DesignPatterns\NullObject;

class Service
{
  protected $logger;

  public function __construct(LoggerInterface $log)
  {
    $this->logger = $log;    
  }

   public function doSomething()
    {
        // no more check "if (!is_null($this->logger))..." with the NullObject pattern
        $this->logger->log('We are in ' . __METHOD__);
        // something to do...
    }
}