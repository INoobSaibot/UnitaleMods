--[[ 

Undyne the Undying [Genocide Battle Recreation] made by u/Jetrocketboy
Original source/base lua made by u/Crystalwarrior and u/Moofins21
Animation made and provided by u/BOBtheman2000

Hope you enjoy the fight as much as I had fun making it.

]]--

Arena.Resize(75, 75)
Player.SetControlOverride(true)
Player.MoveTo(0,-24, false)
Player.sprite.color = {255/255, 255/255, 0/255}

bullets = {}
attack_start = Time.time
spawntimer = 0
hittimer = 0
spawntimer = 0
createdfakearena = false

heart = CreateProjectile("greenheart0", 777, 777)
shield = CreateProjectileAbs("shield", 777, 777)
shield.SetVar("targetrot",0)
shield.SetVar("rotspeed",1)
shielddir = "up"

-- This is where we grab the bullet pattern table.
bullet_table = {
[50] = {dir = 'up', speed = 4}, 
[80] = {dir = 'right', speed = 4},
[110] = {dir = 'down', speed = 4},
[140] = {dir = 'left', speed = 4},
[170] = {dir = 'up', speed = 4},
[200] = {dir = 'right', speed = 4},
[230] = {dir = 'down', speed = 4},
[260] = {dir = 'left', speed = 4},
[290] = {dir = 'up', speed = 4},
[300] = {dir = 'up', speed = 4},
[310] = {dir = 'up', speed = 4},
[320] = {dir = 'up', speed = 4},
}
function Update()
	spawntimer = spawntimer + 1

	local proj = bullet_table[spawntimer]
	if type(proj) == "table" then
		local dir = proj.dir
		if type(dir) == "table" then
			dir = dir[math.random(#dir)]
		end

		if dir == 'down' then
			local bullet = CreateProjectileAbs('arrowup', 320, -80)
			bullet.SetVar('velx', 0)
			bullet.SetVar('vely', proj.speed)
			bullet.SetVar('backward', 0) -- This variable is used to differentiate regular arrows and backward arrows.
			table.insert(bullets, bullet)
		end
		if dir == 'up' then
			local bullet = CreateProjectileAbs('arrowdown', 320, 560)
			bullet.SetVar('velx', 0)
			bullet.SetVar('vely', -proj.speed)
			bullet.SetVar('backward', 0)
			table.insert(bullets, bullet)
		end
		if dir == 'left' then
			local bullet = CreateProjectileAbs('arrowright', 0, 240)
			bullet.SetVar('velx', proj.speed)
			bullet.SetVar('vely', 0)
			bullet.SetVar('backward', 0)
			table.insert(bullets, bullet)
		end
		if dir == 'right' then
			local bullet = CreateProjectileAbs('arrowleft', 640, 240)
			bullet.SetVar('velx', -proj.speed)
			bullet.SetVar('vely', 0)
			bullet.SetVar('backward', 0)
			table.insert(bullets, bullet)
		end
	end

	if proj == 'barrowup' then
		Backarrow(1)
	end
	if proj == 'barrowright' then
		Backarrow(2)
	end
	if proj == 'barrowdown' then
		Backarrow(3)
	end
	if proj == 'barrowleft' then
		Backarrow(4)
	end

	if proj == 'repeat' then
		spawntimer = 40
	end

	-- Duration is the same as wavetimer.
	local dur = Time.time - attack_start

 	-- Covers the regular arena and spawns the fake arena.
    if dur > 0.7 and createdfakearena == false then
		arenawall = CreateProjectile("faux_arena", 0, 0)
		shield = CreateProjectile("shield", 0, 0)
		shield.SetVar('targetrot', 0)
		shield.SetVar('rotspeed', 1)
		heart = CreateProjectile("greenheart0", 0, 0)
		cover2 = CreateProjectile("arena_cover2", 0, 0)
		cover2.SendToBottom()
		arenacover = CreateProjectile("arena_cover", 0, 0)
		arenacover.SendToBottom()
		createdfakearena = true
		fade = CreateProjectileAbs("fade", 320, 240)
		fade.SendToBottom()
		fade.sprite.alpha = 0
    end

    -- Moves the fake arena up to the middle of the screen.
    if dur < 1.1 and dur > 0.7 then
		arenawall.MoveTo(arenawall.x, arenawall.y+4.5*Time.mult)
		shield.MoveTo(shield.x, shield.y+4.5*Time.mult)
		heart.MoveTo(heart.x, heart.y+4.5*Time.mult)
		cover2.MoveTo(cover2.x, cover2.y+4.5*Time.mult)

		-- Fades out the background slightly.
		fade.sprite.alpha = fade.sprite.alpha + 0.015*Time.mult
    end

    if dur > 1.1 then 
    	Player.MoveToAbs(320, 240, true)

    	-- Simulates invincibilty frames.
    	local hurtframe = 0
		if (Player.isHurting) then 
			hurtframe = math.floor((Time.time / (1/15)) % 2) 
		end
		heart.sprite.Set("greenheart" .. hurtframe)
    end

    -- Manages shield rotation.
	local target = shield.GetVar("targetrot")
	local rotspeed = shield.GetVar("rotspeed")
	if math.abs(shield.sprite.rotation-target) < 30 * rotspeed then
		shield.sprite.rotation = target
		shield.SetVar('rotspeed', 1)
	elseif shield.sprite.rotation > target then
		shield.sprite.rotation = shield.sprite.rotation - 25 * rotspeed
	elseif shield.sprite.rotation < target then
		shield.sprite.rotation = shield.sprite.rotation + 25 * rotspeed
	end

	if Input.Left == 1 then 
		ShieldLeft()
		shielddir = "left"
	end
	if Input.Right == 1 then 
		ShieldRight()
		shielddir = "right" 
	end
	if Input.Up == 1 then 
		ShieldUp() 
		shielddir = "up"
	end
	if Input.Down == 1 then 
		ShieldDown()
		shielddir = "down" 
	end

	-- Manages the shield's sprite change when an arrow is blocked.
	hittimer = math.max(0, hittimer - 1)

	if shielddir == "right" then
		if hittimer > 0 then
			shield.sprite.Set("shield_a")
		else
			shield.sprite.Set("shield")
		end
	elseif shielddir == "left" then
		if hittimer > 0 then
			shield.sprite.Set("shield_a")
		else
			shield.sprite.Set("shield")
		end
	elseif shielddir == "up" then
		if hittimer > 0 then
			shield.sprite.Set("shield_a")
		else
			shield.sprite.Set("shield")
		end
	elseif shielddir == "down" then
		if hittimer > 0 then
			shield.sprite.Set("shield_a")
		else
			shield.sprite.Set("shield")
		end
	end
	
	for i=1,#bullets do
		local bullet = bullets[i]
		if bullet.isactive then
			if bullet.GetVar('backward') == 0 then -- Checks if the bullet is a regular arrow.
				local velx = bullet.GetVar('velx')
				local vely = bullet.GetVar('vely')
				local newposx = bullet.x + velx
				local newposy = bullet.y + vely
				bullet.MoveTo(newposx, newposy) -- Moves arrow based on speed variable.

				-- Changes arrow sprite when it gets close.
				if bullet.absx > 200 and bullet.absx < 320 then
					bullet.sprite.Set("aarrowright")
				elseif bullet.absx < 440 and bullet.absx > 320 then
					bullet.sprite.Set("aarrowleft")
				elseif bullet.absy < 360 and bullet.absy > 240 then
					bullet.sprite.Set("aarrowdown")
				elseif bullet.absy > 120 and bullet.absy < 240 then
					bullet.sprite.Set("aarrowup")
				end

				-- Manages successful blocking of an arrow.
				if bullet.absx > 270 and bullet.absx < 300 and bullet.GetVar('velx') > 0 and shielddir == "left" then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				elseif bullet.absx < 370 and bullet.absx > 340 and bullet.GetVar('velx') < 0 and shielddir == "right" then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				elseif bullet.absy < 290 and bullet.absy > 260 and bullet.GetVar('vely') < 0 and shielddir == "up" then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				elseif bullet.absy > 190 and bullet.absy < 220 and bullet.GetVar('vely') > 0 and shielddir == "down" then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				end

				-- Manages unsuccessful blocking of an arrow.
				if bullet.absx > 310 and bullet.absx < 330 and bullet.GetVar('vely') == 0 then
					bullet.Remove()
					Player.Hurt(4)
				elseif bullet.absy > 230 and bullet.absy < 250 and bullet.GetVar('velx') == 0 then
					bullet.Remove()
					Player.Hurt(4)
				end
			end
			if bullet.GetVar('backward') > 0 then -- Checks if the bullet is a backward arrow.
				local rad = bullet.GetVar('radius')
	    		local angle = bullet.GetVar('angle')
	    		bullet.SetVar('radius', rad-3)
	    		bullet.MoveTo(rad*math.cos(angle), Player.y+rad*math.sin(angle))

	    		-- Flips barrow to other side.
	    		if math.abs(bullet.x-Player.x) < 130 and math.abs(bullet.y-Player.y) < 130 and angle ~= bullet.GetVar('targetangle') then
					bullet.SetVar('angle', angle-math.pi/20)
					if math.abs(angle - bullet.GetVar('targetangle')) < math.pi/15 then
		    			bullet.SetVar('angle', bullet.GetVar('targetangle'))
		    			bullet.SetVar('flipped', 1)
					end
	    		end

	    		-- Manages successful blocking of a barrow.
				if bullet.absy > 190 and bullet.absy < 220 and -bullet.GetVar('vely') > 0 and shielddir == "down" and bullet.GetVar('flipped') == 1 then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				elseif bullet.absx > 270 and bullet.absx < 300 and -bullet.GetVar('velx') > 0 and shielddir == "left" and bullet.GetVar('flipped') == 1 then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				elseif bullet.absx < 370 and bullet.absx > 340 and -bullet.GetVar('velx') < 0 and shielddir == "right" and bullet.GetVar('flipped') == 1 then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				elseif bullet.absy < 290 and bullet.absy > 260 and -bullet.GetVar('vely') < 0 and shielddir == "up" and bullet.GetVar('flipped') == 1 then
					hittimer = 10
					bullet.Remove()
					Audio.PlaySound('hit')
				end

				-- Manages unsuccessful blocking of a barrow.
	    		if bullet.absx > 310 and bullet.absx < 330 and bullet.GetVar('vely') == 0 and bullet.GetVar('flipped') == 1 then
					bullet.Remove()
					Player.Hurt(4)
				elseif bullet.absy > 230 and bullet.absy < 250 and bullet.GetVar('velx') == 0 and bullet.GetVar('flipped') == 1 then
					bullet.Remove()
					Player.Hurt(4)
				end
			end
		end	
	end
end
 
function OnHit(bullet)
-- Empty so that the fake arena and other non-bullet bullets don't hurt the player.
end

-- Shield functions.
function ShieldRight()
	shielddir = "right"
	local shield = shield
    if shield.sprite.rotation == 0 then 
    	shield.sprite.rotation = 359.99 
    end
    shield.SetVar('targetrot', 270)
    if shield.sprite.rotation == 90 then 
    	shield.SetVar('rotspeed', 2) 
    end
end

function ShieldDown()
	shielddir = "down"
	local shield = shield
	shield.SetVar('targetrot', 180)
    if shield.sprite.rotation > 359 or shield.sprite.rotation == 0 then 
    	shield.SetVar('rotspeed', 2) 
    end
end

function ShieldLeft()
	shielddir = "left"
	local shield = shield
    if shield.sprite.rotation > 359 then 
    	shield.sprite.rotation = 0 
    end
    shield.SetVar('targetrot', 90)
    if shield.sprite.rotation == 270 then 
    	shield.SetVar('rotspeed', 2) 
    end
end

function ShieldUp()
	shielddir = "up"
	local shield = shield
    if shield.sprite.rotation == 270 then 
    	shield.SetVar('targetrot', 359.99)
    elseif shield.sprite.rotation < 359 then 
    	shield.SetVar('targetrot', 0) 
    end
    if shield.sprite.rotation == 180 then 
    	shield.SetVar('rotspeed', 2) 
    end
end

-- Manages backward arrows.
function Backarrow(dir)
	if dir == 1 then -- Barrow comes from top of the screen.
		local rotation = 0
		local angle = rotation * math.pi/180
		local bullet = CreateProjectile("barrow", Player.x+320*math.cos(angle-math.pi/2), Player.y+320*math.sin(angle-math.pi/2))
		bullet.SetVar('backward', 1)
		bullet.SetVar('velx', 0)
		bullet.SetVar('vely', -1)
		bullet.SetVar('flipped', 0)
		bullet.SetVar('radius', 320)
		bullet.SetVar('angle', angle+math.pi/2)
		bullet.SetVar('targetangle', angle-math.pi/2)
		bullet.sprite.rotation = rotation-180
		table.insert(bullets, bullet)
	end
	if dir == 2 then -- Barrow comes from the right.
		local rotation = 270
		local angle = rotation * math.pi/180
		local bullet = CreateProjectile("barrow", Player.x+320*math.cos(angle-math.pi/2), Player.y+320*math.sin(angle-math.pi/2))
		bullet.SetVar('backward', 1)
		bullet.SetVar('velx', -1)
		bullet.SetVar('vely', 0)
		bullet.SetVar('flipped', 0)
		bullet.SetVar('radius', 320)
		bullet.SetVar('angle', angle+math.pi/2)
		bullet.SetVar('targetangle', angle-math.pi/2)
		bullet.sprite.rotation = rotation-180
		table.insert(bullets, bullet)
	end
	if dir == 3 then -- Barrow comes from the bottom of the screen.
		local rotation = 180
		local angle = rotation * math.pi/180
		local bullet = CreateProjectile("barrow", Player.x+320*math.cos(angle-math.pi/2), Player.y+320*math.sin(angle-math.pi/2))
		bullet.SetVar('backward', 1)
		bullet.SetVar('velx', 0)
		bullet.SetVar('vely', 1)
		bullet.SetVar('flipped', 0)
		bullet.SetVar('radius', 320)
		bullet.SetVar('angle', angle+math.pi/2)
		bullet.SetVar('targetangle', angle-math.pi/2)
		bullet.sprite.rotation = rotation-180
		table.insert(bullets, bullet)
	end
	if dir == 4 then -- Barrow comes from the left.
		local rotation = 90
		local angle = rotation * math.pi/180
		local bullet = CreateProjectile("barrow", Player.x+320*math.cos(angle-math.pi/2), Player.y+320*math.sin(angle-math.pi/2))
		bullet.SetVar('backward', 1)
		bullet.SetVar('velx', 1)
		bullet.SetVar('vely', 0)
		bullet.SetVar('flipped', 0)
		bullet.SetVar('radius', 320)
		bullet.SetVar('angle', angle+math.pi/2)
		bullet.SetVar('targetangle', angle-math.pi/2)
		bullet.sprite.rotation = rotation-180
		table.insert(bullets, bullet)
	end
end