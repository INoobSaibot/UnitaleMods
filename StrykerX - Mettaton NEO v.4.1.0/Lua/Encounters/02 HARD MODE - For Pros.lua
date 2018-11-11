-- A basic encounter script skeleton you can copy and modify for your own creations.
 music = "Power of NEO" --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
voicer = require "randomvoice"
voicer.setvoices({"v_mtt1", "v_mtt2", "v_mtt3", "v_mtt4", "v_mtt5", "v_mtt6", "v_mtt7", "v_mtt8", "v_mtt9"})

encountertext = "Mettaton NEO blocks the way!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"blank"}
randomwave = 0
wavetimer = 0.1
arenasize = {500, 175}

screenAnims = {}
whiteFadeBullets = {}
oneFrameBullets = {}
transformationTimer = 0
transformed = false
SetGlobal("transforming",false)
playedLastSound = false


------Global Variables----------------
SetGlobal("attackNum",11)
SetGlobal("justTaunted",true)
SetGlobal("DEAD",0)
SetGlobal("hurtTime",-10)
SetGlobal("hits1",false)
SetGlobal("fakedie1",false)
SetGlobal("reallyded",false)
SetGlobal("cheatingpieceofshit",false)
--------------------------------------------------

NONE = 0
FIGHT = 1
ACT = 2
ITEM = 3
MERCY = 4
DEFENSE = 5
INNERACT = 6

cursorLoc = FIGHT
curMenu = NONE
itemNum = 1

idleAnim = false

enemies = {
"mettatonneohard"
}

jiggleAlphys = nil
alphysSprite = nil

afterimages = {}
aitimers = {}
spawntimer = 0

enemypositions = {
{0, 0}
}

itemsUsed = { false, 0, false, false, false, false, false }
justUsedNullItem = false

rollingHP = -1

local blackbullet
function Update()	
                    Animate()
	if GetGlobal("hurtframes") ~= nil then
		if GetGlobal("hurtframes") > 60 then
			SetGlobal("hurtframes", GetGlobal("hurtframes") - 1)
		end
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

	if (GetGlobal("esf") ~= nil) then
		if (Time.time - GetGlobal("esf") > 0.2) then
			SetGlobal("esf",nil)
			BattleDialog({"[noskip]Mettaton used[func:PlayIntroPSI]\rPSI Anime B![func:StartPSI][w:85]\n[func:EndPSI]" .. math.random(76,99) .. " HP of mortal damage to Chara![w:9999]"})

		end
	end
	
	if (GetGlobal("fadeout") ~= nil) then
		if (blackbullet.isactive == false) then
			blackbullet = CreateProjectileAbs("screenfade/black",320,240)
			blackbullet.sprite.alpha = 0
			blackbullet.SetVar('tile', 1)
			blackbullet.SendToBottom()
		end
		blackbullet.sprite.alpha = (Time.time - GetGlobal("fadeout"))*5
	end	
	--This is all stuff for the intro that doesn't need to update otherwise
	if (intro == true) then
		--Skip intro with C
		if (Input.Menu > 0) then
			nextwaves = {"blank"}
			introDialoguing = false
			introTime = Time.time
			introPhase = 6
			introPhaseLength = 0.001
			State("DEFENDING")
		end
		if (introDialoguing == false) then
			if (introPhase == 6) then
				--Time to end the intro.
				introPhase = 7
				idleAnim = true
				intro = false
				encountertext = "Alphys NEO blocks the way!"
				State("ACTIONSELECT")
				Audio.Play()
				songIntro = true
				if (whitebullet ~= nil) then whitebullet.Remove() end
				if (blackbullet ~= nil) then blackbullet.Remove() end
			--This is so Alphys pauses between dialogue boxes
			elseif (Time.time - introTime > introPhaseLength) then
				introDialoguing = true
				State("ENEMYDIALOGUE")
			--This is a one-off sprite change midway through a pause
			elseif (Time.time - introTime > (introPhaseLength/2) and introPhase == 4) then
				SetAlphys("alphyssadclosedleft")
			end
		end
		--Black fade-in at the start of the battle
		if (blackbullet.sprite.alpha > 0) then
			blackbullet.sprite.alpha = 3 - (Time.time - introTime)*6
			blackbullet.SendToTop()
			if (blackbullet.sprite.alpha < 0) then blackbullet.Remove() end
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
	
	if (GetGlobal("afterimage") == true) then
		spawntimer = spawntimer + Time.dt
		--Create a new afterimage 30 times a second
		if (spawntimer > 1/30) then
			spawntimer = spawntimer - 1/30
			local newAI = CreateSprite("tldr2/afterimagewhite")
			local cr = 40
			newAI.color = { (96 + math.random()*cr-cr/2) / 255, (64 + math.random()*cr-cr/2) / 255, (224 + math.random()*cr-cr/2) / 255 }
			newAI.x = 325+math.random()*4-2
			newAI.y = 302+math.random()*4-2
			table.insert(afterimages,newAI)
			table.insert(aitimers,Time.time)
		end
	
		--Change color and opacity of existing afterimages
		for i=#afterimages,1,-1 do
			--afterimages[i].color = {math.random(), math.random(), math.random()}
			local timeDiff = Time.time - aitimers[i]
			afterimages[i].alpha = 0.75 - timeDiff * 1.3
			afterimages[i].Scale(0.8 + timeDiff * 0.25, 0.8 + timeDiff * 0.28)
			
			if (afterimages[i].alpha <= 0) then
				afterimages[i].Remove()
				table.remove(afterimages,i)
				table.remove(aitimers,i)
			end
		end
	end	

	if (GetGlobal("ACTED") == true) then
                               cursorLoc = ACT
                               curMenu = ACT
                               SetGlobal("ACTED", false)
	elseif (GetGlobal("FIGHTED") == true) then
                               cursorLoc = FIGHT
                               curMenu = FIGHT
                               SetGlobal("FIGHTED", false)
                     end
	--Audio.Pitch((math.sin(Time.time)*1.5)+1.5)	
end                    

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
randomList = {"custom/attack1", "custom/attack2", "custom/bomb1", "piano1", "custom/corner1", "custom/hard1", "custom/laserbots1", "custom/para1", "custom/para2", "custom/easy1"}
Weaklist = {"weak/weakattack1"}
weakattacks = {"weak/weakattack1", "weak/weakattack2", "weak/weakspaceinvaders1", "weak/weakdrop1"}

 -- If you want to change the game state immediately, this is the place.
function EncounterStarting()
     blackbullet = CreateProjectileAbs("screenfade/black",320,240)
     blackbullet.sprite.alpha = 2
     blackbullet.SetVar('tile', 1)
     blackbullet.SendToTop()
	
     State("DEFENDING")
   -- local randomdialogue = enemies[1].GetVar("randomdialogue") -- retrieve dialogue first, for readability
   -- enemies[1].SetVar("randomdialogue", voicer.randomizetable(randomdialogue)) -- Randomize voices with the library
    require "Animations/mneo_anim"
    Player.lv = 15
    Player.hp = 76
    Player.name = "Chara"
end

function EnemyDialogueStarting()
    curMenu = DEFENSE
    local enemydialogue = enemies[1].GetVar("currentdialogue") -- retrieve dialogue first, for readability
      if enemydialogue ~= nil then -- Note that this can happen when a monster is having its random dialogue!
        enemies[1].SetVar('currentdialogue', voicer.randomizetable(enemydialogue)) -- Randomize voices with the library!
    end
if (GetGlobal("cheatingpieceofshit1") == true) then
    enemies[1].SetVar('currentdialogue', voicer.randomizetable({ "[effect:none][noskip]You cheating piece\nof shit\ngo fuck yourself![func:ESF][next]" }))
    nextwaves = {"blank"}
   wavetimer = 99
end
  if attacknum == 2 then
         if GetGlobal("hit1") == true then
                        enemies[1].SetVar('currentdialogue', voicer.randomizetable({ "[effect:none]Did that hurt,\ndarling?" }))
         else
                        enemies[1].SetVar('currentdialogue', voicer.randomizetable({"[effect:none]I'm guessing you've\nalready seen those\nattacks from\nsomeone you killed[w:15]", "didn't you gorgeous?"}))
         end
   end
end 

attacknum = -1
function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
      -- enemies[1].Call("EnemyDialogueEnding")
    local enemydialogue = enemies[1].GetVar("currentdialogue") -- retrieve dialogue first, for readability
      if enemydialogue ~= nil then -- Note that this can happen when a monster is having its random dialogue!
        enemies[1].SetVar('currentdialogue', voicer.randomizetable(enemydialogue)) -- Randomize voices with the library!
    end
 if (GetGlobal("reallyded") == true) then
     nextwaves = {"custom/ded"}
 elseif (GetGlobal("attacked") == true) then
    attacknum = attacknum + 1
    if attacknum == 0 then
         enemies[1].SetVar('currentdialogue', { "[effect:none]So what do you\nthink of my fully\nrealized defensive\ncapabilities, darling?" })
        nextwaves = {"blank"}
    elseif attacknum == 1 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]I had a hard\ntime believing that\nyou managed to\ndefeat Undyne.", "[effect:none]Perhaps you relied\non more...[:16]\ndubious methods?", "HAHAHA!\n[w:20]Regardless", "It looks like I'm the\nlast hero the\nUnderground has\nleft.", "And we seem to be\nlosing hope.", "So,[w:10] I'm going to\ngive anyone who's\nstill alive a final\ntreat!", "ONE HELL OF A SHOW!" })
        nextwaves = {"attack1"}
    elseif attacknum == 2 then
        nextwaves = {"attack2"}
    elseif attacknum == 3 then
        nextwaves = {"yellow1"}
    enemies[1].SetVar('currentdialogue', { "[effect:none]I won't let\nyou get past me\ndarling!", "If you do\nyou'll just remove\nmy audience", "After all,\nI can't be a\nstar without an\naudience!" })
    elseif attacknum == 4 then
        nextwaves = {"yellow2"}
    elseif attacknum == 5 then
    nextwaves = {"orangetraps"}
    elseif attacknum == 6 then
    nextwaves = {"spaceinvaders"}
    elseif attacknum == 7 then
    nextwaves = {"circlemadness"}
    elseif attacknum == 8 then
    nextwaves = {"piano1"}
    elseif attacknum == 9 then
    SetGlobal("attackNum",10)
    nextwaves = {"timeflow1"}
    enemies[1].SetVar('currentdialogue', { "[effect:none]After all that,\nyou're still alive?", "[effect:none]Guess you've learned\ntoo much from Alphys,\ndarling.", "[effect:none]It's about time\nI move out of\n'Beta Test'", "[effect:none]You ready darling?", "[effect:none][noskip]Because things are\nabout to get\nhot in here![w:13][func:OHYESH][next]" })
    elseif attacknum == 10 then
    nextwaves = {"custom/attack1"}
    elseif attacknum == 11 then
    nextwaves = {"custom/attack2"}
    enemies[1].SetVar('currentdialogue', { "[effect:none]Let's test your\nmemory skills\ngorgeous!"})
    elseif attacknum == 12 then
    SetGlobal("attackNum",1)
       wavetimer = 20
    nextwaves = {"coloredtiles"}
    elseif attacknum == 13 then
    SetGlobal("attackNum",2)
      wavetimer = 20
    nextwaves = {"coloredtiles"}
    elseif attacknum == 14 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]That sparkly\nlook in your\nface...", "[effect:none]It's like you've\nalready seen this\nbefore, darling!"})
    SetGlobal("attackNum",3)
      wavetimer = 20
    nextwaves = {"custom/coloredtiles"}
    elseif attacknum == 15 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]You've crushed\neveryones dream.\nAnd half of mine.", "[effect:none]But you're not\ncrushing my\ndreams completely!"})
    SetGlobal("attackNum",10)
    nextwaves = {"custom/bomb1"}
    elseif attacknum == 16 then
    nextwaves = {"custom/easy1"}
    elseif attacknum == 17 then
    nextwaves = {"custom/spaceinvaders", "Acc/spaceinvade"}
    elseif attacknum == 18 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]I AM THE STAR!"})
    nextwaves = {"custom/circleofdeath"}
    elseif attacknum == 19 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]I AM THE LAST\nHOPE OF THIS\nWORLD!"})
    nextwaves = {"custom/para1"}
    elseif attacknum == 20 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]AND YOU'RE\nRUINING IT!"})
    nextwaves = {"custom/laserbots1"}
    elseif attacknum == 21 then
    nextwaves = {"custom/hard1"}
    elseif attacknum == 22 then
    enemies[1].SetVar('currentdialogue', { "[effect:none][func:Face2]ENOUGH OF THIS!", "[effect:none]WHEN ARE YOU\nGONNA BE SATISFIED\nFROM ALL THIS?!"})
    nextwaves = {"custom/comb/combyellow1"}
    elseif attacknum == 23 then
    nextwaves = {"custom/comb/combtimeflow2"}
    elseif attacknum == 24 then
    nextwaves = {"custom/hardcomb/combyellow1"}  
    elseif attacknum == 25 then
    nextwaves = {"Acc/cmadattack1", "circlemadness"}
    elseif attacknum == 26 then
    nextwaves = {"custom/corner1"}
    elseif attacknum == 27 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]JUST GIVE UP,\nDARLING!"})
    nextwaves = {"custom/para2"}
    elseif attacknum == 28 then
    nextwaves = {"custom/supermett1"}
    elseif attacknum == 29 then
    SetGlobal("attackNum",11)
       local choice = math.random(1,#randomList)
       nextwaves = {randomList[choice]}
       table.remove(randomList,choice)
    elseif attacknum == 30 then
       enemies[1].SetVar('currentdialogue', { "[effect:none]If you don't\ndie now darling...", "[func:Face3]I'll be forced\nto use my\n[color:ff0000]SPECIAL ATTACK!", "Or as I would\nlike to call it\nthe GRAND FINALE!"})
       local choice = math.random(1,#randomList)
       nextwaves = {randomList[choice]}
       table.remove(randomList,choice)
    elseif attacknum == 31 then
       local choice = math.random(1,#randomList)
       nextwaves = {randomList[choice]}
       table.remove(randomList,choice)
    elseif attacknum == 32 then
       local choice = math.random(1,#randomList)
       nextwaves = {randomList[choice]}
       table.remove(randomList,choice)
    elseif attacknum == 33 then
       enemies[1].SetVar('currentdialogue', { "[effect:none]Now's the time to die\ndarling if you don't \nwanna see the\n[color:ff0000]GRAND FINALE!"})
       local choice = math.random(1,#randomList)
       nextwaves = {randomList[choice]}
       table.remove(randomList,choice)
    elseif attacknum == 34 then
    enemies[1].SetVar('currentdialogue', { "[effect:none]It's time for my\n[color:ff0000]SPECIAL ATTACK![w:60]", "FOR HUMANITY!\nFOR MONSTERS!\nFOR MY FAME!", "[color:ff0000]FOR MY FRIENDS\n[w:30]AND BLOOKY!"})
       local choice = math.random(1,#randomList)
       nextwaves = {randomList[choice]}
       table.remove(randomList,choice)
    elseif attacknum == 35 then
    enemies[1].SetVar('currentdialogue', { "[effect:none][noskip][func:Face6]W...[w:30] Wh...[w:30]", "Why?", "[func:Face5] Just die\nalready!", "When are you\ngonna be satisfied\nfrom all this?"})
       nextwaves = {"final"}
    elseif attacknum == 36 then
    enemies[1].SetVar('currentdialogue', { "[effect:none][func:Face2]DIE!"})
       wavetimer = 0.1
       nextwaves = {"blank"}
    elseif attacknum > 37 then
       nextwaves = { weakattacks[math.random(#weakattacks)] }
    end  
end

--enemies[1].SetVar('currentdialogue', { "DIE!"})
--    nextwaves = {"bullet_trig", "weak/weakattack1"}
--    nextwaves = {"bullet_trig", "weak/weakattack1"}
--enemies[1].SetVar('currentdialogue', { "[noskip]W...[w:30] Wh...[w:30]", "Why?", "J.. Just die\nalready!", "When are you\ngonna be satisfied\nfrom all this?"})
--enemies[1].SetVar('currentdialogue', { "It's time for my\n[color:ff0000]SPECIAL ATTACK![w:60]", "FOR HUMANITY!\nFOR MONSTERS!\nFOR MY FAME!", "[color:ff0000]FOR MY FRIENDS\n[w:30]AND ALPHY'S!\nAND BLOOKY!", "Also, your dirty\nhacks won't work\nin my next attack!"})
--enemies[1].SetVar('currentdialogue', { "If you don't\ndie now darling...", "I'll be forced\nto use my\n[color:ff0000]SPECIAL ATTACK!", "Or as I would\nlike to call it\nthe GRAND FINALE!"})

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
    curMenu = NONE
end

function HandleSpare()
cursorLoc = MERCY
curMenu = MERCY
                   BattleDialog({"But the show is still going,\rdarling!"})
end

function HandleItem(ItemID)
cursorLoc = ITEM
	if (ItemID == "DOGTEST1") then
		if (itemsUsed[1] == false) then
			local message = "They're better dry.\n"
			itemsUsed[1] = true
			message = message .. HealItem(90)
			BattleDialog({ message })
		else
			BattleDialog({"You tried to find leftovers\rin the package. You couldn't.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
                        --attacknum = attacknum - 1
		end
	elseif (ItemID == "DOGTEST2") then
		if (itemsUsed[2] == 0) then
			BattleDialog({"You ate the Butterscotch Pie.\nYour HP was maxed out."})
			itemsUsed[2] = 1
			Audio.PlaySound("nom")
			Player.hp = Player.hp + 99
		elseif (itemsUsed[2] == 1) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You fondly remembered that\rtime you ate Butterscotch Pie.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 2) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You again remembered that\rtime you ate Butterscotch Pie.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 3) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You started to recall\revery pie you've ever eaten.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 4) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You grimaced at the memory\rof that time you had rhubarb.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 5) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You calculated the\rcircumference of the plate\ryour Butterscotch Pie was on.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 6) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You drew up a pie chart\rof the flavors of pie you've\reaten. Apple's at 67%.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 7) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"OK, I get it, you really\rwish you had a second pie\rin your inventory.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 8) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"You should seriously stop\rthis. Right now. OK?\rYou won't like what happens.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 9) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"[starcolor:ff0000][color:ff0000]This is your last warning.","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		elseif (itemsUsed[2] == 10) then
			itemsUsed[2] = itemsUsed[2] + 1
			BattleDialog({"[starcolor:ff0000][color:ff0000][effect:shake,3.0]You will regret this.\nI will come for your ass later.","[starcolor:000000][effect:twitch][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		else
			itemsUsed[2] = 12
			Audio.PlaySound("mystery")
                                                                SetGlobal("cheatingpieceofshit",true)
			Audio.PlaySound("nom")
			Player.hp = Player.hp + 99
			BattleDialog({"[effect:twitch]A slice of pie magically\rappears in your hand. You eat it.\rYour HP was maxed out."})
			--Spoopy
		end
	elseif (ItemID == "DOGTEST3") then
		if (itemsUsed[3] == false) then
			local message = "You ate the Snowman Piece.\n"
			itemsUsed[3] = true
			message = message .. HealItem(45)			
			BattleDialog({ message })
		else
			BattleDialog({"You ate the Snowman Piece.\nTastes like invisible.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST4") then
		if (itemsUsed[4] == false) then
			local message = "You ate the Snowman Piece.\n"
			itemsUsed[4] = true
			message = message .. HealItem(45)			
			BattleDialog({ message })
		else
			BattleDialog({"You ate the Snowman Piece.\nTastes like invisible.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST5") then
		if (itemsUsed[5] == false) then
			local message = "You eat the Legendary Hero.\nATTACK increased by 4!\n"
			itemsUsed[5] = true
			message = message .. HealItem(40)
			BattleDialog({ message })
		else
			BattleDialog({"You tried to find crumbs\ron the floor. You couldn't.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	elseif (ItemID == "DOGTEST6") then
		if (itemsUsed[6] == false) then
			local message = "You ate the Face Steak.\n"
			itemsUsed[6] = true
			message = message .. HealItem(60)
			BattleDialog({ message })
		else
			local message1 = "You eat from an endless supply\rof TEMMIE FLAKES. LOL!\n"
                                                                 message1 = message1 .. HealItem(2)
                        BattleDialog({ message1 })
		end
	elseif (ItemID == "DOGTEST7") then
		if (itemsUsed[7] == false) then
			local message = "You eat the quiche.\n"
			itemsUsed[7] = true
			message = message .. HealItem(34)
			BattleDialog({ message })
		else
			BattleDialog({"The quiche has abandoned YOU.\n(Unitale can't delete items yet...)","[starcolor:000000][noskip][func:SetNone][func:State,ACTIONSELECT]"})
		end
	end
end

function HealItem(val)
	Audio.PlaySound("nom")
	Player.hp = Player.hp + val
	if (Player.hp == 76) then return "Your HP was maxed out."
	else return "You recovered " .. val .. " HP!" end
    end
end

function StartFadeout()
	SetGlobal("fadeout",Time.time)
end

function OnHit(bullet)
	if(bullet.GetVar('tile')) == 0 then
    		Player.Hurt(1)
	end
end

function SetNone()
	curMenu = NONE
end

function PlayIntroPSI()
	Audio.PlaySound("tldr")
end

function StartPSI()
	Audio.PlaySound("psi")
	table.insert(screenAnims, { type = "tldr2/psi", frames = 101, x = 320, y = 240, time = Time.time })
end

function EndPSI()
	rollingHP = 0
end
