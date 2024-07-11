--
-- Battlefront Balance Patch
--

PS2_MEMORY = 4000000 -- 4MB

------------------------------------------------
------------   TEAM DISTRIBUTION   -------------
------------------------------------------------

-- maximum units on each team
MAX_UNITS = 32

-- number of reinforcements
DEFAULT_REINFORCEMENTS = 150

-- The following is formatted as:
-- unit class
-- maximum ai in class
-- minimum ai in class

-- soldier
MAX_SOLDIER = MAX_UNITS
MIN_SOLDIER = 10

-- assault
MAX_ASSAULT = 6
MIN_ASSAULT = 2

-- sniper
MAX_SNIPER = 6
MIN_SNIPER = 1

-- engineer
MAX_ENGINEER = 4 
MIN_ENGINEER = 1

-- officer
MAX_OFFICER = 4
MIN_OFFICER = 1

-- specialist
MAX_SPECIAL = 4
MIN_SPECIAL = 1


------------------------------------------------
------------   UBER_MODE   ---------------------
------------------------------------------------

-- remove the unit cap
UBER_MODE = 0

-- maximum units on each team
UBER_MAX_UNITS = 200

-- number of reinforcements
UBER_DEFAULT_REINFORCEMENTS = 1000

-- The following is formatted as:
-- unit class
-- maximum ai in class
-- minimum ai in class

-- soldier
UBER_MAX_SOLDIER = UBER_MAX_UNITS
UBER_MIN_SOLDIER = 10

-- assault
UBER_MAX_ASSAULT = 40
UBER_MIN_ASSAULT = 2

-- sniper
UBER_MAX_SNIPER = 20
UBER_MIN_SNIPER = 1

-- engineer
UBER_MAX_ENGINEER = 10
UBER_MIN_ENGINEER = 1

-- officer
UBER_MAX_OFFICER = 30
UBER_MIN_OFFICER = 1

-- specialist
UBER_MAX_SPECIAL = 30
UBER_MIN_SPECIAL = 1


------------------------------------------------
------------   AI RULES   ----------------------
------------------------------------------------

-- SetSpawnDelay(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED)
AI_WAVE_SPAWN_DELAY = 10.0		-- wave spawn delay for AI
PERCENTAGE_AI_RESPAWNED = 0.25	-- percentage of AI respawned with each wave
