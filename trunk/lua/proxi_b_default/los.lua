local BEACON = {}
BEACON.Name         = "LOS"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

function BEACON:Initialize()
	self.myMathPool = {}
	self.myMaterial = Material( "effects/yellowflare" )
	
end

function BEACON:ShouldTag( entity )
	return entity:IsPlayer()
	
end
function BEACON:DrawUnderCircle( ent )
	render.SetMaterial( self.myMaterial )
	render.DrawBeam( ent:GetShootPos(), ent:GetShootPos() + ent:GetAimVector() * 1024, 64, 0.5, 1, Color( 255, 255, 255, 64 ) )
	
end

proxi.RegisterBeacon( BEACON, "LOS" )
