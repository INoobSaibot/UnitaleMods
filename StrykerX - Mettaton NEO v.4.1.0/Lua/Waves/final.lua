--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
Less lasers at the start
Longer blaster delay
Bolt circle number/rotation speed tweaked to be better with the new less-lasery board
More spacing between plusbomb walls in the gaster chase (and less rows as a result)
Note chart display during the rhythm finale
Damage taken decreases each time Alphys melts further

]]

oblib = require "objectdefs"

--The big final attack.

waveStartTime = Time.time
waveLength = 8.0
ourTime = Time.time
timeMult = 1.2

playerbullet = CreateProjectile("yh0", Player.x, Player.y)
--"tile = 1" just means the onHit function ignores this bullet
playerbullet.SetVar('tile', 1)

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

waveLength = 90
Encounter.SetVar("wavetimer", 90.0)
Arena.Resize(200,200)
Player.MoveTo(0,0+35,true)
--pianoMode = true

hints = {}

table.insert(flow, { icon = "rec", start = 1.0, mult = 1.0, dir = 1, rate = 0, length = 13 })
table.insert(flow, { icon = "rew", start = 1.0, mult = -1, dir = -1, rate = -2, length = 5, endPhase1 = true})
table.insert(flow, { icon = "ff", start = -1, mult = 1.25, dir = 1, rate = 2, length = 4.75, endPhase2 = true, blink = 2 })
table.insert(flow, { icon = "play", start = 1.25, mult = 1.0, dir = -1, rate = -0.2, length = 10 })
table.insert(flow, { icon = "ff", start = 1.0, mult = 1.5, dir = 1, rate = 0.1, length = 9.6, blink = 2, endPhase3 = true })
table.insert(flow, { icon = "slow", start = 1.5, mult = 0.75, dir = -1, rate = -0.4, length = 10, blink = 0.5 })
table.insert(flow, { icon = "play", start = 0.75, mult = 1, dir = 1, rate = 0.25, length = 13, blink = 1, endPhase4 = true })
table.insert(flow, { icon = "play", start = 1, mult = 1/12, dir = -1, rate = -0.1, length = 20, blink = 0.25 })

--Slight laser grid.
for i = 260, 380, 120 do
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = i, startY = 330, time = ourTime, rotation = 0, color = ORANGE }))
end
for i = 135, 255, 120 do
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 180, startY = i, time = ourTime, rotation = 270, color = ORANGE }))
end

--Two blasters come in covering a row or column, over and over.
--The first wave, either the player's row or player's column gets chosen, for sure.
local rand1 = math.random(0,1)
local rand2 = math.random(0,4)
local rand3 = math.random(0,4)

if (rand1 == 1) then
	rand2 = 2
	table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = -30, endX = 156, endY = 195, time = ourTime+0.7, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
	table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = 510, endX = 240+(rand3*40), endY = 360, time = ourTime+0.7, rotation = 0, size = THIN, laserDelay = 0.9, laserLength = 0.55 }))

else
	rand3 = 2
	table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = -30, endX = 156, endY = 115+(rand2*40), time = ourTime+0.7, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
	table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = 510, endX = 320, endY = 360, time = ourTime+0.7, rotation = 0, size = THIN, laserDelay = 0.9, laserLength = 0.55 }))

end
--From there, they just don't pick the same twice in a row, and have a chance to choose the same row/column as the player so you can't find a safe spot
	for i = 224,416,24 do
		table.insert(sboxes, oblib.ShootableBox.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -60, time = ourTime+0.7, bottomScreenDead = false }))
                     end

for i = 1.4,7,0.7 do
	local tempbox = math.random(0,4)
	while (tempbox == rand2) do tempbox = math.random(0,4) end
	rand2 = tempbox
	tempbox = math.random(0,4)
	while (tempbox == rand3) do tempbox = math.random(0,4) end
	rand3 = tempbox
	--20% chance of same row as player. Don't want them to just camp some place "safe"~
	if (math.random() < 0.2) then
		table.insert(pmetts, oblib.Parasol.new( { lifetime = 5, startX = 160, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = 220, xspeed2 = 0, yspeed2 = 80, speedTime = 1, time = ourTime+i, ammo = 1, delay = 1, firstShot = 0.8, flingDir = -1 }))
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = -30, endX = 156, endY = -42, time = ourTime+i, rotation = 270, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
	else
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = -30, endX = 156, endY = 115+(rand2*40), time = ourTime+i, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
	end
	if (math.random() < 0.2) then
		table.insert(pmetts, oblib.Parasol.new( { lifetime = 5, startX = 480, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = 220, xspeed2 = 0, yspeed2 = 80, speedTime = 1, time = ourTime+i, ammo = 1, delay = 1, firstShot = 0.8, flingDir = 1 }))
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = 510, endX = -42, endY = 360, time = ourTime+i, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.55 }))
	else
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 2, startX = -30, startY = 510, endX = 240+(rand3*40), endY = 360, time = ourTime+i, rotation = 0, size = THIN, laserDelay = 0.9, laserLength = 0.55 }))
	end
end

--Circles come from the top of the screen and then spread out.
local timer = 0.8
local timeroffset = 7
local boltcount = 10
local boltmult = 360/boltcount

local numberOfCircs = 6

for i = 0, numberOfCircs-1, 1 do
	local rs
	--These speeds are relatively low but they're harsher during the fast forward, and the orange lasers make it hard enough already.
	if (i == 0) then rs = 50
	elseif (i == 1) then rs = -50
	elseif (i == 2) then rs = 70
	elseif (i == 3) then rs = -70
	elseif (i == 4) then rs = 100
	elseif (i == 5) then rs = -100
	end
	for j = 1, boltcount, 1 do
		table.insert(bolts, oblib.Bolt.new({ circleID = i+1, rotation = j*boltmult, rspeed = rs, startX = 320, startY = 680, endY = 380, yspeed = 400, time = ourTime+timeroffset+timer*i, bounce = false }))
	end
	table.insert(circles, { startR = 30, endR = 99999, shrinkSpeed = 160, time = ourTime+timeroffset+0.75+timer*i, offset = math.random()*360 } )
end

--Breakable plusbomb walls at 13.7 seconds

local timeroffset = 14
local ysp = -78
local timer = 24/(-ysp)

for j = 0, 4, 1 do
	local bombspot = math.random(0,6)
	for i = 0,6,1 do
		if (i == bombspot) then
			table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = 248+i*24, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + timeroffset + j*timer }))
		else
		                     table.insert(pmetts, oblib.Parasol.new( { lifetime = 5, startX = 160, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = 220, xspeed2 = 0, yspeed2 = 80, speedTime = 1, time = ourTime + timeroffset, ammo = 2, delay = 1, firstShot = 0.8, flingDir = -1 }))
		                     table.insert(pmetts, oblib.Parasol.new( { lifetime = 5, startX = 480, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = 220, xspeed2 = 0, yspeed2 = 80, speedTime = 1, time = ourTime + timeroffset, ammo = 2, delay = 1, firstShot = 0.8, flingDir = 1 }))
			table.insert(boxes, oblib.Box.new({ bottomScreenDead = true, simple = true, startX = 248+i*24, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + timeroffset+j*timer }))
		end
	end
end


--All plusbomb walls which get detonated by gaster blasters when they reach the bottom of the screen.
--This lasts a while. The time gets sped up, and... I dunno, it feels good to get in the pattern.
--It's like Sans' gaster blaster circle in that way
local timeroffset = 18
local ysp = -120
local timer = 1.74

for j = 0, 10, 1 do
	for i = 0,6,1 do
			table.insert(pbombs, oblib.PlusBomb.new({ bottomScreenDead = true, simple = true, startX = 248+i*24, startY = 500, endX = 0, endY = -5000, xspeed = 0, yspeed = ysp, time = ourTime + timeroffset + j*timer, fuse = 3.7 }))
	end
	
	table.insert(gbs, oblib.GasterBlaster.new( { lifetime = 2, startX = 670, startY = -30, endX = 510, endY = 50, time = ourTime+timeroffset+j*timer+2.8, rotation = 90, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
	table.insert(gbs, oblib.GasterBlaster.new( { lifetime = 2, startX = 670, startY = -30, endX = 510, endY = -42, time = ourTime+timeroffset+j*timer+2.8, rotation = 90, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
	
end

--Then, the piano mode finale. New song starts at 41 ourTime
--This is all carefully synced with the outro ogg.

local baseOffset = 41

local boltSpeed = 800

--This was an easy way to slightly tweak these bolts' starting time to make them sync well if need be; keep track of the start of them in the array
local startOfPianoBolts = #bolts

for i = 0, 3, 1 do
	local offset = baseOffset + (5.33333*i)
	table.insert(hints, { file = "hintneutral", time = ourTime + offset })
	
	--Little pairs of two bolts come and pass through all the incorrect buttons
	--They all start 370 away from their destination?
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	offset = offset + 0.33
	
	table.insert(hints, { file = "hintup", time = ourTime + offset })
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+0-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+0+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	offset = offset + 0.33
	
	table.insert(hints, { file = "hintright", time = ourTime + offset })
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	offset = offset + 0.34
	
	table.insert(hints, { file = "hintneutral", time = ourTime + offset })
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	offset = offset + 0.33
	
	table.insert(hints, { file = "hintdown", time = ourTime + offset })
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	offset = offset + 0.5
	
	table.insert(hints, { file = "hintdown", time = ourTime + offset })
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	offset = offset + 0.5
	
	table.insert(hints, { file = "hintright", time = ourTime + offset })
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
	
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
	table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
	
	if (i < 3) then
		offset = offset + 0.67
	
		table.insert(hints, { file = "hintneutral", time = ourTime + offset })
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
		
		offset = offset + 0.33
		
		table.insert(hints, { file = "hintright", time = ourTime + offset })
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
		
		offset = offset + 0.33
		
		table.insert(hints, { file = "hintneutral", time = ourTime + offset })
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
		
		offset = offset + 0.34
		
		table.insert(hints, { file = "hintdown", time = ourTime + offset })
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0-10, xspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0+10, xspeed = -boltSpeed, time = ourTime+offset }))
		
		offset = offset + 0.5
		
		table.insert(hints, { file = "hintdown", time = ourTime + offset })
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0-10, xspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-0+10, xspeed = -boltSpeed, time = ourTime+offset }))
		
		offset = offset + 0.5
		
		table.insert(hints, { file = "hintright", time = ourTime + offset })
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0-10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 320+0+10, startY = 530, yspeed = -boltSpeed, time = ourTime+offset }))
		
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+offset }))
		table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 2, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+offset }))
		
	end
end

table.insert(hints, { file = "hintneutral", time = ourTime + baseOffset + 18.67 })

boltSpeed = 400

table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = 320-44-10, startY = -210, yspeed = boltSpeed, time = ourTime+baseOffset+18.67 }))
table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = 320-44+10, startY = -210, yspeed = boltSpeed, time = ourTime+baseOffset+18.67 }))

table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = -100, startY = 160+44-10, xspeed = boltSpeed, time = ourTime+baseOffset+18.67 }))
table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = -100, startY = 160+44+10, xspeed = boltSpeed, time = ourTime+baseOffset+18.67 }))

table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = 320+44-10, startY = 530, yspeed = -boltSpeed, time = ourTime+baseOffset+18.67 }))
table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = 320+44+10, startY = 530, yspeed = -boltSpeed, time = ourTime+baseOffset+18.67 }))

table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = 740, startY = 160-44-10, xspeed = -boltSpeed, time = ourTime+baseOffset+18.67 }))
table.insert(bolts, oblib.Bolt.new({ simple = true, lifetime = 3, startX = 740, startY = 160-44+10, xspeed = -boltSpeed, time = ourTime+baseOffset+18.67 }))

--[[
for i = 1,#hints,1 do
	local thisTime = hints[i].time
	local otherHint = math.random(1,#hints)
	local otherTime = hints[otherHint].time
	
	for j = 1,#bolts,1 do
		if (bolts[j].time == thisTime) then
			bolts[j].time = otherTime
		elseif (bolts[j].time == otherTime) then
			bolts[j].time = thisTime
		end
	end
	
	hints[i].time = otherTime
	hints[otherHint].time = thisTime
	
end
]]


for i = startOfPianoBolts+1,#bolts,1 do
	--bolts[i].time = bolts[i].time - 0.2
	bolts[i].time = bolts[i].time - 0.25
end



--Default variables for circles
for i = #circles,1,-1 do
	circles[i].radius = circles[i].startR
	if (circles[i].endR == nil) then circles[i].endR = circles[i].startR end
	if (circles[i].shrinkSpeed == nil) then circles[i].shrinkSpeed = 0 end
	if (circles[i].offset == nil) then circles[i].offset = 0 end
end


local switched = 0
--This is a way for Alphys to deal more damage at the start of the fight, but then it gets lower and lower as she melts.
--Damage starts at the same level as Hard Mode
local damageMult = 4/3

function Update()

	--Time flow shenanigans
	if (#flow > 0) then
		if (Time.time - flowTime < flow[1].length) then
			local timeDiff = Time.time - flowTime
			timeMult = flow[1].start + timeDiff * flow[1].rate
			if (flow[1].dir == 1) then timeMult = math.min(timeMult, flow[1].mult)
			else timeMult = math.max(timeMult, flow[1].mult) end
		else
			--Hacky way to change some things up to change phases and Alphys' sprite during the final attack synced with timeflow changes
			if (flow[1].endPhase1 == true) then
				Encounter.GetVar("enemies")[1].Call("SetSprite","Keebler/melt1")
				damageMult = 1
			elseif (flow[1].endPhase2 == true) then
			
				Arena.Resize(168,200)
				
				for i = 1,4,1 do
					bots[i].time = ourTime
					bots[i].off = true
					bots[i].lifetime = 2
					if (i < 3) then bots[i].yspeed = 300
					else bots[i].xspeed = -300 end
				end
				
				for i = 1,#bolts,1 do
					if (bolts[i].circleID ~= nil) then
						if (bolts[i].circleID <= numberOfCircs) then
							--poof they all go
							bolts[i].offScreenDead = true
						end
					end
				end
			elseif (flow[1].endPhase3 == true) then
				damageMult = 0.5
				Encounter.GetVar("enemies")[1].Call("SetSprite","Keebler/melt2")
			elseif (flow[1].endPhase4 == true) then
				damageMult = 0.2
				Encounter.GetVar("enemies")[1].Call("SetSprite","Keebler/melt3closedmouth")
			end
			table.remove(flow,1)
			--DEBUG(ourTime - waveStartTime)
			--DEBUG(Audio.playtime)
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

	--In this wave only, audio changes pitch with the time multiplier.
	Audio.Pitch(timeMult)
	--DEBUG(timeMult)
	
	--Remove bullets to be displayed only one frame
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	
	local waveTimeDiff = Time.time - waveStartTime
	local ourWaveTimeDiff = ourTime - waveStartTime
	
	if (switched == 0 and ourWaveTimeDiff > 40) then
		switched = 1
		pianoMode = true
		Player.SetControlOverride(true)
		pianoBullet = CreateProjectile("pianomode",0,-35)
		pianoBullet.SetVar('tile',1)
		boardBullet = CreateProjectileAbs("boardborder",320,420)
		boardBullet.sprite.alpha = 0.5
		Arena.Resize(130,130)
	elseif (switched == 1 and ourWaveTimeDiff > 41) then
		switched = 2
		Audio.LoadFile("AlphysTakesActionOutro")
	elseif (switched == 2 and ourWaveTimeDiff > 62.5) then
		switched = 3
		pianoBullet.Remove()
		boardBullet.Remove()
		if (flowHUD ~= nil) then flowHUD.Remove() end
		for i=#oneFrameBullets,1,-1 do
			oneFrameBullets[i].Remove()
			table.remove(oneFrameBullets,i)
		end
		SetGlobal("DEAD",2)
		State("ENEMYDIALOGUE")
	end
	
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
		
		boardBullet.sprite.alpha = 0.5
		
		for i = #hints,1,-1 do
			--piano mode hint dots
			local timeDiff = ourTime - hints[i].time
			if (timeDiff > 0) then
				local alpha = 1 - timeDiff*4
				if (alpha <= 0) then 
					--table.remove(hints,i)
				else
					local bullet = CreateProjectile(hints[i].file, 0, 0)
					bullet.sprite.alpha = alpha
					bullet.SetVar('tile',1)
					table.insert(oneFrameBullets, bullet)
				end
				
				boardBullet.sprite.alpha = math.max(boardBullet.sprite.alpha,alpha)
				
			end
			
			--note track (the number in this if statement should be half the time it stays on screen?)
			if (timeDiff > -5) then
				local x = 320 - (timeDiff * 200)
				if (x < -40) then
					table.remove(hints,i)
				else
					local bullet = CreateProjectileAbs(hints[i].file .. "board", x, 420)
					bullet.SetVar('tile',1)
					table.insert(oneFrameBullets, bullet)
				end
			end
			
		end
		
		
		
	end
	
	
	
	--Circle radius deciding
	for i = #circles,1,-1 do
		local timeDiff = ourTime - circles[i].time
		if (timeDiff > 0) then
			local rmult = 1
			if (circles[i].startR > circles[i].endR) then rmult = -1 end
			circles[i].radius = circles[i].startR + math.min(circles[i].shrinkSpeed * timeDiff,math.abs(circles[i].endR - circles[i].startR)) * rmult
		else
			circles[i].radius = circles[i].startR
		end
	end
	
	--playerbullet.MoveTo(Player.x, Player.y)
	--Blink the heart at 15 fps if hurting
	--Make it red if piano mode is active (in this wave piano mode being active = no more shooty)
	local heartcolor = "yh"
	if (pianoMode) then heartcolor = "rh" end
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.sprite.Set(heartcolor .. heartframe)
	playerbullet.MoveTo(Player.x,Player.y)
	playerbullet.SendToTop()
	--playerbullet.Remove()
	--playerbullet = CreateProjectile(heartcolor .. heartframe, Player.x, Player.y)
	--playerbullet.SetVar('tile', 1)
	
	--Check for firing bullets. Rule: Can fire if there's zero bullets out, or it's been half a second
	--It uses Time.time instead of ourTime because the player's bullets shouldn't be affected by timeflow shenanigans
	if (pianoMode == false) then 
		if (Input.Confirm == 1) then
			if (#pbs == 0 or (Time.time - lastFireTime > 0.5)) then
				--Fire a bullet
				lastFireTime = Time.time
				table.insert(pbs, { x = Player.absx, y = Player.absy, time = Time.time })
				Audio.PlaySound("pew")
				
			end
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
	
	--Plus bombs
	bombsound = false
	
	for i=#pbombs,1,-1 do
		if (ourTime > pbombs[i].time) then pbombs[i].Update() end
		--Pbombs remove their own bullet because blast
		if (pbombs[i].dead) then table.remove(pbombs,i) end
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
	
	--Bots
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
	
	--Lightning bolts (draw above bots this wave)
	for i=#bolts,1,-1 do
		if (ourTime > bolts[i].time) then bolts[i].Update() end
		if (bolts[i].dead) then
			bolts[i].bullet.Remove()
			table.remove(bolts,i)
		end
	end
	
	--Draw the HUD for record/rewind/etc
	--Gaster blasters get drawn on top of it, cause, blasters don't care bout no GUI!
	--Make this occasionally be "glitchy" in this wave only
	if (#flow > 0) then
		if (flowHUD ~= nil) then
			flowHUD.sprite.alpha = 1
			flowHUD.SendToTop()
		end
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
		
		if (waveTimeDiff > 15 and math.random() * 100 < waveTimeDiff/35) then
			if (flowHUD ~= nil) then
				flowHUD.sprite.alpha = 0
			end
			local bullet = CreateProjectile("timeflow/glitch" .. math.random(1,6), math.floor(Arena.width/2) - 41, -math.floor(Arena.height/2) + 11)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
		end
	end
	
	for i=#gbs,1,-1 do
		--Override the normal behavior for -42 so that they're aligned in my grid
		if (ourTime > gbs[i].time) then
			if (gbs[i].endX == -42) then
				gbs[i].endX = 320 + math.floor((Player.x + 20)/40)*40
			end
			if (gbs[i].endY == -42) then
				gbs[i].endY = 195 + math.floor((Player.y + 20)/40)*40
			end
			gbs[i].Update()
		end
		if (gbs[i].dead) then
			gbs[i].bullet.Remove()
			table.remove(gbs,i)
		end
	end
	
	if (pianoBullet ~= nil) then pianoBullet.SendToBottom() end
	
	--playerbullet.SendToTop()

end

function OnHit(bullet)
	--"Tile" bullets shouldn't collide with the player. Board tiles, fading lasers, whatever else
	if(bullet.GetVar('tile') ~= 1) then
		if (bullet.GetVar('color') == BLUE) then
			if (Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage') * damageMult)
			end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (not Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage') * damageMult)
			end
		else
			Player.Hurt(bullet.GetVar('damage') * damageMult)
		end
	end
end
