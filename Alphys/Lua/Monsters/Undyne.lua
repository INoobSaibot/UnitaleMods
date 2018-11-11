-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"Smells like the work\rof an enemy stand.", "Poseur is posing like his\rlife depends on it.", "Poseur's limbs shouldn't be\rmoving in this way."}
commands = {"Check", "Plead", "Challenge"}
currentdialogue = {}

sprite = "blank" --Always PNG. Extension is added automatically.
name = "Alphys"
hp = 1500
atk = 7
def = 0
check = "The heroine that NEVER\rgives up."
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        -- player did actually attack
		SetSprite("undyne/hurt")
		Encounter["legs"].alpha = 0
		Encounter["pants"].alpha = 0
		Encounter["leftarm"].alpha = 0
		Encounter["armor"].alpha = 0
		Encounter["rightarm"].alpha = 0
		Encounter["hair"].alpha = 0
		Encounter["face"].alpha = 0
    end
end
 
function Startanim()
SetSprite("blank")
Encounter["legs"].alpha = 1
Encounter["pants"].alpha = 1
Encounter["leftarm"].alpha = 1
Encounter["armor"].alpha = 1
Encounter["rightarm"].alpha = 1
Encounter["hair"].alpha = 1
Encounter["face"].alpha = 1
end
	
function Stopanim()
SetSprite("undyne/hurt")
Encounter["legs"].alpha = 0
Encounter["pants"].alpha = 0
Encounter["leftarm"].alpha = 0
Encounter["armor"].alpha = 0
Encounter["rightarm"].alpha = 0
Encounter["hair"].alpha = 0
Encounter["face"].alpha = 0
Encounter["background1"].alpha = 0
Encounter["background2"].alpha = 0
Encounter["background3"].alpha = 0
Encounter["background4"].alpha = 0
Encounter["background5"].alpha = 0
Encounter["background6"].alpha = 0
end
 
-- This handles the commands; all-caps versions of the commands list you have above.
-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
	if command == "CHECK" then
		BattleDialog({"Alphys 50 ATK 20 DEF\nThe heroine that NEVER\rgives up."})
		SetGlobal("plead", 0)
	elseif command == "PLEAD" then
		if GetGlobal ("plead") == 0 then
			BattleDialog({"You told Undyne you didn't\rwant to fight.\nBut nothing happened."})
			SetGlobal("plead", 1)
		elseif GetGlobal ("plead") == 1 then
			BattleDialog({"You told Undyne you didn't\rwant to fight.\nBut nothing happened."})
			SetGlobal("plead", 2)
		elseif GetGlobal ("plead") == 2 then
			BattleDialog({"You told Undyne you didn't\rwant to fight.\nshe is remembering someone", "the bullets are less stronger."})
			SetGlobal("plead", 3)
		elseif GetGlobal ("plead") == 3 then
			BattleDialog({"You told Undyne you didn't\rwant to fight.\nshe is remembering someone", "the bullets are less stronger."})
			
		end
	elseif command == "CHALLENGE" then
		BattleDialog({"You tell Undyne her attacks\rare to easy.\nThe bullets get stronger."})
		SetGlobal("chalenge", true)
	end
	
end
function NO()
Audio.LoadFile("mus_piano")
end
function YES()
Audio.Stop()
end
function RED()
Player.sprite.color = {255/255, 255/255, 0/255}
Audio.PlaySound('switch')
end
function OnDeath()
SetGlobal("turn", 22)
if GetGlobal("det") == 0 then
canspare = false
currentdialogue = {"[noskip][effect:none][func:YES][func:Stopanim][voice:v_undyne]Rahhh...",
 "[noskip][effect:none][voice:v_undyne]You were stronger...[wait:35]\nThan I thought...",
 "[noskip][effect:none][voice:v_undyne]So then...[wait:35]\n...this is where...[wait:35]\n...it ends...",
 "[noskip][effect:none][voice:v_undyne]...",
 "[noskip][effect:none][voice:v_undyne]No...[func:NO]",
 "[noskip][effect:none][voice:v_undyne][func:Startanim]I won't die!",
 "[noskip][effect:none][voice:v_undyne]Undyne...\nToriel...\nSans...",
 "[noskip][effect:none][voice:v_undyne]Everyone is counting\non me to protect\nthem!",
 "[noskip][effect:none][voice:v_undyne]RAHH![func:RED]",
 "[noskip][effect:none][voice:v_undyne]Human!",
 "[noskip][effect:none][voice:v_undyne]In the name of\neverybody's hopes\nand dreams...",
 "[noskip][effect:none][voice:v_undyne]I WILL DEFEAT YOU![func:mor]",}
 wavetimer = 0.1
nextwaves = {"blank2"}
State("ENEMYDIALOGUE")
elseif GetGlobal("det") == 1 then
currentdialogue = {"[noskip][effect:none][voice:v_undyne]Come on, is that\nall you've got!?",}
wavetimer = 5
nextwaves = {"green_ded1"}

State("ENEMYDIALOGUE")
elseif GetGlobal("det") == 2 then
currentdialogue = {"[noskip][effect:none][voice:v_undyne]...pathetic",
"[noskip][effect:none][voice:v_undyne]You're going to\nhave to try\nharder than that!"}
 wavetimer = 5.5
nextwaves = {"green_ded2"}

State("ENEMYDIALOGUE")
elseif GetGlobal("det") == 3 then
currentdialogue = {"[noskip][effect:none][voice:v_undyne]S-see how strong\nwe are when we\nbelieve in\nourselves"}
 wavetimer = 0.1
nextwaves = {"green_ded3"}

State("ENEMYDIALOGUE")
elseif GetGlobal("det") == 4 then
currentdialogue = {"[noskip][effect:none][voice:v_undyne]H... heh...",
"[noskip][effect:none][voice:v_undyne]Had enough yet?"}
 wavetimer = 0.1
nextwaves = {"green_ded4"}

State("ENEMYDIALOGUE")
elseif GetGlobal("det") == 5 then
currentdialogue = {"[noskip][effect:none][voice:v_undyne]...",
"[noskip][effect:none][voice:v_undyne]... I won't...\n... give up..."}
 wavetimer = 0.1
nextwaves = {"green_ded5"}

State("ENEMYDIALOGUE")
elseif GetGlobal("det") == 6 then
currentdialogue = {"[noskip][effect:none][func:YES][func:Stopanim][voice:v_undyne]...",
"[noskip][effect:none][voice:v_undyne]Ha... ha...",
"[noskip][effect:none][voice:v_undyne]... Undyne...",
"[noskip][effect:none][voice:v_undyne]This is what I\nwas afraid of...",
"[noskip][effect:none][voice:v_undyne]This is why I\nnever told you...",
"[noskip][effect:none][voice:v_undyne]...",
"[noskip][effect:none][voice:v_undyne]No...\nNo!",
"[noskip][effect:none][voice:v_undyne]Not yet!",
"[noskip][effect:none][voice:v_undyne]I won't die!",
"[noskip][voice:v_undyne]RAHHHHHHHH!!!",
"[noskip][voice:v_undyne]I WON'T DIE!",
"[noskip][voice:v_undyne]I WON'T DIE!",
"[noskip][func:deee][voice:v_undyne][waitall:10]I WON'T DIE!",
"[noskip][func:deee2][voice:v_undyne][waitall:35]I WON'T[func:Kill]"}
 wavetimer = 0.1
nextwaves = {"blank2"}
SetGlobal("det", 7)
State("ENEMYDIALOGUE")
else
Stopanim()
Kill()
end
end
function mor()
SetGlobal("det", 1)
end
function deee()
SetSprite("deadundyne0")
end
function deee2()
SetSprite("deadundyne1")
end