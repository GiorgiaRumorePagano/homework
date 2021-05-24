<?php
    /*Controllo che il Codice Fiscale sia unico*/
    
    require 'dbconfig.php';
    
    header("Content-Type: application/json");
  

    $conn = mysqli_connect($dbconfig['host'], $dbconfig['user'], $dbconfig['password'], $dbconfig['name']) or die(mysqli_error($conn));
   
    $codice_fiscale = mysqli_real_escape_string($conn, $_GET["q"]) or die(mysqli_error($conn));
 
    $query = "SELECT C_F FROM IMPIEGATO WHERE C_F = '$codice_fiscale'";
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    echo json_encode(array('exists' => mysqli_num_rows($res) > 0 ? true : false));
    mysqli_close($conn);
?>