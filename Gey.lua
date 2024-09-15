-- Khởi tạo các biến
local actions = {}
local isRecording = false
local lastActionTime = tick()

-- Hàm để ghi lại hành động
local function recordAction(actionType, actionValue)
    table.insert(actions, {type = actionType, value = actionValue, time = tick() - lastActionTime})
    lastActionTime = tick()
end

-- Hàm để phát lại các hành động đã ghi
local function replayActions()
    local startTime = tick()
    for _, action in ipairs(actions) do
        wait(action.time + startTime - tick())  -- Chờ đến thời điểm hành động
        if action.type == "Running" then
            -- Điều khiển tốc độ di chuyển của nhân vật
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = action.value
        elseif action.type == "InputBegan" then
            -- Giả lập sự kiện nhấn phím
            -- (Lưu ý: Roblox không hỗ trợ gửi sự kiện nhấn phím trực tiếp, nên phần này có thể cần được điều chỉnh)
            -- game:GetService("UserInputService"):SendInput(action.value)
        end
    end
end

-- Hàm bắt đầu ghi lại
local function startRecording()
    isRecording = true
    actions = {}
    lastActionTime = tick()
    -- Ghi lại di chuyển của người chơi
    game.Players.LocalPlayer.Character.Humanoid.Running:Connect(function(speed)
        if isRecording then
            recordAction("Running", speed)
        end
    end)
    -- Ghi lại nhấn phím
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if isRecording then
            recordAction("InputBegan", input.KeyCode)
        end
    end)
end

-- Hàm dừng ghi lại
local function stopRecording()
    isRecording = false
end

-- Hàm bắt đầu phát lại
local function startPlayback()
    replayActions()
end

-- Điều khiển bắt đầu/dừng ghi và phát lại
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        if isRecording then
            stopRecording()
        else
            startRecording()
        end
    elseif input.KeyCode == Enum.KeyCode.P then
        startPlayback()
    end
end)
