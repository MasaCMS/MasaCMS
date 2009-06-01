var keysPressed = 0;
//capture when a user uses types on their keyboard
document.onkeypress = logKeys;

function logKeys() {
	//user hit a key, increment the counter
	keysPressed++;
	//load the amount to hidden form field
	document.getElementById("formfield1234567892").value = keysPressed;
}