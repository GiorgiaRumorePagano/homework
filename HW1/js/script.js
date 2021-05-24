
//CARICAMENTO SEZIONE CORSI DA DATABASE

fetch("fetch_course.php").then(onResponse).then(fetchCoursesJson);

const section = document.querySelector('#section_corsi');
const divcorsi = document.createElement('div');
divcorsi.classList.add('corsi');
section.appendChild(divcorsi);

function fetchCoursesJson(json) { 
    for (content of json) {
        const divcorso = document.createElement('div');
        divcorso.classList.add('single_course');
        divcorsi.appendChild(divcorso);
        const span = document.createElement('span');
        span.classList.add('row');
        divcorso.appendChild(span);
        const titolo = document.createElement('h3');
        titolo.textContent = content.Nome_corso;
        span.appendChild(titolo);
        const button = document.createElement('span');
        button.classList.add('button');
        button.textContent = "Aggiungi ai preferiti";
        button.addEventListener('click', onFavorites);
        span.appendChild(button);
        const img = document.createElement('img');
        img.src = "img/courses/" + content.ID_corso + ".jpeg";
        divcorso.appendChild(img);
        const dettagli = document.createElement('p');
        dettagli.classList.add('hidden');
        dettagli.classList.add('inf');
        dettagli.textContent = "Il corso è riservato alle persone comprese nella fascia d'età \n" + content.Fascia_eta;
        divcorso.appendChild(dettagli);
        const info = document.createElement('p');
        info.classList.add('underline');
        info.textContent = "Clicca per più informazioni";
        info.addEventListener('click', apriInfo);
        divcorso.appendChild(info);
    }

   


}

//RICERCA DEI CORSI
const input = document.querySelector('#ricerca');
input.addEventListener('keyup', keyUp);


function keyUp() {
    const courses = document.querySelectorAll('.corsi div');
    for (let i = 0; i < courses.length; i++) {
        const s = courses[i].querySelector('span h3').textContent;
        if (s.toLowerCase().indexOf(input.value.toLowerCase()) !== -1) {
            courses[i].classList.remove('hidden');
        }
        else {
            courses[i].classList.add('hidden');
        }
        
    }
}



//VISUALIZZAZIONE DI PIU' DETTAGLI PER OGNI CORSO
function apriInfo(event) {
    const informazioni = event.currentTarget;
    informazioni.removeEventListener('click', apriInfo);

    const dettagli = informazioni.parentNode.querySelector('.hidden');
    dettagli.classList.remove('hidden');

    informazioni.textContent = "Mostra meno dettagli";
    informazioni.addEventListener('click', chiudiInfo);
}

function chiudiInfo(event) {
    const informazioni = event.currentTarget;
    informazioni.removeEventListener('click', chiudiInfo);

    const dettagli = informazioni.parentNode.querySelector('.inf');
    dettagli.classList.add('hidden');

    informazioni.textContent = "Clicca per più informazioni";
    informazioni.addEventListener('click', apriInfo);
}


//GESTIONE DEI PREFERITI
const section_preferiti = document.querySelector('.all_preferiti');
const h1 = document.createElement('h1');
h1.textContent = "Preferiti:";
section_preferiti.appendChild(h1);

const divcorsi_preferiti = document.createElement('div');
divcorsi_preferiti.classList.add('corsi_preferiti');
section_preferiti.appendChild(divcorsi_preferiti);

function onFavorites(event) {

    const button = event.currentTarget;
    button.textContent = "Rimuovi dai preferiti";
    button.removeEventListener('click', onFavorites);
    button.addEventListener('click', deleteFavorites);


    const divcorso_preferiti = document.createElement('div');
    divcorso_preferiti.classList.add("items");
    divcorso_preferiti.id = button.parentNode.parentNode.id;
    if (divcorsi_preferiti.childNodes.length === 0) {
        section_preferiti.classList.remove('hidden');
    }
    divcorsi_preferiti.appendChild(divcorso_preferiti);


    const span_preferiti = document.createElement('span');
    span_preferiti.classList.add('row_preferiti');
    divcorso_preferiti.appendChild(span_preferiti);
    const titolo_preferiti = document.createElement('h3');
    titolo_preferiti.textContent = button.parentNode.querySelector('h3').textContent;
    span_preferiti.appendChild(titolo_preferiti);
    const button_preferiti = document.createElement('span');
    button_preferiti.classList.add('button');
    button_preferiti.textContent = "Rimuovi dai preferiti";
    button_preferiti.addEventListener('click', removeToFavorites);
    span_preferiti.appendChild(button_preferiti);
    const img_preferiti = document.createElement('img');
    img_preferiti.src = button.parentNode.parentNode.querySelector('img').src;
    divcorso_preferiti.appendChild(span_preferiti);
    divcorso_preferiti.appendChild(img_preferiti);
}

function removeToFavorites(event) {
    const new_button = event.currentTarget;

    const preferiti = new_button.parentNode.parentNode;
    preferiti.remove();
    const divcorsi_preferiti = document.querySelector('.corsi_preferiti');
    if (divcorsi_preferiti.childNodes.length === 0) {
        section_preferiti.classList.add('hidden');
    }

    const items = document.querySelectorAll(".corsi div");
    for (const item of items) {
        if (preferiti.id === item.id) {
            const button = item.querySelector('span span');
            button.textContent = "Aggiungi ai preferiti";
            button.addEventListener('click', onFavorites);
            button.removeEventListener('click', deleteFavorites);
        }

    }

}

function deleteFavorites(event) {
    const button = event.currentTarget;
    const preferiti = button.parentNode.parentNode;

    const items = document.querySelectorAll(".all_preferiti div");
    for (const item of items) {
        if (preferiti.id === item.id) {
            item.remove();
            button.textContent = "Aggiungi ai preferiti";
            button.addEventListener('click', onFavorites);
            button.removeEventListener('click', deleteFavorites);
        }
    }

    const divcorsi_preferiti = document.querySelector('.corsi_preferiti');
    if (divcorsi_preferiti.childNodes.length === 0) {
        section_preferiti.classList.add('hidden');
    }

}

//API1---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function onJson (json) {

    const risultati = document.querySelector('#risultati1');
    risultati.innerHTML= ''; //se ci sono risultati della vecchia query li cancello

    const doc = json;
    console.log(doc);
    const description = doc.player[0].strDescriptionIT;

    //Creo la descrizione
    const descrizione = document.createElement('p');
    descrizione.textContent = description;

    //Aggiugno la descrizione alla sezione risultati
    risultati.appendChild(descrizione);
}


function onResponse (response) {
    return response.json();
}

function search (event) {
    event.preventDefault(); //per impedire il comportamento del form attraverso il bottone
    
    //Prendo il valore del campo di testo
    const player_input = document.querySelector('#player'); 
    const player_value = encodeURIComponent(player_input.value);

    //Mi preparo la richiesta
    rest_url = 'https://www.thesportsdb.com/api/v1/json/1/searchplayers.php?p=' + player_value;

    //Effetuo la richiesta
    fetch(rest_url).then(onResponse).then(onJson);
}

//Aggiungo l'EventListener per il form (api_1)
const form = document.querySelector('#api_1 form');
form.addEventListener('submit', search); 


//API2-SPOTIFY---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function onJsonTracks(json) {
    const risultati = document.querySelector('#risultati2');
    risultati.innerHTML= ''; //se ci sono risultati della vecchia query li cancello
    for(track of json.albums[0].tracks.items) {
    const p = document.createElement('p');
    p.textContent = track.name;
    risultati.appendChild(p);
    }
}


function onJsonAlbums (json) {
    console.log(json);
    fetch('https://api.spotify.com/v1/albums?ids=' + json.albums.items[0].id, {
        headers: 
        {
            'Authorization': 'Bearer ' + token
        }
    }).then(onResponse).then(onJsonTracks);
}

function search_2 (event){
    event.preventDefault();

    const album_input = document.querySelector('#album');
    const album_value = encodeURIComponent(album_input.value);

    //Eseguo richiesta asincrona alle REST API di Spotify
    fetch("https://api.spotify.com/v1/search?type=album&q=" + album_value, 
    {
        headers:
        {
            'Authorization' : 'Bearer ' + token
        }

    }).then(onResponse).then(onJsonAlbums);
}


function onTokenJson(json) {
    token = json.access_token;
    console.log(token);

}

function onTokenResponse(response) {
    return response.json();
}


let token;



fetch("api2.php").then(onTokenResponse).then(onTokenJson);

const form2 = document.querySelector('#api_2 form');
form2.addEventListener('submit', search_2); 
