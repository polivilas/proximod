local BEACON = {}
BEACON.Name         = "Wallfinder with Traceback (Resource Intensive)"
BEACON.DefaultOn    = false
BEACON.IsStandAlone = true

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
	self.iPierceTimes  = 2
	self.iTracesPerFrame  = 5
	self.iGap  = 1 / self.iTracesPerFrame
	
	self.iRevAngle  = 0
	self.iRevolution = 120
	
	self.tWalls = {}
	self.iWall  = 1
	self.iMaxWalls = self.iRevolution * 6 // MAX WALLS IS DOUBLED AS OPPOSED TO PIERCER
	
	for i = 1, self.iMaxWalls do
		self.tWalls[ i ] = {}
		
	end
	
	self.traceData = {}
	self.traceData.mask = CONTENTS_SOLID
	self.traceData.filter = nil
	self.traceangle = Angle( 0, 0, 0 )
	self.radius = 0
	
	self.traceRes = {}
	
	self.tracebackData = {}
	self.tracebackData.mask = CONTENTS_SOLID
	self.tracebackData.filter = nil
	
	self.tracebackRes = {}
	
	self.upNorm = Vector( 0, 0, 1 )
	
	self.wallColors = { Color( 192, 128, 255, 128 ), Color( 255, 128, 192, 128 ), Color( 255, 255, 128, 128 ) }
	
end

function BEACON:PerformMath( )
	local numTracesPerformed = 0
	local CVD = proxi:GetCurrentViewData()
	local zPos = CVD.referencepos.z
	for iTraceNum = 1, self.iTracesPerFrame do
		
		self.radius = CVD.radiuseval * 1.5
		self.traceData.start = CVD.referencepos
		self.tracebackData.endpos = CVD.referencepos
		self.traceangle.y = ( self.iRevAngle / self.iRevolution ) * 360
		self.traceData.endpos = self.traceData.start + self.traceangle:Forward() * self.radius
		
		self.traceRes = util.TraceLine( self.traceData )
		numTracesPerformed = numTracesPerformed + 1
		if self.traceRes.Hit then
			local crossMul = self.traceRes.HitNormal:Cross( self.upNorm ) * self.radius * 0.1
			self.tWalls[ self.iWall ][1] = self.traceRes.HitPos + crossMul
			self.tWalls[ self.iWall ][2] = self.traceRes.HitPos - crossMul
			self.tWalls[ self.iWall ][3] = 1
			self.tWalls[ self.iWall ][4] = zPos
			
			-- Keep the following when something gets hit.
			//self.iWall = self.iWall + 1
			//self.iWall = ((self.iWall - 1) % self.iMaxWalls) + 1
			// is equivalent to
			self.iWall = (self.iWall % self.iMaxWalls) + 1
			
			local pierceTime = 1
			while (pierceTime <= self.iPierceTimes) and self.traceRes.Hit do
				self.traceData.start = self.traceRes.HitPos + self.traceangle:Forward()
				self.traceRes = util.TraceLine( self.traceData )
				numTracesPerformed = numTracesPerformed + 1
				if self.traceRes.Hit then
					local crossMul = self.traceRes.HitNormal:Cross( self.upNorm ) * self.radius * 0.1
					self.tWalls[ self.iWall ][1] = self.traceRes.HitPos + crossMul
					self.tWalls[ self.iWall ][2] = self.traceRes.HitPos - crossMul
					self.tWalls[ self.iWall ][3] = 2
					self.tWalls[ self.iWall ][4] = zPos
				
					self.iWall = (self.iWall % self.iMaxWalls) + 1
					
					self.tracebackData.start = self.traceRes.HitPos - self.traceangle:Forward()
					self.tracebackRes = util.TraceLine( self.tracebackData )
					numTracesPerformed = numTracesPerformed + 1
					if self.tracebackRes.Hit then // It should always hit something, otherwise it's weird...
						local crossMul = self.tracebackRes.HitNormal:Cross( self.upNorm ) * self.radius * 0.1
						self.tWalls[ self.iWall ][1] = self.tracebackRes.HitPos + crossMul
						self.tWalls[ self.iWall ][2] = self.tracebackRes.HitPos - crossMul
						self.tWalls[ self.iWall ][3] = 3
						self.tWalls[ self.iWall ][4] = zPos
					
						self.iWall = (self.iWall % self.iMaxWalls) + 1
						
					end
					
				end
				
				pierceTime = pierceTime + 1
				
			end
			
		end
		
		//print( "Performed ".. numTracesPerformed .." traces this frame." )
		
		--Keep the following at the end.
		self.iRevAngle = self.iRevAngle + self.iRevolution * self.iGap
		
	end
	
	self.iRevAngle = (self.iRevAngle + 1) % self.iRevolution
	
end

function BEACON:DrawUnderCircle( )
	local CVD = proxi:GetCurrentViewData()
	for i = 1, self.iTracesPerFrame do
		render.DrawBeam( CVD.referencepos, CVD.referencepos + self.traceangle:Forward() * self.radius, 64, 0.5, 1, Color( 192, 128, 255, 12 ) )
		self.traceangle.y = self.traceangle.y - (1 / self.iRevolution) - self.iGap * 360
		
	end
	
	render.SetMaterial( self.myMaterial )
	for i = 1, self.iMaxWalls do
		if self.tWalls[ i ][1] ~= nil then
			render.DrawBeam( self.tWalls[ i ][1], self.tWalls[ i ][2], 32 * CVD.radiuseval / CVD.baseratio_nomargin / 8192, 0, 1, self.wallColors[ self.tWalls[ i ][3] ] )
			
		end
		
	end
	
end

proxi.RegisterBeacon( BEACON, "wallfinderpierceback" )
