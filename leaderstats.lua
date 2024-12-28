local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PlayerRebirths = DataStoreService:GetDataStore("PlayerRebirths")
local PlayerCoins = DataStoreService:GetDataStore("PlayerCoins")
local PlayerStage = DataStoreService:GetDataStore("PlayerStage")
local PlayerWins = DataStoreService:GetDataStore("PlayerWins")
local Checkpoints = game.Workspace.Map.Checkpoints:GetChildren()

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Wait()
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "leaderstats"
	Leaderstats.Parent = plr

	local Rebirths = Instance.new("IntValue")
	Rebirths.Name = "Rebirths"
	Rebirths.Parent = Leaderstats
	Rebirths.Value = PlayerRebirths:GetAsync(plr.UserId) or 0
	
	local Wins = Instance.new("IntValue")
	Wins.Name = "Wins"
	Wins.Parent = Leaderstats
	Wins.Value = PlayerRebirths:GetAsync(plr.UserId) or 0

	local Coins = Instance.new("IntValue")
	Coins.Name = "Coins"
	Coins.Parent = plr
	Coins.Value = PlayerCoins:GetAsync(plr.UserId) or 0
		
	plr.PlayerGui.ScreenGui.Frame.TextLabel.Text = Coins.Value

	local Stage = Instance.new("IntValue")
	Stage.Name = "Stage"
	Stage.Parent = Leaderstats
	Stage.Value = PlayerStage:GetAsync(plr.UserId) or 1

	table.sort(Checkpoints, function(a, b)
		return a.Name < b.Name
	end)

	print(Checkpoints)

	for i = 1, #Checkpoints, 1 do
		plr.RespawnLocation = Checkpoints[Stage.Value].SpawnLocation
	end
	
	local HumanoidRootPart = plr.Character:WaitForChild("HumanoidRootPart")
	HumanoidRootPart.CFrame =  Checkpoints[Stage.Value].SpawnLocation.CFrame
end)


-- Checkpoint script that changes them below;

local Checkpoint = script.Parent
local StageNumber = Checkpoint.Name
local CheckpointTouched = false
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local StageData = DataStoreService:GetDataStore("PlayerStage")
local CoinsData = DataStoreService:GetDataStore("PlayerCoins")
local CoinAddAmount = script.Parent.AmountOfCoins.Value

Checkpoint.Touched:Connect(function(plr)
	if plr.Parent:IsA("Accessory") then
	else
		local character = plr.Parent
		local humanoid = character:WaitForChild("Humanoid")
		local TouchPlayer = Players:GetPlayerFromCharacter(character)
		local PlayerStage = Players:GetPlayerFromCharacter(character).leaderstats.Stage
		local PlayerCoins = Players:GetPlayerFromCharacter(character).Coins

		if humanoid then
			if CheckpointTouched == false and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
				if PlayerStage.Value < tonumber(StageNumber) then
					TouchPlayer.RespawnLocation = script.Parent.SpawnLocation
					CheckpointTouched = true
					PlayerStage.Value = StageNumber
					PlayerCoins.Value = PlayerCoins.Value + CoinAddAmount
					print(PlayerStage.Value)
					CoinsData:SetAsync(TouchPlayer.UserId, PlayerCoins.Value)
					StageData:SetAsync(TouchPlayer.UserId, PlayerStage.Value)
					Players:GetPlayerFromCharacter(character).PlayerGui.ScreenGui.Frame.TextLabel.Text = PlayerCoins.Value
				end
			end
		end
	end
end)
