--[[
	Battlefront Mission Helper
	Module name: memorypool
	Description: Memory pool setup for common settings
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-03
	Dependencies: constants, logger
	Notes: Additional memory pool sizes must be called separately. 
		   Generally over estiamtes values for simplicity. Users are 
		   encouraged to set their own memory pools if memory limits are 
		   concern. The "num" prefix has been omitted from most parameters 
		   for clarity.
		   
		   SetMemoryPoolSize() comments are written by or inspired from
		   ryanhank.
--]]
local memorypool = {
	name = "memorypool",
	version = 1.0,
	
	initialized = false,
}

-- load dependencies
ScriptCB_DoFile("import")
local constants = import("constants")
local logger = import("logger")

-- weapons should be last for optimal memory pool estimates
local isWeaponPoolSet = false


---------------------------------------------------------------------------
-- FUNCTION:    sumItems
-- PURPOSE:     Calculate number of items and add to total
-- INPUT:		totalItems, itemsPerEntity, numEntities
-- OUTPUT:		totalItems
-- NOTES:       
---------------------------------------------------------------------------
local function sumItems(totalItems, itemsPerEntity, numEntities)
	return totalItems + (itemsPerEntity * numEntities)
end


------------------------------------------------
------------   RATES   -------------------------
------------------------------------------------

-- combo factors
local COMBO_FACTOR = 4					-- should be ~2x number of jedi classes
local COMBO_STATE_FACTOR = 12			-- should be ~12x #Combo
local COMBO_TRANSITION_FACTOR = 2		-- should be a bit bigger than #Combo::State
local COMBO_CONDITION_FACTOR = 2		-- should be a bit bigger than #Combo::State
local COMBO_ATTACK_FACTOR = 12			-- should be ~8-12x #Combo
local COMBO_DAMAGE_SAMPLE_FACTOR = 12	-- should be ~8-12x #Combo::Attack
local COMBO_DEFLECT_FACTOR = 1			-- should be ~1x #combo

-- animations
local ANIMATIONS_PER_UNIT = 6 -- estimate based on stock units

-- tentacles
local TENTACLES_PER_GUNGAN = 2
local TENTACLES_PER_WOOKIEE = 4

-- turrets per vehicle
local TURRETS_PER_FLYER = 0
local TURRETS_PER_HOVER = 1
local TURRETS_PER_WALKER = 2

-- turrets per command vehicle
local TURRETS_PER_COMMAND_FLYER = 3
local TURRETS_PER_COMMAND_HOVER = 2
local TURRETS_PER_COMMAND_WALKER = 3


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   DEFAULTS   ----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- default values
local DEFAULT_MEMORY_POOL_SIZES = {
	-- jedi
	jedi = constants.getMaxPlayableTeams(),
	
	-- map
	asteroids = 0,
	hints = 256,
	obstacles = 512,
	lights = 0,
	redOmniLights = 0,
	treeGridStack = 512,
	
	-- sounds
	music = 0,
	soundSpace = 0,
	soundStatic = 0,
	soundStream = 0,
	
	-- units
	totalAIVehicles = 0,
	totalUnits = 72, -- 2*32 unit teams and headroom for 8 locals
	cloths = constants.getMaxPlayableTeams(), -- to account for heroes
	tentacles = 0,
	gungans = 0,
	wookiees = 0,
	
	-- flyers
	flyers = 6, -- to account for rocket upgrade
	commandFlyers = 0,
	
	-- hovers
	hovers = 0,
	commandHovers = 0,
	
	-- turrets
	turrets = 0,
	additionalVehicleTurrets = 0,
	
	-- walkers
	droidekas = 0,
	onePair = 0,
	twoPair = 0,
	threePair = 0,
	commandWalkers = 0,
	
	-- weapons
	mines = 32, -- 4 mines per assault * 8 assault
	portableTurrets = 8, -- 1 portable turret per sniper * 8 snipers
	towCables = 0,
}

---------------------------------------------------------------------------
-- FUNCTION:    validateParameters
-- PURPOSE:     Validate parameters for erros, and populate missing 
--				parameters
-- INPUT:		params{jedi,
--				-- sounds
--					   music, soundSpace,
--					   soundStatic, soundStream,
--				-- map
--					   hints, obstacles, 
--					   lights, redOmniLights,
--					   treeGridStack,
--				-- units
--					   totalUnits, totalAIVehicles,
--					   soldierAnimations, cloths, 
--					   tentacles, gungans,
--					   wookiees,
--				-- vehicles
--					   flyers, commandFlyers,
--					   hovers, commandHovers,
--					   turrets, droidekas,
--					   onePair, twoPair, 
--					   threePair, commandWalkers,
--					   additionalVehicleTurrets,
--				-- weapons
--					   mines, portableTurrets,
--					   towCables} 
-- OUTPUT:		validParams
-- NOTES:
---------------------------------------------------------------------------
local function validateParameters(params)
	local validParams = {}

	-- validate keys and save value
	for k, v in pairs(params) do
		-- is valid key
		assert(DEFAULT_MEMORY_POOL_SIZES[k], logger:error("Unexpected key, got " .. k))
		
		-- value is a number
		assert(type(v) == "number", logger:error("Expected number, got " .. type(v) .. " for " .. k))
		
		-- if cloths, add the default value to account for heroes
		if k == "cloths" then validParams[k] = v + DEFAULT_MEMORY_POOL_SIZES.cloths
		
		-- if flyers, add the default value to account for rocket upgrade
		elseif k == "flyers" then validParams[k] = v + DEFAULT_MEMORY_POOL_SIZES.flyers
		
		-- else save value
		else validParams[k] = v end
	end

	-- apply default values if key is missing
	for k, defaultValue in pairs(DEFAULT_MEMORY_POOL_SIZES) do
		if not validParams[k] then
			-- notify of default
			logger:notice("Expected value for key " .. k .. ", got nil. Defaulting " .. k .. " to " .. defaultValue)
			
			-- apply default value
			validParams[k] = defaultValue
		end
	end
	
	-- special case for soldier animations
	if params.SoldierAnimations then
		assert(type(params.soldierAnimations) == "number" , logger:error("Expected number, got " .. type(params.soldierAnimations) .. " for soldierAnimations"))
		validParams.soldierAnimations = params.soldierAnimations
	else
		-- soldier animations is a function of the total units
		validParams.soldierAnimations = (ANIMATIONS_PER_UNIT * validParams.totalUnits)
	end
	
	return validParams
end

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   JEDI MEMORY POOL   --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setJediMemoryPoolSize
-- PURPOSE:     Set the memory pool size for jedi (and melee units)
-- INPUT:		jedi
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function memorypool.setJediMemoryPoolSize(jedi)
	-- calculate memory pool size
	local combo = jedi*COMBO_FACTOR
	local comboState = combo*COMBO_STATE_FACTOR
	local comboTransition = comboState*COMBO_TRANSITION_FACTOR
	local comboCondition = comboState*COMBO_CONDITION_FACTOR
	local comboAttack = combo*COMBO_ATTACK_FACTOR
	local comboDamageSample = comboAttack*COMBO_DAMAGE_SAMPLE_FACTOR
	local comboDeflect = combo*COMBO_DEFLECT_FACTOR	
	
	-- set memory pool
	SetMemoryPoolSize("Combo", combo) --  one per unit that uses a combo/melee weapon
    SetMemoryPoolSize("Combo::State", comboState) -- one per state in each combo file per unit
    SetMemoryPoolSize("Combo::Transition", comboTransition) -- one per transition in each combo file per unit
    SetMemoryPoolSize("Combo::Condition", comboCondition) -- one per condition in each combo file per unit
    SetMemoryPoolSize("Combo::Attack", comboAttack) -- one per attack in each combo file per unit
    SetMemoryPoolSize("Combo::DamageSample", comboDamageSample) -- setting too low results in melee attacks not dealing damage
    SetMemoryPoolSize("Combo::Deflect", comboDeflect) -- one per deflect in each combo file per unit
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   MAP MEMORY POOL   ---------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setMapMemoryPool
-- PURPOSE:     Set the memory pool size for all common map features
-- INPUT:		params{hints, obstacles, 
--					   lights, redOmniLights,
--					   treeGridStack}
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function memorypool.setMapMemoryPool(params)
	-- set memory pool
	SetMemoryPoolSize("Asteroid", params.asteroids) -- amount of asteroids used to fill asteroid paths and regions
	SetMemoryPoolSize("BaseHint", params.hints) -- one per hint node placed on the map
	SetMemoryPoolSize("EntityLight", params.lights) -- one per light ODF used on the map
	SetMemoryPoolSize("Obstacle", params.obstacles) -- one per AI barrier placed on the map
	SetMemoryPoolSize("PathNode", constants.getMaxPathNodes()) -- one per path node placed on the map (hard limit by game)
	SetMemoryPoolSize("RedOmniLight", params.redOmniLights) -- one per red omni light ODF used on the map
	SetMemoryPoolSize("TreeGridStack", params.treeGridStack) -- on per unit, object, etc. that is collidable
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   SOUND MEMORY POOL   -------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setSoundMemoryPoolSize
-- PURPOSE:     Set the memory pool size for all things audio related
-- INPUT:		params{music, soundSpace,
--					   soundStatic, soundStream}
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function memorypool.setSoundMemoryPoolSize(params)
	-- set memory pool
	SetMemoryPoolSize("EntitySoundStatic", params.soundStatic)	
    SetMemoryPoolSize("EntitySoundStream", params.soundStream)
	SetMemoryPoolSize("Music", params.music)
	SetMemoryPoolSize("SoundSpaceRegion", params.soundSpace)
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   UNIT MEMORY POOL   --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setAIMemoryPoolSize
-- PURPOSE:     Set the memory pool size for AI units
-- INPUT:		totalUnits, totalAIVehicles
-- OUTPUT:
-- NOTES:       Total units across all teams including locals. Vehicles 
--				with build-in AI like the turrets in the Mygeeto campaign 
--				mission would count toward `totalAIVehicles`, NOT 
--				`totalUnits`. Otherwise, more weapons etc. may be 
--				estimated than necessary.
---------------------------------------------------------------------------
local function setAIMemoryPoolSize(totalUnits, totalAIVehicles)
	-- set memory pool size
	SetMemoryPoolSize("Navigator", totalUnits + totalAIVehicles) -- possibly one per unit, but could be lower
	SetMemoryPoolSize("PathFollower", totalUnits + totalAIVehicles) -- one per entity following a path
	SetMemoryPoolSize("UnitAgent", totalUnits + totalAIVehicles) -- possibly one per unit, but could be higher
	SetMemoryPoolSize("UnitController", totalUnits + totalAIVehicles) -- possibly one per unit, but could be higher
end


---------------------------------------------------------------------------
-- FUNCTION:    setUnitAnimationMemoryPoolSize
-- PURPOSE:     Set the memory pool size for unit animations
-- INPUT:		soldierAnimations, cloths, tentacles, gungans, wookiees
-- OUTPUT:
-- NOTES:       Total units across all teams including locals. Tentacles
--				from Gungans and Wookiees will be estiamted based on stock 
--				rates. The value of `tentacles` is IN ADDITION TO the
--				tentacles estimated from Gungans and Wookiees. 
---------------------------------------------------------------------------
local function setUnitAnimationMemoryPoolSize(soldierAnimations, cloths, 
											  tentacles, gungans, wookiees)
	-- add stock tenticles
	if gungans then
		tentacles = tentacles + (TENTACLES_PER_GUNGAN * gungans)
	end
	if wookiees then
		tentacles = tentacles + (TENTACLES_PER_WOOKIEE * wookiees)
	end

	-- set memory pool
	SetMemoryPoolSize("EntityCloth", cloths) -- animated capes and other fabric
	SetMemoryPoolSize("SoldierAnimation", soldierAnimations) -- total animations loaded across all units
	SetMemoryPoolSize("TentacleSimulator", tentacles) -- one per tentacle (wookies have 4)
end


---------------------------------------------------------------------------
-- FUNCTION:    setUnitMemoryPoolSize
-- PURPOSE:     Set the memory pools for AI units
-- INPUT:		params{totalUnits, totalAIVehicles,
--					   soldierAnimations, 
--					   cloths, tentacles, 
--					   gungans, wookiees}
-- OUTPUT:
-- NOTES:       Total units across all teams including locals.
---------------------------------------------------------------------------
function memorypool.setUnitMemoryPoolSize(params)
	-- AI memory pool
	setAIMemoryPoolSize(params.totalUnits, params.totalAIVehicles)
	
	-- unit animation memory pool
	setUnitAnimationMemoryPoolSize(params.soldierAnimations, params.cloths,
								   params.tentacles, params.gungans, params.wookiees)
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   WALKER MEMORY POOL   ------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setFlyerMemoryPoolSize
-- PURPOSE:     Set the memory pool size for flyers
-- INPUT:		flyers, commandFlyers 
-- OUTPUT:
-- NOTES:       The value of `flyers` is EXCLUSIVE of `commandFlyers`.
---------------------------------------------------------------------------
local function setFlyerMemoryPoolSize(flyers, commandFlyers)	
	-- set memory pool
	SetMemoryPoolSize("EntityFlyer", flyers)
	SetMemoryPoolSize("CommandFlyer", commandFlyers)
end


---------------------------------------------------------------------------
-- FUNCTION:    setHoverMemoryPoolSize
-- PURPOSE:     Set the memory pool size for hover tanks and speeder
-- INPUT:		hovers, commandHovers 
-- OUTPUT:
-- NOTES:       The value of `hovers` is EXCLUSIVE of `commandHovers`.
---------------------------------------------------------------------------
local function setHoverMemoryPoolSize(hovers, commandHovers)
	-- set memory pool
	SetMemoryPoolSize("EntityHover", hovers)
	SetMemoryPoolSize("CommandHover", commandHovers)	
end


---------------------------------------------------------------------------
-- FUNCTION:    setWalkerMemoryPoolSize
-- PURPOSE:     Set the memory pool size for walkes and droidekas
-- INPUT:		droidekas, onePair, twoPair, threePair, commandWalkers
-- OUTPUT:		walkers
-- NOTES:       The value of a leg pair is INCLUSIVE of `commandWalkers`. 
--				I.e. if you have one AT-TE, then `threePair = 1` AND 
--				`commandWalkers = 1`. The value of `walkers` is the sum of 
--				the three leg pairs.
---------------------------------------------------------------------------
local function setWalkerMemoryPoolSize(droidekas, onePair, twoPair, threePair, commandWalkers)	
	-- total walkers (excluding droidekas)
	local walkers = onePair + twoPair + threePair
	
	-- add walkers
	ClearWalkers()
	SetMemoryPoolSize("EntityWalker", -commandWalkers) -- trick to prevent extra walker entities
	AddWalkerType(0, droidekas)	-- droidekas (special case: 0 leg pairs)
	AddWalkerType(1, onePair)	-- 1x2 (1 pair of legs)
	AddWalkerType(2, twoPair)	-- 2x2 (2 pairs of legs)
	AddWalkerType(3, threePair)	-- 3x2 (3 pairs of legs)
	
	-- set memory pool
	SetMemoryPoolSize("CommandWalker", commandWalkers) -- number of ATTEs or ATATs
	SetMemoryPoolSize("EntityDroideka", droidekas) -- number od droidekas
	
	return walkers
end


---------------------------------------------------------------------------
-- FUNCTION:    setTurretMemoryPoolSize
-- PURPOSE:     Set the memory pool size for turrets and estimate total 
--				turrets from vehicles
-- INPUT:		turrets, additionalVehicleTurrets,
--				flyers, hovers, walkers,
--				commandFlyers, commandHovers, commandWalkers
-- OUTPUT:		totalTurrets
-- NOTES:       The value of `additionalVehicleTurrets` is EXCLUSIVE of 
--				`turrets`. It should be used for instances where a vehicle
--				has extra turrets than what is estimated.
---------------------------------------------------------------------------
local function setTurretMemoryPoolSize(turrets, additionalVehicleTurrets, 
									   flyers, hovers, walkers,
									   commandFlyers, commandHovers, commandWalkers)	
	-- sum vehicle turret
	local totalTurrets	= turrets + additionalVehicleTurrets
	totalTurrets = sumItems(totalTurrets, TURRETS_PER_FLYER, flyers)
	totalTurrets = sumItems(totalTurrets, TURRETS_PER_HOVER, hovers)
	totalTurrets = sumItems(totalTurrets, TURRETS_PER_WALKER, walkers)
	
	-- sum command vehicle turrets
	totalTurrets = sumItems(totalTurrets, TURRETS_PER_COMMAND_FLYER, commandFlyers)
	totalTurrets = sumItems(totalTurrets, TURRETS_PER_COMMAND_HOVER, commandHovers)
	totalTurrets = sumItems(totalTurrets, TURRETS_PER_COMMAND_WALKER, commandWalkers)
	
	-- set memory pool
	SetMemoryPoolSize("MountedTurret", totalTurrets) -- one per turret and vehicle passenger slot weapon	
	
	local logMsg = "Estimated " .. totalTurrets .. " turrets from " .. flyers .. " flyers, "
	logMsg = logMsg .. hovers .. " hovers, " .. turrets .. " turrets, " .. walkers
	logMsg = logMsg .. " walkers, and " .. additionalVehicleTurrets
	logMsg = logMsg .. " additional vehicle turrets were added to the memory pool"
	logger:info(logMsg)
	
	return totalTurrets
end


---------------------------------------------------------------------------
-- FUNCTION:    setVehicleMemoryPoolSize
-- PURPOSE:     Set the memory pool size for vehicles
-- INPUT:		params = {flyers, commandFlyers,
--						  hovers, commandHovers,
--						  turrets, additionalVehicleTurrets,
--						  droidekas, onePair, twoPair, threePair, 
--						  commandWalkers} 
-- OUTPUT:		totalVehicles, vehicles
-- NOTES:       The value of `totalVehicles` is the sum of all vehicle 
--				types and turrets. The value of `vehicles` is a table with 
--				the sume of each vehicle type listed separately. Should be 
--				called before `setWeaponMemoryPoolSize()`, otherwise, 
--				weapon estimates may be inaccurate.
---------------------------------------------------------------------------
function memorypool.setVehicleMemoryPoolSize(params)
	-- check if weapon pool has already been set
	assert(not isWeaponsSet, logger:error("setWeaponMemoryPoolSize() was called before setVehicleMemoryPoolSize()"))
	
	
	------------------------------------------------
	------------   PARAMETERS   --------------------
	------------------------------------------------
	
	local flyers, commandFlyers = params.flyers, params.commandFlyers
	local hovers, commandHovers = params.hovers, params.commandHovers
	local droidekas = params.droidekas
	local onePair, twoPair, threePair = params.onePair, params.twoPair, params.threePair
	local commandWalkers = params.commandWalkers
	local turrets, additionalVehicleTurrets = params.turrets, params.additionalVehicleTurrets
	
	
	------------------------------------------------
	------------   SET MEMORY POOL   ---------------
	------------------------------------------------

	-- flyers	
	setFlyerMemoryPoolSize(flyers, commandFlyers)
	
	-- hovers
	setHoverMemoryPoolSize(hovers, commandHovers)
	
	-- walkers
	local walkers = setWalkerMemoryPoolSize(droidekas, 
											onePair, twoPair, threePair, 
											commandWalkers)
	
	-- turrets
	local totalTurrets = setTurretMemoryPoolSize(turrets, additionalVehicleTurrets,
												 flyers, hovers, walkers, 
												 commandFlyers, commandHovers, commandWalkers)
	
	
	------------------------------------------------
	------------   COUNT TOTAL VEHICLES   ----------
	------------------------------------------------
	
	-- total vehicles across all types
	local totalCommandVehicles = commandFlyers + commandHovers + commandWalkers
	local totalVehicles = flyers + hovers + (droidekas + walkers) + totalTurrets + totalCommandVehicles
	
	-- number of vehicles in each category
	local vehicles = {totalFlyers = flyers + commandFlyers,
					  totalHovers = hovers + commandHovers,
					  totalTurrets = totalTurrets,
					  totalWalkers = droidekas + walkers + commandWalkers}

	return totalVehicles, vehicles
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   WEAPON MEMORY POOL   ------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setWeaponMemoryPoolSize
-- PURPOSE:     Set the memory for weapons
-- INPUT:		totalUnits, totalAIVehicles, 
--				totalVehicles, vehicles,
--				params{mines, portableTurrets} 
-- OUTPUT:
-- NOTES:       Counts up all weapons saved to local memory. This function 
--				should be calld last. Total weapons is estimated based on 
--				maximum allowed values for units and vehicles by the game.
--				`vehicles` is a table with the sum of each vehicle type.
---------------------------------------------------------------------------
function memorypool.setWeaponMemoryPoolSize(totalUnits, totalAIVehicles, totalVehicles, vehicles, params)		
	-- localize totalVehicleWeapons
	local totalVehicleWeapons = 0
	
	-- total flyer weapons
	totalVehicleWeapons = sumItems(totalVehicleWeapons, 
								   constants.getMaxVehicleWeaponsPerSeat(), 
								   vehicles.totalFlyers)
	-- total hover weapons
	totalVehicleWeapons = sumItems(totalVehicleWeapons, 
								   constants.getMaxVehicleWeaponsPerSeat(), 
								   vehicles.totalHovers)
	
	-- total turret weapons
	totalVehicleWeapons = sumItems(totalVehicleWeapons, 
								   constants.getMaxVehicleWeaponsPerSeat(), 
								   vehicles.totalTurrets)
	
	-- total walker weapons
	totalVehicleWeapons = sumItems(totalVehicleWeapons, 
								   constants.getMaxVehicleWeaponsPerSeat(), 
								   vehicles.totalWalkers)

	-- total unit weapons
	local totalUnitWeapons = totalUnits * constants.getMaxWeaponsPerUnit()

	-- sum weapons
	local totalWeapons = totalUnitWeapons + totalVehicleWeapons
	
	-- set memory pool
	SetMemoryPoolSize("Aimer", totalUnits + totalVehicleWeapons) -- one per unit, possible more than one per vehicle 
																 -- (assume each vehicle weapon has its own aimer)
	SetMemoryPoolSize("AmmoCounter", totalUnits + totalAIVehicles) --  one per entity that has a weapon
	SetMemoryPoolSize("EnergyBar", totalUnits + totalVehicles) -- one per unit and turret/vehicle/vehicle position
	SetMemoryPoolSize("EntityMine", params.mines) -- one per mine that can be placed
	SetMemoryPoolSize("EntityPortableTurret", params.portableTurrets) -- one per each PortableTurret class
	SetMemoryPoolSize("OrdnanceTowCable", params.towCables) --  one per tow cable weapon used
	SetMemoryPoolSize("Weapon", totalWeapons) -- one per weapon used per unit, vehicle, and turret
	
	local logMsg = "Estimated " .. totalWeapons .. " weapons from " .. totalUnits .. " units and "
	logMsg = logMsg .. totalVehicles .. " vehicles were added to the memory pool"
	logger:info(logMsg)
	
	isWeaponPoolSet = true
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   MEMORY POOL   -------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setGameModeMemoryPoolSize
-- PURPOSE:     Set game mode memory pool size
-- INPUT:		 
-- OUTPUT:
-- NOTES:       Automatically determines the game mode base on what has
--				been loaded into memory.
---------------------------------------------------------------------------
function memorypool.setGameModeMemoryPoolSize()	
	local function objectiveDetected(objective)
		logger:info("memorypool.lua detected objective: " .. objective)
	end
	
	-- flags for ctf
	local flags = 0
	
	-- conquest
	if ObjectiveConquest then
		objectiveDetected("ObjectiveConquest")
	end
	
	-- 1-flag CTF
	if ObjectiveOneFlagCTF then
		objectiveDetected("ObjectiveOneFlagCTF")
		
		flags = constants.getNumFlagsOneFlag()
	end
	
	-- 2-flag CTF
	if ObjectiveCTF then
		objectiveDetected("ObjectiveCTF")
		
		flags = constants.getNumFlagsCTF()
	end
	
	-- team deathmatch / hunt
	if ObjectiveTDM then
		objectiveDetected("ObjectiveTDM")
	
		-- no heroes in tdm / hunt
		DEFAULT_MEMORY_POOL_SIZES.jedi = 0
		DEFAULT_MEMORY_POOL_SIZES.cloths = 0
	end
	
	-- set memory pool
	SetMemoryPoolSize("FlagItem", flags)
end


---------------------------------------------------------------------------
-- FUNCTION:    setMemoryPoolSize
-- PURPOSE:     Set the memory pool size
-- INPUT:		params{
--					jedi,
--				-- map
--					hints, obstacles, 
--					lights, redOmniLights,
--					treeGridStack,
-- 				-- sounds
--					music, soundSpace,
--					soundStatic, soundStream,
--				-- units
--					totalUnits, totalAIVehicles,
--					soldierAnimations, 
--					cloths, tentacles, 
--					gungans, wookiees,
--				-- vehicles
--					flyers, commandFlyers,
--					hovers, commandHovers,
--					turrets, additionalVehicleTurrets,
--					droidekas, onePair, twoPair, threePair, 
--					commandWalkers,
--				-- weapons
--					mines, portableTurrets,
--					towCables
--				} 
-- OUTPUT:
-- NOTES:       All parameters are optional. Default values will be used if 
--				nothing is passed.
---------------------------------------------------------------------------
function memorypool:init(params)
	assert(not self.initialized, logger:error(self.name .. " has already been initialized"))

	-- game mode
	self.setGameModeMemoryPoolSize()

	-- validate parameters and apply defaults to missing ones
	local validParams = validateParameters(params)

	-- jedi
	self.setJediMemoryPoolSize(validParams.jedi)
	
	-- map
	self.setMapMemoryPool(validParams)
	
	-- sounds
	self.setSoundMemoryPoolSize(validParams)
	
	-- units
	self.setUnitMemoryPoolSize(validParams)
	
	-- vehicles
	local totalVehicles, vehicles = self.setVehicleMemoryPoolSize(validParams)
	
	-- weapons
	self.setWeaponMemoryPoolSize(validParams.totalUnits, validParams.totalAIVehicles, totalVehicles, vehicles, validParams)	

	self.initialized = true
end


-- import function
function get_memorypool()
	return memorypool
end
