getgenv().AutoRetry = true
getgenv().SkillWait = 0.3

--Locals
local Workspace,PathfindingService,Players = game:GetService("Workspace"),game:GetService("PathfindingService"),game:GetService("Players")
local Path = PathfindingService:CreatePath({AgentRadius = 3,WaypointSpacing=7,AgentHeight = 6,AgentCanJump = false,Costs = {Neon = 1}})
local waypoints,nextWaypointIndex,reachedConnection,blockedConnection,Speed = {},1,nil,nil,60

function TweenPlayer(destination)
    local distance = (destination - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local duration = distance / Speed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(destination)})
    return tween
end

--Functions
function GetEnemys()
    for i, v in pairs(game:GetService("Workspace").dungeon:GetChildren()) do
        if v:FindFirstChild("enemyFolder") and v.enemyFolder:FindFirstChildOfClass("Model") then
            return v.enemyFolder:GetChildren()
        end
    end
    return nil
end
function GetClosestEnemy()
    if GetEnemys() == nil then return end
    local closestEnemy = nil
    local shortestDistance = math.huge
    for _, v in pairs(GetEnemys()) do
        local enemyPosition = v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.Position
        if enemyPosition then
            local distance = (Players.LocalPlayer.Character.HumanoidRootPart.Position - enemyPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = v
            end
        end
    end
    return closestEnemy
end
function DestroyMap()
    if workspace.dungeonName.Value == "Aquatic Temple" then
        for i,v in pairs(workspace.Map:GetDescendants()) do
            if v.Name == "Aqua tile" or v.Name == "Side tile" then
                v:Destroy()
            elseif v:IsA("Part") and v.Size == Vector3.new(134.37998962402344, 1, 128.66000366210938) then
                v:Destroy()
            end
        end
    elseif workspace.dungeonName.Value == "Gilded Skies" then
        local Ids = {"rbxassetid://9331223307","rbxassetid://9331222982","rbxassetid://9310249638","rbxassetid://9329425049","rbxassetid://9331222661","rbxassetid://9402307859","rbxassetid://6815156999"}
        for i,v in pairs(workspace.Map:GetDescendants()) do
            if v:IsA("MeshPart") and table.find(Ids,v.MeshId) then
                v:Destroy()
            end
        end
    elseif workspace.dungeonName.Value == "Enchanted Forest" then
        local Ids = {"rbxassetid://3733654217","rbxassetid://3733654077","rbxassetid://3751372367","rbxassetid://3751372241","rbxassetid://4704210195","rbxassetid://3733375373","rbxassetid://3733447987","rbxassetid://3733447856","rbxassetid://6416751229","rbxassetid://6416751071"}
        for i,v in pairs(workspace.map:GetDescendants()) do
            if v:IsA("MeshPart") and table.find(Ids,v.MeshId) then
                v:Destroy()
            elseif v.Name == "brick" then
                v:Destroy()
            end
        end
        for i,v in pairs(workspace.borders:GetChildren()) do
            v:Destroy()
        end
    end 
end

function MoveToPath()
    if nextWaypointIndex <= #waypoints then
        local tween = TweenPlayer(waypoints[nextWaypointIndex].Position+Vector3.new(0,2.5,0))
        tween:Play()
        tween.Completed:Connect(function()
            nextWaypointIndex = nextWaypointIndex + 1
            MoveToPath()
        end)
    else
        nextWaypointIndex = 1
    end
end

function followPath(destination)
	local success, errorMessage = pcall(function()
		Path:ComputeAsync(Players.LocalPlayer.Character:GetPivot().p, destination)
	end)

	if success and Path.Status == Enum.PathStatus.Success then
        waypoints = Path:GetWaypoints()
        MoveToPath()
	else
        --Stuck Positions
        if workspace.dungeonName.Value == "Northern Lands" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-637, 21, 373)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-567, 21, 451))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(235, 21, 233)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(389, 14, 169))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(419, -60, 163))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(406, -53, 21)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(485, -23, -17))
            end
        elseif workspace.dungeonName.Value == "Enchanted Forest" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-607, -24, 191)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-651, -24, 266))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-747, -24, 241))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-632, -24, 449)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-728, -21, 365))
            end
        elseif workspace.dungeonName.Value == "Gilded Skies" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(1022, 51, -518)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1013, 60, -560))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1023, 69, -584))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1051, 81, -602))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1126, 108, -608))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1163, 121, -622))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1181, 131, -648))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1187, 144, -688))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(1174, 150, -734))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(757, 86, 275)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(661, 86, 106))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-125, 42, -3)).Magnitude < 200 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(71, 31, -4))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(766, 86, -166)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(801, 74, -171))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(781, 60, -236))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(820, 52, -288))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
            end
        elseif workspace.dungeonName.Value == "Aquatic Temple" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-1754, 36, 2325)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1845, 35, 2307))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1855, 51, 2242))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-1237, 34, 2336)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1257, -23, 2121))
            end
        elseif workspace.dungeonName.Value == "Orbital Outpost" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-35, 9, 158)).Magnitude < 200 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(61, 9, 152))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(60, 10, 119))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(157, 19, 112))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(341, 17, -473)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(102, 18, -454))
            elseif (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(149, 18, -378)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(100, 19, -323))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(16, 5, -323))
            end
        elseif  workspace.dungeonName.Value == "Volcanic Chambers" then
            if (game.Players.LocalPlayer.Character:GetPivot().p-Vector3.new(-1576, -20, 700)).Magnitude < 70 then
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1609, -15, 634))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1713, -6, 611))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1741, 1, 624))
                Players.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1747, 15, 685))
            end
        end
		warn("Path not computed!", errorMessage) 
	end
end
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Coin" then
        local t = TweenPlayer(child.Position)
        t:Play()t.Completed:Wait()
    end
end)

function moveToClosestEnemy()
    while true do task.wait()
        local closestEnemy = GetClosestEnemy()
        if closestEnemy then
            followPath(closestEnemy:GetPivot().p)
        end
    end
end
function castAll()
    task.spawn(function()
        for _,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if v.cooldown.Value then
                for _,v2 in pairs(v:GetChildren()) do
                    if v2.Name == "abilityEvent" or v2.Name == "spellEvent" then
                        for i = 0,3 do
                            Players.LocalPlayer.Character.Humanoid.WalkSpeed = 33
                            v2:FireServer() 
                        end
                    end
                end
                task.wait(getgenv().SkillWait)
            end
        end

        castAll()
    end)
end

task.spawn(function()
    while true do task.wait(1)
        DestroyMap()
        game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer({[1] = {[utf8.char(3)] = "vote",["vote"] = true},[2] = utf8.char(28)})
        game:GetService("ReplicatedStorage").remotes.changeStartValue:FireServer()
        if getgenv().AutoRetry == true then 
            game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer({[1] = {["\3"] = "vote",["vote"] = true},[2] = "/"})         
        end       
    end
end)

castAll()

moveToClosestEnemy()
