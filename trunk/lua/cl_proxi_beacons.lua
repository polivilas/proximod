////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Beacons System                             //
////////////////////////////////////////////////

-- Won't make a metatable because there are so few base functions

local PROXI_BEACONS    = {}
local PROXI_STANDALONE = {}
local PROXI_BEACONORDER = {}

local PROXI_LastQueryBeacons = 0
local PROXI_BeaconQueryDelay = 0.1 -- Seconds.

local PROXI_TaggedEntities = {}

function proxi:ResetAllTags()
	PROXI_TaggedEntities = {}
	proxi:RemoveAllPhysicalTags()
	
end

function proxi:RemoveAllPhysicalTags()
	local allEnts = ents.GetAll()
	for _,ent in pairs( allEnts ) do
		if ValidEntity( ent ) then
			ent.__proxi_hasTags = nil
			ent.__proxi_tags = nil
		end
		
	end
	
end

function proxi:UpdateBeacons()
	if CurTime() < (PROXI_LastQueryBeacons + PROXI_BeaconQueryDelay) then return end
	PROXI_LastQueryBeacons = CurTime()
	
	local allEnts = ents.GetAll()
	for _,ent in pairs( allEnts ) do
		local couldTag = self:TagEntity( ent )
		
		-- couldTag can be a BOOLEAN or NIL :: "if (couldTag == true)" DOES NOT EQUAL TO "if (couldtag)"
		-- Actually, if there were only "(clouldTag)" it could work.
		-- If there is a case where I need "coundTag == false" then do "couldTag == false" and not "not couldTag"
		if couldTag == true then
			table.insert( PROXI_TaggedEntities, ent )
			
		end
		
	end
	
	local i = 1
	while i <= #PROXI_TaggedEntities do
		if not ValidEntity( PROXI_TaggedEntities[ i ] ) then
			table.remove( PROXI_TaggedEntities, i )
			
		else
			i = i + 1
			
		end
		
	end
	
end

function proxi:GetAllBeacons()
	return PROXI_BEACONS
	
end

function proxi:GetTaggedEntities()
	return PROXI_TaggedEntities
	
end

function proxi:TagEntity( ent )
	if not ValidEntity( ent ) then return nil end
	if ent.__proxi_hasTags ~= nil then return nil end -- CAN'T DEFINE TAGS ON AN ENTITIES THAT ALREADY HAVE.
	
	ent.__proxi_hasTags = false
	local tags = {}
	for tag,objBecon in pairs( PROXI_BEACONS ) do
		-- NO MATTER IF THE BEACON IS ENABLED OR NOT
		// Think about algorithm again ?
		if not objBecon.IsStandAlone then
			if objBecon:ShouldTag( ent ) then
				table.insert(tags, tag)
				
			end
			
		end
		
	end
	
	if #tags > 0 then
		ent.__proxi_hasTags = true
		ent.__proxi_tags = tags
		
	end
	
	return ent.__proxi_hasTags
	
end

local PROXI_STEPS = { 
	[0] = "PerformMath",
	[1] = "DrawUnderCircle",
	[2] = "DrawUnderCircle2D",
	[3] = "DrawOverCircle",
	[4] = "DrawOverCircle2D",
	[5] = "DrawOverEverything"
}

function proxi:DebugBeaconOps( tEnts, iStep )
	local sStep = PROXI_STEPS[iStep]
	self:DebugEntOps( sStep, tEnts )
	self:DebugStandAloneOps( sStep )
	
end

function proxi:DebugEntOps( sStep, tEnts )
	for k,ent in pairs( tEnts ) do
		if ValidEntity( ent ) then
			for l,tag in pairs( ent.__proxi_tags ) do
				// should we Run a check on the tag existence ? ?
				local objBeacon = PROXI_BEACONS[tag]
				if objBeacon[sStep] and objBeacon:IsEnabled() then
					objBeacon[sStep]( objBeacon, ent )
					
				end
				
			end
			
		end
		
	end
	
end

function proxi:DebugStandAloneOps( sStep )
	for k,tag in pairs ( PROXI_STANDALONE ) do
		local objBeacon = PROXI_BEACONS[tag]
		if objBeacon[sStep] and objBeacon:IsEnabled() then
			objBeacon[sStep]( objBeacon )
			
		end
		
	end
	
end

function proxi:MountBeacons( )
	for tag,objBeacon in pairs ( PROXI_BEACONS ) do
		if objBeacon.Mount then
			objBeacon.Mount( objBeacon )
			
		end
		
	end
	
end

function proxi:OrderBeaconTable()
	table.sort( PROXI_BEACONORDER, function( a, b )
		return PROXI_BEACONS[a]:GetName() < PROXI_BEACONS[b]:GetName()
		
	end )
	
end

function proxi:GetBeaconOrderTable()
	return PROXI_BEACONORDER
end

-- LIBVAR
function proxi.RegisterBeacon( objBeacon, sName )
	if not objBeacon or not sName then return end
	sName = string.lower( sName )
	if string.find( sName, " " ) or PROXI_BEACONS[sName] then return end
	objBeacon.IsStandAlone = objBeacon.IsStandAlone or false
	if objBeacon.IsStandAlone then
		table.insert(PROXI_STANDALONE, sName)
		
	elseif not objBeacon.ShouldTag then
		return -- ERROR : Not standalone but no way to tag either ! It's invalid !
		
	end
	
	objBeacon.Name = objBeacon.Name or ("<" .. sName .. ">")
	objBeacon.__rawname = sName
	PROXI_BEACONS[sName] = objBeacon
	table.insert( PROXI_BEACONORDER, sName )
	-- REPEAT : Won't make a metatable because there are so few base functions
	proxi.CreateVar("proxi_beacons_enable_" .. sName, (objBeacon.DefaultOn or false) and 1 or 0)
	function objBeacon.IsEnabled( self )
		return proxi.GetVar("proxi_beacons_enable_" .. self.__rawname) > 0
		
	end
	function objBeacon.GetName( self )
		return self.Name
		
	end
	function objBeacon.GetRawName( self )
		return self.__rawname
		
	end
	
	proxi:OrderBeaconTable()
	
end
