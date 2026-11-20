// ==========================================
// EDIT MODE
// ==========================================

if (keyboard_check_pressed(ord("E")))
{
    EditMode = !EditMode;

    SimulationRunning = !EditMode;
}
// ==========================================
// CROSSWALK PLACEMENT MODE
// ==========================================

// Toggle placement mode
if (keyboard_check_pressed(ord("C")))
{
    PlaceCrosswalkMode = !PlaceCrosswalkMode;
}

// Update preview position (no grid snapping)
if (PlaceCrosswalkMode)
{
    PreviewX = mouse_x;
    PreviewY = mouse_y;

    // Determine which road the mouse is over
    PreviewRoadNumber = 0;

    if (PreviewY >= Road1Top && PreviewY <= Road1Bottom)
    {
        PreviewRoadNumber = 1;
    }
    else if (PreviewY >= Road2Top && PreviewY <= Road2Bottom)
    {
        PreviewRoadNumber = 2;
    }

    // Check if placement is valid
    CanPlaceCrosswalk =
        PreviewRoadNumber != 0 &&
        PreviewX >= MapLeft &&
        PreviewX <= MapRight &&
        Money >= CrosswalkCost;

    // Check for duplicates
    var _existing = false;

    with (oCrosswalk)
    {
        if (abs(x - other.PreviewX) < 2 &&
            RoadNumber == other.PreviewRoadNumber)
        {
            _existing = true;
        }
    }

    if (_existing)
    {
        CanPlaceCrosswalk = false;
    }

    // Place crosswalk
    if (mouse_check_button_pressed(mb_left) && CanPlaceCrosswalk)
    {
        var _cw = instance_create_layer(
            PreviewX,
            PreviewY,
            CrosswalkLayer,
            oCrosswalk
        );

        if (_cw != noone)
        {
            _cw.RoadNumber = PreviewRoadNumber;
            _cw.ColumnX = PreviewX;

            Money -= CrosswalkCost;
        }
    }
}
// ==========================================
// SPAWN PEDESTRIANS
// ==========================================

if (!PedestriansSpawned)
{
    for (var i = 0; i < StartingPedestrians; i++)
    {
        var _spawnX = PedestrianSpawnX + (i * 20);
        var _spawnY = PedestrianSpawnY;

        // Random pedestrian type
        var _type = choose(oGirl, oLola);

        instance_create_layer(
            _spawnX,
            _spawnY,
            "Instances",
            _type
        );
    }

    PedestriansSpawned = true;
}


