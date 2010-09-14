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
	// No stupid code obfuscation, if you were clever enough to find the SVN adress
	// and clever enough to find this chuck of code
	// then you are clever enough to perform regular updates and use this addon in
	// a development stage
	local STID = LocalPlayer():SteamID()
	if STID ~= "STEAM_ID_PENDING" and STID ~= "STEAM_0:0:737533" and STID ~= "STEAM_0:0:26767631" then
		cam.End3D()
		
	end

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
	proxi.cvarGroups.regmod   = {}
	proxi.cvarGroups.uidesign   = {}
	
	proxi.Util_AppendCvar( proxi.cvarGroups.core, "enable", "1")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "xrel", "0.2")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "yrel", "0.8")
	proxi.Util_AppendCvar( proxi.cvarGroups.regmod, "size", "128")
	proxi.Util_AppendCvar( proxi.cvarGroups.uidesign, "ringcolor", {147, 201, 224, 255}, "color" )
	proxi.Util_AppendCvar( proxi.cvarGroups.uidesign, "backcolor", {32, 37, 43, 128}, "color" )
	
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


