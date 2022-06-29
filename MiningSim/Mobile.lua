local UI = loadstring(game:HttpGetAsync("https://pastebin.com/raw/QAwr1iuM"))()
local Window = UI:Window("Mining Simulator")
UI:Notification("OUTDATED", "JOIN: https://discord.gg/sS8efKrQdu MOBILE CANNOT BE UPDATED", "Okay!")
local FarmingTab = Window:Tab("Rebirthing")
local NoobTab = Window:Tab("Item Buying")
local AdvancedTab = Window:Tab("Advanced")
FarmingTab:Slider("Sell Threshold",1, 1000000, 20000, function(args)
	_G.SellThresh = args
end)
FarmingTab:Slider("Depth",1, 500, 100, function(args)
	_G.DepthVal = args
end)
FarmingTab:Slider("Sell Time",.1,4, 1, function(args)
	_G.SellTime = args
end)

NoobTab:Toggle("Buy Bags", false, function(args)
	_G.BagBuy = args
end)
NoobTab:Toggle("Buy Tools", false, function(args)
	_G.ToolsBuy = args
end)

AdvancedTab:Label("Support will not be provided here!")
AdvancedTab:Label("Recomended settings have eben enabled!")
AdvancedTab:Slider("Mining X",1,17, 8, function(args)
	_G.MiningX = args
end)
AdvancedTab:Slider("Mining Y",1,17, 8, function(args)
	_G.MiningY = args
end)
AdvancedTab:Slider("Mining Z",1,17, 8, function(args)
	_G.MiningZ = args
end)

_G.SellThresh = 20000
_G.DepthVal = 100
_G.SellTime = 1
_G.BagBuy = false
_G.ToolsBuy = false
_G.MiningX = 8
_G.MiningY = 8
_G.MiningZ = 8

_G.Name = "Hidden" --Name above head

task.wait(6)
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local Path1 = Instance.new("Part", game:GetService("Workspace"))
Character.Head.CustomPlayerTag.PlayerName.Text =_G.Name
Character.Head.CustomPlayerTag.MinerRank.Text = "VertigoCool#1636"

Path1.Position = Vector3.new(22, 8.43, 26285)
Path1.Anchored = true
Path1.CanCollide = true
Path1.Material = "ForceField"
Path1.Size = Vector3.new(12, 2, 100)
Path1.Name = "Path1"
Path1.Velocity = Vector3.new(0, 0, -30)

local Path2 = Instance.new("Part", game:GetService("Workspace"))
Path2.Position = Vector3.new(58, 11, 26365)
Path2.Anchored = true
Path2.CanCollide = true
Path2.Material = "ForceField"
Path2.Size = Vector3.new(50, 1.2, 100)
Path2.Name = "Path2"

local gay = Instance.new("Part", game:GetService("Workspace"))
gay.Anchored = true
gay.Name = "ForTp"
gay.CanCollide = false
gay.Transparency = 1
gay.Position = Vector3.new(23.629228591918945, 12, 26226.427734375)


Path1.Touched:Connect(function()
	Tween(gay.Position + Vector3.new(0, 4, 0))
end)

function Tween(Pos)
	local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Pos).magnitude
	local speed = dist/50
	local TweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear)
	game:GetService("TweenService"):Create(HumanoidRootPart, TweenInfo, {CFrame = CFrame.new(Pos)}):Play()
end

local Remote = game.ReplicatedStorage.Network:InvokeServer()
local A_1 = "MoveTo"
local A_2 = {[1] = {[1] = "LavaSpawn"}}
Remote:FireServer(A_1, A_2)
task.wait(1.5)
Tween(gay.Position + Vector3.new(0, 4, 0))

for each, block in pairs(game.Workspace.Blocks:GetChildren()) do
	block:FindFirstChild("Stats"):FindFirstChild("Multiplier").Value = -9999
end

function Depth()
	s = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.TopInfoFrame.Depth.Text
	s = string.gsub(s, "Blocks", "")
	return tonumber(s)
end

game:GetService("RunService").Stepped:Connect(function()
     if Character:FindFirstChild("Head") and Character.Head:FindFirstChild("CustomPlayerTag") and Character.Head.CustomPlayerTag:FindFirstChild("MinerRank") then
		Character.Head.CustomPlayerTag.MinerRank.TextColor3 = Color3.fromHSV(tick() * 128 % 255/255, 1, 1)
	 end
	if Depth() > tonumber(4000) then
		local A_1 = "MoveTo"
		local A_2 = {[1] = {[1] = "LavaSpawn"}}
		Remote:FireServer(A_1, A_2)
		Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
	end
end)

function GetInventoryAmount()
	local Amount = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.StatsFrame2.Inventory.Amount.Text
	Amount = Amount:gsub('%s+', '')
	Amount = Amount:gsub(',', '')
	
	local stringTable = Amount:split("/")
	return tonumber(stringTable[1])
end

setOld = false
old = nil

LocalPlayer.PlayerGui.ScreenGui.StatsFrame2.Inventory.Amount.Changed:Connect(function(text)
	if Depth() ~= nil and Depth() >= DepthVal or Depth() == DepthVal then
		if text == "Text" and GetInventoryAmount() >= SellThresh or GetInventoryAmount() == SellThresh then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Anchored = false
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(41.96064, 13.8, -1239.64648, 1, 0, 0, 0, 1, 0, 0, 0, 1)
			local ggg;
			ggg = game.Players.LocalPlayer.Character.HumanoidRootPart:GetPropertyChangedSignal("CFrame"):connect(function()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(41.96064, 14, -1239.64648, 1, 0, 0, 0, 1, 0, 0, 0, 1)
				wait(_G.SellTime)
				ggg:Disconnect()
				wait(_G.SellTime - .2)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(41.96064, 13.3, -1239.64648, 1, 0, 0, 0, 1, 0, 0, 0, 1)
			end)
		end
	end
end)

FarmingTab:Button("Force Sell", function()
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Anchored = false
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(41.96064, 13.8, -1239.64648, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	local ggg;
	ggg = game.Players.LocalPlayer.Character.HumanoidRootPart:GetPropertyChangedSignal("CFrame"):connect(function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(41.96064, 14, -1239.64648, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		wait(1)
		ggg:Disconnect()
		wait(.5)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(41.96064, 13.3, -1239.64648, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	end)
end)

LocalPlayer.PlayerGui.ScreenGui.StatsFrame2.Coins.Amount.Changed:Connect(function(text)
	if_G.BagBuy == true then
		for i = 3, 50 do
			Remote:FireServer("BuyItem",{{"Backpack",i}})
			wait(.2)		
		end
	end
	if_G.ToolsBuy == true then
		for i = 1, 50 do
			Remote:FireServer("BuyItem",{{"Tools",i}})
			wait(.2)		
		end
	end
	Remote:FireServer("Rebirth",{{					                }})
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("TopInfoFrame") and LocalPlayer.PlayerGui.ScreenGui.TopInfoFrame:FindFirstChild("Depth") then
		if Depth() ~= nil and Depth() <=_G.DepthVal then
			if HumanoidRootPart then
				local min = HumanoidRootPart.CFrame + Vector3.new(-0,-5,-0)
				local max = HumanoidRootPart.CFrame + Vector3.new(0,5,0)
				local region = Region3.new(min.Position, max.Position)
				local parts = workspace:FindPartsInRegion3WithWhiteList(region, {game.Workspace.Blocks}, 100)

				for each, block in pairs(parts) do
					if block:IsA("BasePart") then
						local BlockModel = block.Parent
						Remote:FireServer("MineBlock",{{BlockModel}})
					end
				end
			end
		else
			if HumanoidRootPart then
			local min = HumanoidRootPart.CFrame + Vector3.new(tonumber("-".._G.MiningX),tonumber("-".._G.MiningY),tonumber("-".._G.MiningZ))
			local max = HumanoidRootPart.CFrame + Vector3.new(tonumber(_G.MiningX),tonumber(_G.MiningY),tonumber(_G.MiningZ))
			local region = Region3.new(min.Position, max.Position)
			local parts = workspace:FindPartsInRegion3WithWhiteList(region, {game.Workspace.Blocks}, 100)
			if game:GetService("Workspace").Collapsed.Value == true then
				local A_1 = "MoveTo"
				local A_2 = {[1] = {[1] = "LavaSpawn"}}
				Remote:FireServer(A_1, A_2)
				wait(.2)
				setOld = false
			else
				for each, block in pairs(parts) do
					if block:IsA("BasePart") then
						local BlockModel = block.Parent
						Remote:FireServer("MineBlock",{{BlockModel}})
					end
				end
			end
		end
		end
	end
end)
