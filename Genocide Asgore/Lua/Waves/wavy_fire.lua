bullets = {}
num_bullets = 0

current_turn = GetGlobal('current_turn')
difficulty = 3


wave_frames_elapsed = 0

--DEBUG MODE DIFFICULTY--
difficulty=3

Arena.Resize(220, 180)

-- set properties
-- a set refers to one left/right combo of fire streams
-- init_y - the initial y position of a wave
-- init_x - the center x position of a wave
-- amplitude - how wide the wave goes
-- period - how long the wave takes to complete a cycle in frames
-- crossover - 0 means the waves meet dead center, greater means they cross over eachother, less means they don't quite meet
-- shift_velocity - 0 means the vertices don't shift. greater means they will travel upwards, less means they will travel down
-- right_offset - positive means right wave begins slightly lower, negative means it begins slightly higher.

emitters = {}

-- x is the number of the wave (0-3 are bottom waves, 4-7 are top)
-- difficulty is obtained from the turn
function add_wave(x)
	local emitter_l = {}
	local emitter_r = {}
	
	emitter_l.amplitude = -16
	emitter_r.amplitude = 16
	is_top_wave = false
		
	if x < 4 then
		emitter_l.init_y = 220 + math.random(0, 40)
		emitter_r.init_y = emitter_l.init_y
	else
		x = x - 4
		is_top_wave = true
		emitter_l.init_y = 520 + math.random(0, 60)
		emitter_r.init_y = emitter_l.init_y
	end
	
	emitter_l.init_x = -100 + x * 64
	emitter_r.init_x = -100 + x * 64
	
	if difficulty == 1 then
		emitter_l.period = 50
		emitter_r.period = emitter_l.period
		emitter_l.y_velocity = -2.85
		emitter_r.y_velocity = emitter_l.y_velocity
		emitter_l.period_pushback = 0
	elseif difficulty == 2 then
		emitter_r.init_x = emitter_r.init_x - math.random() * 4
		emitter_r.init_y = emitter_r.init_y + math.random() * 2
		emitter_r.amplitude = emitter_r.amplitude + (emitter_l.init_x - emitter_r.init_x)
		emitter_l.amplitude = emitter_r.amplitude * -1
		emitter_l.period = 45 + math.random() * 15
		emitter_r.period = emitter_l.period
		emitter_l.y_velocity = -2.55 + math.random() * 0.7
		emitter_r.y_velocity = emitter_l.y_velocity
		emitter_l.period_pushback = math.random() * math.pi / 480
	elseif difficulty == 3 then
		emitter_r.init_x = emitter_r.init_x - math.random() * 8
		emitter_r.init_y = emitter_r.init_y + math.random() * 3
		emitter_r.amplitude = emitter_r.amplitude + (emitter_l.init_x - emitter_r.init_x)
		emitter_l.amplitude = emitter_r.amplitude * -1
		emitter_l.period = 40 + math.random() * 20
		emitter_r.period = emitter_l.period
		emitter_l.y_velocity = -2.45 + math.random() * 0.8
		emitter_r.y_velocity = emitter_l.y_velocity
		emitter_l.period_pushback = math.random() * math.pi / 240

	end
	
	if is_top_wave then
		emitter_l.y_velocity = emitters[x * 2 + 1].y_velocity
		emitter_r.y_velocity = emitter_l.y_velocity
		emitter_l.period_pushback = emitters[x* 2 + 1].period_pushback
	end

	emitter_r.period_pushback = emitter_l.period_pushback
	emitter_l.last_bullet = nil
	emitter_r.last_bullet = nil
	
	table.insert(emitters, emitter_l)
	table.insert(emitters, emitter_r)
end

function spawn_bullet(emitter)
	local bullet = CreateProjectile("reddot", emitter.init_x, emitter.init_y)
	bullet.sprite.Set('firebullet0')
	bullet.SetVar('period', emitter.period)
	bullet.SetVar("startingx", bullet.x)
	bullet.SetVar("vely", emitter.y_velocity)
	bullet.SetVar("frames_elapsed", 0)
	bullet.SetVar("amplitude", emitter.amplitude)
	
	bullet.SetVar("period_pushback", emitter.period_pushback)
	
	table.insert(bullets, bullet)
	num_bullets = num_bullets + 1
	emitter.last_bullet = bullet
end

function update_bullet(bullet)
	local amplitude = bullet.GetVar("amplitude")
	local frames_elapsed = bullet.GetVar("frames_elapsed") + 1
	bullet.SetVar("frames_elapsed", frames_elapsed)
	local new_y = bullet.y + bullet.GetVar("vely")
	local new_x = bullet.GetVar("startingx") + amplitude + amplitude * math.cos((bullet.GetVar("frames_elapsed") / bullet.GetVar("period") + bullet.GetVar("period_pushback") * wave_frames_elapsed) * math.pi * 2)
	
	if wave_frames_elapsed % 8 == 0 then
		bullet.sprite.Set('firebullet0')
	elseif wave_frames_elapsed % 8 == 4 then
		bullet.sprite.Set('firebullet1')
	end
	
	bullet.MoveTo(new_x, new_y)
end

function check_over()
	for i = 9,16 do
		local emitter = emitters[i]
		if emitter.last_bullet == nil then
			return
		end
		
		if emitter.last_bullet.absy > 0 then
			return
		end
	end
	
	EndWave()
end

for i=0,7 do
	add_wave(i)
end

bullets_per_emitter = 0
bulletcount = 20
Encounter.SetVar("wavetimer", 20)

function Update()

	if wave_frames_elapsed < 15 then
		wave_frames_elapsed = wave_frames_elapsed + 1
		return
	end
	
	if wave_frames_elapsed % 4 == 0 then
		for i=1,16 do
			if bullets_per_emitter < bulletcount then
				spawn_bullet(emitters[i])
			end
		end
		bullets_per_emitter = bullets_per_emitter + 1
	end
	
	wave_frames_elapsed = wave_frames_elapsed + 1
	
	for i=1, num_bullets do
		local bullet = bullets[i]
		update_bullet(bullet)
	end
	
	check_over()
end

function OnHit(bullet)
		Player.Hurt(GetGlobal("atk"),0.1)
end