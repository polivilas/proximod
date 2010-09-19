local BEACON = {}
BEACON.Name         = "Props"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

function BEACON:Mount()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
end

function BEACON:ShouldTag( entity )
	return string.find( entity:GetClass(), "prop_" )
	
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
	
	if thisMathPool.ratio > 2 then return end

	local cfP, cfAP = proxi:Util_CalcPowerUniform( thisMathPool.closeFalloff )
	
	render.SetMaterial( self.myMaterial )
	render.DrawSprite( thisMathPool.conePos, 32, 32, Color( 255, 255, 255, 255 * cfAP ) ) ////
	--render.DrawSprite( thisMathPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
	--render.DrawBeam( thisMathPool.posToProj, thisMathPool.conePos, 10, 0.3, 0.5, Color( 255, 255, 255, 255 * cfP ) )
	
	if thisMathPool.ratioClamped < 1 then
		render.SetBlend( 1 - thisMathPool.ratioClamped ^ 5 )
		ent:DrawModel()
		render.SetBlend( 1 )
		
	end
	
end

proxi.RegisterBeacon( BEACON, "props" )
