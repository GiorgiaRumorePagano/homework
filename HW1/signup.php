<?php


    require_once 'auth.php';

    if (checkAuth()) {
        header("Location: registrazione_ok.php");
        exit;
    } 
    
    if (!empty($_POST["codice"]) && !empty($_POST["nome"]) && !empty($_POST["cognome"]) && !empty($_POST["data_nascita"]) && 
        !empty($_POST["email"]) && !empty($_POST["password"]) && !empty($_POST["conferma"]) && !empty($_POST["indirizzo"])  && !empty($_POST["citta"]) && 
        !empty($_POST["telefono"])) {

            
            $error = array();
            $conn = mysqli_connect($dbconfig['host'], $dbconfig['user'], $dbconfig['password'], $dbconfig['name']) or die(mysqli_error($conn));
            
            $codice_fiscale = mysqli_real_escape_string($conn, $_POST['codice']);
            $query = "SELECT C_F FROM IMPIEGATO WHERE C_F = '$codice_fiscale'";
            $res = mysqli_query($conn, $query);

            if(mysqli_num_rows($res) >0 ) {
                $error[] = "Codice fiscale già registrato";
            }

            if (!preg_match('/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,15}$/', $_POST['password'])) {
                $error[] = "La password deve contenere un carattere minuscolo, uno maiuscolo, un numero, un carattere speciale (!@#$^&*) e deve essere formata da 8-15 caratteri";
            }
            
            if (strcmp($_POST["password"], $_POST["conferma"]) != 0) {
                $error[] = "Le password non coincidono";
            }

            $posta = mysqli_real_escape_string($conn, $_POST['email']);
            $query = "SELECT Posta_elettronica FROM IMPIEGATO WHERE Posta_elettronica = '$posta'";
            $res = mysqli_query($conn, $query);

            if(mysqli_num_rows($res) >0 ) {
                $error[] = "Email già registrata";
            }

            if(!isset($_POST['segretario']) && !isset($_POST['istruttore']) && !isset($_POST['addetto_pulizie'])) {
                $error[] = "Selezionare almeno un ruolo";
            }

            if (count($error) == 0){
                $nome = mysqli_real_escape_string($conn, $_POST['nome']);
                $cognome = mysqli_real_escape_string($conn, $_POST['cognome']);
                $data_nascita = mysqli_real_escape_string($conn, $_POST['data_nascita']);
                $password = mysqli_real_escape_string($conn, $_POST['password']);
                $password = password_hash($password, PASSWORD_BCRYPT);
                $indirizzo = mysqli_real_escape_string($conn, $_POST['indirizzo']);
                $citta = mysqli_real_escape_string($conn, $_POST['citta']);
                $telefono = mysqli_real_escape_string($conn, $_POST['telefono']);
                
                


                if(str_contains($data_nascita, "/"))
                    $data_nascita = str_replace('/', '-', $data_nascita);
                if(str_contains($data_nascita, "."))
                    $data_nascita = str_replace('.', '-', $data_nascita);
                $data = new DateTime($data_nascita);
                $data = $data->format('Y-m-d');

                $query = "INSERT INTO IMPIEGATO(C_F, Nome, Cognome, Data_nascita, Indirizzo, Citta, Posta_elettronica, Telefono, Pass) 
                VALUES('$codice_fiscale','$nome','$cognome','$data','$indirizzo','$citta','$posta','$telefono','$password')";
    
                if(mysqli_query($conn, $query) or die(mysqli_error($conn))) {  
                    $id = mysqli_insert_id($conn);
                    $query1="";
                    if(isset($_POST['segretario'])){
                        $query1.= "INSERT INTO SEGRETARIO(ID_impiegato) VALUES ('$id');";
                    }
                    if(isset($_POST['istruttore'])){
                        $query1.= "INSERT INTO ISTRUTTORE(ID_impiegato) VALUES ('$id');";
                    }
                    if(isset($_POST['addetto_pulizie'])){
                        $query1.= "INSERT INTO ADETTO_PULIZIE(ID_impiegato) VALUES ('$id');";
                    }
                    mysqli_query($conn, $query1) or die(mysqli_error($conn));
                    $_SESSION["_web_cf"] = $_POST["codice"];
                    $_SESSION["_web_id"] = mysqli_insert_id($conn);
                    mysqli_close($conn); 
                    header("Location: registrazione_ok.php");
                }
            }
    }
?>

<DOCTYPE html>
<hmtl lang = "en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RUMORE|gym - Iscriviti</title>
    <link rel="stylesheet" href="style/signup_login.css">
    <script src="js/signup.js" defer></script>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand&display=swap" rel="stylesheet">
</head>

<body>
    <main>
        <section class="main_left">
            <h1>Registrati</h1>
            <form action="" method="POST">
                <div class="label" id="cf">
                    <input type="text" placeholder="Codice Fiscale" name="codice">
                    <span><span>
                </div>
                <div class="label" id="nome">
                    <input type="text" placeholder="Nome" name="nome">
                    <span></span>
                </div>
                <div class="label" id="cognome">
                    <input type="text"placeholder="Cognome" name="cognome">
                    <span></span>
                </div>
                <div class="label" id="data_nascita">
                    <input type="text"placeholder="Data di Nascita (gg-mm-aaaa)" name="data_nascita" >
                    <span><span>
                </div>
                <div class="label" id="email">
                    <input type="text" placeholder="Email" name="email">
                    <span></span>
                </div>
                <div class="label" id="password">
                    <input type="password" placeholder="Password" name="password">
                    <span>8-15 caratteri: A, a , numero , (!@#$^&*) </span>
                </div>
                <div class="label" id="conferma">
                    <input type="password" placeholder="Conferma password" name="conferma">
                    <span></span>
                </div>
                <div class="label" id="indirizzo">
                    <input type="text" placeholder="Indirizzo" name="indirizzo">
                    <span></span>
                </div>
                <div class="label" id="citta">
                    <input type="text" placeholder="Città" name="citta">
                    <span></span>
                </div>
                <div class="label" id="telefono">
                    <input type="text" placeholder="Telefono" name="telefono">
                    <span></span>
                </div>
                <div class="label" id="tipo">
                    <p>
                        <input id="s" type='checkbox'  name='segretario' > Segretario
                        <input id="i" type='checkbox'  name='istruttore' > Istruttore
                        <input id="a" type='checkbox'  name='addetto_pulizie' > Adetto Pulizie
                    </p>
                    <span></span>
                </div>
                <div>
                    <input type="submit" value="Registrati" id="submit">
                </div>
            </form>
            <span>Sei già registrato? <a href="login.php">Accedi</a></span>
        </section>
        <section class="main_right">
            <a href="home.php">RUMORE|gym</a>
        </section>
    </main>
</body>
</html>



