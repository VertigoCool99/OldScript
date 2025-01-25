local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local path = PathfindingService:CreatePath({
    AgentRadius = 0,
    WaypointSpacing=6,
	AgentHeight = 6,
	AgentCanJump = false,
	Costs = {
	}
})

local player = Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

local waypoints
local nextWaypointIndex
local reachedConnection
local blockedConnection

function GetEnemys()
    for i, v in pairs(game:GetService("Workspace").dungeon:GetChildren()) do
        if v:FindFirstChild("enemyFolder") and v.enemyFolder:FindFirstChildOfClass("Model") then
            return v.enemyFolder:GetChildren()
        end
    end
end

function GetClosestEnemy(player)
    local closestEnemy = nil
    local shortestDistance = math.huge
    local enemies = GetEnemys()
    if enemies then
        for _, enemy in pairs(enemies) do
            local enemyPosition = enemy:FindFirstChild("HumanoidRootPart") and enemy.HumanoidRootPart.Position
            if enemyPosition then
                local distance = (player.Character.HumanoidRootPart.Position - enemyPosition).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
    end
    return closestEnemy
end

local function followPath(destination)
	local success, errorMessage = pcall(function()
		path:ComputeAsync(character.PrimaryPart.Position, destination)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		waypoints = path:GetWaypoints()

		blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
			if blockedWaypointIndex >= nextWaypointIndex then
				blockedConnection:Disconnect()
				followPath(destination)
			end
		end)

		if not reachedConnection then
			reachedConnection = humanoid.MoveToFinished:Connect(function(reached)
				if reached and nextWaypointIndex < #waypoints then
					nextWaypointIndex += 1
					humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
				else
					reachedConnection:Disconnect()
					blockedConnection:Disconnect()
				end
			end)
		end
		nextWaypointIndex = 2
		humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
	else
        if workspace.dungeonName.Value == "Northen Lands" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-646,21,362)).Magnitude < 50 then
                humanoid:MoveTo(Vector3.new(-588,21,458))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(223, 21, 223)).Magnitude < 50 then
                humanoid:MoveTo(Vector3.new(479, -58, 226))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-573, 25, 468)).Magnitude < 50 then
                humanoid:MoveTo(Vector3.new(-420, 27, 425))
            end
        end
		warn("Path not computed!", errorMessage)
	end
end
local function moveToClosestEnemy()
    while true do task.wait()
        local closestEnemy = GetClosestEnemy(player)
        
        if closestEnemy then
            followPath(closestEnemy:GetPivot().p)
        else
            wait(2) 
        end
    end
end
task.spawn(function()
    while true do task.wait()
        humanoid.WalkSpeed = 35
    end
end)
local function castAll()
    task.spawn(function()
        for _,spell in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if spell.cooldown.Value then
                for _,randombullshit in pairs(spell:GetChildren()) do
                    if randombullshit.Name == "abilityEvent" or randombullshit.Name == "spellEvent" then
                        randombullshit:FireServer()
                    end
                end
                task.wait()
            end
        end

        castAll()
    end)
end

task.spawn(function()
    while true do task.wait(1)
        local ohTable1 = {
            [1] = {
                [utf8.char(3)] = "vote",
                ["vote"] = true
            },
            [2] = utf8.char(28)
        }

        game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer(ohTable1)
        game:GetService("ReplicatedStorage").remotes.changeStartValue:FireServer()
    end
end)

castAll()

moveToClosestEnemy()
