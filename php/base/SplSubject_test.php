<?php
abstract class Observable implements SplSubject {
    protected $_observers = [];

    public function attach(SplObserver $observer) {
        $id = spl_object_hash($observer);
        $this->_observers[$id] = $observer;
    }

    public function detach(SplObserver $observer) {
        $id = spl_object_hash($observer);

        if (isset($this->_observers[$id])) {
            unset($this->_observers[$id]);
        }
    }

    public function notify() {
        foreach ( $this->_observers as $observer ) {
            $observer->update($this);
        }
    }
}



abstract class Observer implements SplObserver {
    private $observer;

    function __construct(SplSubject $observer) {
        $this->observer = $observer;
        $this->observer->attach($this);
    }
}

class Loan extends Observable {
    private $bank;
    private $intrest;
    private $name;

    function __construct($name, $bank, $intrest) {
        $this->name = $name;
        $this->bank = $bank;
        $this->intrest = $intrest;
    }

    function setIntrest($intrest) {
        $this->intrest = $intrest;
        $this->notify();
    }

    function getIntrest() {
        return $this->intrest;
    }
}

class Online implements SplObserver {

    public function update(SplSubject $loan) {
        printf("Online    : Post online about modified Intrest rate of : %0.2f\n",$loan->getIntrest());
    }
}

class SMS implements SplObserver {

    public function update(SplSubject $loan) {
        printf("Send SMS  : Send SMS to premium subscribers : %0.2f\n",$loan->getIntrest());
    }
}

$loan = new Loan("Mortage", "Citi Bank", 20.5);
$loan->attach(new Online());
$loan->attach(new SMS());

echo "<pre>";
$loan->setIntrest(17.5);

?>