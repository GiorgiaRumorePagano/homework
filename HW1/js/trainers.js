
//CARICAMENTO SEZIONE TRAINERS DA DATABASE

fetch("fetch_trainers.php").then(onResponse).then(fetchSediJson);

const section = document.querySelector('#section_trainers');
const divtrainers = document.createElement('div');
divtrainers.classList.add('trainers');
section.appendChild(divtrainers);

function fetchSediJson(json) { 
    for (content of json) {
        const divtrainer = document.createElement('div');
        divtrainer.classList.add('single_trainer');
        divtrainers.appendChild(divtrainer);
        const span = document.createElement('span');
        span.classList.add('row');
        divtrainer.appendChild(span);
        const titolo = document.createElement('h3');
        titolo.textContent = content.Nome + "\n" + content.Cognome;
        span.appendChild(titolo);
        const img = document.createElement('img');
        img.src = "img/trainers/" + content.ID_impiegato + ".jpeg";
        divtrainer.appendChild(img);
        const dettagli = document.createElement('p');
        dettagli.classList.add('hidden');
        dettagli.classList.add('inf');
        dettagli.textContent = "Specializzazione: \n" + content.Specializzazione;
        divtrainer.appendChild(dettagli);
        const info = document.createElement('p');
        info.classList.add('underline');
        info.textContent = "Clicca per più informazioni";
        info.addEventListener('click', apriInfo);
        divtrainer.appendChild(info);
    }

   


}

function onResponse (response) {
    return response.json();
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
