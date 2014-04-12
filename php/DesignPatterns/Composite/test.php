<?php
namespace DesignPatterns\Composite;

require_once(realpath(dirname(__FILE__)) . '/../autoload.php');

$input = new InputElement;
$text = new TextElement;
$form = new Form;

$form->addElement($input);
$form->addElement($text);

echo $form->render();