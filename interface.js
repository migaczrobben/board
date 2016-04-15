///// Change styles on file load /////
// Define objects to change styles
var open_buttons = document.querySelectorAll(".open");
var response_areas = document.querySelectorAll(".text_response");
var submit_buttons = document.querySelectorAll(".submit_response_button");

// Change display status of elements
var void_style = function(objects, display) {
	for (var loop = 0; loop < objects.length; loop++) {
	
		// Change display
		if (display == 1) {
			objects[loop].style.display = "block";
		}
		else {
			objects[loop].style.display = "none";
		}
		
	}
}

// Pass objects to function, modifying display
void_style(open_buttons, 1);
void_style(response_areas, 0);
void_style(submit_buttons, 0);

///// Click events (experimental) /////
var void_modify = function(close, text, pass) {
	close.style.display = "none";
	text.style.display = "block";
	pass.style.display = "block";
	pass.style.margin = "20px 0 0 0";
}

var void_click = function(id) {
	console.log(id);
	var to_close = document.getElementById("button_" + id);
	var to_text = document.getElementById("respond_to_" + id);
	var to_pass = document.getElementById("submit_" + id);
	if (to_close && to_text && to_pass) {
		console.log("Found matches.");
		void_modify(to_close, to_text, to_pass);
	}
}