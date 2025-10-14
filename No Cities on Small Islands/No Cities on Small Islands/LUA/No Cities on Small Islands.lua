-- No Cities on Small Islands
-- Author: yepzer
-- Original PlotMath by connan.morris
-- DateCreated: 8/31/2025 5:21:44 PM
--------------------------------------------------------------
--------------------------------------------------------------
print("Loaded OK")

--------------------------------------------------------------
-- connan.morris: Methods for finding plots in any direction from a given plot
PlotMath = {};

	function PlotMath.isEvenRow(yPosition)
		if yPosition == 0 or math.fmod(yPosition,2) == 0 then
			return true
		end
		return false
	end

	function PlotMath.getHexNorthWest(position)
		local newPosition = {}
		newPosition.xPosition = position.xPosition
		newPosition.yPosition = position.yPosition + 1

		if PlotMath.isEvenRow(position.yPosition) == true then
			newPosition.xPosition = newPosition.xPosition - 1
		end
		return newPosition
	end

	function PlotMath.getHexNorthEast(position)
		local newPosition = {}
		newPosition.xPosition = position.xPosition
		newPosition.yPosition = position.yPosition + 1

		if PlotMath.isEvenRow(position.yPosition) == false then
			newPosition.xPosition = newPosition.xPosition + 1
		end
		return newPosition
	end

	function PlotMath.getHexSouthWest(position)
		local newPosition = {}
		newPosition.xPosition = position.xPosition 
		newPosition.yPosition = position.yPosition - 1

		if PlotMath.isEvenRow(position.yPosition) == true then
			newPosition.xPosition = newPosition.xPosition - 1
		end
		return newPosition
	end

	function PlotMath.getHexSouthEast(position)
		local newPosition = {}
		newPosition.xPosition = position.xPosition
		newPosition.yPosition = position.yPosition - 1

		if PlotMath.isEvenRow(position.yPosition) == false then
			newPosition.xPosition = newPosition.xPosition + 1
		end
		return newPosition
	end

	function PlotMath.getHexEast(position)
		local newPosition = {}
		newPosition.xPosition = position.xPosition + 1
		newPosition.yPosition = position.yPosition
		return newPosition
	end

	function PlotMath.getHexWest(position)
		local newPosition = {}
		newPosition.xPosition = position.xPosition - 1
		newPosition.yPosition = position.yPosition
		return newPosition
	end

--------------------------------------------------------------
function CountPlotWater(plot)
	print("CountPlotWater: ")
	if (plot:IsWater() or plot:IsFreshWater()) then return 1 end
	return 0
end

--------------------------------------------------------------
function onCanFoundCity(iPlayer,iPlotX,iPlotY)
	print("onCanFoundCity: ")
	
	-- Initialize --
	local pPlot = Map.GetPlot(iPlotX,iPlotY)
	if not pPlot then return false end
	if (pPlot:IsCity()) then return false end
	if (pPlot:IsWater()) then return false end
	if (pPlot:IsFreshWater()) then return false end

	print("onCanFoundCity: count")
	--- count water around plot
	local ee = CountPlotWater(PlotMath.getHexEast(pPlot))
	local ww = CountPlotWater(PlotMath.getHexWest(pPlot))
	local nw = CountPlotWater(PlotMath.getHexNorthWest(pPlot))
	local ne = CountPlotWater(PlotMath.getHexNorthEast(pPlot))
	local sw = CountPlotWater(PlotMath.getHexSouthWest(pPlot))
	local se = CountPlotWater(PlotMath.getHexSouthEast(pPlot))
	local result = ee + ww + nw + ne + sw + se

	print("onCanFoundCity: eval")
	--- evaluate
	if (result == 0) then return false end
	if (result == 1) then return false end
	if (result == 2) then
		if ((ee == 1) and (ww == 1)) then return true end
		if ((sw == 1) and (ne == 1)) then return true end
		if ((se == 1) and (nw == 1)) then return true end
		return false
	end
	if (result == 3) then return true end
	if (result == 4) then return true end
	if (result == 5) then return true end
	if (result == 6) then return true end
end

--------------------------------------------------------------
GameEvents.PlayerCanFoundCity.Add( onCanFoundCity )