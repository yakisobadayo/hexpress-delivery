// Initialise money
global.money = 0;
global.base_tip = 50;

function deliver_parcel(){
	// Collected tips (base tip of 50 multiplied by health multiplier)
	global.collected_tips += global.base_tip*global.tip_multiplier;
            
    // Increment delivered package count.
    global.deliveredpackages += 1;
	
	// Reset for the next delivery: Restore parcel health to 100%.
    global.tip_multiplier = 1;
}

function reset_tip_multiplier(){
    // Reset for the next delivery: Restore parcel health to 100%.
    global.tip_multiplier = 1;
}