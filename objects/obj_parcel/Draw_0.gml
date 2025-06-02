switch (hits) {
	case 3:
        image_index = 1;
        break;
    case 2:
        image_index = 1;
        break;
    case 1:
        image_index = 2;
        break;
    case 0:
        image_index = 3;
        break;
    default:
        image_index = 0;
}

draw_self();
/*/
if (landed) {
	draw_text_with_shadow(x, y, "Delivered!", c_white, c_black, 0.33);
}