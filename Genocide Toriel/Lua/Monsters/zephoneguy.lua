-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"..."}
commands = {"Check", "Talk"}
randomdialogue = {"[next]"}

sprite = "empty" --Always PNG. Extension is added automatically.
name = "Cell Phone"
--hp = 3500
hp = 1
atk = 1
def = -100
check = "Nothing lol"
dialogbubble = "topphone" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false

checker = 0

SetGlobal("hurtframes", 0)

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)

end

function OnDeath()
        SetSprite("BrokeCell")
        State("ACTIONSELECT")
        BattleDialog({"[noskip][w:60][func:State,DONE]"})
end

-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
    if command == "CHECK" then
       if checker < 4 then
           BattleDialog({"Cell Phone - ATK 0 DEF ???\nAn ordinary Cell Phone."})
       elseif checker == 4 then
           BattleDialog({"Cell Phone - ATK 0 DEF ???\nYou used to call me on my\rcell phone."})
       elseif checker == 5 then
           BattleDialog({"Cell Phone - ATK 0 DEF ???\nLate night when you need\rmy love."})
       elseif checker >= 6 then
           BattleDialog({"Cell Phone - ATK 0 DEF ???\nAn ordinary Cell Phone."})
       end
    checker = checker + 1
    elseif command == "TALK" then
        BattleDialog({"You told the person through the\rphone something disturbing."})
    end
end

function Phone()
       Audio.PlaySound("phone")
end