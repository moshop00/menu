local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local enabled = true -- สถานะเริ่มต้น (เปิดใช้งาน)

-- ดึง Job ID ของเซิร์ฟเวอร์ปัจจุบัน
local jobId = game.JobId

-- สร้าง GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 300)
Frame.Position = UDim2.new(0.5, -175, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- เพิ่ม UI Corner (ขอบมน)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

-- เงา (Shadow Effect)
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217" -- เงาเบลอ
Shadow.ImageTransparency = 0.5
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "✨ Server Management ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Frame

-- สร้างฟังก์ชันปุ่ม
local function createButton(text, position, color)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.8, 0, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = color
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 18
    Button.AutoButtonColor = false
    Button.Parent = Frame

    -- เพิ่ม UI Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Button

    -- เพิ่มแอนิเมชันเมื่อโฮเวอร์
    Button.MouseEnter:Connect(function()
        Button:TweenSize(UDim2.new(0.85, 0, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        Button.BackgroundColor3 = color:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
    end)
    Button.MouseLeave:Connect(function()
        Button:TweenSize(UDim2.new(0.8, 0, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        Button.BackgroundColor3 = color
    end)

    return Button
end

-- ปุ่ม Rejoin
local RejoinButton = createButton("Rejoin Server", UDim2.new(0.1, 0, 0.25, 0), Color3.fromRGB(50, 150, 255))
RejoinButton.MouseButton1Click:Connect(function()
    if enabled then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
    end
end)

-- ปุ่ม Join by Job ID
local JoinByIdButton = createButton("Join by Job ID", UDim2.new(0.1, 0, 0.45, 0), Color3.fromRGB(255, 100, 100))
JoinByIdButton.MouseButton1Click:Connect(function()
    if enabled then
        local input = LocalPlayer:WaitForChild("PlayerGui"):PromptInput("Enter Job ID", "Paste the Job ID of the server you want to join:")
        if input and input ~= "" then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, input, LocalPlayer)
        else
            print("No Job ID entered.")
        end
    end
end)

-- ปุ่มหาเซิร์ฟเวอร์คนน้อย
local FindLowServerButton = createButton("Find Low Player Server", UDim2.new(0.1, 0, 0.65, 0), Color3.fromRGB(50, 255, 150))
FindLowServerButton.MouseButton1Click:Connect(function()
    if enabled then
        local HttpService = game:GetService("HttpService")
        local PlaceId = game.PlaceId
        local Url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

        spawn(function()
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(Url))
            end)
            if success and result and result.data then
                for _, server in ipairs(result.data) do
                    if server.playing < server.maxPlayers then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                        return
                    end
                end
                print("No available server found.")
            else
                print("Failed to fetch server data.")
            end
        end)
    end
end)

-- ปุ่ม Toggle Script
local ToggleButton = createButton("Disable Script", UDim2.new(0.1, 0, 0.85, 0), Color3.fromRGB(255, 200, 50))
ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        ToggleButton.Text = "Disable Script"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        print("Script Enabled")
    else
        ToggleButton.Text = "Enable Script"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        print("Script Disabled")
    end
end)