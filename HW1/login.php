<?php
   
   include 'auth.php';
    
    if(checkAuth()){
        header('Location: home_riservata.php');
        exit;
    }

    if (!empty($_POST["codice"]) && !empty($_POST["password"])) {
        
        $conn = mysqli_connect($dbconfig['host'], $dbconfig['user'], $dbconfig['password'], $dbconfig['name']) or die(mysqli_error($conn));
    


        $codice_fiscale = mysqli_real_escape_string($conn, $_POST["codice"]);
        $password = mysqli_real_escape_string($conn, $_POST["password"]);
        $query= "SELECT I.*, IF (S.ID_impiegato IS NULL, false, true) as isSegretario , IF (INS.ID_impiegato IS NULL, false, true) as isIstruttore , IF (A.ID_impiegato IS NULL, false, true) as isAddetto
        FROM IMPIEGATO I
        LEFT JOIN SEGRETARIO S ON I.ID_impiegato=S.ID_impiegato
        LEFT JOIN ISTRUTTORE INS ON I.ID_impiegato=INS.ID_impiegato
        LEFT JOIN ADETTO_PULIZIE A ON I.ID_impiegato=A.ID_impiegato
        WHERE I.C_F = '$codice_fiscale' ";
        $res = mysqli_query($conn, $query) or die(mysqli_error($conn));
        if(mysqli_num_rows($res) > 0) {
            $entry = mysqli_fetch_assoc($res);
            if(password_verify($_POST['password'], $entry['Pass'])) {
                if(isset($_POST['remember'])) {
                    $expires = strtotime("+7 day");
                    $cookie = (object) array( "ID_impiegato" => $entry['ID_impiegato'],"C_F"=> $entry['C_F'], "expires" => $expires, "hash" => hash('sha256',$entry['C_F']));
                    setcookie('_web_ID', json_encode( $cookie), $expires); 
                }
                $_SESSION["_web_ID"] = $entry["ID_impiegato"];
                $_SESSION["_C_F"] = $entry['C_F'];
                
                $location = "home_riservata.php?segretario=";
                $location.= ($entry['isSegretario']) ? "true" : "false";
                $location.="&istruttore=";
                $location.=($entry['isIstruttore']) ? "true" : "false"; 
                $location.="&addetto=";
                $location.=($entry['isAddetto']) ? "true" : "false"; 
                
                //header("Location: home_riservata.php");
                header("Location: ".$location);
                mysqli_close($conn);
                exit;
            }

        }
        $show = "Codice fiscale e/o password errati.";

    }else if (isset($_POST["codice"]) || isset($_POST["password"])) {
        $show = "Inserisci codice fiscale e password.";
    }
?>


<DOCTYPE html>
<hmtl lang = "en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RUMORE|gym - Accedi</title>
    <link rel="stylesheet" href="style/signup_login.css">
    <script src="js/login.js" defer></script>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand&display=swap" rel="stylesheet">
</head>

<body>
    <main>
        <section class="main_left">
            <h1>Accedi</h1>
            <form action="" method="POST">

                <div class="label" id="cf">
                    <input type="text" placeholder="Codice Fiscale" name="codice" <?php if(isset($_POST["codice"])){echo "value=".$_POST["codice"];} ?> >
                    <span><span>
                </div>

                <div class="label" id="password">
                    <input type="password" placeholder="Password" name="password" <?php if(isset($_POST["email"])){echo "value=".$_POST["email"];} ?> >
                    <span></span>
                </div>

                <div class="accesso">
                <?php 
                if(isset($show))
                    echo "<span class=\"error\">$show</span>"
                ?>
                <label><input type="checkbox" name="remember">Rimani connesso</label>
                </div>

                <input type="submit" value="Accedi" id="submit">

            </form>
            <span>Non sei ancora registrato? <a href="signup.php">Registrati</a></span>
        </section>
        <section class="main_right">
            <a href="home.php">RUMORE|gym</a>
        </section>
    </main>
</body>
</html>



