local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local enabled = true -- สถานะเริ่มต้น (เปิดใช้งาน)

-- ดึง Job ID ของเซิร์ฟเวอร์ปัจจุบัน
local jobId = game.JobId

-- สร้าง GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- UI Corner (ขอบมน)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

-- UI Drag (ทำให้ลากได้)
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "✨ Server Management ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Frame

-- ฟังก์ชันปุ่ม
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

    return Button
end

-- ปุ่ม Rejoin
local RejoinButton = createButton("Rejoin Server", UDim2.new(0.1, 0, 0.2, 0), Color3.fromRGB(50, 150, 255))
RejoinButton.MouseButton1Click:Connect(function()
    if enabled then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
    end
end)

-- TextBox สำหรับใส่ Job ID
local JobIdBox = Instance.new("TextBox")
JobIdBox.Size = UDim2.new(0.8, 0, 0, 40)
JobIdBox.Position = UDim2.new(0.1, 0, 0.4, 0)
JobIdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JobIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JobIdBox.PlaceholderText = "Enter Job ID here..."
JobIdBox.Font = Enum.Font.Gotham
JobIdBox.TextSize = 18
JobIdBox.ClearTextOnFocus = false
JobIdBox.Parent = Frame

local UICornerTextBox = Instance.new("UICorner")
UICornerTextBox.CornerRadius = UDim.new(0, 10)
UICornerTextBox.Parent = JobIdBox

-- ปุ่ม Join by Job ID
local JoinByIdButton = createButton("Join by Job ID", UDim2.new(0.1, 0, 0.55, 0), Color3.fromRGB(255, 100, 100))
JoinByIdButton.MouseButton1Click:Connect(function()
    if enabled then
        local input = JobIdBox.Text
        if input and input ~= "" then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, input, LocalPlayer)
        else
            print("Please enter a valid Job ID.")
        end
    end
end)

-- ปุ่มคัดลอก Job ID
local CopyJobIdButton = createButton("Copy Job ID", UDim2.new(0.1, 0, 0.7, 0), Color3.fromRGB(100, 255, 100))
CopyJobIdButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(jobId)
        print("Job ID copied to clipboard: " .. jobId)
    else
        print("SetClipboard not supported on this device.")
    end
end)

-- ปุ่มออกจากสคริปต์
local ExitButton = createButton("Exit Script", UDim2.new(0.1, 0, 0.85, 0), Color3.fromRGB(255, 50, 50))
ExitButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("Script exited.")
end)
