local addonName, OQ = ...
local oq = OQ:mod() -- thank goodness i stumbled across this trick
local _  -- throw away (was getting taint warning; what happened blizz?)

--------------------------------------------------------------------------
-- class portrait to replace normal portrait
--------------------------------------------------------------------------
function OQ_ClassPortrait(self)
    if (oq == nil) or (oq.toon == nil) or (oq.toon.class_portrait == 0) then
        if (self.portrait ~= nil) then
            self.portrait:SetTexCoord(0, 1, 0, 1)
        end
        return
    end
    if (self.portrait ~= nil) then
        if
            UnitIsPlayer(self.unit) and
                ((self.unit == 'target') or (self.unit == 'focus') or (self.unit:sub(1, 5) == 'party'))
         then
            local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
            if t then
                self.portrait:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
                self.portrait:SetTexCoord(unpack(t))
            end
        else
            self.portrait:SetTexCoord(0, 1, 0, 1)
        end
    end
end

hooksecurefunc('UnitFramePortrait_Update', OQ_ClassPortrait)
