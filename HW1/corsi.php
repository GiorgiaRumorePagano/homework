

<!DOCTYPE html>
<html>
    
<head>
    <meta charset="utf-8">
    <title>Corsi - Rumore Gym</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="style/corsi.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@200&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
    <script src="js/script.js" defer></script>
</head>

<body>
    <header>
        <div id="overlay"></div>
        <nav>
            <div id="logo">
                RUMORE|gym
            </div>
            <div id="menu">
                <a href="home.php">Home</a>
                <a href="sedi.php">Sedi</a>  
                <a href="corsi.php">Corsi</a> 
                <a href="trainer.php">Trainers</a>
                <a href="login.php">Area Riservata</a>
            </div>
            <div id="ham">
                <div></div>
                <div></div>
                <div></div>
            </div>
        </nav>
        <h1>
            Attività sportive
        </h1>
    </header>
    <section class="all_preferiti hidden"> </section>
    <section id="section_corsi">
        <div id="cerca">
            <h1>Conosci tutti i nostri corsi</h1>
            <h3>Cerca <input type="text" id="ricerca" /></h3>
        </div>
    </section>

    <section id = 'api_1'>
        <h1> Campioni del calcio si affidano a noi </h1>
        <h3>A partire da Cristiano Ronaldo, Danny Welbeck, Diego Milito, Zlatan Ibrahimovic e tanti altri...</h3>
        <h4>Cercali per avere più informazioni su di loro</h4>
        <form>

            <input type = 'text' id='player'>
            <input type = 'submit' id='submit1' value='cerca'>
        </form>
    </section>


    <section id="risultati1">
    </section>

    <section id = 'api_2'>
        <h1>Musica stimolante ad ogni corso per un ottimo workout</h1>
        <h3>I nostri album preferit sono: This Is Acting, Il ballo della vita, Fuori dall'hype Ringo Starr e tanti altri</h3>
        <h4>Cercali e scopri le tracce</h4>
        <form>
            <input type = 'text' id='album'>
            <input type = 'submit' id='submit2' value='cerca'>
        </form>
    </section>

    <section id="risultati2">
    </section>




    <footer>
        <div id="footer1">
            <a id="logofooter" href="home.php">RUMORE|gym <p> Via Dafnica 206B - 0957633393 </p></a>
            <div id="socialfooter"> Seguici su:
                <div id="img-social">
                    <a> <img src="https://cdn.icon-icons.com/icons2/2201/PNG/512/instagram_ig_logo_icon_134013.png">
                    </a>
                    <a> <img src="https://almm.it/wp-content/uploads/2019/01/logo-facebook.png"> </a>
                </div>
            </div>
            <div id="footer-work">
                <h6>Vuoi lavorare con noi? </h6>
                <a> Clicca qui </a>
            </div>
            <div id="area-riservata">
                <a href="login.php"> Area Riservata</a>
            </div>
        </div>
        &#169 Giorgia Rumore Pagano | O46002229
    </footer>

</body>

</html>