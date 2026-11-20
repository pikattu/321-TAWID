// ==========================================
// PEDESTRIAN SIMULATION
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

        DestinationAssigned = true;
    }
}

if (!DestinationAssigned || !instance_exists(Destination))
{
    Moving = false;
    exit;
}

if (PedestrianState == "arrived") exit;

// ==========================================
// FIND CROSSWALK NEAR DESTINATION
// ==========================================

if (RouteStage == "finding" || RouteStage == "waiting")
{
    var _bestCrosswalk = noone;
    var _bestDistance = 999999;

    // Maximum acceptable distance from crosswalk to destination
    var _maxDestinationDistance = 250;

    var _directionY = sign(Destination.y - y);
    var _count = instance_number(oCrosswalk);

    for (var i = 0; i < _count; i++)
    {
        var _cw = instance_find(oCrosswalk, i);

        if (instance_exists(_cw))
        {
            // Crosswalk must be in the direction of the destination
            var _isAhead =
                _directionY * (_cw.y - y) > 0;

            // Measure distance from crosswalk to destination
            var _destinationDistance = point_distance(
                _cw.x, _cw.y,
                Destination.x, Destination.y
            );

            // Only consider crosswalks close to the destination
            if (_isAhead &&
                _destinationDistance <= _maxDestinationDistance)
            {
                if (_destinationDistance < _bestDistance)
                {
                    _bestDistance = _destinationDistance;
                    _bestCrosswalk = _cw;
                }
            }
        }
    }

    if (_bestCrosswalk != noone)
    {
        CurrentCrosswalk = _bestCrosswalk;
        RouteStage = "approach";
        JaywalkDecisionMade = false;
    }
    else if (!JaywalkDecisionMade)
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

if (RouteStage == "approach" ||
    RouteStage == "crossing" ||
    RouteStage == "destination")
{
    var _distance = point_distance(
        x, y,
        _targetX, _targetY
    );

    if (_distance > 2)
    {
        Moving = true;

        var _direction = point_direction(
            x, y,
            _targetX, _targetY
        );

        var _step = min(MoveSpeed, _distance);

        x += lengthdir_x(_step, _direction);
        y += lengthdir_y(_step, _direction);
    }
    else
    {
        x = _targetX;
        y = _targetY;

        if (RouteStage == "approach")
        {
            RouteStage = "crossing";
        }
        else if (RouteStage == "crossing")
        {
            CurrentCrosswalk = noone;
            RouteStage = "finding";
            JaywalkDecisionMade = false;
        }
        else if (RouteStage == "destination")
        {
            Moving = false;
            PedestrianState = "arrived";
        }
    }
}
else
{
    Moving = false;
}