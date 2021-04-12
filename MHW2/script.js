
const section = document.querySelector('#section_corsi');
const divcorsi = document.createElement('div');
divcorsi.classList.add('corsi');
section.appendChild(divcorsi);

for (var i = 0; i < contenuti.length; i++) {
    const divcorso = document.createElement('div');
    divcorso.id = ('corso' + i);
    divcorsi.appendChild(divcorso);
    const span = document.createElement('span');
    span.classList.add('row');
    divcorso.appendChild(span);
    const titolo = document.createElement('h3');
    titolo.textContent = contenuti[i].titolo;
    span.appendChild(titolo);
    const button = document.createElement('span');
    button.classList.add('button');
    button.textContent = "Aggiungi ai preferiti";
    button.addEventListener('click', onFavorites);
    span.appendChild(button);
    const img = document.createElement('img');
    img.src = contenuti[i].immagine;
    divcorso.appendChild(img);
    const dettagli = document.createElement('p');
    dettagli.classList.add('hidden');
    dettagli.classList.add('inf');
    dettagli.textContent = contenuti[i].dettagli;
    divcorso.appendChild(dettagli);
    const info = document.createElement('p');
    info.classList.add('underline');
    info.textContent = "Clicca per più informazioni";
    info.addEventListener('click', apriInfo);
    divcorso.appendChild(info);
}

function keyUp() {
    for (var i = 0; i < courses.length; i++) {
        const s = courses[i].querySelector('span h3').textContent;
        if (s.toLowerCase().indexOf(input.value.toLowerCase()) !== -1) {
            courses[i].classList.remove('hidden');
        }
        else {
            courses[i].classList.add('hidden');
        }
    }
}

const input = document.querySelector('input');
input.addEventListener('keyup', keyUp);
const courses = document.querySelectorAll('.corsi div');


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
