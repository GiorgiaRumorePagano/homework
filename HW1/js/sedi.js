
//CARICAMENTO SEZIONE SEDI DA DATABASE

fetch("fetch_sedi.php").then(onResponse).then(fetchSediJson);

const section = document.querySelector('#section_sedi');
const divsedi = document.createElement('div');
divsedi.classList.add('sedi');
section.appendChild(divsedi);

function fetchSediJson(json) { 
    for (content of json) {
        const divsede = document.createElement('div');
        divsede.classList.add('single_sede');
        divsedi.appendChild(divsede);
        const span = document.createElement('span');
        span.classList.add('row');
        divsede.appendChild(span);
        const titolo = document.createElement('h3');
        titolo.textContent = content.Citta;
        span.appendChild(titolo);
        const img = document.createElement('img');
        img.src = "img/sedi/" + content.ID_sede + ".jpeg";
        divsede.appendChild(img);
        const dettagli = document.createElement('p');
        dettagli.classList.add('hidden');
        dettagli.classList.add('inf');
        dettagli.textContent = "La sede di \n" + content.Citta + "\n si trova in \n" + content.Indirizzo;
        divsede.appendChild(dettagli);
        const info = document.createElement('p');
        info.classList.add('underline');
        info.textContent = "Clicca per più informazioni";
        info.addEventListener('click', apriInfo);
        divsede.appendChild(info);
    }

   


}

function onResponse (response) {
    return response.json();
}

//RICERCA DELLE SEDI
const input = document.querySelector('#ricerca');
input.addEventListener('keyup', keyUp);


function keyUp() {
    const sedi = document.querySelectorAll('.sedi div');
    for (let i = 0; i < sedi.length; i++) {
        const s = sedi[i].querySelector('span h3').textContent;
        if (s.toLowerCase().indexOf(input.value.toLowerCase()) !== -1) {
            sedi[i].classList.remove('hidden');
        }
        else {
            sedi[i].classList.add('hidden');
        }
    }
}


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
