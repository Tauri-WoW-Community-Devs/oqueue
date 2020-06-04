local addonName, OQ = ...

local AceGUI = LibStub('AceGUI-3.0')

function OQ:InitScroll(parent)
    local scrollContainer = AceGUI:Create("SimpleGroup")
    scrollContainer:SetFullWidth(true)
    scrollContainer:SetFullHeight(true)
    scrollContainer:SetLayout("Fill")
    parent:AddChild(scrollContainer)

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    scrollContainer:AddChild(scroll)

    return scroll
end

function OQ:CreateDropdown(optionTable, onChange)
    local msValue = {}
    local frame = AceGUI:Create('Dropdown')
    frame:SetList(optionTable)

    local OnValueChanged = function(self, event, value, justChecked)
        if (self:GetMultiselect()) then
            if (justChecked) then
                msValue[value] = 1
            else
                msValue[value] = nil
            end

            onChange(msValue)
            return
        end
        onChange(value)
    end

    local SetMSValue = function (self, value)
        if (not self:GetMultiselect()) then
            self:SetValue(value)
            return
        end

        msValue = OQ:TableCopy(value)
        for key in pairs(value) do
            self:SetItemValue(key, 1)
        end
    end

    frame:SetCallback('OnValueChanged', OnValueChanged)
    frame.SetMSValue = SetMSValue
    return frame
end

function OQ:CreateCheckbox(label, value, onChange)
    local frame = AceGUI:Create('CheckBox')
    frame:SetType('checkbox')
    frame:SetLabel(label)
    frame:SetValue(value)

    local OnValueChanged = function(self, event, value)
        onChange(value)
    end

    frame:SetCallback('OnValueChanged', OnValueChanged)

    return frame
end

function OQ:SetFormValue(form, key, value)
    form[key] = value
end
