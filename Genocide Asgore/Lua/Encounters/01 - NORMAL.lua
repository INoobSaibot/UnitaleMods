-- A basic encounter script skeleton you can copy and modify for your own creations.
Timers = require "timer"
require "Animations/nomercy"
require "fakeui"
require "vsprite"

-- music = "shine_on_you_crazy_diamond" --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
music = ""
encountertext = "[voice:ui]ASGORE attacks!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"intro_old"}
wavetimer = 100
arenasize = {155, 130}
reddots = {}
reddots_count = 0
del_reddots = {}
del_reddots_count = 0

starttime = Time.time
currenttime = 0
current_turn = 0
current = 0

SetGlobal("bfight", 0)
SetGlobal("bitem", 0)
SetGlobal("gameover", false)
SetGlobal("atk", 3)

enemies = {
"asgore",
"itemgore"
}

enemypositions = {
{-10, 0},
{500, 500}
}

current_turn = 0 --use to test specific attacks
flowey_turn = 0

--DEBUG_MODE = true --uncomment to enable debug mode

function EncounterStarting()
Player.lv = 20
Player.hp = 99
Player.name = "Chara"
    -- If you want to change the game state immediately, this is the place.
    enemies[2].Call("SetActive", false)
    if(DEBUG_MODE) then
    	Audio.LoadFile("asgore")
    	intro = false
    	enemies[1].Call("SetSprite", "asgoreempty")
                                           SpawnBall()
		backpink = CreateSprite("backpink")
		backpink.SetPivot(0, 0)
		backpink.MoveTo(0, 0)
		require "Animations/asgore"
		wavetimer = 7

		fui_init()
	else
		Audio.LoadFile("bergentruckunghousingMANDO")
		BattleDialog({"[effect:none][novoice][noskip][waitall:1.7](A strange light fills the\rroom.)[w:1000][next]"})
                     end
end

function No()
     backpink.Set("empty")
end

testbmercy = nil
intro = true
mask = nil
btt = 0
backpink = nil
goback = false
gotoitemenu = false
initemmenu = false
lasttime = Time.time
framecounter = 0

function add_reddot()
      if GetGlobal("No") == true then
      else
	local rdot
	if del_reddots_count == 0 then
		rdot = CreateVSprite("reddot")
		table.insert(reddots, rdot)
		reddots_count = reddots_count + 1
	else
		rdot = del_reddots[del_reddots_count]
		table.remove(del_reddots, del_reddots_count)
		del_reddots_count = del_reddots_count - 1
	end
	
	local rdotscale = 1 + (math.random() - 0.5)
	rdot.sprite.Scale(rdotscale, rdotscale)
	rdot.sprite.MoveTo(math.random(0, 640), -4)
	rdot.SetVar("velx", (math.random() * 6) - 3)
	rdot.SetVar("alpham", math.random() * 0.03 + 0.001)
	rdot.SetVar("vely", math.random() * 1.0 + 0.01)
	rdot.SetVar("velym", math.random() * 0.02 + 0.01)
	rdot.SetVar("dot_active", true)
	rdot.sprite.alpha = 1.0
                     rdot.sprite.color = {math.sin(Time.time), math.cos(Time.time), -math.sin(Time.time)}
	rdot.sprite.SendToBottom()
         end
end

--moves a red dot into position. This can be improved by changing y velocity over time
function update_reddot(rdot, i)
	if not rdot.GetVar("dot_active") then
		return
	end
	
	local vely = rdot.GetVar("vely")
	
	rdot.sprite.alpha = rdot.sprite.alpha - rdot.GetVar("alpham")
	rdot.sprite.y = rdot.sprite.y + vely
	rdot.SetVar("vely", vely + rdot.GetVar("velym"))
	rdot.sprite.x = rdot.sprite.x + rdot.GetVar("velx")
	if(rdot.sprite.alpha <= 0) then
		del_reddot(i)
	end
end

--performs update on all red dots
function update_reddots()
	for i=1,reddots_count do
		local rdot = reddots[i]	
		update_reddot(rdot, i)
	end
end

function del_reddot(index)
	reddots[index].SetVar("dot_active", false)
	table.insert(del_reddots, reddots[index])
	del_reddots_count = del_reddots_count + 1
end

SetGlobal("afterimage", true)
SetGlobal("soulfix", false)
spawntimer = 0

dedtimer = 0
cheat = false

difficulty = 5
BallExists = false
function SpawnBall()
    BallExists = true ball1xspeed = math.random(1, 6)
    MenuBall1 = CreateProjectileAbs('a_torielflameL0', 0, 40)  MenuBall1.sprite.SetAnimation({"a_torielflameL0", "a_torielflameL1"}, 0.2) MenuBall1.sprite.SendToBottom()
end
-- placeholder menu attack, i might make it so that balls will continuosly spawn
function KillBall()
    MenuBall1.sprite.StopAnimation() MenuBall1.sprite.Set("empty") BallExists = false
end
AsgoreDead1 = false
SetGlobal("dodgeit", 1)
function Update()      
	if waitfordodge then
                                        if GetGlobal("dodgeit") == 3 then
		if Input.Confirm == 1 then
                                                                enemies[1].SetVar("def", 999999999999)
			SetGlobal("dodge", true)
			waitfordodge = false
		end
                                        else
                                           enemies[1].SetVar("def", -9999999)
                                        end
	end
              if fui_inMenu == true and BallExists == true then
                 MenuBall1.Move(ball1xspeed, 0)
                   if MenuBall1.absx >= 640 then 
                         MenuBall1.MoveToAbs(0, 40) 
                   end
              end
             if not intro and Input.Menu == 1 then
                 if math.random(1,3) == 2 then Player.Hurt(2, 0) elseif math.random(1,3) == 3 then Player.heal(1) end
             end
             dedtimer = dedtimer + 1
    	if enemies[1].GetVar("hp") <= 0 then
                            dedtimer = 0 enemies[1].SetVar('dialogbubble', 'rightwide') AsgoreDead1 = true
                            enemies[1].SetVar("hp", 1) enemies[1].Call("SetSprite", "asgoreded1")
                            Audio.Stop() HideAsgore() No()  SetGlobal("No", true)
                     end

	if GetGlobal("hurtframes") ~= nil then
		if GetGlobal("hurtframes") > 0 then
			SetGlobal("hurtframes", GetGlobal("hurtframes") - 1)
		end
	end	
	framecounter = framecounter + 1
	if Timers then
		Timers.UpdateTimers()
	end
	if(goback) then
		State("ACTIONSELECT")
		goback = false
	end
	if(gotoitemenu) then
		enemies[2].Call("SetActive", true)
		enemies[1].Call("SetActive", false)
		State("ACTMENU")
		gotoitemenu = false
	end
	if(initemmenu and Input.Cancel == 1) then
		BattleDialog({"[next]"})
		initemmenu = false
		goback = true
	end
	if(intro) then
		if(mask == nil) then
			mask = CreateProjectileAbs("dialogmask", 320, 160)
                                                                
		end 
		AsgoreIntro()
		AnimNoMercy()
	else
		currenttime = Time.time - starttime
		UpdateAsgore()
		if(Player.absx == 202 and Player.absy == 25 and GetGlobal("soulfix") == false) then
                                                     SetGlobal("soulfix", true)
                                                     fui_soulfixer()
                                           end
		if(Player.absx == 202 and Player.absy == 25 and GetGlobal("bitem") < 4 and Input.Right == 1) then
			goback = true
			BattleDialog({"[next]"})
                                           end
		if(Player.absx == 202 and Player.absy == 25 and GetGlobal("bfight") < 5 and Input.Left == 1) then
			goback = true
			BattleDialog({"[next]"})
                                           end
		if(Player.absx == 361 and Player.absy == 25 and Input.Right == 1) then
			goback = true
			BattleDialog({"[next]"})
		end
		if(Player.absx == 48 and Player.absy == 25 and Input.Left == 1) then
			goback = true
			BattleDialog({"[next]"})
		end
		if(Player.absx == 48 and Player.absy == 25 and GetGlobal("bfight") < 5 and Input.Confirm == 1) then
			goback = true
			BattleDialog({"[next]"})
		end
	end

	update_reddots()

	if(fui_initialized) then
		backpink.yscale = 10 + math.sin(Time.time * 1.2) * 5
                                           backpink.color = {math.sin(Time.time), math.cos(Time.time), -math.sin(Time.time)}
		
		backpink.SendToBottom()
		fui_mask.SendToBottom()

		if framecounter % 2 == 0 then
			add_reddot()
		end
		fui_update()
	end
                     
end
mercies = 0

ballinit = false
function EnteringState(newstate, oldstate)
    if newstate == "ATTACKING" then
        SetGlobal("dodgeit", math.random(1,3))
        waitfordodge = true
    end
	if(newstate == "DEFENDING" and intro) then
		enemies[1].Call("SetSprite", "asgoreempty")
		InitNoMercy()
	end

	if(newstate == "MERCYMENU") then
		State("ACTIONSELECT")
	end
	if(newstate == "ITEMMENU") then
		State("ACTIONSELECT")
		if(#enemies[2].GetVar("commands") == 0) then
			State("ACTIONSELECT")
		else
			initemmenu = true
			gotoitemenu = true
		end
	end
	if((newstate ~= "ACTMENU" and newstate ~= "ITEMMENU") and initemmenu) then
		enemies[1].Call("SetActive", true)
		enemies[2].Call("SetActive", false)
		initemmenu = false
	end

	if(newstate == "ACTIONSELECT" and oldstate == "DEFENDING") then
                             if AsgoreDead1 == false then SpawnBall() end
                                 fui_inMenu = true
                      end

	if(newstate == "ACTIONSELECT") then
		fui_selectingButton = true

	elseif(not goback) then
		fui_selectingButton = false
	end
                      if(not intro and newstate == "ENEMYDIALOGUE" or newstate == "DEFENDING") then
		fui_inMenu = false

	else             
		fui_inMenu = true
	end

	if(intro and newstate == "ENEMYDIALOGUE" or newstate == "DEFENDING") then
		fui_inMenu = false

	else             
		fui_inMenu = true
	end
end

function OnHit(bullet)
       if BallExists == true then
             Player.Hurt(5, 0.2)
       end
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
    if not intro and AsgoreDead1 == false then
         KillBall()
    end
    if (intro) then
       	enemies[1].SetVar('currentdialogue', {"[effect:none][voice:asgore][waitall:2][noskip][w:5][func:SetSprite,asgore4][w:15]Human...\n[w:25][func:SetSprite,asgore4]No...[w:30]\nwhatever you\nare...[w:40][next]","[noskip][effect:none][voice:asgore][waitall:2]It is time...[w:40][next]","[noskip][func:SetSprite,asgore1][effect:none][voice:asgore][waitall:2][w:60][func:SetSprite,asgore4]Goodbye.[w:10][next]"})
    end

end

-- All the attacks that Asgore will always use in order... once this list is exhausted, we move on to possible_attacks
attack_order = {"nothing", "Bulletrain/1", "Bulletrain/2", "spearswing", "hand_opening", "wavy_fire", "warning_fire", "hand_sweep", "spearswing", "circles", "bigbulletrain", "spearswing",
                "wavy_fire", "hand_sweep", "circles", "spearswing", "bigbulletrain", "warning_fire", "circles", "spearswing",
				"hand_sweep", "circles", "bigbulletrain", "spearswing"}

floweyorder = { "nothing", "Flowey/randomCirfast", "nothing", "Flowey/circlehole", "nothing", "nothing", "nothing", "nothing", "Flowey/circlehole", "Flowey/circle", "nothing", "Flowey/circlehole"}

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
-- TODO: Weighted attack order
possible_attacks = {"bigbulletrain", "wavy_fire", "spearswing", "warning_fire", "circles", "hand_sweep", "Bulletrain/1", "Bulletrain/2"}

possible_flowey = {"Flowey/circle", "Flowey/circlehole", "Flowey/orangeCirSlow", "Flowey/orangeCirFast", "Flowey/randomCirSlow", "nothing"}

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
    if(intro) then
    	nextwaves = { "nothing" }
    else
		Timers = nil
		current_turn = current_turn + 1
		flowey_turn = flowey_turn + 1
		SetGlobal("current_turn", current_turn)
                                           if AsgoreDead1 == true then
                                                                nextwaves = {"none"}
		elseif current_turn <= #attack_order then
			nextwaves = {attack_order[current_turn], floweyorder[flowey_turn]}
                                           else
			nextwaves = { possible_attacks[math.random(#possible_attacks)], possible_flowey[math.random(#possible_flowey)] }
			starttime = Time.time
			currenttime = 0
		end
    end
end

function DefenseEnding() --This built-in function fires after the defense round ends.
	if(intro) then
		intro = false
		backpink = CreateSprite("backpink")
		backpink.SetPivot(0, 0)
		backpink.MoveTo(0, 0)
		require "Animations/asgore"
		wavetimer = 7

		fui_init()
	else
    	encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
                     if AsgoreDead1 == true then Player.SetControlOverride(true) end
    end
end

function HandleSpare()
     State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end
introdone = false
function AsgoreIntro()
                     if Input.Menu == 1 and introdone == false then
                         btt = true
                         introdone = true
                     end
	if(btt == 0 and Audio.playtime >= 3) then
		BattleDialog({"[effect:none][novoice][noskip][waitall:1.9](Twilight is shining through\rthe barrier.)[w:700][next]"})
		btt = 1
	end
	if(btt == 1 and Audio.playtime >= 6) then
		BattleDialog({"[effect:none][novoice][noskip][waitall:1.9](Dust floats throughout\rthe Underground.)[w:700][next]"})
		btt = 2
	end
	if(btt == 2 and Audio.playtime >= 9) then
		BattleDialog({"[effect:none][novoice][noskip][waitall:1.9](ASGORE stands between you\rand the absolute.)[w:700][next]"})
		btt = 3
                     end
	if(btt == 3 and Audio.playtime >= 12) then
		BattleDialog({"[effect:none][novoice][noskip][waitall:1.9](It seems your journey is\rcoming to an end.)[w:900][next]"})
		btt = 4
	end
	if(btt == 4 and Audio.playtime >= 16) then
		BattleDialog({"[starcolor:000000][effect:none][novoice][noskip][waitall:2]   * (You're filled with\r      [w:30][color:ff0000]DETERMINATION[color:ffffff].)[w:1000][next]"})
		btt = 5
	end
	if(btt == 5 and Audio.playtime >= 28 or btt == true) then
		Audio.Stop()
		btt = Time.time
	end
	if(btt > 5 and Time.time - btt >= 1) then
		btt = -1
		mask.sprite.Set("fullmask")
		State("ENEMYDIALOGUE")
	end
end