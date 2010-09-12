////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Virtual Scene                              //
////////////////////////////////////////////////


function proxi.HUDPaint()
	if not proxi:IsEnabled() then return end
	
	proxi:DoRenderVirtualScene()

end

function proxi:RecomA()
	self.dat.view_data.pos_func = function()
		local dist = self.dat.view_data.radius_const / math.tan( math.rad( self.dat.view_data.fov_const / 2 ) )
		return EyePos() - self.dat.view_data.ang_func():Forward() * dist
		
	end
	self.dat.view_data.ang_func = function() return Angle( 90, EyeAngles().y, 0 ) end
	self.dat.view_data.radius_const = 1024
	self.dat.view_data.fov_const = 4
	self.dat.view_data.drawx = 12
	self.dat.view_data.drawy = 256
	self.dat.view_data.draww = 312
	self.dat.view_data.drawh = 312
	
end

function proxi:RecomC()
	self.dat.view_data.pos_func = function()
		local dist = self.dat.view_data.radius_const / math.tan( math.rad( self.dat.view_data.fov_const / 2 ) )
		return EyePos() - self.dat.view_data.ang_func():Forward() * dist
		
	end
	self.dat.view_data.ang_func = function() return Angle( 35, EyeAngles().y, 0 ) end
	self.dat.view_data.radius_const = 512
	self.dat.view_data.fov_const = 100
	self.dat.view_data.drawx = 12
	self.dat.view_data.drawy = 256
	self.dat.view_data.draww = 312
	self.dat.view_data.drawh = 312
	
end

function proxi:RecomB()
	self.dat.view_data.pos_func = function()
				return EyePos()
				
			end
	self.dat.view_data.ang_func = function() return (sharpeye_focus and sharpeye_focus.GetSmoothedViewAngles and sharpeye_focus:GetSmoothedViewAngles()) or EyeAngles() end
	self.dat.view_data.radius_const = 200
	self.dat.view_data.fov_const = LocalPlayer():GetFOV()
	self.dat.view_data.drawx = (ScrW() - ScrH()) / 2
	self.dat.view_data.drawy = 0
	self.dat.view_data.draww = ScrH()
	self.dat.view_data.drawh = ScrH()
	
end

function proxi:DoRenderVirtualScene()
	if not self.dat.view_data then
		self.dat.view_data = {}
		proxi:RecomC()
	end
	
	self.dat.view_data.raw_scrw = ScrW()
	self.dat.view_data.raw_scrh = ScrH()
	
	local xDraw, yDraw = self.dat.view_data.drawx, self.dat.view_data.drawy
	local iWidth, iHeight = self.dat.view_data.draww, self.dat.view_data.drawh
	
	--surface.SetDrawColor( 0, 0, 0, 128 )
	--surface.DrawRect( xDraw, yDraw, iWidth, iHeight )
	
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawPoly( self:CalcCircle( 36, iWidth / 2, self.dat.view_data.drawx, self.dat.view_data.drawy ) )
	
	
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	
	local matfix = 1.07
	local iSurfWidth, iSurfHeight = iWidth * matfix, iHeight * matfix
	local iDrawXCenter, iDrawYCenter = xDraw + iWidth / 2, yDraw + iHeight / 2
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( surface.GetTextureID( "proxi/rad_ring.vmt" ) )
	surface.DrawTexturedRectRotated( iDrawXCenter, iDrawYCenter, iSurfWidth, iSurfHeight, 0)
	surface.SetTexture( nil )
	
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	
	cam.Start3D( self.dat.view_data.pos_func(), self.dat.view_data.ang_func(), self.dat.view_data.fov_const, xDraw, yDraw, iWidth, iHeight )
		local bOkay, strErr = pcall( self.DoCameraVirtualScene, self, iWidth, iHeight )
		
	cam.End3D()
	
	if not bOkay then ErrorNoHalt( ">> Proxi ERROR : " .. strErr ) end
	
	render.SetStencilEnable( false )
	
	--draw.SimpleText( "LOL", "ScoreboardText", 20, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function proxi:ConvertToScreen( vPos, iWidth, iHeight )
	local pts = vPos:ToScreen()
		pts.x = pts.x / self.dat.view_data.raw_scrw * iWidth
		pts.y = pts.y / self.dat.view_data.raw_scrh * iHeight
	
	return pts
	
end

local PROXI_CAMERA_FIX = 1
local PROXI_CIRCLE_POLYGON = {}
local PROXI_CIRCLE_RES = -1
local PROXI_CIRCLE_RADIUS = -1
local PROXI_CIRCLE_IDX = -1
local PROXI_CIRCLE_IDY = -1

function proxi:CalcCircle( iRes, iRadius, iDrawX, iDrawY, optiRadiusHeight )
	if PROXI_CIRCLE_RES == iRes and PROXI_CIRCLE_RADIUS == radius and PROXI_CIRCLE_IDX ~= iDrawX and PROXI_CIRCLE_IDY ~= iDrawY then return PROXI_CIRCLE_POLYGON end
	
	PROXI_CIRCLE_RES = iRes
	PROXI_CIRCLE_RADIUS = iRadius
	PROXI_CIRCLE_IDX = iDrawX
	PROXI_CIRCLE_IDY = iDrawY
	
	for i = 1, iRes do
		if not PROXI_CIRCLE_POLYGON[i] then
			PROXI_CIRCLE_POLYGON[i] = {}
			
		end
		
		PROXI_CIRCLE_POLYGON[i]["x"] = math.cos( math.rad( i / iRes * 360 ) ) * iRadius
		PROXI_CIRCLE_POLYGON[i]["y"] = math.sin( math.rad( i / iRes * 360 ) ) * (optiRadiusHeight or iRadius)
		PROXI_CIRCLE_POLYGON[i]["u"] = (iRadius - PROXI_CIRCLE_POLYGON[i]["x"]) / (2 * iRadius)
		PROXI_CIRCLE_POLYGON[i]["v"] = ((optiRadiusHeight or iRadius) - PROXI_CIRCLE_POLYGON[i]["y"]) / (2 * iRadius)

		PROXI_CIRCLE_POLYGON[i]["x"] = iDrawX + iRadius + PROXI_CIRCLE_POLYGON[i]["x"]
		PROXI_CIRCLE_POLYGON[i]["y"] = iDrawY + (optiRadiusHeight or iRadius) + PROXI_CIRCLE_POLYGON[i]["y"]

	end
	
	return PROXI_CIRCLE_POLYGON
		
end

function proxi:DoCameraVirtualScene( iWidth, iHeight )
	if not self.__MYMAT then self.__MYMAT = Material( "effects/yellowflare" ) end
	
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
		
		
		//if k == 17 then print( distanceToOrigin ) end
		local closeFalloff = math.Clamp(distanceToOrigin / 256, 0, 1)
		local closeFalloffPowered = closeFalloff ^ 2
		local closeFalloffAntiPowered = 1 - (1 - closeFalloff) ^ 2
		local size = ((ent:OBBMins() - ent:OBBMaxs()):Length() - ratio ^ 2 * 0.8)
		
		render.SetMaterial( self.__MYMAT )
		//render.DrawSprite( projPos + relPos, size * 1.5, size * 1.5, Color( 255, 255, 255, 255*closeFalloffAntiPowered ) )
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

