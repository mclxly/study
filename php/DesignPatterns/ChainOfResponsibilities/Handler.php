<?php

namespace DesignPatterns\ChainOfResponsibilities;

abstract class Handler
{
  private $successor = null;

  final public function append(Handler $handler)
  {
    if (is_null($this->successor)) {
      $this->successor = $handler;
    } else {
      $this->successor->append($handler);
    }
  }

  final public function handle(Request $req)
  {
    $req->forDebugOnly = get_called_class();
    $processed = $this->processing($req);
    if (!$processed) {
      if (!is_null($this->successor)) {
        $processed = $this->successor->handle($req);
      }
    }

    return $processed;
  }

  abstract protected function processing(Request $req);
}
