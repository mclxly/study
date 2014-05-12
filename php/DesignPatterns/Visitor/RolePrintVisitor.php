<?php

namespace DesignPatterns\Visitor;


class RolePrintVisitor implements RoleVisitorInterface
{
    public function visitGroup(Group $role)
    {
        echo "Role: " . $role->getName();
    }

    public function visitUser(User $role)
    {
        echo "Role: " . $role->getName();
    }
}