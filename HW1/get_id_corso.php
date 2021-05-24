<?php 
    require_once 'auth.php';
    if (!$id = checkAuth()) exit;
    header('Content-type: application/json');
    //Mi connetto al database
    $conn = mysqli_connect($dbconfig['host'],$dbconfig['user'],$dbconfig['password'],$dbconfig['name']) or die(mysqli_error($conn));

    $query = "SELECT ID_corso FROM CORSO HAVING ID_corso >= ALL (SELECT ID_corso FROM CORSO)";

    $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
    if(mysqli_num_rows($res))
        echo json_encode(mysqli_fetch_assoc($res));
    mysqli_free_result($res);
    mysqli_close($conn);
?>
