// Axel O. Balitaan
// CMSC 12 T15L
// Javascript for code computation

function compute(){																		// Function for computing for total price
	var height = 3;																		//Default height set to 3

	var Tiers = document.getElementById('numbertiers').value;							// Gets the number of tiers
	var Cake_Flavor_Multi = CakeFlavor();												// Calls the function that gets the Cake Flavor and its multiplier
	var Filling_Multi = Filling();														// Calls the function that gets the Cake Filling and its multiplier
	var Icing_Multi = Icing();															// Calls the function that gets the Cake Icing and its multiplier
	var Inside_Cake_Multi = Inside_Cake();												// Calls the function that gets the inside cake additions and total multipliers
	var Decorative_Multi = Decorative();												// Calls the function that gets the cake decorations and total multipliers
	var Liquid_Multi = LiquidInfusion();												// Calls the function that gets the liquid infusion and its multiplier
	var Cake_Multiplier = (Cake_Flavor_Multi[0] + Filling_Multi[0] + 					// Adds the total multiplie
		Icing_Multi[0] + Inside_Cake_Multi[0] + Decorative_Multi[0] + Liquid_Multi[0])	

	var TotalCost = 0																	// Block that gets the total cost of cake
	for (var x = 1; x <= Tiers; x++){													// Radius iterates per tier
		TotalCost = TotalCost + (3.14 * (x+1)**2 * height * Cake_Multiplier);			// Substitutes the values to the formula
	}

	if (document.getElementById('shipping').checked){									// Checks if user selected delivery option
		TotalCost += 125;																// If so, adds shipping fee to total cost
		var shipping = 'True';
	}
	else{
		var shipping = 'False';															// If not, declares a value that shipping is false
	}

	submitForm(Tiers, Cake_Flavor_Multi[1], Filling_Multi[1], Icing_Multi[1], 			// Pass the specific options/values (not the multipliers) to a separate submit function
		Inside_Cake_Multi[1], Decorative_Multi[1], Liquid_Multi[1], shipping, TotalCost)
}

function CakeFlavor(){																	// Function for getting the selected Cake Flavor

	var Cake_Flavor_Multi; 
	var Flavor;
	if (document.getElementById('flavor1').checked) {									// Checks if specific radio (ids) are checked
		Cake_Flavor_Multi = 4;															// If so, assigns corresponding multiplier and flavor
		Flavor = 'Traditional White';
	} else if (document.getElementById('flavor2').checked) {
		Cake_Flavor_Multi = 10;
		Flavor = "Devil's Food Chocolate";
	} else if (document.getElementById('flavor3').checked) {
		Cake_Flavor_Multi = 8;
		Flavor = 'Red Velvet';
	} else if (document.getElementById('flavor4').checked) {
		Cake_Flavor_Multi = 6;
		Flavor = 'Lemon';
	}

	return [Cake_Flavor_Multi, Flavor];													// Returns a list of cake_flavor(multiplier), and specific flavor
}

function Filling(){																		// Function for getting the selected Cake Filling

	var Filling_Multi; 
	var Cake_Filling;
	if (document.getElementById('filling1').checked) {									// Checks if specific radio (ids) are checked
		Filling_Multi = 3;																// If so, assigns corresponding multiplier, and cake filling
		Cake_Filling = 'Raspberry Jam';
	} else if (document.getElementById('filling2').checked) {
		Filling_Multi = 3;
		Cake_Filling = 'Strawberry Jam';
	} else if (document.getElementById('filling3').checked) {
		Filling_Multi = 4;
		Cake_Filling = 'Buttercream';
	} else if (document.getElementById('filling4').checked) {
		Filling_Multi = 4;
		Cake_Filling = 'Apricot Jam';
	}

	return [Filling_Multi, Cake_Filling];												// Returns a list of filling multiplier, and specific cake filling
}

function Icing(){																		// Function for getting the selected Cake Icing

	var Icing_Multi; 
	var Cake_Icing;
	if (document.getElementById('icing1').checked) {									// Checks if specific radio (ids) are checked 
		Icing_Multi = 2;																// If so, assigns corresponding multiplier, and cake icing
		Cake_Icing = 'Buttercream';
	} else if (document.getElementById('icing2').checked) {
		Icing_Multi = 2;
		Cake_Icing = 'Cream Cheese';
	} else if (document.getElementById('icing3').checked) {
		Icing_Multi = 2;
		Cake_Icing = 'Mocha Espresso';
	}

	return [Icing_Multi, Cake_Icing];													// Returns a list of icing multiplier, and specific cake icing
}

function Inside_Cake(){																	// Function for getting the selected inside cake additions

	var Inside_Cake_Multi = 0;															// Declares an initial inside cake multiplier value
	var Inside_Cake = [];																// Declares an empty list for inside cake additions

	if (document.getElementById('additions1').checked){									// Checks specific check boxes
		Inside_Cake_Multi += 1.5;														// if so, adds inside cake multiplier
		Inside_Cake.push('Walnut');														// and pushes the selected to the inside_cake list

	} if (document.getElementById('additions2').checked){
		Inside_Cake_Multi += 1.5;
		Inside_Cake.push('Chocolate Chips');

	} if (document.getElementById('additions3').checked){
		Inside_Cake_Multi += 1.5;
		Inside_Cake.push('Pecans');

	} if (document.getElementById('additions4').checked){
		Inside_Cake_Multi += 1.5;
		Inside_Cake.push('White Chocolate Chips');
	}

	return [Inside_Cake_Multi, Inside_Cake];											// returns total inside cake multiplier, and a list of selected inside cake additions
}

function Decorative(){																	// Function for getting the selected decorative additions

	var Decorative_Multi = 0;															// Declares an initial decoration multiplier value
	var Decorations = [];																// Declares an empty list for decorations

	if (document.getElementById('decoration1').checked){								// Checks specific check boxes
		Decorative_Multi += 2.5;														// if so, adds cake decoration multiplier
		Decorations.push('Walnut');														// and pushes the selected to the inside_cake list
	} if (document.getElementById('decoration2').checked){
		Decorative_Multi += 2.5;
		Decorations.push('Chocolate Chips');
	} if (document.getElementById('decoration3').checked){
		Decorative_Multi += 2.5;
		Decorations.push('Pecans');
	} if (document.getElementById('decoration4').checked){
		Decorative_Multi += 2.5;
		Decorations.push('White Chocolate Chips');
	}

	return [Decorative_Multi, Decorations];												// returns total cake decoration multiplier, and a list of selected cake decorations
}

function LiquidInfusion(){																// Function for getting liquid infusions

	var x = document.getElementById('liquor infusions').value;							// Gets the user selected value
	if (x == 'Rum'){																	// Assigns specific multiplier
		Liquid_Multi = 3;
	} else if (x == 'Amaretto'){
		Liquid_Multi = 8;
	} else if (x == 'Kaluha'){
		Liquid_Multi = 5;
	} else if (x == 'None'){
		Liquid_Multi = 0;
	}

	return [Liquid_Multi, x];															// Returns multiplier and liquid infusion
}

function delivery(){																	// Function that disables the delivery field if store pickup is selected
	if (document.getElementById('pickup').checked){										// Checks if pickup option is selected
		document.getElementById('Address').disabled = true;								// If so, disables the fieldset
		document.getElementById('delivery date').disabled = true;
		document.getElementById('delivery time').disabled = true;
		}
	else{																				// If not, reenables the fieldset
		document.getElementById('Address').disabled = false;
		document.getElementById('delivery date').disabled = false;
		document.getElementById('delivery time').disabled = false;
	}
}

function datevalidation(){																// Function that checks user-selected date
	var selected_date = Date.parse(document.getElementById('delivery date').value);		// Gets selected date
	var current_date = Date.parse(new Date());											// Gets current date

	if (selected_date <= current_date){													// Evaluates if the selected date is in the future
			document.getElementById('submitorder').disabled = true;						// If not, disables the submit button
			document.getElementById('deliverydatevalid').innerHTML = 					// and, shows a message
				"<i>Please select a future date!</i>";
		}
	else{
		document.getElementById('submitorder').disabled = false;						// If the selected is in the future, reenables submit button
		document.getElementById('deliverydatevalid').innerHTML = '';					// and, removes the message
	}
}

function timevalidation(){																// Function that checks user-selected time
	var selected_time = document.getElementById('delivery time').value;					// Gets selected time
	var selected_time_hour = parseInt(selected_time.slice(0,2));						// Gets the hour value of selected time
	var selected_time_min = parseInt(selected_time.slice(3,5));							// Gets the minute value of selected time

	var time_selected = (selected_time_hour * 60 + selected_time_min);					// Converts the time to a single integer
	var opening = (6 * 60);																// Converts the opening time to a single integer
	var closing = (18 * 60);															// Converts the closing time to a single integer

	
	if ((time_selected >= opening) && (time_selected <= closing)) {						// Compares if the selected time is within the working hours
		document.getElementById('submitorder').disabled = false;						// If within the working hours, enables the submit button
		document.getElementById('deliverytimevalid').innerHTML = '';					// Removes the message
	}
	else{
		document.getElementById('submitorder').disabled = true;							// If outside working hours, disables submit button
		document.getElementById('deliverytimevalid').innerHTML = 						// and, shows a message
			"<i> Delivery times are only from 6am to 6pm. <i>";
	}
}

function submitForm(Tiers, Cake_Flavor, Cake_Filling, Cake_Icing, 						// Function for submitting the form
	Inside_List, Decorative_List, LiquidInfusion, shipping, TotalCost){

	id_list = ['name', 'mobilenum', 'email'];											// List of information ids
	for (x = 0; x < id_list.length; x ++){												// Iterates over the ids
		if (document.getElementById(id_list[x]).value == ''){							// and, checks if there are empty fields
			alert('Please fill the required fields');									// if so, shows an alert message to field empty fields
			return;																		// and early returns to stop the function
		}
	}

	shipping_id = ['Address', 'delivery date', 'delivery time'];						// List of ids in delivery fieldset
	if (shipping == 'True'){															// If delivery option is selected, 
		for (x = 0; x < shipping_id.length; x ++){										// checks if each was filled
			if (document.getElementById(shipping_id[x]).value == ''){
				alert('Please fill the required fields');								// If not, shows an alert to fill required fields
				return;																	// and early returns to stop the function
			}
		}
		shippingtext = '+ 125 delivery fee.\nDelivery Address: ' + 						// Adds a new line of text to the submit alert if delivery option is selected
			document.getElementById('Address').value + '\n' +
			'Delivery date & time: ' + document.getElementById('delivery date').value + 
			' ' + document.getElementById('delivery time').value;
	}
	else{																				// If store pickup, does not alert delivery info
		shippingtext = 'Store Pickup';
	}

	if (!((Tiers >= 1) && (Tiers <= 5))){												// If cake tiers is not within the range of 1 - 5
		alert('Invalid Cake Tiers!');													// Shows an alert that it is invalid
		return;																			// and early returns to stop the function
	}

	alert(																				// Alert for valid submission
		'Customer name: ' + document.getElementById('name').value + '\n' +
		'Mobile #: ' + document.getElementById('mobilenum').value + '\n' +
		'Email: ' + document.getElementById('email').value + '\n' +
		'Tiers: ' + Tiers + '\n' +
		'Cake Flavor: ' + Cake_Flavor + '\n' +
		'Filling: ' + Cake_Filling + '\n' +
		'Icing: ' + Cake_Icing + '\n' + 
		'Inside cake additions: ' + Inside_List.join(", ") + '\n' +
		'Decorative additions: ' + Decorative_List.join(", ") + '\n' +
		'Infusion: ' + LiquidInfusion + '\n' +
		shippingtext + '\n' +
		'Total cost: ' + TotalCost
	);
}
