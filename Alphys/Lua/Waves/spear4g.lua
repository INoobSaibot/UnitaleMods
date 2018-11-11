--[[ 

Undyne the Undying [Genocide Battle Recreation] made by u/Jetrocketboy
Original source/base lua made by u/Crystalwarrior and u/Moofins21
Animation made and provided by u/BOBtheman2000

Hope you enjoy the fight as much as I had fun making it.

]]--

Arena.resize(75, 100)
Player.sprite.color = {237/255, 0/255, 0/255}

bullets = {}
spawntimer = 0
attack_start = Time.time
soundplay = false

speed = 1 --Initial speed
function Update()
	spawntimer = spawntimer + 0.5

	-- Duration is the same as wavetimer.
	local dur = Time.time - attack_start 

	if(spawntimer % 26 == 0) and dur < 8.0 then -- Only spawn spears if duration/wavetimer is less than 8.0.
		local bullet = CreateProjectile('spear', -25 + (math.random(3)-1)*25, -Arena.height+32)
		bullet.SetVar('firing', 60)
		bullet.SetVar('fired', 0)
		bullet.sprite.alpha = 0
		table.insert(bullets,bullet)
		Audio.PlaySound('spawn')
	elseif(spawntimer % 26 == 0) and dur < 8.0 then
		local bullet = CreateProjectile('spear', -25 + (math.random(3)-1)*25, -Arena.height-32)
		bullet.SetVar('firing', 60)
		bullet.SetVar('fired', 0)
		bullet.sprite.alpha = 0
		table.insert(bullets,bullet)
		Audio.PlaySound('spawn')
	end

	-- Stops player and sets sprite to green.
	if dur > 9.0 and soundplay == false then
		Player.SetControlOverride(true)
		Player.sprite.color = {255/255, 255/255, 0/255}
		Audio.PlaySound('switch')
		soundplay = true
	end

	for i=1, #bullets do
		local bullet = bullets[i]
		if bullet.isactive then
			local firing = bullet.GetVar('firing')
			if firing <= 0 then -- Firing is decreased every frame as a "countdown" to the time for the spear to be actually fired.
				if bullet.GetVar('fired') == 0 then
					bullet.SetVar('yvel', 5)
					Audio.PlaySound('pierce')
					bullet.SetVar('fired', 1)
				end

				bullet.MoveTo(bullet.x, bullet.y+5) -- Fires spear once countdown is 0.

				if bullet.y > 15 then
					bullet.MoveTo(bullet.x, bullet.y) -- Stops spear.
					bullet.sprite.alpha = bullet.sprite.alpha - 2/40*Time.mult -- Fades out spear.
				end
			else
				bullet.SetVar('firing', firing-1)
				bullet.MoveTo(bullet.x, math.min(bullet.y+0.3, -Arena.height+32+10)) -- Spawn-in animation.
				bullet.sprite.alpha = bullet.sprite.alpha + 0.05
			end
		end
	end
end

function OnHit(bullet)
	-- Only hurts the player if alpha is at a certain value.
	if bullet.sprite.alpha > 0.9 then
		Player.Hurt(2)
	end
end