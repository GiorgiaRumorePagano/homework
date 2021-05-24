<?php 
    require_once 'dbconfig.php';
    if(!isset($_GET["q"])){
        echo "Errore";
        exit;
    }
    //Imposto header risposta per il json
    header('Content.type: application/json');
    //Mi connetto al database
    $conn = mysqli_connect($dbconfig['host'],$dbconfig['user'],$dbconfig['password'],$dbconfig['name']) or die(mysqli_error($conn));

    $q = mysqli_real_escape_string($conn, $_GET["q"]);
    
    $query = "  SELECT * 
                FROM ISCRITTO 
                WHERE concat(Nome, ' ' ,Cognome) 
                LIKE '%".$q."%'";

    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
    $postArray = array();
    while($row = mysqli_fetch_assoc($res))
        $postArray[]=$row;
    echo json_encode($postArray);
    mysqli_free_result($res);
    mysqli_close($conn);
?>