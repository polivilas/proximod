////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Virtual Scene                              //
////////////////////////////////////////////////

local RING_TEX_ID = surface.GetTextureID( "proxi/rad_ring.vmt" )
local RING_MATFIX = 1.07
local PROXI_CURRENT_VIEWDATA = nil

function proxi:GetVarColorVariadic( sCvar )
	return self.GetVar(sCvar .. "_r"), self.GetVar(sCvar .. "_g"), self.GetVar(sCvar .. "_b"), self.GetVar(sCvar .. "_a");
	
end

function proxi.HUDPaint()
	if not proxi:IsEnabled() then return end
	
	
	if not proxi.dat.view_data then
		proxi.dat.view_data = {}
		proxi:RecomC()
	end
	proxi:RegularEvaluate()
	proxi:DoRenderVirtualScene( proxi.dat.view_data )

end

function proxi:RegularEvaluate()
	local size = proxi.GetVar("proxi_regmod_size")
	self.dat.view_data.draww = size
	self.dat.view_data.drawh = size
	self.dat.view_data.drawx = proxi.GetVar("proxi_regmod_xrel") * ScrW() - size / 2
	self.dat.view_data.drawy = proxi.GetVar("proxi_regmod_yrel") * ScrH() - size / 2
	
end

function proxi:RecomA()
	self.dat.view_data.pos_func = function()
		local dist = self.dat.view_data.radius_const / math.tan( math.rad( self.dat.view_data.fov_const / 2 ) )
		return EyePos() - self.dat.view_data.ang_func():Forward() * dist
		
	end
	
	self.dat.view_data.pos = nil
	self.dat.view_data.ang = nil
	self.dat.view_data.ang_func = function() return Angle( 90, EyeAngles().y, 0 ) end
	self.dat.view_data.radius_const = 1024
	self.dat.view_data.fov_const = 4
	self.dat.view_data.drawx = 12
	self.dat.view_data.drawy = 256
	self.dat.view_data.draww = 312
	self.dat.view_data.drawh = 312
	self.dat.view_data.margin = 2^0.5
	
end

function proxi:RecomC()
	self.dat.view_data.pos_func = function()
		local dist = self.dat.view_data.radius_const / math.tan( math.rad( self.dat.view_data.fov_const / 2 ) )
		return EyePos() - self.dat.view_data.ang_func():Forward() * dist
		
	end
	
	self.dat.view_data.pos = nil
	self.dat.view_data.ang = nil
	self.dat.view_data.ang_func = function() return Angle( 35, EyeAngles().y, 0 ) end
	self.dat.view_data.radius_const = 512
	self.dat.view_data.fov_const = 10
	self.dat.view_data.drawx = 12
	self.dat.view_data.drawy = 256
	self.dat.view_data.draww = 312
	self.dat.view_data.drawh = 312
	self.dat.view_data.margin = 2^0.5
	
end

function proxi:RecomB()
	self.dat.view_data.pos_func = function()
				return EyePos()
				
			end
	self.dat.view_data.ang_func = function() return (sharpeye_focus and sharpeye_focus.GetSmoothedViewAngles and sharpeye_focus:GetSmoothedViewAngles()) or EyeAngles() end
	
	self.dat.view_data.pos = nil
	self.dat.view_data.ang = nil
	self.dat.view_data.radius_const = 200
	self.dat.view_data.fov_const = LocalPlayer():GetFOV()
	self.dat.view_data.drawx = (ScrW() - ScrH()) / 2
	self.dat.view_data.drawy = 0
	self.dat.view_data.draww = ScrH()
	self.dat.view_data.drawh = ScrH()
	self.dat.view_data.margin = 2^0.5
	
end

function proxi:GetCurrentViewData()
	return PROXI_CURRENT_VIEWDATA
end

function proxi:DoRenderVirtualScene( viewData )
	PROXI_CURRENT_VIEWDATA = viewData
	
	-- We need these because Vector:ToScreen() uses the viewport as a reference, but use the raw Screen sizes from 0 to Screen Size as range of values no matter where the viewport is ou which size the viewport is
	viewData.raw_scrw = ScrW()
	viewData.raw_scrh = ScrH()
	
	local xDraw, yDraw    = viewData.drawx, viewData.drawy
	local iWidth, iHeight = viewData.draww, viewData.drawh
	
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	surface.SetDrawColor( self:GetVarColorVariadic( "proxi_uidesign_backcolor") )
	surface.SetTexture( nil )
	surface.DrawPoly( self:CalcCircle( 36, iWidth / 2, viewData.drawx, viewData.drawy ) )
	
	-- Operation : Keep (We don't want any stencil modification to happen after drawing the polygon).
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	
	local iSurfWidth, iSurfHeight    = iWidth * RING_MATFIX, iHeight * RING_MATFIX
	local iDrawXCenter, iDrawYCenter = xDraw + iWidth / 2, yDraw + iHeight / 2
	surface.SetDrawColor( self:GetVarColorVariadic( "proxi_uidesign_ringcolor") )
	surface.SetTexture( RING_TEX_ID )
	surface.DrawTexturedRectRotated( iDrawXCenter, iDrawYCenter, iSurfWidth, iSurfHeight, 0)
	
	-- Comparaison : Equal : We want all operations to be drawn on the circle.
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	
	viewData.pos = viewData.pos_func()
	viewData.ang = viewData.ang_func()
	viewData.baseratio = math.tan( math.rad( viewData.fov_const / 2 / viewData.margin ) )
	
	cam.Start3D( viewData.pos, viewData.ang, viewData.fov_const, xDraw, yDraw, iWidth, iHeight )
		local bOkay, strErr = pcall( self.DoCameraOverScene, self, viewData )
		
	cam.End3D()
	
	if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
	
	render.SetStencilEnable( false )
	
	--draw.SimpleText( "LOL", "ScoreboardText", 20, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function proxi:ConvertToScreen( vPos, viewData )
	local pts = vPos:ToScreen()
		pts.x = pts.x / viewData.raw_scrw * viewData.draww
		pts.y = pts.y / viewData.raw_scrh * viewData.drawh
	
	return pts
	
end

local PROXI_CAMERA_FIX = 1
local PROXI_CIRCLE_POLYGON = {}
local PROXI_CIRCLE_RES = -1
local PROXI_CIRCLE_RADIUS = -1
local PROXI_CIRCLE_IDX = -1
local PROXI_CIRCLE_IDY = -1


// CalcCircle should use viewdata for multiplicity ?
function proxi:CalcCircle( iRes, iRadius, iDrawX, iDrawY )
	if PROXI_CIRCLE_RES == iRes and PROXI_CIRCLE_RADIUS == iRadius and PROXI_CIRCLE_IDX == iDrawX and PROXI_CIRCLE_IDY == iDrawY then return PROXI_CIRCLE_POLYGON end
	
	PROXI_CIRCLE_RES = iRes
	PROXI_CIRCLE_RADIUS = iRadius
	PROXI_CIRCLE_IDX = iDrawX
	PROXI_CIRCLE_IDY = iDrawY
	
	for i = 1, iRes do
		if not PROXI_CIRCLE_POLYGON[i] then
			PROXI_CIRCLE_POLYGON[i] = {}
			
		end
		
		PROXI_CIRCLE_POLYGON[i]["x"] = math.cos( math.rad( i / iRes * 360 ) ) * iRadius
		PROXI_CIRCLE_POLYGON[i]["y"] = math.sin( math.rad( i / iRes * 360 ) ) * iRadius
		PROXI_CIRCLE_POLYGON[i]["u"] = (iRadius - PROXI_CIRCLE_POLYGON[i]["x"]) / (2 * iRadius)
		PROXI_CIRCLE_POLYGON[i]["v"] = (iRadius - PROXI_CIRCLE_POLYGON[i]["y"]) / (2 * iRadius)

		PROXI_CIRCLE_POLYGON[i]["x"] = iDrawX + iRadius + PROXI_CIRCLE_POLYGON[i]["x"]
		PROXI_CIRCLE_POLYGON[i]["y"] = iDrawY + iRadius + PROXI_CIRCLE_POLYGON[i]["y"]

	end
	
	return PROXI_CIRCLE_POLYGON
		
end

function proxi:ProjectPosition( tMath, posToProj )
	-- PROXI_CURRENT_VIEWDATA.pos = tMath.origin = EyePos() ((Reevaluation))
	tMath.posToProj = posToProj
	
	tMath.norm = PROXI_CURRENT_VIEWDATA.ang:Forward()
	
	tMath.projectedPos = PROXI_CURRENT_VIEWDATA.pos + tMath.norm * (posToProj - PROXI_CURRENT_VIEWDATA.pos):Dot( tMath.norm )
	tMath.relativePos = posToProj - tMath.projectedPos
	
	tMath.length = tMath.relativePos:Length()
	tMath.distanceToOrigin = (tMath.projectedPos - PROXI_CURRENT_VIEWDATA.pos):Length()
	
	tMath.ratio = tMath.length / tMath.distanceToOrigin
	
	tMath.ratioClamped = math.Clamp( tMath.ratio / PROXI_CURRENT_VIEWDATA.baseratio, 0, 1)
	if tMath.ratioClamped >= 1 then
		tMath.relativePos = tMath.relativePos:Normalize() * PROXI_CURRENT_VIEWDATA.baseratio * tMath.distanceToOrigin
		
	end
	
end

function proxi:GetConeProjectedPosition( tMath )
	tMath.conePos = tMath.projectedPos + tMath.relativePos
	return tMath.conePos
	
end

function proxi:GetFalloff( tMath, iFallOff, optbExtras )
	local closeFalloff = math.Clamp( tMath.distanceToOrigin / iFallOff, 0, 1)
	
	if not optbExtras then
		return closeFalloff
		
	else
		return closeFalloff, closeFalloff ^ 2, 1 - (1 - closeFalloff) ^ 2
		
	end
	
end

function proxi:DoCameraOverScene( viewData )
	self:DrawOverCircle( self:GetTaggedEntities() )
	
	--do return end
	
	/*
	local test_ents = table.Add(table.Add(ents.FindByClass("prop_*"), ents.FindByClass("npc_*")), ents.FindByClass("player"))
	local myMath = {}
	for k,ent in pairs( test_ents ) do
		self:ProjectPosition( myMath, ent:GetPos() )		
		local closeFalloff, closeFalloffPowered, closeFalloffAntiPowered = self:GetFalloff( myMath, 256, true )
		local conePos = self:GetConeProjectedPosition( myMath )
		
		render.SetMaterial( self.__MYMAT )
		render.DrawSprite( conePos, 32, 32, Color( 255, 255, 255, 255 * closeFalloffAntiPowered ) ) ////
		render.DrawSprite( myMath.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
		render.DrawBeam( myMath.posToProj, conePos, 10, 0.3, 0.5, Color( 255, 255, 255, 255 * closeFalloffPowered ) )
		
		if myMath.ratio < 1 then
			render.SetBlend( 1 - myMath.ratio ^ 5 )
			ent:DrawModel()
			render.SetBlend( 1 )
			
		end
		
	end
	*/
	
	-- Run 2D Cam in 3D env to use vector conv.
	/*
	cam.Start2D()
		local bOkay, strErr = pcall( function()
		for k,ent in pairs( test_ents ) do
			local pos = ent:GetPos()
			local pts = self:ConvertToScreen( pos, viewData )
			draw.SimpleText(  "  <" .. k, "ScoreboardText", pts.x, pts.y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
		end
	end )
		if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
	cam.End2D()
	*/
end
















if false then // NEVER EXECUTE THIS BIT I WANT THE SYNTAX COLOR
	function proxi:DoCameraVirtualScene( iWidth, iHeight )
		if not self.__MYMAT then self.__MYMAT = Material( "effects/yellowflare" ) end
		
		--do return end
		
		local test_ents = table.Add(table.Add(ents.FindByClass("prop_*"), ents.FindByClass("npc_*")), ents.FindByClass("player"))
		for k,ent in pairs( test_ents ) do
			local origin = EyePos()
			local posToProj = ent:GetPos()
			local norm = self.dat.view_data.ang_func():Forward()
			local projPos = origin + norm * (posToProj - origin):Dot( norm )
			local relPos = posToProj - projPos
			
			local length = relPos:Length()
			local distanceToOrigin = (projPos - origin):Length()
			local myRat = length / distanceToOrigin
			
			local TOLE = 2^0.5 // GOOD
			//local TOLE = 2
			
			--local baseDTO = self.dat.view_data.radius_const / math.tan( math.rad( self.dat.view_data.fov_const / 2 ) )
			--local baseRat = self.dat.view_data.radius_const / baseDTO
			local baseRat = math.tan( math.rad( self.dat.view_data.fov_const / 2 / TOLE ) )
			
			local ratio = math.Clamp( myRat / baseRat, 0, 1)
			if ratio >= 1 then
				relPos = relPos:Normalize() * baseRat * distanceToOrigin
				
			end
			
			local closeFalloff = math.Clamp(distanceToOrigin / 256, 0, 1)
			local closeFalloffPowered = closeFalloff ^ 2
			local closeFalloffAntiPowered = 1 - (1 - closeFalloff) ^ 2
			local size = ((ent:OBBMins() - ent:OBBMaxs()):Length() - ratio ^ 2 * 0.8)
			
			render.SetMaterial( self.__MYMAT )
			render.DrawSprite( projPos + relPos, 32, 32, Color( 255, 255, 255, 255*closeFalloffAntiPowered ) ) ////
			render.DrawSprite( posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
			render.DrawBeam( posToProj, projPos + relPos, 10, 0.3, 0.5, Color( 255, 255, 255, 255*closeFalloffPowered ) )
			
			if ratio < 1 then
				
				render.SetBlend( 1 - ratio ^ 5 )
				ent:DrawModel()
				render.SetBlend( 1 )
				
			end
			
		end
		
		-- Run 2D Cam in 3D env to use vector conv.
		/*
		cam.Start2D()
			local bOkay, strErr = pcall( function()
			for k,ent in pairs( test_ents ) do
				local pos = ent:GetPos()
				local pts = self:ConvertToScreen( pos, iWidth, iHeight )
				draw.SimpleText(  "  <" .. k, "ScoreboardText", pts.x, pts.y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
			end
		end )
			if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
		cam.End2D()
		*/
	end
end