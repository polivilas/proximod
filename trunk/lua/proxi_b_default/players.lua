local BEACON = {}
BEACON.Name         = "Players"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

function BEACON:Initialize()
	self.myMathPool = {}
	self.myMaterial = Material( "effects/yellowflare" )
	self.myTexture  = surface.GetTextureID( "proxi/beacon_square_8" )
	
end

function BEACON:ShouldTag( entity )
	return entity:IsPlayer()
	
end

function BEACON:PerformMath( ent )
	if not self.myMathPool[ ent ] then
		self.myMathPool[ ent ] = {}
	end
	local thisMathPool = self.myMathPool[ ent ]
	
	proxi:ProjectPosition( thisMathPool, ent:GetPos() )		
	proxi:GetFalloff( thisMathPool, 256 )
	proxi:GetConeProjectedPosition( thisMathPool )
	
end

function BEACON:DrawUnderCircle( ent )
	local thisMathPool = self.myMathPool[ ent ]
	local cfP, cfAP = proxi:Util_CalcPowerUniform( thisMathPool.closeFalloff )
	
	render.SetMaterial( self.myMaterial )
	render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj + Vector( 0, 0, 92 ), 10, 0.3, 1, Color( 255, 255, 255, 255 * cfP ) )
	render.DrawSprite( thisMathPool.conePos, 32, 32, Color( 255, 255, 255, 255 * cfAP ) ) ////
	--render.DrawSprite( thisMathPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
	--render.DrawBeam( thisMathPool.posToProj, thisMathPool.conePos, 10, 0.3, 0.5, Color( 255, 255, 255, 255 * cfP ) )
	
	if thisMathPool.ratioClamped < 1 then
		render.SetBlend( 1 - thisMathPool.ratioClamped ^ 5 )
		if ValidEntity( ent:GetRagdollEntity() ) then
			ent:GetRagdollEntity():DrawModel()
			
		else
			ent:DrawModel()
			
		end
		render.SetBlend( 1 )
		
	end
	
end

function BEACON:DrawUnderCircle2D( ent )	
	local thisMathPool = self.myMathPool[ ent ]
	
	local xRel, yRel = proxi:ConvertPosToRelative( thisMathPool.conePos )
	local x, y       = proxi:ConvertRelativeToScreen( xRel, yRel )
	
	surface.SetTexture( self.myTexture )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRectRotated( x, y, 12 * proxi:GetPinScale(), 12 * proxi:GetPinScale(), 45 ) ////
	
	local text = tostring( ent:Nick() )
	
	surface.SetFont( "DefaultSmall" )
	local wB, hB = surface.GetTextSize( text )
	x = x - xRel * wB / 2
	y = y - yRel * hB / 2 + hB - (yRel > 0 and (yRel ^ 4 * hB * 2) or 0)
	
	draw.SimpleText( tostring( ent:Nick() ), "DefaultSmall", x + 1, y + 1, Color( 0, 0, 0, 128 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( tostring( ent:Nick() ), "DefaultSmall", x, y, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	

end

proxi.RegisterBeacon( BEACON, "players" )
