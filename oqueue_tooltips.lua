local _, OQ = ...
local L = OQ._T -- for literal string translations
local oq = OQ:mod() -- thank goodness i stumbled across this trick
local _  -- throw away (was getting taint warning; what happened blizz?)
local tbl = OQ.table

OQ.EMPTY_SQUARE = 'Interface\\Addons\\oqueue\\art\\square_middle.tga'

local function comma_value(n) -- credit http://richard.warburton.it
    if (n == nil) then
        n = 0
    end
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

--------------------------------------------------------------------------
-- main premade hover over tooltip functions
--------------------------------------------------------------------------
function oq.tooltip_label(tt, x, y, align, cx)
    local t = tt:CreateFontString()
    t:SetFontObject(GameFontNormal)
    t:SetWidth(cx or (tt:GetWidth() - (x + 2 * 15)))
    t:SetHeight(15)
    t:SetJustifyV('MIDDLE')
    t:SetJustifyH(align)
    t:SetText('')
    t:Show()
    t:SetPoint('TOPLEFT', tt, 'TOPLEFT', x, -1 * y)
    return t
end

function oq.tooltip_create()
    if (oq.tooltip ~= nil) then
        return oq.tooltip
    end
    local tooltip = oq.CreateFrame('FRAME', 'OQTooltip', UIParent, nil)
    if (oq.__backdrop20 == nil) then
        oq.__backdrop20 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {
                left = 4,
                right = 3,
                top = 4,
                bottom = 3
            }
        }
    end
    tooltip:SetBackdrop(oq.__backdrop20)
    tooltip:SetBackdropColor(0.0, 0.0, 0.0, 1.0)

    -- class portrait
    local f = oq.CreateFrame('FRAME', 'OQTooltipPortraitFrame', tooltip)
    f:SetWidth(35)
    f:SetHeight(35)
    f:SetBackdropColor(0.0, 0.8, 0.8, 1.0)

    local t = tooltip:CreateTexture(nil, 'OVERLAY')
    t:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
    t:SetAllPoints(f)
    t:SetAlpha(1.0)
    f.texture = t

    f:SetPoint('TOPRIGHT', -6, -1 * 6)
    f:Show()
    tooltip.portrait = f

    local x = 5
    local y = 8
    local cy = 15
    tooltip.nRows = 20
    tooltip:SetHeight((tooltip.nRows + 1) * (cy) + 10)
    tooltip:SetWidth(210) -- 240

    tooltip.left = tbl.new()
    tooltip.right = tbl.new()

    for i = 1, tooltip.nRows do
        if (i == (tooltip.nRows - 1)) or (i == (tooltip.nRows)) then
            tooltip.left[i] = oq.tooltip_label(tooltip, x, y, 'LEFT')
            tooltip.left[i]:SetWidth(tooltip:GetWidth() - 3)
        else
            tooltip.left[i] = oq.tooltip_label(tooltip, x, y, 'LEFT')
        end
        if (i == 2) then
            tooltip.right[i] = oq.tooltip_label(tooltip, x, y, 'RIGHT')
            tooltip.right[i]:SetWidth(tooltip:GetWidth() - (x + 3 * 15))
        else
            tooltip.right[i] = oq.tooltip_label(tooltip, x, y, 'RIGHT')
        end
        if (i == 1) then
            x = x + 10
            y = y + 2
            tooltip.left[i]:SetFont(OQ.FONT, 12, '')
            tooltip.right[i]:SetFont(OQ.FONT, 12, '')
        else
            tooltip.left[i]:SetTextColor(0.6, 0.6, 0.6)
            tooltip.left[i]:SetFont(OQ.FONT, 10, '')

            tooltip.right[i]:SetTextColor(0.9, 0.9, 0.25)
            tooltip.right[i]:SetFont(OQ.FONT, 10, '')
        end
        y = y + cy
        if (i == (tooltip.nRows - 1)) or (i == (tooltip.nRows - 2)) then
            y = y + 5 -- spacer before last row
        end
    end

    local ext = oq.CreateFrame('FRAME', 'OQTooltipExtra', UIParent, nil)
    ext:SetBackdrop(oq.__backdrop20)
    ext:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    local cx = tooltip:GetWidth()
    cy = tooltip:GetHeight()
    ext:SetWidth(cx)
    ext:SetHeight(5 * 25)
    ext.header = oq.label(ext, 10, 10, cx - 2 * 10, 25, L['user comment'], 'TOP', 'LEFT')
    ext.header:SetFont(OQ.FONT, 12, '')
    ext.note = oq.label(ext, 10, 35, cx - 2 * 10, cy - 35 - 10, '', 'TOP', 'LEFT')
    ext.note:SetTextColor(0.9, 0.9, 0.9)
    tooltip._extra = ext

    oq.tooltip = tooltip
    return tooltip
end

function oq.tooltip_clear()
    local tooltip = oq.tooltip
    if (tooltip ~= nil) then
        for i = 1, tooltip.nRows do
            tooltip.left[i]:SetText('')
            tooltip.right[i]:SetText('')
        end
    end
end

function oq.make_achieve_icon(id)
    if (id == 0) then
        return '|T' .. OQ.EMPTY_SQUARE .. ':24:24:0:0|t'
    --    return "|T".. OQ.EMPTY_GEMSLOTS["Blue"] ..":24:24:0:0|t" ;
    end
    return '|T' .. select(10, GetAchievementInfo(id)) .. '.blp:24:24:0:0|t'
end

function oq.make_achieve_icon_if(id, b, mask)
    if (id == 0) or (oq.is_set(b, mask) == nil) then
        return '|T' .. OQ.EMPTY_SQUARE .. ':24:24:0:0|t'
    --    return "|T".. OQ.EMPTY_GEMSLOTS["Blue"] ..":24:24:0:0|t" ;
    end
    return '|T' .. select(10, GetAchievementInfo(id)) .. '.blp:24:24:0:0|t'
end

function oq.get_rank_achieves(s)
    if (s == nil) then
        return ''
    end
    -- local rank_id = oq.decode_mime64_digits(s:sub(1, 1))
    local t1 = oq.decode_mime64_digits(s:sub(2, 2))
    local t2 = oq.decode_mime64_digits(s:sub(3, 3))
    local t3 = oq.decode_mime64_digits(s:sub(4, 4))
    local str = ''
    if (oq.player_faction == 'H') then
        str = str .. '' .. oq.make_achieve_icon_if(1175, t2, 0x01) -- battlemaster
        str = str .. '' .. oq.make_achieve_icon_if(8055, t2, 0x20) -- khan
        str = str .. '' .. oq.make_achieve_icon_if(714, t2, 0x02) -- conqueror
        str = str .. '' .. oq.make_achieve_icon_if(5363, t2, 0x04) -- bloodthirsty
        str = str .. '' .. oq.make_achieve_icon_if(5326, t1, 0x02) -- warbringer
        str = str .. '' .. oq.make_achieve_icon_if(6941, t1, 0x01) -- hero of the horde
    else
        str = str .. '' .. oq.make_achieve_icon_if(230, t2, 0x01) -- battlemaster
        str = str .. '' .. oq.make_achieve_icon_if(8052, t2, 0x20) -- khan
        str = str .. '' .. oq.make_achieve_icon_if(907, t2, 0x02) -- conq
        str = str .. '' .. oq.make_achieve_icon_if(5363, t2, 0x04) -- bloodthirsty
        str = str .. '' .. oq.make_achieve_icon_if(5329, t1, 0x02) -- warbound
        str = str .. '' .. oq.make_achieve_icon_if(6942, t1, 0x01) -- hero of the alliance
    end
    -- arena (seems to be the same for both)
    if (oq.is_set(t3, 0x02) ~= nil) then -- gladiator
        str = str .. '' .. oq.make_achieve_icon(2091)
    elseif (oq.is_set(t3, 0x04) ~= nil) then -- duelist
        str = str .. '' .. oq.make_achieve_icon(2092)
    elseif (oq.is_set(t3, 0x08) ~= nil) then -- rival
        str = str .. '' .. oq.make_achieve_icon(2093)
    else
        --    str = str .."".. "|T".. OQ.EMPTY_GEMSLOTS["Blue"] ..":24:24:0:0|t" ;
        str = str .. '' .. '|T' .. OQ.EMPTY_SQUARE .. ':24:24:0:0|t'
    end
    str = str .. '' .. oq.make_achieve_icon_if(1174, t3, 0x01) -- arena master

    return str
end

function oq.get_rank_icons(s)
    if (s == nil) then
        return ''
    end
    local rank_id = oq.decode_mime64_digits(s:sub(1, 1))
    if (OQ.rbg_rank[rank_id] == nil) or (OQ.rbg_rank[rank_id].id == 0) then
        return ''
    end
    return oq.make_achieve_icon(OQ.rbg_rank[rank_id].id)
end

function oq.get_rank_str(s)
    if (s == nil) then
        return ''
    end
    local rank_id = oq.decode_mime64_digits(s:sub(1, 1))
    if (OQ.rbg_rank[rank_id] == nil) or (OQ.rbg_rank[rank_id].str == 0) then
        return ''
    end
    return OQ.rbg_rank[rank_id].str
end

OQ.GOLD_MEDAL = '|TInterface\\Challenges\\ChallengeMode_Medal_Gold.blp:24:24:0:0|t'
OQ.SILVER_MEDAL = '|TInterface\\Challenges\\ChallengeMode_Medal_Silver.blp:24:24:0:0|t'
OQ.BRONZE_MEDAL = '|TInterface\\Challenges\\ChallengeMode_Medal_Bronze.blp:24:24:0:0|t'

OQ.LIL_GOLD_MEDAL = '|TInterface\\Challenges\\ChallengeMode_Medal_Gold.blp:18:18:0:0|t'
OQ.LIL_SILVER_MEDAL = '|TInterface\\Challenges\\ChallengeMode_Medal_Silver.blp:18:18:0:0|t'
OQ.LIL_BRONZE_MEDAL = '|TInterface\\Challenges\\ChallengeMode_Medal_Bronze.blp:18:18:0:0|t'

function oq.get_medal(medal, s)
    if (s == nil) then
        return ''
    end
    s = 'FF'
    if (medal == 'gold') then
        return oq.decode_mime64_digits(s) .. ' ' .. OQ.GOLD_MEDAL
    elseif (medal == 'silver') then
        return oq.decode_mime64_digits(s) .. ' ' .. OQ.SILVER_MEDAL
    elseif (medal == 'bronze') then
        return oq.decode_mime64_digits(s) .. ' ' .. OQ.BRONZE_MEDAL
    end
    return ''
end

function oq.get_medals(s)
    if (s == nil) then
        return ''
    end
    local str = ''

    str = str .. '' .. oq.get_medal('gold', s:sub(5, 6)) .. ' '
    str = str .. '' .. oq.get_medal('silver', s:sub(3, 4)) .. ' '
    str = str .. '' .. oq.get_medal('bronze', s:sub(1, 2)) .. ' '
    return str
end

function oq.tt_int(tt, ndx, left_txt, n)
    tt.left[ndx]:SetText(left_txt)
    tt.right[ndx]:SetText(tostring(n or 0))
end

function oq.tt_perc(tt, ndx, left_txt, n)
    tt.left[ndx]:SetText(left_txt)
    tt.right[ndx]:SetText(string.format('%.2f%%', n or 0))
end

function oq.tt_str(tt, ndx, left_txt, right_txt)
    tt.left[ndx]:SetText(left_txt)
    tt.right[ndx]:SetText(right_txt)
end

function oq.tt_raids(tt, ndx, left_txt, right_txt)
    tt.left[ndx]:SetText(left_txt)
    tt.right[ndx]:SetText(right_txt)
end

function oq.tooltip_set2(f, m, totheside, is_lead)
    if (m == nil) then
        return
    end
    local tooltip = oq.tooltip_create()
    tooltip:ClearAllPoints()
    totheside = true
    if (totheside) then
        tooltip:SetParent(OQMainFrame, 'ANCHOR_RIGHT')
        tooltip:SetPoint('TOPLEFT', OQMainFrame, 'TOPRIGHT', 10, 0)
        tooltip:SetFrameLevel(OQMainFrame:GetFrameLevel() + 10)
    else
        tooltip:SetParent(f, 'ANCHOR_RIGHT')
        tooltip:SetPoint('TOPLEFT', tooltip:GetParent(), 'TOPRIGHT', 10, 0)
        tooltip:SetFrameLevel(f:GetFrameLevel() + 10)
    end
    oq.tooltip_clear()

    if (OQ.CLASS_COLORS[m.class] == nil) then
        return
    end

    tooltip.left[1]:SetText(m.name .. ' (' .. tostring(m.level or 0) .. ')')
    tooltip.left[1]:SetTextColor(OQ.CLASS_COLORS[m.class].r, OQ.CLASS_COLORS[m.class].g, OQ.CLASS_COLORS[m.class].b, 1)
    tooltip.left[2]:SetText(m.realm)
    tooltip.left[2]:SetTextColor(0.0, 0.9, 0.9, 1)

    tooltip.right[2]:SetText(oq.get_rank_icons(m.ranks))

    local spec = oq.get_class_type(m.spec_id) or oq.get_class_spec(m.spec_id)
    if (spec) then
        tooltip.right[3]:SetText(spec.n:sub(4, -1))
    end

    tooltip.left[5]:SetText(OQ.TT_ILEVEL)
    tooltip.right[5]:SetText(m.ilevel)

    if
        oq.is_dungeon_premade(m.premade_type) or (m.premade_type == OQ.TYPE_RAID) or (m.premade_type == OQ.TYPE_QUESTS) or
            (m.premade_type == OQ.TYPE_ROLEPLAY)
     then
        if (m.spec_type == OQ.TANK) then
            oq.tt_perc(tooltip, 8, 'melee hit', m.melee_hit)
            oq.tt_int(tooltip, 9, 'armor', m.armor)
            oq.tt_int(tooltip, 10, 'stam', m.stam)
            oq.tt_int(tooltip, 11, 'agil', m.agil)
            oq.tt_int(tooltip, 12, 'str', m.str)
        elseif (m.spec_type == OQ.CASTER) then
            oq.tt_perc(tooltip, 8, 'spell hit', m.spell_hit)
            oq.tt_int(tooltip, 9, 'spell dmg', m.spell_dmg)
            oq.tt_perc(tooltip, 10, 'spell crit', m.spell_crit)
            oq.tt_perc(tooltip, 11, 'spell haste', m.spell_haste)
            oq.tt_int(tooltip, 12, 'int', m.int)
            oq.tt_int(tooltip, 13, 'spr', m.spr)
        elseif (m.spec_type == OQ.HEALER) then
            oq.tt_int(tooltip, 8, 'bonus heal', m.bonus_heal)
            oq.tt_int(tooltip, 9, 'spr', m.spr)
            oq.tt_int(tooltip, 10, 'heal mp5', m.heal_mp5)
			oq.tt_perc(tooltip, 11, 'spell haste', m.spell_haste)
            oq.tt_int(tooltip, 12, 'int', m.int)
            oq.tt_perc(tooltip, 13, 'spell crit', m.spell_crit)
        elseif (m.spec_type == OQ.RDPS) then
            oq.tt_perc(tooltip, 8, 'ranged hit', m.ranged_hit)
            oq.tt_int(tooltip, 9, 'agil', m.agil)
            oq.tt_int(tooltip, 10, 'stam', m.stam)
            oq.tt_int(tooltip, 11, 'int', m.int)
            oq.tt_int(tooltip, 12, 'spr', m.spr)
            oq.tt_perc(tooltip, 13, 'ranged crit', m.ranged_crit)
            oq.tt_int(tooltip, 14, 'ranged power', m.ranged_atk_pow)
        elseif (m.spec_type == OQ.MDPS) then
            oq.tt_perc(tooltip, 8, 'melee hit', m.melee_hit)
            oq.tt_int(tooltip, 9, 'str', m.str)
            oq.tt_int(tooltip, 10, 'agil', m.agil)
            oq.tt_perc(tooltip, 11, 'melee crit', m.melee_crit)
            oq.tt_int(tooltip, 12, 'melee power', m.melee_atk_pow)
        end
        if (m.premade_type == OQ.TYPE_CHALLENGE) then
            tooltip.left[14]:SetText('medals')
            local str = ''
            local n
            n = oq.decode_mime64_digits(m.raids and m.raids:sub(5, 6))
            if (n > 0) then
                str = str .. '' .. tostring(n) .. 'x ' .. OQ.GOLD_MEDAL
            end
            n = oq.decode_mime64_digits(m.raids and m.raids:sub(3, 4))
            if (n > 0) then
                str = str .. ' ' .. tostring(n) .. 'x ' .. OQ.SILVER_MEDAL
            end
            n = oq.decode_mime64_digits(m.raids and m.raids:sub(1, 2))
            if (n > 0) then
                str = str .. ' ' .. tostring(n) .. 'x ' .. OQ.BRONZE_MEDAL
            end
            if (str == '') then
                str = '--'
            end
            tooltip.right[14]:SetText(str)
        end
        tooltip.left[tooltip.nRows]:SetText(OQ.TT_OQVERSION)
        tooltip.right[tooltip.nRows]:SetText(oq.get_version_str(m.oq_ver))
    else
        if (m.premade_type == OQ.TYPE_ARENA) and (m.pdata) and (m.pdata:sub(1, 1) == '+') then
            tooltip.left[6]:SetText(OQ.TT_MAXHP)
            tooltip.right[6]:SetText(tostring(m.hp or 0) .. ' k')
            tooltip.left[7]:SetText(OQ.TT_HKS)
            tooltip.right[7]:SetText(tostring(m.hks or 0) .. ' k')
            tooltip.left[8]:SetText(OQ.TT_TEARS)
            tooltip.right[8]:SetText(tostring(m.tears or 0))

            local ratings = '|cFFF0F0A0' .. tostring(m.mmr) .. '|r'
            tooltip.left[10]:SetText(OQ.TT_MMR)
            tooltip.right[10]:SetText(ratings)
            tooltip.left[11]:SetText('rank: 2v2')
            tooltip.right[11]:SetText(OQ.ARENA_RANK_ACHIEVE[oq.decode_mime64_digits(m.pdata:sub(2, 2))] or '')
            tooltip.left[12]:SetText('rank: 3v3')
            tooltip.right[12]:SetText(OQ.ARENA_RANK_ACHIEVE[oq.decode_mime64_digits(m.pdata:sub(3, 3))] or '')
            tooltip.left[13]:SetText('rank: 5v5')
            tooltip.right[13]:SetText(OQ.ARENA_RANK_ACHIEVE[oq.decode_mime64_digits(m.pdata:sub(4, 4))] or '')
        else
            tooltip.left[6]:SetText(OQ.TT_RESIL)
            tooltip.right[6]:SetText(m.resil)
            tooltip.left[7]:SetText(OQ.TT_PVPPOWER)
            tooltip.right[7]:SetText(comma_value(m.pvppower))

            local ratings = '|cFFF0F0A0' .. tostring(m.mmr) .. '|r'
            local mmr_rank = oq.get_rank_str(m.ranks)
            if (mmr_rank == '') then
                tooltip.left[8]:SetText(OQ.TT_MMR)
            else
                tooltip.left[8]:SetText(OQ.TT_MMR .. ' |cFFFFD331( ' .. mmr_rank .. ' )|r')
            end
            tooltip.right[8]:SetText(ratings)
            tooltip.left[9]:SetText(OQ.TT_MAXHP)
            tooltip.right[9]:SetText(tostring(m.hp or 0) .. ' k')
            tooltip.left[10]:SetText(OQ.TT_WINLOSS)
            tooltip.right[10]:SetText(tostring(m.wins or 0) .. ' - ' .. tostring(m.losses or 0))
            tooltip.left[11]:SetText(OQ.TT_HKS)
            tooltip.right[11]:SetText(tostring(m.hks or 0) .. ' k')
            tooltip.left[12]:SetText(OQ.TT_TEARS)
            tooltip.right[12]:SetText(tostring(m.tears or 0))
        end

        -- show icons for ranks & titles
        tooltip.left[tooltip.nRows - 1]:SetText(OQ.TT_OQVERSION)
        tooltip.right[tooltip.nRows - 1]:SetText(oq.get_version_str(m.oq_ver))
        tooltip.left[tooltip.nRows - 0]:SetText(oq.get_rank_achieves(m.ranks))
        tooltip.right[tooltip.nRows - 0]:SetText('')
    end

    -- adjust dimensions of the box
    for i = 3, tooltip.nRows do
        tooltip.right[i]:SetWidth(tooltip:GetWidth() - 30)
    end

    local t = CLASS_ICON_TCOORDS[OQ.LONG_CLASS[m.class]]
    if t then
        tooltip.portrait.texture:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
        tooltip.portrait.texture:SetTexCoord(unpack(t))
        tooltip.portrait.texture:SetAlpha(1.0)
    end
    if (m.bg) and ((m.bg[1].status == '2') or (m.bg[2].status == '2')) then
        local txt = ''
        txt = txt .. string.format(L['time diff: %4.2f \n'], m.bg[1].dt / 1000)
        if (m.bg[2].dt > 0) then
            txt = txt .. string.format(L['time diff: %4.2f \n'], m.bg[2].dt / 1000)
        end

        tooltip._extra:Show()
        tooltip._extra.header:SetText(L['queue latency'])
        tooltip._extra.note:SetText(txt)
        tooltip._extra:SetPoint('TOP', tooltip, 'BOTTOM', 0, -3)
    elseif (m._pending_text) and (m._pending_text ~= '') then
        tooltip._extra:Show()
        tooltip._extra.header:SetText(L['user comment'])
        tooltip._extra.note:SetText(m._pending_text)
        tooltip._extra:SetPoint('TOP', tooltip, 'BOTTOM', 0, -3)
    else
        tooltip._extra:Hide()
    end

    tooltip.m = m

    tooltip:Show()
end

function oq.tooltip_show()
    local tooltip = oq.tooltip
    if (tooltip ~= nil) then
        tooltip:Show()
    end
end

function oq.tooltip_hide()
    local tooltip = oq.tooltip
    if (tooltip ~= nil) then
        tooltip:Hide()
        tooltip._extra:Hide()
        tooltip.m = nil
    end
end

--------------------------------------------------------------------------
-- long tooltip
--------------------------------------------------------------------------

function oq.long_tooltip_create()
    if (oq.long_tooltip ~= nil) then
        return oq.long_tooltip
    end
    local tooltip = oq.CreateFrame('FRAME', 'OQLongTooltip', UIParent, nil)
    if (oq.__backdrop21 == nil) then
        oq.__backdrop21 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {
                left = 4,
                right = 3,
                top = 4,
                bottom = 3
            }
        }
    end
    tooltip:SetBackdrop(oq.__backdrop21)
    tooltip:SetBackdropColor(0.0, 0.0, 0.0, 1.0)

    -- class portrait
    local f = oq.CreateFrame('FRAME', 'OQTooltipPortraitFrame', tooltip)
    f:SetWidth(35)
    f:SetHeight(35)
    f:SetBackdropColor(0.0, 0.8, 0.8, 1.0)

    local t = tooltip:CreateTexture(nil, 'OVERLAY')
    t:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
    t:SetAllPoints(f)
    t:SetAlpha(1.0)
    f.texture = t

    f:SetPoint('TOPRIGHT', -6, -1 * 6)
    f:Show()
    tooltip.portrait = f

    local x = 5
    local y = 8
    local cy = 17
    tooltip.nRows = 20
    tooltip:SetHeight((tooltip.nRows + 1) * (cy) + 14)
    tooltip:SetWidth(220) -- 240

    tooltip.left = tbl.new()
    tooltip.right = tbl.new()

    for i = 1, tooltip.nRows do
        if (i == (tooltip.nRows - 1)) or (i == (tooltip.nRows)) then
            tooltip.left[i] = oq.tooltip_label(tooltip, x, y, 'LEFT')
            tooltip.left[i]:SetWidth(tooltip:GetWidth() - 3)
        else
            tooltip.left[i] = oq.tooltip_label(tooltip, x, y, 'LEFT')
        end
        if (i == 2) then
            tooltip.right[i] = oq.tooltip_label(tooltip, x, y, 'RIGHT')
            tooltip.right[i]:SetWidth(tooltip:GetWidth() - (x + 3 * 15))
        else
            tooltip.right[i] = oq.tooltip_label(tooltip, x, y, 'RIGHT')
        end
        if (i == 1) then
            x = x + 10
            y = y + 2
            tooltip.left[i]:SetFont(OQ.FONT, 12, '')
            tooltip.right[i]:SetFont(OQ.FONT, 12, '')
        else
            tooltip.left[i]:SetTextColor(0.6, 0.6, 0.6)
            tooltip.left[i]:SetFont(OQ.FONT, 10, '')

            tooltip.right[i]:SetTextColor(0.9, 0.9, 0.25)
            tooltip.right[i]:SetFont(OQ.FONT, 10, '')
        end
        y = y + cy
        if (i == (tooltip.nRows - 1)) then
            y = y + 15 -- spacer before last row
        end
    end
    oq.long_tooltip = tooltip
    return tooltip
end

function oq.long_tooltip_clear()
    local tooltip = oq.long_tooltip
    if (tooltip ~= nil) then
        for i = 1, tooltip.nRows do
            tooltip.left[i]:SetText('')
            tooltip.right[i]:SetText('')
        end
    end
end

function oq.long_tooltip_show()
    local tooltip = oq.long_tooltip
    if (tooltip ~= nil) then
        tooltip:Show()
    end
end

function oq.long_tooltip_hide()
    local tooltip = oq.long_tooltip
    if (tooltip ~= nil) then
        tooltip:Hide()
    end
end

--------------------------------------------------------------------------
-- text helper tooltip
--------------------------------------------------------------------------
function oq.gen_tooltip_label(tt, x, y, align)
    local t = tt:CreateFontString()
    t:SetFontObject(GameFontNormal)
    t:SetWidth(tt:GetWidth() - (x + 2 * 15))
    t:SetHeight(3 * 25)
    t:SetJustifyV('TOP')
    t:SetJustifyH(align or 'LEFT')
    t:SetText('')
    t:Show()
    t:SetPoint('TOPLEFT', tt, 'TOPLEFT', x, -1 * y)
    return t
end

function oq.gen_tooltip_create()
    if (oq.gen_tooltip ~= nil) then
        return oq.gen_tooltip
    end
    local tooltip
    tooltip = oq.CreateFrame('FRAME', 'OQGenTooltip', UIParent, nil)
    if (oq.__backdrop22 == nil) then
        oq.__backdrop22 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {
                left = 4,
                right = 3,
                top = 4,
                bottom = 3
            }
        }
    end
    tooltip:SetBackdrop(oq.__backdrop22)
    --  local p = OQMainFrame ;
    --  tooltip:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 10, 0 ) ;

    tooltip:SetFrameStrata('TOOLTIP')
    tooltip:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
    oq.setpos(tooltip, 100, 100, 100, 100)
    tooltip:Hide()

    tooltip.left = tbl.new()
    tooltip.right = tbl.new()
    tooltip.left[1] = oq.gen_tooltip_label(tooltip, 8, 8)
    oq.gen_tooltip = tooltip
    return tooltip
end

function oq.gen_tooltip_clear()
    oq.gen_tooltip.left[1]:SetText('')
    oq.gen_tooltip.right[1]:SetText('')
end

function oq.gen_tooltip_set(f, txt)
    local tooltip = oq.gen_tooltip_create()
    tooltip:SetFrameLevel(99)
    oq.tooltip_clear()
    tooltip.left[1]:SetText(txt)

    -- adjust dimensions of the box
    local w = floor(tooltip.left[1]:GetStringWidth()) + 2 * 10
    local h = 3 * 12 + 2 * 10
    tooltip.left[1]:SetWidth(w)
    local x = f:GetLeft() + f:GetWidth() + 20
    local y = (GetScreenHeight() - f:GetTop()) + f:GetHeight() + 20
    tooltip:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', 0, 0)
    oq.setpos(tooltip, x, y, w, h)

    tooltip:Show()
end

function oq.gen_tooltip_show()
    if (oq.gen_tooltip ~= nil) then
        oq.gen_tooltip:Show()
    end
end

function oq.gen_tooltip_hide()
    if (oq.gen_tooltip ~= nil) then
        oq.gen_tooltip:Hide()
    end
end

--------------------------------------------------------------------------
-- premade tooltip functions
--------------------------------------------------------------------------
local pm_tooltip = nil

function oq.pm_tooltip_create()
    if (pm_tooltip ~= nil) then
        return pm_tooltip
    end
    pm_tooltip = oq.CreateFrame('FRAME', 'OQPMTooltip', UIParent, nil)
    if (oq.__backdrop23 == nil) then
        oq.__backdrop23 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {
                left = 4,
                right = 3,
                top = 4,
                bottom = 3
            }
        }
    end
    pm_tooltip:SetBackdrop(oq.__backdrop23)

    local t = pm_tooltip:CreateTexture(nil, 'OVERLAY')
    --  t:SetTexture( "Interface\\TargetingFrame\\UI-Classes-Circles" ) ;
    t:SetAlpha(1.0)
    t:SetWidth(24)
    t:SetHeight(24)
    t:SetPoint('TOPLEFT', pm_tooltip, 'TOPRIGHT', -30, -5)
    t:SetPoint('BOTTOMRIGHT', pm_tooltip, 'TOPRIGHT', -6, -29)
    pm_tooltip.class = t
    pm_tooltip.class:SetTexture(nil)

    pm_tooltip.nRows = 16
    pm_tooltip:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    pm_tooltip:SetWidth(210) -- 220
    pm_tooltip:SetHeight(12 + pm_tooltip.nRows * 16)
    pm_tooltip:SetMovable(true)
    pm_tooltip:SetAlpha(1.0)
    pm_tooltip:SetFrameStrata('TOOLTIP')
    pm_tooltip.left = tbl.new()
    pm_tooltip.right = tbl.new()

    local x = 8
    local y = 12
    for i = 1, pm_tooltip.nRows + 5 do
        pm_tooltip.left[i] = oq.tooltip_label(pm_tooltip, x, y, 'LEFT')
        pm_tooltip.right[i] = oq.tooltip_label(pm_tooltip, x, y, 'RIGHT', pm_tooltip:GetWidth() - 27)
        if (i == 1) then
            x = x + 10
            y = y + 2
            pm_tooltip.left[i]:SetFont(OQ.FONT, 12, '')
            pm_tooltip.right[i]:SetFont(OQ.FONT, 12, '')
            pm_tooltip.right[i]:SetWidth(pm_tooltip:GetWidth() - 15)
        else
            pm_tooltip.left[i]:SetTextColor(0.6, 0.6, 0.6)
            pm_tooltip.left[i]:SetFont(OQ.FONT, 10, '')
            pm_tooltip.right[i]:SetTextColor(0.9, 0.9, 0.25)
        end
        pm_tooltip.left[i]:SetJustifyH('LEFT')
        pm_tooltip.right[i]:SetJustifyH('RIGHT')
        y = y + 15
    end

    local ext = oq.CreateFrame('FRAME', 'OQPMTooltipExtra', UIParent, nil)
    ext:SetBackdrop(oq.__backdrop23)
    ext:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    local cx = pm_tooltip:GetWidth()
    local cy = pm_tooltip:GetHeight()
    ext:SetWidth(cx)
    ext:SetHeight(3 * 25)
    ext.header = oq.label(ext, 10, 10, cx - 2 * 10, 25, L['Not qualified:'], 'TOP', 'LEFT')
    ext.header:SetFont(OQ.FONT, 12, '')
    ext.note = oq.label(ext, 10, 35, cx - 2 * 10, cy - 35 - 10, '', 'TOP', 'LEFT')
    ext.note:SetTextColor(0.9, 0.9, 0.9)
    ext:Hide()
    pm_tooltip._extra = ext

    return pm_tooltip
end

function oq.pm_tooltip_disqualified(raid, pm_tooltip)
    local ext = pm_tooltip._extra
    if (ext == nil) then
        return
    end
    oq.qualified(raid.raid_token)
    if (oq.__reason == nil) then
        ext:Hide()
        return
    end

    ext.note:SetText(oq.__reason .. ((oq.__reason_extra) and (L[' - '] .. L[oq.__reason_extra]) or ''))
    ext:Show()
    ext:SetPoint('TOP', pm_tooltip, 'BOTTOM', 0, -3)
end

function oq.pm_tooltip_clear()
    pm_tooltip.class:SetTexture(nil)
    for i = 1, pm_tooltip.nRows + 5 do
        pm_tooltip.left[i]:SetText('')
        pm_tooltip.right[i]:SetText('')
    end
end

function oq.pm_tooltip_get_xpbar(easy, hard, flexi, nbosses, b1, b2) -- b1, b2 == breaks
    local flex = '|TInterface\\Addons\\oqueue\\art\\yellow_block_64.tga:10:10:0:0|t'
    local hero = '|TInterface\\Addons\\oqueue\\art\\red_block_64.tga:10:10:0:0|t'
    local norm = '|TInterface\\Addons\\oqueue\\art\\green_block_64.tga:10:10:0:0|t'
    local none = '|TInterface\\Addons\\oqueue\\art\\grey_block_64.tga:10:10:0:0|t'
    local str = ''

    easy = oq.decode_mime64_digits(easy)
    hard = oq.decode_mime64_digits(hard)
    flexi = oq.decode_mime64_digits(flexi)
    for i = 1, nbosses do
        if (oq.is_set(hard, bit.lshift(1, i - 1))) then
            str = str .. hero
        elseif (oq.is_set(easy, bit.lshift(1, i - 1))) then
            str = str .. norm
        elseif (oq.is_set(flexi, bit.lshift(1, i - 1))) then
            str = str .. flex
        else
            str = str .. none
        end
        if ((b1) and (b1 == i)) or ((b2) and (b2 == i)) then
            str = str .. ' '
        end
    end
    return str
end

function oq.pm_tooltip_get_rank(rank)
    rank = oq.decode_mime64_digits(rank)
    return '|cFFD23C3C' .. OQ.rbg_rank[rank].rank .. '|r'
end

function oq.pm_tooltip_if_set(x, bitmask, str)
    x = oq.decode_mime64_digits(x)
    if (x ~= nil) and (x ~= 0) and (oq.is_set(x, bitmask)) then
        return '|cFFD23C3C' .. str .. '|r'
    else
        return '|cFF606060' .. str .. '|r'
    end
end

function oq.pm_tooltip_set(f, raid_token)
    oq.pm_tooltip_create()
    local p = f:GetParent():GetParent():GetParent()
    pm_tooltip:SetPoint('TOPLEFT', p, 'TOPRIGHT', 10, 0)
    pm_tooltip:Raise()
    oq.pm_tooltip_clear()

    local raid = oq.premades[raid_token]
    if (raid == nil) then
        return
    end
    if (raid.leader_xp == nil) then
        raid.leader_xp = ''
    end
    local nMembers = raid.nMembers
    local nWaiting = raid.nWaiting
    if ((raid_token == oq.raid.raid_token) and oq.iam_raid_leader()) then
        nMembers, _, _, nWaiting = oq.calc_raid_stats()
    end

    local nWins = 0
    local nLosses = 0

    pm_tooltip.left[1]:SetText(raid.name)
    pm_tooltip.right[1]:SetText('')

    pm_tooltip.left[2]:SetText(OQ.TT_LEADER)

    pm_tooltip.right[2]:SetText(raid.leader)

    pm_tooltip.left[3]:SetText(OQ.TT_REALM)
    pm_tooltip.right[3]:SetText(raid.leader_realm)

    pm_tooltip.left[5]:SetText(OQ.TT_MEMBERS .. '|cFF808080 / |r|cFF49CF69' .. OQ.TT_WAITLIST .. '|r')
    pm_tooltip.right[5]:SetText(string.format('%d |cFF808080/ |r|cFF49CF69%d |r', nMembers, nWaiting))
    pm_tooltip.left[6]:SetText(OQ.TT_ILEVEL)
    pm_tooltip.right[6]:SetText(string.format('%d', raid.min_ilevel))

    pm_tooltip.right[pm_tooltip.nRows]:SetFont(OQ.FONT, 12, '')
    pm_tooltip.right[pm_tooltip.nRows + 2]:SetFont(OQ.FONT, 12, '')

    if (raid.type == OQ.TYPE_RAID) or (raid.type == OQ.TYPE_DUNGEON) then
        pm_tooltip:SetHeight(12 + (pm_tooltip.nRows + 2) * 16)
        pm_tooltip.left[pm_tooltip.nRows + 2]:SetText(OQ.TT_OQVERSION)
        pm_tooltip.right[pm_tooltip.nRows + 2]:SetText((raid.oq_ver == 0) and ('--') or oq.get_version_str(raid.oq_ver))
        pm_tooltip.right[pm_tooltip.nRows + 2]:SetFont(OQ.FONT, 9, '')
    else
        pm_tooltip:SetHeight(12 + pm_tooltip.nRows * 16)
        pm_tooltip.left[pm_tooltip.nRows]:SetText(OQ.TT_OQVERSION)
        pm_tooltip.right[pm_tooltip.nRows]:SetText((raid.oq_ver == 0) and ('--') or oq.get_version_str(raid.oq_ver))
        pm_tooltip.right[pm_tooltip.nRows]:SetFont(OQ.FONT, 9, '')
    end

    --
    -- leader experience
    --
    if (raid.type == OQ.TYPE_BG) or (raid.type == OQ.TYPE_RBG) then
        pm_tooltip.right[1]:SetText(oq.get_rank_icons(raid.leader_xp:sub(10, -1)))

        pm_tooltip.left[8]:SetText(L['highest rank'])
        pm_tooltip.right[8]:SetText('|cFFFFD331' .. oq.get_rank_str(raid.leader_xp:sub(10, -1)) .. '|r')

        pm_tooltip.left[10]:SetText(OQ.TT_RECORD)
        nWins, nLosses = oq.get_winloss_record(raid.leader_xp)
        pm_tooltip.right[10]:SetText(nWins .. ' - ' .. nLosses)
        pm_tooltip.left[pm_tooltip.nRows - 2]:SetWidth(pm_tooltip:GetWidth() + 20)
        pm_tooltip.left[pm_tooltip.nRows - 2]:SetText(oq.get_rank_achieves(raid.leader_xp:sub(10, -1)))
    elseif (raid.type == OQ.TYPE_SCENARIO) then
        local nWins = oq.decode_mime64_digits(raid.leader_xp:sub(1, 3))
        local nLosses = oq.decode_mime64_digits(raid.leader_xp:sub(4, 5))

        pm_tooltip.left[7]:SetText(OQ.TT_PVERECORD)
        pm_tooltip.right[7]:SetText(nWins .. ' - ' .. nLosses)

    elseif (raid.type == OQ.TYPE_CHALLENGE) then
        nWins, nLosses = oq.get_challenge_winloss_record(raid.leader_xp)

        pm_tooltip.left[7]:SetText(OQ.TT_PVERECORD)
        pm_tooltip.right[7]:SetText(nWins .. ' - ' .. nLosses)

        local medals = raid.leader_xp
        pm_tooltip.left[11]:SetText('medals')
        local str = ''
        local n = oq.decode_mime64_digits(medals:sub(1, 2))
        if (n > 0) then
            str = tostring(n) .. 'x '
        end
        pm_tooltip.right[13]:SetText(str .. OQ.LIL_BRONZE_MEDAL)

        n = oq.decode_mime64_digits(medals:sub(3, 4))
        if (n > 0) then
            str = tostring(n) .. 'x '
        end
        pm_tooltip.right[12]:SetText(str .. OQ.LIL_SILVER_MEDAL)

        n = oq.decode_mime64_digits(medals:sub(5, 6))
        if (n > 0) then
            str = tostring(n) .. 'x '
        end
        pm_tooltip.right[11]:SetText(str .. OQ.LIL_GOLD_MEDAL)
    elseif
        (raid.type == OQ.TYPE_RAID) or (raid.type == OQ.TYPE_DUNGEON) or (raid.type == OQ.TYPE_QUESTS) or
            (raid.type == OQ.TYPE_ROLEPLAY)
     then
        if (raid.min_mmr > 0) then
            pm_tooltip.left[6]:SetText(string.format('%s |cFF808080/ |r|cFF49CF69%s |r', OQ.TT_ILEVEL, OQ.TT_LOWEST))
            pm_tooltip.right[6]:SetText(
                string.format('%d |cFF808080/ |r|cFF49CF69%d |r', raid.min_ilevel, raid.min_mmr)
            )
        end

        nWins, nLosses = oq.get_pve_winloss_record(raid.leader_xp)

        pm_tooltip.left[7]:SetText(OQ.TT_PVERECORD)
        pm_tooltip.right[7]:SetText(nWins .. ' - ' .. nLosses)

        local dots = ''
        local raids = raid.leader_xp
        pm_tooltip.left[pm_tooltip.nRows - 6]:SetText('|cFFFFD331' .. OQ.LABEL_RAIDS .. '|r')
        pm_tooltip.right[pm_tooltip.nRows - 6]:SetText('')

        pm_tooltip.left[pm_tooltip.nRows - 5]:SetText(OQ.RAID_TOES)
        pm_tooltip.right[pm_tooltip.nRows - 5]:SetText(
            oq.pm_tooltip_get_xpbar(raids:sub(1, 1), raids:sub(2, 2), nil, 4)
        )
        pm_tooltip.left[pm_tooltip.nRows - 4]:SetText(OQ.RAID_HOF)
        pm_tooltip.right[pm_tooltip.nRows - 4]:SetText(
            oq.pm_tooltip_get_xpbar(raids:sub(3, 3), raids:sub(4, 4), nil, 6, 3, nil)
        ) -- last 2 params: break insert
        pm_tooltip.left[pm_tooltip.nRows - 3]:SetText(OQ.RAID_MV)
        pm_tooltip.right[pm_tooltip.nRows - 3]:SetText(
            oq.pm_tooltip_get_xpbar(raids:sub(5, 5), raids:sub(6, 6), nil, 6, 3, nil)
        ) -- last 2 params: break insert

        pm_tooltip.left[pm_tooltip.nRows - 2]:SetText(OQ.RAID_TOT)
        dots = oq.pm_tooltip_get_xpbar(raids:sub(7, 7), raids:sub(9, 9), nil, 6, 3, 6)
        dots = dots .. '' .. oq.pm_tooltip_get_xpbar(raids:sub(8, 8), raids:sub(10, 10), nil, 6, 3, nil)
        pm_tooltip.right[pm_tooltip.nRows - 2]:SetText(dots)
        pm_tooltip.left[pm_tooltip.nRows - 1]:SetText(OQ.RAID_RA_DEN)
        dots = ' ' .. oq.pm_tooltip_get_xpbar(nil, raids:sub(11, 11), nil, 1) .. ' '
        pm_tooltip.right[pm_tooltip.nRows - 1]:SetText(dots)
        pm_tooltip.left[pm_tooltip.nRows - 0]:SetText(OQ.RAID_SOO)

        -- record: bbbwwLLLmmm   12,22
        dots = oq.pm_tooltip_get_xpbar(raids:sub(23, 23), raids:sub(26, 26), raids:sub(29, 29), 6, 4, nil) -- last 2 params: break insert
        dots = dots .. '' .. oq.pm_tooltip_get_xpbar(raids:sub(24, 24), raids:sub(27, 27), raids:sub(30, 30), 6, 2, 5) -- last 2 params: break insert
        dots = dots .. '' .. oq.pm_tooltip_get_xpbar(raids:sub(25, 25), raids:sub(28, 28), raids:sub(31, 31), 2)
        pm_tooltip.right[pm_tooltip.nRows - 0]:SetText(dots)
    elseif (raid.type == OQ.TYPE_ARENA) then
        -- rmmm5wwwlll3wwwlll2wwwlllC
        local spec = oq.get_class_spec(oq.decode_mime64_digits(raid.leader_xp:sub(26, 26)))
        pm_tooltip.left[pm_tooltip.nRows - 8]:SetText(L['specialization'])
        if (spec) then
            pm_tooltip.right[pm_tooltip.nRows - 8]:SetText(spec.n:sub(4, -1))

            local t = CLASS_ICON_TCOORDS[OQ.LONG_CLASS[spec.n:sub(1, 2)]]
            if t then
                pm_tooltip.class:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
                pm_tooltip.class:SetTexCoord(unpack(t))
                pm_tooltip.class:SetAlpha(1.0)
            end
        end

        pm_tooltip.left[pm_tooltip.nRows - 7]:SetText(L['best mmr'])
        pm_tooltip.right[pm_tooltip.nRows - 7]:SetText(oq.decode_mime64_digits(raid.leader_xp:sub(2, 4)))

        pm_tooltip.left[pm_tooltip.nRows - 5]:SetText(
            '2v2  ' .. OQ.ARENA_MMR_RANK_ACHIEVE[oq.decode_mime64_digits(raid.leader_xp:sub(19, 19))] or ''
        )
        pm_tooltip.right[pm_tooltip.nRows - 5]:SetText(
            oq.decode_mime64_digits(raid.leader_xp:sub(20, 22)) ..
                ' - ' .. oq.decode_mime64_digits(raid.leader_xp:sub(23, 25))
        )
        pm_tooltip.left[pm_tooltip.nRows - 4]:SetText(
            '3v3  ' .. OQ.ARENA_MMR_RANK_ACHIEVE[oq.decode_mime64_digits(raid.leader_xp:sub(12, 12))] or ''
        )
        pm_tooltip.right[pm_tooltip.nRows - 4]:SetText(
            oq.decode_mime64_digits(raid.leader_xp:sub(13, 15)) ..
                ' - ' .. oq.decode_mime64_digits(raid.leader_xp:sub(16, 18))
        )
        pm_tooltip.left[pm_tooltip.nRows - 3]:SetText(
            '5v5  ' .. OQ.ARENA_MMR_RANK_ACHIEVE[oq.decode_mime64_digits(raid.leader_xp:sub(5, 5))] or ''
        )
        pm_tooltip.right[pm_tooltip.nRows - 3]:SetText(
            oq.decode_mime64_digits(raid.leader_xp:sub(6, 8)) ..
                ' - ' .. oq.decode_mime64_digits(raid.leader_xp:sub(9, 11))
        )

        pm_tooltip.right[pm_tooltip.nRows - 1]:SetText(
            OQ.ARENA_RANKS[oq.decode_mime64_digits(raid.leader_xp:sub(1, 1))] or ''
        )
    end

    oq.pm_tooltip_disqualified(raid, pm_tooltip)
    pm_tooltip:Show()
end

function oq.pm_tooltip_show()
    if (pm_tooltip ~= nil) then
        pm_tooltip:Show()
    end
end

function oq.pm_tooltip_hide()
    if (pm_tooltip ~= nil) then
        pm_tooltip:Hide()
        pm_tooltip._extra:Hide()
    end
end

function oq.create_tooltips()
    oq.pm_tooltip_create()
    oq.tooltip_create()
    oq.long_tooltip_create()
    oq.gen_tooltip_create()
end
