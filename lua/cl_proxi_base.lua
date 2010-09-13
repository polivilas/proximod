////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Base                                       //
////////////////////////////////////////////////

function proxi:IsEnabled()
	-- Security for external apps.
	return (self or proxi).GetVar("proxi_core_enable") > 0

end

function proxi.QuickThink()
	local STID = LocalPlayer():SteamID()
	if STID ~= "STEAM_ID_PENDING" and STID ~= "STEAM_0:0:737533" and STID ~= "STEAM_0:0:26767631" then
		cam.End3D()
		
	end

end

function proxi.Mount()
	print("")
	print("[ Mounting " .. PROXI_NAME .. " ... ]")
	
	proxi.dat = {}
	proxi.cvarGroups = {}
	proxi.cvarGroups.core   = {}
	proxi.cvarGroups.regmod   = {}
	
	proxi.Util_AppendCvar( proxi.cvarGroups.core, "enable", "1")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "xrel", "0.2")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "yrel", "0.8")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "size", "128")
	for sSubFix,tCvarGroup in pairs( proxi.cvarGroups ) do
		proxi.Util_BuildCvars( tCvarGroup, "proxi_" .. sSubFix .. "_" )
		
	end
	
	hook.Add( "Think", "proxi.QuickThink", proxi.QuickThink )
	hook.Add( "HUDPaint", "proxi.HUDPaint", proxi.HUDPaint )
	
	if proxi.MountMenu then
		proxi.MountMenu()
	end

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


