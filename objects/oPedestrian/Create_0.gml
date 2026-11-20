// ==========================================
// DESTINATION
// ==========================================

Destination = noone;
DestinationName = "";
DestinationAssigned = false;

// ==========================================
// ROUTE
// ==========================================

TargetX = x;
TargetY = y;

PedestrianState = "walking";

Assigned = false;
AssignedCrosswalk = noone;

// ==========================================
// MOVEMENT
// ==========================================

// Movement
Moving = false;
MoveSpeed = 1;

// ==========================================
// CROSSING
// ==========================================

Crossing = false;
CrossingSafe = false;

// ==========================================
// DYNAMIC ROUTING
// ==========================================

RouteStage = "finding";
CurrentCrosswalk = noone;

JaywalkDecisionMade = false;

// Crosswalk route
CrosswalkRoute = [];
CurrentRouteIndex = 0;
// Maximum distance between crosswalks to consider them connected
CrosswalkLinkDistance = 300;