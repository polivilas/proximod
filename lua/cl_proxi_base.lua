////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Base                                       //
////////////////////////////////////////////////

function proxi.Mount()
	print("")
	print("[ Mounting " .. PROXI_NAME .. " ... ]")
	
	proxi.cvarGroups = {}
	proxi.cvarGroups.core   = {}
	
	proxi.Util_AppendCvar( proxi.cvarGroups.core, "enable", "1")
	
	for sSubFix,tCvarGroup in pairs( proxi.cvarGroups ) do
		proxi.Util_BuildCvars( tCvarGroup, "proxi_" .. sSubFix .. "_" )
		
	end
	
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


