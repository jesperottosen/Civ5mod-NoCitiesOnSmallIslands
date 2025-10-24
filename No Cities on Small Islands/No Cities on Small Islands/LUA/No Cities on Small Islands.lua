-- No Cities on Small Islands
-- Author: yepzer
-- DateCreated: 8/31/2025 5:21:44 PM
--------------------------------------------------------------
--------------------------------------------------------------
print("Loaded OK")

--------------------------------------------------------------
function bool2string(bBool) 
	if (bBool) then return "OK" end
	return "Not OK"
end

--------------------------------------------------------------
function CountIfWater(pPlot)
	if pPlot:IsWater() then return 1 end
	return 0
end

function CountAroundXY(iX,iY)
	-- initialize
	local iEast2 = CountIfWater(Map.PlotDirection(iX,iY,DirectionTypes["DIRECTION_EAST"]))
	local iWest2 = CountIfWater(Map.PlotDirection(iX,iY,DirectionTypes["DIRECTION_WEST"]))
	local iNorthEast2 = CountIfWater(Map.PlotDirection(iX,iY,DirectionTypes["DIRECTION_NORTHEAST"]))
	local iNorthWest2 = CountIfWater(Map.PlotDirection(iX,iY,DirectionTypes["DIRECTION_NORTHWEST"]))
	local iSouthEast2 = CountIfWater(Map.PlotDirection(iX,iY,DirectionTypes["DIRECTION_SOUTHEAST"]))
	local iSouthWest2 = CountIfWater(Map.PlotDirection(iX,iY,DirectionTypes["DIRECTION_SOUTHWEST"]))

	-- print("CountAroundXY:  "..iNorthWest2.." "..iNorthEast2)
	-- print("CountAroundXY: "..iWest2.." X "..iEast2)
	-- print("CountAroundXY:  "..iSouthWest2.." "..iSouthEast2)

	-- evaluate
	return iEast2 + iWest2 + iNorthEast2 + iNorthWest2 + iSouthEast2 + iSouthWest2
end


--------------------------------------------------------------
function WaterInNextRing2(PlotA, PlotB) 
	-- Initialize --
	local iAx = PlotA:GetX()
	local iAy = PlotA:GetY()
	local iBx = PlotB:GetX()
	local iBy = PlotB:GetY()

	-- Execute
	local iAcount = CountAroundXY(iAx,iAy)
	local iBcount = CountAroundXY(iBx,iBy)

	-- evalutate
	local bResult = ((iAcount < 4) and (iBcount < 4))
	-- print ("WaterInNextRing2: "..iAcount.." "..iBcount..": "..bool2string(bResult))

	-- return
	return bResult
end

--------------------------------------------------------------
function WaterInNextRing3(PlotA, PlotB, PlotC) 
	-- Initialize --
	local iAx = PlotA:GetX()
	local iAy = PlotA:GetY()
	local iBx = PlotB:GetX()
	local iBy = PlotB:GetY()
	local iCx = PlotC:GetX()
	local iCy = PlotC:GetY()

	-- Execute
	local iAcount = CountAroundXY(iAx,iAy)
	local iBcount = CountAroundXY(iBx,iBy)
	local iCcount = CountAroundXY(iCx,iCy)

	-- evaluate
	local bResult = ((iAcount < 4) and (iBcount < 4) and (iCcount < 4))
	-- print ("WaterInNextRing3: "..iAcount.." "..iBcount.." "..iCcount..": "..bool2string(bResult))

	-- return
	return bResult
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

	-- print("WaterResults1:  "..iNorthWest.." "..iNorthEast)
	-- print("WaterResults1: "..iWest.." X "..iEast)
	-- print("WaterResults1:  "..iSouthWest.." "..iSouthEast)

	--- evaluate
	if (iWaterResult == 6) then bCanFoundCity = false end
	if (iWaterResult == 5) then bCanFoundCity = false end

	if (iWaterResult == 4) then 

		-- default false at 4 water, unless specific patterns
		bCanFoundCity = false 

		-- get plot locations
		local pEast = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_EAST"])
		local pWest = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_WEST"])
		local pNorthEast = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_NORTHEAST"])
		local pNorthWest = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_NORTHWEST"])
		local pSouthEast = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_SOUTHEAST"])
		local pSouthWest = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_SOUTHWEST"])

		--  1 1
		-- 0 X 0
		--  1 1 
		if ((iEast == 0) and (iWest == 0)) then bCanFoundCity = WaterInNextRing2(pEast,pWest) end 

		--  0 1     1 1     0 1     1 1
		-- 1 X 0   1 X 0   0 X 1   0 X 1
		--  1 1     0 1     1 1     1 0
		if ((iEast == 0) and (iNorthWest == 0)) then bCanFoundCity = WaterInNextRing2(pEast,pNorthWest) end
		if ((iEast == 0) and (iSouthWest == 0)) then bCanFoundCity = WaterInNextRing2(pEast,pSouthWest) end
		if ((iWest == 0) and (iNorthEast == 0)) then bCanFoundCity = WaterInNextRing2(pWest,pNorthEast) end
		if ((iWest == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing2(pWest,pSouthEast) end

		--  1 0     0 1     1 0     0 1
		-- 1 X 1   1 X 1   1 X 1   1 X 1
		--  0 1     1 0     0 1     1 1
		if ((iNorthEast == 0) and (iSouthWest == 0)) then bCanFoundCity = WaterInNextRing2(pNorthEast,pSouthWest) end
		if ((iSouthEast == 0) and (iNorthWest == 0)) then bCanFoundCity = WaterInNextRing2(pSouthEast,pNorthWest) end
		if ((iNorthEast == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing2(pNorthEast,pSouthEast) end
		if ((iSouthWest == 0) and (iNorthWest == 0)) then bCanFoundCity = WaterInNextRing2(pSouthWest,pNorthWest) end
		
	end	

	if (iWaterResult == 3) then
		 -- default true at 3 water, unless 
		 bCanFoundCity = true 

		 -- get plot locations
		 local pEast = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_EAST"])
		 local pWest = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_WEST"])
		 local pNorthEast = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_NORTHEAST"])
		 local pNorthWest = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_NORTHWEST"])
		 local pSouthEast = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_SOUTHEAST"])
		 local pSouthWest = Map.PlotDirection(iPlotX,iPlotY,DirectionTypes["DIRECTION_SOUTHWEST"])

		 --  1 0     0 1     0 0     0 0
		 -- 1 X 1   1 X 1   1 X 1   1 X 1
		 --  0 0     0 0     0 1     1 0
		 if ((iNorthEast == 0) and (iSouthWest == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing3(pNorthEast,pSouthWest,pSouthEast) end
		 if ((iNorthWest == 0) and (iSouthWest == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing3(pNorthWest,pSouthWest,pSouthEast) end
		 if ((iSouthWest == 0) and (iNorthWest == 0) and (iNorthEast == 0)) then bCanFoundCity = WaterInNextRing3(pSouthWest,pNorthWest,pNorthEast) end
		 if ((iNorthEast == 0) and (iNorthWest == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing3(pNorthEast,pNorthWest,pSouthEast) end
		 
		 --  1 1     1 1     0 0     0 0
		 -- 1 X 0   0 X 1   0 X 1   1 X 0
		 --  0 0     0 0     1 1     1 1
		 if ((iEast == 0) and (iSouthWest == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing3(pEast,pSouthWest,pSouthEast) end
		 if ((iWest == 0) and (iSouthWest == 0) and (iSouthEast == 0)) then bCanFoundCity = WaterInNextRing3(pWest,pSouthWest,pSouthEast) end
		 if ((iWest == 0) and (iNorthWest == 0) and (iNorthEast == 0)) then bCanFoundCity = WaterInNextRing3(pWest,pNorthWest,pNorthEast) end
		 if ((iEast == 0) and (iNorthWest == 0) and (iNorthEast == 0)) then bCanFoundCity = WaterInNextRing3(pEast,pNorthWest,pNorthEast) end
	end

	if (iWaterResult == 2) then bCanFoundCity = true end
	if (iWaterResult == 1) then bCanFoundCity = true end
	if (iWaterResult == 0) then bCanFoundCity = true end

	-- return
	return bCanFoundCity
end

--------------------------------------------------------------
GameEvents.PlayerCanFoundCity.Add( onCanFoundCity )