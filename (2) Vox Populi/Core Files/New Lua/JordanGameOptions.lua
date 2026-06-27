-- ============================================================================
-- Jordan's custom game-setup options - runtime handler
--
-- Reads the three custom GameOptions defined in
--   Database Changes/Jordan/JordanGameOptions.xml
-- and applies each effect at runtime, so all three can be toggled per game from
-- the Advanced Setup screen. Loaded as an InGameUIAddin (see Vox Populi.civ5proj).
--
--   GAMEOPTION_EXTRA_PALACE_BONUSES
--       Grants BUILDING_JORDAN_PALACE_BONUS (the "Capital Bonuses" carrier building:
--       +30% worker speed, +150 happiness, +10% food) to each MAJOR civ's capital.
--       Done per-turn so it survives a new game (capitals are founded on turn 1, not
--       at game-init), a loaded save, and a capital relocation. The GetNumRealBuilding
--       guard makes it a no-op once granted, so it is cheap.
--
--   GAMEOPTION_CAPTURE_GREAT_PEOPLE
--       Captures a defeated civilian Great Person instead of killing it, via the DLL
--       GameEvents.UnitCaptureType value hook. Requires CustomModOption
--       EVENTS_UNIT_CAPTURE = 1 (set in (1) Community Patch NewCustomModOptions.xml).
--       Returning nothing falls through to the static Capture column (unset for GPs ->
--       killed), which is exactly the OFF behaviour.
--
--   GAMEOPTION_NO_FUTURISTIC_UNITS
--       Blocks training UNIT_MECH / UNIT_XCOM_SQUAD via GameEvents.CityCanTrain
--       (returning false vetoes the build for both the player and the AI).
-- ============================================================================

local bExtraPalace  = Game.IsOption("GAMEOPTION_EXTRA_PALACE_BONUSES")
local bCaptureGP    = Game.IsOption("GAMEOPTION_CAPTURE_GREAT_PEOPLE")
local bNoFuturistic = Game.IsOption("GAMEOPTION_NO_FUTURISTIC_UNITS")

print(string.format("[JordanGameOptions] ExtraPalace=%s  CaptureGP=%s  NoFuturistic=%s",
	tostring(bExtraPalace), tostring(bCaptureGP), tostring(bNoFuturistic)))

-- ----------------------------------------------------------------------------
-- Extra Palace Bonuses
-- ----------------------------------------------------------------------------
if bExtraPalace then
	local iBonusBuilding = GameInfoTypes["BUILDING_JORDAN_PALACE_BONUS"]
	if iBonusBuilding then
		local function GrantPalaceBonus(iPlayer)
			local pPlayer = Players[iPlayer]
			if pPlayer and pPlayer:IsAlive() and not pPlayer:IsMinorCiv() and not pPlayer:IsBarbarian() then
				local pCapital = pPlayer:GetCapitalCity()
				if pCapital and pCapital:GetNumRealBuilding(iBonusBuilding) == 0 then
					pCapital:SetNumRealBuilding(iBonusBuilding, 1)
				end
			end
		end
		GameEvents.PlayerDoTurn.Add(GrantPalaceBonus)
	end
end

-- ----------------------------------------------------------------------------
-- Capture Great People
-- ----------------------------------------------------------------------------
if bCaptureGP then
	local tCaptureAs = {}
	local function MapGP(fromType, toType)
		local idFrom = GameInfoTypes[fromType]
		local idTo   = GameInfoTypes[toType]
		if idFrom and idTo then tCaptureAs[idFrom] = idTo end
	end
	MapGP("UNIT_WRITER",            "UNIT_WRITER")
	MapGP("UNIT_ARTIST",            "UNIT_ARTIST")
	MapGP("UNIT_MUSICIAN",          "UNIT_MUSICIAN")
	MapGP("UNIT_SCIENTIST",         "UNIT_SCIENTIST")
	MapGP("UNIT_MERCHANT",          "UNIT_MERCHANT")
	MapGP("UNIT_ENGINEER",          "UNIT_ENGINEER")
	MapGP("UNIT_GREAT_DIPLOMAT",    "UNIT_GREAT_DIPLOMAT")
	MapGP("UNIT_VENETIAN_MERCHANT", "UNIT_MERCHANT") -- Venice's unique -> a generic Merchant for the captor

	-- iPlayer = capturing player, iUnitType = type of the unit being captured
	local function OnUnitCaptureType(iPlayer, iUnit, iUnitType, iByCiv)
		local iCaptureAs = tCaptureAs[iUnitType]
		if iCaptureAs then
			return iCaptureAs
		end
	end
	GameEvents.UnitCaptureType.Add(OnUnitCaptureType)
end

-- ----------------------------------------------------------------------------
-- No Futuristic Units
-- ----------------------------------------------------------------------------
if bNoFuturistic then
	local tBlocked = {}
	local function Block(unitType)
		local id = GameInfoTypes[unitType]
		if id then tBlocked[id] = true end
	end
	Block("UNIT_MECH")
	Block("UNIT_XCOM_SQUAD")

	local function OnCityCanTrain(iPlayer, iCity, iUnitType)
		if tBlocked[iUnitType] then
			return false
		end
		return true
	end
	GameEvents.CityCanTrain.Add(OnCityCanTrain)
end
