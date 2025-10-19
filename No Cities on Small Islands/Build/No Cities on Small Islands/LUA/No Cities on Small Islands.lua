-- No Cities on Small Islands
-- Author: yepzer
-- DateCreated: 8/31/2025 5:21:44 PM
--------------------------------------------------------------
--------------------------------------------------------------
print("Loaded OK")

--------------------------------------------------------------
function CountIfWater(pPlot)
	if pPlot:IsWater() then return 1 end
	return 0
end

--------------------------------------------------------------
function onCanFoundCity(iPlayer,iPlotX,iPlotY)
	
	-- Polynesia get to settle on islands 
	if (Game.GetActiveCivilizationType() == GameInfoTypes["CIVILIZATION_POLYNESIA"]) then return true end

	-- Initialize --
	local iEast = CountIfWater(Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_EAST"]))
	local iWest = CountIfWater(Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_WEST"]))
	local iNorthEast = CountIfWater(Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_NORTHEAST"]))
	local iNorthWest = CountIfWater(Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_NORTHWEST"]))
	local iSouthEast = CountIfWater(Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_SOUTHEAST"]))
	local iSouthWest = CountIfWater(Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_SOUTHWEST"]))
	local iWaterResult = iEast + iWest + iNorthEast + iNorthWest + iSouthEast + iSouthWest
	local bCanFoundCity = true

	-- print("onCanFoundCity WaterResults:  "..iNorthWest.." "..iNorthEast)
	-- print("onCanFoundCity WaterResults: "..iWest.." * "..iEast)
	-- print("onCanFoundCity WaterResults:  "..iSouthWest.." "..iSouthEast)

	--- evaluate
	if (iWaterResult == 6) then bCanFoundCity = false end
	if (iWaterResult == 5) then bCanFoundCity = false end
	if (iWaterResult == 4) then 
		-- default false at 4, unless specific patterns
		bCanFoundCity = false 

		-- -*-
		if ((iEast == 0) and (iWest == 0)) then bCanFoundCity = true end 

		--  \*- /*- -*/ -*\
		if ((iEast == 0) and (iNorthWest == 0)) then bCanFoundCity = true end
		if ((iEast == 0) and (iSouthhWest == 0)) then bCanFoundCity = true end
		if ((iWest == 0) and (iNorthEast == 0)) then bCanFoundCity = true end
		if ((iWest == 0) and (iSouthEast == 0)) then bCanFoundCity = true end

		--  / \   \  / 
		-- /   \  /  \
		if ((iNorthEast == 0) and (iSouthWest == 0)) then bCanFoundCity = true end
		if ((iSouthEast == 0) and (iNorthWest == 0)) then bCanFoundCity = true end
		if ((iNorthEast == 0) and (iSouthEast == 0)) then bCanFoundCity = true end
		if ((iSouthWest == 0) and (iNorthWest == 0)) then bCanFoundCity = true end
		
	end	
	if (iWaterResult == 3) then bCanFoundCity = true end
	if (iWaterResult == 2) then bCanFoundCity = true end
	if (iWaterResult == 1) then bCanFoundCity = true end
	if (iWaterResult == 0) then bCanFoundCity = true end

	return bCanFoundCity
end

--------------------------------------------------------------
GameEvents.PlayerCanFoundCity.Add( onCanFoundCity )