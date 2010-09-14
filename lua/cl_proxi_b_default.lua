////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Default Beacons                            //
////////////////////////////////////////////////

function proxi:LoadDefaultBeacons()
	do
		local BEACON = {}
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMath = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
		end
		
		function BEACON:ShouldTag( entity )
			return entity:IsPlayer()
			
		end
		
		function BEACON:PerformMath( ent )
		end
		
		function BEACON:DrawUnderCircle( ent )
		end
		
		function BEACON:DrawOverCircle( ent )
			
			proxi:ProjectPosition( self.myMath, ent:GetPos() )		
			local cf, cfP, cfAP = proxi:GetFalloff( self.myMath, 256, true )
			local conePos = proxi:GetConeProjectedPosition( self.myMath )
			
			render.SetMaterial( self.myMaterial )
			render.DrawSprite( conePos, 32, 32, Color( 255, 255, 255, 255 * cfAP ) ) ////
			render.DrawSprite( self.myMath.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
			render.DrawBeam( self.myMath.posToProj, conePos, 10, 0.3, 0.5, Color( 255, 255, 255, 255 * cfP ) )
			
			if self.myMath.ratio < 1 then
				render.SetBlend( 1 - self.myMath.ratio ^ 5 )
				ent:DrawModel()
				render.SetBlend( 1 )
				
			end
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "players" )
		
	end
	
	do
		local BEACON = {}
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMath = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
		end
		
		function BEACON:ShouldTag( entity )
			return string.find( entity:GetClass(), "prop_" ) and true or false
			
		end
		
		function BEACON:PerformMath( ent )
		end
		
		function BEACON:DrawUnderCircle( ent )
		end
		
		function BEACON:DrawOverCircle( ent )
			
			proxi:ProjectPosition( self.myMath, ent:GetPos() )		
			local cf, cfP, cfAP = proxi:GetFalloff( self.myMath, 256, true )
			local conePos = proxi:GetConeProjectedPosition( self.myMath )
			
			render.SetMaterial( self.myMaterial )
			render.DrawSprite( conePos, 32, 32, Color( 255, 255, 255, 255 * cfAP ) ) ////
			render.DrawSprite( self.myMath.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
			render.DrawBeam( self.myMath.posToProj, conePos, 10, 0.3, 0.5, Color( 255, 255, 255, 255 * cfP ) )
			
			if self.myMath.ratio < 1 then
				render.SetBlend( 1 - self.myMath.ratio ^ 5 )
				ent:DrawModel()
				render.SetBlend( 1 )
				
			end
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "props" )
		
	end
	
end