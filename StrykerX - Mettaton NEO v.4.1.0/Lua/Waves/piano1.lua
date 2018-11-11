--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
Toned down the timeflows greatly
Increase gaster laser delay slightly, separate the second pair
Tweaked the maze to have more leeway

]]

oblib = require "objectdefs"

waveStartTime = Time.time
waveLength = 8.0
ourTime = Time.time
timeMult = 1

playerbullet = CreateProjectile("yh0", Player.x, Player.y)
--"tile = 1" just means the onHit function ignores this bullet
playerbullet.SetVar('tile', 1)

blackbullet = CreateProjectileAbs("blackfade/black",325,230)
blackbullet.sprite.alpha = 0
blackbullet.SetVar('tile', 1)
blackbullet.SendToBottom()

NORMAL = 0
THIN = 1
LARGE = 2

ORANGE = 0
BLUE = 1

--When a Gaster Blaster's endX or endY equals -42, it'll instead change itself to be at the player's X or Y, once it's ready to appear.
--Easier than making it a new variable!
PX = -42
PY = -42

lastFireTime = 0
gbs = {}
bots = {}
pbs = {}
sboxes = {}
boxes = {}
bolts = {}
pbombs = {}
pmetts = {}
hearts = {}

--Timeflow commands
flow = {}
flowTime = Time.time
flowHUD = nil
flowHUDTime = Time.time

--With this array, I can set the radius of a given circle, and change it, without messing about with the objects connected to the circle
circles = {}

debugs = {}

oneFrameBullets = {}
--currentFrameBullet = CreateProjectileAbs("white",-50,-50)

--Here, I set up exactly what I want to spawn in and when (using the time variable)

--Circle 1: The metts belong to this one. Its origin point moves based on circle 2?
--table.insert(circles, { radius = 140, offset = 0, originX = 0, originY = 0 } )
--Circle 2: Circle 1 belongs to this one
--table.insert(circles, { radius = 30, offset = 0 } )


local shieldMetts = {}
local allMettsShot = 0

local pianoMode = false
local pianoBullet = nil

local rand1 = math.random(0,1)
if (rand1 == 0) then rand1 = -1 end
local rand2 = math.random(0,1)
if (rand2 == 0) then rand2 = -1 end
local rand3 = math.random(0,1)
if (rand3 == 0) then rand3 = -1 end
local rand4 = math.random(0,1)
if (rand4 == 0) then rand4 = -1 end

waveLength = 17.75
Encounter.SetVar("wavetimer", 17.75)
Arena.Resize(130,130)
pianoMode = true

--Faster. FASTER
--The "harder" version of this wave changes what flow commands are added
if (GetGlobal("attackNum") > 10) then
	--This only happens on the "harder" version of this wave.
	waveLength = 19.25
	Encounter.SetVar("wavetimer", 19.25)
	table.insert(flow, { icon = "rec", start = 1.125, mult = 1.125, dir = 1, rate = 0, length = 5, blink = 1.5 })
	table.insert(flow, { icon = "rec", start = 1.125, mult = 1.25, dir = 1, rate = 0.2, length = 5.4, blink = 2 })
	--table.insert(flow, { icon = "ff", start = 1.25, mult = 1.4, dir = 1, rate = 0.2, length = 6, blink = 2 })
	table.insert(flow, { icon = "rew", start = 1.25, mult = -1.25, dir = -1, rate = -1.8, length = 12, blink = 2 })

else
	table.insert(flow, { icon = "play", start = 1.0, mult = 1.0, dir = 1, rate = 0, length = 9 })
	table.insert(flow, { icon = "ff", start = 1.0, mult = 1.25, dir = 1, rate = 0.2, length = 9, blink = 2 })
end

local ysp = -110
--Row of unshootable boxes with a plus bomb. (Left bomb)
for i = 248,392,24 do
	if (i == 272) then
		table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime }))
	else
		table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime }))
	end
end

--Right bomb
for i = 248,392,24 do
	if (i == 368) then
		table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 0.4 }))
	else
		table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 0.4 }))
	end
end

--Middle bomb
for i = 248,392,24 do
	if (i == 320) then
		table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 0.8 }))
	else
		table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 0.8 }))
	end
end


--Blasties covering two of the three rows either horiz or vert
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = 510, endX = 184, endY = 160+(rand1*22), time = ourTime+2.8, rotation = 270, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = 510, endX = 320+(rand2*22), endY = 290, time = ourTime+3.5, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = 670, startY = -30, endX = 456, endY = 160+(rand3*22), time = ourTime+4.8, rotation = 90, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = 670, startY = -30, endX = 320+(rand4*22), endY = 30, time = ourTime+5.1, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))

local ysp2 = 180
local timer = 6.2

--Creating a maze of bolts, twice
--This is by far the least readable wave creation code... it's a pain to try to change haha

for i = 0,100,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 346, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
	table.insert(bolts, oblib.Bolt.new({ startX = 386, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
end

--left side wall going leftward
for i = 1,6,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 346-(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((100 + i*3)/ysp2) }))
end

--right side wall going up some more, alone
for i = 120,200,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 386, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--right side wall going leftward
for i = 1,6,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 386-(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((200 + i*3)/ysp2) }))
end

--left side wall going up alone
for i = 138,218,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--both going up
for i = 238,338,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
	table.insert(bolts, oblib.Bolt.new({ startX = 296, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
end

--right wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 296+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((338)/ysp2) }))
end

--left wall going up
for i = 358,438,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

iJustCopiedThisWithoutLooking = true

--left wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((438)/ysp2) }))
end

--right wall going up
for i = 358,438,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 341, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--right wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 341+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((438)/ysp2) }))
end

--left wall going up
for i = 458,538,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 301, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--left wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 301+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((538)/ysp2) }))
end

--right wall going up
for i = 458,538,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 386, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--and then the whole thing again

timer = timer + (558/ysp2)

for i = 0,100,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 346, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
	table.insert(bolts, oblib.Bolt.new({ startX = 386, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
end

--left side wall going leftward
for i = 1,6,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 346-(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((100 + i*3)/ysp2) }))
end

--right side wall going up some more, alone
for i = 120,200,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 386, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--right side wall going leftward
for i = 1,6,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 386-(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((200 + i*3)/ysp2) }))
end

--left side wall going up alone
for i = 138,218,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--both going up
for i = 238,338,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
	table.insert(bolts, oblib.Bolt.new({ startX = 296, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2) }))
end

--right wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 296+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((338)/ysp2) }))
end

--left wall going up
for i = 358,438,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--left wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 256+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((438)/ysp2) }))
end

--right wall going up
for i = 358,438,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 341, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end
--[[
--right wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 341+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((438)/ysp2) }))
end

--left wall going up
for i = 458,538,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 301, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end

--left wall going right
for i = 1,3,1 do
	table.insert(bolts, oblib.Bolt.new({ startX = 301+(i*15), startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + ((538)/ysp2) }))
end

--right wall going up
for i = 458,538,20 do
	table.insert(bolts, oblib.Bolt.new({ startX = 386, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp2, time = ourTime + timer + (i/ysp2)}))
end
]]
--This is kind of silly, but basically, I changed how "yspeed" works and I need it to be NEGATIVE ysp2.
--But that'd mess up their timers. So I just change it here
--I also make them simple and die off at bottom of the screen here
for i = #bolts,1,-1 do
	bolts[i].yspeed = -bolts[i].yspeed
	bolts[i].simple = true
	bolts[i].bottomScreenDead = true
end


--Row of unshootable boxes with a plus bomb. (Left bomb)
for i = 248,392,24 do
	if (i == 272) then
		table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 13 }))
	else
		table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 13 }))
	end
end

--Right bomb
for i = 248,392,24 do
	if (i == 368) then
		table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 13.4 }))
	else
		table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 13.4 }))
	end
end

--Middle bomb
for i = 248,392,24 do
	if (i == 320) then
		table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 13.8 }))
	else
		table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = i, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + 13.8 }))
	end
end

--Blasties covering two of the three rows either horiz or vert
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 184, endY = 160+(rand1*22), time = ourTime+15.8, rotation = 270, size = NORMAL, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 320+(rand2*22), endY = 290, time = ourTime+16.5, rotation = 0, size = NORMAL, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 456, endY = 160+(rand3*22), time = ourTime+17.8, rotation = 90, size = NORMAL, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 320+(rand4*22), endY = 30, time = ourTime+18.1, rotation = 180, size = NORMAL, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
	

if (pianoMode) then
	--Piano prep
	Player.SetControlOverride(true)
	pianoBullet = CreateProjectile("pianomode",0,0)
	pianoBullet.SetVar('tile',1)
end	

function Update()

	--Time flow shenanigans
	if (#flow > 0) then
		if (Time.time - flowTime < flow[1].length) then
			local timeDiff = Time.time - flowTime
			timeMult = flow[1].start + timeDiff * flow[1].rate
			if (flow[1].dir == 1) then timeMult = math.min(timeMult, flow[1].mult)
			else timeMult = math.max(timeMult, flow[1].mult) end
		else
			table.remove(flow,1)
			flowTime = Time.time
			for i=#gbs,1,-1 do
				if (gbs[i].rev == true) then
					--gbs[i].s1 = false
					--gbs[i].s2 = false
				end
			end
		end
	end

	ourTime = ourTime + (Time.dt * timeMult)

	--Remove bullets to be displayed only one frame
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	
	local waveTimeDiff = Time.time - waveStartTime
	local ourWaveTimeDiff = ourTime - waveStartTime
	
	--Piano mode. 44 = a third of the arena size. 440 = It only takes 1/10th of a second (three frames) to get there
	--That's how long it takes to change rows in Muffet's fight
	if (pianoMode) then
		if (Input.Right > 0) then
			Player.MoveTo(math.min(44, Player.x + Time.dt*440),Player.y,true)
		elseif (Input.Left > 0) then 
			Player.MoveTo(math.max(-44, Player.x - Time.dt*440),Player.y,true)
		else
			if (Player.x > 0) then
				--rubberbanding leftward to center
				Player.MoveTo(math.max(0, Player.x - Time.dt*440),Player.y,true)
			else
				--rightward
				Player.MoveTo(math.min(0, Player.x + Time.dt*440),Player.y,true)
			end
		end
		
		if (Input.Up > 0) then
			Player.MoveTo(Player.x,math.min(44, Player.y + Time.dt*440),true)
		elseif (Input.Down > 0) then 
			Player.MoveTo(Player.x,math.max(-44, Player.y - Time.dt*440),true)
		else
			if (Player.y > 0) then
				--rubberbanding downward to center
				Player.MoveTo(Player.x,math.max(0, Player.y - Time.dt*440),true)
			else
				--upward
				Player.MoveTo(Player.x,math.min(0, Player.y + Time.dt*440),true)
			end
		end
	end
	
	--playerbullet.MoveTo(Player.x, Player.y)
	--Blink the heart at 15 fps if hurting
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.sprite.Set("yh" .. heartframe)
	playerbullet.MoveTo(Player.x,Player.y)
	
	--Check for firing bullets. Rule: Can fire if there's zero bullets out, or it's been half a second
	--It uses Time.time instead of ourTime because the player's bullets shouldn't be affected by timeflow shenanigans
	if (Input.Confirm == 1) then
		if (#pbs == 0 or (Time.time - lastFireTime > 0.5)) then
			--Fire a bullet
			lastFireTime = Time.time
			table.insert(pbs, { x = Player.absx, y = Player.absy, time = Time.time })
			Audio.PlaySound("pew")
			
		end
	end

	for i=#pbs,1,-1 do
		--Check for collision with collidable things here?
		local timeDiff = Time.time - pbs[i].time
		local curFrame = math.floor(timeDiff / (1/30))
		if (curFrame > 20) then curFrame = 20 end
		--Here, I'm just trying to be accurate. Your shots move about 16 pixels per (30fps) frame (hence the 1/60 * 8)
		--but they also pick up a slight amount of speed over time it seems
		--End result looks great!
		local by = pbs[i].y - 24 + (timeDiff/(1/60))*8 + timeDiff*60
		
		--Is boolet offscreen?
		if (by > 480) then
			table.remove(pbs,i)
		else
			--Last H represents the height of the bullet (increases over time)
			pbs[i].lastY = by
			pbs[i].lastH = 10 + (curFrame * 2)
			--Collision used to be here, but I moved it to the object update functions.
			--Less useless checks. Should run a lot better that way.
			local bullet = CreateProjectileAbs("bullet/" .. curFrame, pbs[i].x, by)
			bullet.SetVar('tile',1)
			bullet.SendToBottom()
			table.insert(oneFrameBullets, bullet)
		end
	end

	--Parasol Mettaton heart bullets (they need to be drawn below the mettatons)
	for i=#hearts,1,-1 do
		if (ourTime > hearts[i].time) then hearts[i].Update() end
		if (hearts[i].dead) then
			hearts[i].bullet.Remove()
			hearts[i].hitbox.Remove()
			table.remove(hearts,i)
		end
	end
	
	--Parasol Mettatons
	for i=#pmetts,1,-1 do
		if (ourTime > pmetts[i].time) then pmetts[i].Update() end
		if (pmetts[i].dead) then
			pmetts[i].bullet.Remove()
			table.remove(pmetts,i)
		end
	end
	
	--Shootable black boxes
	for i=#sboxes,1,-1 do
		if (ourTime > sboxes[i].time) then sboxes[i].Update() end
		if (sboxes[i].dead) then
			sboxes[i].bullet.Remove()
			table.remove(sboxes,i)
		end	
	end
	
	--Unshootable boxes
	for i=#boxes,1,-1 do
		if (ourTime > boxes[i].time) then boxes[i].Update() end
		if (boxes[i].dead) then
			boxes[i].bullet.Remove()
			table.remove(boxes,i)
		end
	end
	
	--Lightning bolts
	for i=#bolts,1,-1 do
		--Special restrictions for rewinding this wave. Don't destroy bolts
		if (ourTime > bolts[i].time) then bolts[i].Update() end
		if (bolts[i].dead and GetGlobal("attackNum") < 10) then
			bolts[i].bullet.Remove()
			table.remove(bolts,i)
		end
	end
	
	--Bots (drawn before bombs)
	for i=#bots,1,-1 do
		if (ourTime > bots[i].time) then bots[i].Update() end
		if (bots[i].dead) then
			bots[i].bullet.Remove()
			if (bots[i].laser ~= nil) then
				bots[i].laser.Remove()
			end
			table.remove(bots,i)
		end
	end
	
	--Plus bombs
	bombsound = false
	
	for i=#pbombs,1,-1 do
		if (ourTime > pbombs[i].time) then pbombs[i].Update() end
		--Pbombs remove their own bullet because blast
		if (pbombs[i].dead) then table.remove(pbombs,i) end
	end
	
	

	--Draw the HUD for record/rewind/etc
	--Gaster blasters get drawn on top of it, cause, blasters don't care bout no GUI!
	if (#flow > 0) then
		if (flowHUD ~= nil) then flowHUD.SendToTop() end
		local sprite = "timeflow/" .. flow[1].icon
		
		local freq = 1/3
		if (flow[1].blink ~= nil) then freq = freq / flow[1].blink end
		--...I have no idea if this will work
		if (Time.time - flowHUDTime > freq) then
			flowHUDTime = Time.time
			if (flowHUD == nil) then
				flowHUD = CreateProjectile(sprite, math.floor(Arena.width/2) - 41, -math.floor(Arena.height/2) + 11)
				flowHUD.SetVar('tile',1)
			else
				flowHUD.Remove()
				flowHUD = nil
			end
		end
		
	end
	
	for i=#gbs,1,-1 do
		if (ourTime > gbs[i].time) then gbs[i].Update()
		else gbs[i].bullet.MoveToAbs(-500,-500) end
		if (gbs[i].dead and GetGlobal("attackNum") < 10) then
			gbs[i].bullet.Remove()
			table.remove(gbs,i)
		end
	end
	
	--Draw the black translucent bullet that goes over everything but the arena (fades in/out at start/end of wave)
	--I want to go from 0% to 50% opacity in a third of a second
	if (Time.time - waveStartTime < 0.5) then
		local timeDiff = Time.time - waveStartTime
		blackbullet.sprite.alpha = math.min(0.5, timeDiff / (2/3))
	elseif (Time.time - waveStartTime > waveLength - (1/3)) then
		local timeDiff = Time.time - waveStartTime - (waveLength - (1/3))
		blackbullet.sprite.alpha = 0.5 - math.min(0.5, timeDiff / (2/3))
	end
	blackbullet.SendToBottom()
	
	if (pianoBullet ~= nil) then pianoBullet.SendToBottom() end
	
	--playerbullet.SendToTop()

end

function OnHit(bullet)
	--"Tile" bullets shouldn't collide with the player. Board tiles, fading lasers, whatever else
	if(bullet.GetVar('tile') ~= 1) then
		if (bullet.GetVar('color') == BLUE) then
			if (Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage'))
			end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (not Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage'))
			end
		else
			Player.Hurt(bullet.GetVar('damage'))
		end
	end
end
