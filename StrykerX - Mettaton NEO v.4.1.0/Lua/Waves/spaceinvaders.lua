--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--Space invaders wave woo
--There's special rules in this so don't copy this Parasol Mettaton code ok!! Unless you want the rules this way!!
--This wave doesn't use the library because it's so weird and unique!
--I think this wave's balanced pretty well so I didn't change it for normal mode

spawntimer = 0
bullets = {}
yOffset = 180
mult = 0.5

--Arena.Resize(155,130)

waveStartTime = Time.time
waveLength = 8.0
ourTime = Time.time
timeMult = 1

playerbullet = CreateProjectile("yh0", Player.x, Player.y)
--"tile = 1" just means the onHit function ignores this bullet
playerbullet.SetVar('tile', 1)

blackbullet = CreateProjectileAbs("invaderfade/black",325,230)
blackbullet.SetVar('tile', 1)
blackbullet.sprite.alpha = 0
blackbullet.SendToBottom()

NONE = 0
LEFT = 1
RIGHT = 2
UP = 3
DOWN = 4

ORANGE = 1
LEMON = 2

STEP = 5

NORMAL = 0
THIN = 1
LARGE = 2

HORIZ = 0
VERT = 1

ORANGE = 0
BLUE = 1

--When a Gaster Blaster's endX or endY equals -42, it'll instead change itself to be at the player's X or Y, once it's ready to appear.
--Easier than making it a new variable!
PX = -42
PY = -42

moving = NONE
beingShocked = false
freeMovement = false
flavor = NONE
startShock = 0
posX = 1
posY = 3

lastFireTime = 0
--Player Bullets
pbs = {}
--Shootable boxes
sboxes = {}
--Unshootable boxes (blown up by plus bombs)
boxes = {}
--Lightning bolts (bullets go through them)
bolts = {}
--Plus bombs
pbombs = {}
--Parasol mettatons
pmetts = {}
--Parasol mettaton heart projectiles
hearts = {}

--Timeflow commands
flow = {}
flowTime = Time.time
flowHUD = nil
flowHUDTime = Time.time

--With this array, I can set the radius of a given circle, and change it, without messing about with the objects connected to the circle
circles = {}

debugs = {}

tileAnims = {}
--Note: For tile animations, the number of frames is one less than it should; that's just referring to the last number in the file names for it (which start at 0. So 2 frames = display filename0,1,2 (3 frames))

oneFrameBullets = {}
--currentFrameBullet = CreateProjectileAbs("white",-50,-50)

gbs = {}
-- { startX, startY, endX, endY, time, rotation, size, laserDelay, laserLength, s1, s2 }
-- s1 and s2 are for playing the sound effects

bots = {}
-- { startX, startY, endX, endY, time, speed, rotation, color }
-- Speed = pixels per second

--Here, I set up exactly what I want to spawn in and when (using the time variable)
--This lua file may as well be used for multiple attacks, just with a variable saying which set to load
--Colored tile puzzles can have their own file, as can yellow shooty sections

local shieldMetts = {}
local allMettsShot = 0

local pianoMode = false
local pianoBullet = nil

waveLength = 90
Arena.Resize(500,16)

local ROWHEIGHT = 45

--Actually 7. but i like starting at 0 for this
COLUMNS = 6

local LENGTH = 80

local leftMost = 0
local rightMost = 6

local bounceCount = 0

local bounceMax = 16

XOFFSET = 100
YOFFSET = 540

Encounter.SetVar("wavetimer", 90)

--Space invaders board of metts
damageMult = 1
if (GetGlobal("justTaunted") == true) then
	damageMult = 4/3
	for i = 0,3,1 do
		local xoffset = 100
		local yoffset = 320-ROWHEIGHT
		for j = 0,6,1 do
			table.insert(pmetts, { row = i, column = j, startX = xoffset + j*60, startY = yoffset + i*ROWHEIGHT, endX = xoffset + (j*60) + LENGTH, endY = -5000, xspeed = 20, yspeed = 0, time = ourTime+i/16+j/120, nextShot = math.random()*8, flingDir = -1 } )
		end
	end
else
	for i = 0,2,1 do
		local xoffset = 100
		local yoffset = 320
		for j = 0,6,1 do
			table.insert(pmetts, { row = i, column = j, startX = xoffset + j*60, startY = yoffset + i*ROWHEIGHT, endX = xoffset + (j*60) + LENGTH, endY = -5000, xspeed = 20, yspeed = 0, time = ourTime+i/16+j/120, nextShot = math.random()*10+1, flingDir = -1 } )
		end
	end
end

--"UFO" laserbots. Not actually shootable like space invader UFOs cause, I mean, whatever
--Orange laserbots aren't interesting because you're always wanting to keep moving pretty much
for i = 4,90,6 do
	if (math.random(0,1) == 0) then
		table.insert(bots, { startX = -50, startY = 430, endX = 5000, endY = -5000, time = Time.time + i, speed = 180, rotation = 0, color = BLUE })
	else
		table.insert(bots, { startX = 690, startY = 430, endX = -5000, endY = -5000, time = Time.time + i, speed = 180, rotation = 0, color = BLUE })

	end
end


--Here I set variables in the arrays that always default to the same thing, to avoid problems with comparing with nil	

for i = #gbs,1,-1 do
	--lastX and lastY track where this box last was, for collision checking the player bullet, and drawing the box blowing up
	--THESE BOXES STOP MOVING ONCE THEY GET SHOT
	if (gbs[i].rs1 == nil) then gbs[i].rs1 = true end
	if (gbs[i].rs2 == nil) then gbs[i].rs2 = true end
end

for i = #sboxes,1,-1 do
	--lastX and lastY track where this box last was, for collision checking the player bullet, and drawing the box blowing up
	--THESE BOXES STOP MOVING ONCE THEY GET SHOT
	sboxes[i].lastX = sboxes[i].startX
	sboxes[i].lastY = sboxes[i].startY
	sboxes[i].shot = false
	sboxes[i].shotTime = 0
end

for i = #boxes,1,-1 do
	--lastX and lastY track where this box last was, for collision checking the player bullet, and drawing the box blowing up
	--These boxes probably don't even need shot or shotTime probably but whatever.
	boxes[i].lastX = boxes[i].startX
	boxes[i].lastY = boxes[i].startY
	boxes[i].shot = false
	boxes[i].shotTime = 0
end

for i = #pbombs,1,-1 do
	--lastX and lastY track where this box last was, for collision checking the player bullet, and drawing the box blowing up
	--These stop moving once they start exploding, but not while blinking!
	pbombs[i].lastX = pbombs[i].startX
	pbombs[i].lastY = pbombs[i].startY
	pbombs[i].shot = false
	pbombs[i].shotTime = 0
	if (pbombs[i].fuse == nil) then pbombs[i].fuse = 6969 end
end

for i = #pmetts,1,-1 do
	--lastX and lastY track where this box last was, for collision checking the player bullet, and drawing the box blowing up
	--These stop moving once they start exploding, but not while blinking!
	pmetts[i].lastX = pmetts[i].startX
	pmetts[i].lastY = pmetts[i].startY
	pmetts[i].shot = false
	pmetts[i].shotTime = 0
	pmetts[i].shotsFired = 0
	pmetts[i].shooting = false
	pmetts[i].shootingTime = ourTime
	pmetts[i].heartFired = false
	--pmetts[i].lastMoved = ourTime - pmetts[i].time
	pmetts[i].lastMoved = 0
	pmetts[i].dir = 1
	pmetts[i].bounces = 0
end

local startingNum = #pmetts
local currentNum = startingNum

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
	
	--timeMult = 1 * 1.25^(bounceCount)
	timeMult = math.min(startingNum / currentNum,20)
	--timeMult = 1 * 1.05^(startingNum - #pmetts)
	
	ourTime = ourTime + (Time.dt * timeMult)
	--DEBUG(timeMult)
	--Audio.Pitch(timeMult)
	--Audio.Pitch(math.max(1/12,timeMult))
	--if (Time.time - waveStartTime > 5) then timeMult = timeMult - 0.01 end

	--Remove bullets to be displayed only one frame
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	
	for i=#debugs,1,-1 do
		debugs[i].Remove()
		table.remove(debugs,i)
	end
	
	local waveTimeDiff = Time.time - waveStartTime
	local ourWaveTimeDiff = ourTime - waveStartTime
	
	--playerbullet.MoveTo(Player.x, Player.y)
	--Blink the heart at 15 fps if hurting
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.Remove()
	playerbullet = CreateProjectile("yh" .. heartframe, Player.x, Player.y)
	playerbullet.SetVar('tile', 1)

	--Check for wave ending
	
	if (allMettsShot == 0) then
		if (#pmetts == 0 or bounceCount >= bounceMax) then
			allMettsShot = Time.time
			waveLength = Time.time - waveStartTime + 1
		end
	end
	
	--The all metts shot timer has been set. wave ends a second from then
	if (allMettsShot ~= 0) then
		if (Time.time - allMettsShot > 1) then EndWave() end
	end
	
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
		--but they also pick up a slight amount of speed over time
		local by = pbs[i].y - 24 + (timeDiff/(1/60))*8 + timeDiff*60
		
		--Collision checking with collidable object tables here (math.abs(x - object x) < half of x sprite width and object sprite width)
		--Is boolet offscreen?
		if (by > 480) then
			table.remove(pbs,i)
		else
			local collided = false
			local bheight = 10 + (curFrame * 2)
			
			--There's a lot of reused code here but whatever.
			for j=#sboxes,1,-1 do
				if (collided) then break end
				if (sboxes[j].shot == false) then
					local xdiff = math.abs(pbs[i].x - sboxes[j].lastX)
					
					if (xdiff < 14 and sboxes[j].lastY - 12 < by+40 and sboxes[j].lastY + 12 > by+40-bheight) then
						--We're colliding
						sboxes[j].shot = true
						sboxes[j].shotTime = Time.time
						collided = true
						Audio.PlaySound("shotbox")
					end
				end
			end
			
			for j=#pbombs,1,-1 do
				if (collided) then break end
				if (pbombs[j].shot == false) then
					local xdiff = math.abs(pbs[i].x - pbombs[j].lastX)
					
					if (xdiff < 14 and pbombs[j].lastY - 15 < by+40 and pbombs[j].lastY + 15 > by+40-bheight) then
						--We're colliding
						pbombs[j].shot = true
						pbombs[j].shotTime = Time.time
						collided = true
						Audio.PlaySound("plusexplode")
					end
				end
			end
			
			for j=#boxes,1,-1 do
				if (collided) then break end
				if (boxes[j].shot == false) then
					local xdiff = math.abs(pbs[i].x - boxes[j].lastX)
					
					if (xdiff < 12 and boxes[j].lastY - 12 < by+40 and boxes[j].lastY + 12 > by+40-bheight) then
						--We're colliding. But these boxes don't disappear if shot. They just absorb the bullet
						collided = true
					end
				end
			end
			
			for j=#pmetts,1,-1 do
				if (collided) then break end
				if (pmetts[j].shot == false) then
					local xdiff = math.abs(pbs[i].x - (pmetts[j].lastX + 3))
					
					if (xdiff < 14 and pmetts[j].lastY - 24 < by+40 and pmetts[j].lastY + 2 > by+40-bheight) then
						--We're colliding
						pmetts[j].shot = true
						pmetts[j].shotTime = Time.time
						collided = true
						Audio.PlaySound("shotbox")
						currentNum = currentNum - 1
						--Extra space invaders stuff. Test what the leftmost/rightmost column is now.
						
						if (pmetts[j].column == 0 or pmetts[j].column == rightMost) then
							local columnClear = true
							for k = #pmetts,1,-1 do
								if (pmetts[k].column == pmetts[j].column and pmetts[k].shot == false) then columnClear = false end
							end
							
							if (columnClear == true and pmetts[j].column == 0) then
								local zeroFound = false
								while zeroFound == false do
									local foundAtLeastOne = false
									for k = #pmetts,1,-1 do
										if (pmetts[k].shot == false) then
											foundAtLeastOne = true
											pmetts[k].column = pmetts[k].column - 1
											if (pmetts[k].column <= 0) then zeroFound = true end
										end
									end
									if (foundAtLeastOne == false) then break end
								end
							end
						end
						
						rightMost = 0
						for k = #pmetts, 1, -1 do
							if (pmetts[k].column > rightMost and pmetts[k].shot == false) then rightMost = pmetts[k].column end
						end
								
					end
				end
			end
			
			--No collision, so the bullet is still to be drawn
			if (collided == false) then
				local bullet = CreateProjectileAbs("bullet/" .. curFrame, pbs[i].x, by)
				bullet.SetVar('tile',1)
				bullet.SendToBottom()
				table.insert(oneFrameBullets, bullet)
			else
				table.remove(pbs,i)
			end
		end
	end

	--Parasol Mettaton heart bullets (they need to be drawn below the mettatons)
	
	--Maybe not have them affected by the time flow changes from the mett rows
	for i=#hearts,1,-1 do
		local timeDiff = Time.time - hearts[i].time
		
		--Heart bullets shouldn't be drawn before they existed
		if (timeDiff > 0) then
			local boxx = hearts[i].startX + (hearts[i].xspeed * timeDiff)
			local boxy = hearts[i].startY + (hearts[i].yspeed * timeDiff)
			local curFrame = math.floor(timeDiff / (1/30))
			while (curFrame > 36) do curFrame = curFrame - 24 end
			
			if (OnScreen(boxx,boxy)) then
				local bullet = CreateProjectileAbs("para/heart" .. curFrame, boxx, boxy)
				bullet.SetVar('tile',1)
				table.insert(oneFrameBullets, bullet)
				--Smaller, invisible hitbox to actually hit the player with
				local bullet = CreateProjectileAbs("para/hearthitbox", boxx, boxy)
				bullet.SetVar('damage',6)
				table.insert(oneFrameBullets, bullet)
			else
				--Delete them if they're off screen in this attack (lag, no rewinding)
				table.remove(hearts,i)
			end
		end		
			
	end
	
	--Lightning bolts
	for i=#bolts,1,-1 do
		local result = GetXY(bolts[i])
		if (OnScreen(result[1], result[2])) then
			local bullet = CreateProjectileAbs("bolt", result[1], result[2])
			bullet.SetVar('damage',6)
			table.insert(oneFrameBullets, bullet)
		else
			table.remove(bolts,i)
		end
		
	end
	
	--Parasol Mettatons
	for i=#pmetts,1,-1 do
		
		local timeDiff = ourTime - pmetts[i].time
		
		--Time to fire a heart? There's a lot of criteria??
		if (timeMult > 0 and pmetts[i].shot == false and pmetts[i].shooting == false and timeDiff > pmetts[i].nextShot) then 
			pmetts[i].shooting = true
			pmetts[i].shootingTime = ourTime
			pmetts[i].heartFired = false
			--Set the time for it to shoot next.
			pmetts[i].nextShot = pmetts[i].nextShot + (math.random()*16) + 4 - (startingNum / currentNum) / 5
		end
		
		--Space invaders row logic thing.
		local result = GetXYInvader(pmetts[i])
		
		if (pmetts[i].shot == true) then
			local curFrame = math.floor((Time.time - pmetts[i].shotTime) / (1/30))
			if (curFrame < 15) then
				local bullet = CreateProjectileAbs("para/fade" .. curFrame, pmetts[i].lastX, pmetts[i].lastY)
				bullet.SetVar('tile',1)
				table.insert(oneFrameBullets, bullet)
			else
				table.remove(pmetts,i)
			end
		else
			--Check for if shooting heart
			pmetts[i].lastX = result[1]
			pmetts[i].lastY = result[2]
			if (pmetts[i].shooting == true) then
				local curFrame = math.floor((ourTime - pmetts[i].shootingTime) / (1/15))
				if (curFrame > 17 or curFrame < 0) then
					--Shooting is complete, or time is going in reverse
					pmetts[i].shooting = false
					local bullet = CreateProjectileAbs("para/para0", result[1], result[2])
					--Mettatons actually do collide with the player in this wave. And since that'd mean they're at the bottom... They should do a substantial chunk?
					bullet.SetVar('damage',13)
					--bullet.SetVar('tile',1)
					table.insert(oneFrameBullets, bullet)
				else
					--Has to be in bounds to shoot a heart.
					--In this wave they can spawn a heart at the player, or a bolt straight downward
					if (pmetts[i].heartFired == false and curFrame >= 12 and result[1] > -30 and result[1] < 670 and result[2] > -30 and result[2] < 510) then
						--Fire a heart!!
						pmetts[i].shotsFired = pmetts[i].shotsFired + 1
						pmetts[i].heartFired = true
						--the -10 and +3 are because boxx and boxy are the center of the entire sprite;
						--parasol mettatons are kinda weird because their center for THIS shouldnt include their parasol
						--In this wave, heart bullets use Time.time, not ourTime
						local heartOrBolt = math.random(0,1)
						if (heartOrBolt == 0) then
							local theAngle = math.atan2(Player.absy-(result[2]-10),Player.absx-(result[1]+3))
							table.insert(hearts, { startX = result[1] + 3, startY = result[2] - 10, xspeed = 150*math.cos(theAngle), yspeed = 150*math.sin(theAngle), time = Time.time })
						else
							table.insert(bolts, { startX = result[1] + 3, startY = result[2] - 10, endX = 0, endY = -50000, xspeed = 0, yspeed = 200, time = Time.time })
						end
						
					end
					local bullet = CreateProjectileAbs("para/para" .. curFrame, result[1], result[2])
					--Mettatons actually do collide with the player in this wave
					bullet.SetVar('damage',13)
					table.insert(oneFrameBullets, bullet)
				end
			else
				if (OnScreen(result[1],result[2])) then
					local bullet = CreateProjectileAbs("para/para0", result[1], result[2])
					--Mettatons actually do collide with the player in this wave
					bullet.SetVar('damage',13)
					table.insert(oneFrameBullets, bullet)
				elseif (allMettsShot == 0) then
					--If any mett is off screen, that means the wave can end
					allMettsShot = Time.time
					waveLength = Time.time - waveStartTime + 1
				end
			end
		end
			
	end
	
	
		--Laser bots!!
	--Note: Should remake these to use an xspeed/yspeed and the GetXY function all the others use.
	--Oh well.
	for i=1,#bots do
		-- Seconds since this bot's spawned
		--Uses Time.time in this wave instead of ourTime
		local timeDiff = Time.time - bots[i].time

	    if (timeDiff > 0) then
			--Always firing laser.
			--The sprite for the bot can be based on global time instead of timeDiff. All bots should be synced
			local botFrame = (math.floor(Time.time / (1/15))) % 5

			local botx = 0
			local boty = 0
			local laserx = 0
			local lasery = 0
			local laserfile = ""
			local botfile = ""
			
			--firing up/down (moving left/right)
			if (bots[i].rotation == 0 or bots[i].rotation == 180) then
				if (bots[i].startX > bots[i].endX) then
					botx = bots[i].startX - (bots[i].speed * timeDiff) % (2*math.abs(bots[i].endX - bots[i].startX))
					botx = bots[i].endX + math.abs(botx - bots[i].endX)
				else
					botx = bots[i].startX + (bots[i].speed * timeDiff) % (2*math.abs(bots[i].endX - bots[i].startX))
					botx = bots[i].endX - math.abs(botx - bots[i].endX)
				end
				boty = bots[i].startY
				laserx = botx
				if (bots[i].rotation == 0) then lasery = boty - 253
				else lasery = boty + 251 end
				if (bots[i].color == BLUE) then 
					laserfile = "bolasers/blaser6v"
					botfile = "bot" .. bots[i].rotation .. "/spr_lasermachine_b_" .. botFrame
				else 
					laserfile = "bolasers/olaser6v"
					botfile = "bot" .. bots[i].rotation .. "/spr_lasermachine_o_" .. botFrame
				end
			--firing left/right (moving up/down)
			elseif (bots[i].rotation == 90 or bots[i].rotation == 270) then
				botx = bots[i].startX
				--boty = bots[i].startY + (bots[i].speed * timeDiff)
				if (bots[i].startY > bots[i].endY) then
					boty = bots[i].startY - (bots[i].speed * timeDiff) % (2*math.abs(bots[i].endY - bots[i].startY))
					boty = bots[i].endY + math.abs(boty - bots[i].endY)
				else
					boty = bots[i].startY + (bots[i].speed * timeDiff) % (2*math.abs(bots[i].endY - bots[i].startY))
					boty = bots[i].endY - math.abs(boty - bots[i].endY)
				end
				if (bots[i].rotation == 90) then laserx = botx - 333
				else laserx = botx + 331 end
				lasery = boty
				if (bots[i].color == BLUE) then 
					laserfile = "bolasers/blaser6h"
					botfile = "bot" .. bots[i].rotation .. "/spr_lasermachine_b_" .. botFrame
				else 
					laserfile = "bolasers/olaser6h"
					botfile = "bot" .. bots[i].rotation .. "/spr_lasermachine_o_" .. botFrame
				end
			end

			local bullet = CreateProjectileAbs(botfile, botx, boty)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
			
			local laserbullet = CreateProjectileAbs(laserfile, laserx, lasery)
			if (bots[i].color == BLUE) then laserbullet.SetVar('color',BLUE)
			else laserbullet.SetVar('color',ORANGE) end
			laserbullet.SetVar('damage',6)
			table.insert(oneFrameBullets, laserbullet)
			
		else
			--The laser is currently off.
			local bullet = CreateProjectileAbs("bot" .. bots[i].rotation .. "/spr_lasermachine_off_0", bots[i].startX, bots[i].startY)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
	   end
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
				flowHUD = CreateProjectile(sprite, Arena.width/2 - 41, -Arena.height/2 + 11)
				flowHUD.SetVar('tile',1)
			else
				flowHUD.Remove()
				flowHUD = nil
			end
		end
		
	end

	--Debug bullets
	for i=1,#debugs do
		debugs[i].SendToTop()
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

--Simple function to avoid drawing off-screen bullets. I'm a bit lenient to accomodate for large sprites
function OnScreen(x,y)
	if (x > 670 or x < -30 or y > 510 or y < -30) then return false
	else return true
	end
end


--Twospeed movement = the bullet moves at a certain speed for a certain amount of time, then changes to a second speed. Default: false
--Bounce = should it stop at its end X/Y or bounce backwards. Default: true
function GetXY(bullet)
	--In this wave this function uses Time.time instead of ourTime so only the invaders speed up over time
	local timeDiff = Time.time - bullet.time
	local x = 0
	local y = 0
	
	if (timeDiff > 0) then
		local xmult = 1
		if (bullet.startX > bullet.endX) then xmult = -1 end
		local ymult = 1
		if (bullet.startY > bullet.endY) then ymult = -1 end
		
		if (bullet.xspeed == 0 or bullet.startX == bullet.endX) then
			x = bullet.startX
		elseif (bullet.xspeed2 == nil) then
			if (bullet.bounce ~= false) then
				x = bullet.startX + ((bullet.xspeed * timeDiff) % (2*math.abs(bullet.endX - bullet.startX))) * xmult
				x = bullet.endX - (math.abs(x - bullet.endX)*xmult)
			else
				x = bullet.startX + math.min(bullet.xspeed * timeDiff,math.abs(bullet.endX - bullet.startX)) * xmult
			end
		else
			local speedDiff = timeDiff - bullet.speedTime
			if (bullet.bounce ~= false) then
				x = bullet.startX + ((bullet.xspeed * math.min(timeDiff,bullet.speedTime) + bullet.xspeed2 * math.max(0, speedDiff)) % (2*math.abs(bullet.endX - bullet.startX))) * xmult
				x = bullet.endX - (math.abs(x - bullet.endX)*xmult)
			else
				x = bullet.startX + math.min(bullet.xspeed * math.min(timeDiff,bullet.speedTime) + bullet.xspeed2 * math.max(0, speedDiff), math.abs(bullet.endX - bullet.startX)) * xmult
			end
		end
		
		if (bullet.yspeed == 0 or bullet.startY == bullet.endY) then
			y = bullet.startY
		elseif (bullet.xspeed2 == nil) then
			if (bullet.bounce ~= false) then
				y = bullet.startY + ((bullet.yspeed * timeDiff) % (2*math.abs(bullet.endY - bullet.startY))) * ymult
				y = bullet.endY - (math.abs(y - bullet.endY)*ymult)
			else
				y = bullet.startY + math.min(bullet.yspeed * timeDiff,math.abs(bullet.endY - bullet.startY)) * ymult
			end
		else
			local speedDiff = timeDiff - bullet.speedTime
			if (bullet.bounce ~= false) then
				y = bullet.startY + ((bullet.yspeed * math.min(timeDiff,bullet.speedTime) + bullet.yspeed2 * math.max(0, speedDiff)) % (2*math.abs(bullet.endY - bullet.startY))) * ymult
				y = bullet.endY - (math.abs(y - bullet.endY)*ymult)
			else
				y = bullet.startY + math.min(bullet.yspeed * math.min(timeDiff,bullet.speedTime) + bullet.yspeed2 * math.max(0, speedDiff), math.abs(bullet.endY - bullet.startY)) * ymult
			end
		end
		
	else
		x = bullet.startX
		y = bullet.startY
	end
	
	if (bullet.circleID ~= nil) then
		--This box is in a circle. Calculate its x and y based on circle radius and rotation speed and etc
		--At the moment, boxx and boxy represent the center point of the circle.
		local radius = circles[bullet.circleID].radius
		local boxr = 0
		if (timeDiff > 0) then
			boxr = bullet.rotation + (bullet.rspeed * timeDiff) + circles[bullet.circleID].offset
		else boxr = bullet.rotation end
		x = x + (radius * math.cos(math.rad(boxr)))
		y = y + (radius * math.sin(math.rad(boxr)))
	end
	
	return { x, y }
	
end


function GetXYInvader(bullet)
	--Note: I bet if you timed a column destruction just right, the invaders could get a bit out of sync
	--Whatever though, it'd still work fine, just be a bit harder/bad looking

	local timeDiff = ourTime - bullet.time
	--Make timeDiff be split up into 4 chunks?
	local roundTimeDiff = math.floor(timeDiff * 4) / 4
	
	if (roundTimeDiff > bullet.lastMoved) then
		
		local leftBound = XOFFSET + (bullet.column*60)
		local rightBound = leftBound + 80 + (6 - rightMost)*60
		
		local x = bullet.lastX
		local y = bullet.startY
		
		x = x + 5 * bullet.dir
		
		if (x < leftBound) then
			x = leftBound
			bullet.dir = bullet.dir * -1
			bullet.bounces = bullet.bounces + 1
		elseif (x > rightBound) then
			x = rightBound
			bullet.dir = bullet.dir * -1
			bullet.bounces = bullet.bounces + 1
		end
		if (bullet.bounces > bounceCount) then bounceCount = bullet.bounces end
		
		y = y - bullet.bounces * (ROWHEIGHT/2)
		bullet.lastMoved = timeDiff
		return { x, y }
	else
		return { bullet.lastX, bullet.lastY }
	end
end