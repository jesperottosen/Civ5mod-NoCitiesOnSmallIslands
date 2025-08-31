-- No Cities on Small Islands
-- Author: yepzer
-- DateCreated: 8/31/2025 5:21:44 PM
--------------------------------------------------------------
--------------------------------------------------------------
print("Loaded OK")

function NCoSI_CanFoundCity(iPlayer, iPlotX, iPlotY) 
	return true
end

--------------------------------------------------------------
GameEvents.PlayerCanFoundCity.Add( NCoSI_CanFoundCity(iPlayer, iPlotX, iPlotY) )