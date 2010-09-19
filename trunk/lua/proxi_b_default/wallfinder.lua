local BEACON = {}
BEACON.Name         = "Wallfinder v1 (in development)"
BEACON.DefaultOn    = false
BEACON.IsStandAlone = true

function BEACON:Mount()
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
	self.iTracesPerFrame  = 2
	
	self.iRevAngle  = 0
	self.iRevolution = 90
	
	self.tWalls = {}
	self.iWall  = 1
	self.iMaxWalls = self.iRevolution * 3
	
	for i = 1, self.iMaxWalls do
		self.tWalls[ i ] = {}
		
	end
	
	self.traceData = {}
	self.traceData.mask = CONTENTS_SOLID
	self.traceData.filter = nil
	self.traceangle = Angle( 0, 0, 0 )
	
	self.traceRes = {}
	
	self.upNorm = Vector( 0, 0, 1 )
	
end

function BEACON:PerformMath( )
	for iTraceNum = 1, self.iTracesPerFrame do
		local CVD = proxi:GetCurrentViewData()
		local radius = CVD.radius_const
		self.traceData.start = LocalPlayer():GetShootPos()
		self.traceangle.y = ( self.iRevAngle / self.iRevolution ) * 360
		self.traceData.endpos = self.traceData.start + self.traceangle:Forward() * radius
		
		self.traceRes = util.TraceLine( self.traceData )
		if self.traceRes.Hit then
			local crossMul = self.traceRes.HitNormal:Cross( self.upNorm ) * radius * 0.1
			self.tWalls[ self.iWall ][1] = self.traceRes.HitPos + crossMul
			self.tWalls[ self.iWall ][2] = self.traceRes.HitPos - crossMul
			
			
			-- Keep the following when something gets hit.
			//self.iWall = self.iWall + 1
			//self.iWall = ((self.iWall - 1) % self.iMaxWalls) + 1
			// is equivalent to
			self.iWall = (self.iWall % self.iMaxWalls) + 1
		end
		
		--Keep the following at the end.
		self.iRevAngle = (self.iRevAngle + 1) % self.iRevolution
		
	end
	
end

function BEACON:DrawUnderCircle( )
	render.DrawBeam( self.traceData.start, self.traceData.endpos, 64, 0.5, 1, Color( 192, 128, 255, 128 ) )
	
	render.SetMaterial( self.myMaterial )
	for i = 1, self.iMaxWalls do
		if self.tWalls[ i ][1] ~= nil then
			render.DrawBeam( self.tWalls[ i ][1], self.tWalls[ i ][2], 64, 0, 1, Color( 192, 128, 255, 128 ) )
			
		end
		
	end
	
end

proxi.RegisterBeacon( BEACON, "wallfinder" )
