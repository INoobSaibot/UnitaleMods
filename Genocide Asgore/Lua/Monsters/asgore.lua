-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"[voice:ui]...", "[voice:ui][starcolor:ff0000][color:ff0000]DETERMINATION.", "[voice:ui][starcolor:ff0000][color:ff0000]In my absolute way.", "[voice:ui][starcolor:ff0000][color:ff0000]ASGORE.", "[voice:ui][starcolor:ff0000][color:ff0000]=)"}
commands = {"Check", "Talk", "FIGHT", "ITEM"}
randomdialogue = {"[next]"}

talkmessages = {{"[voice:ui]You loudly tell ASGORE\ryou killed everyone he\rloves.", "[voice:ui]Nothing Happens."}, {"[voice:ui]You tell ASGORE that you\rwant to kill him.","[voice:ui]He smiles."}, {"[voice:ui]You firmly tell ASGORE to\rgive up.","[voice:ui]He doesn't care..."}, {"[voice:ui]Seems talking won't do anything\rgood.[func:Return]"}}

currenttalk = 1

sprite = "asgore4" --Always PNG. Extension is added automatically.
name = "ASGORE"
hp = 499999999
--hp = 1
atk = 5
fakeatk = 100
def = -9999999
fakedef = 100
check = "dunno lol"
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false

SetGlobal("hurtframes", 0)
SetGlobal("dodge", false)

function OnDeath()
    whatdidyoujustfuckingsaytomeyoulittlebitch()
end

function Return()
    currenttalk = 4
end

function whatdidyoujustfuckingsaytomeyoulittlebitch()
  dialogbubble = "nothing"
end

function PlaceHolder()
     BattleDialog({"[voice:ui]Insert Ending Here[waitall:10]. . . . . . . . .\r. . . . . .[func:State, DONE]"})
end

attacknum = 0
-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
	SetGlobal("waitfordodge", false)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        attacknum = attacknum + 1
        -- player did actually attack
             SetGlobal("hurtframes", 60)
     end
     if hp <= 0 then
         currentdialogue = {"[voice:asgore][effect:none][noskip]Why...[w:20]\nYou...[w:60][func:PlaceHolder][w:10]"}
    end
end


-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
    if command == "TALK" then
        if(currenttalk == 3) then
           
        end
        BattleDialog(talkmessages[currenttalk])
		if currenttalk < #talkmessages then
			currenttalk = currenttalk + 1
		end
    end
    if command == "CHECK" then
        BattleDialog({"[voice:ui]ASGORE "..fakeatk.." ATK "..fakedef.." DEF"})
    end
    if command == "FIGHT" then
       if GetGlobal("bfight") == 0 then
          SetGlobal("bfight", 1)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I look around for pieces of the\rbutton."})
       elseif GetGlobal("bfight") == 1 then
          SetGlobal("bfight", 2)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I pick up a piece of the button."})
       elseif GetGlobal("bfight") == 2 then
          SetGlobal("bfight", 3)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I pick up the other piece of\rthe button."})
       elseif GetGlobal("bfight") == 3 then
          SetGlobal("bfight", 4)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I pick up remaining pieces."})
       elseif GetGlobal("bfight") == 4 then
          SetGlobal("bfight", 5)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]DETERMINATION."})
       end
    end
    if command == "ITEM" then
       if GetGlobal("bitem") == 0 then
          SetGlobal("bitem", 1)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I look around for pieces of the\rbutton."})
       elseif GetGlobal("bitem") == 1 then
          SetGlobal("bitem", 2)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I pick up a piece of the button."})
       elseif GetGlobal("bitem") == 2 then
          SetGlobal("bitem", 3)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]I pick up the other piece of\rthe button."})
       elseif GetGlobal("bitem") == 3 then
          SetGlobal("bitem", 4)
          BattleDialog({"[color:ff0000][starcolor:ff0000][voice:ui]Determination."})
       end
    end
end