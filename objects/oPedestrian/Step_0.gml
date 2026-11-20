
/// oPedestrian - Step Event

// ==========================================
// SIMULATION CHECK
// ==========================================

if (!instance_exists(oGameManager)) exit;
if (!oGameManager.SimulationRunning) exit;


// ==========================================
// RANDOM DESTINATION ASSIGNMENT
// ==========================================

if (!DestinationAssigned)
{
    var _cafeCount = instance_number(oCafe);
    var _bakeryCount = instance_number(oBakery);
    var _total = _cafeCount + _bakeryCount;

    if (_total > 0)
    {
        var _choice = irandom(_total - 1);

        if (_choice < _cafeCount)
        {
            Destination = instance_find(oCafe, _choice);
            DestinationName = "Cafe";
        }
        else
        {
            Destination = instance_find(
                oBakery,
                _choice - _cafeCount
            );

            DestinationName = "Bakery";
        }

        DestinationAssigned = instance_exists(Destination);
    }
}

if (!DestinationAssigned || !instance_exists(Destination))
{
    Destination = noone;
    DestinationAssigned = false;
    DestinationName = "";

    Moving = false;
    exit;
}

if (PedestrianState == "arrived") exit;



// ==========================================
// FIND CROSSWALK ROUTE
// ==========================================

if (RouteStage == "finding" || RouteStage == "waiting")
{
    if (!instance_exists(Destination))
    {
        DestinationAssigned = false;
        Destination = noone;
        Moving = false;
        exit;
    }

    if (array_length(CrosswalkRoute) == 0)
    {
        CrosswalkRoute = [];

        var _crosswalkCount = instance_number(oCrosswalk);

        // Start searching from the destination
        var _anchorX = Destination.x;
        var _anchorY = Destination.y;

        show_debug_message(
            "Planning route to " + DestinationName
        );

        // ==========================================
        // STEP 1: FIND THE CLOSEST CROSSWALK
        // TO THE DESTINATION
        // ==========================================

        var _firstCrosswalk = noone;
        var _firstDistance = 999999;

        for (var i = 0; i < _crosswalkCount; i++)
        {
            var _cw = instance_find(oCrosswalk, i);

            if (!instance_exists(_cw)) continue;

            var _distance = point_distance(
                _anchorX, _anchorY,
                _cw.x, _cw.y
            );

            if (_distance <= CrosswalkLinkDistance &&
                _distance < _firstDistance)
            {
                _firstDistance = _distance;
                _firstCrosswalk = _cw;
            }
        }

        // Add the closest crosswalk
        if (instance_exists(_firstCrosswalk))
        {
            CrosswalkRoute[0] = _firstCrosswalk;

            _anchorX = _firstCrosswalk.x;
            _anchorY = _firstCrosswalk.y;

            show_debug_message(
                "Closest to destination: " +
                string(_anchorX) + ", " +
                string(_anchorY)
            );

            // ==========================================
            // STEP 2: KEEP FINDING THE NEXT CLOSEST
            // CROSSWALK TOWARD THE PEDESTRIAN
            // ==========================================

            for (var i = 1; i < _crosswalkCount; i++)
            {
                var _bestCrosswalk = noone;
                var _bestDistance = 999999;

                var _anchorPedDistance = point_distance(
                    _anchorX, _anchorY,
                    x, y
                );

                for (var j = 0; j < _crosswalkCount; j++)
                {
                    var _cw = instance_find(oCrosswalk, j);

                    if (!instance_exists(_cw)) continue;

                    // Skip crosswalks already in the route
                    var _alreadyUsed = false;

                    for (var k = 0;
                         k < array_length(CrosswalkRoute);
                         k++)
                    {
                        if (CrosswalkRoute[k] == _cw)
                        {
                            _alreadyUsed = true;
                            break;
                        }
                    }

                    if (_alreadyUsed) continue;

                    // Distance from current crosswalk
                    var _distance = point_distance(
                        _anchorX, _anchorY,
                        _cw.x, _cw.y
                    );

                    // Distance from pedestrian
                    var _pedDistance = point_distance(
                        _cw.x, _cw.y,
                        x, y
                    );

                    // Only consider nearby crosswalks
                    // that move the route closer to the pedestrian
                    if (_distance <= CrosswalkLinkDistance &&
                        _pedDistance < _anchorPedDistance)
                    {
                        if (_distance < _bestDistance)
                        {
                            _bestDistance = _distance;
                            _bestCrosswalk = _cw;
                        }
                    }
                }

                // No more suitable crosswalks
                if (!instance_exists(_bestCrosswalk))
                {
                    show_debug_message(
                        "No more connected crosswalks."
                    );

                    break;
                }

                // Add the next closest crosswalk
                var _length = array_length(CrosswalkRoute);

                CrosswalkRoute[_length] = _bestCrosswalk;

                _anchorX = _bestCrosswalk.x;
                _anchorY = _bestCrosswalk.y;

                show_debug_message(
                    "Next crosswalk " + string(_length + 1) +
                    ": " + string(_anchorX) + ", " +
                    string(_anchorY)
                );
            }
        }

        // ==========================================
        // STEP 3: REVERSE THE ROUTE
        // DESTINATION -> PEDESTRIAN
        // BECOMES PEDESTRIAN -> DESTINATION
        // ==========================================

        var _routeLength = array_length(CrosswalkRoute);

        for (var i = 0; i < floor(_routeLength / 2); i++)
        {
            var _opposite = _routeLength - 1 - i;

            var _temp = CrosswalkRoute[i];

            CrosswalkRoute[i] = CrosswalkRoute[_opposite];
            CrosswalkRoute[_opposite] = _temp;
        }

        // ==========================================
        // STEP 4: BEGIN FOLLOWING THE ROUTE
        // ==========================================

        if (_routeLength > 0)
        {
            CurrentRouteIndex = 0;
            CurrentCrosswalk = CrosswalkRoute[0];

            RouteStage = "approach";
            JaywalkDecisionMade = false;

            show_debug_message(
                "Route planned! Crosswalks to visit: " +
                string(_routeLength)
            );
        }
        else
        {
            show_debug_message(
                "No crosswalks found near the destination."
            );

            if (!JaywalkDecisionMade)
            {
                JaywalkDecisionMade = true;

                if (random(1) < JaywalkTendency)
                {
                    RouteStage = "destination";
                }
                else
                {
                    RouteStage = "waiting";
                }
            }
        }
    }
}



// ==========================================
// SELECT MOVEMENT TARGET
// ==========================================

var _targetX = x;
var _targetY = y;

if (RouteStage == "approach" ||
    RouteStage == "crossing")
{
    if (!instance_exists(CurrentCrosswalk))
    {
        CurrentCrosswalk = noone;
        CrosswalkRoute = [];
        CurrentRouteIndex = 0;

        RouteStage = "finding";
        exit;
    }

    var _directionY = sign(Destination.y - y);

    var _halfHeight =
        sprite_get_height(CurrentCrosswalk.sprite_index) * 0.5;

    _targetX = CurrentCrosswalk.x;

    if (RouteStage == "approach")
    {
        _targetY = CurrentCrosswalk.y -
            (_directionY * _halfHeight);
    }
    else
    {
        _targetY = CurrentCrosswalk.y +
            (_directionY * _halfHeight);
    }
}
else if (RouteStage == "destination")
{
    _targetX = Destination.x;
    _targetY = Destination.y;
}


// ==========================================
// MOVE PEDESTRIAN
// ==========================================

var _step = MoveSpeed;


// ==========================================
// APPROACH CROSSWALK
// ==========================================

if (RouteStage == "approach")
{
    if (!instance_exists(CurrentCrosswalk))
    {
        CurrentCrosswalk = noone;
        CrosswalkRoute = [];
        CurrentRouteIndex = 0;

        RouteStage = "finding";
        exit;
    }

    Moving = true;

    // STEP 1: Align horizontally
    if (abs(x - _targetX) > 2)
    {
        x += sign(_targetX - x) *
             min(_step, abs(_targetX - x));
    }
    // STEP 2: Move toward entrance
    else if (abs(y - _targetY) > 2)
    {
        x = _targetX;

        y += sign(_targetY - y) *
             min(_step, abs(_targetY - y));
    }
    else
    {
        x = _targetX;
        y = _targetY;

        RouteStage = "crossing";
    }
}


// ==========================================
// CROSS CROSSWALK
// ==========================================

else if (RouteStage == "crossing")
{
    if (!instance_exists(CurrentCrosswalk))
    {
        CurrentCrosswalk = noone;
        CrosswalkRoute = [];
        CurrentRouteIndex = 0;

        RouteStage = "finding";
        exit;
    }

    Moving = true;

    // Lock X position
    x = CurrentCrosswalk.x;

    // Cross vertically
    if (abs(y - _targetY) > 2)
    {
        y += sign(_targetY - y) *
             min(_step, abs(_targetY - y));
    }
    else
    {
        x = _targetX;
        y = _targetY;

        // Move to next crosswalk
        CurrentRouteIndex++;

        if (CurrentRouteIndex < array_length(CrosswalkRoute))
        {
            CurrentCrosswalk =
                CrosswalkRoute[CurrentRouteIndex];

            RouteStage = "approach";
        }
        else
        {
            // Route completed
            CurrentCrosswalk = noone;

            CrosswalkRoute = [];
            CurrentRouteIndex = 0;

            RouteStage = "destination";
        }
    }
}


// ==========================================
// MOVE TO DESTINATION
// ==========================================

else if (RouteStage == "destination")
{
    Moving = true;

    // HORIZONTAL MOVEMENT FIRST
    if (abs(x - _targetX) > 2)
    {
        x += sign(_targetX - x) *
             min(_step, abs(_targetX - x));
    }
    // VERTICAL MOVEMENT SECOND
    else if (abs(y - _targetY) > 2)
    {
        x = _targetX;

        y += sign(_targetY - y) *
             min(_step, abs(_targetY - y));
    }
    else
    {
        x = _targetX;
        y = _targetY;

        Moving = false;
        PedestrianState = "arrived";

        show_debug_message(
            DestinationName + " reached!"
        );
    }
}


// ==========================================
// IDLE
// ==========================================

else
{
    Moving = false;
}
