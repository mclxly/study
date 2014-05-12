<?php

namespace DesignPatterns\Visitor;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$visitor = new RolePrintVisitor();
$visitor->visitGroup(new Group('Administrators'));
$visitor->visitUser(new User('Colin'));