gametimer = 0
enemynum = GetGlobal("enemynum")
Encounter["attacking"] = true
timer = Encounter["wavetimer"]
Encounter["wavetimer"] = math.huge
Arena.ResizeImmediate(565,130)
Player.SetControlOverride(true)
target = CreateProjectile("shoes/target",0,0)
damagenumbers = {}
bars = {}
dyingbars = {}
sprite = Encounter["enemies"][enemynum]["sprite"]
local bar = CreateProjectile("shoes/choice_0",-Arena.width/2 - 10,0) ; table.insert(bars,bar)
local bar2 = CreateProjectile("shoes/choice_1",-Arena.width/2 - math.random(95,105),0) ; table.insert(bars,bar2)
local bar3 = CreateProjectile("shoes/choice_0",-Arena.width/2 - math.random(160,170),0) ; table.insert(bars,bar3)
errors = 0
deadcenter = 0
speed = 5.5
animationstarted = 0

if Encounter["enemies"][enemynum]["maxhp"] == nil then
	Encounter["enemies"][enemynum]["maxhp"] = Encounter["enemies"][enemynum]["hp"]
end

damage = 0

sprite_x = Encounter["enemypositions"][enemynum][1]
sprite_y = Encounter["enemypositions"][enemynum][2] + 186

function Update()
	gametimer = gametimer + 1
	local pressed = false
	count = 0
	for k,v in pairs(bars) do
		if v.isactive then ; count = count + 1
			if Input.Confirm == 1 and pressed == false and v.x >= -Arena.width/2 - 10 and errors < 2 then
				pressed = true
				v.sprite.Set("shoes/choice_0")
				v.SetVar("pressed",true)
				v.sprite.alpha = 1
				if v.x > -100 and v.x < 40 then
					damage = damage + ((100 - math.abs(v.x))/6) + math.random(1,3)
				end
				if v.x <= -100 or v.x >= 40 then
					errors = errors + 1
					v.sprite.Set("shoes/white")
					v.sprite.color = {1.0,0.0,0.0}
					v.SetVar("scale",true)
				elseif (v.x > -100 and v.x < -5) or (v.x > 5 and v.x < 40) then
					v.sprite.Set("shoes/white")
					v.SetVar("scale",true)
					Audio.PlaySound("shoe_"..math.random(1,2))
					v.sprite.color = {0.0,162/255,232/255}
				elseif v.x >= -5 and v.x <= 5 then
					v.sprite.Set("shoes/white")
					v.SetVar("scale",true)
					deadcenter = deadcenter + 1
					Audio.PlaySound("shoe_"..math.random(1,2))
					v.sprite.color = {1.0,154/255,34/255}
				end
				table.remove(bars,k)
				table.insert(dyingbars,v)
			elseif errors == 2 and count == 1 then
				cleanup()
			end
			if not v.GetVar("pressed") then
				v.Move(speed*Time.mult,0)
				if v.x >= 40 and v.sprite.alpha > 0.2 then
					v.sprite.alpha = v.sprite.alpha - 0.075
				elseif v.sprite.alpha <= 0.2 then
					v.SetVar("move",speed)
					table.remove(bars,k)
					table.insert(dyingbars, v)
				end
			end
			if not v.GetVar("pressed") and gametimer%5 == 0 then
				if k%2 ~= 0 then
					v.sprite.Set("shoes/choice_"..gametimer%2)
				else
					v.sprite.Set("shoes/choice_"..(gametimer+5)%2)
				end
			end
		end
	end
	for k,v in pairs(dyingbars) do
		if v.isactive then
			count = count + 1
			if v.sprite.alpha > 0 then
				v.sprite.alpha = v.sprite.alpha - 0.05
			elseif v.sprite.alpha == 0 then
				v.Remove()
			end
			if v.GetVar("move") ~= nil then ; v.Move(speed*Time.mult,0) ; end
			if v.GetVar("scale") then
				v.sprite.Scale(1 + (1 - v.sprite.alpha), 1 + (1 - v.sprite.alpha))
			end
		end
	end
	if count == 0 and not animatingkick and damage > 0 then
		damage = math.ceil(damage + ((15 + (2*Player.lv)) - Encounter["enemies"][enemynum]["def"]))
		if Encounter["enemies"][enemynum]["hp"] - damage < 0 then
			damage = Encounter["enemies"][enemynum]["hp"]
		end
		Encounter["enemies"][enemynum].Call("handleattack",damage)
		maxhealth = Encounter["enemies"][enemynum]["maxhp"]
		health = Encounter["enemies"][enemynum]["hp"]
		newhealth = Encounter["enemies"][enemynum]["hp"] - damage
		animatingkick = true
		animationstarted = gametimer
		Encounter["enemies"][enemynum].Call("SetSprite","blank")
		enemysprite = CreateProjectile(sprite,sprite_x,sprite_y)
		foot = CreateProjectile("shoes/foot (1)",math.random(sprite_x-5,sprite_x+5),sprite_y+20)
		local hp_y = sprite_y-75
		hp_back = CreateProjectile("damage/hp_back",sprite_x,hp_y)
		hp_front = CreateProjectile("damage/hp_back",sprite_x,hp_y)
		hp_front.sprite.Set("damage/hp_front")
		hp_front.sprite.SetPivot(0,0.5)
		hp_front.sprite.SetParent(hp_back.sprite)
		hp_front.sprite.SetAnchor(0,0.5)
		hp_front.sprite.xscale = (newhealth + (damage*60)/maxhealth)/maxhealth
		Audio.PlaySound("shoe_final")
		if deadcenter >= 2 then
			Audio.PlaySound("shoe_dazzle")
			foot.sprite.color = {1.0,(248/255),(112/255)}
		end
		local string2 = tostring(math.ceil(damage))
		local var = -15 ; var = var + (15 * #string2)
		for i=1,#string2 do
			local num = CreateProjectile("damage/"..string.sub(string2,i,i),(sprite_x + (i-1)*32) - var,sprite_y)
			num.sprite.color = {1.0,0.0,0.0}
			table.insert(damagenumbers,num)
		end
		
	elseif count == 0 and animatingkick and damage > 0 then
		if (gametimer - animationstarted)%5 == 0 and (gametimer - animationstarted) < 59 then
			enemysprite.MoveTo((math.sin(gametimer)*(60-(gametimer-animationstarted))/2)+sprite_x,sprite_y)
			local time = (gametimer-animationstarted)
			hp_front.sprite.xscale = (newhealth + (damage*(60-time))/maxhealth)/maxhealth
		elseif (gametimer - animationstarted) == 59 then
			enemysprite.MoveTo(sprite_x,sprite_y)
		elseif (gametimer - animationstarted) == 60 then
			cleanup()	
		end
		if (gametimer - animationstarted) == 10 then
			foot.sprite.Set("shoes/foot (2)")
		elseif (gametimer - animationstarted) == 12 then
			foot.sprite.Set("shoes/foot (3)")
		elseif (gametimer - animationstarted) == 15 then
			foot.sprite.Set("shoes/foot (4)")
		elseif (gametimer - animationstarted) == 17 then
			foot.sprite.Set("shoes/foot (5)")
		elseif (gametimer - animationstarted) == 20 then
			foot.sprite.Set("shoes/foot (6)")
		elseif (gametimer - animationstarted) == 22 then
			foot.Remove()
		end
		if (gametimer-animationstarted) < 60 then
			for k,v in pairs(damagenumbers) do
				if v.isactive then
					v.MoveTo(v.x,(sprite_y-50) + math.sin((gametimer-animationstarted)/20)*40)
				end
			end
		end
	elseif count == 0 and damage == 0 then
		cleanup()
	end
end
function OnHit(bullet)
end
function cleanup()
	for k,v in pairs(bars) do ; if v.isactive then ; v.Remove() ; end ; end
	for k,v in pairs(dyingbars) do ; if v.isactive then ; v.Remove() ; end ; end
	target.Remove()
	Encounter["enemies"][enemynum].Call("SetSprite",sprite)
	if enemysprite ~= nil then ; enemysprite.Remove() ; end
	if damage == 0 then
		Encounter["damage_indicators"][#Encounter["damage_indicators"]+1] = CreateProjectile("damage/miss",sprite_x,sprite_y+100)
	elseif damage > 0 and Encounter["enemies"][enemynum]["hp"] > 0 then
		Encounter["damage_indicators"] = {hp_back,hp_front}
	end
	if newhealth ~= nil then
		Encounter["enemies"][enemynum]["hp"] = newhealth
		if newhealth <= 0 then
			Encounter["damage_indicators"] = {}
			hp_back.Remove() ; hp_front.Remove()
			for k,v in pairs(damagenumbers) do
				if v.isactive then ; v.Remove() ; end
			end
			Encounter["enemies"][enemynum].Call("Kill")
		end
		for k,v in pairs(damagenumbers) do
			if v.isactive then ; Encounter["damage_indicators"][#Encounter["damage_indicators"]+k] = v ; end
		end
	end
	Encounter["wavetimer"] = timer
	State("ENEMYDIALOGUE")
end