hands = {}
bullets = {}
bullet_count = 0
cur_hand = 2
total_hands = 6 -- yes, Asgore has three hands...

current_turn = GetGlobal('current_turn')

--if current_turn < 6 then
--	difficulty = 1
--elseif current_turn < 11 then
--    difficulty = 2
--else
--	difficulty = 3
--end

--DEBUG MODE DIFFICULTY--
difficulty=4

ARENA_WIDTH = 215
ARENA_HEIGHT = 180

Arena.Resize(ARENA_WIDTH, ARENA_HEIGHT)


--Don't change
fire_time = 88 -- How long the hand takes to release the bullets after it starts its path

--Change by difficulty
hand_interval = 80 / 60
bullet_accel = 1.04

if difficulty == 2 then
	hand_interval = 70 / 60
	bullet_accel = 1.04125

elseif difficulty == 3 then
	hand_interval = 60 / 60
	bullet_accel = 1.0425

elseif difficulty == 4 then
	hand_interval = 48 / 82
	bullet_accel = 1.84
end

starttime = Time.time - 0.6 * hand_interval -- last time a hand was set. Deliberately set back to get one quickly.
enddtime = starttime + 7.7 -- end of the wave... I could have just used wavetimer, but I don't like things I can't see.
real_starttime = Time.time -- terribly named, but refers to the actual start of the wave

--hand properties
--bullets - a set of bullets
--update_fn - which update function to use
--starttime - when the hand was put in its current position
-------------------------------------------------------------------

function create_hands()
	for i = 1,total_hands do
		local hand = {}
		hand.bullets = {}
		
		hand.starttime = Time.time
		
		table.insert(hands, hand)
		hand.projectile = CreateProjectile("bullet/hand", -400, -400)
		hand.projectile.sprite.Set("bullet/hand")
		hand.projectile.sprite.xscale = 2
		hand.projectile.sprite.yscale = 2
		hand.projectile.SetVar("harmful", false)
		hand.projectile.sprite.SetPivot(0.5, 0.5)
		hand.starttime = Time.time
		hand.projectile.sprite.SendToTop()
	end
end

create_hands()

function reset_hand()
	local hand = hands[cur_hand]
	cur_hand = ((cur_hand + 1) % total_hands) + 1 -- we want to reset the next hand next time.
	
	hand.starttime = Time.time
	hand.bullets = {}
	
	local direction = math.random(0,3)
	
	--DEBUG
	--direction = 0
	
	if direction == 0 then
		hand.update_fn = hand_update_left
		hand.x_origin = -96
		hand.y_origin = -148
		hand.vely = 250 / hand_interval
		hand.projectile.sprite.Set('bullet/hand')
		hand.projectile.sprite.rotation = 270
	elseif direction == 1 then
		hand.update_fn = hand_update_right
		hand.y_origin = 134
		hand.x_origin = 96
		hand.vely = -250 / hand_interval
		hand.projectile.sprite.Set('bullet/hand')
		hand.projectile.sprite.rotation = 90
	elseif direction == 2 then
		hand.update_fn = hand_update_top
		-- start positions
		hand.x_origin = -158
		hand.y_origin = 114
		--vertex of the parabola
		hand.vertex_x = 52
		hand.vertex_y = 70
		--how fast it moves on the x axis
		hand.velx = 315 / hand_interval
		hand.projectile.sprite.Set('bullet/hand_top')
		hand.projectile.sprite.rotation = 180
	else
		hand.update_fn = hand_update_bottom
		--start positions
		hand.x_origin = 168
		hand.y_origin = -122
		--vertex of the parabola
		hand.vertex_x = -60
		hand.vertex_y = -84
		--ho fast it moves on the x axis
		hand.velx = -315 / hand_interval
		hand.projectile.sprite.Set('bullet/hand_top')
		hand.projectile.sprite.rotation = 0
	end
	hand.projectile.sprite.alpha = 0.4
	
	-- might comment this one out in a little while
	hand.x = hand.x_origin
	hand.y = hand.y_origin
	
	hand.bullets_spawned = 0
end

function set_bullets_on_player(bullettable, num_bullets, x_diff, y_diff)
	for i=1,num_bullets do
		local bullet = bullettable[i]
		local x_distance = bullet.x - (Player.x + x_diff)
		local y_distance = bullet.y - (Player.y + y_diff)
		local distance = math.sqrt(x_distance * x_distance + y_distance * y_distance)
		bullet.SetVar('xvel', -x_distance / distance * 0.45)
		bullet.SetVar('yvel', -y_distance / distance * 0.45)
	end
end

function hand_update_common(hand)
	if hand.projectile.sprite.alpha < 1 then
		hand.projectile.sprite.alpha = hand.projectile.sprite.alpha + 0.05
	end
end

-- left bottom to top / right top to bottom / top left to right / down right to left = 0 / 1 / 2 / 3
function hand_update_left(hand)
	hand_update_common(hand)
	local y_difference = hand.vely * (Time.time - hand.starttime)
	hand.projectile.MoveTo(hand.x_origin, hand.y_origin + y_difference)
	
	if hand.bullets_spawned == 11 then return end
	
	local distance_to_next_bullet = hand.bullets_spawned * 30 + 20

	if y_difference > distance_to_next_bullet then
		if hand.bullets_spawned == 10 then
			set_bullets_on_player(hand.bullets, 10, 20, 0)
			hand.bullets_spawned = 11
			return
		end
		local x_next_bullet = hand.x_origin + 4
		local y_next_bullet = hand.y_origin + distance_to_next_bullet
		create_bullet(hand, x_next_bullet, y_next_bullet)
	end
end

function hand_update_right(hand)
	hand_update_common(hand)
	local y_difference = hand.vely * (Time.time - hand.starttime)
	hand.projectile.MoveTo(hand.x_origin, hand.y_origin + y_difference)
	
	if hand.bullets_spawned == 11 then return end
	
	local distance_to_next_bullet = hand.bullets_spawned * 30

	if math.abs(y_difference) > distance_to_next_bullet then
		if hand.bullets_spawned == 10 then
			set_bullets_on_player(hand.bullets, 10, -20, 0)
			hand.bullets_spawned = 11
			return
		end
		local x_next_bullet = hand.x_origin - 10
		local y_next_bullet = hand.y_origin - distance_to_next_bullet
		create_bullet(hand, x_next_bullet, y_next_bullet)
	end
end

function create_bullet(hand, x, y)
	local bullet = CreateProjectile('bullet/big_fire_collision', x, y)
	bullet.sprite.Set('bigfirebullet0')
	bullet.sprite.SendToBottom()
		
	bullet.SetVar('xvel', 0)
	bullet.SetVar('yvel', 0)
	bullet.SetVar('harmful', true)
	bullet.SetVar('anim_frame_timer', Time.time)
	bullet.SetVar('anim_frame', 0)
		
	table.insert(hand.bullets, bullet) -- table used to set the bullets on the player
	table.insert(bullets, bullet)
	bullet_count = bullet_count + 1
		
	hand.bullets_spawned = hand.bullets_spawned + 1
end

function hand_update_top(hand)
	hand_update_common(hand)
	
	local x_difference = hand.velx * (Time.time - hand.starttime)
	local x = hand.x_origin + x_difference -- fix it!
	local diff_x = math.abs(52 - x)
	local y = 70 + 44 * math.pow(diff_x / 210, 2)
	
	hand.projectile.MoveTo(x, y)
	
	if hand.bullets_spawned == 11 then return end
	
	local distance_to_next_bullet = hand.bullets_spawned * 34
	if x_difference > distance_to_next_bullet then
		if hand.bullets_spawned == 10 then
			set_bullets_on_player(hand.bullets, 10, 0, -20)
			hand.bullets_spawned = 11
			return
		end
		local x_next_bullet = hand.x_origin + distance_to_next_bullet
		local diff_x_bullet = math.abs(52 - x_next_bullet)
		local y_next_bullet = 70 + 44 * math.pow(diff_x / 210, 2)
		create_bullet(hand, x_next_bullet, y_next_bullet)
	end
end

--hand.x_origin = 168
--hand.y_origin = -122
--vertex of the parabola
--hand.vertex_x = -60
--hand.vertex_y = -84
function hand_update_bottom(hand)
	hand_update_common(hand)
	
	local x_difference = hand.velx * (Time.time - hand.starttime)
	local x = hand.x_origin + x_difference -- fix it!
	local diff_x = math.abs(-60 - x)
	local y = -84 - 38 * math.pow(diff_x / 228, 2)
	
	hand.projectile.MoveTo(x, y)
	
	if hand.bullets_spawned == 11 then return end
	
	local distance_to_next_bullet = hand.bullets_spawned * 34
	if math.abs(x_difference) > distance_to_next_bullet then
		if hand.bullets_spawned == 10 then
			set_bullets_on_player(hand.bullets, 10, 0, 20)
			hand.bullets_spawned = 11
			return
		end
		local x_next_bullet = hand.x_origin - distance_to_next_bullet
		local diff_x_bullet = math.abs(-60 - x_next_bullet)
		local y_next_bullet = -84 - 38 * math.pow(diff_x / 228, 2)
		create_bullet(hand, x_next_bullet, y_next_bullet)
	end
end

function update_hands()
	if Time.time >= enddtime then
		EndWave()
		return
	end
	if Time.time - starttime >= hand_interval then
		reset_hand()
		starttime = Time.time
	end
	
	for i = 1,total_hands do
		local hand = hands[i]
		if not hand then
			break
		end
		
		if hand.update_fn then
			hand.update_fn(hand)
		end
	end
end

function tern ( cond , T , F )
    if cond then return T else return F end
end

function update_bullet(bullet)
	local xvel = bullet.GetVar('xvel')
	local yvel = bullet.GetVar('yvel')
	local speed = xvel * xvel + yvel * yvel
	local last_frame_update = bullet.GetVar('anim_frame_timer')

	bullet.Move(xvel, yvel)
	
	if (speed < 13) then
		bullet.SetVar('xvel', xvel * bullet_accel)
		bullet.SetVar('yvel', yvel * bullet_accel)
	end
	
	if Time.time - last_frame_update >= 4 / 60 then
		local last_frame = bullet.GetVar('anim_frame')
		if last_frame == 0 then
			bullet.sprite.Set('bigfirebullet1')
			bullet.SetVar('anim_frame', 1)
		else
			bullet.sprite.Set('bigfirebullet0')
			bullet.SetVar('anim_frame', 0)
		end
		bullet.SetVar('anim_frame_timer', Time.time)
	end
	
end

function update_bullets()
	for i=1,bullet_count do
		local bullet = bullets[i]
		update_bullet(bullet)
	end
end

function Update()
	update_hands()
	update_bullets()
end

function OnHit(bullet)
	local bullet_is_harmful = bullet.GetVar("harmful")
	if not bullet_is_harmful then
		return
	end
		Player.Hurt(GetGlobal("atk"),0.1)
end