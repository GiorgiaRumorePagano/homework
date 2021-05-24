function fetchResponse(response) {
    if (!response.ok) return null;
    return response.json();
}

function jsonCheckCodiceFiscale(json) {
    // Controllo il campo exists ritornato dal JSON

    if (formStatus.codice = !json.exists) {
        document.querySelector('#cf input').classList.remove('false');
    } else {
        document.querySelector('#cf span').textContent = "Codice Fiscale già registrato";
        document.querySelector('#cf input').classList.remove('true');
        document.querySelector('#cf input').classList.add('false');
    }
}

function jsonCheckEmail(json) {
    // Controllo il campo exists ritornato dal JSON

    if (formStatus.email = !json.exists) {
        document.querySelector('#email input').classList.remove('false');
    } else {
        document.querySelector('#email span').textContent = "Email già registrata";
        document.querySelector('#email input').classList.remove('true');
        document.querySelector('#email input').classList.add('false');
    }
}


function checkCodiceFiscale(event) {
    const input = document.querySelector('#cf input');
    if(formStatus.codice = input.value.length != 16 ) {
        input.parentNode.querySelector('span').textContent = "Devi inserire 16 caratteri!";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
        fetch("check_cf.php?q="+encodeURIComponent(input.value)).then(fetchResponse).then(jsonCheckCodiceFiscale);
    } 
}

function checkNome(event) {
    const input= document.querySelector('#nome input');
    if(formStatus.nome = input.value.length == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci il tuo nome";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkCognome(event) {
    const input= document.querySelector('#cognome input');
    if(formStatus.cognome = input.value.length == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci il tuo cognome";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkDataNascita(event) {
    const input= document.querySelector('#data_nascita input');
    if(!/^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/.test(input.value)) {
        input.parentNode.querySelector('span').textContent = "Data di nascita non valida!";
        input.classList.remove('true');
        input.classList.add('false');

        
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkEMail(event) {
    const input = document.querySelector('#email input');
    if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(String(input.value).toLowerCase())) {
        input.parentNode.querySelector('span').textContent = "Email non valida!";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
        fetch("check_email.php?q="+encodeURIComponent(input.value)).then(fetchResponse).then(jsonCheckEmail);
        }
    } 

function checkPassword(event) {
    const input = document.querySelector('#password input');
    if (!/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,15}$/.test(input.value)) {
        input.parentNode.querySelector('span').textContent = "Formato password errato!";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    }
}
    
function checkConferma(event) {
    const input = document.querySelector('#conferma input');
    if (formStatus.conferma = input.value != document.querySelector('#password input').value) {
        input.parentNode.querySelector('span').textContent = "Le password non coincidono";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    }
}

function checkIndirizzo(event) {
    const input= document.querySelector('#indirizzo input');
    if(formStatus.indirizzo = input.value.length == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci il tuo indirizzo";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkCitta(event) {
    const input= document.querySelector('#citta input');
    if(formStatus.citta = input.value.length == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci la tua citta'";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkTelefono(event) {
    const input= document.querySelector('#telefono input');
    if(formStatus.telefono = input.value.length == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci il tuo numero di telefono'";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkTipo(event) {
    const segretario = document.querySelector('#tipo p #s');
    const istruttore = document.querySelector('#tipo p #i');
    const addetto = document.querySelector('#tipo p #a');
    const input = document.querySelector('#tipo p');

    if(!segretario.checked && !istruttore.checked && !addetto.checked) {
        input.parentNode.querySelector('span').textContent = "Seleziona il tuo ruolo";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}


const formStatus = {'upload': true};
document.querySelector('#cf input').addEventListener('blur', checkCodiceFiscale);
document.querySelector('#nome input').addEventListener('blur', checkNome);
document.querySelector('#cognome input').addEventListener('blur', checkCognome);
document.querySelector('#data_nascita input').addEventListener('blur', checkDataNascita);
document.querySelector('#email input').addEventListener('blur', checkEMail);
document.querySelector('#password input').addEventListener('blur', checkPassword);
document.querySelector('#conferma input').addEventListener('blur', checkConferma);
document.querySelector('#indirizzo input').addEventListener('blur', checkIndirizzo);
document.querySelector('#citta input').addEventListener('blur', checkCitta);
document.querySelector('#telefono input').addEventListener('blur', checkTelefono);
document.querySelector('#tipo input').addEventListener('blur', checkTipo);

