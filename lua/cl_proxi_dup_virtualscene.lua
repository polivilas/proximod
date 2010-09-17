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
local PROXI_CALC_SCREENPOS = nil

function proxi:GetPinScale()
	return self.GetVar( "proxi_regmod_size" ) / 256
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

////////////////////////////////////////////////
////////////////////////////////////////////////

function proxi:RegularEvaluate()
	local size = proxi.GetVar("proxi_regmod_size")
	self.dat.view_data.draww = size
	self.dat.view_data.drawh = size
	self.dat.view_data.drawx = proxi.GetVar("proxi_regmod_xrel") * ScrW() - size / 2
	self.dat.view_data.drawy = proxi.GetVar("proxi_regmod_yrel") * ScrH() - size / 2
	self.dat.view_data.fov_const    = proxi.GetVar("proxi_regmod_fov")
	self.dat.view_data.radius_const = proxi.GetVar("proxi_regmod_radius")
	
end

////////////////////////////////////////////////
////////////////////////////////////////////////

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

function proxi:RecomC()
	self.dat.view_data.pos_func = function()
		local dist = self.dat.view_data.radius_const / math.tan( math.rad( self.dat.view_data.fov_const / 2 ) )
		return EyePos() - self.dat.view_data.ang_func():Forward() * dist
		
	end
	
	self.dat.view_data.pos = nil
	self.dat.view_data.ang = nil
	self.dat.view_data.ang_func = function() return Angle( proxi.GetVar("proxi_regmod_angle"), EyeAngles().y, 0 ) end
	self.dat.view_data.radius_const = 512
	self.dat.view_data.fov_const = 10
	self.dat.view_data.drawx = 12
	self.dat.view_data.drawy = 256
	self.dat.view_data.draww = 312
	self.dat.view_data.drawh = 312
	self.dat.view_data.margin = 2^0.5
	
end

////////////////////////////////////////////////
////////////////////////////////////////////////

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
	
	-- Calculate actual values
	viewData.pos = viewData.pos_func()
	viewData.ang = viewData.ang_func()
	viewData.baseratio = math.tan( math.rad( viewData.fov_const / 2 / viewData.margin ) )
	
	
	
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	---- Background circle
	surface.SetDrawColor( self:Util_GetVarColorVariadic( "proxi_uidesign_backcolor") )
	surface.SetTexture( nil )
	surface.DrawPoly( self:CalcCircle( 36, iWidth / 2, viewData.drawx, viewData.drawy ) )
	
	-- Operation : Keep (We don't want any stencil modification to happen after drawing the polygon).
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	
	---- Undercontents
	
	-- Comparaison : Equal : We want all operations to be drawn on the circle.
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	
	cam.Start3D( viewData.pos, viewData.ang, viewData.fov_const, xDraw, yDraw, iWidth, iHeight )
		local bOkayFirst, strErrFirst = pcall( self.DoCameraMath, self, viewData )
		if bOkayFirst then
			local bOkay, strErr = pcall( self.DoCameraUnderScene, self, viewData )
			if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
			
		end
		
	cam.End3D()
	if not bOkayFirst then ErrorNoHalt( ">> Proxi ERROR : " .. strErrFirst )	end
	
	---- Drawing the ring.

	-- Compare : We want it only to draw no matter what
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	
	local iSurfWidth, iSurfHeight    = iWidth * RING_MATFIX, iHeight * RING_MATFIX
	local iDrawXCenter, iDrawYCenter = xDraw + iWidth / 2, yDraw + iHeight / 2
	surface.SetDrawColor( self:Util_GetVarColorVariadic( "proxi_uidesign_ringcolor") )
	surface.SetTexture( RING_TEX_ID )
	surface.DrawTexturedRectRotated( iDrawXCenter, iDrawYCenter, iSurfWidth, iSurfHeight, 0)
	
	---- Preparing Overcontents
	if bOkayFirst then
		-- Comparaison : Equal : We want all operations to be drawn on the circle.
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		
		---- Overcontents
		cam.Start3D( viewData.pos, viewData.ang, viewData.fov_const, xDraw, yDraw, iWidth, iHeight )
			local bOkay, strErr = pcall( self.DoCameraOverScene, self, viewData )
			
		cam.End3D()
		if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
		
	end
	
	render.SetStencilEnable( false )
	
end

////////////////////////////////////////////////
////////////////////////////////////////////////

function proxi:ConvertPosToScreen( vPos, fAlterX, fAlterY )
	PROXI_CALC_SCREENPOS = vPos:ToScreen()
	PROXI_CALC_SCREENPOS.x = (PROXI_CALC_SCREENPOS.x / PROXI_CURRENT_VIEWDATA.raw_scrw + (fAlterX or 0) / 2) * PROXI_CURRENT_VIEWDATA.draww
	PROXI_CALC_SCREENPOS.y = (PROXI_CALC_SCREENPOS.y / PROXI_CURRENT_VIEWDATA.raw_scrh + (fAlterY or 0) / 2) * PROXI_CURRENT_VIEWDATA.drawh
	
	return PROXI_CALC_SCREENPOS.x, PROXI_CALC_SCREENPOS.y
	
end

function proxi:ConvertPosToRelative( vPos )
	PROXI_CALC_SCREENPOS = vPos:ToScreen()
	PROXI_CALC_SCREENPOS.x = (PROXI_CALC_SCREENPOS.x / PROXI_CURRENT_VIEWDATA.raw_scrw) * 2 - 1
	PROXI_CALC_SCREENPOS.y = (PROXI_CALC_SCREENPOS.y / PROXI_CURRENT_VIEWDATA.raw_scrh) * 2 - 1
	
	return PROXI_CALC_SCREENPOS.x, PROXI_CALC_SCREENPOS.y
	
end

function proxi:ConvertRelativeToScreen( fAlterX, fAlterY )
	local x,y = (fAlterX + 1) / 2 * PROXI_CURRENT_VIEWDATA.draww, (fAlterY + 1) / 2 * PROXI_CURRENT_VIEWDATA.drawh
	
	return x, y
	
end


////////////////////////////////////////////////
////////////////////////////////////////////////

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

////////////////////////////////////////////////
////////////////////////////////////////////////

function proxi:ProjectPosition( tMath, posToProj )
	-- PROXI_CURRENT_VIEWDATA.pos = tMath.origin = EyePos() ((Reevaluation))
	tMath.posToProj = posToProj
	
	tMath.norm = PROXI_CURRENT_VIEWDATA.ang:Forward()
	
	tMath.projectedPos = PROXI_CURRENT_VIEWDATA.pos + tMath.norm * (posToProj - PROXI_CURRENT_VIEWDATA.pos):Dot( tMath.norm )
	tMath.relativePos = posToProj - tMath.projectedPos
	
	tMath.length = tMath.relativePos:Length()
	tMath.distanceToOrigin = (tMath.projectedPos - PROXI_CURRENT_VIEWDATA.pos):Length()
	
	// WARNING : AMBIGUOUS CODE.
	//
	// WAS :
	tMath.relativity = tMath.length / tMath.distanceToOrigin
	tMath.ratio      = tMath.relativity / PROXI_CURRENT_VIEWDATA.baseratio
	
	tMath.ratioClamped = tMath.ratio > 1 and 1 or tMath.ratio
	if tMath.ratioClamped == 1 then
		tMath.relativePos = tMath.relativePos:Normalize() * PROXI_CURRENT_VIEWDATA.baseratio * tMath.distanceToOrigin
		
	end
	
end

function proxi:GetConeProjectedPosition( tMath )
	tMath.conePos = tMath.projectedPos + tMath.relativePos
	return tMath.conePos
	
end

function proxi:GetFalloff( tMath, iFallOff, optbExtras )
	tMath.closeFalloff = math.Clamp( tMath.distanceToOrigin / iFallOff, 0, 1)
	
	if not optbExtras then
		return tMath.closeFalloff
		
	else
		return tMath.closeFalloff, self:Util_CalcPowerUniform( tMath.closeFalloff )
		
	end
	
end

function proxi:DoCameraMath( viewData )
	self:DebugBeaconOps( self:GetTaggedEntities(), 0 )
	
end

////////////////////////////////////////////////
////////////////////////////////////////////////

function proxi:DoCameraUnderScene( viewData )
	self:DebugBeaconOps( self:GetTaggedEntities(), 1 )
	
	cam.Start2D()
		local bOkay, strErr = pcall( function()
		self:DebugBeaconOps( self:GetTaggedEntities(), 2 )
		
	end )
	cam.End2D()
	
	if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
	
end

function proxi:DoCameraOverScene( viewData )
	self:DebugBeaconOps( self:GetTaggedEntities(), 3 )
	
	cam.Start2D()
		local bOkay, strErr = pcall( function()
		self:DebugBeaconOps( self:GetTaggedEntities(), 4 )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		self:DebugBeaconOps( self:GetTaggedEntities(), 5 )
		//surface.SetDrawColor( 255, 255, 255, 64 )
		//surface.DrawRect( 0, 0, ScrW(), ScrH() )
		
	end )
	cam.End2D()
	
	if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
	
end
