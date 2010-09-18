local BEACON = {}
BEACON.Name         = "Players"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

function BEACON:Initialize()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
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
	
	if thisMathPool.ratioClamped < 1 then
		render.SetBlend( 1 - thisMathPool.ratioClamped ^ 5 )
		if ValidEntity( ent:GetRagdollEntity() ) then
			render.DrawBeam( thisMathPool.posToProj, ent:GetRagdollEntity():GetPos(), 10, 0.2, 0.8, Color( 255, 255, 255, 255 * cfP ) )
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
	
	local teamColor = team.GetColor( ent:Team() )
	
	surface.SetTexture( self.myTexture )
	surface.SetDrawColor( teamColor )
	surface.DrawTexturedRectRotated( x, y, 8 * proxi:GetPinScale(), 8 * proxi:GetPinScale(), 45 ) ////
	
	local text = tostring( ent:Nick() )
	
	surface.SetFont( "DefaultSmall" )
	local wB, hB = surface.GetTextSize( text )
	x = x - xRel * wB / 2
	y = y - yRel * hB / 2 + hB - (yRel > 0 and (yRel ^ 4 * hB * 2) or 0)
	
	draw.SimpleText( tostring( ent:Nick() ), "DefaultSmall", x + 1, y + 1, Color( 0, 0, 0, 128 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( tostring( ent:Nick() ), "DefaultSmall", x, y, teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	

end

proxi.RegisterBeacon( BEACON, "players" )
