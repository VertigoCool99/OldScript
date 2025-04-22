--Locals
local FetchItemModule = require(game:GetService("ReplicatedStorage").FetchItem)
local TycoonBase = game.Players.LocalPlayer.PlayerTycoon.Value.Base
local MyTycoon = game:GetService("Players").LocalPlayer.PlayerTycoon.Value
local MoneyLibary = require(game:GetService("ReplicatedStorage").MoneyLib)
local PlayersList = {}
local player = game.Players.LocalPlayer
local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local collectedBoxes = {}
local oldRebirths = game:GetService("Players").LocalPlayer.Rebirths.Value


local Settings = {AutoLoopUpgrader=false,LayoutCopierSelected="1",LayoutPlayerSelected="",ItemTracker=false,WebhookLink="",LoopPulse=false,AutoPulse=false,LoopRemoteDrop=false,AutoLoadSetup=false,LoadAfter=5,ShouldReload=false,LayoutSelected=1,AutoRebirth=false,LoopUpgrader=false,SelectedUpgrader="nil",SelectedFurnace="nil"}

--Functions
function GetUpgraders()
    tbl = {}
    for i,v in pairs(MyTycoon:GetChildren()) do
        if v:FindFirstChild("Model") and v.Model:FindFirstChild("Upgrade") then
            table.insert(tbl,v)
        elseif v:FindFirstChild("Model") and v.Model:FindFirstChild("Upgrader") then
            table.insert(tbl,v)
        elseif v:FindFirstChild("Model") and v.Model:FindFirstChild("Cannon") then
            table.insert(tbl,v)
        end
    end
    return tbl
end
function GetPlayers()
    table.clear(PlayersList)
    for i,v in pairs(game.Players:GetChildren()) do
        table.insert(PlayersList,v.Name)
    end
end
GetPlayers()
game.Players.PlayerAdded:Connect(function()
    GetPlayers()
end)
game.Players.PlayerRemoving:Connect(function()
    GetPlayers()
end)
function GetDropped()
    local tbl = {}
    for i,v in pairs(game:GetService("Workspace").DroppedParts[MyTycoon.Name]:GetChildren()) do
        if not string.find(v.Name,"Coal") then 
            table.insert(tbl,v)        
        end
    end
    return tbl
end
function ShopItems()
    for i,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v,"Miscs") then
            return v["All"]
        end
    end
end
function HasItem(Needed)
    if game:GetService("ReplicatedStorage").HasItem:InvokeServer(Needed) > 0 then
        return true
    end
    return false
end
function IsShopItem(Needed)
    for i,v in pairs(ShopItems()) do
        if tonumber(v.ItemId.Value) == tonumber(Needed) then
            return true
        end
    end
    return false
end
function GetMissingItems()
    local MissingTbl = {}
    for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:GetService("Players")[Settings.LayoutPlayerSelected].Layouts["Layout"..Settings.LayoutCopierSelected].Value)) do
        local ItemName = FetchItemModule.Get(nil,v["ItemId"]).Name
        if HasItem(v["ItemId"]) == false and IsShopItem(v["ItemId"]) == true then
            table.insert(MissingTbl,ItemName.." [Shop]")
        elseif HasItem(v["ItemId"]) == false and IsShopItem(v["ItemId"]) == false then
            table.insert(MissingTbl,ItemName)
        end
    end
    local MissingString
    if #MissingTbl > 0 then
        MissingString = table.concat(MissingTbl, "\n")
    else
        MissingString = "No Missing Items!"
    end
    return MissingString
end

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/VertigoCool99/282c9e98325f6b79299c800df74b2849/raw/d9efe72dc43a11b5237a43e2de71b7038e8bb37b/library.lua"))()

local Window = Library:CreateWindow({Title=" Miners Haven",TweenTime=.15,Center=true})
   
local MainTab = Window:AddTab("Main")
local LayoutsTab = Window:AddTab("Layouts")

--Ores
local OresTabbox = MainTab:AddLeftGroupbox("Ores")

local SelectedUpgraderTextbox = OresTabbox:AddInput("SelectedUpgraderTextbox",{Text = "Selected Upgrader";Default = "Upgrader",Numeric = false,Finished = true})
SelectedUpgraderTextbox:OnChanged(function(Value)
    Settings.SelectedUpgrader = Value
end)
local LoopUpgraderToggle = OresTabbox:AddToggle("LoopUpgrader",{Text = "Loop Upgrader",Default = false,Risky = false})
LoopUpgraderToggle:OnChanged(function(value)
    Settings.LoopUpgrader = value
    task.spawn(function()
        while Settings.LoopUpgrader do task.wait()
            if Settings.LoopUpgrader then
                for i,v in pairs(GetDropped()) do
                    task.spawn(function()
                        if MyTycoon:FindFirstChild(Settings.SelectedUpgrader) and MyTycoon[Settings.SelectedUpgrader].Model:FindFirstChild("Upgrade") then
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Upgrade,0)
                            task.wait()
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Upgrade,1)
                        elseif MyTycoon:FindFirstChild(Settings.SelectedUpgrader) and MyTycoon[Settings.SelectedUpgrader].Model:FindFirstChild("Upgrader") then
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Upgrader,0)
                            task.wait()
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Upgrader,1)
                        elseif MyTycoon:FindFirstChild(Settings.SelectedUpgrader) and MyTycoon[Settings.SelectedUpgrader].Model:FindFirstChild("Cannon") then
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Cannon,0)
                            task.wait()
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Cannon,1)
                        elseif MyTycoon:FindFirstChild(Settings.SelectedUpgrader) and MyTycoon[Settings.SelectedUpgrader].Model:FindFirstChild("Copy") then
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Copy,0)
                            task.wait()
                            firetouchinterest(v,MyTycoon[Settings.SelectedUpgrader].Model.Copy,1)
                        end
                    end)
                end
            end
        end
    end)
end)
local AutoLoopUpgraderToggle = OresTabbox:AddToggle("AutoLoopUpgraders",{Text = "Auto Loop Upgraders",Default = false,Risky = false})
AutoLoopUpgraderToggle:OnChanged(function(value)
    Settings.AutoLoopUpgraders = value
    task.spawn(function()
        while Settings.AutoLoopUpgraders do task.wait()
            if Settings.AutoLoopUpgraders then
                for i,v2 in pairs(GetDropped()) do
                    task.spawn(function()
                        for i2,v in pairs(GetUpgraders()) do
                            if v:FindFirstChild("Model") and v.Model:FindFirstChild("Upgrade") and v.Name ~= "Ore Illuminator" then
                                firetouchinterest(v2,v.Model.Upgrade,0)
                                task.wait()
                                firetouchinterest(v2,v.Model.Upgrade,1)
                            elseif v:FindFirstChild("Model") and v.Model:FindFirstChild("Upgrader") then
                                firetouchinterest(v2,v.Model.Upgrader,0)
                                task.wait()
                                firetouchinterest(v2,v.Model.Upgrader,1)
                            elseif v:FindFirstChild("Model") and v.Model:FindFirstChild("Cannon") then
                                firetouchinterest(v2,v.Model.Cannon,0)
                                task.wait()
                                firetouchinterest(v2,v.Model.Cannon,1)
                            elseif v:FindFirstChild("Model") and v.Model:FindFirstChild("Copy") then
                                firetouchinterest(v2,v.Copy,0)
                                task.wait()
                                firetouchinterest(v2,v,1)
                            end
                        end
                    end)
                end
            end
        end
    end)
end)
OresTabbox:AddDivider()
local SelectedFurnaceTextbox = OresTabbox:AddInput("SelectedFurnaceTextbox",{Text = "Selected Furnace";Default = "Furnace",Numeric = false,Finished = true})
SelectedFurnaceTextbox:OnChanged(function(Value)
    Settings.SelectedFurnace = Value
end)
local AutoSellOresToggle = OresTabbox:AddToggle("AutoLoopUpgraders",{Text = "Auto Sell Ore",Default = false,Risky = false})
AutoSellOresToggle:OnChanged(function(value)
    task.spawn(function()
        while value do task.wait()
            for i,v in pairs(GetDropped()) do
                task.spawn(function()
                    if MyTycoon:FindFirstChild(Settings.SelectedFurnace) then
                        firetouchinterest(v,MyTycoon[Settings.SelectedFurnace].Model.Lava,0)
                        task.wait()
                        firetouchinterest(v,MyTycoon[Settings.SelectedFurnace].Model.Lava,1)
                    end
                end)
            end
        end
    end)
end)
local SellOresButton = OresTabbox:AddButton({Text = "Sell Ores",Func = function()
    for i,v in pairs(GetDropped()) do
        task.spawn(function()
            if MyTycoon:FindFirstChild(Settings.SelectedFurnace) then
                firetouchinterest(v,MyTycoon[Settings.SelectedFurnace].Model.Lava,0)
                task.wait()
                firetouchinterest(v,MyTycoon[Settings.SelectedFurnace].Model.Lava,1)
            end
        end)
    end
end,})

--Rebirths
local RebirthTabbox = MainTab:AddRightGroupbox("Rebirths")

local AutoRebirthToggle = RebirthTabbox:AddToggle("AutoRebirth",{Text = "Auto Rebirth",Default = false,Risky = false})
AutoRebirthToggle:OnChanged(function(value)
    Settings.AutoRebirth = value
    task.spawn(function()
        while Settings.AutoRebirth do task.wait()
            if game:GetService("Players").LocalPlayer.PlayerGui.GUI.Money.Value >= MoneyLibary.RebornPrice(game:GetService("Players").LocalPlayer) and Settings.AutoRebirth  == true then
                if Toggles.ToggleAutoBoxes.Value == true and (game:GetService("Players").LocalPlayer.PlayerTycoon.Value:GetPivot().p - humanoidRootPart:GetPivot().p).Magnitude <= 150 then
                    repeat task.wait()
                        humanoidRootPart:PivotTo(game:GetService("Players").LocalPlayer.PlayerTycoon.Value:GetPivot())
                    until (game:GetService("Players").LocalPlayer.PlayerTycoon.Value:GetPivot().p - humanoidRootPart:GetPivot().p).Magnitude <= 150
                end
                if Settings.DelayRebirth == true then
                    task.delay(2,function()
                        game:GetService("ReplicatedStorage").Rebirth:InvokeServer(26)
                    end)
                else
                    game:GetService("ReplicatedStorage").Rebirth:InvokeServer(26)
                end
                if Settings.AutoLoadSetup == true then
                    game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load","Layout"..Settings.LayoutSelected)
                    if Settings.ShouldReload == true then
                        task.wait(Settings.LoadAfter)
                        game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load","Layout"..Settings.LayoutSelected)
                    end
                end
            end
        end
    end)
end)
local DelayRebirthToggle = RebirthTabbox:AddToggle("DelayRebirth",{Text = "Delay Rebirth",Default = false,Risky = false})
DelayRebirthToggle:OnChanged(function(value)
    Settings.DelayRebirth = value
end)
local AutoLoadSetupToggle = RebirthTabbox:AddToggle("AutoLoadSetup",{Text = "Auto Load Setup",Default = false,Risky = false})
AutoLoadSetupToggle:OnChanged(function(value)
    Settings.AutoLoadSetup = value
end)
local RebirthLayoutSelectedDrop = RebirthTabbox:AddDropdown("LayoutSelected",{Text = "Layout", AllowNull = false,Values = {1,2,3},Multi = false,Default=1})
RebirthLayoutSelectedDrop:OnChanged(function(Value)
    Settings.LayoutSelected = Value
end)
local AutoReloadLoadSetupToggle = RebirthTabbox:AddToggle("ShouldReload",{Text = "Reload Slot",Default = false,Risky = false})
AutoReloadLoadSetupToggle:OnChanged(function(value)
    Settings.ShouldReload = value
end)
local LoadAfterSlider = RebirthTabbox:AddSlider("LoadAfterSlider",{Text = "Reload Slot After (s)",Default = 5,Min = 1,Max = 60,Rounding = 0})
LoadAfterSlider:OnChanged(function(Value)
    Settings.LoadAfter = Value
end)


--Misc
local MiscTabbox = MainTab:AddLeftGroupbox("Misc")

local LoopProximtyPromptToggle = MiscTabbox:AddToggle("LoopProximtyPrompt",{Text = "Auto Proximity",Default = false,Risky = false})
LoopProximtyPromptToggle:OnChanged(function(value)
    Settings.LoopProximtyPrompt = value
    task.spawn(function()
        while Settings.LoopProximtyPrompt do task.wait()
            if Settings.LoopProximtyPrompt then
                for i,v in pairs(MyTycoon:GetChildren()) do
                    if string.find(v.Name,"Excavator") then
                       fireproximityprompt(v.Model.Internal.ProximityPrompt)
                    elseif v:FindFirstChild("Model"):FindFirstChild("Internal"):FindFirstChild("ProximityPrompt") then
                        fireproximityprompt(v.Model.Internal.ProximityPrompt)
                    end
                end
            end
        end
    end)
end)
local LoopRemoteDropToggle = MiscTabbox:AddToggle("LoopRemoteDrop",{Text = "Auto Remote",Default = false,Risky = false})
LoopRemoteDropToggle:OnChanged(function(value)
    Settings.LoopRemoteDrop = value
    task.spawn(function()
        while Settings.LoopRemoteDrop == true do task.wait()
            if Settings.LoopRemoteDrop == true then
                game:GetService("ReplicatedStorage").RemoteDrop:FireServer()
            end
        end
    end)
end)
local LoopPulseToggle = MiscTabbox:AddToggle("LoopPulse",{Text = "Auto Pulse",Default = false,Risky = false})
LoopPulseToggle:OnChanged(function(value)
    Settings.LoopPulse = value
    task.spawn(function()
        while Settings.LoopPulse == true do task.wait()
            if Settings.LoopPulse == true then
                game:GetService("ReplicatedStorage").Pulse:FireServer()
            end
        end
    end)
end)
local GetFreeDailyCrateButton = MiscTabbox:AddButton({Text = "Get Free Daily Crate",Func = function()
    firesignal(game:GetService("Players").LocalPlayer.PlayerGui.GUI.SpookMcDookShop.RedeemFrame.MouseButton1Click)
end,})
MiscTabbox:AddDivider()
local ToggleCraftsManToggle = MiscTabbox:AddToggle("ToggleCraftsManToggle",{Text = "Craftman Gui",Default = false,Risky = false})
ToggleCraftsManToggle:OnChanged(function(value)
    game:GetService("Players").LocalPlayer.PlayerGui.GUI.Craftsman.Visible = value
end)
local ToggleAutoBoxesToggle = MiscTabbox:AddToggle("ToggleAutoBoxes",{Text = "Auto Collect Boxes",Default = false,Risky = false})
ToggleAutoBoxesToggle:OnChanged(function(value)
    task.spawn(function()
        while value do task.wait(.2)
            if humanoidRootPart then
                for i, v in pairs(game:GetService("Workspace").Boxes:GetChildren()) do
                    local boxNames = {"Shadow", "Research", "Goldpot", "Golden", "Crystal", "Diamond", "Present","Lucky"}
                    if table.find(boxNames,v.Name) and not collectedBoxes[v] and v:FindFirstChild("TouchInterest") then
                        humanoidRootPart.Velocity = Vector3.zero
                        humanoidRootPart:PivotTo(v:GetPivot()*CFrame.new(0,-1,0))
                        firetouchinterest(humanoidRootPart,v,0)
                        if v:FindFirstChild("TouchInterest") then
                            firetouchinterest(humanoidRootPart,v,1)
                        end
                        if v.Transparency ~= 0.2 then
                            collectedBoxes[v] = nil
                        else
                            collectedBoxes[v] = true
                        end
                        task.wait(.2)
                        humanoidRootPart.Velocity = Vector3.zero
                        humanoidRootPart:PivotTo(v:GetPivot()*CFrame.new(0,-30,0))
                    end
                end
                humanoidRootPart.Velocity = Vector3.zero
                humanoidRootPart:PivotTo(TycoonBase:GetPivot()+Vector3.new(0,TycoonBase.Size.Y+2.5,0))
            end 
        end
    end)
end)
local GotoBaseButton = MiscTabbox:AddButton({Text = "Goto Base!",Func = function()
    humanoidRootPart.Velocity = Vector3.zero
    humanoidRootPart.CFrame = TycoonBase:GetPivot()+Vector3.new(0,TycoonBase.Size.Y+2.5,0)
end,})

--Webhook
local WebhookTabbox = MainTab:AddRightGroupbox("Webhook")

local WebhookLinkTextbox = WebhookTabbox:AddInput("WebhookLinkTextbox",{Text = "Link";Default = "Link",Numeric = false,Finished = true})
WebhookLinkTextbox:OnChanged(function(Value)
    Settings.WebhookLink = Value
end)
local ItemTrackerToggle = WebhookTabbox:AddToggle("ItemTrackerToggle",{Text = "Item Tracker",Default = false,Risky = false})
ItemTrackerToggle:OnChanged(function(value)
    Settings.ItemTracker = value
end)

--Event
local EventTabbox = MainTab:AddRightGroupbox("Event")
local AutoCloverToggle = EventTabbox:AddToggle("AutoCloverToggle",{Text = "Auto Clover",Default = false,Risky = false})
AutoCloverToggle:OnChanged(function(value)
    task.spawn(function()
        while value do task.wait(.2)
            if humanoidRootPart then
                for i,v in pairs(workspace.Clovers:GetChildren()) do
                    if v:FindFirstChild("ProximityPrompt") then
                        game.Players.LocalPlayer.Character:PivotTo(v:GetPivot())
                        task.wait(.2)
                        if v:FindFirstChild("ProximityPrompt") ~= nil then 
                            fireproximityprompt(v.ProximityPrompt)
                        end
                    end 
                end
                humanoidRootPart.Velocity = Vector3.zero
                humanoidRootPart:PivotTo(TycoonBase:GetPivot()+Vector3.new(0,TycoonBase.Size.Y+2.5,0))
            end 
        end
    end)
end)
local CloverGuiToggle = EventTabbox:AddToggle("CloverGuiToggle",{Text = "Clover Gui",Default = false,Risky = false})
CloverGuiToggle:OnChanged(function(value)
    game:GetService("Players").LocalPlayer.PlayerGui.GUI.Patrick.Visible = value
end)

--Fps
local FpsTabbox = MainTab:AddRightGroupbox("FPS")
local RenderingToggle = FpsTabbox:AddToggle("RenderingToggle",{Text = "Rendering",Default = true,Risky = false})
RenderingToggle:OnChanged(function(value)
    game:GetService("RunService"):Set3dRenderingEnabled(value)
end)

--Layouts           
local LayoutsGroup = LayoutsTab:AddLeftGroupbox("Layout Copier")
local LayoutsInfoGroup = LayoutsTab:AddRightGroupbox("Missing Items")
local LayoutPlayerSelectedDrop = LayoutsGroup:AddDropdown("LayoutPlayerSelected",{Text = "Player", AllowNull = false,Values = PlayersList,Multi = false,Default=PlayersList[1]})
LayoutPlayerSelectedDrop:OnChanged(function(Value)
    Settings.LayoutPlayerSelected = Value
end)
local LayoutCopierSelectedDrop = LayoutsGroup:AddDropdown("LayoutCopierSelected",{Text = "Layout", AllowNull = false,Values = {1,2,3},Multi = false,Default=1})
LayoutCopierSelectedDrop:OnChanged(function(Value)
    Settings.LayoutCopierSelected = Value
end)
local LayoutCopierLoadButton = LayoutsGroup:AddButton({Text = "Build Layout!",Func = function()
    if Settings.LayoutPlayerSelected == nil and Settings.LayoutCopierSelected == nil then return end
    for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:GetService("Players")[Settings.LayoutPlayerSelected].Layouts["Layout"..Settings.LayoutCopierSelected].Value)) do
        task.spawn(function()
            if HasItem(v["ItemId"]) == true then
                local TopLeft = TycoonBase.CFrame * CFrame.new(Vector3.new(TycoonBase.Size.X/2, 0, TycoonBase.Size.Z/2))
                local Position = TopLeft * Vector3.new(tonumber(v.Position[1]), tonumber(v.Position[2]), tonumber(v.Position[3]))
                local Rotation = Vector3.new(tonumber(v.Position[4]),tonumber(v.Position[5]),tonumber(v.Position[6]))
                local NewCf = CFrame.new(Position, Position + (Rotation * 5))
                game:GetService("ReplicatedStorage").PlaceItem:InvokeServer(FetchItemModule.Get(nil,v["ItemId"]).Name,NewCf,{TycoonBase})
                task.wait()
            elseif HasItem(v["ItemId"]) == false and IsShopItem(v["ItemId"]) == true and game:GetService("Players").LocalPlayer.PlayerGui.GUI.Money.Value >= game:GetService("ReplicatedStorage").Items[FetchItemModule.Get(nil,v["ItemId"]).Name].Cost.Value then
                game:GetService("ReplicatedStorage").BuyItem:InvokeServer(FetchItemModule.Get(nil,v["ItemId"]).Name,1)
                task.wait()
                local TopLeft = TycoonBase.CFrame * CFrame.new(Vector3.new(TycoonBase.Size.X/2, 0, TycoonBase.Size.Z/2))
                local Position = TopLeft * Vector3.new(tonumber(v.Position[1]), tonumber(v.Position[2]), tonumber(v.Position[3]))
                local Rotation = Vector3.new(tonumber(v.Position[4]),tonumber(v.Position[5]),tonumber(v.Position[6]))
                local NewCf = CFrame.new(Position, Position + (Rotation * 5))
                game:GetService("ReplicatedStorage").PlaceItem:InvokeServer(FetchItemModule.Get(nil,v["ItemId"]).Name,NewCf,{TycoonBase})
                task.wait()
            else
                if IsShopItem(v["ItemId"]) == true then
                    print("Cant Afford Item, "..FetchItemModule.Get(nil,v["ItemId"]).Name)
                else
                    print("Cant Find, "..FetchItemModule.Get(nil,v["ItemId"]).Name)
                end
            end
        end)
    end
end,})
local Label = LayoutsInfoGroup:AddLabel("LayoutInfoLabel",'No Layout Selected')
LayoutsInfoGroup:AddButton({Text = "Get Missing Items!",Func = function()
    if Settings.LayoutPlayerSelected == nil and Settings.LayoutCopierSelected == nil then return end
    Label:SetText(GetMissingItems())
end})

--Webhook Function
game.ReplicatedStorage.ItemObtained.OnClientEvent:Connect(function(Item,Amt)
    if Item and Amt and Settings.ItemTracker == true then
        
        local Tier = game.ReplicatedStorage.Tiers:FindFirstChild(tostring(Item.Tier.Value))
        local ImageId = Item.ThumbnailId.Value
        if Tier.TierName.Value == "Slipstream" then return end
        if string.find(ImageId,"rbxasset") then
           ImageId = string.split(tostring(Item.ThumbnailId.Value),"//")[2] 
        end
        local ImageData = game:GetService("HttpService"):JSONDecode(request({Url="https://thumbnails.roblox.com/v1/assets?assetIds="..tonumber(ImageId).."&returnPolicy=PlaceHolder&size=512x512&format=Png&isCircular=false"}).Body)
        local ImageLink = ImageData.data[1]["imageUrl"]
        local TierColor = Color3.new((Tier.TierColor.Value.r*0.7) + 0.2, (Tier.TierColor.Value.g*0.7) + 0.2, (Tier.TierColor.Value.b*0.7) + 0.2)
        local Data = {["embeds"]= {{
            ["title"] = "**New Item**",
            ["fields"] = {
                {
                    ["name"] = ":page_facing_up: **Item**",
                    ["value"] =  tostring("```\n"..Item.Name.."```"),
                    ["inline"] = true
                },
                {
                    ["name"] = (":arrow_up: **Tier**"),
                    ["value"] =  tostring("```\n"..Tier.TierName.Value.."```"),
                    ["inline"] = true
                },
                {
                    ["name"] = (":chart_with_upwards_trend:  **Total Quantity**"),
                    ["value"] =  tostring("```\n"..require(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Inventory.Inventory).localInventory[Item.ItemId.Value].Quantity.."```"),
                    ["inline"] = true
                },
                {
                    ["name"] = (":recycle: **Rebirth Data**"),
                    ["value"] =  tostring("```\nRebirth: "..tostring(game:GetService("Players").LocalPlayer.Rebirths.Value).." | Rebirths With PV: "..tostring(game:GetService("Players").LocalPlayer.Rebirths.Value-oldRebirths).."```"),
                    ["inline"] = false
                },
                {
                    ["name"] = (":link: **Item Info | Wiki**"),
                    ["value"] =  tostring("https://minershaven.fandom.com/wiki/"..Item.Name:gsub(" ", "_")),
                    ["inline"] = false
                },
            },

        ["color"] = tonumber("0x"..tostring(string.split((string.format("#%02X%02X%02X", TierColor.R * 0xFF,TierColor.G * 0xFF, TierColor.B * 0xFF)),"#")[2])),
        ["footer"] = {["text"] = "Project Vertigo | "..os.date()},
        ["thumbnail"] = {["url"]=tostring(ImageLink)}
        }}
    }
    
        request({Url = Settings.WebhookLink.."?wait=true", Body =  game:GetService("HttpService"):JSONEncode(Data), Method = "POST", Headers = {["content-type"] = "application/json"}})
    end
end)




Library:SetWatermark("Float.Balls [Miners Haven]")

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
    game:GetService("RunService"):Set3dRenderingEnabled(true)
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
Library.SaveManager:SetFolder('Test')
Library.SaveManager:BuildConfigSection(Settings)
--Settings End
