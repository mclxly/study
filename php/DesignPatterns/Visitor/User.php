<?php

namespace DesignPatterns\Visitor;

class User extends Role
{
    protected $name;

    public function __construct($name)
    {
        $this->name = (string) $name;
    }

    public function getName()
    {
        return "User " . $this->name;
    }
}