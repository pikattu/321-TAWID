
// ==========================================
// CROSSWALK PLACEMENT PREVIEW
// ==========================================

if (PlaceCrosswalkMode)
{
    var _previewColor = c_red;

    if (CanPlaceCrosswalk)
    {
        _previewColor = c_lime;
    }

    draw_sprite_ext(
        sCrossWalk_Place,
        0,
        PreviewX,
        PreviewY,
        1,
        1,
        0,
        _previewColor,
        0.5
    );
}
