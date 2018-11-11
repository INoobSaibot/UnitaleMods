-- A basic encounter script skeleton you can copy and modify for your own creations.

music = "spear of justice"
encountertext = "Alphys attacks!"
nextwaves = {"bullettest_chaserorb"}
wavetimer = 4.0
arenasize = {155, 130}
enemies = {
"Undyne", "items"
}

enemypositions = {
{-25, -10},
{0, 0} 
}
itemmenu = false



function Update()
if currentstate ~= "ITEMMENU" and itemoverlay ~= nil then --makes sure that "PAGE1"/"PAGE2" does not stay on screen when you leave
		itemoverlay.Remove()
		itemmenu = false
	end
	if currentstate == "ITEMMENU" then--the following code controls changing the page. However, since it's an act menu, the cursor sometimes moves incorrectly.
		if Input.Right == 1 and Player.absx == 321 and Player.absy == 190 and #enemies[2].GetVar("commands2") >= 1 then
			ChangePage() -- the reason for getting the amount of "commands2" is because, in Undertale, pressing left/right at certain positions changes it...
		elseif Input.Left == 1 and Player.absx == 65 and Player.absy == 190 and #enemies[2].GetVar("commands2") >= 2 then
			ChangePage() -- ...but only if there are items in the correct positions on the next page.
		elseif Input.Right == 1 and Player.absx == 321 and Player.absy == 160 and #enemies[2].GetVar("commands2") >= 3 then
			ChangePage() -- the only problem with this here is that, since the items are act commands, the cursor/soul will move around a bit whenever
		elseif Input.Left == 1 and Player.absx == 65 and Player.absy == 160 and #enemies[2].GetVar("commands2") == 4 then
			ChangePage() -- the page is changed. Currently there is no way to fix it, but it's better than nothing.
		end
	end
	AnimateUndyne()
end

possible_attacks = {"spear3", "spear4"}

function EncounterStarting()
    require "Animations/Undyne"
	Player.name = "Frisk"
	Player.lv = 1
	Player.hp = 20
	SetGlobal("turn", 0)
	SetGlobal("det", 0)
	SetGlobal("plead", 0)
	SetGlobal("chalenge", false)
	SetGlobal("hit", false)
	SetGlobal("sare", false)
	SetGlobal("asare", false)
	State("ENEMYDIALOGUE")
	Audio.Stop()
end
function ChangePage() -- changes the pages. Check "items.lua" in the Monsters folder and scroll to the bottom to see this in action.
	enemies[2].Call("SwapTables")
	itemoverlay.Remove()
	State("ITEMMENU")
end
function OnHit(bullet)
	if bullet.GetVar("safe") == nil then -- so that the "PAGE 1"/"PAGE 2" does not hurt you
		Player.Hurt(1,0)
	end
end
function EnteringState(newstate,oldstate)
	currentstate = newstate
	if newstate == "ITEMMENU" then -- if the player selected "ITEMS"
		if itemmenu == false then -- if it's the first time they're going in (because it technically also goes to this state when you change page)
			local commands = enemies[2].GetVar("commands")
			local commands2 = enemies[2].GetVar("commands2")
			if #commands <=3 and #commands2 > 0 then --This block will search for missing slots in page 1 and fill them in with items from page 2.
				for i=1,4-#commands do
					if #commands2 > 0 then
						local item = commands2[1]
						table.remove(commands2,1)
						table.insert(commands,item)
					end
				end
			end
			enemies[2].SetVar("commands",commands) --puts the "balanced" command tables into the monster file.
			enemies[2].SetVar("commands2",commands2)
		end
		if #enemies[2].GetVar("commands") + #enemies[2].GetVar("commands2") > 0 then -- if there are any items there
			enemies[1].Call("SetActive",false)
			enemies[2].Call("SetActive",true)
			itemmenu = true
			local alt = 0
			if enemies[2].GetVar("alt")%2 ~= 0 then --this bit gets which page the items menu is on.
				alt = 2
			else
				alt = 1
			end
			itemoverlay = CreateProjectileAbs("items_"..alt,320,240) -- creates the overlay reading "Page 1" or "Page 2"
			itemoverlay.SetVar("safe",1)
			State("ACTMENU")
		else
			State("ACTIONSELECT") --You can't enter the item menu if you don't have any items.
		end
	elseif newstate == "ENEMYDIALOGUE" then --Since it always happens right after BATTLEDIALOG, we can use it to reset the tables.
		local alt = enemies[2].GetVar("alt")
		if alt%2 ~= 0 then
			enemies[2].Call("SwapTables")
		end
	elseif oldstate == "ACTMENU" then -- if the player is leaving the "item menu" (it's actually an act menu) then
		enemies[1].Call("SetActive",true)
		enemies[2].Call("SetActive",false)
		if itemmenu == true and newstate == "ENEMYSELECT" then --if this code wasn't here, pressing Z within the item menu would display the item monster.
			itemmenu = false
			State("ACTIONSELECT")
		end
end
if oldstate == "ATTACKING" then
		enemies[1].Call("SetSprite","blank")
		animtimer = 0
		legs.alpha = 1
		pants.alpha = 1
		leftarm.alpha = 1
		armor.alpha = 1
		rightarm.alpha = 1
		hair.alpha = 1
		face.alpha = 1
	end
end
function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
	if GetGlobal("turn") == 0 then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]En guarde!"})
	wavetimer = 0.1
	nextwaves = {"blank"}
	SetGlobal("turn", 1)
	Player.sprite.color = {255/255, 255/255, 0/255}
	elseif GetGlobal("turn") == 1 then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]As long as you're\n[color:1eff00]GREEN[color:000000] you [color:ff0000]CAN'T\nESCAPE[color:000000]!",
										  "[noskip][effect:none][voice:v_undyne]Unless you learn\nto [color:ff0000]face danger\nhead-on[color:000000]...",
										  "[noskip][effect:none][voice:v_undyne]You won't last\na SECOND against\nME!"})
	wavetimer = 4.0
	nextwaves = {"green_start"}
	SetGlobal("turn", 2)
	
	elseif GetGlobal("turn") == 2 then
		if GetGlobal("hit") == true then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]When I said\n[color:ff0000]face towards\ndanger[color:000000]...", 
										  "[noskip][effect:none][voice:v_undyne]I meant face\ntowards the\nbullets!"})
		wavetimer = 4.0
	nextwaves = {"green_start"}
	SetGlobal("hit", false)
		else
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Not bad!\nThen how about\nTHIS!?"})
	wavetimer = 5
	nextwaves = {"green_sides"}
	end
	SetGlobal("turn", 3)
	
	elseif GetGlobal("turn") == 3 then
		if GetGlobal("hit") == true then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Look.",
										  "[noskip][effect:none][voice:v_undyne]I gave you an\naxe to block\nthe bullets with.", 
										  "[noskip][effect:none][voice:v_undyne]Do I have to\nexplain this\nany more\nclearly?"})
		wavetimer = 4.0
	nextwaves = {"green_start"}
	SetGlobal("hit", false)
		else
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]For years,\nwe've dreamed\nof a happy\nending"})
		if GetGlobal ("plead") == 3 then
	wavetimer = 7
	nextwaves = {"green_3"}
	elseif GetGlobal ("chalenge") == true then
	wavetimer = 7
	nextwaves = {"green_3 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	wavetimer = 7
	nextwaves = {"green_3 - Copie"}
	end
	end
	SetGlobal("turn", 4)
	
	elseif GetGlobal("turn") == 4 then
		if GetGlobal("hit") == true then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]WHAT ARE YOU\nDOING?",
										  "[noskip][effect:none][voice:v_undyne]JUST FACE\nUPWARDS!!!", 
										  "[noskip][effect:none][voice:v_undyne]IT'S NOT HARD!"})
		wavetimer = 4.0
	nextwaves = {"green_start"}
	SetGlobal("hit", false)
		else
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]And now,\nsunlight is\njust within\nour reach!"})
	if GetGlobal ("plead") == 3 then
	wavetimer = 7
	nextwaves = {"green_4"}
	elseif GetGlobal ("chalenge") == true then
	wavetimer = 7
	nextwaves = {"green_4 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	wavetimer = 7
	nextwaves = {"green_4 - Copie"}
	end
	end
	SetGlobal("turn", 5)
	
	elseif GetGlobal("turn") == 5 then
		if GetGlobal("hit") == true then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]I wanted this to\nbe a fair fight.",
										  "[noskip][effect:none][voice:v_undyne]I thought if I\nbeat you like\nthis...", 
										  "[noskip][effect:none][voice:v_undyne]It'd truly show\nhow strong\nmonsters can be.", 
										  "[noskip][effect:none][voice:v_undyne]BUT NOW???", 
										  "[noskip][effect:none][voice:v_undyne]I DON'T CARE!", 
										  "[noskip][effect:none][voice:v_undyne]I'M NOT YOUR\nFREAKING\nBABYSSITOR!", 
										  "[noskip][effect:none][voice:v_undyne]Unless your\nbabyssitor...", 
										  "[noskip][effect:none][voice:v_undyne]DOES THIS!"})
		wavetimer = 8
	nextwaves = {"green_TROLL"}
	SetGlobal("hit", false)
	SetGlobal("turn", 7)
	SetGlobal("sare", true)
		else
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]I wont let\nyou snatch it\naway from\nus!"})
	wavetimer = 5
	if GetGlobal ("plead") == 3 then
	nextwaves = {"green_6"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_6 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_6 - Copie"}
	end
	SetGlobal("turn", 6)
	end
	
	elseif GetGlobal("turn") == 6 then
	enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]RAHHH!\nEnough warming\nup!"})
	wavetimer = 6
	if GetGlobal ("plead") == 3 then
	nextwaves = {"green_5"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_5 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_5 - Copie"}
	end
	SetGlobal("turn", 7)
	SetGlobal("sare", true)
	
	elseif GetGlobal("turn") == 7 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Heh...\nYou're tough!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"spear3"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"spear3 - Copie - Copie"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"spear3 - Copie"}
	end
			wavetimer = 10.0
			Player.sprite.color = {237/255, 0/255, 0/255}
	SetGlobal("turn", 8)
	elseif GetGlobal("turn") == 8 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]But even if\nyou could\nbeat me..."})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"spear4g"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"spear4g - Copie - Copie"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"spear4g - Copie"}
	end
			wavetimer = 10.0
			Player.sprite.color = {237/255, 0/255, 0/255}
	SetGlobal("turn", 9)
	elseif GetGlobal("turn") == 9 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]No human has\nEVER made it\npast[color:ff0000]\nTORIEL[color:000000]!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_7"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_7 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_7 - Copie"}
	end
			wavetimer = 4
			
	SetGlobal("turn", 10)
	elseif GetGlobal("turn") == 10 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Honestly,\nkilling you\nnow is an act\nof mercy...!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_8"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_8 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_8 - Copie"}
	end
			wavetimer = 4
			
	SetGlobal("turn", 11)
	elseif GetGlobal("turn") == 11 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]So STOP being\nso damn\nresilient!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_9"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_9 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_9 - Copie"}
	end
			wavetimer = 7
			
	SetGlobal("turn", 12)
	elseif GetGlobal("turn") == 12 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]What the\nhell are\nhuman made\nout of!?"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"spear3a"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"spear3a - Copie - Copie"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"spear3a - Copie"}
	end
			wavetimer = 10.0
			Player.sprite.color = {237/255, 0/255, 0/255}
	SetGlobal("turn", 13)
	elseif GetGlobal("turn") == 13 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Anyone else\nwould be DEAD\nby now!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"spear4ga"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"spear4ga - Copie - Copie"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"spear4ga - Copie"}
	end
			wavetimer = 10.0
			Player.sprite.color = {237/255, 0/255, 0/255}
	SetGlobal("turn", 14)
	elseif GetGlobal("turn") == 14 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Undyne told me\nhumans were\ndetermined..."})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_10"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_10 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_10 - Copie"}
	end
			wavetimer = 3.5
			
	SetGlobal("turn", 15)
	elseif GetGlobal("turn") == 15 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]I see now what\nshe meant by\nthat!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_11"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_11 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_11 - Copie"}
	end
			wavetimer = 4.5
			
	SetGlobal("turn", 16)
	elseif GetGlobal("turn") == 16 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]But I'm\ndetermined,\ntoo!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_12"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_12 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_12 - Copie"}
	end
			wavetimer = 5
			
	SetGlobal("turn", 17)
	elseif GetGlobal("turn") == 17 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Determined to\nend this\nRIGHT NOW!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_13"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_13 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_13 - Copie"}
	end
			wavetimer = 5
			
	SetGlobal("turn", 18)
	elseif GetGlobal("turn") == 18 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]...RIGHT NOW!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_14"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_14 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_14 - Copie"}
	end
			wavetimer = 7
			
	SetGlobal("turn", 19)
	elseif GetGlobal("turn") == 19 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]... RIGHT...\n...\n... NOW!!"})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_15"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_15 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_15 - Copie"}
	end
			wavetimer = 5
			
	SetGlobal("turn", 20)
	elseif GetGlobal("turn") == 20 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Ha...\nHa..."})
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_16"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_16 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_16 - Copie"}
	end
			wavetimer = 5
			
	SetGlobal("turn", 21)
	elseif GetGlobal("turn") == 21 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]RAHHH!!!\nDIE ALREADY, YOU\nLITTLE BRAT!"})
		enemies[1].SetVar("canspare" , true)
		enemies[1].SetVar("def" , -20)
			if GetGlobal ("plead") == 3 then
	nextwaves = {"green_17"}
	elseif GetGlobal ("chalenge") == true then
	nextwaves = {"green_17 - Copie (2)"}
	SetGlobal("chalenge", false)
	else
	nextwaves = {"green_17 - Copie"}
	end
			wavetimer = 6.2
			
	SetGlobal("turn", 22)
	elseif GetGlobal("det") == 1 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]Come on, is that\nall you've got!?"})
wavetimer = 5
nextwaves = {"green_ded1"}
SetGlobal("det", 2)
SetGlobal("turn", 1000)
			
	elseif GetGlobal("det") == 2 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]...pathetic",
"[noskip][effect:none][voice:v_undyne]You're going to\nhave to try\nharder than that!"})
wavetimer = 5.5
nextwaves = {"green_ded2"}
SetGlobal("det", 3)
SetGlobal("turn", 1001)
			
			elseif GetGlobal("det") == 3 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]S-see how strong\nwe are when we\nbelieve in\nourselves"})
wavetimer = 4.5
nextwaves = {"green_ded3"}
SetGlobal("det", 4)
SetGlobal("turn", 1002)
			
	elseif GetGlobal("det") == 4 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]H... heh...",
"[noskip][effect:none][voice:v_undyne]Had enough yet?"})
wavetimer = 5
nextwaves = {"green_ded4"}
SetGlobal("det", 5)
SetGlobal("turn", 1003)
			
	elseif GetGlobal("det") == 5 then
		enemies[1].SetVar('currentdialogue', {"[noskip][effect:none][voice:v_undyne]...",
"[noskip][effect:none][voice:v_undyne]... I won't...\n... give up..."})
wavetimer = 5
nextwaves = {"green_ded5"}
SetGlobal("det", 6)
SetGlobal("turn", 1004)
			
	else
    nextwaves = { possible_attacks[math.random(#possible_attacks)] }
	end
	
end



function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
end

function DefenseEnding() --This built-in function fires after the defense round ends.
end

function HandleSpare()
State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end