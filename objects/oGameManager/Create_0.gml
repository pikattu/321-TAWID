// Initialize random number generator
randomize();
 // ==========================================
 // CROSSWALK PLACEMENT
 // ==========================================

PlaceCrosswalkMode = false;

CrosswalkCost = 20;
CrosswalkGrid = 32;

// Road 1 boundaries
Road1Top = 229;
Road1Bottom = 333;

// Road 2 boundaries
Road2Top = 498;
Road2Bottom = 603;

// Room boundaries
MapLeft = 0;
MapRight = room_width;


// Placement layer
CrosswalkLayer = "Instances";

// ==========================================
// PLAYER ECONOMY
// ==========================================

Money = 1000;

PreviewX = 0;
PreviewY = 0;
PreviewRoadNumber = 0;
CanPlaceCrosswalk = false;

// ==========================================
// SIMULATION SETTINGS
// ==========================================

EditMode = true;
SimulationRunning = false;

StartingPedestrians = 10;
PedestriansSpawned = false;

// ==========================================
// PEDESTRIAN SPAWN AREA
// ==========================================

PedestrianSpawnMinX = 100;
PedestrianSpawnMaxX = room_width - 100;

PedestrianSpawnMinY = room_height - 180;
PedestrianSpawnMaxY = room_height - 40;

