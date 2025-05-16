grav = 0.26;
y_velocity = 0;
grounded    = false;  // is it on the floor?
landed      = false;  // has it already landed? (one-shot guard)

switch (hits) {       // Calculates the damage multiplier based on hit count
    case 4: dmg_mult = 1.00; break;
    case 3: dmg_mult = 0.80; break;
    case 2: dmg_mult = 0.55; break;
    case 1: dmg_mult = 0.30; break;
    case 0: dmg_mult = 0.00; break;
}