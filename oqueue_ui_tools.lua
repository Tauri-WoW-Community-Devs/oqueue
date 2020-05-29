local addonName, OQ = ...
local oq = OQ:mod() -- thank goodness i stumbled across this trick
local _  -- throw away (was getting taint warning; what happened blizz?)
local tbl = OQ.table

OQ.MENU_DISPLAY_TM = 3
OQ.BUTTON_SZ = 32
OQ.MAX_MENU_OPTIONS = 40
OQ.DOWNARROW_DOWN = 'INTERFACE/CHATFRAME/UI-ChatIcon-ScrollDown-Down'
OQ.DOWNARROW_UP = 'INTERFACE/CHATFRAME/UI-ChatIcon-ScrollDown-Up'
OQ.BUTTON_PREV_DN = 'INTERFACE/BUTTONS/UI-SpellbookIcon-PrevPage-Down'
OQ.BUTTON_PREV_UP = 'INTERFACE/BUTTONS/UI-SpellbookIcon-PrevPage-Up'
OQ.BUTTON_NEXT_DN = 'INTERFACE/BUTTONS/UI-SpellbookIcon-NextPage-Down'
OQ.BUTTON_NEXT_UP = 'INTERFACE/BUTTONS/UI-SpellbookIcon-NextPage-Up'
OQ.BUTTON_PREV_DISABLED = 'INTERFACE/BUTTONS/UI-SpellbookIcon-PrevPage-Disabled'
OQ.BUTTON_NEXT_DISABLED = 'INTERFACE/BUTTONS/UI-SpellbookIcon-NextPage-Disabled'
OQ.PLACEHOLDER = 'Interface\\Addons\\oqueue\\art\\place_holder.tga'

function oq.save_position(f)
    if (f._save_position) then
        f._save_position(f)
    end
end

function oq.make_frame_moveable(f)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag('LeftButton')
    f:SetScript('OnDragStart', f.StartMoving)
    f:SetScript('OnDragStop', f.StopMovingOrSizing)
    f:SetScript(
        'OnMouseDown',
        function(self, button)
            if (button == 'LeftButton') and (not self.isMoving) then
                self:StartMoving()
                self.isMoving = true
            elseif (button == 'LeftButton') then
                -- try to recover from odd double left-down with no left-up
                self:StopMovingOrSizing()
                self.isMoving = false
            end
        end
    )
    f:SetScript(
        'OnMouseUp',
        function(self, button)
            if (button == 'LeftButton') and self.isMoving then
                if (f._save_position) then
                    f._save_position(f)
                end
                self:StopMovingOrSizing()
                self.isMoving = false
            end
        end
    )
    f:SetScript(
        'OnHide',
        function(self)
            if (self.isMoving) then
                self:StopMovingOrSizing()
                self.isMoving = false
            end
        end
    )
end

function oq.moveto(f, x, y)
    if (y >= 0) then
        if (x >= 0) then
            f:SetPoint('TOPLEFT', f:GetParent(), 'TOPLEFT', x, -1 * y)
        else
            f:SetPoint('TOPRIGHT', f:GetParent(), 'TOPRIGHT', x, -1 * y)
        end
    else
        if (x >= 0) then
            f:SetPoint('BOTTOMLEFT', f:GetParent(), 'BOTTOMLEFT', x, -1 * y)
        else
            f:SetPoint('BOTTOMRIGHT', f:GetParent(), 'BOTTOMRIGHT', x, -1 * y)
        end
    end
end

function oq.move_y(f, y, adjust_br)
    if (f) and (f:GetParent()) then
        local x = floor(f:GetLeft() - f:GetParent():GetLeft())
        y = floor(y)
        f:SetPoint('TOPLEFT', x, -1 * y)

        if (adjust_br) then
            local cx = floor(f:GetWidth())
            local cy = min(25, max(25, floor(f:GetHeight())))
            f:SetPoint('BOTTOMRIGHT', f:GetParent(), 'TOPLEFT', x + cx, -1 * (y + cy))
        end
    end
end

function oq.setpos(f, x, y, cx, cy)
    if (f) then
        oq.moveto(f, x, y)
        if (cx ~= nil) and (cx > 0) then
            f:SetWidth(cx)
        end
        if (cy ~= nil) and (cy > 0) then
            f:SetHeight(cy)
        end
    end
    return f
end

function oq.set_tab_order(a, b)
    a.next_edit = b
    b.prev_edit = a
    a:SetScript(
        'OnTabPressed',
        function(self)
            if (IsShiftKeyDown() == 1) and (self.prev_edit ~= nil) then
                self.prev_edit:SetFocus()
            elseif (self.next_edit ~= nil) then
                self.next_edit:SetFocus()
            end
        end
    )
end

-- dump a count of frame types ready for reuse
--
function oq.frame_report(opt)
    local arg = nil
    if (opt) and (opt:find(' ')) then
        arg = strlower(opt:sub(opt:find(' ') + 1, -1))
    end
    print('--[ frame dump ]--')
    local n = 0
    local s = nil
    local i, v
    for i, v in pairs(oq.__frame_pool) do
        if (arg == nil) or (strlower(i):find(arg)) then
            n = tbl.size(v)
            if (n <= 1) then
                s = '-'
            else
                s = tostring(n - 1)
            end
            print(' ' .. s .. ' / ' .. tostring(v[0] or 0) .. ' ' .. tostring(i))
        end
    end
    print('--')
    print('in-use: ' .. tostring(tbl.size(oq.__frame_pool['#check'])))
    print('tables: ' .. tostring(tbl.size(tbl.__pool)) .. ' of ' .. tostring(tbl._count))
end

function oq.frames_inuse_report(opt)
    local arg = nil
    if (opt) and (opt:find(' ')) then
        arg = strlower(opt:sub(opt:find(' ') + 1, -1))
    end
    print('--[ frames inuse ]--')
    local n = 0
    local s = nil
    local i, v
    for i, v in pairs(oq.__frame_pool['#check']) do
        if (arg == nil) or (strlower(v):find(arg)) then
            if (i.raid_token) then
                local p = oq.premades[i.raid_token]
                if (p) then
                    if (p._row) then
                        print(
                            ' ' ..
                                tostring(v) ..
                                    '  ' ..
                                        tostring(i) ..
                                            '  tok(' ..
                                                tostring(i.raid_token) ..
                                                    ') ' .. ' |cFF20F020' .. tostring(p._row) .. '|r '
                        )
                    else
                        print(
                            ' ' ..
                                tostring(v) ..
                                    '  ' .. tostring(i) .. '  tok(' .. tostring(i.raid_token) .. ') ' .. ' no row'
                        )
                    end
                else
                    print(' ' .. tostring(v) .. '  ' .. tostring(i) .. '  tok(' .. tostring(i.raid_token) .. ') ')
                end
            else
                print(' ' .. tostring(v) .. '  ' .. tostring(i))
            end
        end
    end
    print('--')
end

function oq.DeleteFrame(f)
    if (f == nil) then
        return nil
    end
    if (type(f) ~= 'table') then
        return nil
    end
    f:Hide()
    f:SetParent(nil)
    local key = oq.__frame_pool['#check'][f]
    tbl.push(oq.__frame_pool[key], f)
    oq.__frame_pool['#check'][f] = nil
    return nil
end

function oq.CreateFrame(type_, name, parent, template)
    type_ = strlower(type_)
    name = strlower(name)

    if (oq.__frame_pool[name] == nil) then
        oq.__frame_pool[name] = tbl.new()
        tbl.clear(oq.__frame_pool[name])
        oq.__frame_pool[name][0] = 0
    end

    local pool = oq.__frame_pool[name]
    local ndx = tbl.next(pool)
    local f = nil
    if (ndx) and (pool[ndx]) and (type(pool[ndx]) == 'table') and (pool[ndx].SetParent) then
        f = pool[ndx]
        pool[ndx] = nil
        f:SetParent(parent)
    else
        f = CreateFrame(type_, name, parent, template)
        pool[0] = (pool[0] or 0) + 1
    end
    oq.__frame_pool['#check'][f] = name -- track the checked out frames

    if (parent ~= nil) then
        f:SetFrameLevel(parent:GetFrameLevel() + 1)
    end
    return f
end

function oq.editline(parent, name, x, y, cx, cy, max_chars)
    oq.nthings = (oq.nthings or 0) + 1
    local e = oq.CreateFrame('EditBox', 'OQEditline' .. tostring(oq.nthings), parent, 'InputBoxTemplate')
    e:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0)
    e:SetText('')
    e:SetAutoFocus(false)
    e:SetFontObject('GameFontNormal')
    e:SetMaxLetters(max_chars or 30)
    e:SetCursorPosition(0)
    e:SetTextColor(0.9, 0.9, 0.9, 1)
    e.str = ''
    e:SetScript(
        'OnTextChanged',
        function(self)
            self.str = self:GetText() or ''
            if (self.func ~= nil) then
                self.func(self.str)
            end
        end
    )
    e:SetScript(
        'OnEscapePressed',
        function(self)
            self:ClearFocus()
        end
    )
    oq.setpos(e, x, y, cx, cy)
    e:Show()
    return e
end

function oq.editbox(parent, name, x, y, cx, cy, max_chars, func, init_val)
    local e = oq.CreateFrame('EditBox', 'OQEditBox', parent)
    e:SetMultiLine(true)
    e:SetPoint('TOPLEFT', parent, 'TOPLEFT', x - 4, -y)
    e:SetWidth(cx)
    e:SetPoint('BOTTOMRIGHT', parent, 'TOPLEFT', x + cx, -y - cy)
    e.str = init_val or ''
    e.func = func
    e:SetScript(
        'OnTextChanged',
        function(self)
            self.str = self:GetText() or ''
            if (self.func ~= nil) then
                self.func(self, self.str)
            end
        end
    )
    e:SetScript(
        'OnEscapePressed',
        function(self)
            self:ClearFocus()
        end
    )
    e:SetText(init_val or '')
    if (oq.__backdrop17 == nil) then
        oq.__backdrop17 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    e:SetBackdrop(oq.__backdrop17)
    e:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    e:SetAlpha(0.8)
    e:SetAutoFocus(false)
    e:SetFontObject('GameFontNormal')
    e:SetMaxLetters(max_chars or 30)
    e:SetCursorPosition(0)
    e:SetTextColor(0.9, 0.9, 0.9, 1)
    e:SetTextInsets(5, 5, 5, 5)
    oq.setpos(e, x - 4, y, cx, cy)
    e:Show()
    return e
end

function oq.checkbox(parent, x, y, cx, cy, text_cx, text, is_checked, on_click_func)
    local button = oq.CreateFrame('CheckButton', 'OQ_Check', parent, 'UICheckButtonTemplate')
    button:SetWidth(cx)
    button:SetHeight(cy)
    button.string = button:CreateFontString()
    button.string:SetWidth(text_cx)
    button.string:SetJustifyH('LEFT')
    button.string:SetPoint('LEFT', 24, 1)
    button:SetFontString(button.string)
    button:SetNormalFontObject('GameFontNormalSmall')
    button:SetHighlightFontObject('GameFontHighlightSmall')
    button:SetDisabledFontObject('GameFontDisableSmall')
    button:SetText(text)
    button:SetScript('OnClick', on_click_func)
    if (is_checked == 0) then
        is_checked = nil
    end
    button:SetChecked(is_checked)
    oq.moveto(button, x, y)
    button:Show()
    button:SetScript(
        'OnEnter',
        function(self, ...)
            oq.hint(self, self.tt, true)
        end
    )
    button:SetScript(
        'OnLeave',
        function(self, ...)
            oq.hint(self, self.tt, nil)
        end
    )
    return button
end

function oq.radiobutton(parent, x, y, cx, cy, text_cx, text, value, on_click_func)
    local button = oq.CreateFrame('CheckButton', 'OQ_RadioButton', parent, 'UIRadioButtonTemplate')
    button:SetWidth(cx)
    button:SetHeight(cy)
    button.value = value
    button.string = button:CreateFontString()
    button.string:SetWidth(text_cx)
    button.string:SetJustifyH('LEFT')
    button.string:SetPoint('LEFT', 24, 1)
    button:SetFontString(button.string)
    button:SetNormalFontObject('GameFontNormalSmall')
    button:SetHighlightFontObject('GameFontHighlightSmall')
    button:SetDisabledFontObject('GameFontDisableSmall')
    button:SetText(text)
    button:SetScript(
        'OnClick',
        function(self)
            on_click_func(self)
        end
    )
    button:SetChecked(nil)
    oq.moveto(button, x, y)
    button:Show()
    return button
end

function oq.click_label(parent, x, y, cx, cy, text, justify_v, justify_h, font, template)
    local f = oq.CreateFrame('Button', 'OQClikLabel', parent, template)
    f:SetWidth(cx) -- Set these to whatever height/width is needed
    f:SetHeight(cy) -- for your Texture
    f:SetBackdropColor(0.2, 0.9, 0.2, 1.0) -- transparent

    f:SetPoint('TOPLEFT', x, -1 * y)
    f.label = oq.label(f, 0, 0, cx, cy, text, justify_v, justify_h, font)
    f:Show()
    return f
end

function oq.label(parent, x, y, cx, cy, text, justify_v, justify_h, font, strata)
    local label = parent:CreateFontString(nil, strata or 'ARTWORK', font or 'GameFontNormalSmall')
    label:SetWidth(cx)
    label:SetHeight(cy or 25)
    if (justify_v == 'CENTER') then
        justify_v = 'MIDDLE'
    end
    label:SetJustifyV(justify_v or 'MIDDLE')
    label:SetJustifyH(justify_h or 'LEFT')
    label:SetText(text)
    label:Show()
    oq.moveto(label, x, y)
    return label
end

function oq.panel(parent, name, x, y, cx, cy, no_texture)
    local f = oq.CreateFrame('FRAME', name, parent)
    f:SetPoint('TOPLEFT', f:GetParent(), 'TOPLEFT', x, -1 * y)
    f:SetWidth(cx) -- Set these to whatever height/width is needed
    f:SetHeight(cy) -- for your Texture
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)

    if (not no_texture) then
        local t = f:CreateTexture(nil, 'BACKGROUND')
        t:SetAllPoints(f)
        t:SetDrawLayer('BACKGROUND')
        f.texture = t
    end
    return f
end

function oq.click_panel(parent, name, x, y, cx, cy, no_texture)
    local f = oq.CreateFrame('BUTTON', name, parent)
    f:SetPoint('TOPLEFT', f:GetParent(), 'TOPLEFT', x, -1 * y)
    f:SetWidth(cx) -- Set these to whatever height/width is needed
    f:SetHeight(cy) -- for your Texture
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)

    if (not no_texture) then
        local t = f:CreateTexture(nil, 'BACKGROUND')
        t:SetAllPoints(f)
        t:SetDrawLayer('BACKGROUND')
        f.texture = t
    end
    return f
end

function oq.simple_texture(f, x, y, cx, cy, texture, layer)
    if (f == nil) then
        return nil
    end
    local t = f:CreateTexture(nil, layer or 'ARTWORK')
    t:SetTexture(texture)
    t:SetWidth(cx)
    t:SetHeight(cy)
    t:SetAlpha(1.0)
    t:SetPoint('TOPLEFT', x, -1 * y)
    t:SetBlendMode('BLEND')
    return t
end

function oq.texture(parent, x, y, cx, cy, texture)
    local f = oq.CreateFrame('FRAME', 'OQ_Texture', parent)
    f:SetWidth(cx)
    f:SetHeight(cy)
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)

    local t = f:CreateTexture(nil, 'BACKGROUND')
    t:SetTexture(texture)
    t:SetAllPoints(f)
    t:SetAlpha(1.0)
    f.texture = t

    f:SetPoint('TOPLEFT', x, -1 * y)
    f:Show()
    return f
end

function oq.texture_button(parent, x, y, cx, cy, up_texture, dn_texture, disable_texture, click_func)
    local f = oq.CreateFrame('BUTTON', 'OQ_TexturedButton', parent)
    f:SetWidth(cx)
    f:SetHeight(cy)
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
    f:SetText('')
    f._dn_texture = dn_texture
    f._up_texture = up_texture
    f._disable_texture = disable_texture
    f:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    f:SetScript(
        'OnMouseDown',
        function(self, button)
            if (self._dn_texture) and (self:IsEnabled()) then
                self.texture:SetTexture(self._dn_texture)
            elseif (self.texture) then
                self.texture:SetTexCoord(3 / 64, 61 / 64, 3 / 64, 61 / 64)
            end
        end
    )
    f:SetScript(
        'OnMouseUp',
        function(self, button)
            if (self._up_texture) and (self:IsEnabled()) then
                self.texture:SetTexture(self._up_texture)
            elseif (self.texture) then
                self.texture:SetTexCoord(0 / 64, 64 / 64, 0 / 64, 64 / 64)
            end
        end
    )
    f:SetScript('OnClick', click_func)

    local t = f:CreateTexture(nil, 'BACKGROUND')
    t:SetTexture(up_texture)
    t:SetAllPoints(f)
    t:SetAlpha(1.0)
    f.texture = t

    f:SetPoint('TOPLEFT', x, -1 * y)
    f:Show()
    return f
end

function oq.next_button(parent, x, y, func)
    local f =
        oq.texture_button(
        parent,
        x,
        y,
        OQ.BUTTON_SZ,
        OQ.BUTTON_SZ,
        OQ.BUTTON_NEXT_UP,
        OQ.BUTTON_NEXT_DN,
        OQ.BUTTON_NEXT_DISABLED
    )
    f:SetScript('OnClick', func)
    return f
end

function oq.prev_button(parent, x, y, func)
    local f =
        oq.texture_button(
        parent,
        x,
        y,
        OQ.BUTTON_SZ,
        OQ.BUTTON_SZ,
        OQ.BUTTON_PREV_UP,
        OQ.BUTTON_PREV_DN,
        OQ.BUTTON_PREV_DISABLED
    )
    f:SetScript('OnClick', func)
    return f
end

function oq.button_enable(f)
    if (f == nil) then
        return
    end
    f.texture:SetTexture(f._up_texture)
    f:Enable()
end

function oq.button_disable(f)
    if (f == nil) then
        return
    end
    f.texture:SetTexture(f._disable_texture)
    f:Disable()
end

function oq.button(parent, x, y, cx, cy, text, on_click_func)
    local button = oq.CreateFrame('Button', 'OQButton', parent, 'UIPanelButtonTemplate')

    button:SetWidth(cx)
    button:SetHeight(cy)
    button:SetNormalFontObject('GameFontNormalSmall')
    button:SetHighlightFontObject('GameFontHighlightSmall')
    button:SetDisabledFontObject('GameFontDisableSmall')
    button:SetText(text or '')
    button:SetScript('OnClick', on_click_func)
    oq.moveto(button, x, y)
    button:Show()
    button:SetScript(
        'OnEnter',
        function(self, ...)
            oq.hint(self, self.tt, true)
        end
    )
    button:SetScript(
        'OnLeave',
        function(self, ...)
            oq.hint(self, self.tt, nil)
        end
    )

    return button
end

function oq.button2(parent, x, y, cx, cy, text, font_sz, on_click_func)
    local button = oq.CreateFrame('Button', 'OQButton2', parent, 'UIPanelButtonTemplate')

    button:SetWidth(cx)
    button:SetHeight(cy)
    button.string = button:CreateFontString()
    button.string:SetJustifyH('CENTER')
    button.string:SetPoint('CENTER', 0, 0)
    button.font_sz = font_sz or 11
    button.string:SetFont(OQ.FONT, button.font_sz, '')
    button:SetFontString(button.string)
    button:SetText(text)
    button:SetScript('OnClick', on_click_func)
    oq.moveto(button, x, y)
    button:Show()
    button:SetScript(
        'OnEnter',
        function(self, ...)
            oq.hint(self, self.tt, true)
        end
    )
    button:SetScript(
        'OnLeave',
        function(self, ...)
            oq.hint(self, self.tt, nil)
        end
    )
    return button
end

function oq.closebox(parent, on_close)
    local closepb = oq.CreateFrame('Button', 'OQClose', parent, 'UIPanelCloseButton')
    closepb:SetWidth(25)
    closepb:SetHeight(25)
    closepb:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', -7, -7)
    if (on_close == nil) then
        closepb:SetScript(
            'OnClick',
            function(self)
                self:GetParent():Hide()
            end
        )
    else
        closepb:SetScript('OnClick', on_close)
    end
    closepb:Show()
    return closepb
end

function oq.menu_clear()
    oq.__menu:Hide()
    local i
    for i = 1, OQ.MAX_MENU_OPTIONS do
        if (oq.__menu_options[i]) then
            oq.__menu_options[i]:Hide()
            oq.__menu_options[i]._text = nil
            oq.__menu_options[i]._checked = nil
            oq.__menu_options[i]._arg1 = nil
            oq.__menu_options[i]._arg2 = nil
            oq.__menu_options[i]._func = nil
        end
    end
end

function oq.menu_create()
    if (oq.__menu == nil) then
        oq.__menu = oq.CreateFrame('FRAME', 'OQMenu', UIParent)
        oq.__menu_options = tbl.new()
        if (oq.__backdrop18 == nil) then
            oq.__backdrop18 = {
                bgFile = 'Interface/Tooltips/CHATBUBBLE-BACKGROUND',
                edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
                tile = true,
                tileSize = 16,
                edgeSize = 16,
                insets = {left = 1, right = 1, top = 1, bottom = 2}
            }
        end
        oq.__menu:SetBackdrop(oq.__backdrop18)
        oq.__menu:SetBackdropColor(1, 0, 0)
        oq.__menu:SetAlpha(1.0)
        oq.__menu._cy = 18
        oq.__menu:SetScript(
            'OnShow',
            function(self, ...)
                self._last_move_tm = GetTime()
            end
        )
        oq.__menu:SetScript(
            'OnHide',
            function(self, ...)
                self._last_move_tm = nil
            end
        )
        oq.__menu:SetScript(
            'OnUpdate',
            function(self, ...)
                if ((self._last_move_tm) and (abs(GetTime() - self._last_move_tm) > OQ.MENU_DISPLAY_TM)) then
                    self:Hide()
                end
            end
        )

        local y = 8
        local i
        for i = 1, OQ.MAX_MENU_OPTIONS do
            local m = oq.CreateFrame('BUTTON', 'OQMenuOption', oq.__menu)
            y = oq.__menu._cy * (i - 1)
            if (oq.__backdrop19 == nil) then
                oq.__backdrop19 = {
                    bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
                    tile = true,
                    tileSize = 16,
                    edgeSize = 16,
                    insets = {left = 1, right = 1, top = 1, bottom = 1}
                }
            end
            m:SetBackdrop(oq.__backdrop19)
            m:SetBackdropColor(0, 0, 0)
            m:SetAlpha(1.0)
            m:SetPoint('TOP', oq.__menu, 'TOP', 0, -1 * y - 4)
            m:SetPoint('LEFT', oq.__menu, 'LEFT', 3, 0)
            m:SetPoint('RIGHT', oq.__menu, 'RIGHT', -3, 0)
            m:SetHeight(oq.__menu._cy + 4)

            local t = m:CreateTexture(nil, 'BORDER')
            t:SetTexture('INTERFACE/QUESTFRAME/UI-QuestTitleHighlight')
            t:SetPoint('TOPLEFT', 5, 0, 'TOPLEFT', 0, 0)
            t:SetPoint('BOTTOMRIGHT', -5, 0, 'BOTTOMRIGHT', 0, 0)
            t:SetAlpha(0.6)
            t:Hide()
            m._highlight = t
            m._label = oq.label(m, 18, 3, 160, oq.__menu._cy, '')
            m._label:SetTextColor(1, 1, 1, 1)
            m:SetScript(
                'OnEnter',
                function(self, ...)
                    if (self._func) then
                        self._highlight:Show()
                    end
                    if (self:GetParent()) then
                        self:GetParent()._last_move_tm = GetTime()
                    end
                end
            )
            m:SetScript(
                'OnLeave',
                function(self, ...)
                    if (self._func) then
                        self._highlight:Hide()
                    end
                    if (self:GetParent()) then
                        self:GetParent()._last_move_tm = GetTime()
                    end
                end
            )
            m:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
            m:SetScript(
                'OnClick',
                function(self, button)
                    local stay_open = nil
                    if (self._func) then
                        stay_open = self._func(self:GetParent():GetParent(), self._arg1, self._arg2, button)
                        PlaySound('igMainMenuOptionCheckBoxOff')
                    end
                    if (not stay_open) then
                        self:GetParent():Hide()
                    end
                end
            )
            oq.__menu_options[i] = m
        end
    end
    oq.menu_clear()
    return oq.__menu
end

function oq.menu_add(text, arg1, arg2, checked, func)
    if (oq.__menu == nil) then
        oq.menu_create()
    end

    local i
    for i = 1, OQ.MAX_MENU_OPTIONS do
        if (oq.__menu_options[i]) and (oq.__menu_options[i]._text == nil) then
            local m = oq.__menu_options[i]
            m._text = text
            m._checked = checked
            m._arg1 = arg1
            m._arg2 = arg2
            m._func = func
            m._label:SetText(text)
            m:Show()
            return
        end
    end
end

function oq.menu_show_core(f, width)
    if (oq.__menu) then
        local n = 0
        local i
        for i = 1, OQ.MAX_MENU_OPTIONS do
            if (oq.__menu_options[i]) and (oq.__menu_options[i]._text ~= nil) then
                n = n + oq.__menu._cy
            else
                break
            end
        end
        oq.__menu._height = max(10, n + 16)
        oq.__menu._width = width or f:GetWidth()

        oq.__menu:SetParent(f)
        oq.__menu:SetFrameStrata('HIGH')
        oq.__menu:SetFrameLevel(120)

        oq.__menu:SetWidth(oq.__menu._width)
        oq.__menu:SetHeight(oq.__menu._height)
        oq.__menu:Raise()
        PlaySound('igMainMenuOptionCheckBoxOn')
    end
end

function oq.menu_show(f, my_corner, adj_x, adj_y, their_corner, width)
    if (oq.__menu) then
        oq.menu_show_core(f, width)
        oq.__menu:SetPoint(my_corner, adj_x, adj_y, their_corner, 0, 0)
        oq.__menu:Show()
    end
end

function oq.menu_show_aligned(f, adj_x, adj_y, width)
    if (oq.__menu) then
        oq.menu_show_core(UIParent, width)

        oq.__menu:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', f:GetLeft(), f:GetBottom() - 2)
        oq.__menu:SetWidth(oq.__menu._width)
        oq.__menu:SetHeight(oq.__menu._height)
        oq.__menu:Show()
    end
end

function oq.menu_show_at_cursor(width, adj_x, adj_y)
    if (oq.__menu) then
        oq.menu_show_core(UIParent, width)

        local cursorX, cursorY = GetCursorPosition()
        cursorX = floor(cursorX / UIParent:GetEffectiveScale())
        cursorY = floor(cursorY / UIParent:GetEffectiveScale())
        oq.__menu:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', cursorX + adj_x, cursorY + adj_y)
        oq.__menu:Show()
    end
end

function oq.menu_hide()
    if (oq.__menu) then
        PlaySound('igMainMenuOptionCheckBoxOff')
        oq.__menu:Hide()
    end
end

function oq.menu_is_visible()
    if (oq.__menu) then
        return oq.__menu:IsVisible()
    end
    return nil
end

function oq.combo_box(parent, x, y, edit_cx, cy, populate_list_func, init_text)
    local cb = oq.texture_button(parent, x + edit_cx + 2, y, 16, cy, OQ.DOWNARROW_UP, OQ.DOWNARROW_DOWN)
    cb:SetFrameLevel(parent:GetFrameLevel() + 5)
    cb._populate = populate_list_func
    cb._edit = oq.editbox(parent, cb:GetName() .. 'Edit', x, y, edit_cx, cy, 35, nil, '')
    cb._edit:SetFontObject('GameFontNormalSmall')
    cb._edit:SetTextColor(1, 1, 1, 1)
    cb._edit:SetTextInsets(10, 5, 7, 2)
    cb._edit:Disable()
    cb._edit:SetText(init_text or '')
    cb._edit:SetFrameLevel(parent:GetFrameLevel() + 5)
    cb._edit:SetWidth(edit_cx)
    cb.__width = edit_cx + 22
    cb:SetScript(
        'OnClick',
        function(self, button)
            if (oq.menu_is_visible()) then
                oq.menu_hide()
            else
                if (self._populate) then
                    self._populate()
                end
                oq.menu_show(self._edit, 'TOPLEFT', 0, -25, 'BOTTOMLEFT', self.__width or (self._edit:GetWidth() + 22))
            end
        end
    )
    return cb
end

function oq.button_pulldown(parent, x, y, cx, cy, populate_list_func, init_texture)
    local cb = oq.texture_button(parent, x + cx + 2, y, 16, cy, OQ.DOWNARROW_UP, OQ.DOWNARROW_DOWN)
    cb:SetFrameLevel(parent:GetFrameLevel() + 5)
    cb._selected = oq.texture(parent, x, y, cx, cy, init_texture)
    if (init_texture == nil) then
        cb._selected.texture:SetTexture(OQ.PLACEHOLDER)
    end
    cb._populate = populate_list_func
    cb:SetScript(
        'OnClick',
        function(self, button)
            if (oq.menu_is_visible()) then
                oq.menu_hide()
            else
                if (self._populate) then
                    self._populate()
                end
                oq.menu_show(
                    self._selected,
                    'TOPLEFT',
                    0,
                    -25,
                    'BOTTOMLEFT',
                    self._selected:GetWidth() * 2 + (self.__width or 130)
                )
            end
        end
    )
    return cb
end

function oq.pushbutton_pulldown(parent, x, y, cx, cy, populate_list_func, init_texture)
    local cb =
        oq.texture_button(
        parent,
        x,
        y,
        cx,
        cy,
        init_texture,
        init_texture,
        nil,
        function(self, button)
            if (oq.menu_is_visible()) then
                oq.menu_hide()
            else
                if (self._populate) then
                    self._populate()
                end
                oq.menu_show(self, 'TOPLEFT', 0, -25, 'BOTTOMLEFT', self:GetWidth() * 2 + (self.__width or 130))
            end
        end
    )
    cb:SetFrameLevel(parent:GetFrameLevel() + 5)
    if (init_texture == nil) then
        cb.texture:SetTexture(OQ.PLACEHOLDER)
    end
    cb._populate = populate_list_func

    return cb
end
