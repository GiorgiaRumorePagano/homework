<?php
    require_once 'dbconfig.php'; 
    session_start();
    function checkAuth() {
        if(isset($_COOKIE["_web_ID"])){
            $cookie = json_decode($_COOKIE['_web_ID'], true);
                
            if(hash('sha256',$entry["C_F"])==$cookie["hash"]){
                $_SESSION["_web_ID"] = $cookie["ID_impiegato"];
                $_SESSION["_C_F"] = $cookie["_CF"];
                return $_SESSION["_web_ID"];
            }
        }
        return isset($_SESSION['_web_ID']) ? $_SESSION['_web_ID'] : 0;
    }
?>