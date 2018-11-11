local self = {}
currentstate = "NONE"
damage_indicators = {}
damage_number_counter = 40
decrease_counter = false
function self.Update()
	if decrease_counter == true and damage_number_counter > 0 then
		damage_number_counter = damage_number_counter - 1
	elseif damage_number_counter == 0 then
		decrease_counter = false
		for k,v in pairs(damage_indicators) do
			if v.isactive then ; v.Remove() ; end
		end
	end
end

function self.EnterState(newstate,oldstate)
	if newstate == "ATTACKING" then
		SetGlobal("enemynum",((190 - Player.absy)/30) + self.GetEnemyOffset())
		nextwaves = { "shoes" }
		State("DEFENDING")
	elseif oldstate == "DEFENDING" and attacking then
		attacking = nil
		damage_number_counter = 40
		decrease_counter = true
		local found = false
		for i=1,#enemies do
			if enemies[i]["hp"] ~= nil and enemies[i]["hp"] > 0 then
				found = true
				break
			end
		end
		if not found then
			Player.sprite.alpha = 0
		end
	end
end

function self.GetEnemyOffset()
	local num = 1
	for i=1,#enemies do
		if enemies[i]["hp"] ~= nil and enemies[i]["hp"] <= 0 then
			num = num + 1
		end
	end
	return num
end

return self