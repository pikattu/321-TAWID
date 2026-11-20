
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

    // Allow placement anywhere inside the map
	CanPlaceCrosswalk =
	    PreviewX >= MapLeft &&
	    PreviewX <= MapRight &&
	    Money >= CrosswalkCost;

    // Check for duplicates
    var _existing = false;

    with (oCrosswalk)
    {
        if (point_distance(x, y, other.PreviewX, other.PreviewY) < 2)
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
// SPAWN PEDESTRIANS RANDOMLY
// ==========================================

if (!PedestriansSpawned)
{
    // Store previous spawn positions
    var _spawnXs = [];
    var _spawnYs = [];

    for (var i = 0; i < StartingPedestrians; i++)
    {
        var _spawnX = 0;
        var _spawnY = 0;
        var _validPosition = false;
        var _attempts = 0;

        // Find a position that isn't too close
        // to another pedestrian
        while (!_validPosition && _attempts < 50)
        {
            _spawnX = irandom_range(
                PedestrianSpawnMinX,
                PedestrianSpawnMaxX
            );

            _spawnY = irandom_range(
                PedestrianSpawnMinY,
                PedestrianSpawnMaxY
            );

            _validPosition = true;

            for (var j = 0; j < i; j++)
            {
                var _distance = point_distance(
                    _spawnX, _spawnY,
                    _spawnXs[j], _spawnYs[j]
                );

                if (_distance < 35)
                {
                    _validPosition = false;
                    break;
                }
            }

            _attempts++;
        }

        // Save position
        _spawnXs[i] = _spawnX;
        _spawnYs[i] = _spawnY;

        // Random pedestrian type
        var _type = choose(oGirl, oLola);

        // Create pedestrian
        instance_create_layer(
            _spawnX,
            _spawnY,
            "Instances",
            _type
        );
    }

    PedestriansSpawned = true;
}

