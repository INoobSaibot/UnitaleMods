-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"[voice:ui]..."}
commands = {"Pie", "LOVE", "G. Burger x3", "L. Hero x4"}
--commands = {"Pie", "G. Burger", "Junk Food", "Bisicle"}
randomdialogue = {"[next]"}

talkmessages = {{"[voice:ui]You quietly tell ASGORE\ryou don't want to fight\rhim.","[voice:ui]His hands tremble for a\rmoment."},{"[voice:ui]You tell ASGORE that you\rdon't want to fight him.","[voice:ui]His breathing gets funny\rfor a moment."},{"[voice:ui]You firmly tell ASGORE to\rSTOP fighting.","[voice:ui]Recollection flashes in his\reyes...","[voice:ui]ASGORE's ATTACK dropped!\nASGORE's DEFENSE dropped![func:Drop]"},{"[voice:ui]Seems talking won't do any more\rgood.[func:Return]"}}

currenttalk = 1

sprite = "asgoreempty" --Always PNG. Extension is added automatically.
name = "ASGORE"
hp = 1900
atk = 5
fakeatk = 100
def = -30
fakedef = 100
check = "dunno lol"
dialogbubble = "right" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false

function Return()
    currenttalk = 4
end

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        -- player did actually attack
    end
end
-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
    if command == "PIE" then
        BattleDialog({EatMessage("Butterscotch Pie", 100),"[voice:ui]The smell reminded ASGORE of\rwhat he is fighting for...","[voice:ui]ASGORE's ATTACK increased!"})
        Player.Heal(100)
        Encounter.GetVar("enemies")[1].SetVar("fakeatk", fakeatk + 50)
        SetGlobal("atk", 4)
        RemoveCommand("Pie")
    elseif command == "LOVE" then
        if Player.lv == 1 then
            BattleDialog({"[starcolor:ff0000][color:ff0000]You really are an idiot.", "[func:Lovekill]"})
        else
            BattleDialog({"[starcolor:ff0000][color:ff0000]DETERMINATION."})
            Player.lv = Player.lv - 1
            Player.Heal(100)
        end
    elseif command == "G. BURGER" then
        BattleDialog({EatMessage("Glamburger", 27)})
        Player.Heal(27)
        RemoveCommand("G. Burger")
    elseif command == "G. BURGER X2" then
        BattleDialog({EatMessage("Glamburger", 27)})
        Player.Heal(27)
        for i=1,#commands do
            if(commands[i] == "G. Burger x2") then
                commands[i] = "G. Burger"
                return
            end
        end
    elseif command == "G. BURGER X3" then
        BattleDialog({EatMessage("Glamburger", 27)})
        Player.Heal(27)
        for i=1,#commands do
            if(commands[i] == "G. Burger x3") then
                commands[i] = "G. Burger x2"
                return
            end
        end

    elseif command == "L. HERO" then
        BattleDialog({EatMessage("Legendary Hero", 40)})
        Player.Heal(40)
        RemoveCommand("L. Hero")
    elseif command == "L. HERO X2" then
        BattleDialog({EatMessage("Legendary Hero", 40)})
        Player.Heal(40)
        for i=1,#commands do
            if(commands[i] == "L. Hero x2") then
                commands[i] = "L. Hero"
                return
            end
        end
    elseif command == "L. HERO X3" then
        BattleDialog({EatMessage("Legendary Hero", 40)})
        Player.Heal(40)
        for i=1,#commands do
            if(commands[i] == "L. Hero x3") then
                commands[i] = "L. Hero x2"
                return
            end
        end
    elseif command == "L. HERO X4" then
        BattleDialog({EatMessage("Legendary Hero", 40)})
        Player.Heal(40)
        for i=1,#commands do
            if(commands[i] == "L. Hero x4") then
                commands[i] = "L. Hero x3"
                return
            end
        end
     end
end

function EatMessage(item, amount)
    local maxhp = 16 + (Player.lv * 4)
    local msg = "You recovered " .. amount .. " HP!"
    if(Player.hp + amount >= maxhp) then
        msg = "Your HP was maxed out."
    end
    return "[voice:ui]You ate the " .. item .. ".\n" .. msg
end

function RemoveCommand(name)
    for i=1,#commands do
        if(commands[i] == name) then
            table.remove(commands, i)
            return
        end
    end
end

function Lovekill()
    Player.Hurt(99)
end