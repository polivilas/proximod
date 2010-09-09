////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Utility functions                          //
////////////////////////////////////////////////

function proxi.Util_AppendCvar( tGroup, sName, oDefault, sType, ... )
	if not sType then
		tGroup[sName] = oDefault
		
	elseif sType == "color" then
		tGroup[sName .. "_r"] = oDefault[1]
		tGroup[sName .. "_g"] = oDefault[2]
		tGroup[sName .. "_b"] = oDefault[3]
		tGroup[sName .. "_a"] = oDefault[4]
		
	end
	
	
end

function proxi.Util_BuildCvars( tGroup, sPrefix )
	if not sPrefix then return end
	
	for sName,oDefault in pairs( tGroup ) do
		proxi.CreateVar( tostring( sPrefix ) .. tostring( sName ), tostring( oDefault ), true, false )
		
	end
	
end

function proxi.Util_RestoreCvars( tGroup, sPrefix )
	if not sPrefix then return end
	
	for sName,oDefault in pairs( tGroup ) do
		proxi.SetVar( tostring( sPrefix ) .. tostring( sName ), tostring( oDefault ) )
		
	end
	
end
