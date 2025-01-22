--Locals
local workspace = cloneref(game:GetService("Workspace"))
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

--Tables
local Settings = {
    Aimbot = {Enabled=false,HitPart="Head"};
    Exploits = {NoRecoil=true,};
}

--Librarys
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/VertigoCool99/282c9e98325f6b79299c800df74b2849/raw/d9efe72dc43a11b5237a43e2de71b7038e8bb37b/library.lua"))()
local AimbotLibrary,AimbotLibraryFunctions = loadstring(game:HttpGet("https://gist.githubusercontent.com/VertigoCool99/fa9c704473a4ba2014733a9f200febed/raw/eccf4858d07cb0a724da7d615e7ca9e117d71656/AimLibrary.lua"))()
local EspLibrary,EspLibraryFunctions = loadstring(game:HttpGet("https://gist.githubusercontent.com/VertigoCool99/2bcff189f55663147f8d63cb5b2012d9/raw/e4489b7e9c0e2e3e708a0c4f18bd00d47b9cbca5/EspLibrary.lua"))()

local Window = Library:CreateWindow({Title=" Town",TweenTime=.15,Center=true})
   
local AimbotTab = Window:AddTab("Aimbot")
local VisualsTab = Window:AddTab("Visuals")
local MiscTab = Window:AddTab("Misc")

local AimbotGroup = AimbotTab:AddLeftGroupbox("Aimbot")
local FovGroup = AimbotTab:AddRightGroupbox("Fov")
local PlayersVisualGroupbox = VisualsTab:AddLeftGroupbox("Players")
local ExploitsGroupbox = MiscTab:AddLeftGroupbox("Exploits")

--Start Aimbot
local AimbotToggle = AimbotGroup:AddToggle("AimbotToggle",{Text = "Enabled",Default = false,Risky = false})
AimbotToggle:OnChanged(function(value)
    Settings.Aimbot.Enabled = value
end)
local AimbotToggleKeyPicker = AimbotToggle:AddKeyPicker("AimbotToggleKeyPicker",{Default = "MB2",Mode = "Hold",SyncToggleState = false})
Library.Options["AimbotToggleKeyPicker"]:OnClick(function(Value)
    AimbotLibrary.Vars.Aiming = Value
end)

local SensitivitySlider = AimbotGroup:AddSlider("SensitivitySlider",{Text = "Sensitivity",Default = 30,Min = 0,Max = 100,Rounding = 0})
SensitivitySlider:OnChanged(function(Value)
    AimbotLibrary.GeneralSettings.Sensitivity = Value
end)

local HitPartDropdown = AimbotGroup:AddDropdown("HitPartDropdown",{Text = "HitPart", Default="Head",Values = {"Head","Torso","Right Leg","Left Leg","Left Arm","Right Arm"},Multi = false,})
HitPartDropdown:OnChanged(function(Value)
    Settings.HitPart = Value
end)
--End Aimbot



--Start Fov
local FovEnabled = FovGroup:AddToggle("FovEnabled",{Text = "Enabled",Default = false,Risky = false})
FovEnabled:OnChanged(function(value)
    AimbotLibrary.Fov.Enabled = value
end)
local FovEnabledColorPicker = FovEnabled:AddColorPicker("FovEnabledColorPicker",{Default = Color3.fromRGB(255,55,65);Rainbow = false})
FovEnabledColorPicker:OnChanged(function(Color)
    AimbotLibrary.Fov.Color = Color
end)
local FovSizeSlider = FovGroup:AddSlider("FovSizeSlider",{Text = "Size",Default = 90,Min = 2,Max = 300,Rounding = 0})
FovSizeSlider:OnChanged(function(Value)
    AimbotLibrary.Fov.FovSize=tonumber(Value)
end)
local FovPosDropdown = FovGroup:AddDropdown("FovPosDropdown",{Text = "Fov Position", Default="Mouse",Values = {"Screen","Mouse"},Multi = false,})
FovPosDropdown:OnChanged(function(Value)
    AimbotLibrary.Fov.FovPositionType=Value
end)
local SnaplineEnabledToggle = FovGroup:AddToggle("SnaplineEnabledToggle",{Text = "Snapline Enabled",Default = false,Risky = false})
SnaplineEnabledToggle:OnChanged(function(value)
    AimbotLibrary.Snapline.Enabled = value
end)
local SnaplineColorPicker = SnaplineEnabledToggle:AddColorPicker("SnaplineColorPicker",{Default = Color3.fromRGB(255,0,0);Rainbow = false})
SnaplineColorPicker:OnChanged(function(Color)
    AimbotLibrary.Snapline.Color = Color
end)
--End Fov

--Start Visuals
local BoxesPlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("BoxesPlayersEnabledToggle",{Text = "Bounding Box",Default = false,Risky = false})
BoxesPlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.Boxes.Enabled = value
end)
local BoxColorPicker = BoxesPlayersEnabledToggle:AddColorPicker("BoxColorPicker",{Default = Color3.fromRGB(255,255,255);Rainbow = false})
BoxColorPicker:OnChanged(function(Color)
    EspLibrary.Boxes.Color = Color
end)
local BoxesFilledPlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("BoxesFilledPlayersEnabledToggle",{Text = "Box Filled",Default = false,Risky = false})
BoxesFilledPlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.Boxes.Filled = value
end)
local BoxFilledColorPicker = BoxesFilledPlayersEnabledToggle:AddColorPicker("BoxFilledColorPicker",{Default = Color3.fromRGB(255,255,255);Rainbow = false})
BoxFilledColorPicker:OnChanged(function(Color)
    EspLibrary.Boxes.FilledColor = Color
end)
local NamesPlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("NamesPlayersEnabledToggle",{Text = "Names",Default = false,Risky = false})
NamesPlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.Names.Enabled = value
end)
local NamesPlayersColorPicker = NamesPlayersEnabledToggle:AddColorPicker("NamesPlayersColorPicker",{Default = Color3.fromRGB(255,255,255);Rainbow = false})
NamesPlayersColorPicker:OnChanged(function(Color)
    EspLibrary.Names.Color = Color
end)
local DistancePlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("DistancePlayersEnabledToggle",{Text = "Distance",Default = false,Risky = false})
DistancePlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.Distances.Enabled = value
end)
local DistancePlayersColorPicker = DistancePlayersEnabledToggle:AddColorPicker("DistancePlayersColorPicker",{Default = Color3.fromRGB(255,255,255);Rainbow = false})
DistancePlayersColorPicker:OnChanged(function(Color)
    EspLibrary.Distances.Color = Color
end)
local ToolsPlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("ToolsPlayersEnabledToggle",{Text = "Tools",Default = false,Risky = false})
ToolsPlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.Tools.Enabled = value
end)
local ToolsPlayersColorPicker = ToolsPlayersEnabledToggle:AddColorPicker("ToolsPlayersColorPicker",{Default = Color3.fromRGB(255,255,255);Rainbow = false})
ToolsPlayersColorPicker:OnChanged(function(Color)
    EspLibrary.Tools.Color = Color
end)
local HBPlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("HBPlayersEnabledToggle",{Text = "Health Bars",Default = false,Risky = false})
HBPlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.HealthBars.Enabled = value
end)
local HTPlayersEnabledToggle = PlayersVisualGroupbox:AddToggle("HTPlayersEnabledToggle",{Text = "Health Text",Default = false,Risky = false})
HTPlayersEnabledToggle:OnChanged(function(value)
    EspLibrary.HealthText.Enabled = value
end)
local HTPlayersColorPicker = HTPlayersEnabledToggle:AddColorPicker("HTPlayersColorPicker",{Default = Color3.fromRGB(255,255,255);Rainbow = false})
HTPlayersColorPicker:OnChanged(function(Color)
    EspLibrary.HealthText.Color = Color
end)


local PlayersRenderDistance = PlayersVisualGroupbox:AddSlider("PlayersRenderDistance",{Text = "Render Distance",Default = 1000,Min = 1,Max = 1500,Rounding = 0})
PlayersRenderDistance:OnChanged(function(Value)
    EspLibrary.GeneralSettings.RenderDistance = Value
end)
--End Visuals

--Start Misc
local NoRecoilEnabledToggle = ExploitsGroupbox:AddToggle("NoRecoilEnabledToggle",{Text = "No Recoil",Default = false,Risky = false})
NoRecoilEnabledToggle:OnChanged(function(value)
    Settings.Exploits.NoRecoil = value
    Players.LocalPlayer.Recoil.CurrentRecoil.Value = CFrame.new(0,0,0)
end)
--End Misc

Library:SetWatermark("Float.Balls [Town]")

task.spawn(function()
    while true do task.wait()
        if AimbotLibrary.Vars.Aiming == true and Settings.Aimbot.Enabled == true then
            local Player = AimbotLibraryFunctions:GetClosetInFov()

            if Player ~= nil and Player:FindFirstChild("HumanoidRootPart") then
                local Point = Camera:WorldToViewportPoint(Player[Settings.Aimbot.HitPart]:GetPivot().p)
                AimbotLibraryFunctions:AimAt(Point)
            end
        end
    end
end)

task.spawn(function()
    while true do task.wait(1)
        table.clear(AimbotLibrary.Players)
        for i,v in next, Players:GetPlayers() do
            if v.Character and v ~= Players.LocalPlayer then
                table.insert(AimbotLibrary.Players,v.Character)
            end
        end
    end
end)
local NoRecoilCon = Players.LocalPlayer.Recoil.CurrentRecoil.Changed:Connect(function()
    if Settings.Exploits.NoRecoil == true then
        Players.LocalPlayer.Recoil.CurrentRecoil.Value = CFrame.new(0,0,0) 
    end
end)
--Connections End

--Settings Start
local Settings = Window:AddTab("Settings")
local SettingsUI = Settings:AddLeftGroupbox("UI")

local SettingsUnloadButton = SettingsUI:AddButton({Text="Unload",Func=function()
    NoRecoilCon:Disconnect()
    MainCon:Disconnect()
    EspLibraryFunctions:Unload()
    Library:Unload()
end})
local SettingsMenuLabel = SettingsUI:AddLabel("SettingsMenuKeybindLabel","Menu Keybind")
local SettingsMenuKeyPicker = SettingsMenuLabel:AddKeyPicker("SettingsMenuKeyBind",{Default="Insert",IgnoreKeybindFrame=true})
Library.Options["SettingsMenuKeyBind"]:OnClick(function()
    Library:Toggle()
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

--Init
AimbotLibrary.Snapline.Outline = false
AimbotLibrary.Fov.FovOutline = false
AimbotLibraryFunctions:CreateFov()
AimbotLibrary.GeneralSettings.AimMode = "Mouse"
AimbotLibrary.GeneralSettings.IgnoreHumanoid = false
EspLibrary.GeneralSettings.IgnoreHumanoid = false

Players.ChildAdded:Connect(function(Child)
    Child.CharacterAdded:Connect(function(Character)
        if not EspLibrary.PlayerCache[Character] and Child ~= Players.LocalPlayer then
            EspLibraryFunctions:CreateEsp(Character)
            table.insert(AimbotLibrary.Players,Character)
        end
    end)
end)
for i,v in next, Players:GetPlayers() do
    if v.Character and not EspLibrary.PlayerCache[v.Character] and v ~= Players.LocalPlayer then
        EspLibraryFunctions:CreateEsp(v.Character)
        v.CharacterAdded:Connect(function(NewChar)
            EspLibraryFunctions:CreateEsp(NewChar)
        end)
    end
end
