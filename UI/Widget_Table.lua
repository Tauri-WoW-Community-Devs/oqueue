local addonName, OQ = ...

local AceGUI = LibStub('AceGUI-3.0')

--[[
columns = {
    {
        label = "Text",
        width = 0,
        headerAlign = "TOPLEFT",
        cellAlign = "TOPLEFT",
    }
}
data = {
    {
        arg1 = 1,
        arg2 = 2,
    }
}
itemRenderer(arg1, arg2, ...)
]]
function OQ:Table(columns, data, itemRenderer)
    local table = AceGUI:Create("InlineGroup")
    table:SetLayout("Table")

    for col in columns do
        -- Clickable label with sorting
    end

    return table
end

function OQ:TableLabelAlign(label, horizontal, vertical)
    if (horizontal == nil and vertical == nil) then
        return
    end

    local group = AceGUI:Create("SimpleGroup")
    if (horizontal ~= nil) then
        label:SetJustifyH(horizontal)
    end
    if (vertical ~= nil) then
        label:SetJustifyV(vertical)
    end
    group:AddChild(label)

    return group
end
