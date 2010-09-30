////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Base                                       //
////////////////////////////////////////////////

-- Added due to callback problems with the cvars lib.
if not PROXI__CALLBACK_FUNC then
	PROXI__CALLBACK_FUNC = {}
	
end




function proxi:IsEnabled()
	-- Security for external apps.
	return (self or proxi).GetVar("proxi_core_enable") > 0

end

function proxi.QuickThink()
	proxi:UpdateBeacons()

end

function proxi.RevertAddon()
	for sSubFix,tCvarGroup in pairs( proxi.cvarGroups ) do
		proxi.Util_RestoreCvars( tCvarGroup, "proxi_" .. sSubFix .. "_" )
		
	end
	
end

function proxi.RevertDesign()
	proxi.Util_RestoreCvars( proxi.cvarGroups.uidesign, "proxi_uidesign_" )
	
end

function proxi.Mount()
	print("")
	print("[ Mounting " .. PROXI_NAME .. " ... ]")
	
	proxi.dat = {}
	proxi.cvarGroups = {}
	proxi.cvarGroups.core   = {}
	proxi.cvarGroups.global   = {}
	proxi.cvarGroups.regmod   = {}
	proxi.cvarGroups.uidesign   = {}
	
	proxi.Util_AppendCvar( proxi.cvarGroups.core, "enable", "1")
	proxi.Util_AppendCvar( proxi.cvarGroups.global, "finderdistance", "8192")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "xrel", "0.2")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "yrel", "0.2")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "size", "172")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "fov", "45")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "radius", "2048")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "angle", "50")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "pitchdyn", "2")
	proxi.Util_AppendCvar( proxi.cvarGroups.uidesign, "ringcolor", {147, 201, 224, 255}, "color" )
	proxi.Util_AppendCvar( proxi.cvarGroups.uidesign, "backcolor", {32, 37, 43, 128}, "color" )
	
	for sSubFix,tCvarGroup in pairs( proxi.cvarGroups ) do
		proxi.Util_BuildCvars( tCvarGroup, "proxi_" .. sSubFix .. "_" )
		
	end
	
	if not PROXI__CALLBACK_FUNC["proxi_core_enable"] then
		cvars.AddChangeCallback( "proxi_core_enable" , function( sCvar, prev, new )
			if not proxi then return end
			if (tonumber( new ) <= 0 and tonumber( prev ) <= 0) or (tonumber( new ) > 0 and tonumber( prev ) > 0) then return end
			
			if tonumber( new ) > 0 then
				proxi:MountBeacons()
			
			else
				proxi:UnmountBeacons()
				
			end
			
		end)
		
		PROXI__CALLBACK_FUNC["proxi_core_enable"] = true
		
	end
	
	hook.Add( "Think", "proxi.QuickThink", proxi.QuickThink )
	hook.Add( "HUDPaint", "proxi.HUDPaint", proxi.HUDPaint )
	
	if proxi.MountMenu then
		proxi.MountMenu()
	end
	
	proxi:RemoveAllPhysicalTags()
	proxi:MountBeacons( )

	print("[ " .. PROXI_NAME .. " is now mounted. ]")
	print("")
	
end

function proxi.Unmount()
	print("")
	print("] Unmounting " .. PROXI_NAME .. " ... [")

	local bOkay, strErr = pcall(function()
		-- Insert parachute Unmount
		
		proxi_simmap = nil
		hook.Remove( "HUDPaint", "proxi.HUDPaint" )
		hook.Remove( "Think", "proxi.QuickThink" )
		
		if proxi.UnmountMenu then
			proxi.UnmountMenu()
		end
		
	end)
	if not bOkay then
		print("[<<< " .. PROXI_NAME .. " failed to unmount properly : " .. tostring(strErr) .. " ]")
		
	end
	
	proxi = nil
	
	print("[ " .. PROXI_NAME .. " is now unmounted. ]")
	print("")
	
end


