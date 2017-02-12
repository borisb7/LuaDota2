local defend= {}

defend.optionEnable = Menu.AddOption({ "Utility", "Defend"}, "Enable", "defend")
--defend.fontSize = Menu.AddOption({ "Awareness", "Show defend Count"}, "Font Size", "", 20, 50, 10)
defend.optionDaggerEnable = Menu.AddOption({ "Utility","Defend"}, "Use Dagger","")
defend.optionHurricanEnable = Menu.AddOption({ "Utility","Defend"}, "Use Hurirrican","")
defend.font = Renderer.LoadFont("Tahoma", 30, Enum.FontWeight.EXTRABOLD)

function defend.OnUpdate()
    if not Menu.IsEnabled(defend.optionEnable) then return end
    local myHero = Heroes.GetLocal()
    local myTeam = Entity.GetTeamNum(myHero)
    if myHero == nill then return end
     -- Log.Write(NPC.GetAbsOrigin(myHero):GetX().." X")
     -- Log.Write(NPC.GetAbsOrigin(myHero):GetY().." Y")
     -- Log.Write(NPC.GetAbsOrigin(myHero):GetZ().." Z")
     -- Log.Write(Entity.GetTeamNum(myHero).."teamNum")
    local myDagger = NPC.GetItem(myHero,"item_blink")
    local hurrican = NPC.GetItem(myHero,"item_hurricane_pike")
    for i= 1, Heroes.Count() do
        local enemy = Heroes.Get(i)
        local sameTeam = Entity.GetTeamNum(enemy) == myTeam
        if not sameTeam and not NPC.IsDormant(enemy) and Entity.GetHealth(enemy) > 0 then
            local dagger = NPC.GetItem(enemy,"item_blink")
            if dagger and Ability.GetCooldownLength(dagger) > 4 and Ability.SecondsSinceLastUse(dagger)<=1 and Ability.SecondsSinceLastUse(dagger)>0 then
                if Menu.IsEnabled(defend.optionDaggerEnable) and myDagger and Ability.IsReady(myDagger) then              
                    if myTeam == 2 then
                        defend.useDagger(myHero, myDagger,Vector(-7327.4375,-6820.78125,512))
                    else
                        defend.useDagger(myHero, myDagger,Vector(-7267.6562,6560.25,512))
                    end 
                end
                local myMana = NPC.GetMana(myHero)
                if Menu.IsEnabled(defend.optionHurricanEnable) and hurrican and Ability.IsCastable(hurrican, myMana) then
                    Ability.CastTarget(hurrican, enemy)
                end 
            end 
        end 
    end 
end

function defend.useDagger(myHero, dagger, vector)
    if dagger == nill or not Ability.IsReady(dagger) then return end 
    local dir = vector - NPC.GetAbsOrigin(myHero)
    dir:SetZ(0)
    dir:Normalize()
    dir:Scale(1199)
    local destination = NPC.GetAbsOrigin(myHero) + dir
    Ability.CastPosition(dagger, vector)
end
return defend