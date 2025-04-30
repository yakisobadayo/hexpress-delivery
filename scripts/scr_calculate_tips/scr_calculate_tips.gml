// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calculate_tips(){
	var baseTip       = 100;
	var totalTip      = 0;
	var scores        = global.parcel_scores;
	var numParcels    = array_length(scores);

	// Sum up each parcel’s tip
	for (var i = 0; i < numParcels; i++) {
	    var healthPct    = scores[i];          // e.g. 100, 90, 80…
	    var parcelTip    = baseTip * healthPct;
	    totalTip        += parcelTip;
	}

	// Optionally round to an integer
	totalTip = round(totalTip);

	// Store it somewhere
	global.tip_money += totalTip;
}