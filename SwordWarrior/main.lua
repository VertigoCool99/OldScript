--Bypasses
hookfunction(require(game:GetService("ReplicatedStorage").CurrentModule.PlayerFight).HackCheck,function()
	return nil
end)
local namecall; namecall = hookmetamethod(game, '__namecall', function(obj, ...)
    local args,method = {...},getnamecallmethod()
    if method == "FireServer" and obj.Name == 'MonsterEvent' and args[1] == "HackCheck" then
        args[3] = 0
    end
    return namecall(obj, unpack(args))
end)
--Locals
local oldTick = tick()

--Tables
local Settings = {
    MainFarm=false,InfiniteFarm=false,DrillMasterFarm=false,EventFarm=false,
    HitTimesPerS=10,
    AutoHealth=false,AutoDamage=false,AutoSpeed=false,AutoCrit=false,AutoSkills=false,AutoRebirth=false,
    SlashSpeed=false,SlashSpeedValue=0,
}

local newindex; newindex = hookmetamethod(game, '__newindex', function(obj, idx, val)
    if obj.Name == 'SlashSpeed' and idx == 'Value' then
        if Settings.SlashSpeed == true then
            val = Settings.SlashSpeedValue
        else
            val = 0
        end
    end
    return newindex(obj, idx, val)
end)


--Functions
function UpgradeSkill(Type)
    if tonumber(string.split(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.UpgradeFrame.Points.Text,":")[2]) > 0 then
        game:GetService("ReplicatedStorage"):WaitForChild("CurRemotes"):WaitForChild("DataChange_Points"):FireServer(unpack({[1] = "ClickPoints",[2] = {["Obj"] = Type,["Points"] = 1}} ))
    end
end

function GetMyMonstersMain()
    for i,v in pairs(game:GetService("Workspace").ForScript.Monster:GetDescendants()) do
		if v.Name == "Player" and v:IsA("Folder") and v:FindFirstChild(game.Players.LocalPlayer.Name) then
			return v.Parent.Monster_
        end
    end
end
function GetMyMonstersEternal()
    for i,v in pairs(game:GetService("Workspace").ForScript.InfiniteMap:GetDescendants()) do
		if v.Name == "Player" and v:IsA("Folder") and v:FindFirstChild(game.Players.LocalPlayer.Name) then
			return v.Parent.Monster_
        end
    end
end
function GetMyMonstersDrillMaster()
    for i,v in pairs(game:GetService("Workspace").ForScript.DrilRaid:GetDescendants()) do
		if v.Name == "Player" and v:IsA("Folder") and v:FindFirstChild(game.Players.LocalPlayer.Name) then
			return v.Parent.Monster_
        end
    end
end
function GetMyMonstersEvent()
	return game:GetService("Workspace").ForScript.SkibiMap.Monster_
end

function KillMonsters(MonsterFolder,HitTimes)
    HitTimes = HitTimes or 10
    if MonsterFolder then
        for i2,v2 in pairs(MonsterFolder:GetChildren()) do
            v2:PivotTo(game.Players.LocalPlayer.Character:GetPivot()*CFrame.new(0,0,-15))
            task.spawn(function()
                for i = 0,HitTimes do
                    task.spawn(function()
                        game:GetService("ReplicatedStorage").CurRemotes.MonsterEvent:FireServer("DamToMonster",v2,{["damtype"] = "normal"})
                    end)
                end
            end)
        end
    end
end

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/VertigoCool99/LoadScript/main/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({Title = 'Project Vertigo | Sword Warrior',Center = true, AutoShow = true,})

Library:SetWatermark('Project Vertigo | Sword Warrior')
Library:OnUnload(function() 
    Library.Unloaded = true
    for i,v in pairs(Toggles) do
        v:SetValue(false)
    end
end)

local Tabs = {["Auto Farm"]=Window:AddTab('Main'),['UI Settings'] = Window:AddTab('UI Settings')}

local AutoFarmsTab = Tabs['Auto Farm']:AddLeftGroupbox('Farming')
AutoFarmsTab:AddSlider('HitTimes', {Text='Times To Hit',Default=10,Min=1,Max=50,Rounding=0,Compact=false}):OnChanged(function(AttackTimes)
    Settings.HitTimesPerS = AttackTimes
end)
AutoFarmsTab:AddToggle('MainFarm', {Text='Main Farm',Default = false,Tooltip="Main Mobs In The Worlds"})
AutoFarmsTab:AddToggle('InfiniteFarm', {Text='Eternal Farm',Default = false,Tooltip="Eternal Arena Mobs"})
AutoFarmsTab:AddToggle('DrillMasterFarm', {Text='Drill Master Farm',Default = false,Tooltip="Drill Master Arena Mobs"})
AutoFarmsTab:AddToggle('EventFarm', {Text='EventFarm Farm',Default = false,Tooltip="Event Arena Mobs"})

Toggles.MainFarm:OnChanged(function(state)
    Settings.MainFarm = state
    task.spawn(function()
        while Settings.MainFarm == true do task.wait(.05)
            KillMonsters(GetMyMonstersMain(),Settings.HitTimesPerS)
        end
    end)
end)
Toggles.InfiniteFarm:OnChanged(function(state)
    Settings.InfiniteFarm = state
    task.spawn(function()
        if GetMyMonstersEternal() ~= nil then
            local Part = Instance.new("Part",workspace);Part.Size=Vector3.new(5,1,5);Part.Anchored=true;Part.Material=Enum.Material.ForceField;Part.Position=GetMyMonstersEternal().Parent.PlayerPoint.Born.Position+Vector3.new(70,60,0)
            game.Players.LocalPlayer.Character:PivotTo(Part:GetPivot()+Vector3.new(0,5,0))
        end
        while Settings.InfiniteFarm == true do task.wait(.05)
            KillMonsters(GetMyMonstersEternal(),Settings.HitTimesPerS)
        end
    end)
end)
Toggles.DrillMasterFarm:OnChanged(function(state)
    Settings.DrillMasterFarm = state
    task.spawn(function()
        while Settings.DrillMasterFarm == true do task.wait(.05)
            KillMonsters(GetMyMonstersDrillMaster(),Settings.HitTimesPerS)
        end
    end)
end)
Toggles.EventFarm:OnChanged(function(state)
    Settings.EventFarm = state
    task.spawn(function()
        while Settings.EventFarm == true do task.wait(.1)
            KillMonsters(GetMyMonstersEvent(),Settings.HitTimesPerS)
        end
    end)
end)
local AutoFarmsTab = Tabs['Auto Farm']:AddLeftGroupbox('Exploits')
AutoFarmsTab:AddToggle('SlashSpeed', {Text='Slash Speed',Default=false}):OnChanged(function(state)
    Settings.SlashSpeed = state
    game:GetService("Players").LocalPlayer.SlashSpeed.Value=1;task.wait();game:GetService("Players").LocalPlayer.SlashSpeed.Value=0
end)
AutoFarmsTab:AddSlider('SlashSpeedValue', {Text='Slash Speed',Default=0,Min=0,Max=70,Rounding=0,Compact=false}):OnChanged(function(SlashSpeedValue)
    Settings.SlashSpeedValue = SlashSpeedValue
    game:GetService("Players").LocalPlayer.SlashSpeed.Value=1;task.wait();game:GetService("Players").LocalPlayer.SlashSpeed.Value=0
end)

local SkillsTab = Tabs['Auto Farm']:AddRightGroupbox('Skills')
SkillsTab:AddToggle('HealthPoints', {Text='Health',Default=false}):OnChanged(function(state)
    Settings.AutoHealth = state
    task.spawn(function()
        while Settings.AutoHealth == true do task.wait(.05)
            UpgradeSkill("GHealth")
        end
    end)
end)
SkillsTab:AddToggle('DamagePoints', {Text='Attack',Default=false}):OnChanged(function(state)
    Settings.AutoDamage = state
    task.spawn(function()
        while Settings.AutoDamage == true do task.wait(.05)
            UpgradeSkill("GDamage")
        end
    end)
end)
SkillsTab:AddToggle('SpeedPoints', {Text='Speed',Default=false}):OnChanged(function(state)
    Settings.AutoSpeed = state
    task.spawn(function()
        while Settings.AutoSpeed == true do task.wait(.05)
            UpgradeSkill("GSpeed")
        end
    end)
end)
SkillsTab:AddToggle('CritPoints', {Text='Critical Hit',Default=false}):OnChanged(function(state)
    Settings.AutoCrit = state
    task.spawn(function()
        while Settings.AutoCrit == true do task.wait(.05)
            UpgradeSkill("GCriticalHit")
        end
    end)
end)
SkillsTab:AddDivider()
SkillsTab:AddToggle('Auto Rebirth', {Text='Auto Rebirth',Default=false}):OnChanged(function(state)
    Settings.AutoRebirth = state
    task.spawn(function()
        while Settings.AutoRebirth == true do task.wait(.05)
            game:GetService("ReplicatedStorage"):WaitForChild("CurRemotes"):WaitForChild("DataChange_Rebirth"):FireServer("rebirth")
        end
    end)
end)
SkillsTab:AddToggle('AfkDoPoints', {Text='Auto Skills',Default=false}):OnChanged(function(state)
    Settings.AutoSkills = state
    task.spawn(function()
        while Settings.AutoSkills == true do task.wait(.05)
            local CritPercent = tonumber(string.split(string.split(string.split(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.UpgradeFrame.main.GCriticalHit.pluspoint.Text,"+(")[2],")")[1],"%")[1])
            if CritPercent >= 100 then
                UpgradeSkill("GDamage")
            else
                UpgradeSkill("GCriticalHit")
            end
        end
    end)
end)


local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddToggle('Watermark', {Text="Watermark",Default=true}):OnChanged(function(newValue)
    Library:SetWatermarkVisibility(newValue)
end)
MenuGroup:AddToggle('KeybindFrame', {Text="Keybinds",Default=false}):OnChanged(function(newValue)
    Library.KeybindFrame.Visible = newValue
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('ProjectVertigo')
SaveManager:SetFolder('ProjectVertigo/SwordWarrior')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

Library:Notify("Loaded "..tostring(tick()-oldTick).."s",8)
