// Axel Balitaan
// CMSC 12 T1L
// Distance coordinate points and farthest/nearest finder using javascript


var p = 3;
var origin = ['Manila', 3, 4];
var destinations = [['Hanoi', -3, 3], ['Tokyo', 8, 9], ['Bangkok', 6, 7], ['London', 15, 12]];

function processMap(origin, destinations, p) {																				// Function for computing distances
	var distance_list = []
	var origin_loc = origin[0];																								// Gets the coordinates from the origin
	var origin_x = origin[1];
	var origin_y = origin[2];
	var power = 1 / p;

	for (var i = 0; i < destinations.length; i++){
		var destination_loc = destinations[i][0];																			// Gets the city from destinations
		var destination_x = destinations[i][1];																				// Gets the coordinates from destinations
		var destination_y = destinations[i][2];
		
		var distance_x = Math.pow(Math.abs(destination_x - origin_x), p);													// Solves for the distances
		var distance_y = Math.pow(Math.abs(destination_y - origin_y), p);
		var distance = Math.pow((distance_x + distance_y), power);
		distance_list.push([destination_loc, distance]);																	// Pushes the location and its corresponding distance from origin
	}
	return distance_list
}

function findFarthest(distance_list){																						// Function for finding the farthest distance and location
	var farthest_distance = 0;

	for (var i = 0; i < distance_list.length; i++){

		var distance = distance_list[i][1];																					// Gets the distance of the corresponding location

		if (distance > farthest_distance) {																					// Compares if the distance is longer the the current farthest distance
			farthest_distance = distance;																					// If so, dethrones the farthest distance
			var farthest_loc = distance_list[i][0];																			// Gets the location of the new farthest distance
		}
	}
	return [farthest_loc, farthest_distance]
}

function findNearest(distance_list, farthest){																				// Function for finding the nearest distance and location
	var nearest_distance = farthest;																						// Sets the first nearest distance as the farthest (for comparison)

	for (var i = 0; i < distance_list.length; i++){

		var distance = distance_list[i][1];																					// Gets the distance of the corresponding location

		if (distance < nearest_distance) {																					// Compares if the distance is nearer than the current nearest distance
			nearest_distance = distance;																					// If so, dethrones the nearest distance
			var nearest_loc = distance_list[i][0];																			// Gets the location of the new nearest distance
		}
	}
	return [nearest_loc, nearest_distance]
}


var distance_list = processMap(origin, destinations, p);																	// Main Block
var farthest = findFarthest(distance_list);
var nearest = findNearest(distance_list, farthest[1]);

console.log('The longest distance from', origin[0], 'is:', farthest[0], 'at', farthest[1])
console.log('The shortest distance from', origin[0], 'is:', nearest[0], 'at', nearest[1])