
function checkCodiceFiscale(event) {
    const input = document.querySelector('#cf input');
    if(formStatus.codice = input.value.length  == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci il codice fiscale";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    } 
}

function checkPassword(event) {
    const input = document.querySelector('#password input');
    if (formStatus.password = input.value.length  == 0 ) {
        input.parentNode.querySelector('span').textContent = "Inserisci la password";
        input.classList.remove('true');
        input.classList.add('false');
    } else {
        input.parentNode.querySelector('span').textContent = "";
        input.classList.add('true');
    }
}

const formStatus = {'upload': true};
document.querySelector('#cf input').addEventListener('blur', checkCodiceFiscale);
document.querySelector('#password input').addEventListener('blur', checkPassword);