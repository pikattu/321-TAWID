event_inherited();
/// oGirl - Create Event

// Pedestrian stats
WalkSpeed = 1.5;
Patience = 100;
MaxPatience = 100;

AgeType = "young";
VisionRange = 150;
Fatigue = 0;
FatigueRate = 0.5;
JaywalkTendency = 0.2;

// Movement
MoveSpeed = WalkSpeed;
TargetX = x;
TargetY = y;

Moving = false;

// Crosswalk assignment
AssignedCrosswalk = noone;
Assigned = false;

// Crossing
Crossing = false;
CrossingSafe = false;

// State
PedestrianState = "walking";
