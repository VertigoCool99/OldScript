repeat task.wait() until game:IsLoaded()

--Locals
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Character = Players.LocalPlayer.Character
local WaitingToTp = false
local GreggCoin,RealCoin = false,nil
local oldTick = tick()
local BestDungeon,BestDiffculty = "nil","Insane"

--Tables
local Settings = {
    AutoFarm={Enabled=false,Delay=2,Distance=6,UseSkills=false,RaidFarm=false},
    Dungeon={Enabled=false,EnabledBest=false,Name="",Diffculty="",Mode="Normal",RaidEnabled=false,RaidName="",Tier="1"},
    AutoSell = {Enabled = false,Raritys = {},ItemTypes = {}};
    Misc={AutoRetry=false,GetGreggCoin=false},
    DebugMode=false,
}
local DungeonLevels = {
    ["0"] = {["Dungeon"] = "Desert Temple", ["Easy"] = 1, ["Medium"] = 5, ["Hard"] = 15},
    ["30"] = {["Dungeon"] = "Winter Outpost", ["Easy"] = 30, ["Medium"] = 40, ["Hard"] = 50},
    ["60"] = {["Dungeon"] = "Pirate Island", ["Insane"] = 60, ["Nightmare"] = 65},
    ["70"] = {["Dungeon"] = "King's Castle", ["Insane"] = 70, ["Nightmare"] = 75},
    ["80"] = {["Dungeon"] = "The Underworld", ["Insane"] = 80, ["Nightmare"] = 85},
    ["90"] = {["Dungeon"] = "Samurai Palace", ["Insane"] = 90, ["Nightmare"] = 95},
    ["100"] = {["Dungeon"] = "The Canals", ["Insane"] = 100, ["Nightmare"] = 105},
    ["110"] = {["Dungeon"] = "Ghastly Harbor", ["Insane"] = 110, ["Nightmare"] = 115},
    ["120"] = {["Dungeon"] = "Steampunk Sewers", ["Insane"] = 120, ["Nightmare"] = 125},
    ["135"] = {["Dungeon"] = "Orbital Outpost", ["Insane"] = 135, ["Nightmare"] = 140},
    ["150"] = {["Dungeon"] = "Volcanic Chambers", ["Insane"] = 150, ["Nightmare"] = 155},   
    ["160"] = {["Dungeon"] = "Aquatic Temple", ["Insane"] = 160, ["Nightmare"] = 165},
    ["170"] = {["Dungeon"] = "Enchanted Forest", ["Insane"] = 170, ["Nightmare"] = 175},
    ["180"] = {["Dungeon"] = "Northern Lands", ["Insane"] = 180, ["Nightmare"] = 185},
    ["190"] = {["Dungeon"] = "Gilded Skies", ["Insane"] = 190, ["Nightmare"] = 195},
    ["200"] = {["Dungeon"] = "Yokai Peak", ["Insane"] = 200, ["Nightmare"] = 205},
    ["210"] = {["Dungeon"] = "Abyssal Void", ["Insane"] = 210, ["Nightmare"] = 215},
}
local Raritys = {
    ["Legendary"]=Color3.fromRGB(244, 154, 9);
    ["Epic"]=Color3.fromRGB(146, 70, 159);
    ["Rare"]=Color3.fromRGB(75, 77, 195);
    ["Uncommon"]=Color3.fromRGB(91, 194, 80);
    ["Common"]=Color3.fromRGB(152, 152, 152);
}
local Functions = {}

--Functions
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    repeat task.wait() until Character:FindFirstChild("HumanoidRootPart")
    Players.LocalPlayer.Character.Head.playerNameplate.PlayerName.Text = "Float.balls"
    Players.LocalPlayer.Character.Head.playerNameplate.Title.Text="🤖"
end)

function Functions:GetInventoryItems()
    local tbl = {}
    for i,v in pairs(Players.LocalPlayer.PlayerGui.sellShop.Frame.innerFrame.rightSideFrame.ScrollingFrame:GetChildren()) do
        if v:IsA("ImageLabel") and v:FindFirstChild("itemType") and v.itemType:FindFirstChild("uniqueItemNum") then
            local Item = {["index"]=v:FindFirstChild("itemType"):FindFirstChild("uniqueItemNum").Value,["rarity"]="";["itemType"]=v:FindFirstChild("itemType").Value}
            for i2,v2 in pairs(Raritys) do
                if v.ImageColor3 == v2 then
                    Item["rarity"] = i2
                end
            end
            table.insert(tbl,Item)
        end
    end
    return tbl
end
function Functions:DoSkills(RepeatCount)
    for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if v.cooldown.Value then
            for i2,v2 in pairs(v:GetChildren()) do
                if v2.Name == "abilityEvent" or v2.Name == "spellEvent" then
                    for i = 0,RepeatCount do task.wait()
                        task.spawn(function()
                            v2:FireServer()
                        end)
                    end 
                end
            end
            task.wait()
        end
    end
end
function Functions:Teleport(Cframe)
    if not Character:FindFirstChild("HumanoidRootPart") then return end
    if WaitingToTp == true then return end
    local bodyPosition = Character.HumanoidRootPart:FindFirstAncestorOfClass("BodyPosition")
    local bodyGyro = Character.HumanoidRootPart:FindFirstAncestorOfClass("BodyGyro")
    if not Character.HumanoidRootPart:FindFirstAncestorOfClass("BodyGyro") then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000);bodyGyro.CFrame = Character.HumanoidRootPart.CFrame;bodyGyro.D = 250;bodyGyro.Parent = Character.HumanoidRootPart
    end
    if not Character.HumanoidRootPart:FindFirstAncestorOfClass("BodyPosition") then
        bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000);bodyPosition.Position = Cframe.Position;bodyPosition.D = 300;bodyPosition.Parent = Character.HumanoidRootPart;Character.HumanoidRootPart.Velocity = Vector3.zero
    end
    local oldTime = tick()
    WaitingToTp = true
    Character.HumanoidRootPart.Anchored = false
    repeat task.wait()
        if Character:FindFirstChild("HumanoidRootPart") and bodyPosition ~= nil and bodyGyro ~= nil then
            Character:PivotTo(Cframe + Vector3.new(0, Settings.AutoFarm.Distance * 2, 0))
            bodyPosition.Position = Cframe.Position + Vector3.new(0, Settings.AutoFarm.Distance * 2, 0)
            bodyGyro.CFrame = CFrame.new(Character:GetPivot().p, Cframe.Position) * CFrame.Angles(math.rad(90), 0, 0)
        end
    until tick() - oldTime >= Settings.AutoFarm.Delay or not Character:FindFirstChild("HumanoidRootPart")
    WaitingToTp = false
    if Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.Anchored = true
        bodyPosition:Destroy();bodyGyro:Destroy()
    end
end


function Functions:GetEnemys()
    if not workspace:FindFirstChild("dungeon") then 
        return workspace:FindFirstChild("enemies"):GetChildren()
    end
    for i, v in pairs(workspace.dungeon:GetChildren()) do
        if v:FindFirstChild("enemyFolder") and v.enemyFolder:FindFirstChildOfClass("Model") then
            return v.enemyFolder:GetChildren()
        end
    end
    return nil
end
function Functions:GetClosestEnemy()
    if not Character:FindFirstChild("HumanoidRootPart") then return end
    if Functions:GetEnemys() == nil then return end

    local closestEnemy = nil
    local highestHealthEnemy = nil
    local shortestDistance = math.huge
    local maxHealth = -math.huge
    for _, v in pairs(Functions:GetEnemys()) do
        local enemyPosition = v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.Position
        local enemyHumanoid = v:FindFirstChild("Humanoid")
        if enemyPosition and enemyHumanoid then
            local distance = (Character.HumanoidRootPart.Position - enemyPosition).Magnitude
            if distance < shortestDistance or (distance == shortestDistance and enemyHumanoid.MaxHealth > maxHealth) then
                shortestDistance = distance
                closestEnemy = v
                maxHealth = enemyHumanoid.MaxHealth
            end
        end
    end

    return closestEnemy
end
function Functions:GetBestDungeon()
    local highestLevelDungeon = 0
    for i, v in pairs(DungeonLevels) do
        if Players.LocalPlayer.leaderstats.Level.Value >= tonumber(i) then
            if tonumber(i) > highestLevelDungeon then
                highestLevelDungeon = tonumber(i)
                if v["Nightmare"] and Players.LocalPlayer.leaderstats.Level.Value >= v["Nightmare"] then
                    BestDungeon = v["Dungeon"];BestDifficulty = "Nightmare"
                elseif v["Insane"] and Players.LocalPlayer.leaderstats.Level.Value >= v["Insane"] then
                    BestDungeon = v["Dungeon"];BestDifficulty = "Insane"
                elseif v["Hard"] and Players.LocalPlayer.leaderstats.Level.Value >= v["Hard"] then
                    BestDungeon = v["Dungeon"];BestDifficulty = "Hard"
                elseif v["Medium"] and Players.LocalPlayer.leaderstats.Level.Value >= v["Medium"] then
                    BestDungeon = v["Dungeon"];BestDifficulty = "Medium"
                elseif v["Easy"] and Players.LocalPlayer.leaderstats.Level.Value >= v["Easy"] then
                    BestDungeon = v["Dungeon"];BestDifficulty = "Easy"
                end
            end
        end
    end
end
--Librarys
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/VertigoCool99/282c9e98325f6b79299c800df74b2849/raw/d9efe72dc43a11b5237a43e2de71b7038e8bb37b/library.lua"))()

local Window = Library:CreateWindow({Title=" Dungeon Quest",TweenTime=.15,Center=true})
   
local FarmingTab = Window:AddTab("Farming")
local MiscTab = Window:AddTab("Misc")

local NormalFarm = FarmingTab:AddLeftGroupbox("Auto Farm")
local DungeonCreateGroup = FarmingTab:AddRightGroupbox("Dungeon Creation")
local SettingsGroup = FarmingTab:AddLeftGroupbox("Settings")
local AutoSellGroup = MiscTab:AddLeftGroupbox("Auto Sell")

--Farming Start
local NormalFarmToggle = NormalFarm:AddToggle("NormalFarmToggle",{Text = "Enabled",Default = false,Risky = false})
NormalFarmToggle:OnChanged(function(value)
    Settings.AutoFarm.Enabled = value
end)
local UseSkillsToggle = NormalFarm:AddToggle("UseSkillsToggle",{Text = "Use Skills",Default = false,Risky = false})
UseSkillsToggle:OnChanged(function(value)
    Settings.AutoFarm.UseSkills = value
end)
NormalFarm:AddDivider()
local TeleportDelaySlider = NormalFarm:AddSlider("TeleportDelaySlider",{Text = "Teleport Delay",Default = 2,Min = 1,Max = 4,Rounding = 1})
TeleportDelaySlider:OnChanged(function(Value)
    Settings.AutoFarm.Delay = Value
end)
local DistanceSlider = NormalFarm:AddSlider("DistanceSlider",{Text = "Distance",Default = 6,Min = 0,Max = 10,Rounding = 0})
DistanceSlider:OnChanged(function(Value)
    Settings.AutoFarm.Distance = Value
end)
--Farming End
--DungeonCreateGroup Start
local AutoCreateBestToggle = DungeonCreateGroup:AddToggle("AutoCreateBestToggle",{Text = "Auto Create Best",Default = false,Risky = false})
AutoCreateBestToggle:OnChanged(function(value)
    Settings.Dungeon.EnabledBest = value
end)
local AutoCreateToggle = DungeonCreateGroup:AddToggle("AutoCreateToggle",{Text = "Auto Create",Default = false,Risky = false})
AutoCreateToggle:OnChanged(function(value)
    Settings.Dungeon.Enabled = value
end)
local AutoCreateDungeonNameDrop = DungeonCreateGroup:AddDropdown("AutoCreateDungeonNameDrop",{Text = "Dungeon", AllowNull = false,Values = {"Desert Temple","Winter Outpost","Pirate Island","King's Castle","The Underworld","Samurai Palace","The Canals","Ghastly Harbor","Steampunk Sewers","Orbital Outpost","Volcanic Chambers","Aquatic Temple","Enchanted Forest","Northen Lands","Gilded Skies","Yokai Peak","Abyssal Void"},Default=BestDungeon,Multi = false,})
AutoCreateDungeonNameDrop:OnChanged(function(Value)
    Settings.Dungeon.Name = Value
end)
local AutoCreateDungeonDiffcultyDrop = DungeonCreateGroup:AddDropdown("AutoCreateDungeonDiffcultyDrop",{Text = "Diffculty", AllowNull = false,Values = {"Insane","Nightmare"},Default=BestDiffculty,Multi = false,})
AutoCreateDungeonDiffcultyDrop:OnChanged(function(Value)
    Settings.Dungeon.Diffculty = Value
end)
local AutoCreateDungeonModeDrop = DungeonCreateGroup:AddDropdown("AutoCreateDungeonModeDrop",{Text = "Mode", AllowNull = false,Values = {"Normal","Hardcore"},Default="Normal",Multi = false,})
AutoCreateDungeonModeDrop:OnChanged(function(Value)
    Settings.Dungeon.Mode = Value
end)
DungeonCreateGroup:AddDivider()
local AutoCreateRaidToggle = DungeonCreateGroup:AddToggle("AutoCreateRaidToggle",{Text = "Auto Create Raid",Default = false,Risky = false})
AutoCreateRaidToggle:OnChanged(function(value)
    Settings.Dungeon.RaidEnabled = value
end)
local AutoCreateDungeonNameRaidDrop = DungeonCreateGroup:AddDropdown("AutoCreateDungeonNameRaidDrop",{Text = "Raid Dungeon", AllowNull = false,Values = {"Hela Raid","Goliath Raid"},Default=BestDungeon,Multi = false,})
AutoCreateDungeonNameRaidDrop:OnChanged(function(Value)
    Settings.Dungeon.RaidName = Value
end)
local AutoCreateDungeonTierDrop = DungeonCreateGroup:AddDropdown("AutoCreateDungeonTierDrop",{Text = "Tier", AllowNull = false,Values = {"1","2","3","4","5"},Default="1",Multi = false,})
AutoCreateDungeonTierDrop:OnChanged(function(Value)
    Settings.Dungeon.Tier = Value
end)


--DungeonCreateGroup End
--Settings Group Start
local AutoRetryToggle = SettingsGroup:AddToggle("AutoRetryToggle",{Text = "Auto Retry",Default = false,Risky = false})
AutoRetryToggle:OnChanged(function(value)
    Settings.Misc.AutoRetry = value
end)
local RaidFarmToggle = SettingsGroup:AddToggle("RaidFarmToggle",{Text = "Raid Farm",Default = false,Risky = false})
RaidFarmToggle:OnChanged(function(value)
    Settings.AutoFarm.RaidFarm = value
end)
Players.LocalPlayer.PlayerGui:WaitForChild("RetryVote").Changed:Connect(function(change)
    if change == "Enabled" and Settings.Misc.AutoRetry == true then
        game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer({[1] = {["\3"] = "vote",["vote"] = true},[2] = "/"})    
    end
end)
local GetGreggCoinToggle = SettingsGroup:AddToggle("GetGreggCoin",{Text = "Get Gregg Coin",Default = false,Risky = false})
GetGreggCoinToggle:OnChanged(function(value)
    Settings.Misc.GetGreggCoin = value
end)
--Settings Group End
--Auto Sell Start
local AutoSellEnabledToggle = AutoSellGroup:AddToggle("AutoSellEnabledToggle",{Text = "Auto Sell",Default = false,Risky = false})
AutoSellEnabledToggle:AddTooltip("This Will Sell All Selected Raritys!")
AutoSellEnabledToggle:OnChanged(function(value)
    Settings.AutoSell.Enabled = value
end)
local AutoSellItemTypeDrop = AutoSellGroup:AddDropdown("AutoCreateDungeonTierDrop",{Text = "Item Type", AllowNull = false,Values = {"weapon","ability","ring","helmet","chest"},Default={""},Multi = true,})
AutoSellItemTypeDrop:OnChanged(function(Value)
    table.clear(Settings.AutoSell.ItemTypes)
    for i, v in pairs(Value) do
        if v == true then
            table.insert(Settings.AutoSell.ItemTypes,i)
        end
    end
end)
local AutoSellRarirtyDrop = AutoSellGroup:AddDropdown("AutoCreateDungeonTierDrop",{Text = "Raritys", AllowNull = false,Values = {"Ultimate","Legendary","Epic","Rare","Uncommon","Common"},Default={""},Multi = true,})
AutoSellRarirtyDrop:OnChanged(function(Value)
    table.clear(Settings.AutoSell.Raritys)
    for i, v in pairs(Value) do
        if v == true then
            table.insert(Settings.AutoSell.Raritys,i)
        end
    end
end)

--Auto Sell End

--Connections
task.spawn(function()
    while true do task.wait(.05)
        if Settings.AutoSell.Enabled == true then
            local args = {["chest"] = {},["helmet"] = {},["ability"] = {},["ring"] = {},["weapon"] = {}}
            local counters = {["chest"] = 0, ["helmet"] = 0, ["ability"] = 0, ["ring"] = 1, ["weapon"] = 0}
            for i,v in pairs(Functions:GetInventoryItems()) do
                if table.find(Settings.AutoSell.ItemTypes,v["itemType"]) and table.find(Settings.AutoSell.Raritys,v["rarity"]) then
                    counters[v["itemType"]] = counters[v["itemType"]] + 1
                    args[v["itemType"]][counters[v["itemType"]]] = tonumber(v["index"])
                end
            end 
            game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("sellItemEvent"):FireServer(args)
        end
        if workspace:FindFirstChild("CharacterSelectScene") and Settings.Dungeon.Enabled == true then
            local DunArgs = {[1] = {[1] = {[1] = "\1",[2] = {["\3"] = "PlaySolo",["partyData"] = {
                                ["difficulty"] = Settings.Dungeon.Diffculty,
                                ["mode"] = Settings.Dungeon.Mode,
                                ["dungeonName"] = Settings.Dungeon.Name,
                                ["tier"] = 1,
                            }}},[2] = "d"}}
            game:GetService("ReplicatedStorage"):WaitForChild("dataRemoteEvent"):FireServer(unpack(DunArgs))
        elseif workspace:FindFirstChild("CharacterSelectScene") and Settings.Dungeon.RaidEnabled == true then
            local RaidArgs = {[1] = {[1] = {[1] = "\1",[2] = {["\3"] = "PlaySolo",["partyData"] = {
                                ["difficulty"] = "Nightmare",
                                ["minimumJoinLevel"] = 0,
                                ["tier"] = Settings.Dungeon.Tier,
                                ["dungeonName"] = Settings.Dungeon.RaidName,
                                ["mode"] = "Raid",
                                ["visibility"] = "Public",
                                ["maxPlayers"] = 40
                            }}},[2] = "d"}}
            game:GetService("ReplicatedStorage"):WaitForChild("dataRemoteEvent"):FireServer(unpack(RaidArgs))
        elseif Settings.Dungeon.EnabledBest == true then
            local DunArgs = {[1] = {[1] = {[1] = "\1",[2] = {["\3"] = "PlaySolo",["partyData"] = {
                ["difficulty"] = BestDiffculty,
                ["mode"] = "Normal",
                ["dungeonName"] = BestDungeon,
                ["tier"] = 1,
            }}},[2] = "d"}}
            game:GetService("ReplicatedStorage"):WaitForChild("dataRemoteEvent"):FireServer(unpack(DunArgs))
        end
        if not workspace:FindFirstChild("CharacterSelectScene") and Settings.AutoFarm.Enabled == true and Character == Players.LocalPlayer.Character and Character:FindFirstChild("HumanoidRootPart") then
            if Players.LocalPlayer.PlayerGui.HUD.Main.StartButton.Visible == true or Players.LocalPlayer.PlayerGui.RaidReadyCheck.Enabled == true then
                game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer({[1] = {[utf8.char(3)] = "vote",["vote"] = true},[2] = utf8.char(28)})
                game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer(unpack({[1] = {["\3"] = "raidReady"},[2] = ";"}))     
                game:GetService("ReplicatedStorage").remotes.changeStartValue:FireServer()         
                game:GetService("ReplicatedStorage"):WaitForChild("Utility"):WaitForChild("AssetRequester"):WaitForChild("Remote"):InvokeServer({[1] = "ui",[2] = "raidTimeLeftGui"})                  
            end
            if Settings.AutoFarm.UseSkills == true then
                Functions:DoSkills(25)
            end
            if Settings.Misc.GetGreggCoin == true and GreggCoin == true and RealCoin ~= nil then
                Functions:Teleport(RealCoin:GetPivot()-Vector3.new(0,Settings.AutoFarm.Distance*2,0))
                GreggCoin = false;RealCoin=nil
            end
            local Enemy = Functions:GetClosestEnemy()
            if GreggCoin == false and Enemy ~= nil then
                Functions:Teleport(Functions:GetClosestEnemy():GetPivot())
            end
        end
    end 
end)

workspace.ChildAdded:Connect(function(child)
    if Settings.DebugMode == false then
        if child:IsA("Part") and child.Name == "pulseWavesWave" then
            child:Destroy()
        elseif child:IsA("MeshPart") and child.Name == "groundAura" then
            child:Destroy()
        elseif child:IsA("Model") and child.Name == "pulseWavesHitbox" then
            child:Destroy()
        end 
    end
end)

--Settings Start
local Settings = Window:AddTab("Settings")
local SettingsUI = Settings:AddLeftGroupbox("UI")
local SettingsUnloadButton = SettingsUI:AddButton({Text="Unload",Func=function()
    Library:Unload()
end})
local SettingsMenuLabel = SettingsUI:AddLabel("SettingsMenuKeybindLabel","Menu Keybind")
local SettingsMenuKeyPicker = SettingsMenuLabel:AddKeyPicker("SettingsMenuKeyBind",{Default="Insert",IgnoreKeybindFrame=true})
Library.Options["SettingsMenuKeyBind"]:OnClick(function()
    Library:Toggle()
    Library:Notify({Title="Float.balls";Text=string.format('Press Ins To Open The UI');Duration=5})
end)
local SettingsNotiPositionDropdown = SettingsUI:AddDropdown("SettingsNotiPositionDropdown",{Text="Notification Position",Values={"Top_Left","Top_Right","Bottom_Left","Bottom_Right"},Default="Top_Left"})
SettingsNotiPositionDropdown:OnChanged(function(Value)
    Library.NotificationPosition = Value
end)

Library.ThemeManager:SetLibrary(Library)
Library.SaveManager:SetLibrary(Library)
Library.ThemeManager:ApplyToTab(Settings)
Library.SaveManager:IgnoreThemeSettings()
Library.SaveManager:SetIgnoreIndexes({"MenuKeybind","BackgroundColor", "ActiveColor", "ItemBorderColor", "ItemBackgroundColor", "TextColor" , "DisabledTextColor", "RiskyColor"})
Library.SaveManager:SetFolder('DungeonQuest')
Library.SaveManager:BuildConfigSection(Settings)
Library.KeybindContainer.Visible = false
Library.SaveManager:LoadAutoloadConfig()
--Settings End

--Init
Players.LocalPlayer.PlayerGui.rewardGuiHolder.holder.ChildAdded:Connect(function()
    if Settings.AutoFarm.RaidFarm == true then
        game:GetService("TeleportService"):Teleport(2414851778,game.Players.LocalPlayer)
    end
end)
Players.LocalPlayer.PlayerGui.cutscene.Changed:Connect(function(change)
    if change == "Enabled" then
        game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer({[1] = {["\3"] = "skip"},[2] = "\184"})        
    end
end)
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Coin" then
        GreggCoin = true;RealCoin = child
    end
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    game:GetService("TeleportService"):Teleport(2414851778,game.Players.LocalPlayer)
end)

Library:Notify({Title="Loaded";Text=string.format('Loaded In '..(tick()-oldTick));Duration=5})

if queue_on_teleport ~= nil then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/VertigoCool99/Script/refs/heads/main/Dungeon%20Quest/Ui.lua"))()')
end

Players.LocalPlayer.PlayerGui.HUD.Main.PlayerStatus.PlayerStatus.Portrait.Frame.ImageLabel.Visible = false
Players.LocalPlayer.PlayerGui.HUD.Main.PlayerStatus.PlayerStatus.PlayerName.Text = "Float.balls"
Players.LocalPlayer.Character.Head.playerNameplate.PlayerName.Text = "Float.balls"
Players.LocalPlayer.Character.Head.playerNameplate.Title.Text="🤖"

repeat task.wait() until Character:FindFirstChild("HumanoidRootPart")
Functions:GetBestDungeon()
