/// @function draw_text_with_shadow(x, y, text, text_color, shadow_color, shadow_alpha)
/// @param x             The x-coordinate to draw the text.
/// @param y             The y-coordinate to draw the text.
/// @param text          The string to draw.
/// @param text_color    The color of the main text.
/// @param shadow_color  The color of the shadow.
/// @param shadow_alpha  The alpha (0–1) of the shadow.
function draw_text_with_shadow(_x, _y, _text, _text_color, _shadow_color, _shadow_alpha)
{
    // stash old settings
    var _old_col   = draw_get_color();
    var _old_alpha = draw_get_alpha();

    // draw the shadow at +1,+1
    draw_set_color(_shadow_color);
    draw_set_alpha(_shadow_alpha);
    draw_text(_x + 1, _y + 1, _text);

    // draw the main text
    draw_set_color(_text_color);
    draw_set_alpha(_old_alpha);
    draw_text(_x, _y, _text);

    // restore
    draw_set_color(_old_col);
    draw_set_alpha(_old_alpha);
}
