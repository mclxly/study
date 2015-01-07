<?php
function fexe($value='')
{
    $str = md5($value);

    for ($i=0; $i < 10000; $i++) { 
        $str = md5($value);
    }    
}

$o = 'http://php.net/manual/en/function.printf.php';

for ($i=0; $i < 10000; $i++) { 
    fexe(md5($o));
}    
?>