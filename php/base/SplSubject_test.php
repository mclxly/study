<?php
$list = new SplDoublyLinkedList();
$list->push('a');
$list->push('b');
$list->push('c');
$list->push('d');
 
echo "FIFO (First In First Out) :\n";
$list->setIteratorMode(SplDoublyLinkedList::IT_MODE_FIFO);
for ($list->rewind(); $list->valid(); $list->next()) {
    echo $list->current()."\n";
}
 
echo "LIFO (Last In First Out) :\n";
$list->setIteratorMode(SplDoublyLinkedList::IT_MODE_LIFO);
for ($list->rewind(); $list->valid(); $list->next()) {
    echo $list->current()."\n";
}

?>