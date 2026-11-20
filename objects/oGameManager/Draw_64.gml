if (PlaceCrosswalkMode)
{
    draw_set_color(c_yellow);
    draw_text(20, 20, "CROSSWALK PLACEMENT MODE");

    draw_set_color(c_white);
    draw_text(20, 40, "Click on a road to place a crosswalk");
    draw_text(20, 60, "Cost: $" + string(CrosswalkCost));
}