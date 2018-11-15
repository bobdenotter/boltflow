#!/usr/bin/env php
<?php

// better set to php.ini phar.readonly = 0
ini_set("phar.readonly", 0);

$pharFile = '../files/boltflow.phar';

// clean up
if (file_exists($pharFile)) {
    unlink($pharFile);
}
if (file_exists($pharFile . '.gz')) {
    unlink($pharFile . '.gz');
}

// create phar
$p = new Phar($pharFile);

// creating our library using whole directory
$p->buildFromDirectory('./');

// pointing main file which requires all classes
$p->setDefaultStub('boltflow.php', '/boltflow.php');

// plus - compressing it into gzip
$p->compress(Phar::GZ);

echo "$pharFile successfully created. \n";
