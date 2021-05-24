<!DOCTYPE html>
<html>
    
<head>
    <meta charset="utf-8">
    <title>Area Riservata-Rumore Gym</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="style/home_riservata.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@200&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
    <script src="js/home_riservata.js" defer></script>
</head>

<body>

    <header>
        <div id="overlay"></div>
        <nav>
            <div id="logo">
                RUMORE|gym
            </div>
                 
            <div id="menu">
                <a href="logout.php">Esci</a>
            </div>
            <div id="ham">
                <div></div>
                <div></div>
                <div></div>
            </div>
        </nav>
        <h1>
            Benvenuto
        </h1>
    </header>

    <section id="ricerca">
        <h1>Informazioni iscritti</h1>
        <input type="text" placeholder="Cerca iscritto" id="cerca"> 
        <div id="risultati"> </div>
    </section>

    <section id="op">
        <h1>Cosa vuoi fare?</h1>
        <div id="operazione-1" class="hidden segretario operazioni"> 
            <h3>&#149 OPERAZIONE 1: Mostra l'ID, la specializzazione e il numero di corsi dell'istruttore che ne insegna di più </h3>
            <span class="hidden"></span>
        </div>

        <div id="operazione-2" class="hidden segretario operazioni"> 
            <h3>&#149 OPERAZIONE 2: Mostra tutti gli impiegati con lo stesso nome che lavorano o che hanno lavorato in una determinata sede</h3>
            <form class="hidden">
                <input type="text" placeholder="Inserisci l'id della sede" name="id_sede"> 
                <button> Vai </button>
            </form>
            <span></span>
        </div>

        <div id="operazione-3" class="hidden segretario operazioni"> 
            <h3>&#149 OPERAZIONE 3: Inserisci un nuovo corso di funzionale: se il corso ha meno di 20 iscritti verrà inserito nella sede di Roma altrimenti in quella di Milano. </h3>
            <form class="hidden">
                <input type="text" placeholder="ID del corso"  id="id_corso" disabled>
                <input type="text" placeholder="Nome del corso"  id="nome_corso"> 
                <input type="text" placeholder="Prezzo"  id="prezzo_corso"> 
                <input type="text" placeholder="Numero massimo di iscritti"  id="iscritti_corso"> 
                <input type="text" placeholder="Fascia d'età"  id="eta_corso"> 
                <select name="istruttore" id=#istruttore_corso>
                    <option>Istruttore</option>
                </select> 
                <button> Vai </button>
                <span class="hidden">Inserimento effettuato correttamente!</span>
            </form>
        </div>

        <div id="operazione-4" class="hidden istruttore segretario addetto operazioni">
            <h3>&#149 OPERAZIONE 4: Visualizza l'iscritto minorenne iscritto a più corsi </h3>
            <span class="hidden"></span>
        </div>
    </section>
    <footer>
        <div id="footer1">
            <div id="logofooter">RUMORE|gym</div>
            <div id="socialfooter"> Seguici su:
                <div id="img-social">
                    <a> <img src="https://cdn.icon-icons.com/icons2/2201/PNG/512/instagram_ig_logo_icon_134013.png">
                    </a>
                    <a> <img src="https://almm.it/wp-content/uploads/2019/01/logo-facebook.png"> </a>
                </div>
            </div>
            <div id="exit">
                <a href="logout.php">Esci</a>
            </div>
        </div>
        &#169 Giorgia Rumore Pagano | O46002229
    </footer>
</html>