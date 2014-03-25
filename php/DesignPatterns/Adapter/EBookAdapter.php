<?php
namespace DesignPatterns\Adapter;

class EBookAdapter implements PaperBookInterface
{
	protected $ebook;

	public function __construct(EBookInterface $ebook) {
		$this->ebook = $ebook;		
	}

	public function open() {
		$this->ebook->pressStart();
	}

	public function turnPage() {
		$this->ebook->pressNext();
	}
}