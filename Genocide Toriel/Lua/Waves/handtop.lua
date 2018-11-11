Arena.Resize(210, 175)
SetGlobal("atk", 0)
bullets = {}

Encounter.SetVar("wavetimer", 8.0)

timer = 0
handtop_timer = 4
handtop = CreateProjectile("bullet/hand", -100, 100)
handtop.sprite.Set("bullet/hand")
handtop.sprite.rotation = 180
--handtop.sprite.xscale = 2
--handtop.sprite.yscale = 2
handtop.SetVar('bullet_type', 0)
handtop.SetVar('x_speed', 3.25)
handtop.SetVar('y_speed', -1 * 0.88)
handtop.SetVar('y_grav', 1 / 60 * 1.00)
handtop.SetVar('x_grav', 0)
handtop.sprite.alpha = 0.5

top_bullets = 0
bullets_set = false

function handle_hand_movement(bullet)
	local x_speed = bullet.GetVar('x_speed')
	local y_speed = bullet.GetVar('y_speed')
	local y_grav = bullet.GetVar('y_grav')
	local x_grav = bullet.GetVar('x_grav')
	bullet.MoveTo(bullet.x + x_speed, bullet.y + y_speed)
	bullet.SetVar('y_speed', y_speed + y_grav)
	bullet.SetVar('x_speed', x_speed + x_grav)
                     if handtop.x >= Arena.width/2 then
                         handtop.MoveTo(1000, bullet.y)
                     end
end

function set_on_player()
	for i=1,#bullets do
		local bullet = bullets[i]
		local x_distance = bullet.x - Player.x
		local y_distance = bullet.y - Player.y
		local distance = math.sqrt(x_distance * x_distance + y_distance * y_distance)
		bullet.SetVar('x_speed', -x_distance / distance * 0.4)
		bullet.SetVar('y_speed', -y_distance / distance * 0.4)
	end
end

function Update()
	handle_hand_movement(handtop)
	timer = timer + 1
	handtop_timer = handtop_timer + 1
	
                     if handtop.x >= 85 then
	       handtop.sprite.alpha = handtop.sprite.alpha - 0.09*Time.mult
                     else
	       handtop.sprite.alpha = math.min(1.0, timer / 30 + 0.2)
                     end

	if handtop_timer > 0 and top_bullets < 8 and handtop_timer % 8 == 0 then
		local top_bullet = CreateProjectile('bullet/big_fire_collision', handtop.x, handtop.y)
                                           Audio.PlaySound("click")
		
		top_bullet.sprite.Set('firebullet0')
		top_bullet.sprite.SendToBottom()
		top_bullet.SetVar('bullet_type', 1)
		top_bullet.SetVar('frames_alive', 0)
		top_bullet.SetVar('x_speed', 0)
		top_bullet.SetVar('y_speed', 0)
		table.insert(bullets, top_bullet)
		top_bullets = top_bullets + 1
	end
	
	if not bullets_set and top_bullets == 8 then
		set_on_player()
		bullets_set = true
	end
	
	for i=1,#bullets do
		local bullet = bullets[i]
		local x_speed = bullet.GetVar('x_speed')
		local y_speed = bullet.GetVar('y_speed')
		local real_speed = x_speed * x_speed + y_speed * y_speed
		local frames_alive = bullet.GetVar('frames_alive')
		
		frames_alive = frames_alive + 1
		if frames_alive % 8 == 0 then
			bullet.sprite.Set('firebullet0')
		elseif frames_alive %8 == 4 then
			bullet.sprite.Set('firebullet1')
		end
		bullet.SetVar('frames_alive', frames_alive)
		
		bullet.MoveTo(bullet.x + x_speed, bullet.y + y_speed)
		
		if (real_speed < 13) then
			bullet.SetVar('x_speed', x_speed * 1.04)
			bullet.SetVar('y_speed', y_speed * 1.04)
		end

		if (bullet.y < -Arena.height/2 + 8 and bullets_set == true) then
			bullet.SetVar('y_speed', 1.04)
		elseif (bullet.y > Arena.height/2 - 8 and bullets_set == true) then
			bullet.SetVar('y_speed', -1.04)
		end
		if (bullet.x < -Arena.width/2 + 8 and bullets_set == true) then 
			bullet.SetVar('x_speed', 1.04)
		elseif (bullet.x > Arena.width/2 - 8 and bullets_set == true) then
			bullet.SetVar('x_speed', -1.04)
		end

	end
	
	if timer == 300 then
		EndWave()
	end
end

function SpawnBullet(key)
	local bullet = CreateProjectile("firebullet0", math.sin(Time.time)*Arena.width/bulletspawnportion, Arena.height*1.6)
                     Audio.PlaySound("click")
	bullet.SetVar("startingx", bullet.x)
	bullet.SetVar("vely", -3)
	bullet.SetVar("spawntime", key)
	table.insert(bullets, bullet)
end

function OnHit(bullet)
	local bullet_type = bullet.GetVar('bullet_type')
	if bullet_type == 0 then
		return
	end
	
	if (Player.hp - GetGlobal("atk") < 1 and Player.hp <= GetGlobal("atk")) and Player.isHurting == false then
		Player.Hurt(3)
	else
		Player.Hurt(3)
	end
end