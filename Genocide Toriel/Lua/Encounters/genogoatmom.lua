-- A basic encounter script skeleton you can copy and modify for your own creations.

music = "Heartache Remix" --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
encountertext = "Toriel blocks the way!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"blank"}
wavetimer = 1
arenasize = {155, 130}

enemies = {
"toriel",
"zephoneguy"
}

enemypositions = {
{0, 10},
{190,0}
}
SetGlobal("hurtframes",0)
SetGlobal("attackNum",0)
SetGlobal("atk", 3)

screenAnims = {}
whiteFadeBullets = {}
oneFrameBullets = {}

playedLastSound = false

SetGlobal("attackNum",0)
SetGlobal("DEAD",0)
SetGlobal("hit1",false)
SetGlobal("hurtTime",-10)
SetGlobal("cheatingpieceofshit", false)


NONE = 0
FIGHT = 1
ACT = 2
ITEM = 3
MERCY = 4
DEFENSE = 5
INNERACT = 6

cursorLoc = FIGHT
curMenu = DEFENSE
itemNum = 1

idleAnim = false
momisded = false
wee = false

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"hand2", "test", "handtop", "handbottom", "bulletrain", "rain", "circle"}
--possible_attacks = {"circle"}

function EncounterStarting()
    require "Animations/toriel_anim"
    -- If you want to change the game state immediately, this is the place.
    State("ENEMYDIALOGUE")
    Player.lv = 4
    Player.hp = 92
    Player.name = "Chara"
    enemies[2].Call("SetActive", false)
end

rollingHP = -1

local blackbullet

time = 0

function Update()		
                     if enemies[1].GetVar("hp") <= 0 and wee == false then
                         momisded = true
                         SetGlobal("ded", true)
                         wee = true
                     end
                     if momisded == true then
                         Audio.Stop()
                         HideToriel()
                         enemies[1].Call("SetSprite","a_torielded0")
                         SetGlobal("hurtframes", 100)
                     end
	--Remove bullets to be displayed only one frame (well, one update)
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	--Eat shit
	if (rollingHP > -1) then
		rollingHP = rollingHP + 1
		if (rollingHP % 2 == 0) then Player.hp = Player.hp - 1 end
	end
	
	if (curMenu == NONE) then
		if (Input.Confirm == 1) then
			curMenu = cursorLoc
			itemNum = 1
			if (curMenu == ITEM) then
				local bullet = CreateProjectileAbs("item1", 320, 240)
				bullet.SetVar('tile',1)
				table.insert(oneFrameBullets, bullet)
			end
		elseif (Input.Left == 1) then 
			cursorLoc = cursorLoc - 1
			if (cursorLoc == 0) then cursorLoc = MERCY end
		elseif (Input.Right == 1) then
			cursorLoc = cursorLoc + 1
			if (cursorLoc == 5) then cursorLoc = FIGHT end
		end
	elseif (curMenu == ITEM) then
		if (Input.Cancel == 1) then
			curMenu = NONE
		elseif (Input.Confirm == 1) then
			curMenu = DEFENSE
		--There's probably a better way to do this but I don't care!!
		elseif (Input.Left == 1) then
			if (itemNum == 1) then itemNum = 6
			elseif (itemNum == 2) then itemNum = 1
			elseif (itemNum == 4) then itemNum = 3
			elseif (itemNum == 5) then itemNum = 2
			elseif (itemNum == 6) then itemNum = 5
			elseif (itemNum == 7) then itemNum = 4
			end
		elseif (Input.Right == 1) then
			if (itemNum == 1) then itemNum = 2
			elseif (itemNum == 2) then itemNum = 5
			elseif (itemNum == 3) then itemNum = 4
			elseif (itemNum == 4) then itemNum = 7
			elseif (itemNum == 5) then itemNum = 6
			elseif (itemNum == 6) then itemNum = 1
			end
		elseif (Input.Up == 1) then
			if (itemNum == 1) then itemNum = 3
			elseif (itemNum == 2) then itemNum = 4
			elseif (itemNum == 3) then itemNum = 1
			elseif (itemNum == 4) then itemNum = 2
			elseif (itemNum == 5) then itemNum = 7
			elseif (itemNum == 7) then itemNum = 5
			end
		elseif (Input.Down == 1) then
			if (itemNum == 1) then itemNum = 3
			elseif (itemNum == 2) then itemNum = 4
			elseif (itemNum == 3) then itemNum = 1
			elseif (itemNum == 4) then itemNum = 2
			elseif (itemNum == 5) then itemNum = 7
			elseif (itemNum == 7) then itemNum = 5
			end
		end
		
		--Draw the item bullet overlays now. Menu 1
		if (itemNum <= 4) then
			local bullet = CreateProjectileAbs("item1", 320, 240)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
		--Menu 2
		else
			local bullet = CreateProjectileAbs("item2", 320, 240)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)	
		end
	elseif (curMenu == ACT) then
		if (Input.Cancel == 1) then
			curMenu = NONE
		elseif (Input.Confirm == 1) then
			curMenu = INNERACT
		end
	elseif (curMenu == INNERACT) then
		if (Input.Cancel == 1) then
			curMenu = ACT
		elseif (Input.Confirm == 1) then
			curMenu = DEFENSE
		end
	elseif (curMenu ~= DEFENSE) then
		if (Input.Cancel == 1) then
			curMenu = NONE
		elseif (Input.Confirm == 1) then
			curMenu = DEFENSE
		end
	end
	
	for i=#screenAnims,1,-1 do
		-- I want the animations to play at 30 FPS.
		local curFrame = math.floor((Time.time - screenAnims[i].time) / (1/30))
		if (curFrame <= screenAnims[i].frames) then
			local bullet = CreateProjectileAbs(screenAnims[i].type .. curFrame, screenAnims[i].x,screenAnims[i].y)
			bullet.SetVar('tile',1)
			table.insert(oneFrameBullets, bullet)
		else
			table.remove(screenAnims,i)
		end
	end
                     Animate()
	if GetGlobal("hurtframes") ~= nil then
		if GetGlobal("hurtframes") > 0 then
			SetGlobal("hurtframes", GetGlobal("hurtframes") - 1)
		end
	end	
	if (GetGlobal("ACTED") == true) then
                               cursorLoc = ACT
                               SetGlobal("ACTED", false)
	elseif (GetGlobal("FIGHTED") == true) then
                               cursorLoc = FIGHT
                               SetGlobal("FIGHTED", false)
                     end

	if (GetGlobal("esf") ~= nil) then
		if (Time.time - GetGlobal("esf") > 0.2) then
			SetGlobal("esf",nil)
			BattleDialog({"[noskip]Toriel charged an incredible\rmagic attack.\n" .. math.random(32,99) .. " [func:die]HP of mortal damage to Chara![w:9999]"})

		end
	end
end
chat = 0
function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
    curMenu = DEFENSE
    if (GetGlobal("DEAD") == 1) then
         enemies[1].SetVar('currentdialogue', { "[voice:toriel][effect:none][noskip]My Naive Child...", "[voice:toriel][effect:none][noskip]You think you can\njust murder everyone\nand leave?", "[voice:toriel][effect:none][noskip]I'm sorry but no.[func:ESF]"})
         nextwaves = {"blank"}
         wavetimer = 1
    elseif (GetGlobal("DEAD") == 2 and chat == 0) then
         enemies[1].SetVar('currentdialogue', { "[voice:toriel1][waitall:3][effect:none][noskip]What?\nHow?\nNo!", "[voice:toriel1][waitall:3][effect:none][noskip]This can't\nhappen!", "[voice:toriel1][waitall:3][effect:none][noskip]I can't let\nyou...\nGet past...", "[voice:toriel1][waitall:3][effect:none][noskip]I guess the\nHistory books\nwere true...", "[voice:toriel1][func:SetSprite,a_torielded1][waitall:3][effect:none][noskip]We are no\nmatch to a\nhuman like you.", "[voice:toriel1][waitall:3][effect:none][noskip]I have to\nring him...", "[voice:toriel1][waitall:3][effect:none][noskip][color:ff0000]ASGORE[color:000000]...", "[voice:toriel1][waitall:3][effect:none][noskip]I thought I'd\nnever need to\nuse this again.[w:10][func:Phone][w:5]", "[func:SetSprite,a_torielded2][func:State,ENEMYDIALOGUE] "})
         --enemies[1].SetVar('currentdialogue', { "hi", "[func:State,ENEMYDIALOGUE]" })
         chat = 1
         momisded = false
    elseif (GetGlobal("DEAD") == 2 and chat == 1) then
         enemies[2].Call("SetActive", true)
         enemies[2].SetVar('currentdialogue', { "[noskip][func:SetSprite,Cell][effect:shake, 1.0][color:ffffff][w:5]Hello. Who is it?[w:60].", "[func:State,ENEMYDIALOGUE]"})
         chat = 2
    elseif (GetGlobal("DEAD") == 2 and chat == 2) then
         enemies[1].SetVar('currentdialogue', { "[voice:toriel1][waitall:3][effect:shake, 1.0][noskip]A S G . . . O . . R . .", "[voice:toriel1][waitall:3][effect:shake, 1.0][noskip]T h . . e . . . .\nH . . u m a . . n .", "[func:Kill][func:State,ENEMYDIALOGUE]" })
         chat = 3
    elseif (GetGlobal("DEAD") == 2 and chat == 3) then
         HideBG()
         enemies[2].SetVar('currentdialogue', { "[waitall:3][effect:shake, 1.0][func:Phone][noskip][color:ffffff]Tori? TORI?\nIs that you?!?" })
         chat = 4
    elseif (GetGlobal("DEAD") == 2 and chat == 4) then
         enemies[2].SetVar('currentdialogue', { "[waitall:3][effect:shake, 1.0][func:Phone][noskip][color:ffffff]TORI?!?" })
    end
end


function Phone()
       Audio.PlaySound("phone")
end

function HideBGs()
    HideBG()
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
   if (GetGlobal("DEAD") == 1) then
       nextwaves = {"blank"}
   elseif (GetGlobal("DEAD") == 2) then
       nextwaves = {"blank"}
   else
       nextwaves = { possible_attacks[math.random(#possible_attacks)] }
   end
end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
    curMenu = NONE
end

function HandleSpare()
  cursorLoc = MERCY
end

itemsUsed = { false, false, false, false, false, false, 0 }

function HandleItem(ItemID)
                     cursorLoc = ITEM
	if (ItemID == "DOGTEST1") then
	                     BattleDialog({"You threw the Stick.", "...", "But nobody came to pick\rit up except me."})
	elseif (ItemID == "DOGTEST2") then
		if (itemsUsed[2] == false) then
			local message = "You ate the Monster Candy.\nVery un-licorice-like.\n"
			itemsUsed[2] = true
			message = message .. HealItem(10)
			BattleDialog({ message })
		else
			BattleDialog({"You licked the wrapper.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST3") then
		if (itemsUsed[3] == false) then
			local message = "You ate the Monster Candy.\nVery un-licorice-like.\n"
			itemsUsed[3] = true
			message = message .. HealItem(10)
			BattleDialog({ message })
		else
			BattleDialog({"You licked the wrapper.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST4") then
		if (itemsUsed[4] == false) then
			local message = "You ate the Monster Candy.\nVery un-licorice-like.\n"
			itemsUsed[4] = true
			message = message .. HealItem(10)
			BattleDialog({ message })
		else
			BattleDialog({"You licked the wrapper.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST5") then
		if (itemsUsed[5] == false) then
			local message = "Don't worry, spider didn't.\n"
			itemsUsed[5] = true
			message = message .. HealItem(12)
			BattleDialog({ message })
		else
			BattleDialog({"You licked the wrapper.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST6") then
		if (itemsUsed[6] == false) then
			local message = "You drank the Spider Cider.\n"
			itemsUsed[6] = true
			message = message .. HealItem(24)
			BattleDialog({ message })
		else
			BattleDialog({"You tried to find one last\rdrop in the jug. You couldn't.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST7") then
		if (itemsUsed[7] == 0) then
			BattleDialog({"You ate the Butterscotch Pie.\nYour HP was maxed out."})
			itemsUsed[7] = 1
			Audio.PlaySound("nom")
			Player.hp = Player.hp + 99
		elseif (itemsUsed[7] == 1) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"You fondly remembered that\rtime you ate Butterscotch Pie.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 2) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"You again remembered that\rtime you ate Butterscotch Pie.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 3) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"You started to recall\revery pie you've ever eaten.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 4) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"You grimaced at the memory\rof that time you had rhubarb.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 5) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"You calculated the\rcircumference of the plate\ryour Butterscotch Pie was on.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 6) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"You drew up a pie chart\rof the flavors of pie you've\reaten. Apple's at 67%.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 7) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"OK, I get it, you really\rwish you had a second pie\rin your inventory.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 8) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"Are we seriously\rdoing this again?", "You should seriously stop\rthis. Right now. OK?\rYou won't like what happens.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[7] == 9) then
			itemsUsed[7] = itemsUsed[7] + 1
			BattleDialog({"[starcolor:ff0000][color:ff0000]This is your last warning.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		else
			itemsUsed[7] = 11
			Audio.PlaySound("mystery")
			Audio.PlaySound("nom")
			Player.hp = Player.hp + 99
			BattleDialog({"A slice of pie magically\rappears in your hand. You eat it.\rYour HP was maxed out."})
                                                                SetGlobal("cheatingpieceofshit", true)
			--Spoopy
		end
                      end
end

function HealItem(val)
	Audio.PlaySound("nom")
	Player.hp = Player.hp + val
	if (Player.hp == 32) then return "Your HP was maxed out."
	else return "You recovered " .. val .. " HP!" end
end

function OnHit(bullet)
   if bullet.GetVar('tile') == 1 then
   
   end
end

function SetNone()
	curMenu = NONE
end

function die()
  rollingHP = 0
end