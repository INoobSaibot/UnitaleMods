-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"Stage lights are blaring."}
commands = {"Check"}
randomdialogue = {"[effect:none][next]"}
sprite = "empty" --Always PNG. Extension is added automatically.
name = "Mettaton NEO"
hp = 30000
atk = 90
def = -699999
check = "Dr. Alphys greatest invention."
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false

--comments = {"Stage lights are blaring.", "Mettaton NEO.", "Smells like Neon.", "The crowd goes silent!", "...", "[starcolor:ff0000][color:ff0000]Pile of Garbage...", "Mettaton NEO is preparing\ran attack.", "Smells like Mettaton.", "Mettaton.", "In my way.", "Legs."}

numberoftaunts = 0

------------- Global Variables ----------------
SetGlobal("attack_num", 0)
SetGlobal("hurtframes", 0)
SetGlobal("FirstHit", 0)
SetGlobal("SecondHit", 0)
SetGlobal("Face", 0)
attacknum = -1
SetGlobal("turns", -1)
SetGlobal("Lightss", false)
SetGlobal("Lighter", false)
SetGlobal("hit1", false)
SetGlobal("dialog1", false)
----------------------------------------------------------

-- Happens after the slash animation but before 
attack_num = -1
attacknum = 0
taunt = 0
key = 0
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
        SetGlobal("FIGHTED", true)
    else
if (GetGlobal("attacked") == true) then
         if (GetGlobal("Face") == 0) or (GetGlobal("Face") == 3) then
             Audio.PlaySound("Yeaah 2")
        end
end 
        if (GetGlobal("fakedie1") == false) then
             SetGlobal("hurtframes", 30)
        else
             SetGlobal("hurtframes", 120)
        end

        attack_num = attack_num + 1
        SetGlobal("FIGHTED", true)
        SetGlobal("justTaunted", false)

        -- player did actually attack
        if attack_num == 0 then --Player's first attack
            Audio.Stop()
            currentdialogue = {"[effect:none][noskip]GH...[w:15]", "[effect:none][func:fanclub][noskip]GUESS YOU DON'T\nWANNNA JOIN MY\nFAN CLUB...?[w:22][func:fanclub2][next]"}
            BattleDialog({"[noskip][starcolor:000000][w:50][starcolor:ff0000][color:ff0000]Disappointment..."})
            hp = 1
            comments = {"...", "[starcolor:ff0000][color:ff0000]Just finish the job.", "...", "...", "..."}
        elseif attack_num == 1 then --Player's second attack
            currentdialogue = {"[effect:none]Heh...", "Did I scare you\ndarling?", "[effect:none][noskip][func:RealShow][func:JK]NOW THE REAL\nSHOW BEGINS![w:12][func:OHYES][next]"}
            BattleDialog({"[noskip][starcolor:000000][w:50][starcolor:ff0000][color:ff0000]It's not over..."})
            SetGlobal("attacked",true)
            hp = 31000
            def = 20
            commands = {"Check", "Taunt"}
            comments = {"Stage lights are blaring.", "Mettaton NEO.", "Smells like Neon.", "The crowd goes silent!", "...", "[starcolor:ff0000][color:ff0000]Pile of Garbage...", "Mettaton NEO is preparing\ran attack.", "Smells like Mettaton.", "Mettaton.", "In my way.", "Legs."}
        elseif attack_num == 2 then
            def = 0
        elseif attack_num == 3 then
            def = -50
        elseif attack_num == 4 then
            def = -100
        elseif attack_num == 5 then
            def = -200
        elseif attack_num == 6 then
            def = -250
        elseif attack_num == 7 then
            def = -300
            commands = {"Check", "Taunt", "Key"}
        end
    end
end

-- Face Functions
function Face0()
-- Regular Face
         SetGlobal("Face", 0)
end
function Face1()
-- Kinda Sad Face
         SetGlobal("Face", 1)
end
function Face2()
-- Mad Epic Face
         SetGlobal("Face", 2)
end
function Face3()
-- Mad Happy Face
         SetGlobal("Face", 3)
end
function Face4()
-- Damaged Face
         SetGlobal("Face", 4)
end
function Face5()
-- Fanclub Face
         SetGlobal("Face", 5)
end
function Face6()
-- Sad Face
         SetGlobal("Face", 6)
end
-- End of Face Functions

function fanclub()
          SetGlobal("fanclub", true)
end

function fanclub2()
          SetGlobal("fanclub", false)
end

function JK()
        SetGlobal("hurtframes", 120)
        SetGlobal("fakedie1", true)
        SetGlobal("stage", true)
end

function OnDeath()
if (GetGlobal("cheatingpieceofshit") == true) then
             SetGlobal("cheatingpieceofshit1", true)
             State("ENEMYDIALOGUE")
else
             SetGlobal("hurtframes", 30)
             SetGlobal("die",true)
            Audio.Stop()
         if (GetGlobal("die") == true) then
                  if (GetGlobal("hit1") == true) then
                                currentdialogue = {"[effect:none][noskip][func:Face4]GH...", "GUESS THAT'S IT\nHUH!?", "I SHOULD HAVE\nUPDATED THE\nGRAND FINALE...", "[w:10].[w:10].[w:10].", "[noskip]If I'm gonna die now...\n[func:Face3]I'LL DIE WITH\nA BANG![w:5][func:reallyded][next]"}
                                BattleDialog({"[noskip][w:20][color:ff0000]Finally..."})
                              --BattleDialog({"[noskip][starcolor:000000][w:150][func:StartFadeout][w:30][func:State,DONE]"})
                  --elseif (GetGlobal("hit1") == false) then
                  elseif Player.hp == 76 then
                                currentdialogue = {"[effect:none][noskip][func:Face6]HA...[w:20]", "I COULDN'T EVEN\nLAND A SINGLE HIT\nON YOU...", "THIS WILL BRING A\nHUGE DISAPPOINTMENT\nTO MY NON-EXISTENT\nFANS...", "[noskip]IF I COULDN'T HURT\nYOU.[w:8].[w:8].[w:15]\n[func:Face3]THEN PERHAPS\nTHIS WILL![w:10][func:reallyded][w:70][w:5][next]"}
                                BattleDialog({"[noskip][w:20][color:ff0000]Pathetic..."})
end
                  end
         end
end

----- Extremely Messy Death Functions cus im a noob-----
function reallyded()
dialogbubble = "bottom"
             SetGlobal("hurtframes", -1)
        currentdialogue = {"[noskip][w:120][func:reallyfalse][next]", "[func:Bubbles][noskip][w:70][func:Exit][next]"}
        Audio.PlaySound("enemydust1")
        SetGlobal("reallyded", true)
        SetGlobal("reallyded2", true)
        SetGlobal("attacked", false)
        comments = {""}
        Player.Hurt(20)
        State("ENEMYDIALOGUE")
end

function reallyfalse()
        commands = {"Check"}
        def = 255
         dialogbubble = "top"
         SetGlobal("reallyded1", true)
         SetGlobal("reallyded", false)
         SetGlobal("reallyded1", true)
         SetGlobal("reallyded2", true)
        Player.lv = 19
        --Kill()
end
function Bubbles()
    dialogbubble = "top"
end
function Exit()
        State("DONE")
end
----- End of Death Functions-----
function OHYES()
  Audio.PlaySound("oh yes")
  SetGlobal("Lightss", true)
  SetGlobal("Lighter", true)
end

function RealShow()
 Audio.LoadFile("Power of NEO Remix")
end

function OHYESH()
   Audio.PlaySound("oh yes2")
end

function ESF()
	SetGlobal("esf",Time.time)
end

-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)   
SetGlobal("ACTED", true)
    if command == "CHECK" then
        if attack_num < 0 then
                BattleDialog({"METTATON NEO - 90 ATK 9 DEF\nDr. Alphy's greatest\rinvention."})
        elseif attack_num == 0 then
                BattleDialog({"METTATON NEO - 0 ATK 0 DEF\nDr. Alphy's greatest invention...\nUseless pile of junk."})     
        elseif GetGlobal("reallyded1") == true then
                BattleDialog({"METTATON NEO - -255 ATK -255 DEF\nWon't be missed."}) 
        else
                BattleDialog({"METTATON NEO - 90 ATK 9 DEF\nDr. Alphy's greatest\rinvention."})        
        end     
    elseif command == "TAUNT" then
       if taunt == 0 then
          BattleDialog({"You say you aren't going to get\rhit at ALL.", "The fight hardens."})
                  SetGlobal("justTaunted", true)
                  SetGlobal("attackNum",11)
                  taunt = taunt + 1
       elseif taunt == 1 then
          BattleDialog({"You said it was fun bashing\rAlphys's face to a pulp.", "He seems angry about this."})
                  SetGlobal("justTaunted", true)
                  SetGlobal("attackNum",11)
                  taunt = taunt + 1 
       elseif taunt == 2 then
          BattleDialog({"You tell Mettaton he left his\rcousin for his own fame."})
                  SetGlobal("justTaunted", true)
                  SetGlobal("attackNum",11)
                  taunt = taunt + 1 
       elseif taunt == 3 then
          BattleDialog({"You tell Mettaton he will\rnever be popular."})
                  SetGlobal("justTaunted", true)
                  SetGlobal("attackNum",11)
                  taunt = taunt + 1 
       elseif taunt == 4 then
          BattleDialog({"You tell Mettaton no one will\rmiss him after this."})
                  SetGlobal("justTaunted", true)
                  SetGlobal("attackNum",11)
                  taunt = taunt + 1 
       else
          BattleDialog({"You say something disturbing.\nMettaton ignores you."})
          end
    elseif command == "KEY" then 
         if key == 0 then    
                BattleDialog({"You show Mettaton the mysterious\rkey.", "He remembers something.", "Mettaton NEO Defense lowered!"})
                def = -350    
                 key = key + 1 
         else
                BattleDialog({"You show Mettaton the mysterious\rkey.", "Mettaton pretends it isn't\rthere."})
         end
     end
end