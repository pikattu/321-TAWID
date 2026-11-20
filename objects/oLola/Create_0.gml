/// oLola - Create Event

// Initialize shared variables from oPedestrian
event_inherited();

// ==========================================
// PEDESTRIAN STATS
// ==========================================

WalkSpeed = 1.0;

Patience = 150;
MaxPatience = 150;

AgeType = "elderly";
VisionRange = 150;

Fatigue = 0;
FatigueRate = 0.3;

JaywalkTendency = 10.05;

// ==========================================
// MOVEMENT
// ==========================================

MoveSpeed = WalkSpeed;

TargetX = x;
TargetY = y;

Moving = false;

// ==========================================
// CROSSWALK ASSIGNMENT
// ==========================================

AssignedCrosswalk = noone;
Assigned = false;

// ==========================================
// CROSSING
// ==========================================

Crossing = false;
CrossingSafe = false;

// ==========================================
// STATE
// ==========================================

PedestrianState = "walking";