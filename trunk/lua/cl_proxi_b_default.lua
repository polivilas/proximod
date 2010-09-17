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
		BEACON.Name         = "Players"
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMathPool = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
		end
		
		function BEACON:ShouldTag( entity )
			return entity:IsPlayer()
			
		end
		
		function BEACON:PerformMath( ent )
			if not self.myMathPool[ ent ] then
				self.myMathPool[ ent ] = {}
			end
			local thisMapPool = self.myMathPool[ ent ]
			
			proxi:ProjectPosition( thisMapPool, ent:GetPos() )		
			proxi:GetFalloff( thisMapPool, 256 )
			proxi:GetConeProjectedPosition( thisMapPool )
			
		end
		
		function BEACON:DrawUnderCircle( ent )
			local thisMapPool = self.myMathPool[ ent ]
			local cfP, cfAP = proxi:Util_CalcPowerUniform( thisMapPool.closeFalloff )
			
			render.SetMaterial( self.myMaterial )
			render.DrawSprite( thisMapPool.conePos, 32, 32, Color( 255, 255, 255, 255 * cfAP ) ) ////
			--render.DrawSprite( thisMapPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
			--render.DrawBeam( thisMapPool.posToProj, thisMapPool.conePos, 10, 0.3, 0.5, Color( 255, 255, 255, 255 * cfP ) )
			
			if thisMapPool.ratioClamped < 1 then
				render.SetBlend( 1 - thisMapPool.ratioClamped ^ 5 )
				ent:DrawModel()
				render.SetBlend( 1 )
				
			end
			
		end
		
		function BEACON:DrawOverCircle( ent )
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "players" )
		
	end
	
	do
		local BEACON = {}
		BEACON.Name         = "Props"
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMathPool = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
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
		
		function BEACON:DrawUnderCircle2D( ent )
			/*local thisMathPool = self.myMathPool[ ent ]
			if thisMathPool.ratioClamped == 1 then return end
			
			local pos = ent:GetPos()	
			local x,y = proxi:ConvertPosToScreen( pos, 0, 0.1 )
			draw.SimpleText(  "  " .. ent:GetClass(), "ScoreboardText", x, y, Color( 255, 255, 255, 255 * (1 - thisMathPool.ratioClamped ^ 5) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )*/
		end
		
		function BEACON:DrawOverCircle( ent )
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "props" )
		
	end
	
	do
		local BEACON = {}
		BEACON.Name         = "Rockets"
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMathPool = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
		end
		
		function BEACON:ShouldTag( entity )
			return entity:GetClass() == "rpg_missile"
			
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
			
			if not thisMathPool.tracedata then
				thisMathPool.tracedata = {}
				thisMathPool.tracedata.filter = ent
				
				thisMathPool.traceres = {}
				
			end
			
			thisMathPool.tracedata.start = thisMathPool.posToProj
			thisMathPool.tracedata.endpos = thisMathPool.posToProj + ent:GetVelocity():Normalize() * 1024
			thisMathPool.traceres = util.TraceLine( thisMathPool.tracedata )
			
			render.SetMaterial( self.myMaterial )
			--render.DrawSprite( thisMathPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
			render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj + ent:GetVelocity() * 2, 64, 0.5, 1, Color( 255, 255, 255, 255 ) )
			render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj - ent:GetVelocity() * 0.5, 64, 0.5, 1, Color( 255, 0, 0, 128 ) )
			render.DrawSprite( thisMathPool.conePos, 256, 256, Color( 255, 0, 0, 255 ) ) ////
			
			for i=1,10 do
				render.DrawBeam( thisMathPool.traceres.HitPos, thisMathPool.traceres.HitPos + VectorRand() * 256 + thisMathPool.traceres.HitNormal * 512, 32, 0.5, 1, Color( 255, 255, 0, 128 ) )
			end
			render.DrawSprite( thisMathPool.traceres.HitPos, 256, 256, Color( 255, 255, 0, 255 ) ) ////
			
		end
		
		function BEACON:DrawUnderCircle2D( ent )
			local thisMathPool = self.myMathPool[ ent ]
			if thisMathPool.ratioClamped == 1 then return end
			
			local pos = ent:GetPos()	
			local x,y = proxi:ConvertPosToScreen( pos, 0, 0.1 )
			draw.SimpleText(  "  " .. ent:GetClass(), "ScoreboardText", x, y, Color( 255, 255, 255, 255 * (1 - thisMathPool.ratioClamped ^ 5) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			x,y = proxi:ConvertPosToScreen( thisMathPool.traceres.HitPos, 0, 0 )
			draw.SimpleText(  "  < EXPLOSION", "ScoreboardText", x, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		function BEACON:DrawOverCircle( ent )
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "rockets" )
		
	end
	
	do
		local BEACON = {}
		BEACON.Name         = "Bolts"
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMathPool = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
		end
		
		function BEACON:ShouldTag( entity )
			return entity:GetClass() == "crossbow_bolt"
			
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
			
			if not thisMathPool.tracedata then
				thisMathPool.tracedata = {}
				thisMathPool.tracedata.filter = ent
				
				thisMathPool.traceres = {}
				
			end
			
			thisMathPool.tracedata.start = thisMathPool.posToProj
			thisMathPool.tracedata.endpos = thisMathPool.posToProj + ent:GetVelocity():Normalize() * 16384
			thisMathPool.traceres = util.TraceLine( thisMathPool.tracedata )
			
			render.SetMaterial( self.myMaterial )
			--render.DrawSprite( thisMathPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
			render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj + ent:GetVelocity() * 2, 32, 0.5, 1, Color( 255, 255, 0, 255 ) )
			render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj - ent:GetVelocity() * 0.5, 32, 0.5, 1, Color( 255, 0, 0, 128 ) )
			render.DrawSprite( thisMathPool.conePos, 128, 128, Color( 255, 255, 0, 255 ) ) ////
			
			render.DrawSprite( thisMathPool.traceres.HitPos, 256, 256, Color( 255, 255, 255, 255 ) ) ////
			
		end
		
		function BEACON:DrawUnderCircle2D( ent )
		end
		
		function BEACON:DrawOverCircle( ent )
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "bolts" )
		
	end
	
	do
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
		
		function BEACON:PerformMath( ent )			
		end
		
		function BEACON:DrawUnderCircle( ent )
			render.SetMaterial( self.myMaterial )
			render.DrawBeam( ent:GetShootPos(), ent:GetShootPos() + ent:GetAimVector() * 1024, 64, 0.5, 1, Color( 255, 255, 255, 64 ) )
			
		end
		
		function BEACON:DrawUnderCircle2D( ent )
		end
		
		function BEACON:DrawOverCircle( ent )
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "LOS" )
		
	end
	
	do
		local BEACON = {}
		BEACON.Name         = "Nades"
		BEACON.DefaultOn    = true
		BEACON.IsStandAlone = false
		
		function BEACON:Initialize()
			self.myMathPool = {}
			self.myMaterial = Material( "effects/yellowflare" )
			
		end
		
		function BEACON:ShouldTag( entity )
			return entity:GetClass() == "npc_grenade_frag"
			
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
			
			for i=1,10 do
				render.DrawBeam( thisMathPool.conePos, thisMathPool.conePos - ent:GetVelocity() + VectorRand() * 128, 32, 0.5, 1, Color( 255, 0, 0, 128 ) )
			end
			render.DrawSprite( thisMathPool.conePos, 256 + 128 * math.sin( CurTime() * math.pi * 2 * 3 ), 256 + 128 * math.sin( CurTime() * math.pi * 2 * 3 ), Color( 255, 0, 0, 255 ) ) ////
			
		end
		
		function BEACON:DrawUnderCircle2D( ent )
		end
		
		function BEACON:DrawOverCircle( ent )
			
		end

		function BEACON:DrawOverEverything( ent, fDist, fAngle )
		end
		
		proxi.RegisterBeacon( BEACON, "nades" )
		
	end
	
end