local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Arsenal",
   LoadingTitle = "Neptune Script",
   LoadingSubtitle = "by Froceur",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Créez un dossier personnalisé pour votre hub / jeu
      FileName = "Neptune Script"
   },
   Discord = {
      Enabled = true,
      Invite = "VFtbSWZ5", -- Le code d'invitation Discord, n'incluez pas Discord.gg/. Par exemple, discord.gg/abcd serait ABCD
      RememberJoins = false -- Réglez ceci sur False pour les faire rejoindre le Discord à chaque fois qu'ils le chargent
   },
   KeySystem = true, -- Réglez ceci sur true pour utiliser notre système de clés
   KeySettings = {
      Title = "Neptune Script",
      Subtitle = "Discord link",
      Note = "join the server to get the key",
      FileName = "Key", -- Il est recommandé d'utiliser quelque chose d'unique car d'autres scripts utilisant Rayfield peuvent écraser votre fichier de clé
      SaveKey = true, -- La clé de l'utilisateur sera sauvegardée, mais si vous changez la clé, ils ne pourront plus utiliser votre script
      GrabKeyFromSite = false, -- Si c'est true, réglez Key ci-dessous sur le site RAW d'où vous souhaitez que Rayfield obtienne la clé
      Key = {"neptune"} -- Liste des clés qui seront acceptées par le système, peut être des liens de fichiers RAW (pastebin, github, etc.) ou des chaînes simples ("hello","key22")
   }
})


local MainTab = Window:CreateTab("fight", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")



local Button = MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(value)
        local Camera = game.Workspace.CurrentCamera
        local Players = game:GetService("Players")
        local StarterGui = game:GetService("StarterGui")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local LocalPlayer = Players.LocalPlayer
        local Holding = false
        local TargetPlayer = nil

        _G.AimbotEnabled = false
        _G.TeamCheck = true
        _G.AimPart = "Head"
        _G.Sensitivity = 0

        local function GetClosestPlayer()
            local MaximumDistance = math.huge
            local ClosestPlayer = nil
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= LocalPlayer.Team then
                    local HumanoidRootPart = v.Character.HumanoidRootPart
                    local ScreenPoint = Camera:WorldToScreenPoint(HumanoidRootPart.Position)
                    
                    -- Vérifie si le joueur est au-dessus de la caméra (en Y) pour éviter les joueurs sous la carte
                    if ScreenPoint.Z > 0 then
                        local Distance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                        if Distance < MaximumDistance then
                            MaximumDistance = Distance
                            ClosestPlayer = v
                        end
                    end
                end
            end
            return ClosestPlayer
        end
        

        UserInputService.InputBegan:Connect(function(Input)
            if Input.KeyCode == Enum.KeyCode.G then
                _G.AimbotEnabled = not _G.AimbotEnabled
                StarterGui:SetCore("SendNotification", {
                    Title = "Aimbot",
                    Text = _G.AimbotEnabled and "Aimbot Enabled" or "Aimbot Disabled",
                    Duration = 3
                })
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                Holding = true
            end
        end)

        UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                Holding = false
                TargetPlayer = nil
            end
        end)

        RunService.RenderStepped:Connect(function()
            if Holding and _G.AimbotEnabled then
                if not TargetPlayer then
                    TargetPlayer = GetClosestPlayer()
                end
                if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild(_G.AimPart) then
                    TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, TargetPlayer.Character[_G.AimPart].Position)}):Play()
                else
                    TargetPlayer = nil
                end
            end
        end)
    end
})







local ESPEnabled = false


local ESP = nil
local ESPScriptUrl = "https://pastebin.com/raw/nwNqar0b"

local Esp = MainTab:CreateToggle({
    Name = "esp",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function()
      ESPEnabled = not ESPEnabled
        if ESPEnabled then
        ESP = loadstring(game:HttpGet(ESPScriptUrl))()
		ESP.Enabled = true
		ESP.ShowBox = true
		ESP.BoxType = "Corner Box Esp"
		ESP.ShowName = true
		ESP.ShowHealth = true
		ESP.ShowTracer = false
		ESP.ShowDistance = true
        else
            ESP.Enabled = not ESP.Enabled
        end
    end
 })


 
local teleportAttackLoopEnabled = false
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


local teleportAttackButton = MainTab:CreateButton({
    Name = "Tp kill",
    Callback = function()
        local teleportAttackLoopEnabled = false
        local Camera = game.Workspace.CurrentCamera
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        -- Fonction pour obtenir le joueur ennemi le plus proche
        local function GetClosestEnemy()
            local ClosestDistance = math.huge
            local ClosestEnemy = nil
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Team ~= LocalPlayer.Team and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local Distance = (Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if Distance < ClosestDistance then
                        ClosestDistance = Distance
                        ClosestEnemy = Player
                    end
                end
            end
            return ClosestEnemy
        end

        -- Vérifier si la position est sécurisée pour la téléportation
        local function IsSafePosition(position)
            -- Vérifie si la position est en dessous de -10 sur l'axe Y
            if position.Y < -10 then
                return false, "Position en dessous de la carte."
            end

            -- Vérifie si des objets (modèles) se trouvent dans un rayon de 5 unités autour de la position
            local nearbyParts = workspace:FindPartsInRegion3(
                Region3.new(position - Vector3.new(5, 5, 5), position + Vector3.new(5, 5, 5)),
                LocalPlayer.Character,
                10 -- Limite le nombre de parties à vérifier
            )
            if #nearbyParts == 0 then
                return false, "Aucun objet trouvé à proximité."
            end

            return true, "Position sécurisée."
        end

        -- Fonction pour téléporter et attaquer
        local function TeleportAndAttack()
            local TargetEnemy = GetClosestEnemy()
            if TargetEnemy and TargetEnemy.Character and TargetEnemy.Character:FindFirstChild("HumanoidRootPart") then
                local TargetHRP = TargetEnemy.Character.HumanoidRootPart
                local TargetPosition = TargetHRP.Position + Vector3.new(0, 3, 0)
                
                local safe, reason = IsSafePosition(TargetPosition)
                if not safe then
                    warn("Téléportation annulée: " .. reason)
                    return
                end

                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(TargetPosition))

               -- Viser la tête du joueur cible
               local TargetHead = TargetEnemy.Character:FindFirstChild("Head")
               if TargetHead then
                   while teleportAttackLoopEnabled and TargetEnemy.Parent do
                       Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetHead.Position)
               
                       if teleportAttackLoopEnabled then
                           for i = 1, 3 do  -- Spammer le clic gauche 3 fois
                               mouse1click()
                               mouse1click()
                
                               wait(0.1)  -- Intervalle entre chaque clic
                           end
                           game:GetService("Players").LocalPlayer.NRPBS.FireDamage = 200
                           game:GetService("Players").LocalPlayer.NRPBS.ExplosiveDamage = 200
                           game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
                           game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
                       else 
                           game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 30
                           game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 30
                           break
                       end
               
                       wait(0) -- Intervalle entre les attaques
                   end
               end
           end
       end

        -- Activation/Désactivation de la boucle de téléportation et d'attaque
        teleportAttackLoopEnabled = not teleportAttackLoopEnabled

        -- Gestion de la connexion
        local teleportConnection
        if teleportAttackLoopEnabled then
            teleportConnection = RunService.RenderStepped:Connect(function()
                if teleportAttackLoopEnabled then
                    TeleportAndAttack()
                end
            end)
        else
            if teleportConnection then
                teleportConnection:Disconnect()
                teleportConnection = nil
            end
        end

        -- Notification de l'état actuel
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleport & Attack",
            Text = teleportAttackLoopEnabled and "Enabled" or "Disabled",
            Duration = 3
        })

        -- Ajout de la détection de la touche F3 pour désactiver
        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.F3 then
                teleportAttackLoopEnabled = false
                if teleportConnection then
                    teleportConnection:Disconnect()
                    teleportConnection = nil
                end
            end
        end)
    end
})


local otherTab = Window:CreateTab("other", nil) -- Title, Image
local otherSection = otherTab:CreateSection("Main")

local admin = false


local Admin = otherTab:CreateButton({
    Name = "Enabled Admin Mode",
    Callback = function()
        admin = not admin
        if ESPEnabled then
            game:GetService("Players").LocalPlayer.QueuePoints.Name = "IsAdmin"
        else
            game:GetService("Players").LocalPlayer.IsAdmin.Name = "QueuePoints"
        end
    end
 })


local amoEnabled = false

local amoButton = MainTab:CreateButton({
    Name = "Infinite Ammo",
    Callback = function()
        amoEnabled = not amoEnabled
        while amoEnabled do
            game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
            game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
            wait() 
        end
    end
})


local infjmp = true
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")


local infjmp = false
local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local jumpRequestConnection

local jumpButton = MainTab:CreateButton({
    Name = "infini jump",
    Callback = function()
        infjmp = not infjmp
        if infjmp then
            humanoid.JumpPower = 35 -- Change this value to your desired jump power
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
            if not jumpRequestConnection then
                jumpRequestConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if infjmp then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        else
            humanoid.JumpPower = 50 -- Optional: reset to default jump power or desired default value
        end
    end
})

