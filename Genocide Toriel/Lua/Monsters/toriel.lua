-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"...", "In my way.", "Toriel.", "The room is heating up."}
commands = {"Check", "Talk"}
randomdialogue = {"[next]"}

sprite = "a_faketoriel" --Always PNG. Extension is added automatically.
name = "Toriel the Gatekeeper"
hp = 4550
--hp = 1
atk = 1
def = -100
check = "Nothing lol"
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false

SetGlobal("hurtframes", 0)

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
        SetGlobal("FIGHTED", true)
    else
        if hp <= 350 then
            def = -1000
        end
        -- player did actually attack
        SetGlobal("hurtframes", 60)
        SetGlobal("FIGHTED", true)
    end
end

function OnDeath()
                   if GetGlobal("cheatingpieceofshit") == true then
                     SetGlobal("DEAD",1)
                   else
                     SetGlobal("DEAD",2)
                   end
                   State("ENEMYDIALOGUE")
end
     
-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
    if command == "CHECK" then
        BattleDialog({"The Gatekeeper - ATK ??? DEF ???\nIt's rude to ask a lady her\rstats."})
        SetGlobal("ACTED", true)
    elseif command == "TALK" then
        BattleDialog({"You thought about telling\rToriel that you saw\rher die.", "But...[w:30]\nThat's creepy."})
        SetGlobal("ACTED", true)
    end
end

function ESF()
	SetGlobal("esf",Time.time)
end

function Phone()
       Audio.PlaySound("phone")
end