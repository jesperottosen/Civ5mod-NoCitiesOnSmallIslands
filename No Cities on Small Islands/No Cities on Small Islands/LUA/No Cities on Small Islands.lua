-- No Cities on Small Islands
-- Author: yepzer
-- DateCreated: 8/31/2025 5:21:44 PM
--------------------------------------------------------------
--------------------------------------------------------------
print("Loaded OK")
local cMAX_WATERTILES = 3

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


--------------------------------------------------------------
function NCoSI_CanFoundCity(iPlayer,iX,iY)
	print("CanFound")
	
	-- Initialize --
	local pPlot = Map.GetPlot(iX,iY)
	if not pPlot then return false end
	if (pPlot:IsCity()) then return false end

	--- evaluate
	local result = 6


	--- return
	return (result > cMAX_WATERTILES)
end

--------------------------------------------------------------
GameEvents.PlayerCanFoundCity.Add( NCoSI_CanFoundCity )
