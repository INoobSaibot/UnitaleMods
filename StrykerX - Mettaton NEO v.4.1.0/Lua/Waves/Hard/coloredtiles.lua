--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--I decided against using the libraries for colored tiles waves. There's special Gaster Blaster rules after all.
--I also kept all the puzzles together.

--And hey. If you're gonna steal this... make your own damn puzzle for christs' sake.

spawntimer = 0
bullets = {}
yOffset = 180
mult = 0.5

waveStartTime = Time.time
ourTime = Time.time
timeMult = 1

playerbullet = CreateProjectile("hearts/heart0_0", Player.x, Player.y)
--"tile = 1" just means the onHit function ignores this bullet
playerbullet.SetVar('tile', 1)

XOFFSET = 166
YOFFSET = 300

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

--Whoops, I made orange for laserbots = 0 in the other scripts. Which overwrites orange = 1 for flavor
--So I guess they're swapped in this! Durrhurrrr
BLUE = 0
ORANGE = 1


moving = NONE
moveTime = Time.time
beingShocked = false
finished = false
flavor = NONE
startShock = 0

tileAnims = {}
--Note: For tile animations, the number of frames is one less than it should; that's just referring to the last number in the file names for it (which start at 0. So 2 frames = display filename0,1,2 (3 frames))
--I've got soap as its own array since I want it to display over other tile effects (and it has the same frame for most of it)
soapAnims = {}

oneFrameBullets = {}
--currentFrameBullet = CreateProjectileAbs("white",-50,-50)

gbs = {}
-- { startX, startY, endX, endY, time, rotation, size, laserDelay, laserLength, s1, s2 }
-- s1 and s2 are for playing the sound effects
gasterTimer = Time.time
warningTimer = -1
GBDELAY = 4


bots = {}
-- { startX, startY, endX, endY, time, speed, rotation, color }
-- Speed = pixels per second

-- Create random tile puzzle? Make sure it's completable using pathfinding algorithm??

--Hey, so, I totally have "width" and "height" and "x" and "y" all like, kinda mixed up all throughout this...
--But it works
GRIDWIDTH = 1
GRIDHEIGHT = 1
puzzle = {}
available = {}
timeLimit = 15
finishTime = -1
ripped = false
posX = 1
posY = 3


if (GetGlobal("attackNum") == 5) then
	XOFFSET = 140
	YOFFSET = 300
	GRIDWIDTH = 5
	GRIDHEIGHT = 10
	posX = 1
	poxY = 3

	for i=1, GRIDWIDTH do
		puzzle[i] = {}
	end

	--Have to keep track of which rows/columns already have a blaster
	--Columns first, then rows
	available = {}
	for i=1, GRIDWIDTH+GRIDHEIGHT do
		available[i] = i
	end

	Arena.ResizeImmediate(450,250)

	puzzle[1][1] = "blue"
	puzzle[2][1] = "green"
	puzzle[3][1] = "pink"
	puzzle[4][1] = "orange"
	puzzle[5][1] = "red"

	puzzle[1][2] = "red"
	puzzle[2][2] = "red"
	puzzle[3][2] = "blue"
	puzzle[4][2] = "green"
	puzzle[5][2] = "yellow"

	puzzle[1][3] = "orange"
	puzzle[2][3] = "green"
	puzzle[3][3] = "purple"
	puzzle[4][3] = "pink"
	puzzle[5][3] = "blue"

	puzzle[1][4] = "yellow"
	puzzle[2][4] = "blue"
	puzzle[3][4] = "yellow"
	puzzle[4][4] = "pink"
	puzzle[5][4] = "red"
	
	puzzle[1][5] = "red"
	puzzle[2][5] = "blue"
	puzzle[3][5] = "purple"
	puzzle[4][5] = "blue"
	puzzle[5][5] = "orange"
	
	puzzle[1][6] = "blue"
	puzzle[2][6] = "pink"
	puzzle[3][6] = "orange"
	puzzle[4][6] = "orange"
	puzzle[5][6] = "pink"
	
	puzzle[1][7] = "purple"
	puzzle[2][7] = "red"
	puzzle[3][7] = "red"
	puzzle[4][7] = "blue"
	puzzle[5][7] = "green"
	
	puzzle[1][8] = "purple"
	puzzle[2][8] = "orange"
	puzzle[3][8] = "blue"
	puzzle[4][8] = "pink"
	puzzle[5][8] = "orange"
	
	puzzle[1][9] = "green"
	puzzle[2][9] = "pink"
	puzzle[3][9] = "purple"
	puzzle[4][9] = "green"
	puzzle[5][9] = "yellow"
	
	puzzle[1][10] = "finish"
	puzzle[2][10] = "finish"
	puzzle[3][10] = "finish"
	puzzle[4][10] = "red"
	puzzle[5][10] = "red"


	for i=1,#puzzle do
		for j=1,#puzzle[i] do
			-- local bullet = CreateProjectile(puzzle[i][j], -Arena.width/2 + 5 + j*40, 180 - i*40)
			local bullet = CreateProjectileAbs(puzzle[i][j], XOFFSET + (j-1)*40, YOFFSET - (i-1)*40)
			bullet.SetVar('color',puzzle[i][j])
			bullet.SetVar('tile', 1)
			bullet.SendToBottom()
		end
	end

	timeLimit = 15

elseif (GetGlobal("attackNum") == 6) then
	XOFFSET = 140
	YOFFSET = 300
	GRIDWIDTH = 5
	GRIDHEIGHT = 10
	posX = 1
	poxY = 3

	for i=1, GRIDWIDTH do
		puzzle[i] = {}
	end

	--Have to keep track of which rows/columns already have a blaster
	--Columns first, then rows
	available = {}
	for i=1, GRIDWIDTH+GRIDHEIGHT do
		available[i] = i
	end

	Arena.ResizeImmediate(450,250)

	puzzle[1][1] = "green"
	puzzle[2][1] = "orange"
	puzzle[3][1] = "pink"
	puzzle[4][1] = "red"
	puzzle[5][1] = "yellow"

	puzzle[1][2] = "pink"
	puzzle[2][2] = "purple"
	puzzle[3][2] = "blue"
	puzzle[4][2] = "purple"
	puzzle[5][2] = "pink"

	puzzle[1][3] = "blue"
	puzzle[2][3] = "red"
	puzzle[3][3] = "orange"
	puzzle[4][3] = "pink"
	puzzle[5][3] = "green"

	puzzle[1][4] = "orange"
	puzzle[2][4] = "red"
	puzzle[3][4] = "blue"
	puzzle[4][4] = "yellow"
	puzzle[5][4] = "red"
	
	puzzle[1][5] = "pink"
	puzzle[2][5] = "blue"
	puzzle[3][5] = "green"
	puzzle[4][5] = "pink"
	puzzle[5][5] = "green"
	
	puzzle[1][6] = "purple"
	puzzle[2][6] = "blue"
	puzzle[3][6] = "yellow"
	puzzle[4][6] = "orange"
	puzzle[5][6] = "blue"
	
	puzzle[1][7] = "pink"
	puzzle[2][7] = "yellow"
	puzzle[3][7] = "pink"
	puzzle[4][7] = "purple"
	puzzle[5][7] = "yellow"
	
	puzzle[1][8] = "green"
	puzzle[2][8] = "red"
	puzzle[3][8] = "orange"
	puzzle[4][8] = "purple"
	puzzle[5][8] = "green"
	
	puzzle[1][9] = "red"
	puzzle[2][9] = "red"
	puzzle[3][9] = "yellow"
	puzzle[4][9] = "purple"
	puzzle[5][9] = "red"
	
	puzzle[1][10] = "finish"
	puzzle[2][10] = "finish"
	puzzle[3][10] = "finish"
	puzzle[4][10] = "finish"
	puzzle[5][10] = "finish"


	for i=1,#puzzle do
		for j=1,#puzzle[i] do
			-- local bullet = CreateProjectile(puzzle[i][j], -Arena.width/2 + 5 + j*40, 180 - i*40)
			local bullet = CreateProjectileAbs(puzzle[i][j], XOFFSET + (j-1)*40, YOFFSET - (i-1)*40)
			bullet.SetVar('color',puzzle[i][j])
			bullet.SetVar('tile', 1)
			bullet.SendToBottom()
		end
	end

	--These laserbots only get created if the previous puzzle was completed
	if (GetGlobal("finishedpuzzle") == true) then
		GBDELAY = 3
		table.insert(bots, { startX = XOFFSET + 40, startY = YOFFSET - (6-1)*40, endX = 171, endY = 50, time = ourTime, speed = 0, rotation = 180, color = ORANGE })
		table.insert(bots, { startX = XOFFSET + 3*40, startY = YOFFSET - (6-1)*40, endX = XOFFSET + 8*40, endY = 50, time = ourTime, speed = 150, rotation = 180, color = BLUE })
	end
	timeLimit = 15

elseif (GetGlobal("attackNum") == 10) then
	XOFFSET = 140
	YOFFSET = 300
	GRIDWIDTH = 5
	GRIDHEIGHT = 10
	posX = 1
	poxY = 3

	for i=1, GRIDWIDTH do
		puzzle[i] = {}
	end

	--Have to keep track of which rows/columns already have a blaster
	--Columns first, then rows
	available = {}
	for i=1, GRIDWIDTH+GRIDHEIGHT do
		available[i] = i
	end

	Arena.ResizeImmediate(450,250)

	puzzle[1][1] = "blue"
	puzzle[2][1] = "pink"
	puzzle[3][1] = "blue"
	puzzle[4][1] = "pink"
	puzzle[5][1] = "blue"

	puzzle[1][2] = "purple"
	puzzle[2][2] = "blue"
	puzzle[3][2] = "orange"
	puzzle[4][2] = "blue"
	puzzle[5][2] = "yellow"

	puzzle[1][3] = "blue"
	puzzle[2][3] = "green"
	puzzle[3][3] = "blue"
	puzzle[4][3] = "purple"
	puzzle[5][3] = "blue"

	puzzle[1][4] = "yellow"
	puzzle[2][4] = "blue"
	puzzle[3][4] = "pink"
	puzzle[4][4] = "blue"
	puzzle[5][4] = "orange"
	
	puzzle[1][5] = "blue"
	puzzle[2][5] = "green"
	puzzle[3][5] = "blue"
	puzzle[4][5] = "orange"
	puzzle[5][5] = "blue"
	
	puzzle[1][6] = "orange"
	puzzle[2][6] = "blue"
	puzzle[3][6] = "red"
	puzzle[4][6] = "blue"
	puzzle[5][6] = "yellow"
	
	puzzle[1][7] = "blue"
	puzzle[2][7] = "pink"
	puzzle[3][7] = "blue"
	puzzle[4][7] = "orange"
	puzzle[5][7] = "blue"
	
	puzzle[1][8] = "red"
	puzzle[2][8] = "blue"
	puzzle[3][8] = "green"
	puzzle[4][8] = "blue"
	puzzle[5][8] = "green"
	
	puzzle[1][9] = "blue"
	puzzle[2][9] = "yellow"
	puzzle[3][9] = "blue"
	puzzle[4][9] = "purple"
	puzzle[5][9] = "blue"
	
	puzzle[1][10] = "finish"
	puzzle[2][10] = "finish"
	puzzle[3][10] = "finish"
	puzzle[4][10] = "finish"
	puzzle[5][10] = "finish"


	for i=1,#puzzle do
		for j=1,#puzzle[i] do
			-- local bullet = CreateProjectile(puzzle[i][j], -Arena.width/2 + 5 + j*40, 180 - i*40)
			local bullet = CreateProjectileAbs(puzzle[i][j], XOFFSET + (j-1)*40, YOFFSET - (i-1)*40)
			bullet.SetVar('color',puzzle[i][j])
			bullet.SetVar('tile', 1)
			bullet.SendToBottom()
		end
	end

	--These laserbots only get created if a previous puzzle was completed
	if (GetGlobal("finishedpuzzle") == true) then
		GBDELAY = 2.5
		--table.insert(bots, { startX = XOFFSET + (11-1)*40, startY = YOFFSET - (2-1)*40, endX = 171, endY = 50, time = ourTime, speed = 0, rotation = 90, color = ORANGE })
		--table.insert(bots, { startX = XOFFSET + (11-1)*40, startY = YOFFSET - (4-1)*40, endX = XOFFSET + 8*40, endY = 50, time = ourTime, speed = 0, rotation = 90, color = ORANGE })
	end
	timeLimit = 15
	
	
end

lastposX = posX
lastposY = posY

Player.SetControlOverride(true)
Player.MoveToAbs(XOFFSET+(posX-1)*40,YOFFSET-(posY-1)*40,true)

--Flavor hud
flavorHUD = CreateProjectileAbs("hud",520,439)
flavorHUD.SetVar('tile',1)

function Update()

	ourTime = ourTime + (Time.dt * timeMult)
	--DEBUG(timeMult)
	--Audio.Pitch(math.max(1/12,timeMult))
	--if (Time.time - waveStartTime > 5) then timeMult = timeMult - 0.01 end
	
	--Remove bullets to be displayed only one frame
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	
	if (#gbs > 0 and Time.time > warningTimer) then
		Audio.PlaySound("gasterintro")
		warningTimer = warningTimer + GBDELAY
	end
	
	--We are between two tiles and moving. (Player doesn't have control)
	--If we've reached the other tile, we need to do whatever it is that space do.
	--Big fat if statement.
	if (moving ~= NONE) then
		local timeDiff = Time.time - moveTime
		
		local targetX = XOFFSET+(posX-1)*40
		local targetY = YOFFSET-(posY-1)*40
		
		--Length of step; number of frames I want it to take to move. Made a constant so I can tweak it easy
		local LOS = 6/30
		
		if (beingShocked == true) then
			if (Time.time-startShock > (10/30)) then
				beingShocked = false
				moveTime = Time.time
			end
		elseif (timeDiff < LOS) then
			--Moving is in the middle of occurring
			local lastX = XOFFSET+(lastposX-1)*40
			local lastY = YOFFSET-(lastposY-1)*40
			
			local xmult = 1
			if (lastX > targetX) then xmult = -1 end
			local ymult = 1
			if (lastY > targetY) then ymult = -1 end
			
			--I want to move some percentage of 40 pixels (size of a tile) based on timediff
			--Then I multiply the result by xmult/ymult so that I move in the correct direction
			local curX, curY
			--There's no diagonal movement, so we're either moving up/down or left/right
			if (lastX ~= targetX) then
				curX = lastX + (40 * (timeDiff / LOS)) * xmult
				curY = lastY
			else
				curY = lastY + (40 * (timeDiff / LOS)) * ymult
				curX = lastX
			end
			
			Player.MoveToAbs(curX, curY, true)
			
		else
			--Moving is done! Check what color has been landed on and do the things.
			local moveBackwards = false
			local moveForwards = false
			Player.MoveToAbs(targetX,targetY,true)
			lastposX = posX
			lastposY = posY
			
			if (puzzle[posY][posX] == "yellow") then
				--Electric tile. Cannot step, but first you're kept in place a brief time.
				Audio.PlaySound("shock")
				moveBackwards = true
				--The player takes the hp damage, even if they're invulnerable
				Player.hp = Player.hp - 2
				table.insert(tileAnims, { type = "spr_tileyellow_shock_", frames = 13, x = posX, y = posY, time = Time.time })
				beingShocked = true
				startShock = Time.time
			elseif (puzzle[posY][posX] == "blue" and NextToYellow(posX,posY)) then
				--Water next to electric
				Audio.PlaySound("shock")
				moveBackwards = true
				Player.hp = Player.hp - 2
				table.insert(tileAnims, { type = "spr_tileyellow_shock_blue_", frames = 17, x = posX, y = posY, time = Time.time })
				beingShocked = true
				startShock = Time.time
			elseif (puzzle[posY][posX] == "blue" and flavor == ORANGE) then
				--If you smell like oranges, the piranhas will bite you
				Audio.PlaySound("encounter")
				moveBackwards = true
				Player.hp = Player.hp - 2
				table.insert(tileAnims, { type = "spr_pirahna_anim_wip_", frames = 12, x = posX, y = posY, time = Time.time })
			elseif (puzzle[posY][posX] == "orange") then
				if (flavor ~= ORANGE) then
					--Change the flavor indicator here as well?
					table.insert(tileAnims, { type = "white", frames = 4, x = posX, y = posY, time = Time.time })
					Audio.PlaySound("ding")
					flavor = ORANGE
				end
			elseif (puzzle[posY][posX] == "purple") then
				if (flavor ~= LEMON) then
					table.insert(tileAnims, { type = "white", frames = 4, x = posX, y = posY, time = Time.time })
					Audio.PlaySound("ding")
					flavor = LEMON
				end
				moveForwards = true
				table.insert(soapAnims, { rot = moving, x = posX, y = posY, time = Time.time })
			elseif (puzzle[posY][posX] == "green") then
				if (#available > 0) then
					Audio.PlaySound("yeah")
					table.insert(tileAnims, { type = "white", frames = 4, x = posX, y = posY, time = Time.time })
					
					local gbx = 0
					local gby = 0
					local gbr = 0
					
					local s = math.random(1, #available)
					--while (gbslots[selection] == true) do selection = math.random(1, GRIDWIDTH+GRIDHEIGHT)
					--The gby/gbx should be based on xoffset/yoffset
					if (available[s] <= GRIDHEIGHT) then
						--GB is along the top
						local col = available[s]
						gbx = XOFFSET + (col-1)*40
						gby = YOFFSET + 110
					else
						--GB is on the sides
						local row = available[s]-GRIDHEIGHT
						gbr = 270
						gbx = XOFFSET - 110
						gby = YOFFSET - (row-1)*40
					end
					table.remove(available,s)
					
					--The first gaster you spawn is what initiates the sync
					if (#gbs == 0) then
						gasterTimer = Time.time + 0.8
						warningTimer = Time.time + GBDELAY
						table.insert(gbs, { startX = -30, startY = 510, endX = gbx, endY = gby, time = ourTime, rotation = gbr, size = THIN, laserDelay = 0.8, laserLength = 0.5, s1 = false, s2 = false })
					else
						--This is to sync all the gasters up. It's dumb probably. But it works
						local delay = gasterTimer
						while (delay < Time.time) do delay = delay + GBDELAY end
						if (delay - Time.time < 0.35) then delay = delay + GBDELAY end
						table.insert(gbs, { startX = -30, startY = 510, endX = gbx, endY = gby, time = ourTime, rotation = gbr, size = THIN, laserDelay = delay - Time.time, laserLength = 0.5, s1 = true, s2 = true })
					end
				end
				
				--table.insert(gbs, { startX = 640, startY = 0, endX = 580, endY = 120, time = ourTime, rotation = 90, size = LARGE, laserDelay = 0.82, laserLength = 0.5, s1 = true, s2 = true })
				--table.insert(gbs, { startX = 640, startY = 0, endX = 500, endY = 50, time = ourTime, rotation = 180, size = LARGE, laserDelay = 0.84, laserLength = 0.5, s1 = true, s2 = true })
				--table.insert(gbs, { startX = 0, startY = 480, endX = 150, endY = 420, time = ourTime, rotation = 0, size = LARGE, laserDelay = 0.86, laserLength = 0.5, s1 = true, s2 = true })
			elseif (puzzle[posY][posX] == "finish") then
				Audio.PlaySound("congratulations")
				--Player.SetControlOverride(false)
				finished = true
				finishTime = Time.time
			end
			
			if (moveBackwards) then
				if (moving == LEFT) then 
					moving = RIGHT
					moveTime = Time.time
					posX = posX+1
				elseif (moving == RIGHT) then 
					moving = LEFT
					moveTime = Time.time
					posX = posX-1
				elseif (moving == UP) then 
					moving = DOWN
					moveTime = Time.time
					posY = posY + 1
				elseif (moving == DOWN) then 
					moving = UP
					moveTime = Time.time
					posY = posY - 1
				else end
			--For moving forwards (soap) we should check for red tiles / OOB
			--Put the arrow anim starting in these ifs as well?
			elseif (moveForwards) then
				if (moving == LEFT) then
					if (TestMove(posX-1,posY)) then
						moveTime = Time.time
						posX = posX-1
					else moving = NONE end
				elseif (moving == RIGHT) then 
					if (TestMove(posX+1,posY)) then
						moveTime = Time.time
						posX = posX+1
					else moving = NONE end
				elseif (moving == UP) then 
					if (TestMove(posX,posY-1)) then
						moveTime = Time.time
						posY = posY-1
					else moving = NONE end
				elseif (moving == DOWN) then 
					if (TestMove(posX,posY+1)) then
						moveTime = Time.time
						posY = posY+1
					else moving = NONE end
				else end
			else moving = NONE
			end
			
			
		end
	end
	
	if (moving == NONE and finished == false) then
		if (Input.Right > 0 and TestMove(posX+1,posY)) then 
			moving = RIGHT
			moveTime = Time.time
			posX = posX+1
		elseif (Input.Left > 0 and TestMove(posX-1,posY)) then 
			moving = LEFT
			moveTime = Time.time
			posX = posX-1
		elseif (Input.Up > 0 and TestMove(posX,posY-1)) then 
			moving = UP
			moveTime = Time.time
			posY = posY-1
		elseif (Input.Down > 0 and TestMove(posX,posY+1)) then 
			moving = DOWN
			moveTime = Time.time
			posY = posY+1
		end
	end

	--DEBUG(moving)

	for i=#tileAnims,1,-1 do
		-- I want the animations to play at 30 FPS.
		local curFrame = math.floor((Time.time - tileAnims[i].time) / (1/30))
		if (curFrame <= tileAnims[i].frames) then
			local bullet = CreateProjectileAbs(tileAnims[i].type .. curFrame, XOFFSET + (tileAnims[i].x-1)*40, YOFFSET - (tileAnims[i].y-1)*40)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
		else
			table.remove(tileAnims,i)
		end
	end
	
	for i=#soapAnims,1,-1 do
		-- I want the animations to play at 30 FPS.
		local curFrame = math.floor((Time.time - soapAnims[i].time) / (1/30))
		curFrame = math.max(0,curFrame - 4)
		if (curFrame <= 3) then
			local bullet = CreateProjectileAbs("arrow" .. soapAnims[i].rot .. "_" .. curFrame, XOFFSET + (soapAnims[i].x-1)*40, YOFFSET - (soapAnims[i].y-1)*40)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
		else
			table.remove(soapAnims,i)
		end
	end
	
	--Blink the heart at 15 fps if hurting
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.Remove()
	playerbullet = CreateProjectile("hearts/heart" .. flavor .. "_" .. heartframe, Player.x, Player.y)
	playerbullet.SetVar('tile', 1)
	
	--Oh boy, Gaster Blaster logic! What a mess.
	for i=#gbs,1,-1 do
		-- Seconds since this blaster's spawned
		local timeDiff = ourTime - gbs[i].time
		--Rotating/moving into place takes a third of a second.
		local shootDiff = ourTime - gasterTimer
		
		local phase1length = 0.33333
	    if (timeDiff > 0) then
			if (timeDiff < phase1length) then
				if (gbs[i].s1 == false) then
					Audio.PlaySound("gasterintro")
					gbs[i].s1 = true
				end
				--This is a way to make it so the blasters move a lot at first, then sharply slow down.
				local diffsqrt = (timeDiff)^(0.3)
				local conssqrt = (phase1length)^(0.3)
				local diffX = gbs[i].endX - gbs[i].startX
				local diffY = gbs[i].endY - gbs[i].startY
				local rot = 0

				if (gbs[i].rotation < 180) then
					rot = (gbs[i].rotation * diffsqrt/conssqrt)
				else
					rot = 360 - ((360 - gbs[i].rotation) * diffsqrt/conssqrt)
				end
				
				local bullet = CreateProjectileAbs("gaster" .. gbs[i].size .. "/gb0",
						gbs[i].startX + (diffX * (diffsqrt/conssqrt)),
						gbs[i].startY + (diffY * (diffsqrt/conssqrt)))
				bullet.sprite.rotation = -rot
				bullet.SetVar('tile',1)
				table.insert(oneFrameBullets, bullet)

			elseif (timeDiff < gbs[i].laserDelay) then
				local bullet = CreateProjectileAbs("gaster" .. gbs[i].size .. "/gb0", gbs[i].endX, gbs[i].endY)
				bullet.sprite.rotation = -gbs[i].rotation
				bullet.SetVar('tile',1)
				table.insert(oneFrameBullets, bullet)

			else
				--Currently firing laser.
				--In colored tile mode, the blasters don't get moved backwards when shooting
				--They also all should fire in sync, and repeatedly.
				
				if (gbs[i].s2 == false) then
					Audio.PlaySound("gasterfire")
					gbs[i].s2 = true
				end
				local laserDiff = timeDiff - gbs[i].laserDelay
				local curFrame = math.floor(laserDiff / (1/30))
				local diffpow = (laserDiff^4 * 1000)

				local gbx = gbs[i].endX
				local gby = gbs[i].endY
				local laserx = 0
				local lasery = 0
				local laserfile = ""

				--0 = firing down
				if (gbs[i].rotation == 0) then
					laserx = gbx
					lasery = gby - 690
					if (gbs[i].size == LARGE) then lasery = lasery - 60 end
					laserfile = "laser" .. gbs[i].size .. "/laserv"
				--90 = firing left
				elseif (gbs[i].rotation == 90) then
					laserx = gbx - 690
					if (gbs[i].size == LARGE) then laserx = laserx - 60 end
					lasery = gby
					laserfile = "laser" .. gbs[i].size .. "/laserh"
				--180 = firing up
				elseif (gbs[i].rotation == 180) then
					laserx = gbx
					lasery = gby + 690
					if (gbs[i].size == LARGE) then lasery = lasery + 60 end
					laserfile = "laser" .. gbs[i].size .. "/laserv"
				--270 = firing right
				else
					laserx = gbx + 690
					if (gbs[i].size == LARGE) then laserx = laserx + 60 end
					lasery = gby
					laserfile = "laser" .. gbs[i].size .. "/laserh"
				end

				local gbFrame = curFrame
				while (gbFrame > 5) do gbFrame = gbFrame - 2 end
				
				--This code is absolutely horrible compared to the other versions.
				--But basically, I want the blaster mouth to close as the laser fades, since it'll still be on screen.
				if (curFrame >= 4) then
					--Creating the laser!
					if (timeDiff < (gbs[i].laserDelay + gbs[1].laserLength)) then
						local bullet = CreateProjectileAbs("gbfire/gb_" .. gbs[i].size .. "_0_" .. gbFrame, gbx, gby)
						bullet.sprite.rotation = -gbs[i].rotation
						bullet.SetVar('tile',1)
						table.insert(oneFrameBullets, bullet)
						local laserFrame = curFrame - 4
						while (laserFrame > 10) do laserFrame = laserFrame - 8 end
						bullet = CreateProjectileAbs(laserfile .. laserFrame, laserx, lasery)
						bullet.SetVar('damage',13)
						table.insert(oneFrameBullets, bullet)
					--Laser should be fading out!
					else
						local laserDiff2 = laserDiff - gbs[i].laserLength
						local laserFrame = math.floor(laserDiff2 / (1/30))
						if (laserFrame <= 9) then
							gbFrame = math.min(gbFrame, 4 - (laserFrame - 5))
							local bullet = CreateProjectileAbs("gbfire/gb_" .. gbs[i].size .. "_0_" .. gbFrame, gbx, gby)
							bullet.sprite.rotation = -gbs[i].rotation
							bullet.SetVar('tile',1)
							table.insert(oneFrameBullets, bullet)
						
							bullet = CreateProjectileAbs(laserfile .. "fade" .. laserFrame, laserx, lasery)
							bullet.SetVar('tile',1)
							table.insert(oneFrameBullets, bullet)
						else
							--Laser is done firing.
							local bullet = CreateProjectileAbs("gaster" .. gbs[i].size .. "/gb0", gbs[i].endX, gbs[i].endY)
							bullet.sprite.rotation = -gbs[i].rotation
							bullet.SetVar('tile',1)
							table.insert(oneFrameBullets, bullet)
							gbs[i].laserDelay = gbs[i].laserDelay + GBDELAY
							if (i == 1) then gbs[i].s2 = false end
						end
					end
				else
					local bullet = CreateProjectileAbs("gbfire/gb_" .. gbs[i].size .. "_0_" .. gbFrame, gbx, gby)
					bullet.sprite.rotation = -gbs[i].rotation
					bullet.SetVar('tile',1)
					table.insert(oneFrameBullets, bullet)
				end
			end
		end
	end

	--Laser bots!! Simpler?? I hope.
	--Need to work on them moving back and forth between their start and end location
	for i=#bots,1,-1 do
		-- Seconds since this bot's spawned
		local timeDiff = ourTime - bots[i].time

	    if (timeDiff > 0) then
			--Always firing laser.
			--The sprite for the bot can be based on global time. All bots should be synced
			local botFrame = (math.floor(ourTime / (1/15))) % 5

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
			laserbullet.SetVar('damage',8)
			table.insert(oneFrameBullets, laserbullet)
			

	   end
	end
	
	--We should make the fire walls here. They move in a bit slowly to give the player one last chance to win??
	--Also end the wave after timer runs out
	--If you've finished, NO! MORE! FIRE!
	if (finished == false and timeLimit - (Time.time - waveStartTime) < 0) then
		if (ripped == false) then
			ripped = true
			Audio.PlaySound("rip")
		end
		local fireFrame = math.floor(Time.time/(1/15) % 5)
		local timeDiff = (timeLimit - (Time.time - waveStartTime)) * -1
		local bullet = CreateProjectileAbs("flame" .. fireFrame, math.min(-20 + timeDiff^3 * 75, 300), 298)
		bullet.SetVar('damage',16)
		table.insert(oneFrameBullets, bullet)
		bullet = CreateProjectileAbs("flame" .. fireFrame, math.max(660 - timeDiff^3 * 75, 340), 298)
		bullet.SetVar('damage',16)
		table.insert(oneFrameBullets, bullet)
		if (timeDiff > 2) then EndWave() end
	end
	--Should also end the wave a second after you reach the finish line
	if (finished == true and Time.time - finishTime > 1) then
		if (Time.time - waveStartTime < 8) then
			--The player finished fast. Too fast
			SetGlobal("fastfinish",true)
		end
		SetGlobal("finishedpuzzle",true)
		EndWave()
	end
	
	--On the water-filled puzzle, being orange means instant death :3
	if (GetGlobal("attackNum") == 10 and flavor == ORANGE) then
		if (ripped == false) then
			ripped = true
			Audio.PlaySound("conglaturation")
			timeLimit = Time.time - waveStartTime
			Encounter.SetVar("idleAnim",false)
			Encounter.GetVar("enemies")[1].Call("SetSprite","alphystrollgrin")
		end
	end
	
	
	--Flavor hud
	flavorHUD.SendToTop()
	if (flavor == ORANGE) then
		local bullet = CreateProjectileAbs("orangehud", 490, 418)
		bullet.SetVar('tile',1)
		table.insert(oneFrameBullets, bullet)
	elseif (flavor == LEMON) then
		local bullet = CreateProjectileAbs("lemonhud", 490, 418)
		bullet.SetVar('tile',1)
		table.insert(oneFrameBullets, bullet)
	end
	
	--Minimum of zero on the timer.
	local seconds = math.max(math.ceil(timeLimit - (Time.time - waveStartTime)),0)
	if (seconds >= 10) then
		local bullet = CreateProjectileAbs("spr_digitalnumber_" .. math.floor(seconds / 10), 590, 418)
		bullet.SetVar('tile',1)
		table.insert(oneFrameBullets, bullet)
	end
	local bullet = CreateProjectileAbs("spr_digitalnumber_" .. seconds % 10, 608, 418)
	bullet.SetVar('tile',1)
	table.insert(oneFrameBullets, bullet)
	
	
	--playerbullet.MoveTo(Player.x, Player.y)
	--playerbullet.SendToTop()

end

function OnHit(bullet)
	--"Tile" bullets shouldn't collide with the player. Board tiles, fading lasers, whatever else
	--During colored tile puzzles, the player "moving" needs to be determined differently
	if(finished == false and bullet.GetVar('tile') ~= 1) then
		if (bullet.GetVar('color') == BLUE) then
			if (moving ~= NONE) then Player.Hurt(bullet.GetVar('damage')) end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (moving == NONE) then Player.Hurt(bullet.GetVar('damage')) end
		else
			Player.Hurt(bullet.GetVar('damage'))
		end
	end
end

function TestMove(newX, newY)
	--OOB?
	if (newY < 1 or newY > GRIDWIDTH or newX < 1 or newX > GRIDHEIGHT) then return false end
	--Red tile?
	if (puzzle[newY][newX] ~= "red") then 
		return true
	else 
		return false
	end
end

function NextToYellow(newX, newY)
	--Self-explanatory. I have to make sure I don't check out of bounds tiles, though
	if (newY+1 <= GRIDWIDTH) then if (puzzle[newY+1][newX] == "yellow") then return true end end
	if (newY-1 > 0) then if (puzzle[newY-1][newX] == "yellow") then return true end end
	if (newX+1 <= GRIDHEIGHT) then if (puzzle[newY][newX+1] == "yellow") then return true end end
	if (newX-1 > 0) then if (puzzle[newY][newX-1] == "yellow") then return true end end
	return false
end