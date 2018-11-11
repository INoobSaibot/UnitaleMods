alt = 2 --Determines what page it is on. The code uses "alt%2", so this would return "0". If it was an odd number, it'd return "1".
commands = {"Cake","Bisicle","Bisicle","Steak"}
commands2 = {"C. Bun","C. Bun","A. Food","A. Food"}
-- This is VERY important:
-- You can ONLY have 4 items per page!
-- "commands" handles the CURRENT page. "commands2" handles the page that is off-screen.
-- If you have more than 4 on EITHER ONE, things could get glitchy! Watch out.
-- If you want to have less than 8, subtract from "commands2" first!
-- Otherwise my code will do it automatically.
sprite = "blank" --doesn't have to be THIS sprite, just a blank one.
name = "null" --doesn't matter anyway, you will never see it.
hp = 1 --once again, doesn't matter.
def = math.huge --still doesn't matter.
SetActive(false) -- but THIS does.
function HandleCustomCommand(command)
	if command == "MYSTERY KEY" then -- Not all items have to be food!
		BattleDialog({"You used the Mystery Key.[w:10]\nNothing happened."})
	elseif command == "BUTTSPIE" or command == "CAKE" then --These are essentially just ACT commands.
		BattleDialog({"You ate the Butterscotch Cake.[w:10]\n"..HealAndReturnString(99,"gulp+heal")}) --"HealAndReturnString": explained below, in its section.
		RemoveCommandByName(command) --Also explained in its section.
	elseif command == "BISICLE" then
		BattleDialog({"You ate one half of the Bisicle.[w:10]\n"..HealAndReturnString(11,"gulp+heal")}) --The bisicle is an example of swapping items.
		SwapCommandByNames("BISICLE","Unisicle"	)
	elseif command == "UNISICLE" or command == "POPSICLE" then
		BattleDialog({"You ate the Unisicle.[w:10]\n"..HealAndReturnString(11,"gulp+heal")})
		RemoveCommandByName(command)
	elseif command == "CINNAMON" or command == "C. BUN" then
		BattleDialog({"You ate the Cinnamon Bunny.[w:10]\n"..HealAndReturnString(22,"gulp+heal")})
		RemoveCommandByName(command)
	elseif command == "A. FOOD" then
		BattleDialog({"You ate the Astronaute Food.[w:10]\n"..HealAndReturnString(21,"gulp+heal")})
		RemoveCommandByName(command)
	elseif command == "BOUGH" then
		BattleDialog({"You ate the Tree Bough.[w:10]\n"..HealAndReturnString(45,"gulp+heal")})
		RemoveCommandByName(command)
	elseif command == "STEAK" then
		BattleDialog({"You ate the Grilled Steak.[w:10]\n"..HealAndReturnString(24,"gulp+heal")})
		RemoveCommandByName(command)
	elseif command == "CRABAPPLE" then
		BattleDialog({"You ate the Crab Apple.[w:10]\n"..HealAndReturnString(18,"gulp+heal")})
		RemoveCommandByName(command)
	elseif command == "HOT CAT" then
		BattleDialog({"You ate the Hot Cat.[w:10]\n"..HealAndReturnString(21,"gulp+heal")})
		RemoveCommandByName(command)
		Audio.PlaySound("meow") -- You can play sounds, too!
	end
end
function HealAndReturnString(num,sound)
	local string = nil -- This code here determines whether or not to say "Your hp was maxed out" or "You recovered <num> hp".
	if Player.hp + num >= GetMaxHP() then
		string = "Your HP was maxed out!"
	else
		string = "You recovered "..num.." HP!"
	end
	Player.hp = Player.hp + num --If we just use "Player.heal(num)", it plays a singular healing sound.
	Audio.PlaySound(sound) --This allows for custom sounds, for things like the Sea Tea and Legendary Hero that have pre-merged healing sounds.
	return string
end
function GetMaxHP() --Does just what it says on the tin.
	if Player.lv < 20 then
		return 16 + (4 * Player.lv)
	elseif Player.lv == 20 then
		return 99
	end
end
function RemoveCommandByName(command) -- Also does just what it says on the tin.
	for k,v in pairs(commands) do
		if string.upper(v) == string.upper(command) then
			table.remove(commands,k)
		end
	end
end
function SwapCommandByNames(command,command2)
	local found = false -- essentially, it finds the first instance of "command"...
	for k,v in pairs(commands) do
		if string.upper(v) == command and found == false then
			found = true
			commands[k] = command2 -- and replaces it with "command2".
		end
	end
end
function SwapTables() --Once again, the title explains it. Swaps "commands" with "commands2".
	local storage = commands2
	commands2 = commands
	commands = storage
	alt = alt + 1
end