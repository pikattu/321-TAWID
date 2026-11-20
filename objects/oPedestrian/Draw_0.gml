/// oPedestrian - Draw Event

// Draw pedestrian sprite
draw_self();

// ==========================================
// DESTINATION LABEL
// ==========================================

if (DestinationAssigned)
{
    var _label = "Going to: " + DestinationName;
    var _labelY = y - sprite_get_height(sprite_index) - 12;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Text outline
    draw_set_color(c_black);

    draw_text(x - 1, _labelY, _label);
    draw_text(x + 1, _labelY, _label);
    draw_text(x, _labelY - 1, _label);
    draw_text(x, _labelY + 1, _label);

    // Main text
    draw_set_color(c_white);
    draw_text(x, _labelY, _label);

    // Reset drawing settings
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}