<?php
    
    require 'dbconfig.php';
    
    header("Content-Type: application/json");
  

    $conn = mysqli_connect($dbconfig['host'], $dbconfig['user'], $dbconfig['password'], $dbconfig['name']) or die(mysqli_error($conn));
   
    $posta = mysqli_real_escape_string($conn, $_GET["q"]) or die(mysqli_error($conn));
 
    $query = "SELECT Posta_elettronica FROM IMPIEGATO WHERE Posta_elettronica = '$posta'";
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    echo json_encode(array('exists' => mysqli_num_rows($res) > 0 ? true : false));
    mysqli_close($conn);
?>