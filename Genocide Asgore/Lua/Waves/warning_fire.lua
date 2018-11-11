--Player.MoveTo(-30, Player.y, false)
stream_bullets = {}
stream_bullet_count = 0
inactive_stream_bullets = {}
inactive_stream_bullet_count = 0

emitter_bullets = {}
emitter_bullets_count = 0
emitter_starttime = Time.time - 1 -- Get an emitter bullet right off the bat.

current_turn = GetGlobal('current_turn')

--if current_turn < 5 then
--	difficulty = 1
--else
 --   difficulty = 2
--end

wave_frames_elapsed = 0

--DEBUG MODE DIFFICULTY--
--difficulty=1

ARENA_WIDTH = 215
ARENA_HEIGHT = 180

Arena.Resize(ARENA_WIDTH, ARENA_HEIGHT)

emitter_x_origin = 0
emitter_y_origin = 190
emitter_radius = 32 -- pixels from origin to circle around
emitter_theta = 0 -- current phase around the circle
emitter_period = 6 -- seconds to get around the circle
emitter_direction = 0 -- 0 is to the right, 1 is to the left
emitter_cur_in_direction = 0 -- will do either 2 or 3, favoring 3.
emitter_last_fire = 0 -- tracks the time the last fireball was made
emitter_time_between_fireballs = 1 -- expected frames between fireballs... but it really works with delta time

emitter_bullet_yvel = 145 -- pixels per second traveled by emitter bullets
emitter_bullet_amplitude = ARENA_WIDTH * 0.4
emitter_bullet_period = 100 -- time for bullets to do a complete wave in frames


time_to_first_warning = 50 --expected frames for first warning to show up
warning_duration = 25 -- expected frames from when a warning box appears to when the fire streams start
warning_horizontal = 75
warning_vertical = 177
warning_beep_time = 5 -- expected frames between warning sounds

bullet_vertical_velocity = 270 --pixels a bullet travels downward over the course of a second
total_warnings = 8

if difficulty == 2 then
	emitter_time_between_fireballs = 10 -- longer for some reason
	warning_duration = 50
	time_to_first_warning = 60
	warning_horizontal = 75
	bullet_vertical_velocity = 270
	total_warnings = 6
	emitter_bullet_yvel = 145
	emitter_radius = 36
	emitter_bullet_period = 75
end

phase_left = math.pi / 2 -- starting phase of bullets going to the left
phase_right = 0 -- starting phase of bullets going to the right
wave_length = 180 -- in vertical pixels
travel_time = 120 -- time for a fireball to go from the top to the bottom

time_to_next_warning = time_to_first_warning
starttime = Time.time -- used for tracking warning stuff

real_starttime = Time.time -- terribly named, but refers to the actual start of the wave

warnings_done_so_far = 0

warning_active = false

warning_is_yellow = false

function tern ( cond , T , F )
    if cond then return T else return F end
end

function create_wave_bullet(x_center, top, x_iter, y_iter)
	local bullet
	local random_vert_offset = math.random(0, 32)
	
	if inactive_stream_bullet_count > 0 then
		bullet = inactive_stream_bullets[inactive_stream_bullet_count]
		table.remove(inactive_stream_bullets, inactive_stream_bullet_count)
		inactive_stream_bullet_count = inactive_stream_bullet_count - 1
		
		bullet.MoveTo(x_center + x_iter * (warning_horizontal - 24) + math.random(-8, 8),
		              tern(top, 0.5 * Arena.height, -0.5 * Arena.height) + tern(top, y_iter, -y_iter) * 28 + tern(top, random_vert_offset, -random_vert_offset))
	else
		bullet = CreateProjectile('reddot',
		                          x_center + x_iter * (warning_horizontal - 24) + math.random(-8, 8),
		                          tern(top, 0.5 * Arena.height, -0.5 * Arena.height) + tern(top, y_iter, -y_iter) * 28 + tern(top, random_vert_offset, -random_vert_offset))
		bullet.sprite.set('firebullet0')
		table.insert(stream_bullets, bullet)
		stream_bullet_count = stream_bullet_count + 1
		bullet.SetVar("harmful", true)
	end
	
	bullet.sprite.alpha = 0
	bullet.SetVar('bullet_active', true)
	if top then
		bullet.SetVar('vel_y', -bullet_vertical_velocity)
	else
		bullet.SetVar('vel_y', bullet_vertical_velocity)
	end
end

function stream_bullet_update(bullet, delta)
	local active = bullet.GetVar('bullet_active')
	if not active then
		return
	end

	local vel = bullet.GetVar('vel_y')
	
	bullet.MoveTo(bullet.x, bullet.y + delta * vel)
	
	
	if vel < 0 then
		if bullet.y < -Arena.height / 2 then
			bullet.sprite.alpha = 0
			bullet.SetVar('bullet_active', false)
			table.insert(inactive_stream_bullets, bullet)
			inactive_stream_bullet_count = inactive_stream_bullet_count + 1
		elseif bullet.y < Arena.height / 2 then
			bullet.sprite.alpha = 1
		end
	elseif vel > 0 then
		if bullet.y > Arena.height / 2 then
			bullet.sprite.alpha = 0
			bullet.SetVar('bullet_active', false)
			table.insert(inactive_stream_bullets, bullet)
			inactive_stream_bullet_count = inactive_stream_bullet_count + 1
		elseif bullet.y > -Arena.height / 2 then
			bullet.sprite.alpha = 1
		end
	end
	

end

function stream_bullets_update()
	if stream_bullet_count == 0 then
		return
	end
	
	local delta = Time.time - last_bullet_update

	if delta == 0 then
		return
	end
	
	for i = 1,stream_bullet_count do
		stream_bullet_update(stream_bullets[i], delta)
	end
	
	last_bullet_update = Time.time
end

function blast_wave(x_pos)
	for y = 0,4 do
		for x = -0.5, 0.5, 1 / 2 do
			create_wave_bullet(x_pos, false, x, y)
		end
	end
	
	for y = 0,4 do
		for x = -0.5, 0.5, 1 / 3 do
			create_wave_bullet(x_pos, true, x, y)
		end
	end
	
	last_bullet_update = Time.time
	Audio.PlaySound('warning_fire')
end

function create_warning()
	if Player.x < -30 then
		offset = -Arena.width/2 + warning_horizontal / 2 + 1
		exclam_offset = -Arena.width / 2 + 24
	elseif Player.x > 30 then
		offset = Arena.width/2 - warning_horizontal / 2 - 1
		exclam_offset = Arena.width / 2 - 24
	elseif Player.x > -30 and Player.x < 30 then
		offset = 0
		exclam_offset = 0
	end
	warning_exclamation_point = CreateProjectile('bullet/warning_exclamation', exclam_offset, 16)
	warning_top_border = CreateProjectile('bullet/warning_border_horz', 0 + offset, 88)
	warning_top_border.sprite.Set('bullet/warning_border_horz')
	warning_top_border.sprite.xscale = warning_horizontal / 100
	warning_bottom_border = CreateProjectile('bullet/warning_border_horz', 0 + offset, -88)
	warning_bottom_border.sprite.Set('bullet/warning_border_horz')
	warning_bottom_border.sprite.xscale = warning_horizontal / 100
	warning_left_border = CreateProjectile('bullet/warning_border_vert', -warning_horizontal / 2 + offset, 0)
	warning_right_border = CreateProjectile('bullet/warning_border_vert', warning_horizontal / 2 + offset, 0)
	warning_exclamation_point.sprite.color = {1, 0.25, 0.25}
	warning_bottom_border.sprite.color = {1, 0, 0}
	warning_left_border.sprite.color = {1, 0, 0}
	warning_top_border.sprite.color = {1, 0, 0}
	warning_right_border.sprite.color = {1, 0, 0}
	
	warning_start_time = Time.time
	last_beep_time = warning_start_time
	warning_active = true
end

function update_warning()
	if not warning_active then
		return
	end
	
	if not warning_is_yellow then
		if Time.time - last_beep_time >= warning_beep_time / 60 then
			warning_is_yellow = true
			last_beep_time = Time.time
			Audio.PlaySound('warning_sound')
			
			warning_exclamation_point.sprite.color = {1, 1, 0.5}
			warning_bottom_border.sprite.color = {1, 1, 0}
			warning_left_border.sprite.color = {1, 1, 0}
			warning_top_border.sprite.color = {1, 1, 0}
			warning_right_border.sprite.color = {1, 1, 0}
		end
	else
		warning_is_yellow = false
		warning_exclamation_point.sprite.color = {1, 0.25, 0.25}
		warning_bottom_border.sprite.color = {1, 0, 0}
		warning_left_border.sprite.color = {1, 0, 0}
		warning_top_border.sprite.color = {1, 0, 0}
		warning_right_border.sprite.color = {1, 0, 0}
	end
	
	if Time.time - warning_start_time >= warning_duration / 60 then
		blast_wave(warning_bottom_border.x)
		warning_exclamation_point.Remove()
		warning_top_border.Remove()
		warning_bottom_border.Remove()
		warning_left_border.Remove()
		warning_right_border.Remove()
		warning_active = false
	end
end

emitterpi = math.pi * 2 / emitter_period

function add_emitter_bullet()
	local cur_phase = -(Time.time - real_starttime) * emitterpi
	local x = emitter_x_origin + emitter_radius * math.cos(cur_phase)
	local y = emitter_y_origin + emitter_radius * math.sin(cur_phase)
	
	local bullet = CreateProjectile('reddot', x, y)
	bullet.sprite.set('firebullet0')
	bullet.SetVar('x_origin', x)
	bullet.SetVar('y_origin', y)
	bullet.SetVar('start_time', Time.time)
	
	if emitter_direction == 0 then
		bullet.SetVar('start_left', false)
	else
		bullet.SetVar('start_left', true)
	end
	
	emitter_cur_in_direction = emitter_cur_in_direction + 1
	
	if emitter_cur_in_direction == 3 or (emitter_cur_in_direction == 2 and math.random(1, 4) == 1) then
		emitter_cur_in_direction = 0
		emitter_direction = (emitter_direction + 1) % 2
	end
	
	bullet.SetVar("harmful", true)
	
	table.insert(emitter_bullets, bullet)
	emitter_bullets_count = emitter_bullets_count + 1
		
end

--emitter_bullet_yvel = 105 -- pixels per second traveled by emitter bullets
--emitter_bullet_period = 100 -- time for bullets to do a complete wave in frames

emitter_bullet_period_pi = math.pi * 60 / emitter_bullet_period

amp_random_offset = math.random() * math.pi * 2 -- to make the wave a little more random, the initial amp multiplier phase is random!

function emitter_bullet_update(bullet)
	local start_left = bullet.GetVar('start_left')
	local time_difference = Time.time - bullet.GetVar('start_time')
	local x = bullet.GetVar('x_origin')
	local y = bullet.GetVar('y_origin')
	local multiplier = tern(start_left, -1, 1)
	local current_amp_multiplier = emitter_bullet_amplitude * math.sin(Time.time - real_starttime * 1.1 + time_difference / 30)
	
	--x = x + multiplier * emitter_bullet_amplitude / 2

	y = y - emitter_bullet_yvel * time_difference
	x = x + multiplier * current_amp_multiplier * math.sin(time_difference * emitter_bullet_period_pi)
	
	bullet.MoveTo(x, y)
	
end

function emitter_bullets_update()
	for i=1,emitter_bullets_count do
		emitter_bullet_update(emitter_bullets[i])
	end
end

function Update()
	if Time.time - starttime >= time_to_next_warning / 60 then
		if warnings_done_so_far < total_warnings then
			create_warning()
			starttime = Time.time
			time_to_next_warning = warning_duration + 30
			warnings_done_so_far = warnings_done_so_far + 1
		else
			EndWave()
		end
	end
	
	if Time.time - emitter_last_fire >= emitter_period / 60 then
		add_emitter_bullet()
		emitter_last_fire = Time.time
	end
	
	update_warning()
	stream_bullets_update()
	emitter_bullets_update()
end

function OnHit(bullet)
	local bullet_is_harmful = bullet.GetVar("harmful")
	if not bullet_is_harmful then
		return
	end
		Player.Hurt(GetGlobal("atk"),0.1)
end