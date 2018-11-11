Arena.Resize(215, 180)

bullets = {}

timer = 0
handtop_timer = 4
handbottom_timer = -10
handtop = CreateProjectile("bullet/hand", -170, 106)
handtop.sprite.Set("bullet/hand")
handtop.sprite.rotation = 180
handtop.sprite.xscale = 2
handtop.sprite.yscale = 2
handtop.SetVar('bullet_type', 0)
handtop.SetVar('x_speed', 3.25)
handtop.SetVar('y_speed', -1 * 0.88)
handtop.SetVar('y_grav', 1 / 60 * 0.80)
handtop.SetVar('x_grav', 0)
handtop.sprite.alpha = 0.5

handbottom = CreateProjectile("bullet/hand", 182, -70)
handbottom.sprite.Set("bullet/hand")
handbottom.sprite.xscale = 2
handbottom.sprite.yscale = 2

handbottom.SetVar('bullet_type', 0)
handbottom.SetVar('x_speed', -3.25)
handbottom.SetVar('y_speed', 1)
handbottom.SetVar('y_grav', -1 / 60 * 0.75)
handbottom.SetVar('x_grav', 0)
handbottom.sprite.alpha = 0.2

top_bullets = 0
bottom_bullets = 0
bullets_set = false

function handle_hand_movement(bullet)
	local x_speed = bullet.GetVar('x_speed')
	local y_speed = bullet.GetVar('y_speed')
	local y_grav = bullet.GetVar('y_grav')
	local x_grav = bullet.GetVar('x_grav')
	bullet.MoveTo(bullet.x + x_speed, bullet.y + y_speed)
	bullet.SetVar('y_speed', y_speed + y_grav)
	bullet.SetVar('x_speed', x_speed + x_grav)
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
	handle_hand_movement(handbottom)
	timer = timer + 1
	handtop_timer = handtop_timer + 1
	handbottom_timer = handbottom_timer + 1
	
	handtop.sprite.alpha = math.min(1.0, timer / 30 + 0.2)
	handbottom.sprite.alpha = math.min(1.0, timer / 30 + 0.2)

	if handtop_timer > 0 and top_bullets < 10 and handtop_timer % 10 == 0 then
		local top_bullet = CreateProjectile('bullet/big_fire_collision', handtop.x, handtop.y)
		
		top_bullet.sprite.Set('bigfirebullet0')
		top_bullet.sprite.SendToBottom()
		top_bullet.SetVar('bullet_type', 1)
		top_bullet.SetVar('frames_alive', 0)
		top_bullet.SetVar('x_speed', 0)
		top_bullet.SetVar('y_speed', 0)
		table.insert(bullets, top_bullet)
		top_bullets = top_bullets + 1
	end
	
	if handbottom_timer > 0 and bottom_bullets < 10 and handbottom_timer % 10 == 0 then
		local bottom_bullet = CreateProjectile('bullet/big_fire_collision', handbottom.x, handbottom.y + 6)
		
		bottom_bullet.sprite.Set('bigfirebullet0')
		bottom_bullet.sprite.SendToBottom()
		bottom_bullet.SetVar('bullet_type', 1)
		bottom_bullet.SetVar('frames_alive', 0)
		bottom_bullet.SetVar('x_speed', 0)
		bottom_bullet.SetVar('y_speed', 0)
		table.insert(bullets, bottom_bullet)
		bottom_bullets = bottom_bullets + 1
	end
	
	if not bullets_set and top_bullets == 10 and bottom_bullets == 10 then
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
			bullet.sprite.Set('bigfirebullet0')
		elseif frames_alive %8 == 4 then
			bullet.sprite.Set('bigfirebullet1')
		end
		bullet.SetVar('frames_alive', frames_alive)
		
		bullet.MoveTo(bullet.x + x_speed, bullet.y + y_speed)
		
		if (real_speed < 13) then
			bullet.SetVar('x_speed', x_speed * 1.04)
			bullet.SetVar('y_speed', y_speed * 1.04)
		end
	end
	
	if timer == 300 then
		EndWave()
	end
end

function SpawnBullet(key)
	local bullet = CreateProjectile("firebullet0", math.sin(Time.time)*Arena.width/bulletspawnportion, Arena.height*1.6)
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
		Player.Hurt(GetGlobal("atk"),0.1)
end