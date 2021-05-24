<?php 
    require_once 'auth.php';
    if (!$id = checkAuth()) exit;
    header('Content-type: application/json');
    //Mi connetto al database
    $conn = mysqli_connect($dbconfig['host'],$dbconfig['user'],$dbconfig['password'],$dbconfig['name']) or die(mysqli_error($conn));

    $query = "SELECT I.ID_impiegato as ID, IM.Nome as nome, IM.Cognome as cognome FROM ISTRUTTORE I JOIN IMPIEGATO IM on I.ID_impiegato = IM.ID_impiegato";

    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
    $postArray = array();
    while($row = mysqli_fetch_assoc($res))
        $postArray[]=$row;
    echo json_encode($postArray);
    mysqli_free_result($res);
    mysqli_close($conn);
?>

