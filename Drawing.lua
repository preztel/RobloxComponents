local Library = {}

local CreateRenderObject = getupvalue(Drawing.new, 1) ~= nil and getupvalue(Drawing.new, 1) or Drawing.new
local SetRenderProperty = setrenderproperty or getupvalue(getupvalue(Drawing.new, 7).__newindex, 4)
local GetRenderProperty = getrenderproperty or getupvalue(getupvalue(Drawing.new, 7).__index, 4)
local DestroyRenderObject = getupvalue(getupvalue(Drawing.new, 7).__index, 3) ~= nil and getupvalue(getupvalue(Drawing.new, 7).__index, 3) or Drawing.Destroy

local UserInput = game:GetService("UserInputService")

function Library.OnMouse(Instance)
    local Mouse = UserInput:GetMouseLocation()
    
    local InstanceVisible = GetRenderProperty(Instance, "Visible")
    local InstancePosition = GetRenderProperty(Instance, "Position")
    local InstanceSize = GetRenderProperty(Instance, "Size")

    if InstanceVisible and (Mouse.X > InstancePosition.X) and (Mouse.X < InstancePosition.X + InstanceSize.X) and (Mouse.Y > InstancePosition.Y) and (Mouse.Y < InstancePosition.Y + InstanceSize.Y) then
        return true
    end
end

function Library.new(InstanceType, InstanceProperties, InstanceParent)
    local Utility = {}
    local Instance = CreateRenderObject(InstanceType)
    SetRenderProperty(Instance, "Visible", true)
    Utility.Instance = Instance

    if InstanceType == "Square" then
        SetRenderProperty(Instance, "Filled", true)
        SetRenderProperty(Instance, "Thickness", 0)
    elseif InstanceType == "Text" then
        SetRenderProperty(Instance, "Size", 13)
        SetRenderProperty(Instance, "Font", 1)
        SetRenderProperty(Instance, "Color", Color3.fromRGB(255, 255, 255))
    end

    if Instance then
        for Name, Value in next, InstanceProperties do
            SetRenderProperty(Instance, tostring(Name), Value)
        end
    end

    Utility.Mouse1Down = function(Callback)
        UserInput.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Library.OnMouse(Instance) then
                Callback()
            end
        end)
    end

    Utility.Mouse2Down = function(Callback)
        UserInput.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton2 and Library.OnMouse(Instance) then
                Callback()
            end
        end)
    end

    Utility.Edit = function(Name, Value)
        SetRenderProperty(Instance, tostring(Name), Value)
    end

    if InstanceParent then
        InstanceParent[#InstanceParent + 1] = Instance
    end

    return Utility
end

function Library:Size(xScale, xOffset, yScale, yOffset, Parent)
    if Parent then
        local X = xScale * GetRenderProperty(Parent, "Size").X + xOffset
        local Y = yScale * GetRenderProperty(Parent, "Size").Y + yOffset
        return Vector2.new(X, Y)
    else
        local vx, vy = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
        local X = xScale * vx + xOffset
        local Y = yScale * vy + yOffset
        return Vector2.new(X, Y)
    end
end

function Library:Position(xScale, xOffset, yScale, yOffset, Parent)
    if Parent then
        local X = GetRenderProperty(Parent, "Position").X + xScale * GetRenderProperty(Parent, "Size").X + xOffset
        local Y = GetRenderProperty(Parent, "Position").Y + yScale * GetRenderProperty(Parent, "Size").Y + yOffset
        return Vector2.new(X, Y)
    else
        local vx, vy = workspace.CurrentCamera.ViewportSize.x, workspace.CurrentCamera.ViewportSize.y
        local X = xScale * vx + xOffset
        local Y = yScale * vy + yOffset
        return Vector2.new(X, Y)
    end
end

return Library
