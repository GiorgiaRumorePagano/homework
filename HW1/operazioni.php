<?php 
    require_once 'auth.php';
    if (!$id = checkAuth()) exit;
    header('Content-type: application/json');

    $conn = mysqli_connect($dbconfig['host'],$dbconfig['user'],$dbconfig['password'],$dbconfig['name']) or die(mysqli_error($conn));
    if(!isset( $_GET['op'])) exit;
    $operazione = $_GET['op'];
    

    if($operazione=='1') {
        $query = "CALL OP1_2($id,@id1_2,@specializzazione1_2,@numero_corsi1_2);";
        $res = mysqli_query($conn,$query) or die(mysqli_error($conn));
        if ($res) {
            $query = "SELECT @id1_2 as id_istruttore ,@specializzazione1_2 as specializzazione_istruttore,@numero_corsi1_2 as numero_corsi_istruttore;";
            $res = mysqli_query($conn,$query) or die(mysqli_error($conn));
            $postArray = array();
            while($row = mysqli_fetch_assoc($res))
                $postArray[]=$row;
            echo json_encode($postArray);
            mysqli_free_result($res);
        }
    }

    if($operazione=='2') {
        if(!isset($_GET['id_sede'])) exit;
        $sede = $_GET['id_sede'];
        $query = "CALL OP2_2($id,$sede)";
        $res = mysqli_query($conn,$query) or die(mysqli_error($conn));
        $postArray = array();
        while($row = mysqli_fetch_assoc($res))
            $postArray[]=$row;
        echo json_encode($postArray);
        mysqli_free_result($res);
    }

    if($operazione=='3') {
        
        if(!isset($_GET['id_corso']) || !isset($_GET['nome_corso']) || !isset($_GET['prezzo_corso']) || 
        !isset($_GET['iscritti_corso']) || !isset($_GET['eta_corso']) || !isset($_GET['istruttore_corso'])) exit;

        $id_corso = $_GET['id_corso'];
        $nome = mysqli_real_escape_string($conn,$_GET['nome_corso']);
        $prezzo = $_GET['prezzo_corso'];
        $iscritti = $_GET['iscritti_corso'];
        $eta = mysqli_real_escape_string($conn,$_GET['eta_corso']);
        $istruttore = $_GET['istruttore_corso'];
        
        $query = "CALL OP3_2($id,$id_corso,\"$nome\",$prezzo,$iscritti,\"$eta\",$istruttore)";
        

        $res = mysqli_query($conn,$query) or die(mysqli_error($conn));
        echo json_encode($res);
       
      
    }

    if($operazione=='4') {
        $query = "CALL OP4_2($id,@ID4_2,@NomeIscritto4_2,@CognomeIscritto4_2,@ncorsi4_2);";
        $res = mysqli_query($conn,$query) or die(mysqli_error($conn));
        if ($res) {
            $query = "SELECT @ID4_2 as id_iscritto,@NomeIscritto4_2 as nome_iscritto,@CognomeIscritto4_2 as cognome_iscritto,@ncorsi4_2 as numero_corsi_iscritto;";
            $res = mysqli_query($conn,$query) or die(mysqli_error($conn));
            $postArray = array();
            while($row = mysqli_fetch_assoc($res))
                $postArray[]=$row;
            echo json_encode($postArray);
            mysqli_free_result($res);
        }
    }

    //
    mysqli_close($conn);

?>