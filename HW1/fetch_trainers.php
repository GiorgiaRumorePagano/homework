<?php 

    require_once 'dbconfig.php';

    //Definisco il tipo di risposta che voglio mi ritorni
    header('Content-type: application/json');

    //Connessione al database
    $conn = mysqli_connect($dbconfig['host'],$dbconfig['user'],$dbconfig['password'],$dbconfig['name']) or die(mysqli_error($conn));

    //Prendo i campi che mi descrivono un corso e li ordino secondo l'ID del corso
    $query = "SELECT I.ID_impiegato, I.Nome, I.Cognome, S.Specializzazione FROM IMPIEGATO I JOIN ISTRUTTORE S on I.ID_impiegato=S.ID_impiegato ORDER BY I.ID_impiegato"; 
    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));

    //Definisco l'array dove andranno tutti i campi che vogliamo prelevare dal database relativamente ai corsi
    $postArray = array();

    //Scorro tutti i risultati che mi vengono tornati dalla query e li ritorno in formato json
    while($row = mysqli_fetch_assoc($res))
        $postArray[]=$row;
    echo json_encode($postArray);
    mysqli_free_result($res);
    mysqli_close($conn);
?>