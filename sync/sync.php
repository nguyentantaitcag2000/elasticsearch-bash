<?php
use App\Core\DB;
use App\Models\Group;
if ($argc > 2) {
    $host = $argv[1];
    $curl_user = $argv[2];
    $DOCUMENT_ROOT = $argv[3];
    $_SERVER['DOCUMENT_ROOT'] = $DOCUMENT_ROOT;
    require $_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php';

    $dotenv = Dotenv\Dotenv::createImmutable($_SERVER['DOCUMENT_ROOT'] );
    $dotenv->load();
    
    
    echo "$host - $curl_user - " . $_SERVER['DOCUMENT_ROOT'];
    $db = new DB();
    $group = new Group($db);
    $result = $group->get();
    print_r($result);

} else {
    echo "Not enough arguments provided!";
}
