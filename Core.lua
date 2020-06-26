local addonName, OQ = ...
local L = OQ._T -- for literal string translations
if (OQ.table == nil) then
    OQ.table = {}
end
local tbl = OQ.table
-------------------------------------------------------------------------------
local OQ_MAJOR = 2
local OQ_MINOR = 0
local OQ_REVISION = 3
local OQ_SPECIAL_TAG = ""
local OQ_BUILD_STR = tostring(OQ_MAJOR) .. tostring(OQ_MINOR) .. tostring(OQ_REVISION)
local OQ_BUILD = tonumber(OQ_BUILD_STR)
local OQUEUE_VERSION = tostring(OQ_MAJOR) .. '.' .. tostring(OQ_MINOR) .. '.' .. OQ_REVISION
local OQ_NOTIFICATION_CYCLE = 2 * 60 * 60 -- every 2 hrs
local OQ_NOEMAIL = '.'
local OQ_HEADER = 'OQ'
local OQ_MSGHEADER = OQ_HEADER .. ','
local OQ_FLD_TO = '#to:'
local OQ_FLD_FROM = '#fr:'
local OQ_FLD_REALM = '#rlm:'
local OQ_REALM_CHANNEL = 'x.oqueue'
local OQ_TTL = 4
local OQ_PREMADE_STAT_LIFETIME = 5 * 60 -- 5 minutes
local OQ_GROUP_RECOVERY_TM = 5 * 60 -- 5 minutes
local OQ_SEC_BETWEEN_ADS = 20
local OQ_SEC_BETWEEN_PROMO = 20
-- local OQ_MIN_PROMO_TIME = (OQ_SEC_BETWEEN_ADS - 5) ; -- allow for mesh latency
local OQ_BOOKKEEPING_INTERVAL = 10
local OQ_MAX_ATOKEN_LIFESPAN = 120 -- 120 seconds before token removed from ATOKEN list
local OQ_MIN_ATOKEN_RELAY_TM = 30 -- do not relay atokens more then once every 30 seconds
local OQ_MAX_HONOR_WARNING = 3600
local OQ_MAX_HONOR = 4000
local OQ_MAX_WAITLIST = 30
local OQ_INVITEALL_CD = 5 -- seconds
local OQ_PENDINGNOTE_UPDATE_CD = 5
local OQ_CREATEPREMADE_CD = 5 -- seconds
local MAX_OQGENERAL_TALKERS = 9999
local my_group = 0
local my_slot = 0
local next_invite_tm = 0
local last_ident_tm = 0
local skip_stats = 0
local last_stats = ''
local player_name = nil
local player_class = nil
local player_realm = nil
local player_realm_id = 0
local player_level = 1
local player_ilevel = 1
local player_resil = 1
local player_role = 3
local player_deserter = nil
local player_queued = nil
local player_online = 1
local player_karma = 0
local _source = nil -- bnet, addon, bnfinvite, oqgeneral, party
local _msg_token = nil
local _inc_channel = nil
local _received = nil
local _reason = nil
local _ok2relay = 1
local _inside_bg = nil
local _winner = nil
local _msg = nil
local _msg_type = nil
local _msg_id = nil
local _core_msg = nil
local _to_name = nil
local _to_realm = nil
local _from = nil
local _lucky_charms = nil
local _map_open = nil
local _ui_open = nil
local _oqgeneral_id = nil
local _oqgeneral_count = 0
local _oqgeneral_lockdown = true -- restricted until unlocked once the # of members of oqgeneral are determined
local _flags = nil
local _enemy = nil
local _next_flag_check = 0
local _announcePremades = nil -- used for delayed announcements when loading
local _hop = 0
local player_away = nil
local _toon = nil
local _arg = nil
local _vars = nil
local _names = nil
local _items = nil
local oq_ascii = nil
local oq_mime64 = nil
OQ.TOP_LEVEL = 90
OQ.MAX_LOG_LINES = 43
OQ.MAX_SNITCH_LINES = 250
OQ.BUNDLE_EARLIEST_SEND = 3.0 -- seconds
OQ.BUNDLE_EXPIRATION = 4.0 -- seconds
OQ.MAX_BNET_MSG_SZ = 4078 -- max size as per blizz limitation
OQ.DEFAULT_WIDTH = 835
OQ.MIN_FRAME_HEIGHT = 475
OQ.BNET_CAPB4THECAP = 98 -- blizz increased the cap from 100 to 112 (also fixed the crash.  capb4cap needed?).
OQ.MODEL_CHECK_TM = 3 -- check every 3 seconds
OQ.RELAY_OVERLOAD = 28 -- if sent msgs/sec exceeds 28, p8 msgs will stop sending
OQ.MAX_MSGS_PER_CYCLE = 6 -- cycles 4 times per second sending msgs
OQ.MAX_PENDING_NOTE = 70

local _  -- throw away (was getting taint warning; what happened blizz?)

local oq = {
    my_tok = nil,
    ui = nil,
    channels = nil,
    premades = nil,
    raid = nil,
    waitlist = nil,
    pending = nil
}

local dtp = oq
function OQ:mod()
    return oq
end

-------------------------------------------------------------------------------
--   local defines
-------------------------------------------------------------------------------

function oq.get_version_str(version)
    if (version == nil) then
        return 'Unknown'
    end

    version = tostring(version)
    if (version == '') then
        return 'Unknown'
    end

    local major, minor, rev = version:match('(%d)(%d)(%d)')
    if (major == nil or minor == nil or rev == nil) then
        return 'Unknown'
    end

    return major .. "." .. minor .. "." ..rev
end

-------------------------------------------------------------------------------
--   slash commands
-------------------------------------------------------------------------------

SLASH_OQUEUE1 = '/oqueue'
SLASH_OQUEUE2 = '/oq'
SlashCmdList['OQUEUE'] = function(msg)
    if (msg == nil) or (msg == '') then
        oq.ui_toggle()
        return
    end
    local arg1 = msg
    local opts = nil
    if (msg ~= nil) and (msg:find(' ') ~= nil) then
        arg1 = msg:sub(1, msg:find(' ') - 1)
        opts = msg:sub(msg:find(' ') + 1, -1)
    end
    if (oq.options[arg1] ~= nil) then
        oq.options[arg1](opts)
    end
end

SLASH_OQLOG1 = '/oqlog'
SLASH_OQLOG2 = '/log'
SlashCmdList['OQLOG'] = function()
    oq.toggle_log()
end

--------------------------------------------------------------------------
function oq.hook_options()
    oq.options = tbl.new()
    oq.options['?'] = oq.usage
    oq.options['ban'] = oq.ban_user
    oq.options['brb'] = oq.brb
    oq.options['clear'] = oq.cmdline_clear
    oq.options['cp'] = oq.toggle_class_portraits
    oq.options['debug'] = oq.debug_toggle
    oq.options['delist'] = oq.clear_pending
    oq.options['disband'] = oq.raid_disband
    oq.options['dg'] = oq.quit_raid_now -- drop group
    oq.options['dp'] = oq.quit_raid_now -- drop party
    oq.options['ejectall'] = oq.ejectall
    oq.options['find'] = oq.cmdline_find_member
    oq.options['fixui'] = oq.reposition_ui
    oq.options['harddrop'] = oq.harddrop
    oq.options['help'] = oq.usage
    oq.options['inviteall'] = oq.waitlist_invite_all
    oq.options['log'] = oq.log_cmdline
    oq.options['mbsync'] = oq.mbsync
    oq.options['mycrew'] = oq.mycrew
    oq.options['mini'] = oq.toggle_mini
    oq.options['off'] = oq.oq_off
    oq.options['on'] = oq.oq_on
    oq.options['pending'] = oq.bn_show_pending
    oq.options['ping'] = oq.ping_toon
    oq.options['raw'] = oq.show_raw_numbers
    oq.options['reset'] = oq.data_reset
    oq.options['show'] = oq.show_data
    oq.options['set'] = oq.set_params
    oq.options['snitch'] = oq.snitch_toggle_ui
    oq.options['spy'] = oq.battleground_spy
    oq.options['stats'] = oq.dump_statistics
    oq.options['toggle'] = oq.toggle_option
    oq.options['tz'] = oq.timezone_adjust
    oq.options['wallet'] = oq.show_wallet
end

function oq.on_update_instance_info()
    local n = GetNumSavedInstances()
    for index = 1, n do
        local iName,
            iID,
            iReset,
            iDiff,
            locked,
            extended,
            iIDMostSig,
            isRaid,
            maxPlayers,
            diffName,
            maxBosses,
            defeatedBosses = GetSavedInstanceInfo(index)
        print(
            tostring(index) ..
                '. [' ..
                    tostring(iName) ..
                        '].' ..
                            tostring(iID) ..
                                ' iReset(' ..
                                    tostring(iReset) ..
                                        ') iDiff(' .. tostring(iDiff) .. ').(' .. tostring(diffName) .. ')'
        )
        print(
            tostring(index) ..
                '. locked(' ..
                    tostring(locked) .. ') ext(' .. tostring(extended) .. ') iIDMostSig(' .. tostring(iIDMostSig) .. ')'
        )
        print(
            tostring(index) ..
                '. isRaid(' ..
                    tostring(isRaid) ..
                        ')  maxPlayers(' ..
                            tostring(maxPlayers) ..
                                ') bosses: ' .. tostring(defeatedBosses) .. ' / ' .. tostring(maxBosses)
        )
        print('-')
    end
end

function oq.toggle_mini()
    if (OQ_MinimapButton:IsVisible()) then
        OQ_MinimapButton:Hide()
        oq.toon.mini_hide = true
        print(OQ.MINIMAP_HIDDEN)
    else
        OQ_MinimapButton:Show()
        oq.toon.mini_hide = nil
        print(OQ.MINIMAP_SHOWN)
    end
end

local function comma_value(n) -- credit http://richard.warburton.it
    local left, num, right = string.match(n or 0, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

function oq.csv(t)
    if (t == nil) then
        return t
    end
    local m
    for _, v in pairs(t) do
        if (m) then
            m = m .. ',' .. v
        else
            m = v
        end
    end
    return m
end

-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function oq.trim(s)
    -- from PiL2 20.4
    return (s:gsub('^%s*(.-)%s*$', '%1'))
end

-- remove leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function oq.ltrim(s)
    return (s:gsub('^%s*', ''))
end

-- remove trailing whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function oq.rtrim(s)
    local n = #s
    while n > 0 and s:find('^%s', n) do
        n = n - 1
    end
    return s:sub(1, n)
end

function oq.onLootAcceptanceHide(f)
    oq.tremove_value(getglobal('UISpecialFrames'), f:GetName())
    tinsert(getglobal('UISpecialFrames'), oq.ui:GetName())
    PlaySound('igQuestLogClose')
end

function oq.onLootAcceptanceShow(f)
    tinsert(getglobal('UISpecialFrames'), f:GetName())
    oq.tremove_value(getglobal('UISpecialFrames'), oq.ui:GetName())
    PlaySound('igQuestLogOpen')
end

function oq.create_loot_rule_contract()
    local cx = 440
    local cy = 220
    local x = 30
    local y = 25
    local f = oq.panel(UIParent, 'LootContract', 100, 100, cx, cy)

    f:SetScript(
        'OnShow',
        function(self)
            oq.onLootAcceptanceShow(self)
        end
    )
    f:SetScript(
        'OnHide',
        function(self)
            oq.onLootAcceptanceHide(self)
        end
    )

    f.closepb =
        oq.closebox(
        f,
        function(self)
            self:GetParent():Hide()
        end
    )
    f.closepb:SetPoint('TOPRIGHT', f, 'TOPRIGHT', -15, -8)
    f.closepb:Show()

    local s = f:CreateTexture(nil, 'BORDER')
    s:SetTexture('INTERFACE/LFGFRAME/UI-LFG-SCENARIO-Random.png')
    s:SetTexCoord(0 / 512, 325 / 512, 0 / 512, 326 / 512)
    s:SetAllPoints(f)
    s:SetAlpha(1.0)
    f._backdrop = s

    f:SetAlpha(1.0)

    f.line1 = oq.label(f, x, y, cx - 2 * x, 30, L['Loot method has changed.'], 'CENTER', 'CENTER')
    f.line1:SetFont(OQ.FONT, 16, '')
    y = y + 40

    f.loot_text = oq.label(f, x, y, cx - 2 * x, 30, 'Loot Method', 'CENTER', 'CENTER')
    f.loot_text:SetFont(OQ.FONT, 20, '')
    f.loot_text:SetTextColor(1, 1, 1)
    y = y + 40

    f.line2 = oq.label(f, x, y, cx - 2 * x, 30, L['Do you accept the new loot method?'], 'CENTER', 'CENTER')
    f.line2:SetFont(OQ.FONT, 16, '')
    y = y + 40

    y = y + 20

    local x2 = x
    f.accept_but =
        oq.button(
        f,
        x2,
        y,
        110,
        30,
        L['Accept'],
        function(self)
            self:GetParent():accept()
        end
    )
    x2 = x2 + 110 + 25
    f.donot_but =
        oq.button(
        f,
        x2,
        y,
        110,
        30,
        L['Do not Accept'],
        function(self)
            self:GetParent():donot_accept()
        end
    )
    x2 = x2 + 110 + 25
    f.reject_but =
        oq.button(
        f,
        x2,
        y,
        110,
        30,
        L['Reject and Leave'],
        function(self)
            self:GetParent():reject_and_leave()
        end
    )

    f:Hide()

    f.accept = function(self)
        -- don't send msg for affirmative, only negative
        OQ_data.loot_method = self._method
        self:Hide()
    end

    f.donot_accept = function(self)
        local instance, instanceType = IsInInstance()
        if (instanceType ~= L['None']) then
            oq.SendChatMessage(
                string.format('%s: %s', L['Loot method unacceptable'], L['loot.' .. self._method]),
                instanceType
            )
        end
        OQ_data.loot_method = nil

        self.donot_but:Disable()
        oq.timer_oneshot(4, oq.enable_button, self.donot_but)
    end

    f.reject_and_leave = function(self)
        local instance, instanceType = IsInInstance()
        if (instanceType ~= L['None']) then
            oq.SendChatMessage(
                string.format('%s: %s', L["I'm leaving due to loot method"], L['loot.' .. self._method]),
                instanceType
            )
        end
        OQ_data.loot_method = nil
        self:Hide()
        oq.quit_raid_now()
    end

    f._method = 'unspecified'
    return f
end

function oq.verify_loot_rules_acceptance()
    if (OQ_data.loot_acceptance ~= 1) or (UnitIsGroupLeader('player') == true) then
        return
    end

    -- Do not show if you are solo running some dungeons/raids
    if (not oq.iam_in_a_party()) then
        return
    end

    local instance, instanceType = IsInInstance()
    if (instance == nil) or ((instanceType ~= 'party') and (instanceType ~= 'raid')) then
        return
    end

    local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID =
        GetInstanceInfo()

    -- 1 Normal - party
    -- 2 Heroic - party
    -- 3 10 Player
    -- 4 25 Player
    -- 5 10 Player (Heroic)
    -- 6 25 Player (Heroic)
    -- 9 40 Player	raid
    if (difficultyIndex > 6 and difficultyIndex ~= 9) then
        return
    end

    oq._loot_rule_contract = oq._loot_rule_contract or oq.create_loot_rule_contract()

    local f = oq._loot_rule_contract
    local method = GetLootMethod()

    if (OQ_data.loot_method == method) then
        -- already accepted, leave
        return
    end

    f._method = method
    f.loot_text:SetText(L['loot.' .. method])
    oq.moveto(f, floor((GetScreenWidth() - f:GetWidth()) / 2), 200)
    f:Show()
end

function string.find_end(self, s)
    if (s) then
        return self:find(s) + string.len(s)
    end
end

-- new browser capability
-- might be able to show armory in-game (nice for quick lookups off waitlist)
-- not ready yet; doesn't seem to work and may break key binds
function oq.armory()
    if (oq.browser == nil) then
        oq.browser = oq.CreateFrame('Browser', 'oQueueBrowser', UIParent)
    end
    if (oq.browser:HasConnection() ~= true) then
        print('oQueue browser - no connection')
        return
    end
    print('oQueue browser - navigation')
    oq.browser:Show()
    --  oq.browser:NavigateHome();
    oq.browser:OpenExternalLink('http://us.battle.net')
end

function oq.reposition_ui()
    local x = 100

    x = x + 400
    -- main ui
    local f = OQMainFrame
    if (not f:IsVisible()) then
        oq.ui_toggle()
    end
    f:SetWidth(OQ.DEFAULT_WIDTH)
    f:SetHeight(OQ.MIN_FRAME_HEIGHT)
    f:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', x, -150)

    x = x + OQ.DEFAULT_WIDTH

    -- toggle minimap button so it's on top
    OQ_MinimapButton:Show()
    OQ_MinimapButton:SetFrameStrata('MEDIUM')
    OQ_MinimapButton:SetFrameLevel(50)

    -- log
    if (oq._log) then
        oq._log:Show()
        oq._log:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', x, -325)
        oq._log:_save_position()
    end

    oq.snitch_ui_create()
    if (oq._snitch) and (oq._snitch.ui) then
        oq._snitch.ui:_fixui()
        oq._snitch.ui:Show()
    end
end

function oq.frame_resize()
    local cy = OQ_data._height or OQ.MIN_FRAME_HEIGHT
    local dy = cy - OQMainFrame:GetHeight()
    OQTabPage1:SetHeight(OQTabPage1:GetHeight() + dy)
    OQTabPage1:_resize()
    OQTabPage2:SetHeight(OQTabPage2:GetHeight() + dy)
    OQTabPage2:_resize()
    OQTabPage3:SetHeight(OQTabPage3:GetHeight() + dy)
    OQTabPage3:_resize()
    OQTabPage5:SetHeight(OQTabPage6:GetHeight() + dy)
    OQTabPage5:_resize()
    OQTabPage6:SetHeight(OQTabPage6:GetHeight() + dy)
    OQTabPage6:_resize()
    OQTabPage7:SetHeight(OQTabPage7:GetHeight() + dy)
    OQTabPage7:_resize()

    oq.reshuffle_premades_now()
end

function oq.set_params(opt)
    if (opt == nil) then
        return
    end
    if (opt:find('rowheight')) then
        OQ_data._rowheight = min(30, max(15, tonumber(opt:sub(opt:find(' ') or -1, -1)) or 0))
        oq.reshuffle_premades()
        print(L['row height set: '] .. tostring(OQ_data._rowheight))
    elseif (opt:find('height')) then
        OQ_data._height = min(1000, max(OQ.MIN_FRAME_HEIGHT, tonumber(opt:sub(opt:find(' ') or -1, -1)) or 0))
        oq.ui:SetHeight(OQ_data._height or OQ.MIN_FRAME_HEIGHT)
        oq.frame_resize()
    end
end

function oq.show_count()
    local nLeaders = 0
    local nWaiting = 0
    local nMembers = 0
    for _, v in pairs(oq.premades) do
        nLeaders = nLeaders + 1
        nMembers = nMembers + v.nMembers
        nWaiting = nWaiting + v.nWaiting
    end
    print('nLeaders: ' .. tostring(nLeaders))
    print('nMembers: ' .. tostring(nMembers))
    print('nWaiting: ' .. tostring(nWaiting))
end

function oq.show_data(opt)
    if (opt == nil) or (opt == '?') then
        print('oQueue v' .. OQUEUE_VERSION .. '  build ' .. OQ_BUILD .. ' (' .. tostring(OQ.REGION) .. ')')
        print(' usage:  /oq show <option>')
        print('   count        sum up LFM info')
        print('   frames       frame report (ie: show frames listingregion)')
        print('   income       currency report')
        print('   inuse        frames in use (ie: show inuse listingregion)')
        print('   locals       local premade leaders')
        print('   premades     list premades')
        print('   raid         show current raid members')
        print("   remove       list all the battle-tags that will be removed with 'remove now'")
        print('   report       show battleground reports yet to be filed')
        print('   snitch       list snitch info to chat area')
        print('   stats        list various stats')
        print("   wallet       what's in YOUR wallet?")
    elseif (opt == 'count') then
        oq.show_count()
    elseif (opt == 'cache') then
        oq.show_premade_cache()
    elseif (opt:find('frames') == 1) then
        oq.frame_report(opt)
    elseif (opt == 'globals') then
        oq.dump_globals()
    elseif (opt == 'income') then
        oq.check_currency()
    elseif (opt:find('inuse') == 1) then
        oq.frames_inuse_report(opt)
    elseif (opt == 'locals') then
        oq.show_locals()
    elseif (opt:find('premades') == 1) then
        oq.show_premades(opt)
    elseif (opt == 'raid') or (opt == 'premade') then
        oq.show_raid()
    elseif (opt == 'reform') then
        oq.reform_show_keys()
    elseif (opt == 'report') then
        oq.show_reports()
    elseif (opt == 'snitch') then
        oq.snitch('dump')
    elseif (opt == 'stats') then
        oq.dump_statistics()
    elseif (opt:find('tables') == 1) then
        tbl.fill_match(_arg, opt, ' ') -- args: tables cnt dump substring
        tbl.dump_track(_arg[2], _arg[3], _arg[4])
    elseif (opt:find('systables') == 1) then
        tbl.fill_match(_arg, opt, ' ') -- args: tables cnt dump substring
        oq.dump_tables(_arg[2], _arg[3])
    elseif (opt:find('timers') == 1) then
        oq.timer_dump(opt)
    elseif (opt == 'waitlist') then
        oq.show_waitlist()
    elseif (opt == 'wallet') then
        oq.show_wallet()
    end
end

function oq.dump_tables(sub, dump)
    local n, cnt
    cnt = tonumber(sub)
    for i, v in pairs(oq) do
        if (type(v) == 'table') then
            local s = tostring(v)
            n = tbl.size(v)
            if (sub == nil) or (i:find(sub)) or (s:find(sub)) or (cnt and (cnt < n)) then
                print('oq.' .. tostring(i) .. ':  ' .. tostring(v) .. '  #: ' .. tbl.size(v))
                if (dump) then
                    for j, x in pairs(v) do
                        print('    ' .. tostring(j) .. ' (' .. type(j) .. ')  [' .. tostring(x) .. ']')
                    end
                end
            end
        end
    end

    for i, v in pairs(tbl) do
        if (type(v) == 'table') then
            local s = tostring(v)
            n = tbl.size(v)
            if (sub == nil) or (i:find(sub)) or (s:find(sub)) or (cnt and (cnt < n)) then
                print('tbl.' .. tostring(i) .. ':  ' .. tostring(v) .. '  #: ' .. tbl.size(v))
                if (dump) then
                    for j, x in pairs(v) do
                        print('    ' .. tostring(j) .. ' (' .. type(j) .. ')  [' .. tostring(x) .. ']')
                    end
                end
            end
        end
    end
end

function oq.show_waitlist()
    print('-- waitlist rows')
    for _, v in pairs(oq.tab7.waitlist) do
        local btag = strlower(oq.waitlist[v.token].realid)
        print('  ' .. tostring(v.token) .. '  btag: ' .. tostring(btag))
    end
    print(' ')
    print('-- waitlist table')
    for req_tok, v in pairs(oq.waitlist) do
        print('  ' .. tostring(req_tok) .. '  btag: ' .. tostring(v.realid))
    end
    print('--')
end

function oq.dump_globals()
    print('--  globals')

    for i, v in pairs(OQ) do
        local t = strupper(i)
        if (t ~= i) then
            print('  ' .. tostring(i) .. ':  [' .. tostring(v) .. ']')
        end
    end
    print('-- ')
end

function oq.show_wallet()
    if (oq.toon.player_wallet == nil) then
        return
    end
    print('--[ wallet ]--')

    for i, v in pairs(oq.toon.player_wallet) do
        print('  ' .. tostring(i) .. '  ' .. tostring(v))
    end
    print('--')
end

function oq.show_reports()
end

function oq.toggle_option(opt)
    if (opt == nil) or (opt == '?') then
        print('oQueue v' .. OQUEUE_VERSION .. '  build ' .. OQ_BUILD .. ' (' .. tostring(OQ.REGION) .. ')')
        print(' usage:  /oq toggle <option>')
        print('   ads          toggle the premade advertisements')
        print('   mini         toggle the minimap icon')
    elseif (opt == 'mini') then
        oq.toggle_mini()
    elseif (opt == 'ads') then
        if (OQ_data.show_premade_ads == nil) or (OQ_data.show_premade_ads == 0) then
            OQ_data.show_premade_ads = 1
            print('premade advertisements are now ON')
        else
            OQ_data.show_premade_ads = 0
            print('premade advertisements are now OFF')
        end
    end
end

function oq.timezone_adjust(opt)
    if (opt == nil) then
        OQ_data.sk_adjust = 0
        print(L['OQ: timezone adjustment cleared'])
        return
    end
    if (opt == 'sk') then
        OQ_data.sk_adjust = 0
        OQ_data.sk_next_update = oq.utc_time('pure') + 3 * 24 * 60 * 60
        return
    end
    local n = tonumber(opt or 0) or 0
    if (n == 0) then
        OQ_data.sk_adjust = 0
        print(L['OQ: timezone adjustment cleared'])
        return
    end
    print(string.format(L['OQ: timezone adjustment set to %d minutes'], n))
    OQ_data.sk_adjust = n * 60
end

function oq.harddrop()
    oq.raid_disband()
    oq.raid_cleanup()
    oq.raid_init()

    print(L['OQ: group info reset'])
end

function oq.ban_user(tag)
    if (tag == nil) then
        return
    end
    local dialog = StaticPopup_Show('OQ_BanUser', tag)
    if (dialog ~= nil) then
        dialog.data2 = {flag = 3, btag = tag}
    end
end

function oq.usage()
    print('oQueue v' .. OQUEUE_VERSION .. '  build ' .. OQ_BUILD .. ' (' .. tostring(OQ.REGION) .. ')')
    print(L['usage:  /oq [command]'])
    print(L['command such as:'])
    print(L['  adds            show the list of OQ added b.net friends'])
    print(L['  ban [b-tag]     manually add battle-tag to your ban list'])
    print(L['  bnclear         clear OQ enabled battle-net associations'])
    print(L["  brb             signal to the group that you'll be-right-back"])
    print(L['  check           force OQ capability check'])
    print(L['  cp              toggle class portraits to normal portrait'])
    print(L['  delist          de-waitlist with any premades currently pending'])
    print(L['  dg              drop group.  same as /script LeaveParty()'])
    print(L['  fixui           will reposition the UI to upper left area'])
    print(L['  id              show guid, id, and name of target'])
    print(L['  log [clear]     toggle log on/off or clear'])
    print(L['  mini            toggle the minimap button'])
    print(L['  mycrew [clear]  for boxers, populate the alt list'])
    print(L['  now             print the current utc time (only visible to user)'])
    print(L['  off             turn off OQ messaging'])
    print(L['  on              turn on OQ messaging'])
    print(L['  pnow            print the current utc time to party chat'])
    print(L['  pos             print your current location in the world'])
    print(L['  purge           purge friends list of OQ added b.net friends'])
    print(L['  rc              start role check (OQ premade leader only)'])
    print(L['  refresh         sends out a request to refresh find-premade list'])
    print(L['  show <opt>      show various information'])
    print(L['  stats           various statistics about the player'])
    print(L['  spy [on|off]    display summary of enemy class types'])
    print(L['  toggle <opt>    toggle specific option'])
    print(L['  who             list of OQ enabled battle-net friends'])
end

function oq.toon_init(t)
    t.last_tm = 0
    t.auto_role = 1
    t.class_portrait = 1
    t.reports = tbl.new()
end

function oq.data_reset()
    oq = {
        my_tok = nil,
        ui = tbl.new(),
        channels = tbl.new(),
        premades = tbl.new(),
        raid = tbl.new(),
        waitlist = tbl.new()
    }
    OQ_data = nil
    oq.load_oq_data()
    --    if (OQ_toon) then
    --      OQ_toon = tbl.delete( OQ_toon ) ;
    --    end
    oq.load_toon_info()
    oq.init_stats_data()
    print('oQueue data reset.  for it to take effect, type /reload')
end

function oq.debug_toggle(level)
    if (level) then
        if (level == 'off') then
            oq._debug = nil
            print('debug off')
        elseif (level == 'on') then
            oq._debug = true
            print('debug on')
        elseif (tonumber(level)) then
            oq._debug_level = tonumber(level)
            print('debug level: ' .. tostring(oq._debug_level))
        end
    else
        if (oq._debug) then
            oq._debug = nil
            print('debug off')
        else
            oq._debug = true
            print('debug on')
        end
    end
end

function oq.reset_stats()
    oq.pkt_sent:reset()
    oq.pkt_recv:reset()
    oq.pkt_processed:reset()
    oq.pkt_drift:reset()
    oq.gmt_diff_track:reset()
end

function oq.oq_off()
    oq.toon.disabled = true
    oq.oqgeneral_leave()
    oq.remove_all_premades()
    oq.reset_stats()
    print(OQ.DISABLED)
end

function oq.oq_on()
    oq.toon.disabled = nil
    oq.oqgeneral_join()
    print(OQ.ENABLED)
end

local _consts = {
    0x00000000,
    0x77073096,
    0xEE0E612C,
    0x990951BA,
    0x076DC419,
    0x706AF48F,
    0xE963A535,
    0x9E6495A3,
    0x0EDB8832,
    0x79DCB8A4,
    0xE0D5E91E,
    0x97D2D988,
    0x09B64C2B,
    0x7EB17CBD,
    0xE7B82D07,
    0x90BF1D91,
    0x1DB71064,
    0x6AB020F2,
    0xF3B97148,
    0x84BE41DE,
    0x1ADAD47D,
    0x6DDDE4EB,
    0xF4D4B551,
    0x83D385C7,
    0x136C9856,
    0x646BA8C0,
    0xFD62F97A,
    0x8A65C9EC,
    0x14015C4F,
    0x63066CD9,
    0xFA0F3D63,
    0x8D080DF5,
    0x3B6E20C8,
    0x4C69105E,
    0xD56041E4,
    0xA2677172,
    0x3C03E4D1,
    0x4B04D447,
    0xD20D85FD,
    0xA50AB56B,
    0x35B5A8FA,
    0x42B2986C,
    0xDBBBC9D6,
    0xACBCF940,
    0x32D86CE3,
    0x45DF5C75,
    0xDCD60DCF,
    0xABD13D59,
    0x26D930AC,
    0x51DE003A,
    0xC8D75180,
    0xBFD06116,
    0x21B4F4B5,
    0x56B3C423,
    0xCFBA9599,
    0xB8BDA50F,
    0x2802B89E,
    0x5F058808,
    0xC60CD9B2,
    0xB10BE924,
    0x2F6F7C87,
    0x58684C11,
    0xC1611DAB,
    0xB6662D3D,
    0x76DC4190,
    0x01DB7106,
    0x98D220BC,
    0xEFD5102A,
    0x71B18589,
    0x06B6B51F,
    0x9FBFE4A5,
    0xE8B8D433,
    0x7807C9A2,
    0x0F00F934,
    0x9609A88E,
    0xE10E9818,
    0x7F6A0DBB,
    0x086D3D2D,
    0x91646C97,
    0xE6635C01,
    0x6B6B51F4,
    0x1C6C6162,
    0x856530D8,
    0xF262004E,
    0x6C0695ED,
    0x1B01A57B,
    0x8208F4C1,
    0xF50FC457,
    0x65B0D9C6,
    0x12B7E950,
    0x8BBEB8EA,
    0xFCB9887C,
    0x62DD1DDF,
    0x15DA2D49,
    0x8CD37CF3,
    0xFBD44C65,
    0x4DB26158,
    0x3AB551CE,
    0xA3BC0074,
    0xD4BB30E2,
    0x4ADFA541,
    0x3DD895D7,
    0xA4D1C46D,
    0xD3D6F4FB,
    0x4369E96A,
    0x346ED9FC,
    0xAD678846,
    0xDA60B8D0,
    0x44042D73,
    0x33031DE5,
    0xAA0A4C5F,
    0xDD0D7CC9,
    0x5005713C,
    0x270241AA,
    0xBE0B1010,
    0xC90C2086,
    0x5768B525,
    0x206F85B3,
    0xB966D409,
    0xCE61E49F,
    0x5EDEF90E,
    0x29D9C998,
    0xB0D09822,
    0xC7D7A8B4,
    0x59B33D17,
    0x2EB40D81,
    0xB7BD5C3B,
    0xC0BA6CAD,
    0xEDB88320,
    0x9ABFB3B6,
    0x03B6E20C,
    0x74B1D29A,
    0xEAD54739,
    0x9DD277AF,
    0x04DB2615,
    0x73DC1683,
    0xE3630B12,
    0x94643B84,
    0x0D6D6A3E,
    0x7A6A5AA8,
    0xE40ECF0B,
    0x9309FF9D,
    0x0A00AE27,
    0x7D079EB1,
    0xF00F9344,
    0x8708A3D2,
    0x1E01F268,
    0x6906C2FE,
    0xF762575D,
    0x806567CB,
    0x196C3671,
    0x6E6B06E7,
    0xFED41B76,
    0x89D32BE0,
    0x10DA7A5A,
    0x67DD4ACC,
    0xF9B9DF6F,
    0x8EBEEFF9,
    0x17B7BE43,
    0x60B08ED5,
    0xD6D6A3E8,
    0xA1D1937E,
    0x38D8C2C4,
    0x4FDFF252,
    0xD1BB67F1,
    0xA6BC5767,
    0x3FB506DD,
    0x48B2364B,
    0xD80D2BDA,
    0xAF0A1B4C,
    0x36034AF6,
    0x41047A60,
    0xDF60EFC3,
    0xA867DF55,
    0x316E8EEF,
    0x4669BE79,
    0xCB61B38C,
    0xBC66831A,
    0x256FD2A0,
    0x5268E236,
    0xCC0C7795,
    0xBB0B4703,
    0x220216B9,
    0x5505262F,
    0xC5BA3BBE,
    0xB2BD0B28,
    0x2BB45A92,
    0x5CB36A04,
    0xC2D7FFA7,
    0xB5D0CF31,
    0x2CD99E8B,
    0x5BDEAE1D,
    0x9B64C2B0,
    0xEC63F226,
    0x756AA39C,
    0x026D930A,
    0x9C0906A9,
    0xEB0E363F,
    0x72076785,
    0x05005713,
    0x95BF4A82,
    0xE2B87A14,
    0x7BB12BAE,
    0x0CB61B38,
    0x92D28E9B,
    0xE5D5BE0D,
    0x7CDCEFB7,
    0x0BDBDF21,
    0x86D3D2D4,
    0xF1D4E242,
    0x68DDB3F8,
    0x1FDA836E,
    0x81BE16CD,
    0xF6B9265B,
    0x6FB077E1,
    0x18B74777,
    0x88085AE6,
    0xFF0F6A70,
    0x66063BCA,
    0x11010B5C,
    0x8F659EFF,
    0xF862AE69,
    0x616BFFD3,
    0x166CCF45,
    0xA00AE278,
    0xD70DD2EE,
    0x4E048354,
    0x3903B3C2,
    0xA7672661,
    0xD06016F7,
    0x4969474D,
    0x3E6E77DB,
    0xAED16A4A,
    0xD9D65ADC,
    0x40DF0B66,
    0x37D83BF0,
    0xA9BCAE53,
    0xDEBB9EC5,
    0x47B2CF7F,
    0x30B5FFE9,
    0xBDBDF21C,
    0xCABAC28A,
    0x53B39330,
    0x24B4A3A6,
    0xBAD03605,
    0xCDD70693,
    0x54DE5729,
    0x23D967BF,
    0xB3667A2E,
    0xC4614AB8,
    0x5D681B02,
    0x2A6F2B94,
    0xB40BBE37,
    0xC30C8EA1,
    0x5A05DF1B,
    0x2D02EF8D,
    0xB629F2,
    0xD7CE3A,
    '0x02000000056899EB'
}

function oq.CRC32(s)
    local bit_band, bit_bxor, bit_rshift, str_byte, str_len = bit.band, bit.bxor, bit.rshift, string.byte, string.len
    local crc, l = 0xFFFFFFFF, str_len(s)
    for i = 1, l, 1 do
        crc = bit_bxor(bit_rshift(crc, 8), _consts[bit_band(bit_bxor(crc, str_byte(s, i)), 0xFF) + 1])
    end
    return bit_bxor(crc, -1)
end

function oq.mycrew(arg)
    -- use the current raid/party to poulate the OQ_data.my_toons
    if (arg == 'clear') then
        oq.clear_alt_list()
        return
    end
    if (not UnitInParty('player')) then
        return
    end
    oq.clear_alt_list()
    local n = GetNumGroupMembers()
    if (n > 0) then

        for i = 1, n do
            local name = select(1, GetRaidRosterInfo(i))
            oq.add_toon(name)
        end
    else
        n = GetNumGroupMembers()
        oq.add_toon(player_name)

        for i = 1, n do
            local name = GetUnitName('party' .. i)
            oq.add_toon(name)
        end
    end
end

-- this will return utc time in seconds
--
function oq.utc_time(arg)
    local now = time()
    if (oq.__date1 == nil) then
        oq.__date1 = date('!*t')
        oq.__date2 = date('!*t', now)
    end
    if (arg == nil) then
        --
        -- date("!*t") leaks a table after every call.  to avoid, only call once
        -- this will cause a problem for those ppl with incorrect set timezones.
        -- whereas they will automatically pick up the timezone change now, this
        -- will force them to tell oq to re-calc the tables
        --
        --    return time(date("!*t")) + difftime(now, time(date("!*t", now) ));
        return time(oq.__date1) + difftime(now, time(oq.__date2)) - (OQ_data.sk_adjust or 0)
    elseif (arg == 'pure') then
        return time(oq.__date1) + difftime(now, time(oq.__date2))
    else
        return time(oq.__date1)
    end
end

function oq.reset_portrait(f, player, show_default)
    if (f == nil) or (f.portrait == nil) then
        return
    end
    if (show_default) then
        SetPortraitTexture(f.portrait, player)
        f.portrait:SetTexCoord(0, 1, 0, 1)
    else
        OQ_ClassPortrait(f)
    end
end

function oq.toggle_class_portraits()
    if (oq.toon.class_portrait == 1) then
        oq.toon.class_portrait = 0
    else
        oq.toon.class_portrait = 1
    end
    oq.reset_portrait(PlayerFrame, 'player', (oq.toon.class_portrait == 0))
    oq.reset_portrait(TargetFrame, 'target', (oq.toon.class_portrait == 0))
    oq.reset_portrait(PartyMemberFrame1, 'party1', (oq.toon.class_portrait == 0))
    oq.reset_portrait(PartyMemberFrame2, 'party2', (oq.toon.class_portrait == 0))
    oq.reset_portrait(PartyMemberFrame3, 'party3', (oq.toon.class_portrait == 0))
    oq.reset_portrait(PartyMemberFrame4, 'party4', (oq.toon.class_portrait == 0))
    oq.reset_portrait(PartyMemberFrame5, 'party5', (oq.toon.class_portrait == 0))
end

function oq.render_tm(dt, force_hours)
    -- if (dt == nil) then
    --     return 'xx:xx'
    -- end

    dt = abs(dt or 0) or 0
    if (dt >= 0) then
        local dsec, dmin, dhr, ddays, dyrs, dstr
        ddays = floor(dt / (24 * 60 * 60))
        dt = dt % (24 * 60 * 60)
        dyrs = floor(ddays / 365)
        ddays = ddays % 365
        dhr = floor(dt / (60 * 60))
        dt = dt % (60 * 60)
        dmin = floor(dt / 60)
        dt = dt % 60
        dsec = dt
        dstr = ''
        if (dyrs > 0) then
            dstr = dyrs .. 'y ' .. ddays .. 'd ' .. string.format('%02d:%02d:%02d', dhr, dmin, dsec)
        elseif (ddays > 0) then
            dstr = ddays .. 'd ' .. string.format('%02d:%02d:%02d', dhr, dmin, dsec)
        elseif (dhr > 0) or (force_hours) then
            dstr = string.format('%02d:%02d:%02d', dhr, dmin, dsec)
        elseif (dmin > 0) then
            dstr = string.format('%02d:%02d', dmin, dsec)
        else
            dstr = string.format('00:%02d', dsec)
        end
        return dstr
    else
        return 'xx:xx'
    end
end

-------------------------------------------------------------------------------
-- token functions
-------------------------------------------------------------------------------
function oq.atok_last_seen(token)
    oq._atoken = oq._atoken or tbl.new()

    if (token == nil) or (oq._atoken[token] == nil) then
        return 0
    end
    return oq._atoken[token]
end

function oq.atok_seen(token)
    if (token ~= nil) then
        oq._atoken = oq._atoken or tbl.new()
        oq._atoken[token] = oq.utc_time()
    end
end

-- will register token as seen if ok to process
--
function oq.atok_ok2process(token)
    local last_seen = oq.atok_last_seen(token)
    local now = oq.utc_time()
    if ((now - last_seen) > OQ_MIN_ATOKEN_RELAY_TM) then
        oq.atok_seen(now)
        return true
    end
end

function oq.atok_clear_old()
    oq._atoken = oq._atoken or tbl.new()

    local now = oq.utc_time()
    for i, v in pairs(oq._atoken) do
        if ((now - v) > OQ_MAX_ATOKEN_LIFESPAN) then
            oq._atoken[i] = nil
        end
    end
end

function oq.atok_clear()
    tbl.clear(oq._atoken)
end

function oq.token_gen() --
    --[[
  local tm = floor(GetTime() * 1000);
  local r = random(0, 10000);
  local token = (tm % 100000) * 10000 + r ;
  return oq.encode_mime64_5digit(token);
]] return oq.encode_mime64_5digit(
        oq.utc_time() * 10000 + oq.random(0, 10000)
    )
end

function oq.is_my_token(t)
    OQ_data.my_tokens = OQ_data.my_tokens or tbl.new()

    if (OQ_data.my_tokens[t]) and (OQ_data.my_tokens[t] > oq.utc_time()) then
        return true
    end
    return nil
end

function oq.store_my_token(t)
    if (t == nil) then
        return
    end
    OQ_data.my_tokens[t] = oq.utc_time() + 8 * 60 * 60 -- expires in 8 hrs
end

function oq.clear_my_token(t)
    if (t == nil) then
        return
    end
    OQ_data.my_tokens[t] = nil
end

function oq.clear_old_tokens()
    if (OQ_data.my_tokens == nil) then
        OQ_data.my_tokens = tbl.new()
    end
    local now = oq.utc_time()

    for i, v in pairs(OQ_data.my_tokens) do
        if (v < now) then
            OQ_data.my_tokens[i] = nil
        end
    end
end

function oq.token_list_init()
    oq._recent_keys = oq._recent_keys or tbl.new()
    oq._recent_tokens = oq._recent_tokens or tbl.new()

    for i = 1, 500 do
        oq._recent_tokens[i] = i
        oq._recent_keys[i] = i
    end
    oq._tok_cnt = 501
end

function oq.token_was_seen(token)
    oq._recent_tokens = oq._recent_tokens or tbl.new()
    return (oq._recent_tokens[token] ~= nil)
end

--
--  remove one from the front, push one to the back
--
function oq.token_push(token_)
    oq._recent_keys = oq._recent_keys or tbl.new()
    oq._recent_tokens = oq._recent_tokens or tbl.new()

    local key = table.remove(oq._recent_keys, 1) -- pop oldest token
    if (key) then
        oq._recent_tokens[key] = nil -- remove old token from quick lookup table
    end

    oq._tok_cnt = oq._tok_cnt + 1
    table.insert(oq._recent_keys, token_) -- push token to back of list
    oq._recent_tokens[token_] = oq._tok_cnt
end

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
function oq.tremove_value(t, val)
    for i, v in pairs(t) do
        if (v == val) then
            tremove(t, i)
            return
        end
    end
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
local function tprint_col(tbl, indent, key)
    if not indent then
        indent = 0
    end
    local ln = string.rep(' ', indent)
    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            tprint_col(v, indent + 1, k)
        elseif (k ~= 'leader_rid') then
            ln = ln .. ' ' .. k .. ': ' .. tostring(v)
        end
    end
    if (key ~= nil) then
        print(tostring(key) .. ': ' .. ln)
    else
        print(ln)
    end
end

function oq.total_tears()
    local n = 0
    for _, v in pairs(OQ_data.tear_cup) do
        n = n + v
    end
    return n
end

function oq.new_tears(ntears)
    player_name = player_name or UnitName('player')
    player_realm = player_realm or oq.GetRealmName()
    if (oq.player_faction == nil) then
        oq.get_player_faction()
    end
    local ndx = strlower(player_realm) .. '.' .. oq.player_faction .. '.' .. strlower(player_name)
    OQ_data.tear_cup[ndx] = (OQ_data.tear_cup[ndx] or 0) + ntears
end

function oq.n_premades()
    local nShown, nPremades = 0, 0

    for _, p in pairs(oq.premades) do
        if (p) then
            if (p._isvis) then
                nShown = nShown + 1
            end
            nPremades = nPremades + 1
        end
    end
    return nShown, nPremades
end

function oq.dump_statistics()
    oq.gather_my_stats()

    print('oQueue premade stats')
    print('---')
    print(' leader stats')
    print(
        ' -  regular bg   : ' ..
            tostring(OQ_data.leader['bg'].nWins or 0) ..
                ' - ' ..
                    tostring(OQ_data.leader['bg'].nLosses or 0) ..
                        ' over ' .. tostring(OQ_data.leader['bg'].nGames or 0) .. ' games'
    )
    print(
        ' -  rated bg     : ' ..
            tostring(OQ_data.leader['rbg'].nWins or 0) ..
                ' - ' ..
                    tostring(OQ_data.leader['rbg'].nLosses or 0) ..
                        ' over ' .. tostring(OQ_data.leader['rbg'].nGames or 0) .. ' games'
    )
    print(
        ' -  5Mans        : ' ..
            tostring(OQ_data.leader['pve.5man'].nBosses) ..
                ' - ' ..
                    tostring(OQ_data.leader['pve.5man'].nWipes) .. '  pts: ' .. tostring(OQ_data.leader['pve.5man'].pts)
    )
    print(
        ' -  raids        : ' ..
            tostring(OQ_data.leader['pve.raid'].nBosses) ..
                ' - ' ..
                    tostring(OQ_data.leader['pve.raid'].nWipes) .. '  pts: ' .. tostring(OQ_data.leader['pve.raid'].pts)
    )
    print(
        ' -  challenges   : ' ..
            tostring(OQ_data.leader['pve.challenge'].nBosses) ..
                ' - ' ..
                    tostring(OQ_data.leader['pve.challenge'].nWipes) ..
                        '  pts: ' .. tostring(OQ_data.leader['pve.challenge'].pts)
    )
    print(
        ' -  scenarios    : ' ..
            tostring(OQ_data.leader['pve.scenario'].nBosses) ..
                ' - ' ..
                    tostring(OQ_data.leader['pve.scenario'].nWipes) ..
                        '  pts: ' .. tostring(OQ_data.leader['pve.scenario'].pts)
    )

    print('  my win-loss      : ')
    print(
        ' -  regular bg     : ' ..
            tostring(oq.toon.stats['bg'].nWins or 0) ..
                ' - ' ..
                    tostring(oq.toon.stats['bg'].nLosses or 0) ..
                        ' over ' .. tostring(oq.toon.stats['bg'].nGames or 0) .. ' games'
    )
    print(
        ' -  rated bg       : ' ..
            tostring(oq.toon.stats['rbg'].nWins or 0) ..
                ' - ' ..
                    tostring(oq.toon.stats['rbg'].nLosses or 0) ..
                        ' over ' .. tostring(oq.toon.stats['rbg'].nGames or 0) .. ' games'
    )

    print('  my_tears         : ' .. tostring(oq.total_tears()))
    print('  my_name          : ' .. tostring(player_name))

    if (OQ.REGION ~= 'us') and (OQ.REGION ~= 'eu') and (OQ.REGION ~= 'hu') then
        print(
            '  my_region        : ' .. OQ.LILREDX_ICON .. ' |cFFFF8080invalid region(' .. tostring(OQ.REGION) .. ')|r'
        )
    else
        print('  my_region        : ' .. tostring(OQ.REGION))
    end
    print('  my_realmlist     : ' .. tostring(GetCVar('realmlist')))

    if (player_realm == nil) then
        print(
            '  my_realm          : ' ..
                OQ.LILREDX_ICON .. ' |cFFFF8080unknown realm: ' .. tostring(GetRealmName()) .. '|r'
        )
    else
        print('  my_realm         : ' .. tostring(player_realm) .. ' (' .. tostring(oq.GetRealmID(player_realm)) .. ')')
    end

    if (oq.player_realid == nil) then
        print('  my_btag          : ' .. OQ.LILREDX_ICON .. ' |cFFFF8080no battle-tag assigned|r')
    else
        print('  my_btag          : ' .. tostring(oq.player_realid))
    end

    print('  my_role          : ' .. tostring(OQ.ROLES[player_role]))
    print('  my_ilevel        : ' .. oq.get_ilevel())
    print('  my_rbg_rating    : ' .. oq.get_mmr())
    print('  my_2s_rating     : ' .. oq.get_arena_rating(1))
    print('  my_3s_rating     : ' .. oq.get_arena_rating(2))
    print('  my_5s_rating     : ' .. oq.get_arena_rating(3))
    print('  my_resil         : ' .. oq.get_resil())
    print('  my_timevariance  : ' .. oq.render_tm(OQ_data.sk_adjust or 0))
    print('  my_time_drift    : ' .. oq.render_tm(oq.pkt_drift._mean or 0))
    print('  my_time_diff     : ' .. oq.render_tm(oq.gmt_diff_track:median()))
    print('  my_time_adjust   : ' .. oq.render_tm(OQ_data.sk_adjust))
    print('  my_next_timechk  : ' .. oq.render_tm((OQ_data.sk_next_update or 0) - oq.utc_time('pure')))
    if (oq.raid.raid_token == nil) then
        print('  my_group:  not in an OQ premade')
    else
        print(
            '  my_group: ' ..
                tostring(oq.raid.type) ..
                    '.' ..
                        tostring(oq.raid.raid_token) ..
                            ' . ' ..
                                tostring(my_group) ..
                                    ' . ' ..
                                        tostring(my_slot) ..
                                            '  ' .. tostring(oq.raid.leader) .. '-' .. tostring(oq.raid.leader_realm)
        )
        if (oq.iam_related_to_boss()) then
            print('    --  i am related to the boss')
        end
    end
    if (_inside_bg) then
        print(' inside bg       : yes')
    elseif (oq._inside_instance) then
        print(' inside instance : yes')
    else
        print(' inside bg       : no')
    end
    if (oq.toon.disabled) then
        print('  OQ messaging is DISABLED')
    else
        print('  OQ messaging is ENABLED')
    end
    local nShown, nPremades = oq.n_premades()
    print('  # of premades        : ' .. nShown .. ' / ' .. nPremades)
    print(
        '  packets recv         : ' ..
            oq.pkt_recv._cnt .. ' (' .. string.format('%5.3f', oq.pkt_recv._aps) .. ' per sec)'
    )
    print(
        '  packets processed    : ' ..
            oq.pkt_processed._cnt .. ' (' .. string.format('%5.3f', oq.pkt_processed._aps) .. ' per sec)'
    )
    print(
        '  packets sent         : ' ..
            oq.pkt_sent._cnt ..
                ' (' .. string.format('%5.3f', oq.pkt_sent._aps) .. ' per sec)  ' .. #oq.send_q .. " q'd"
    )
    print('')

    if (oq._isAfk) then
        print('  oqgeneral #:  |cFFFF8080player is AFK|r')
    else
        if (_oqgeneral_lockdown) then
            if (_oqgeneral_count > 0) then
                print('  oqgeneral #: ' .. _oqgeneral_count .. '   channel over capacity.  restricted')
            else
                print('  oqgeneral #: ' .. _oqgeneral_count .. '   restricted')
            end
        else
            if (_oqgeneral_count > MAX_OQGENERAL_TALKERS) then
                print('  oqgeneral #: ' .. _oqgeneral_count .. '   channel over capacity.  no restrictions')
            else
                print('  oqgeneral #: ' .. _oqgeneral_count .. '   no restrictions')
            end
        end
    end
    print('---')
end

function oq.show_member(m)
    print('-- [' .. tostring(m.name) .. '][' .. tostring(m.realm) .. ']')
end

function oq.raid_init()
    tbl.delete(oq.raid, true)
    tbl.delete(oq.waitlist, true)
    tbl.delete(oq.pending, true)
    tbl.delete(oq.names, true)

    oq.raid = tbl.new()
    oq.raid.group = tbl.new()
    for i = 1, 8 do
        oq.raid.group[i] = tbl.new()
        oq.raid.group[i].member = tbl.new()
        for j = 1, 5 do
            oq.raid.group[i].member[j] = tbl.new()
            oq.raid.group[i].member[j].flags = 0
            oq.raid.group[i].member[j].bg = tbl.new()
            oq.raid.group[i].member[j].bg[1] = tbl.new()
            oq.raid.group[i].member[j].bg[2] = tbl.new()
            oq.raid.group[i].member[j].bg[1].queue_ts = 0
            oq.raid.group[i].member[j].bg[2].queue_ts = 0
            oq.raid.group[i].member[j].bg[1].dt = 0
            oq.raid.group[i].member[j].bg[2].dt = 0
        end
    end
    oq.raid.raid_token = nil
    oq.raid.type = OQ.TYPE_BG
    oq.waitlist = tbl.new()
    oq.pending = tbl.new()
    oq.names = tbl.new() -- key == name-realm; value == btag; populate from waitlist
    my_group = 0
    my_slot = 0

    -- clear chart for bg premades
    if (oq.ui.battleground_frame) and (oq.ui.battleground_frame._chart) then
        oq.ui.battleground_frame._chart:zero_data()
    end

    oq.procs_no_raid()
end

function oq.channel_isregistered(chan_name)
    local n = strlower(chan_name)
    return oq.channels[n]
end

function oq.buildChannelList(...)
    local tbl = tbl.new()

    for i = 1, select('#', ...), 2 do
        local id, name = select(i, ...)
        tbl[id] = strlower(name)
    end

    return tbl
end

function oq.channel_join(chan_name, pword)
    local n = strlower(chan_name)
    if
        ((n == OQ_REALM_CHANNEL and oq._inside_instance and not oq.iam_raid_leader()) or
            oq._oqgeneral_initialized == nil)
     then
        return nil
    end
    if (oq.channels[n] == nil) then
        oq.channels[n] = tbl.new()
        oq.channels[n].id = 0
    end

    local id, chname, instance_id = GetChannelName(n)
    if (chname == nil) then
        JoinTemporaryChannel(n, pword)
        id, chname, instance_id = GetChannelName(n)
        if (id < 2) then
            LeaveChannelByName(chname)
            return nil
        end
    end
    oq.channels[n].id = id
    oq.channels[n].pword = pword
    return 1
end

function oq.hook_roster_update(chan_name)
    local n = strlower(chan_name)
    local nchannels = GetNumDisplayChannels()

    for i = 1, nchannels do
        local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive =
            GetChannelDisplayInfo(i)
        if (name ~= nil) and (strlower(name) == n) then
            _oqgeneral_id = i
            SetSelectedDisplayChannel(_oqgeneral_id)
            return true
        end
    end
end

function oq.check_oqgeneral_lockdown()
    local n, index = oq.n_channel_members(OQ_REALM_CHANNEL)
    _oqgeneral_count = n
    if (n < MAX_OQGENERAL_TALKERS) or (n == 0) then
        -- no restrictions
        _oqgeneral_lockdown = (n == 0)
        return
    end

    local old_chan_ndx = GetSelectedDisplayChannel()
    SetSelectedDisplayChannel(index)
    --  local index = GetSelectedDisplayChannel()
    local count = select(5, GetChannelDisplayInfo(index))
    tbl.clear(_names)

    for i = 1, count do
        local n2 = select(1, GetChannelRosterInfo(index, i))
        if n2 then
            table.insert(_names, n2)
        end
    end
    -- sort
    table.sort(_names)
    -- determine player position in list
    count = 0
    for _, v in pairs(_names) do
        count = count + 1
        if (v == player_name) or (count > MAX_OQGENERAL_TALKERS) then
            _oqgeneral_lockdown = (count > MAX_OQGENERAL_TALKERS)
            break
        end
    end
    -- if position > max talkers, lockdown
    SetSelectedDisplayChannel(old_chan_ndx)
end

function oq.n_channel_members(chan_name)
    local n = strlower(chan_name)
    local nchannels = GetNumDisplayChannels()

    for i = 1, nchannels do
        local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive =
            GetChannelDisplayInfo(i)

        if (name ~= nil) and (n == strlower(name)) then
            return count or 0, i
        end
    end
    return 0, 0
end

function oq.channel_leave(chan_name)
    local n = strlower(chan_name)
    LeaveChannelByName(n)
    oq.channels[n] = nil
end

function oq.log_clear()
    OQ_data.log = tbl.new()
end

function oq.log_cmdline(opt)
    if (opt == nil) or (opt == '') then
        oq.toggle_log()
        return
    end
    if (opt == 'clear') then
        if (OQ_data._history) then
            OQ_data._history = tbl.delete(OQ_data._history)
            oq.log(nil, '|cFF808080log cleared on|r ' .. date('%H:%M %d-%b', oq.utc_time()))
        end
        return
    end
end

function oq.SendChannelMessage(chan_name, msg)
    local n = strlower(chan_name)
    if (not oq.IsMessageWellFormed(msg)) then
        local msg_tok = 'A' .. oq.token_gen()
        oq.token_push(msg_tok)
        msg = 'OQ,' .. OQ_BUILD_STR .. ',' .. msg_tok .. ',' .. OQ_TTL .. ',' .. msg
    end
    if (n ~= nil and oq.channels[n] ~= nil and oq._isAfk == nil and oq.channels[n].id and oq._banned == nil) then
        oq.SendChatMessage(msg, 'CHANNEL', nil, oq.channels[n].id)
    end
end

function oq.oqgeneral_join()
    oq.initial_join_oqgeneral()
    if (oq._banned) or (OQ_data.auto_join_oqgeneral == 0) or (oq._oqgeneral_initialized == nil) then
        return
    end
    if (oq._inside_instance) and (not oq.iam_raid_leader()) then
        return
    end
    if (oq.channel_join(OQ_REALM_CHANNEL) == 1) then
        oq.timer('hook_roster_update', 5, oq.hook_roster_update, true, OQ_REALM_CHANNEL) -- will repeat until channel joined
        oq.timer('chk_OQGeneralLockdown', 30, oq.check_oqgeneral_lockdown, true) -- will check capacity every 30 seconds
    else
        oq._oqgeneral_initialized = nil
    end
end

function oq.initial_join_oqgeneral()
    if (oq._oqgeneral_initialized) then
        return
    end
    local now = GetTime()
    if (oq._next_init_tm) and (now < oq._next_init_tm) then
        return
    end
    oq._next_init_tm = now + 5

    tbl.fill(_arg, GetChannelList())
    if (#_arg < 2) then
        return
    end

    oq._oqgeneral_initialized = 1
    oq.oqgeneral_join()
    return oq._oqgeneral_initialized
end

function oq.oqgeneral_leave()
    _oqgeneral_lockdown = true -- lock the door.  the restriction will life once joined and cleared
    oq.channel_leave(OQ_REALM_CHANNEL)
    oq.timer('chk_OQGeneralLockdown', 0, nil)
end

function oq.SendOQChannelMessage(msg)
    if (_oqgeneral_lockdown) then
        return -- too many ppl in oqgeneral, voluntary mute engaged
    end
    oq.SendChannelMessage(OQ_REALM_CHANNEL, msg)
end

function oq.iam_in_a_party()
    return GetNumGroupMembers() > 0
end

function oq.is_oqueue_msg(msg)
    if (msg:sub(1, #OQ_MSGHEADER) == OQ_MSGHEADER) then
        return true
    end
    return nil
end

function oq.SendChatMessage(msg, type, lang, channel)
    if (msg == nil) then
        return
    end

    if ((GetNumGroupMembers() == 0) and (type ~= 'CHANNEL' and type ~= 'WHISPER')) then
        return
    end

    local instance, instanceType = IsInInstance()
    if (instance and ((type == 'PARTY') or (type == 'RAID'))) then
        type = 'INSTANCE_CHAT'
    elseif (instance == nil) then
        if (IsInRaid() and (type == 'PARTY')) then
            type = 'RAID'
        elseif (not IsInRaid() and (type == 'RAID')) then
            type = 'PARTY'
        end
    end

    SendChatMessage(msg, type, lang, channel)
    oq.pkt_sent:inc()
end

function oq.SendAddonMessage_now(channel, msg, type, to_name)
    if (oq._isAfk) then
        return
    end
    SendAddonMessage(channel, msg, type, to_name)
    oq.pkt_sent:inc()
end

function oq.SendAddonMessage(channel, msg, type, to_name)
    if (msg == nil) or (GetNumGroupMembers() == 0) then
        return
    end
    if (#msg > 254) then
        msg = msg:sub(1, 254)
    end
    local instance, instanceType = IsInInstance()

    if (instance and ((type == 'PARTY') or (type == 'RAID'))) then
        type = 'INSTANCE_CHAT'
    elseif (instance == nil) then
        if (IsInRaid() and (type == 'PARTY')) then
            type = 'RAID'
        elseif (not IsInRaid() and (type == 'RAID')) then
            type = 'PARTY'
        end
    end

    if (oq._send_immediate) then
        if (type == 'PARTY') or (type == 'RAID') or (type == 'INSTANCE_CHAT') then
            oq.SendAddonMessage_now(channel, msg, type, nil)
        elseif (type == 'WHISPER') and (to_name) then
            oq.SendAddonMessage_now(channel, msg, type, to_name)
        elseif (string.find(msg, ',p8,') == nil) then
            oq.SendAddonMessage_now(channel, msg, type, to_name)
        end
    else
        if (type == 'PARTY') or (type == 'RAID') or (type == 'INSTANCE_CHAT') then
            oq.BNSendQ_push(oq.SendAddonMessage_now, channel, msg, type, nil)
        elseif (type == 'WHISPER') and (to_name) then
            oq.BNSendQ_push(oq.SendAddonMessage_now, channel, msg, type, to_name)
        elseif (string.find(msg, ',p8,') == nil) then
            oq.BNSendQ_push(oq.SendAddonMessage_now, channel, msg, type, to_name)
        end
    end
end

function oq.SendPartyMessage(msg)
    oq.SendAddonMessage(OQ_HEADER, msg, 'PARTY')
end

--------------------------------------------------------------------------
--  communications
--------------------------------------------------------------------------
--[[
    http://www.wowpedia.org/API_GetCombatRating

    CR_WEAPON_SKILL = 1;
    CR_DEFENSE_SKILL = 2;
    CR_DODGE = 3;
    CR_PARRY = 4;
    CR_BLOCK = 5;
    CR_HIT_MELEE = 6;
    CR_HIT_RANGED = 7;
    CR_HIT_SPELL = 8;
    CR_CRIT_MELEE = 9;
    CR_CRIT_RANGED = 10;
    CR_CRIT_SPELL = 11;
    CR_HIT_TAKEN_MELEE = 12;
    CR_HIT_TAKEN_RANGED = 13;
    CR_HIT_TAKEN_SPELL = 14;
    COMBAT_RATING_RESILIENCE_CRIT_TAKEN = 15;
    COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
    CR_CRIT_TAKEN_SPELL = 17;
    CR_HASTE_MELEE = 18;
    CR_HASTE_RANGED = 19;
    CR_HASTE_SPELL = 20;
    CR_WEAPON_SKILL_MAINHAND = 21;
    CR_WEAPON_SKILL_OFFHAND = 22;
    CR_WEAPON_SKILL_RANGED = 23;
    CR_EXPERTISE = 24;
    CR_ARMOR_PENETRATION = 25;
    CR_MASTERY = 26;
    CR_PVP_POWER = 27;
]]
function oq.get_pvppower()
    return (GetCombatRating(27) or 0)
end

function oq.on_player_mmr_change()
    oq.get_mmr()
end

function oq.get_best_mmr(type)
    if (type == OQ.TYPE_ARENA) then
        local m = 0
        for i = 1, 3 do
            m = max(m, oq.get_arena_rating(i))
        end
        return m
    else
        return oq.get_mmr()
    end
end

function oq.get_mmr()
    return select(1, GetPersonalRatedInfo(4)) or 0
end

function oq.get_arena_rating(type)
    return select(1, GetPersonalRatedInfo(type)) or 0
end

function oq.my_seat()
    return my_group, my_slot
end

function oq.clear_empty_seats()
    local n = GetNumGroupMembers()
    local seats = tbl.new()

    for i = 1, 8 do
        seats[i] = 0
    end

    local g = 0
    for i = 1, n do
        local name_, _, gid = GetRaidRosterInfo(i)
        local name, realm = oq.crack_name(name_)
        if (gid ~= g) then
            g = gid
            seats[gid] = 1
        else
            seats[gid] = seats[gid] + 1
        end
    end
    -- for groups w/ no one in them
    if (oq.raid.raid_token) then
        seats[1] = max(1, seats[1]) -- at least the RL
    end
    for g2 = 1, 8 do
        if (seats[g2] < 5) then
            for i = seats[g2] + 1, 5 do
                oq.raid_cleanup_slot(g2, i)
            end
        end
    end
end

function oq.check_seat(name, realm, g_id, slot)
    g_id = g_id or 0
    slot = slot or 0
    if (g_id == 0) or (slot == 0) or (oq.raid.group[g_id] == nil) or (oq.raid.group[g_id].member[slot] == nil) then
        return -1
    end
    realm = oq.GetRealmNameFromID(realm)

    local me = oq.raid.group[g_id].member[slot]
    if (me.name == name) and (me.realm == realm) then
        return 0
    end

    -- find seat
    for i = 1, 8 do
        for j = 1, 5 do
            local s = oq.raid.group[i].member[j]
            if (s.name == name) and (s.realm == realm) then
                -- found the seat, move
                oq.raid.group[g_id].member[slot] = s
                oq.raid.group[i].member[j] = me -- clean it out
                oq.raid_cleanup_slot(i, j)
                return 1
            end
        end
    end
    return -2
end

function oq.check_my_seat()
    return oq.check_seat(player_name, player_realm_id, my_group, my_slot)
end

function oq.get_spell_power()
    local pow = 0

    for i = 1, 7 do
        pow = max(pow, GetSpellBonusDamage(i))
    end
    return pow
end

function oq.get_hks()
    local hks = GetStatistic(588) or 0
    if (hks == '--') then
        hks = 0
    end
    return floor(hks / 1000)
end

function oq.get_resil()
    return (GetCombatRating(16) or 0)
end

function oq.debug_report(...)
    if (oq._debug) then
        print(...)
    end
end

function oq.get_ilevel()
    return floor(select(2, GetAverageItemLevel()))
end

function oq.iam_party_leader()
    if (oq.iam_in_a_party()) then
        return my_group ~= 0 and my_slot == 1
    else
        return my_slot == 1
    end
end

function oq.iam_alone()
    if (oq._inside_instance and oq._entered_alone) then
        return true
    end
    local n = 0
    for i = 1, 5 do
        local m = oq.raid.group[1].member[i]
        if ((m.name) and (m.name ~= '-')) then
            n = n + 1
        end
    end
    return (n == 1)
end

function oq.iam_raid_leader()
    return (oq.raid.leader ~= nil and player_name == oq.raid.leader)
end

function oq.has_lead_popped()
    local lead = oq.raid.group[1].member[1]
    if (lead.bg[1].queue_ts ~= 0) or (lead.bg[2].queue_ts ~= 0) then
        return true
    end
    return nil
end

function oq.my_queue_popped()
    local s1 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(1))]
    local s2 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(2))]
    return (s1 == '2') or (s2 == '2')
end

function oq.is_raid()
    if
        (oq.raid.type == OQ.TYPE_BG) or (oq.raid.type == OQ.TYPE_RBG) or (oq.raid.type == OQ.TYPE_RAID) or
            (oq.raid.type == OQ.TYPE_ROLEPLAY)
     then
        return true
    end
    return nil
end

function oq.is_in_raid(name)
    if (name == nil) or (name == '') then
        return nil
    end

    name = name:gsub('%s+', '')
    name = strlower(name)
    for _, grp in pairs(oq.raid.group) do
        for _, mem in pairs(grp.member) do
            local n = strlower(mem.name or '')
            if ((n) and (n ~= '') and (n ~= '-')) then
                if ((mem.realm) and (mem.realm ~= player_realm)) then
                    n = n .. '-' .. mem.realm
                end
                n = n:gsub('%s+', '')
                n = strlower(n)
                if (name == n) then
                    return true
                end
            end
        end
    end
    return nil
end

function oq.mark_currency()
    -- clear the wallet
    tbl.clear(oq.toon.player_wallet)
    -- mark currency
    local n = GetCurrencyListSize()

    for index = 1, n do
        local name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID =
            GetCurrencyListInfo(index)
        if (name ~= nil) then
            oq.toon.player_wallet[name] = count
        end
    end
    -- mark rep
    for factionIndex = 1, GetNumFactions() do
        local name,
            description,
            standingId,
            bottomValue,
            topValue,
            earnedValue,
            atWarWith,
            canToggleAtWar,
            isHeader,
            isCollapsed,
            hasRep,
            isWatched,
            isChild = GetFactionInfo(factionIndex)
        if (name ~= nil) then
            oq.toon.player_wallet[name] = earnedValue
        end
    end
    -- mark xp
    oq.toon.player_wallet['level'] = UnitLevel('player') or 0
    oq.toon.player_wallet['xp'] = UnitXP('player') or 0
    oq.toon.player_wallet['maxxp'] = UnitXPMax('player') or 0

    -- mark hks
    oq.toon.player_wallet['hks'] = tonumber(GetStatistic(588) or 0) or 0

    -- mark mmr
    oq.toon.player_wallet['mmr'] = oq.get_mmr() or 0

    -- mark money
    oq.toon.player_wallet['money'] = tonumber(GetMoney() or 0) or 0
end

function oq.check_currency()
    local duration = oq._instance_duration
    if (duration == nil) or (duration == 0) and ((oq._instance_tm) and (oq._instance_tm > 0)) then
        duration = oq.utc_time() - (oq._instance_tm or 0)
    end
    if (duration == nil) or (duration == 0) then
        print(OQ.LILREDX_ICON .. ' ' .. OQ.ERR_NODURATION)
        return
    end

    -- check for gains in currency
    local n = GetCurrencyListSize()

    for index = 1, n do
        local name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID =
            GetCurrencyListInfo(index)
        if (name ~= nil) and (oq.toon.player_wallet[name] ~= nil) then
            if (oq.toon.player_wallet[name] ~= count) then
                local delta = count - oq.toon.player_wallet[name]
                local rate = floor((delta / duration) * 60 * 60) -- bg_length is seconds * 60*60 --> delta/hr
                if (delta > 0) then
                    if (name == OQ.HONOR_PTS) and (count == OQ_MAX_HONOR) then -- honor capped
                        oq.log(true, name .. '  ' .. OQ.LILREDX_ICON .. ' ' .. OQ.CAPPED .. ' ' .. OQ.LILREDX_ICON)
                    elseif (name == OQ.HONOR_PTS) and (count >= OQ_MAX_HONOR_WARNING) then -- approaching honor capped
                        oq.log(
                            true,
                            OQ.GAINED ..
                                ' ' ..
                                    delta ..
                                        ' ' ..
                                            name ..
                                                '  (' ..
                                                    rate ..
                                                        ' ' ..
                                                            OQ.PERHOUR ..
                                                                ')  ' ..
                                                                    OQ.LILREDX_ICON ..
                                                                        ' ' ..
                                                                            OQ.APPROACHING_CAP .. ' ' .. OQ.LILREDX_ICON
                        )
                    else
                        oq.log(
                            true,
                            OQ.GAINED .. ' ' .. delta .. ' ' .. name .. '  (' .. rate .. ' ' .. OQ.PERHOUR .. ')'
                        )
                    end
                elseif (delta < 0) then
                    oq.log(true, OQ.LOST .. ' ' .. delta .. ' ' .. name .. '  (' .. rate .. ' ' .. OQ.PERHOUR .. ')')
                end
            elseif (oq.toon.player_wallet[name] == count) and (name == OQ.HONOR_PTS) and (count == OQ_MAX_HONOR) then
                oq.log(true, name .. '  ' .. OQ.LILREDX_ICON .. ' ' .. OQ.CAPPED .. ' ' .. OQ.LILREDX_ICON)
            end
        end
    end

    -- check for gains in reputation
    for factionIndex = 1, GetNumFactions() do
        local name,
            description,
            standingId,
            bottomValue,
            topValue,
            count,
            atWarWith,
            canToggleAtWar,
            isHeader,
            isCollapsed,
            hasRep,
            isWatched,
            isChild = GetFactionInfo(factionIndex)
        if (name ~= nil) and (oq.toon.player_wallet[name] ~= nil) then
            local delta = count - oq.toon.player_wallet[name]
            local rate = floor((delta / duration) * 60 * 60) -- bg_length is seconds * 60*60 --> delta/hr
            if (delta > 0) then
                oq.log(
                    true,
                    OQ.GAINED ..
                        ' ' .. delta .. ' ' .. OQ.WITH .. ' ' .. name .. '  (' .. rate .. ' ' .. OQ.PERHOUR .. ')'
                )
            elseif (delta < 0) then
                oq.log(
                    true,
                    OQ.LOST ..
                        ' ' .. delta .. ' ' .. OQ.WITH .. ' ' .. name .. '  (' .. rate .. ' ' .. OQ.PERHOUR .. ')'
                )
            end
        end
    end

    -- check for gains in xp
    local level = UnitLevel('player')
    local xp = UnitXP('player')
    local maxxp = UnitXPMax('player')
    local delta = 0
    if (level ~= oq.toon.player_wallet['level']) then
        -- gained level
        -- note: won't handle gaining more then one level per bg.  don't have the maxxp per level to calculate
        delta = (oq.toon.player_wallet['maxxp'] - oq.toon.player_wallet['xp']) + xp
    elseif (xp ~= oq.toon.player_wallet['xp']) then
        delta = xp - oq.toon.player_wallet['xp']
    end
    if (delta > 0) then
        -- report gained xp
        local rate = floor((delta / duration) * 60 * 60) -- bg_length is seconds * 60*60 --> delta/hr
        oq.log(true, OQ.GAINED .. ' ' .. delta .. ' XP  (' .. rate .. ' ' .. OQ.PERHOUR .. ')')
    end

    -- check for gains in hks
    if (oq.toon.player_wallet['hks']) then
        local hks = tonumber(GetStatistic(588) or 0) or 0
        delta = hks - (tonumber(oq.toon.player_wallet['hks'] or 0) or 0)
        if (delta > 0) then
            -- report gained hks
            local rate = floor((delta / duration) * 60 * 60) -- bg_length is seconds * 60*60 --> delta/hr
            oq.log(true, OQ.GAINED .. ' ' .. delta .. ' HKs  (' .. rate .. ' ' .. OQ.PERHOUR .. ')')
        end
    end

    -- report mmr
    local mmr = oq.get_mmr()
    delta = mmr - oq.toon.player_wallet['mmr']
    if (delta > 0) then
        oq.log(true, OQ.GAINED .. ' ' .. delta .. ' ' .. OQ.TT_MMR .. '  (' .. OQ.NOW .. ' ' .. mmr .. ')')
    elseif (delta < 0) then
        oq.log(true, OQ.LOST .. ' ' .. delta .. ' ' .. OQ.TT_MMR .. '  (' .. OQ.NOW .. ' ' .. mmr .. ')')
    end

    if (oq._instance_end_tm) and (oq._instance_end_tm > 0) then
        oq.log(
            true,
            OQ.INSTANCE_LASTED .. ' ' .. floor(duration / 60) .. ':' .. string.format('%02d', floor(duration % 60))
        )
    end

    -- report money
    if (oq.toon.player_wallet['money']) then
        local money = GetMoney()
        delta = money - (tonumber(oq.toon.player_wallet['money'] or 0) or 0)
        local rate = floor((delta / duration) * 60 * 60) -- bg_length is seconds * 60*60 --> delta/hr
        -- shave the pennies
        delta = floor(delta / 100) * 100
        rate = floor(rate / 100) * 100

        if (delta > 0) then
            oq.log(
                true,
                OQ.GAINED ..
                    ' ' ..
                        GetCoinTextureString(delta) ..
                            '    (' .. GetCoinTextureString(abs(rate)) .. ' ' .. OQ.PERHOUR .. ')'
            )
        elseif (delta < 0) then
            oq.log(
                true,
                OQ.LOST ..
                    ' ' ..
                        GetCoinTextureString(abs(delta)) ..
                            '    (' .. GetCoinTextureString(abs(rate)) .. ' ' .. OQ.PERHOUR .. ')'
            )
        end
    end

    oq.timer_oneshot(10, oq.force_stats) -- force stats to refresh 10 seconds after coming out

    -- instance over
    if (oq._instance_end_tm) and (oq._instance_end_tm > 0) then
        -- resetting data
        oq._instance_type = nil
    end
end

function oq.show_wallet()
    print('--[ player wallet ]--')
    if (oq.toon.player_wallet) then
        for i, v in pairs(oq.toon.player_wallet) do
            print(i .. ' :  ' .. v)
        end
    end
    print('--')
end

function oq.bg_cleanup()
    -- clean up structs no longer needed after bg
    _flags = tbl.delete(_flags, true)
    _enemy = tbl.delete(_enemy, true)
end

function oq.flag_watcher()
    if (not _inside_bg) or (_winner ~= nil) then
        return
    end
    local now = oq.utc_time()
    if (now < _next_flag_check) then
        return
    end
    _next_flag_check = now + 4 -- minimal

    local p_faction = 0 -- 0 == horde, 1 == alliance, -1 == offline
    if (oq.get_bg_faction() == 'A') then
        p_faction = 1
    end
    if (WorldStateScoreFrame:IsVisible()) then
        return
    end
    -- clear faction
    SetBattlefieldScoreFaction(nil)
    local nplayers = GetNumBattlefieldScores()

    if (nplayers <= 10) then
        -- not inside, the call failed, or in an arena match
        return
    end
    _flags = _flags or tbl.new()
    _enemy = _enemy or tbl.new()

    for i = 1, nplayers do
        local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class =
            GetBattlefieldScore(i)
        if (name) and (faction) and (faction == p_faction) then
            local nstats = GetNumBattlefieldStats()
            if (_flags[name] == nil) then
                _flags[name] = tbl.new()
            end
            for statndx = 1, nstats do
                local stat = GetBattlefieldStatData(i, statndx)
                if (_flags[name][statndx] == nil) then
                    _flags[name][statndx] = 0
                end
                if (_flags[name][statndx] ~= stat) then
                    local stat_name = GetBattlefieldStatInfo(statndx)
                    local str = stat_name .. ':  ' .. name
                    if (OQ.BG_STAT_COLUMN[stat_name] ~= nil) then
                        str = OQ.BG_STAT_COLUMN[stat_name] .. ':  ' .. name
                    end
                end
                _flags[name][statndx] = stat
            end
        elseif (name) and (faction) and (faction ~= p_faction) then
            if (_enemy[name] == nil) then
                _enemy[name] = tbl.new()
                _enemy[name].appearance = now
            end
            _enemy[name].last_seen = now -- always updating, last time seen ~= now... player left
            _enemy[name].strike = 0
        end
    end

    -- report rage-quitters
    local s = oq.toon.stats['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = oq.toon.stats['rbg']
    end

    if (nplayers > 10) then -- just incase the GetBattlefieldScore was wonky
        for _, e in pairs(_enemy) do
            if (e.last_seen ~= nil) then
                if (e.last_seen ~= now) and (e.reported == nil) then
                    if (e.strike >= 1) then
                        -- don't report until the 2nd strike.  the scorecard can be flaky
                        e.reported = true
                        if (IsRatedBattleground() == false) then
                            oq.new_tears(1) -- acct wide; should increment your tear count only for regular bgs, as only enemy faction counts
                        end
                        OQ_data.nrage = OQ_data.nrage + 1
                    else
                        e.strike = e.strike + 1
                    end
                end
            end
        end
    end
end

function oq.UnitSetRole(target, role)
    if (InCombatLockdown()) then
        -- cannot change while in combat.  comeback in 3 seconds to try again
        oq.timer_oneshot(3, oq.UnitSetRole, target, role)
    else
        UnitSetRole(target, role)
    end
end

function oq.entering_bg()
    _inside_bg = true
    _lucky_charms = nil
    _winner = nil
    OQ_data.nrage = 0

    oq.UnitSetRole('player', OQ.ROLES[player_role])

    oq.timer('flag_watcher', 5, RequestBattlefieldScoreData, true) -- requesting score info
    StaticPopup_Hide('OQ_QueuePoppedMember')

    local s = oq.init_stats_data()

    _winner = nil

    if (not oq.iam_raid_leader()) then
        return
    end

    oq.timer('bg_spy_report', 30, oq.battleground_spy)

    -- send one last message before entering
    oq.send_my_premade_info()
end

function oq.game_ended()
    _winner = GetBattlefieldWinner()

    oq.calc_game_stats()
    oq.calc_player_stats()
    oq.calc_game_report()

    -- update info for hover on find-premade and premade tab
    oq.update_my_hover_overs()
end

function oq.update_my_hover_overs()
    if ((my_group == 0) or (my_slot == 0)) then
        return
    end

    -- update leader info for find-premade tab
    if (oq.iam_raid_leader()) then
        local s = OQ_data.leader['bg']
        if (oq.raid.type == OQ.TYPE_RBG) then
            s = OQ_data.leader['rbg']
        end

        local raid = oq.premades[oq.raid.raid_token]
        if (raid ~= nil) then
            raid.nWins = s.nWins
            raid.nLosses = s.nLosses
        end
    end

    -- update personal win-loss in the main premade tab
    local me = oq.raid.group[my_group].member[my_slot]
    local s = oq.toon.stats['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = oq.toon.stats['rbg']
    end
    me.wins = s.nWins
    me.losses = s.nLosses
    me.tears = oq.total_tears()
end

function oq.deserted()
    if (my_group == 0) then
        return
    end

    -- register personal loss
    local s = oq.toon.stats['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = oq.toon.stats['rbg']
    end
    print(OQ.LILSKULL_ICON .. '  ' .. OQ.RANAWAY)

    s.nLosses = s.nLosses + 1
    s.nGames = s.nGames + 1

    -- if leader, register leader loss
    if (not oq.iam_raid_leader()) then
        return
    end
    local s = OQ_data.leader['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = OQ_data.leader['rbg']
    end
    s.nLosses = s.nLosses + 1
    s.nGames = s.nGames + 1
end

function oq.leaving_bg()
    _inside_bg = nil
    _lucky_charms = nil

    oq.raid._last_lag = oq.utc_time() + 60 -- give them some time to leave the BG

    -- post game clean up
    oq.gather_my_stats()
    if (oq.check_for_deserter()) then
        -- register loss
        oq.deserted()
        return
    end

    -- reset queue status
    for i = 1, 8 do
        for j = 1, 5 do
            local m = oq.raid.group[i].member[j]
            m.check = OQ.FLAG_CLEAR
            m.bg[1].status = '0'
            m.bg[1].queue_ts = 0
            m.bg[1].dt = 0

            m.bg[2].status = '0'
            m.bg[2].queue_ts = 0
            m.bg[2].dt = 0
        end
    end

    -- reset ping timers
    if (oq.iam_raid_leader()) then
        for i = 2, 8 do
            oq.raid.group[i]._last_ping = nil
        end
    end

    if (oq.iam_raid_leader()) then
        local now = oq.utc_time()
        local raid = oq.premades[oq.raid.raid_token]
        raid.last_seen = now
        raid.next_advert = now + (OQ_SEC_BETWEEN_PROMO / 2)
    end

    oq.timer_oneshot(4.0, oq.cache_mmr_stats) -- must open conquest tab to refresh mmr info
    oq.timer('flag_watcher', 5, nil)
    _flags = tbl.delete(_flags, true) -- clearing out score flags
    _enemy = tbl.delete(_enemy, true)

    -- clear chart for bg premades
    if (oq.ui.battleground_frame) and (oq.ui.battleground_frame._chart) then
        oq.ui.battleground_frame._chart:zero_data()
    end

    -- update my slot
    if (my_group > 0) and (my_slot > 0) then
        oq.set_textures(my_group, my_slot)
    end
end

function oq.game_in_process()
    oq.pass_bg_leader()
end

function oq.warning_no_role()
    if (oq.loaded == nil) then
        return
    end
    local class, spec, spec_id = oq.get_spec()

    print(OQ.LILREDX_ICON .. '  WARNING:  player_role unknown.  This may be a language support issue.')
    print(OQ.LILREDX_ICON .. '  WARNING:  If you believe oQueue does not support your language,')
    print(OQ.LILREDX_ICON .. '  WARNING:  please inform tiny on https://github.com/Tauri-WoW-Community-Devs/oqueue')
    print(OQ.LILREDX_ICON .. '  locale: ' .. GetLocale())
    print(OQ.LILREDX_ICON .. '  class: ' .. tostring(class))
    print(OQ.LILREDX_ICON .. '  spec: ' .. tostring(spec))
end

function oq.get_spec()
    local class = select(2, UnitClass('player'))
    local primaryTalentTree = GetSpecialization()
    local spec = nil
    local spec_id = 0
    if (primaryTalentTree) then
        local id, name, description, icon, background, role = GetSpecializationInfo(primaryTalentTree)
        spec = name
        spec_id = id
    end
    return class, spec, spec_id
end

function oq.get_role()
    local class, spec, spec_id = oq.get_spec()
    if (spec == nil) then
        return 'None'
    end
    if (OQ.CLASS_SPEC[spec_id]) then
        return OQ.CLASS_SPEC[spec_id].spy
    end
    return 'None'
    --   return OQ.BG_ROLES[ class ][ spec ] or "None" ;
end

function oq.get_player_role()
    local role = oq.get_role()
    local role_id = 1
    -- 1  dps
    -- 2  healer
    -- 3  none
    -- 4  tank
    if (role == 'Healer') then
        role_id = 2
    elseif (role == 'Tank') then
        role_id = 4
    end
    player_role = role_id
    return role_id
end

function oq.auto_set_role()
    if (oq.toon.auto_role == 0) or (InCombatLockdown()) or (my_group == 0) or (my_slot == 0) then
        return
    end

    local old_role = player_role
    oq.get_player_role()

    if (old_role ~= player_role) then
        -- insure UI update
        oq.set_role(my_group, my_slot, player_role)
        oq.set_textures(my_group, my_slot)
        oq.UnitSetRole('player', OQ.ROLES[player_role])
    end
end

function oq.battleground_spy(opt)
    if (opt == 'on') then
        OQ_data.announce_spy = 1
    elseif (opt == 'off') then
        OQ_data.announce_spy = 0
    end
    if (OQ_data.announce_spy == 0) then
        return
    end
    SetBattlefieldScoreFaction(nil)

    local numScores = GetNumBattlefieldScores()
    if (numScores <= 12) then
        -- call messed up or in an arena
        return
    end
    local numHorde = 0
    local numAlliance = 0
    local f = tbl.new()
    local p_faction = 0 -- 0 == horde, 1 == alliance, -1 == offline
    local e_faction = 1
    if (oq.get_bg_faction() == 'A') then
        p_faction = 1
        e_faction = 0
    end

    for i = 0, 1 do
        f[i] = tbl.new()
        f[i].num = 0
        f[i].roles = tbl.new()
        f[i].stealthies = 0
    end

    for i = 1, numScores do
        local name,
            killingBlows,
            honorableKills,
            deaths,
            honorGained,
            faction,
            race,
            class,
            classToken,
            damageDone,
            healingDone,
            bgRating,
            ratingChange,
            preMatchMMR,
            mmrChange,
            talentSpec = GetBattlefieldScore(i)
        if (faction) and (OQ.BG_ROLES[classToken] ~= nil) and (OQ.BG_ROLES[classToken][talentSpec] ~= nil) then
            f[faction].num = f[faction].num + 1
            if (classToken == 'DRUID') or (classToken == 'ROGUE') then
                f[faction].stealthies = f[faction].stealthies + 1
            end
            local role = OQ.BG_ROLES[classToken][talentSpec]
            if (role ~= nil) then
                f[faction].roles[role] = (f[faction].roles[role] or 0) + 1
            end
        end
    end
    local str = 'OQ BG-Spy:'
    if (f[e_faction].roles['Healer']) then
        str = str .. '  ' .. f[e_faction].roles['Healer'] .. ' Healers.'
    end
    if (f[e_faction].roles['Tank']) then
        str = str .. '  ' .. f[e_faction].roles['Tank'] .. ' Tanks.'
    end
    if (f[e_faction].roles['Melee']) then
        str = str .. '  ' .. f[e_faction].roles['Melee'] .. ' Melee.'
    end
    if (f[e_faction].roles['Ranged']) then
        str = str .. '  ' .. f[e_faction].roles['Ranged'] .. ' Ranged.'
    end
    if (f[e_faction].roles['Knockback']) then
        str = str .. '  ' .. f[e_faction].roles['Knockback'] .. ' Knockback.'
    end
    if (f[e_faction].stealthies > 0) then
        str = str .. '  ' .. f[e_faction].stealthies .. ' Stealthies.'
    end
    if (oq.iam_raid_leader() and _inside_bg) then
        oq.SendChatMessage(str, 'INSTANCE_CHAT')
    elseif (_inside_bg) then
        print(str)
    else
        print('OQ BG-Spy:  You are not in a battleground')
    end

    -- cleanup
    tbl.delete(f, true)
end

function oq.snitch(opt)
    if (opt) and ((opt == 'dump') or (opt == 'dumpall')) then
        oq.snitch_dump(opt)
        return
    end

    oq._snitch._report = true
    oq.snitch_init()
    oq.snitch_start_inspect(opt)
end

function oq.snitch_toggle_ui()
    local f = oq.snitch_ui_create()
    if (f == nil) then
        return
    end
    if (f:IsVisible()) then
        f:Hide()
    else
        f:Show()
    end
end

function oq.onSnitchHide(f)
    oq.tremove_value(getglobal('UISpecialFrames'), f:GetName())
    PlaySound('igCharacterInfoClose')
end

function oq.onSnitchShow(f)
    tinsert(getglobal('UISpecialFrames'), f:GetName())
    PlaySound('igCharacterInfoOpen')
end

function oq.create_snitch_button(parent, name)
    local x = floor(parent:GetWidth() - 140)
    local y = 8
    local cx = 34
    local cy = 34
    local b = CreateFrame('Button', name or 'OQSnitchButton', parent)
    b:SetFrameLevel(parent:GetFrameLevel() + 1)
    b:RegisterForClicks('anyUp')
    b:SetWidth(cx)
    b:SetHeight(cy)
    b:SetPoint('TOPLEFT', x, y)

    local pt = b:CreateTexture(nil, 'ARTWORK')
    pt:SetTexture('INTERFACE\\TARGETINGFRAME\\PetBadge-Critter.png')
    pt:SetAllPoints(b)
    b:SetPushedTexture(pt)

    local ct = b:CreateTexture()
    ct:SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
    ct:SetAllPoints(b)
    ct:SetBlendMode('ADD')
    ct:SetAlpha(0.5)
    ct:SetTexCoord(2 / 32, 29 / 32, 2 / 32, 28 / 32)
    b:SetHighlightTexture(ct)

    local icon = b:CreateTexture(nil, 'ARTWORK')
    icon:SetAllPoints(b)
    icon:SetTexture('INTERFACE\\TARGETINGFRAME\\PetBadge-Critter.png')
    b:SetNormalTexture(icon)

    b:SetScript(
        'OnClick',
        function()
            OQ_Snitch_Toggle()
        end
    )
    b:Show()
    return b
end

function OQ_SnitchScrollBar_Update(f)
    OQ_data._snitch = OQ_data._snitch or tbl.new()
    local nItems = max(10, table.getn(OQ_data._snitch))
    FauxScrollFrame_Update(f, nItems, 5, 25)
end

function oq.snitch_ui_create()
    oq.snitch_init()
    if (oq._snitch.ui) then
        return oq._snitch.ui
    end
    local d = oq.CreateFrame('FRAME', 'OQSnitchFrame', UIParent)
    oq.make_frame_moveable(d)
    d:SetScript(
        'OnShow',
        function(self)
            oq.onSnitchShow(self)
        end
    )
    d:SetScript(
        'OnHide',
        function(self)
            oq.onSnitchHide(self)
        end
    )

    if (oq.__backdrop01 == nil) then
        oq.__backdrop01 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    d:SetBackdrop(oq.__backdrop01)
    d:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    d:SetAlpha(1.0)

    oq.setpos(d, 500, 300, 354, 256)

    d.closepb =
        oq.closebox(
        d,
        function(self)
            self:GetParent():Hide()
        end
    )
    d.closepb:SetPoint('TOPRIGHT', d, 'TOPRIGHT', 0, -2)
    d._save_position = function(self)
        OQ_data.snitch_x = max(0, floor(self:GetLeft()))
        OQ_data.snitch_y = max(0, floor(self:GetTop()))
    end
    if (OQ_data.snitch_x or OQ_data.snitch_y) then
        d:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', OQ_data.snitch_x, OQ_data.snitch_y)
    end

    -- snitch icon, top left
    d._snitch_icon = oq.create_snitch_button(d, 'OQSnitchLogo')
    d._snitch_icon:SetPoint('TOPLEFT', -10, 10)
    d._snitch_icon:SetScript('OnClick', nil)

    -- title
    local x = 10
    local y = 10
    d.title = oq.label(d, x + 3, y + 2, 160, 25, L['The Snitch Report'], 'CENTER', 'CENTER')
    d.title:SetFont(OQ.FONT, 16, '')
    x = x + 160 + 5

    d.clear_but =
        oq.button(
        d,
        x,
        y + 2,
        50,
        25,
        L['clear'],
        function()
            oq.snitch_clear()
        end
    )
    x = x + 50 + 3
    d.start_but =
        oq.button(
        d,
        x,
        y + 2,
        50,
        25,
        L['start'],
        function()
            oq.snitch_start_inspect()
        end
    )
    x = x + 50 + 3
    d.stop_but =
        oq.button(
        d,
        x,
        y + 2,
        50,
        25,
        L['stop'],
        function()
            oq.snitch_stop()
        end
    )
    y = y + 30 + 5

    -- resize corner
    local but = oq.CreateFrame('BUTTON', 'OQSnitchResize', d)
    but:RegisterForDrag('LeftButton', 'RightButton')
    but:SetScript(
        'OnMouseDown',
        function(self)
            OQ_ResizeMouse_down(self)
        end
    )
    but:SetScript(
        'OnMouseUp',
        function(self)
            OQ_ResizeMouse_up(self)
        end
    )
    but:SetScript(
        'OnHide',
        function(self)
            self:GetParent():StopMovingOrSizing()
        end
    )
    but:SetNormalTexture('Interface\\AddOns\\oqueue-classic\\art\\resize')
    but:GetNormalTexture():SetVertexColor(0.6, 0.6, 0.6)
    but:SetWidth(16)
    but:SetHeight(16)
    but:SetPoint('BOTTOMRIGHT', d, 'BOTTOMRIGHT', -3, 1)

    d:SetResizable(true)
    d:SetMaxResize(900, 900)
    d:SetMinResize(360, 300)
    d:Hide() -- require caller to explicitly show it
    d:SetWidth(350)
    d:SetHeight(450)
    -- snitch layout
    d._scroller, d._list = oq.create_scrolling_list(d, 'snitchlist', 'SimpleHTML', OQ_SnitchScrollBar_Update)
    local f = d._scroller
    oq.setpos(f, 20, y, f:GetParent():GetWidth() - 2 * 30, f:GetParent():GetHeight() - (y + 38))

    d:SetScript(
        'OnSizeChanged',
        function(self)
            self._resize(self)
        end
    )

    d._fixui = function(self)
        d:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', 800, 500)
        d:SetWidth(360)
        d:SetHeight(300)
        self:_resize()
    end

    d._resize = function(self)
        local cx = floor(self:GetWidth())
        local cy = floor(self:GetHeight())
        self._scroller:ClearAllPoints()
        self._scroller:SetPoint('TOPLEFT', self, 'TOPLEFT', 10, -45)
        self._scroller:SetWidth(cx - 4 * 10)
        self._scroller:SetHeight((cy - 10) - 45)
        self._list:SetWidth(self._scroller:GetWidth())

        OQ_data.snitch_cx = cx
        OQ_data.snitch_cy = cy
    end

    -- tweak list
    d._list:SetBackdrop(nil) -- remove outline frame inside scrolling region
    d._list:SetFont(OQ.FONT, 12)
    d._list:SetWidth(d:GetWidth() - 2 * 10)
    d._list:SetHeight(1000)
    d._list:SetFont('h1', OQ.FONT_FIXED, 12)
    d._list:SetTextColor('h1', 0.9, 0.9, 0.9, 0.8)

    d._list:SetFont('h2', 'Fonts\\MORPHEUS.ttf', 40)
    d._list:SetShadowColor('h2', 0, 0, 0, 1)
    d._list:SetShadowOffset('h2', 1, -1)
    d._list:SetTextColor('h2', 128 / 255, 0 / 255, 0 / 255, 1.0)

    d._list:SetFont('h3', OQ.FONT, 10)
    d._list:SetShadowColor('h3', 0, 0, 0, 1)
    d._list:SetShadowOffset('h3', 0, 0)
    d._list:SetTextColor('h3', 0.2, 0.2, 0.2, 0.8)

    d._list:SetText('')

    if (OQ_data.snitch_x or OQ_data.snitch_y) then
        d:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', OQ_data.snitch_x or 100, OQ_data.snitch_y or 100)
    end
    if (OQ_data.snitch_cx or OQ_data.snitch_cy) then
        d:SetWidth(OQ_data.snitch_cx or 360)
        d:SetHeight(OQ_data.snitch_cy or 300)
    end
    d:_resize()

    -- done
    oq._snitch.ui = d
    oq.update_snitch_text()
    return oq._snitch.ui
end

function oq.snitch_init()
    oq._snitch = oq._snitch or tbl.new()
    oq._snitch.players = oq._snitch.players or tbl.new()
    tbl.clear(oq._snitch.players)
end

function oq.snitch_log(...)
    local now = oq.utc_time()
    OQ_data._snitch = OQ_data._snitch or tbl.new()
    tinsert(OQ_data._snitch, '|cFF00B000' .. date('%H:%M:%S', now) .. '|r  ' .. tostring(...))
    if (table.getn(OQ_data._snitch) > OQ.MAX_SNITCH_LINES) then
        local n = table.getn(OQ_data._snitch) - OQ.MAX_SNITCH_LINES

        for _ = 1, n do
            table.remove(OQ_data._snitch, 1)
        end
    end
    oq.update_snitch_text()
end

function oq.update_snitch_text()
    OQ_data._snitch = OQ_data._snitch or tbl.new()

    local d = oq._snitch.ui
    local txt = '<html><body><h1>'
    local n = table.getn(OQ_data._snitch)
    if (n > 0) then
        for i = 1, n do
            txt = txt .. OQ_data._snitch[i] .. '<br/>'
        end
    end

    if
        (oq._snitch.current) and (oq._snitch.players[oq._snitch.current]) and
            (type(oq._snitch.players[oq._snitch.current]) ~= 'number')
     then
        local now = oq.utc_time()
        txt =
            txt ..
            '|cFF00B000' ..
                date('%H:%M:%S', now) ..
                    '|r  ' ..
                        tostring(oq._snitch.current) .. ' ... ' .. tostring(oq._snitch.players[oq._snitch.current])
    end

    txt = txt .. '</h1><br/></body></html>'

    d._list:SetText(txt)
    d._list:SetHeight(25 * max(25, n))
    d._list:Show()
end

function oq.snitch_clear()
    oq.snitch_stop()
    tbl.clear(OQ_data._snitch)
    oq.snitch_log('--')
    oq.update_snitch_text()
end

function oq.snitch_stop()
    if (oq._snitch.status == 0) then
        return
    end
    oq._snitch.status = 0 -- 1 == active; 0 == completed
    oq._snitch.current = nil
    oq._snitch.giveup = 0
    oq.timer('snitch_check', 1, nil)
    oq.snitch_log('stopped')
end

function oq.snitch_start_inspect(opt)
    if (oq._snitch.status == 1) then
        return
    end
    oq._snitch.status = 0
    oq.snitch_log(L['starting'])
    oq._snitch.min_ilevel = tonumber(opt or 0) or 0
    local p = oq.premades[oq.raid.raid_token]
    if (oq._snitch.min_ilevel == 0) and (oq.raid.raid_token) then
        oq._snitch.min_ilevel = p.min_ilevel or 0
        if ((p.type == OQ.TYPE_DUNGEON) or (p.type == OQ.TYPE_RAID)) and (p.min_mmr > 0) then
            oq._snitch.min_ilevel = min(oq._snitch.min_ilevel, p.min_mmr)
        end
    end
    if (oq._snitch.min_ilevel <= 0) then
        oq.snitch_log(L['no minimum ilevel set'])
        oq.snitch_log('--')
        return
    end

    -- fill pending w/ group members
    local n = GetNumGroupMembers()
    if (n == 0) then
        oq.snitch_log(L['no members to snitch on'])
        oq.snitch_log('--')
        return
    end
    if (n > 0) then
        oq.snitch_log(tostring(GetZoneText() or L['Zone text unavailable']))

        for i = 1, n do
            local name, realm = oq.crack_name(string.lower(select(1, GetRaidRosterInfo(i)) or ''))
            -- tried caching the data by calling inspect on all.. didn't help
            --      NotifyInspect( oq.proper_name(name, realm) ) ;
            oq._snitch.players[name .. '-' .. realm] = 'pending'
        end
        oq.snitch_log('min ilevel: ' .. tostring(oq._snitch.min_ilevel))
    end
    oq._snitch.status = 1 -- 1 == active; 0 == completed
    oq._snitch.current = nil
    oq._snitch.giveup = 0

    oq.timer('snitch_check', 0.5, oq.snitch_check, true)
end

function oq.snitch_check()
    if (oq._snitch.current == nil) then
        oq._snitch.current = oq.snitch_next()
        if (oq._snitch.current == nil) then
            oq._snitch.status = nil
            oq.snitch_log('--')
            return 1 -- no more.  end timed function
        end
        oq._snitch.players[oq._snitch.current] = 'inspect' -- inspect stage
        oq._snitch.giveup = GetTime() + 5.0 -- wait no longer then 5 seconds before moving on
    end

    local proper_name = oq.proper_name(oq.crack_name(oq._snitch.current))
    if (not CanInspect(proper_name)) then
        oq._snitch.players[oq._snitch.current] = 'oor' -- out of range
        oq.snitch_log('OOR  ' .. tostring(oq._snitch.current))
        oq._snitch.current = nil -- go to next player
        oq.update_snitch_text()
        return
    end

    --
    -- in range, try to pull gear info
    --
    if (oq._snitch.players[oq._snitch.current] == 'inspect') then
        NotifyInspect(proper_name)
        oq._snitch.players[oq._snitch.current] = 'wait'
        oq.update_snitch_text()
        return
    elseif (oq._snitch.players[oq._snitch.current] == 'wait') then
        if (oq.snitch_info_missing(oq._snitch.current)) then
            if (oq._snitch.giveup < GetTime()) then
                oq._snitch.players[oq._snitch.current] = 'unk'
                oq.snitch_log('|cffffff80' .. 'UNK|r  ' .. tostring(oq._snitch.current))
                oq._snitch.current = nil -- go to next player
            else
                NotifyInspect(proper_name)
            end
            return
        end
        oq._snitch.players[oq._snitch.current] = 'ready'
    end

    --
    -- have gear info.  do check
    --
    local ilevel = oq.snitch_get_ilevel(oq._snitch.current)
    if (ilevel < oq._snitch.min_ilevel) then
        oq._snitch.players[oq._snitch.current] = tostring(ilevel)
        oq.snitch_log('|cffff8080' .. tostring(ilevel) .. '|r  ' .. tostring(oq._snitch.current))
    else
        oq._snitch.players[oq._snitch.current] = ilevel
        oq.snitch_log(tostring(ilevel) .. '  ' .. tostring(oq._snitch.current))
    end
    oq._snitch.current = nil -- go to next player
end

function oq.snitch_get_ilevel(unit)
    local proper_name = oq.proper_name(oq.crack_name(unit))
    local sum, cnt, ilevel, itemLink
    sum, cnt = 0, 0
    for i = 1, 19 do
        itemLink = GetInventoryItemLink(proper_name, i)
        if (itemLink) and (i ~= 4) and (i ~= 19) then -- not shirt or tabard
            ilevel = oq.get_actual_ilevel(itemLink)
            sum = (sum or 0) + ilevel
            cnt = (cnt or 0) + 1
        end
    end
    local avg_ilevel = 0
    if (cnt > 0) then
        avg_ilevel = floor(sum / cnt)
    end
    return avg_ilevel
end

function oq.proper_name(n, r)
    if (r == player_realm) then
        return n
    end
    return n .. '-' .. r
end

function oq.snitch_next()
    local proper_name
    for name, v in pairs(oq._snitch.players) do
        if (v == 'pending') then
            proper_name = oq.proper_name(oq.crack_name(name))
            if UnitExists(proper_name) and CanInspect(proper_name) then
                return name
            else
                oq._snitch.players[proper_name] = 'invalid'
            end
        end
    end
    return nil
end

function oq.snitch_info_missing(unit)
    local missing = nil
    for i = 1, 19 do
        if GetInventoryItemID(unit, i) and not GetInventoryItemLink(unit, i) then
            missing = true
        end
    end
    return missing
end

function oq.snitch_dump(opt)
    opt = opt or 'show'

    print('-- OQ snitch results --')

    for name, v in pairs(oq._snitch.players) do
        if (type(v) ~= 'number') then
            print('|cFFFF8080' .. tostring(v) .. '|r  ' .. tostring(name))
        elseif (opt == 'dumpall') then
            print(tostring(v) .. '  ' .. tostring(name))
        end
    end
    print('--')
end

function oq.calc_pkt_stats()
    if
        (not OQTabPage5:IsVisible()) or (oq.pkt_recv == nil) or (oq.pkt_processed == nil) or (oq.pkt_sent == nil) or
            (oq.send_q == nil)
     then
        return
    end
    oq.tab5._oq_pktrecv:SetText(string.format('%7.2f', oq.pkt_recv._aps))
    oq.tab5._oq_pktprocessed:SetText(string.format('%7.2f', oq.pkt_processed._aps))
    oq.tab5._oq_pktsent:SetText(string.format('%7.2f', oq.pkt_sent._aps))
    oq.tab5._oq_timedrift:SetText(oq.render_tm(OQ_data.sk_adjust))
    --  oq.tab5._oq_timedrift   :SetText( oq.render_tm( oq.gmt_diff_track:median() ) ) ;
    oq.tab5._oq_gmt:SetText(date('!%H:%M:%S %d-%b', oq.utc_time()))

    local nQueued = tbl.size(oq.send_q)
    if (nQueued > 20) then -- more then 1 sec of pkts in the queue
        oq.tab5._oq_send_queuesz:SetText(string.format('(|cFFFF3131%d|r)', nQueued))
    elseif (nQueued > 5) then
        oq.tab5._oq_send_queuesz:SetText(string.format('(|cFFFFD331%d|r)', nQueued))
    else
        oq.tab5._oq_send_queuesz:SetText('')
    end
end

function oq.check_bg_status()
    local instance, instanceType = IsInInstance()
    if (instance and (instanceType == 'pvp')) then
        if (not _inside_bg) then
            -- transition
            oq.entering_bg()
        end
    elseif (not instance and _inside_bg) then
        oq.leaving_bg()
    end
    if (instanceType ~= 'none') and (oq._inside_instance == nil) and (instance == 1) then
        OQ_data.nrage = 0
        oq._entered_alone = oq.iam_alone()
        oq._inside_instance = 1
        oq._instance_type = instanceType
        oq._instance_pts = 0
        oq._instance_header = nil
        oq._instance_tm = oq.utc_time()
        oq._instance_end_tm = 0
        oq._instance_duration = 0
        oq._boss_fight = nil
        oq._wiped = nil
        oq._instance_faction = nil
        if (not oq.iam_raid_leader()) then
            oq.timer_oneshot(5, oq.oqgeneral_leave)
        end
        if (oq._instance_type ~= 'pvp') then
            if
                (oq.raid.raid_token ~= nil and oq.raid.type == OQ.TYPE_RAID) or
                    (oq.raid.raid_token == nil and instanceType == 'raid')
             then
                if (oq._loot_rule_contract) then
                    oq._loot_rule_contract._method = 'unspecified'
                end
                oq.verify_loot_rules_acceptance()
            end
            oq.timer('wipe_check', 5.0, oq.check_for_wipe, true)
        end
        SetMapToCurrentZone() -- one-time call to set the map to the current zone
        oq.mark_currency()
        oq.timer_oneshot(2.0, oq.log_realm_name)
    end
    if (instance ~= 1) and (oq._inside_instance ~= nil) and (not UnitIsDeadOrGhost('player')) then
        oq._inside_instance = nil
        oq._entered_alone = nil
        oq._instance_faction = nil
        if (oq._instance_tm) and (oq._instance_tm > 0) then
            oq._instance_end_tm = oq.utc_time()
            oq._instance_duration = oq._instance_end_tm - oq._instance_tm
        end
        oq.timer_oneshot(5.0, oq.oqgeneral_join)
        oq.timer_oneshot(5.0, oq.check_currency)
        oq.timer_oneshot(3.0, oq.bg_cleanup)
    end
    oq.group_lead_bookkeeping()

    -- if ui close, make sure flag is set (for display and redisplaying map)
    if (not oq.ui:IsVisible()) then
        _ui_open = nil
    end
end

function oq.on_world_map_change()
    -- check map
    if (not _map_open) and (WorldMapFrame:IsVisible()) then
        _map_open = true
    elseif _map_open and not WorldMapFrame:IsVisible() then
        _map_open = nil
        -- map closing ... open the UI if it was open
        if (_ui_open) then
            oq.ui:Show()
        end
    end
end

function oq.report_premades()
    if (OQ_data.show_premade_ads == 0) then
        return
    end
    _announcePremades = true
end

function oq.announce_new_premade(name, name_change, raid_token)
    if (OQ_data.show_premade_ads == 0) or (oq._inside_instance) then
        return
    end
    if (not _announcePremades) then
        return
    end

    -- don't announce if interested in qualified or certain premade types
    if (raid_token ~= nil) then
        if (OQ_data.premade_filter_qualified == 1) and (not oq.qualified(raid_token)) then
            return
        end
        local p = oq.premades[raid_token]
        if (OQ_data.premade_filter_type ~= OQ.TYPE_NONE) and (p.type ~= OQ_data.premade_filter_type) then
            return
        end
        if not oq.pass_filter(p) then
            return
        end
    end

    local premade = oq.premades[raid_token]
    if (premade == nil) then
        return
    end

    local hlink = '|Hoqueue:' .. tostring(raid_token) .. '|h' .. OQ.DIAMOND_ICON
    local nShown, nPremades = oq.n_premades()
    local wtoken = ''
    if (name_change) then
        print(
            hlink ..
                '  ' .. string.format(OQ.PREMADE_NAMEUPD, nShown, premade.leader, name, premade.bgs) .. '|h' .. wtoken
        )
    else
        print(
            hlink .. '  ' .. string.format(OQ.NEW_PREMADE, nShown, premade.leader, name, premade.bgs) .. '|h' .. wtoken
        )
    end
    return 1
end

function oq.calc_player_stats()
    if ((my_group == 0) or (my_slot == 0)) then
        return
    end

    if (oq.enemy_is_same_faction() or oq.iam_alone()) then
        return
    end

    local s = oq.toon.stats['bg']
    if (IsRatedBattleground()) then
        s = oq.toon.stats['rbg']
    end

    -- function to hold player stat info
    -- bg name, time of start, hks, dmg, heals
    -- other player names and their stats
    local winner = GetBattlefieldWinner() -- nil, 0, 1, 255
    if (winner) then
        local p_faction = oq.get_bg_faction()
        if (p_faction == 'H') then
            p_faction = 0
        elseif (p_faction == 'A') then
            p_faction = 1
        end
        if (winner == p_faction) then
            s.nWins = s.nWins + 1
        elseif (winner ~= 255) then
            s.nLosses = s.nLosses + 1
        end
        if (winner ~= 255) then
            s.nGames = s.nGames + 1
        end
    end
end

function oq.get_bg_faction()
    if (oq._instance_faction) then
        return oq._instance_faction
    end
    local numScores = GetNumBattlefieldScores()
    local nMembers = 0
    local hks = 0
    local honor = 0

    for i = 1, numScores do
        local name,
            killingBlows,
            honorableKills,
            deaths,
            honorGained,
            faction,
            rank,
            race,
            class,
            filename,
            damageDone,
            healingDone = GetBattlefieldScore(i)
        if (faction and (faction == 0)) then
            faction = 'H'
        elseif (faction) then
            faction = 'A'
        end
        if (name == player_name) then
            oq._instance_faction = faction
            return faction
        end
    end
    return 'n'
end
function oq.calc_game_stats()
    if (not oq.iam_raid_leader()) then
        return
    end

    local s = OQ_data.leader['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = OQ_data.leader['rbg']
    end
    local winner = GetBattlefieldWinner() -- nil, 0, 1, 255
    if (winner) then
        local p_faction = oq.get_bg_faction()
        if (p_faction == 'H') then
            p_faction = 0
        elseif (p_faction == 'A') then
            p_faction = 1
        end
        if (winner == p_faction) then
            s.nWins = s.nWins + 1
        elseif (winner ~= 255) then
            s.nLosses = s.nLosses + 1
        end
        if (winner ~= 255) then
            s.nGames = s.nGames + 1
        end
    end

    if (IsRatedBattleground() == true) or (winner == nil) then
        -- rated BGs shouldn't impact stats
        return
    end

    -- clear faction
    SetBattlefieldScoreFaction(nil)
end

function oq.calc_game_report()
    if (not oq.iam_raid_leader() or oq.enemy_is_same_faction() or oq.iam_alone()) then
        return
    end
    -- go through the in-game scorecard
    -- clear faction
    SetBattlefieldScoreFaction(nil)
    local numScores = GetNumBattlefieldScores()
    local bg_winner = GetBattlefieldWinner()
    local scores = tbl.new()

    for i = 1, numScores do
        --    local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i);
        local name,
            killingBlows,
            honorableKills,
            deaths,
            honorGained,
            faction,
            race,
            class,
            classToken,
            damageDone,
            healingDone,
            bgRating,
            ratingChange,
            preMatchMMR,
            mmrChange,
            talentSpec = GetBattlefieldScore(i)
        if (name) then
            if (faction and (faction == 0)) then
                faction = 'H'
            elseif (faction) then
                faction = 'A'
            end
            local n = name
            if (n:find('-') == nil) then
                n = n .. '-' .. player_realm
            end
            scores[n] = tbl.new()
            scores[n].fact = faction
            scores[n].dmg = damageDone
            scores[n].heal = healingDone
        end
    end
    -- get winner
    if (bg_winner and (bg_winner == 0)) then
        bg_winner = 'H'
    elseif (bg_winner) then
        bg_winner = 'A'
    end

    oq.report_score(bg_winner, scores)

    -- clean up
    tbl.delete(scores, true)
end

function oq.enemy_is_same_faction()
    if (IsRatedBattleground() ~= true) then
        return nil
    end
    -- is rated bg.  must look at races in scorecard to determine if same faction
    SetBattlefieldScoreFaction(nil)

    local nplayers = GetNumBattlefieldScores()
    if (nplayers == 0) then
        -- not inside or the call failed
        return nil
    end
    local game_faction = nil -- the faction i played during the game
    local me = strlower(player_name)
    for i = 1, nplayers do
        local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class =
            GetBattlefieldScore(i)
        name = strlower(name)
        if (name) and (faction) and (name:find(me) ~= nil) then
            game_faction = faction
            break
        end
    end
    if (game_faction == nil) then
        -- unable to determine races
        return nil
    end

    -- now look for opposing faction and check race to determine whether or not factions actually match
    --
    for i = 1, nplayers do
        local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class =
            GetBattlefieldScore(i)
        if (faction) and (race) and (faction ~= game_faction) then
            -- opposing team member, check race
            if (OQ.FACTION[race]) and (OQ.FACTION[race] ~= 'X') then
                return (OQ.FACTION[race] == oq.player_faction)
            end
        end
    end
    -- unable to determine
    return nil
end

function oq.show_raw_numbers()
    if (oq._show_raw) then
        oq._show_raw = nil
        print(L['OQ: showing queue scale icons'])
    else
        oq._show_raw = 1
        print(L['OQ: showing raw queue times'])
    end
end

local ad = 0
function oq.get_ab_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Resources: 400/1600
    local points = txt:match('Resources: (%d+)')
    return points
end

function oq.get_av_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Reinforcements: 400
    local points = txt:match('Reinforcements: (%d+)')
    return points
end

function oq.get_bfg_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Resources: 400/2000
    local points = txt:match('Resources: (%d+)')
    return points
end

function oq.get_eots_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Bases: 3  Victory Points:  1600/2000
    local bases, points = txt:match('Bases: (%d+)  Victory Points: (%d+)')
    return points
end

function oq.get_ioc_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Reinforcements: 400
    local points = txt:match('Reinforcements: (%d+)')
    return points or ''
end

function oq.get_sota_text(txt)
    if (txt == nil) then
        return ''
    end
    -- time
    -- End of Round: 02:01
    local tm = txt:match('End of Round: (%d+:%d+)')
    if (tm == nil) or (tm == '') then
        return ''
    else
        return 'round (' .. tm .. ')'
    end
end

function oq.get_ssm_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Resources: 400/1600
    local points = txt:match('Resources: (%d+)')
    return points
end

function oq.get_tok_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Victory Points: 400/1600
    local points = txt:match('Victory Points: (%d+)')
    return points
end

function oq.get_tp_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Bases: 3  Victory Points:  1600/1600
    local points = txt:match('%d+')
    return points or ''
end

function oq.get_wsg_text(txt)
    if (txt == nil) then
        return ''
    end
    -- 0/3
    local points = txt:match('%d+')
    return points or ''
end

function oq.get_dwg_text(txt)
    if (txt == nil) then
        return ''
    end
    -- Bases: 3  Gold:  200/1600
    local bases, points = txt:match('Bases: (%d+)  Gold: (%d+)')
    return points or ''
end

function oq.get_ad_text()
    ad = ad + 1
    local zone = OQ.BG_SHORT_NAME[GetZoneText()]
    local bg = zone
    if (bg == nil) then
        bg = 'BG'
    end
    local aText = ''
    local hText = ''
    local line1 = ''
    if (AlwaysUpFrame1Text ~= nil) then
        line1 = AlwaysUpFrame1Text:GetText()
    end
    local line2 = ''
    if (AlwaysUpFrame2Text ~= nil) then
        line2 = AlwaysUpFrame2Text:GetText()
    end
    local tm = ''
    if (zone == 'AB') then
        aText = oq.get_ab_text(line1)
        hText = oq.get_ab_text(line2)
    elseif (zone == 'AV') then
        aText = oq.get_av_text(line1)
        hText = oq.get_av_text(line2)
    elseif (zone == 'BFG') then
        aText = oq.get_bfg_text(line1)
        hText = oq.get_bfg_text(line2)
    elseif (zone == 'EotS') then
        aText = oq.get_eots_text(line1)
        hText = oq.get_eots_text(line2)
    elseif (zone == 'IoC') then
        aText = oq.get_ioc_text(line1)
        hText = oq.get_ioc_text(line2)
    elseif (zone == 'SotA') then
        local line3 = ''
        if (AlwaysUpFrame3Text ~= nil) then
            line3 = AlwaysUpFrame3Text:GetText()
        end
        aText = oq.get_sota_text(line3)
    elseif (zone == 'SSM') then
        aText = oq.get_ssm_text(line1)
        hText = oq.get_ssm_text(line2)
    elseif (zone == 'ToK') then
        aText = oq.get_tok_text(line1)
        hText = oq.get_tok_text(line2)
    elseif (zone == 'TP') then
        tm = line1:match('Remaining: (%d+)')
        local line3 = AlwaysUpFrame3Text:GetText()
        aText = oq.get_tp_text(line2)
        hText = oq.get_tp_text(line3)
    elseif (zone == 'WSG') then
        tm = line1:match('Remaining: (%d+)')
        local line3 = AlwaysUpFrame3Text:GetText()
        aText = oq.get_wsg_text(line2)
        hText = oq.get_wsg_text(line3)
    elseif (zone == 'DWG') then
        aText = oq.get_dwg_text(line1)
        hText = oq.get_dwg_text(line2)
    else
        return ''
    end

    local p_faction = oq.get_bg_faction()
    if (zone == 'SotA') then
        bg = bg .. ': ' .. aText
    elseif (zone == 'TP') or (zone == 'WSG') then
        if (p_faction == 'A') then
            bg = bg .. ': ' .. aText .. ' - ' .. hText
        else
            bg = bg .. ': ' .. hText .. ' - ' .. aText
        end
        bg = bg .. ' (' .. tm .. ' min)'
    else
        if (p_faction == 'A') then
            bg = bg .. ': ' .. (aText or '') .. ' - ' .. (hText or '')
        else
            bg = bg .. ': ' .. (hText or '') .. ' - ' .. (aText or '')
        end
    end

    return bg
end

function oq.init_stats_element(s)
    s.nWins = 0
    s.nLosses = 0
    s.nGames = 0
    s.start_tm = 0 -- time() when this raid was created
    s.bg_start = 0 -- place holder - time() of bg start
    s.bg_end = 0 -- place holder - time() of bg end
    s.bg_length = 0
    s.tm = 0 -- time of last update from source.  able to know which data is the latest
end

function oq.init_stats_data()
    if (OQ_data.stats == nil) then
        OQ_data.stats = {bg_length = 0, bg_end = 0, bg_start = 0}
    end
    if (OQ_data.leader == nil) then
        OQ_data.leader = {
            ['bg'] = tbl.new(),
            ['rbg'] = tbl.new()
        }
        oq.init_stats_element(OQ_data.leader['bg'])
        oq.init_stats_element(OQ_data.leader['rbg'])
        -- copy over old data
        OQ_data.leader['bg'].nWins = OQ_data.stats.nWins or 0
        OQ_data.leader['bg'].nLosses = OQ_data.stats.nLosses or 0
        OQ_data.leader['bg'].nGames = OQ_data.stats.nGames or 0
    end
    if (oq.toon.stats == nil) then
        oq.toon.stats = {
            ['bg'] = {nWins = 0, nLosses = 0, nGames = 0},
            ['rbg'] = {nWins = 0, nLosses = 0, nGames = 0}
        }
        oq.toon.stats['bg'].nWins = oq.toon.wins or 0
        oq.toon.stats['bg'].nLosses = oq.toon.losses or 0
        oq.toon.stats['bg'].nGames = (oq.toon.stats['bg'].nWins + oq.toon.stats['bg'].nLosses)
    end
    OQ_data.tear_cup = OQ_data.tear_cup or tbl.new()
    if (oq.toon.stats['bg'].nTears) and (oq.toon.stats['bg'].nTears > 0) and (oq.total_tears() == 0) then
        oq.new_tears(oq.toon.stats['bg'].nTears)
        oq.toon.stats['bg'].nTears = nil
    end
    if (OQ_data.tear_count) and (OQ_data.tear_count > 0) and (oq.total_tears() == 0) then
        oq.new_tears(min(3000, OQ_data.tear_count)) -- a bug existed where tears dupped; trimming to 3k
        OQ_data.tear_count = nil
    end
    OQ_data.stats.tears = nil -- old value no longer used

    local s = OQ_data.leader['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = OQ_data.leader['rbg']
    end
    return s
end

function oq.send_my_premade_info()
    if ((not oq.iam_raid_leader()) or oq.toon.disabled) then
        return
    end

    -- announce new raid on main channel
    local nMembers, avg_resil, avg_ilevel, nWaiting, min_ilvl = oq.calc_raid_stats()
    local now = oq.utc_time()

    oq.raid.pdata = oq.get_pdata(oq.raid.type, oq.raid.subtype)
    oq.raid.leader_xp = oq.get_leader_experience()

    local s = oq.init_stats_data()

    s.status = 0
    if (_inside_bg) then
        s.status = 2
    elseif (player_queued) then
        s.status = 1
    end

    player_realm = player_realm or oq.GetRealmName()

    local raid = oq.premades[oq.raid.raid_token] or oq.raid
    if ((raid) and (raid.next_advert > now) and ((raid.next_advert - now) < 5)) then
        return
    end

    local enc_data = oq.encode_data('abc123', player_name, player_realm, oq.player_realid)
    if (raid) then
        raid.nMembers = OQ_data.nMembers or 0
        raid.nWaiting = OQ_data.nWaiting or 0
        raid.status = OQ_data.status or 0
    end
    oq._my_group = 1
    oq.process_premade_info(
        oq.raid.raid_token,
        oq.encode_name(oq.raid.name),
        oq.raid.faction,
        oq.raid.level_range,
        oq.raid.min_ilevel,
        oq.raid.min_resil,
        oq.raid.min_mmr,
        enc_data,
        oq.encode_bg(oq.raid.bgs),
        nMembers,
        1,
        now,
        s.status,
        nWaiting,
        oq.raid.has_pword,
        oq.raid.is_realm_specific,
        oq.raid.type,
        oq.raid.subtype,
        oq.raid.pdata,
        oq.raid.leader_xp,
        player_karma,
        oq.raid._preferences,
        OQ_BUILD
    )
    oq._my_group = nil

    if (raid == nil) and (oq.premades[oq.raid.raid_token]) then
        -- would have just been created, ok2send
        raid = oq.premades[oq.raid.raid_token]
        raid.nMembers = OQ_data.nMembers or 0
        raid.nWaiting = OQ_data.nWaiting or 0
        raid.status = OQ_data.status or 0
    end

    -- if (raid) and ((raid.type == OQ.TYPE_DUNGEON) or (raid.type == OQ.TYPE_RAID)) then
    --     raid.min_mmr = min_ilvl
    --     oq.raid.min_mmr = min_ilvl
    --     oq.debug(true, min_ilvl)
    -- end

    player_realm = player_realm or oq.GetRealmName()
    raid.leader = player_name
    raid.leader_realm = player_realm
    raid.leader_rid = oq.player_realid
    raid.level_range = oq.raid.level_range
    raid.last_seen = now
    raid.next_advert = now + OQ_SEC_BETWEEN_PROMO

    local ad_text = nil
    if (_inside_bg) then
        ad_text = oq.get_ad_text()
    else
        ad_text = oq.raid.bgs
    end

    local stat = s.status or 0
    if _inside_bg then
        stat = 2
    end

    local is_realm_specific = nil
    local is_source = 1

    -- on_premade
    local msg =
        'p8,' ..
        oq.raid.raid_token ..
            ',' ..
                oq.encode_name(oq.raid.name) ..
                    ',' ..
                        oq.encode_premade_info(
                            oq.raid.raid_token,
                            stat,
                            now,
                            oq.raid.has_pword,
                            is_realm_specific,
                            is_source,
                            player_karma,
                            min_ilvl
                        ) ..
                            ',' ..
                                enc_data ..
                                    ',' ..
                                        oq.encode_bg(ad_text) ..
                                            ',' ..
                                                oq.raid.type ..
                                                    ',' ..
                                                        oq.raid.pdata ..
                                                            ',' ..
                                                                oq.get_leader_experience() ..
                                                                    ',' ..
                                                                        oq.encode_mime64_1digit(oq.raid.subtype) ..
                                                                            ',' .. oq.raid._preferences
    if (oq.__my_last_ad == msg) then
        return
    end
    oq.__my_last_ad = msg -- to avoid resending too often

    oq.__premade_msg = 1
    _inc_channel = nil
    oq.announce(msg)
    oq.__premade_msg = nil

    if (_oqgeneral_lockdown) then
        local is_restricted = _oqgeneral_lockdown
        _oqgeneral_lockdown = nil -- this allows the group leader to advertise on their own realm
        oq.SendOQChannelMessage(msg)
        _oqgeneral_lockdown = is_restricted
    end
end

function oq.advertise_my_raid()
    if ((not oq.iam_raid_leader()) or (oq.raid.raid_token == nil)) then
        return
    end
    oq._ad_ticker = (oq._ad_ticker or 0) + 1
    if ((oq._ad_ticker % 2) == 0) then
        if (not _inside_bg) and (not oq._inside_instance) then
            -- this will produce premade ads every 30 seconds when not in a bg and every 15 seconds when inside
            return
        end
    end

    if (not _inside_bg) then
        -- send the raid token to everyone in the party
        oq.party_announce('party_update,' .. oq.raid.raid_token)
    end
    -- even if inside a bg, the leader will continue to send premade info
    oq.send_my_premade_info()
end

function oq.on_charm(raid_token, g_id, slot, icon)
    if (raid_token == nil) or (raid_token ~= oq.raid.raid_token) then
        return
    end
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    icon = tonumber(icon or 0) or 0
    oq.set_charm(g_id, slot, icon)
    oq.set_textures(g_id, slot)
end

function oq.leader_set_charm(g_id, slot, icon)
    if (not oq.iam_raid_leader()) then
        return
    end
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    icon = tonumber(icon or 0) or 0
    oq.raid_announce(
        'charm,' .. oq.raid.raid_token .. ',' .. tostring(g_id) .. ',' .. tostring(slot) .. ',' .. tostring(icon)
    )
    oq.set_charm(g_id, slot, icon)
    oq.set_textures(g_id, slot)
end

function oq.group_charm_clear(g_id)
    g_id = tonumber(g_id)

    for i = 1, 5 do
        oq.raid.group[g_id].member[i].charm = 0
        oq.raid.group[g_id].member[i].check = OQ.FLAG_CLEAR
    end
end

function oq.set_charm(g_id, slot, icon)
    if (icon > 0) then
        for i = 1, 8 do
            if (oq.raid.group[i]) then
                for j = 1, 5 do
                    if (oq.raid.group[i].member) then
                        local m = oq.raid.group[i].member[j]
                        if (m) and (m.name) and (m.name ~= '-') and (m.name ~= '') and (m.charm == icon) then
                            m.charm = 0
                            oq.set_textures(i, j)
                        end
                    end
                end
            end
        end
    end
    oq.raid.group[g_id].member[slot].charm = icon

    -- set the charm if currently in the bg
    if (g_id == my_group) and (slot == my_slot) then
        SetRaidTarget('player', icon)
    end
    if (oq.IsRaidLeader()) then
        local m = oq.raid.group[g_id].member[slot]
        if (m.name == player_name) then
            SetRaidTarget('player', icon)
        else
            local n = m.name
            if (m.realm) and (m.realm ~= player_realm) then
                n = n .. '-' .. m.realm
            end
            if (n) then
                SetRaidTarget(n, icon)
            end
        end
    end
end

function oq.numeric_sanity(n)
    if (n == nil) or (n == '') or (tostring(n) == '-1.#IND') then
        return 0
    end
    return tonumber(n or 0) or 0
end

function oq.nActiveGroups()
    if (oq.raid.type ~= OQ.TYPE_BG) then
        return 1
    end
    local n = 0
    for i = 1, 8 do
        if (oq.raid.group[i].member[1].realid ~= nil) then
            n = n + 1
        end
    end
    return n
end

function oq.show_raid()
    print('raid_name: ' .. tostring(oq.raid.name) .. '  token(' .. tostring(oq.raid.raid_token) .. ')')
    print(
        'leader: ' ..
            tostring(oq.raid.leader) ..
                '-' .. tostring(oq.raid.leader_realm) .. '  btag(' .. tostring(oq.raid.leader_rid) .. ')'
    )

    for i = 1, 8 do
        local str = ' ' .. tostring(i) .. '. '
        if (oq.raid.group[i]) then
            local g = oq.raid.group[i]
            if (g.member) then
                for j = 1, 5 do
                    local m = g.member[j]
                    if (m) then
                        if (m.name) then
                            str =
                                str ..
                                '(' ..
                                    tostring(j) ..
                                        ': ' ..
                                            tostring(OQ.SHORT_RACE[m.race or 0]) ..
                                                '.' ..
                                                    tostring(m.class) ..
                                                        '.' ..
                                                            tostring(m.name) ..
                                                                '-' ..
                                                                    tostring(m.realm_id) ..
                                                                        '^' .. tostring(m.realid) .. ') '
                        else
                            str = str .. '(' .. tostring(j) .. ': .) '
                        end
                    else
                        str = str .. '(' .. tostring(j) .. ': nil) '
                    end
                end
            else
                str = str .. '  nil+'
            end
        else
            str = str .. '  nil'
        end
        print(str)
    end
    print('--')
end

function oq.push_initial_raid_info()
    if (oq.raid.raid_token) and (oq.raid.raid_token ~= '') then
        local enc_data = oq.encode_data('abc123', oq.raid.leader, oq.raid.leader_realm, oq.raid.leader_rid)
        local tm = oq.utc_time() - 90 -- must back it up so the last premade msg will be processed
        oq.process_premade_info(
            oq.raid.raid_token,
            oq.encode_name(oq.raid.name),
            oq.player_faction,
            oq.raid.level_range,
            oq.raid.min_ilevel,
            oq.raid.min_resil,
            oq.raid.min_mmr,
            enc_data,
            oq.encode_bg(oq.raid.bgs),
            1,
            1,
            tm,
            0,
            0,
            oq.raid.has_pword,
            oq.raid.is_realm_specific,
            oq.raid.type,
            oq.raid.subtype,
            oq.raid.pdata,
            oq.raid.leader_xp,
            player_karma,
            oq.raid._preferences,
            OQ_BUILD
        )
    end
end

function oq.raid_create()
    if (oq.raid.raid_token ~= nil) then
        print(OQ.STILL_IN_PREMADE)
        return
    end
    -- check information to make sure it's all filled in

    -- generate token
    oq.raid.raid_token = 'G' .. oq.token_gen()
    if (not oq.valid_rid(oq.player_realid)) then
        message(OQ.BAD_REALID .. ' ' .. tostring(oq.player_realid))
        return
    end

    if (player_level < 10) then
        message(OQ.MSG_CANNOTCREATE_TOOLOW)
    --    return ;
    end

    player_realm = player_realm or oq.GetRealmName()

    -- set raid info
    my_group = 1
    my_slot = 1
    oq.raid.name = oq.rtrim(oq.tab3_raid_name:GetText())
    oq.raid.type = oq.tab3_radio_selected
    oq.raid.subtype = OQ_data._premade_subtype
    oq.raid.leader = player_name
    oq.raid.leader_class = player_class
    oq.raid.leader_realm = player_realm
    oq.raid.leader_rid = oq.player_realid
    oq.raid.level_range = oq.tab3_level_range
    oq.raid.faction = oq.player_faction
    oq.raid.min_ilevel = oq.numeric_sanity(oq.tab3_min_ilevel:GetText())
    oq.raid.min_resil = oq.numeric_sanity(oq.tab3_min_resil:GetText())
    oq.raid.min_mmr = oq.numeric_sanity(oq.tab3_min_mmr:GetText())
    oq.raid.notes = (oq.tab3_notes.str or '')
    oq.raid.bgs = string.gsub(oq.tab3_bgs:GetText() or '.', ',', ';')
    oq.raid.pword = oq.tab3_pword:GetText() or ''
    oq.raid.leader_xp = oq.get_leader_experience()
    oq.raid.next_advert = 0
    oq.raid.oq_ver = OQ_BUILD

    local m = tbl.new()
    m.level = player_level
    m.faction = oq.player_faction
    m.resil = oq.get_resil()
    m.ilevel = oq.get_ilevel()
    m.spec_type = player_role
    m.mmr = oq.get_best_mmr(oq.raid.type)
    --  m.arena2s   = oq.get_arena_rating(1),
    --  m.arena3s   = oq.get_arena_rating(2),
    --  m.arena5s   = oq.get_arena_rating(3),
    --  m.mmr       = oq.get_mmr()

    if (oq.is_qualified(m) == nil) then
        oq.raid_cleanup()
        StaticPopup_Show('OQ_DoNotQualifyPremade')
        tbl.delete(m)
        return
    end
    m = tbl.delete(m) -- cleanup

    if (oq.raid == nil) or (oq.raid.type == nil) then
        oq.set_premade_type(OQ.TYPE_BG)
    else
        oq.set_premade_type(oq.raid.type)
    end

    if (oq.raid.pword == nil) or (oq.raid.pword == '') then
        oq.raid.has_pword = nil
    else
        oq.raid.has_pword = true
    end

    local s = oq.init_stats_data()

    oq.raid.notes = oq.raid.notes or ''
    oq.raid.bgs = oq.raid.bgs or ''

    local voip_ = oq.get_preference('voip')
    local role_ = oq.get_preference('role')
    local lang_ = oq.get_preference('lang')
    local class_ = oq.get_preference('class')
    oq.raid._preferences = oq.encode_preferences(voip_, role_, class_, lang_)

    local enc_data = oq.encode_data('abc123', oq.raid.leader, oq.raid.leader_realm, oq.raid.leader_rid)

    oq.log(nil, '|cFF808080created group:|r ' .. tostring(oq.raid.name) .. '')

    -- enable premade leader only controls
    oq.ui_raidleader()

    oq.set_group_lead(1, player_name, player_realm, player_class, oq.player_realid)
    oq.raid.group[1].member[1].resil = player_resil
    oq.raid.group[1].member[1].ilevel = player_ilevel
    oq.raid.group[1].member[1].level = player_level

    -- push it locally
    oq.process_premade_info(
        oq.raid.raid_token,
        oq.raid.name,
        oq.player_faction,
        oq.raid.level_range,
        oq.raid.min_ilevel,
        oq.raid.min_resil,
        oq.raid.min_mmr,
        enc_data,
        oq.raid.bgs,
        1,
        1,
        oq.utc_time(),
        0,
        0,
        oq.raid.has_pword,
        oq.raid.is_realm_specific,
        oq.raid.type,
        oq.raid.subtype,
        oq.raid.pdata,
        oq.raid.leader_xp,
        player_karma,
        oq.raid._preferences,
        oq.raid.oq_ver
    )

    -- update tab_1
    oq.update_tab1_common()
    oq.update_tab1_stats()
    oq.check_for_deserter()
    oq.timer('announce_leader', 4, oq.announce_raid_leader)

    -- remove myself from other waitlists
    oq.clear_pending()

    -- assign slots to the party members
    oq.brief_player() -- will announce group info to all current members

    -- activate in-raid only procs
    oq.procs_join_raid()

    -- tell the world
    oq._ad_ticker = 0
    oq.advertise_my_raid()
    oq.mini_count_update(0)
    return 1
end

function oq.bnbackflow(msg, to_pid)
    -- ie: "OQ,0A,P477389297,G17613410,name,1,3,Tinymasher,Magtheridon"
    local tok = msg:sub(7, 16)
    if (_msg_token ~= tok) then
        return nil
    end
    return true
end

function oq.bn_ok2send(msg, pid)
    if (oq.bnbackflow(msg, pid)) then
        return nil
    end

    for _, v in pairs(OQ_data.bn_friends) do
        if ((v.toon_id == pid) and v.isOnline and v.oq_enabled and (v.faction == oq.player_faction)) then
            return true
        end
    end
    return nil
end

function oq.BNSendQ_push(func_, pid_, msg_, name_, realm_)
    if (pid_ == 0) or (msg_ == nil) or (oq.toon.disabled) then
        return
    end
    local now = GetTime()
    oq.send_q = oq.send_q or tbl.new()

    if (pid_ ~= OQ_HEADER) and (msg_:find('oq_user') == nil) then
        oq._bundles = oq._bundles or tbl.new()
        oq._bundles[pid_] = oq._bundles[pid_] or tbl.new()
        local t = oq._bundles[pid_]

        if (t.msg) and ((OQ.MAX_BNET_MSG_SZ - #t.msg) < 255) then
            -- bundle full.  cut it lose, set it to be deleted and create a new one for overflow
            t.ok2delete = 1 -- must already be queue'd up.  pop will delete it
            oq._bundles[pid_] = tbl.new()
            t = oq._bundles[pid_]
            return
        end

        --
        -- i know the function is the same for all non-'OQ' pids
        --
        t.func = func_
        t.pid = pid_
        t.name = name_
        t.realm = realm_
        t.cnt = (t.cnt or 0) + 1

        local was_new = (t.msg == nil)
        if (t.msg == nil) then
            t.msg =
                'OQ,' ..
                OQ_BUILD_STR ..
                    ',' ..
                        'W1,' ..
                            '1,' .. -- OQ_TTL ..",".. (only one hop... to the specified target)
                                'b9,' ..
                                    player_name ..
                                        ',' ..
                                            player_realm_id ..
                                                ',' ..
                                                    oq.player_faction ..
                                                        ',' ..
                                                            oq.player_realid .. ',' .. oq.encode_mime64_5digit(now or 0)
        end

        t.msg = t.msg .. '|' .. msg_

        if (was_new) then
            t.earliest_ts = now + OQ.BUNDLE_EARLIEST_SEND
            t.expire_ts = now + OQ.BUNDLE_EXPIRATION
            tbl.push(oq.send_q, t)
        end
        if ((OQ.MAX_BNET_MSG_SZ - #t.msg) < 255) then
            t.earliest_ts = now - 1 -- send now
        end
    else
        local t = tbl.new()
        t.func = func_
        t.pid = pid_
        t.msg = msg_
        t.name = name_
        t.realm = realm_
        t.earliest_ts = now - 1.0 -- looks better in debug
        t.expire_ts = now + OQ.BUNDLE_EXPIRATION
        t.ok2delete = 1
        t.cnt = 1
        tbl.push(oq.send_q, t)
    end
end

function oq.BNSendQ_pop()
    if (oq.send_q == nil) then
        return
    end
    local now = GetTime()
    local t = nil
    local nQueued = tbl.size(oq.send_q)

    for i, v in pairs(oq.send_q) do
        if (v.msg) then
            if (now >= v.earliest_ts) and (now <= v.expire_ts) then
                -- found it
                t = v
                oq.send_q[i] = nil -- remove it from the queue
                break
            elseif (now > v.expire_ts) then
                if (v.ok2delete) then
                    oq.send_q[i] = tbl.delete(v) -- remove it from the queue
                else
                    tbl.clear(v)
                    oq.send_q[i] = nil -- remove it from the queue
                end
            end
        end
    end

    if (t == nil) then
        return
    end
    -- have an entry... process
    t.func(t.pid, t.msg, t.name, t.realm)

    -- recycle pkt holder
    if (t.ok2delete) then
        tbl.delete(t)
    else
        tbl.clear(t)
    end
end

function oq.send_queued_msgs()
    if (oq.send_q == nil) then
        return
    end
    local last_pkt_this_round = oq.pkt_sent._cnt + OQ.MAX_MSGS_PER_CYCLE -- called four times a second, 28 msgs/sec max
    local cnt = 0

    while (oq.pkt_sent._cnt < last_pkt_this_round) and (cnt < 10) do
        oq.BNSendQ_pop()
        cnt = cnt + 1
    end
end

function oq.get_field(m, fld)
    if (m == nil) or (fld == nil) then
        return nil
    end
    -- not found, leave
    local p1 = m:find(fld)
    if (p1 == nil) then
        return nil
    end

    -- find end, either the next ',' or eos
    local p2 = m:find(',', p1)
    if (p2 == nil) then
        p2 = -1
    else
        p2 = p2 - 1
    end
    return m:sub(p1 + #fld, p2)
end

-- takes name-realm and returns name,realm
-- if there is no realm, player_realm assumed
--
function oq.crack_name(n)
    if (n == nil) then
        return nil, nil
    end
    player_realm = player_realm or oq.GetRealmName()
    local name = n
    local realm = player_realm
    local p = n:find('-')
    if (p) then
        name = n:sub(1, p - 1)
        realm = n:sub(p + 1, -1)
    end
    return name, realm
end

function oq.is_number(s)
    if (s == nil) then
        return nil
    end
    if (type(s) == 'number') then
        return true
    end
    if (tonumber(s) ~= nil) then
        return true
    end
    return nil
end

function oq.space_it(s)
    local x = string.find(s:sub(2, -1), OQ.PATTERN_CAPS)
    if (x == nil) or (s:sub(x, x) == "'") then
        return s
    end
    return s:sub(1, x) .. ' ' .. s:sub(x + 1, -1)
end

function oq.IsRealmNameValid(realm)
    if (realm == nil) or (realm == '-') or (realm == 'nil') or (realm == 'n/a') or (realm == '') then
        return nil
    end

    return true
end

function oq.GetRealmID(realm)
    if (not oq.IsRealmNameValid(realm)) then
        return 0
    end

    if (oq.is_number(realm)) then
        return realm
    end
    if (OQ.REALMS[realm] ~= nil) then
        return OQ.REALMS[realm]
    end
    local r = realm

    if (OQ.REALMS[r] == nil) then
        -- for some reason, realms like "Bleeding Hollow" will come from blizz as "BleedingHollow".. sometimes
        r = oq.space_it(r)
        if (OQ.REALMS[r] == nil) then
            print(OQ.LILREDX_ICON .. ' unable to locate realm id.  realm[' .. tostring(realm) .. ']')
            print(OQ.LILREDX_ICON .. ' please report this to tiny on wow.publicvent.org : 4135')
            return 0
        end
    end

    return OQ.REALMS[r]
end

function oq.GetRealmNameFromID(realmId)
    if (not oq.IsRealmNameValid(realmId)) then
        return nil
    end

    if (oq.is_number(realmId)) then
        return OQ.REALMS[tonumber(realmId)]
    end

    return nil
end

function oq.crack_bn_msg(msg)
    local p = msg:find(',' .. OQ_FLD_TO)
    if (p == nil) then
        return msg, nil, nil, nil
    end

    local m, name, realm, from
    m = msg:sub(1, p - 1)
    name = oq.get_field(msg, OQ_FLD_TO)
    realm = oq.get_field(msg, OQ_FLD_REALM)
    realm = oq.GetRealmNameFromID(realm)
    from = oq.get_field(msg, OQ_FLD_FROM)

    local from_name, from_realm = oq.crack_name(from)
    from_realm = oq.GetRealmNameFromID(from_realm)
    return m, name, realm, from
end

function oq.WhisperPartyLeader(msg)
    if ((my_group <= 0) or (oq.raid.group[my_group].member[1].name == nil) or (msg == nil)) then
        return
    end
    if ((oq.raid.leader == nil) or (oq.raid.leader_realm == nil)) then
        return
    end
    local lead = oq.raid.group[my_group].member[1]
    local name = lead.name
    if (lead.realm ~= player_realm) then
        name = name .. '-' .. lead.realm
    end

    -- TODO test whether XRealmWhisper or SendAddonMessage would be better
    -- oq.SendAddonMessage(OQ_HEADER, msg, "WHISPER", name)
    oq.XRealmWhisper(lead.name, lead.realm, msg)
    -- oq.XRealmWhisper(OQ_HEADER, msg, 'WHISPER', name)
end

function oq.WhisperRaidLeader(msg)
    if (msg == nil or oq.raid.leader == nil or oq.raid.leader_realm == nil) then
        return
    end

    oq.XRealmWhisper(oq.raid.leader, oq.raid.leader_realm, msg)
end

function oq.send_invite_accept(raid_token, group_id, slot, _, class, _, _, req_token)
    -- the 'W' stands for 'whisper' and should not be echo'd far and wide
    local msg_tok = 'W' .. oq.token_gen()
    oq.token_push(msg_tok)

    local enc_data = oq.encode_data('abc123', player_name, player_realm, oq.player_realid)
    local m =
        'OQ,' ..
        OQ_BUILD_STR ..
            ',' ..
                msg_tok ..
                    ',' ..
                        OQ_TTL ..
                            ',' ..
                                'invite_accepted,' ..
                                    raid_token ..
                                        ',' ..
                                            group_id ..
                                                ',' .. slot .. ',' .. class .. ',' .. enc_data .. ',' .. req_token

    oq.WhisperRaidLeader(m)
end

local _auras = nil
function oq.check_for_deserter()
    _auras = _auras or tbl.new()
    if (oq._spellname_deserter == nil) then
        oq._spellname_deserter = GetSpellInfo(26013)
    end
    tbl.fill(_auras, UnitAura('player', oq._spellname_deserter, nil, 'PLAYER|HARMFUL'))
    if (player_deserter and (_auras[1] == nil)) then
        player_deserter = nil
        oq.set_status(my_group, my_slot, player_deserter, player_queued, player_online)
    elseif (not player_deserter and (_auras[1] ~= nil)) then
        player_deserter = true
        oq.set_status(my_group, my_slot, player_deserter, player_queued, player_online)
    end
    return player_deserter
end

function oq.check_my_role(changedPlayer, _, _, newRole)
    if (changedPlayer == player_name) then
        local role = OQ.ROLES[newRole]
        if (role ~= player_role) then
            player_role = role
        end
        -- insure UI update
        oq.set_role(my_group, my_slot, role)
        oq.set_textures(my_group, my_slot)
    end
end

function oq.brief_player()
    if (not oq.iam_raid_leader()) then
        return
    end
    local enc_data = oq.encode_data('abc123', oq.raid.leader, oq.raid.leader_realm, oq.raid.leader_rid)
    oq.party_announce(
        'party_join,' ..
            '1' ..
                ',' .. -- gets ignored now
                    oq.encode_name(oq.raid.name) ..
                        ',' ..
                            oq.raid.leader_class ..
                                ',' ..
                                    enc_data ..
                                        ',' ..
                                            oq.raid.raid_token ..
                                                ',' .. oq.encode_note(oq.raid.notes) .. ',' .. tostring(oq.raid.type)
    )

    oq.send_premade_note(true)
end

function oq.set_member_stats_offline(m)
    if (m == nil) or (m.stats == nil) then
        return
    end
    --  m.flags must set to 0 for offline
    m.stats = m.stats:sub(1, 6) .. 'A' .. m.stats:sub(8, -1)
end

function oq.find_group_member(name)
    if (not oq.iam_party_leader() or (my_group == 0) or (my_slot ~= 1) or _inside_bg) then
        return
    end

    for i = 2, 5 do
        -- check the members of my party to see if they are online
        local m = oq.raid.group[my_group].member[i]
        if (m.name and (m.name == name)) then
            return m
        end
    end
    return nil
end

function oq.IsFriend(realId)
    if (realId == nil) then
        return nil, nil
    end

    realId = strlower(realId)
    local total = GetNumFriends()

    for i = 1, total do
        local friendName, _, _, _, isOnline = GetFriendInfo(i)

        if (friendName and realId == strlower(friendName)) then
            return true, isOnline
        end
    end

    return nil, nil
end

function oq.get_nConnections()
    -- update the label on tab 5
    local nlocals = oq.n_channel_members(OQ_REALM_CHANNEL)
    if (nlocals > 0) then
        nlocals = nlocals - 1 -- subtract player
    end
    local ntotal, nonline = GetNumFriends()
    return nlocals, ntotal
end

function oq.n_connections()
    local nOQlocals, nOQfriends = 0
    if (oq.loaded) and (oq.tab2._connection) then
        oq.tab2._connection:SetText(string.format(OQ.CONNECTIONS, nOQlocals, nOQfriends))
    end
end

function oq.bnpresence(name)
    local v = OQ_data.bn_friends[strlower(name)]
    if (v) then
        if (not v.isOnline) or ((not v.oq_enabled) and (not v.sk_enabled)) then
            return 0
        else
            return v.toon_id or 0
        end
    end
    return 0
end

function oq.mbsync_toons(to_name)
    for _, friend in pairs(OQ_data.bn_friends) do
        if ((friend.toon_id ~= 0) and friend.isOnline and friend.oq_enabled) then
            local m =
                'OQ,' ..
                OQ_BUILD_STR ..
                ',' ..
                'W1,' ..
                OQ_TTL ..
                ',' ..
                'mbox_bn_enable,' ..
                friend.toonName ..
                ',' .. tostring(oq.GetRealmID(friend.realm)) .. ',' .. tostring(1)
            oq.XRealmWhisper(to_name, player_realm, m)
        end
    end
end

function oq.mbsync_single(toonName, toonRealm  )
    for _, v in pairs(oq.toon.my_toons) do
        local m =
            'OQ,' ..
            OQ_BUILD_STR ..
                ',' ..
                    'W1,' ..
                        OQ_TTL ..
                            ',' ..
                                'mbox_bn_enable,' ..
                                    toonName .. ',' .. tostring(oq.GetRealmID(toonRealm)) .. ',' .. tostring(1)
        oq.XRealmWhisper(v.name, player_realm, m)
    end
end

function oq.mbsync()
    for _, v in pairs(oq.toon.my_toons) do
        oq.mbsync_toons(v.name)
    end
end

function oq.on_mbox_bn_enable(name, realm, is_enabled)
    if (is_enabled == '0') then
        is_enabled = nil
    else
        is_enabled = true
    end
    realm = oq.GetRealmNameFromID(realm)
    local name_ndx = strlower(name .. '-' .. realm)
    local friend = OQ_data.bn_friends[name_ndx]
    if (friend == nil) then
        OQ_data.bn_friends[name_ndx] = tbl.new()
        friend = OQ_data.bn_friends[name_ndx]
        friend.isOnline = nil
        friend.toonName = name
        friend.realm = realm
        friend.pid = 0
        friend.toon_id = 0
        return
    end
    friend.oq_enabled = is_enabled
end

-- returns first pid of a toon on the desired realm
function oq.bnpresence_realm(realm)
    if (realm == nil) then
        return nil
    end

    for _, v in pairs(OQ_data.bn_friends) do
        if (v.realm == realm) and (v.oq_enabled) and (v.isOnline) and (v.faction == oq.player_faction) then
            return v.pid
        end
    end
    return 0
end

function oq.bn_echo_msg(name, realm, msg)
    print(name .. '-' .. realm)
    local pid = oq.bnpresence(name .. '-' .. realm)
    if (pid == 0) then
        return
    end
    if (oq.bn_ok2send(msg, pid)) then
        oq.XRealmWhisper(name, realm, msg)
    end
end

function oq.bn_echo_raid(msg)
    if (oq.raid.raid_token == nil) then
        return
    end
    if (oq.raid.group) then
        for i = 1, 8 do
            if (oq.raid.group[i]) then
                for j = 1, 5 do
                    if (oq.raid.group[i].member) then
                        local m = oq.raid.group[i].member[j]
                        if (m) and (m.name) and (m.realm) and (m.realm ~= player_realm) then
                            oq.bn_echo_msg(m.name, m.realm, msg)
                        end
                    end
                end
            end
        end
    end
end

function oq.cmdline_clear(opt)
    if (opt == nil) then
        print(L['please specify clear option'])
    end
    if (opt == 'exclusions') then
        oq.clear_exclusions()
        return
    elseif (opt == 'height') then
        OQ_data._height = nil
        oq.frame_resize()
        return
    elseif (opt == 'premades') then
        oq.remove_all_premades()
        return
    elseif (opt == 'rowheight') then
        OQ_data._rowheight = nil
        oq.reshuffle_premades_now()
        return
    end
    print(string.format(L['unknown option (%s)'], tostring(opt)))
    print(L['  options: premades'])
end

function oq.invert_exclusions()
    for i, _ in pairs(OQ.voip_selections) do
        oq.set_voip_filter(i, true, true)
    end
    for i, _ in pairs(OQ.lang_selections) do
        oq.set_lang_filter(i, true, true)
    end
    for i, v in pairs(OQ.findpremade_types) do
        oq.on_premade_filter(i, v, true, true)
    end
    oq.tab2._filter._edit:SetText('')
end

function oq.clear_exclusions()
    if (OQ_data._voip_exclusion) then
        tbl.clear(OQ_data._voip_exclusion)
    end
    if (OQ_data._lang_exclusion) then
        tbl.clear(OQ_data._lang_exclusion)
    end
    if (OQ_data._premade_exclusion) then
        tbl.clear(OQ_data._premade_exclusion)
    end
    oq.set_voip_filter(OQ.VOIP_UNSPECIFIED)
    oq.set_lang_filter(OQ.LANG_UNSPECIFIED)

    -- premade sort
    OQ_data.premade_sort = 'lead'
    OQ_data.premade_sort_ascending = true

    -- premade types
    OQ_data.premade_filter_type = OQ.TYPE_NONE
    oq._filter:SetChecked(nil)
    oq.tab2._filter._edit:SetText(OQ.LABEL_ALL)
    -- spyglass
    oq.toggle_filter(nil)
    -- qualified
    oq.tab2._enforce:SetChecked(nil)
    OQ_data.premade_filter_qualified = 0
    -- make sure to unpress shift
    oq.toggle_raid_scroll(0)

    oq.reshuffle_premades_now()
end

function oq.show_premades(opt)
    local arg = nil
    if (opt) and (opt:find(' ')) then
        arg = strlower(opt:sub(opt:find(' ') + 1, -1))
    end
    if (arg) then
        print('--[ premades (' .. tostring(arg) .. ') ]--')
    else
        print('--[ premades ]--')
    end

    for _, r in pairs(oq.premades) do
        if (r) then
            if
                ((arg == nil) and (r._isvis)) or
                    ((arg ~= nil) and ((strlower(r.name):find(arg)) or (strlower(r.leader):find(arg))))
             then
                local s = ''
                if (r.leader == nil) then
                    s = '  **  nil leader'
                elseif (r.leader == 'nil') then
                    s = "  **  leader name is 'nil'"
                end
                if (r._row) then
                    s = ' |cFF20F020(ROW)|r ' .. s
                end
                print(
                    tostring(r.__y) ..
                    '  |cFF008080' ..
                    tostring(r.raid_token) ..
                    '|r |cFF808080' ..
                    tostring(r.leader) ..
                    '|r  [|cFFcccccc' .. tostring(r.name) .. '|r] [' .. tostring(r.bgs) .. ']' .. s
                )
            end
        end
    end
    print('--')
end

function oq.dead_token(name, noteText)
    if (noteText:find('OQ,G') == nil) then
        return nil
    end
    if (oq.raid.raid_token == nil) then
        return true
    end
    local token = noteText:sub(4, -1)
    if (token == oq.raid.raid_token) then
        if (oq.raid.type ~= OQ.TYPE_BG) or (not oq.iam_raid_leader()) then
            return true
        else
            return nil -- not dead yet
        end
    end
    return true -- dead token
end

function oq.is_enabled(toonName, realm)
    local n = strlower(toonName .. '-' .. realm)
    if (OQ_data.bn_friends[n] == nil) then
        return nil
    end
    return OQ_data.bn_friends[n].oq_enabled
end

function oq.bn_show_pending()
    if (oq.pending_invites == nil) then
        print('pending list is empty')
        oq.pending_invites = tbl.new()
    else
        print('pending ---')
        local cnt = 0

        for i, v in pairs(oq.pending_invites) do
            cnt = cnt + 1
            print(tostring(v.gid) .. '.' .. tostring(v.slot) .. ': ' .. i .. ' (' .. tostring(v.rid) .. ')')
        end
        print('--- total: ' .. tostring(cnt))
    end

    if (oq.waitlist == nil) then
        print('wait list is empty')
        oq.waitlist = tbl.new()
    else
        print('waiting ---')
        local cnt = 0

        for i, v in pairs(oq.waitlist) do
            cnt = cnt + 1
            print('[' .. i .. '] [' .. v.name .. '-' .. v.realm .. '] [' .. v.realid .. ']')
        end
        print('--- total: ' .. tostring(cnt))
    end

    if (OQ_data._pending_info) then
        print('waitlisted ---')
        local cnt = 0
        local r
        for i, _ in pairs(OQ_data._pending_info) do
            cnt = cnt + 1
            r = oq.premades[i]
            print(tostring(i) .. '.' .. tostring(r.name or '') .. ' [' .. tostring(r._my_note) .. ']')
        end
        print('--- total: ' .. tostring(cnt))
    end
end

function oq.announce(msg, to_name, to_realm)
    if ((msg == nil) or oq.toon.disabled) then
        return
    end

    if (to_name ~= nil) then
        local msg_tok = 'W' .. oq.token_gen()
        oq.token_push(msg_tok)
        local m = 'OQ,' .. OQ_BUILD_STR .. ',' .. msg_tok .. ',' .. OQ_TTL .. ',' .. msg

        oq.XRealmWhisper(to_name, to_realm, m)

        msg = msg .. ',' .. OQ_FLD_TO .. '' .. to_name .. ',' .. OQ_FLD_REALM .. '' .. tostring(oq.GetRealmID(to_realm))
    end
    local msg_tok = 'A' .. oq.token_gen()
    oq.token_push(msg_tok)

    local m = 'OQ,' .. OQ_BUILD_STR .. ',' .. msg_tok .. ',' .. OQ_TTL .. ',' .. msg

    -- send to raid (which sends to local channel and real-id ppl in the raid)
    oq.announce_relay(m, true)
end

--
-- message relays
--
function oq.announce_relay(m, insure)
    if (oq.toon.disabled) then
        return
    end
    -- keep copy
    if (oq.__premade_msg) and (oq.raid.raid_token) then
        OQ_data._premade_info[oq.raid.raid_token] =
            tostring(oq.player_faction) .. '.' .. tostring(oq.utc_time()) .. '.' .. m
    end

    -- send to general channel
    if (_inc_channel ~= OQ_REALM_CHANNEL) and (oq._banned == nil) then
        oq.SendOQChannelMessage(m)
    end

    -- send to raid channels
    if (oq.raid.raid_token ~= nil) then
        oq.SendPartyMessage(m)
    end
end

--
--  send to local OQRaid channel then to real-id friends in the raid
--
function oq.raid_announce(msg, msg_tok)
    if (oq.raid.raid_token == nil) then
        -- no raid token means not in a raid
        return
    end

    if (msg_tok == nil) then
        -- the 'R' stands for 'raid' and should not be echo'd far and wide
        msg_tok = 'R' .. oq.token_gen()
        oq.token_push(msg_tok)
    end

    local m = 'OQ,' .. OQ_BUILD_STR .. ',' .. msg_tok .. ',' .. oq.raid.raid_token .. ',' .. msg
    oq.SendPartyMessage(m)
end

function oq.raid_announce_member(group_id, slot, name, realm, class)
    if ((name == nil) or (name == '-')) then
        return
    end
    oq.raid_announce(
        'member,' ..
            group_id ..
                ',' .. slot .. ',' .. tostring(class) .. ',' .. tostring(name) .. ',' .. tostring(oq.GetRealmID(realm))
    )
end

function oq.party_announce(msg)
    if (oq.raid.raid_token == nil) or (not oq.iam_in_a_party()) then
        return
    end
    -- the 'P' stands for 'party' and should not be echo'd far and wide
    local msg_tok = 'P' .. oq.token_gen()
    oq.token_push(msg_tok)

    local m = 'OQ,' .. OQ_BUILD_STR .. ',' .. msg_tok .. ',' .. oq.raid.raid_token .. ',' .. msg
    -- send to party channel
    oq.SendPartyMessage(m)
end

function oq.bg_announce(msg)
    if (oq._isAfk) then
        return
    end

    local m = 'OQ,' .. OQ_BUILD_STR .. ',' .. 'W1,' .. OQ_TTL .. ',' .. msg
    -- this should send to both parties and instance groups and fail silently if either isn't valid
    SendAddonMessage(OQ_HEADER, m, 'PARTY')
    oq.pkt_sent:inc()
    SendAddonMessage(OQ_HEADER, m, 'INSTANCE_CHAT')
    oq.pkt_sent:inc()
end

--
--  ONLY sent by raid leader
--
function oq.raid_disband(dont_clean)
    if (oq.iam_raid_leader()) then
        local token = oq.token_gen()
        local raid_tok = oq.raid.raid_token
        local m = 'disband,' .. oq.raid.raid_token .. ',' .. token
        oq.log(nil, '|cFF808080group disbanded:|r ' .. tostring(oq.raid.name) .. '')

        oq.announce(m)
        oq.recently_disbanded(raid_tok)
        oq.mini_count_update(0)
        if (_oqgeneral_lockdown) then
            local is_restricted = _oqgeneral_lockdown
            _oqgeneral_lockdown = nil
            oq.SendOQChannelMessage(m)
            _oqgeneral_lockdown = is_restricted
        end
        if (dont_clean == nil) then
            oq.reject_all_waitlist()
            oq._local = true
            oq.on_disband(oq.raid.raid_token, token, true)
            oq._local = nil
        end
    end
end

function oq.ejectall()
    if (oq.iam_raid_leader()) then
        local n, x
        local t = tbl.new()
        n = 0
        for i = GetNumGroupMembers(), 1, -1 do
            x = strlower(select(1, GetRaidRosterInfo(i)))
            if (x ~= player_name) then
                n = n + 1
                t[n] = x
            end
        end
        for _, v in pairs(t) do
            oq.UninviteUnit(v)
        end
        tbl.delete(t)
        oq.raid_disband()
    end
end

function oq.cmdline_find_member(subname)
    if (subname == nil) then
        print(L['please specify partial string'])
        return 0
    end
    local table = oq.raid.group
    local cnt = 0
    subname = strlower(subname)

    for i = 1, 8 do
        for j = 1, 5 do
            local m = table[i].member[j]
            if (subname == '#all') and (m.name) then
                cnt = cnt + 1
                print(
                    '  ' ..
                    tostring(i) ..
                    '.' ..
                    tostring(j) ..
                    '  |cFF00e0e0' ..
                    tostring(m.name) ..
                    '-' .. tostring(m.realm) .. '|r  ' .. tostring(m.realid or 'UNK')
                )
            elseif (m.name) and (strlower(m.name):find(subname)) then
                cnt = cnt + 1
                print(
                    '  ' ..
                    tostring(i) ..
                    '.' ..
                    tostring(j) ..
                    '  |cFF00e0e0' ..
                    tostring(m.name) ..
                    '-' .. tostring(m.realm) .. '|r  ' .. tostring(m.realid or 'UNK')
                )
            end
        end
    end
    print('----  ' .. tostring(cnt) .. ' found')
end

function oq.raid_join(ndx, bg_type)
    oq.raid_announce('join,' .. ndx .. ',' .. bg_type)
end

function oq.raid_leave(ndx)
    oq.raid_announce('leave,' .. ndx)
end

function oq.raid_ping()
    local msg_tok = 'B' .. oq.token_gen()
    oq.token_push(msg_tok)
    local m =
        'OQ,' ..
        OQ_BUILD_STR .. ',' .. msg_tok .. ',' .. oq.raid.raid_token .. ',ping,' .. oq.my_tok .. ',' .. GetTime() * 1000

    for i = 2, 8 do
        local grp = oq.raid.group[i]
        if (grp.member and grp.member[1].name and grp.member[1].realm) then
            oq.XRealmWhisper(grp.member[1].name, grp.member[1].realm, m)
        end
    end
end

function oq.raid_ping_ack(tok, tm)
    oq._sender = nil -- must nil to allow send
    if (my_group == 0) then
        local name = _from
        local realm = nil
        if (_from:find('-')) then
            name = _from:sub(1, _from:find('-') - 1)
            realm = _from:sub(_from:find('-') + 1, -1)
            realm = oq.GetRealmNameFromID(realm)
        end
        local msg = 'ping_ack,' .. tok .. ',' .. tm .. ',' .. (my_group or 0)
        oq.XRealmWhisper(name, realm, msg)
    else
        local m = 'ping_ack,' .. tok .. ',' .. tm .. ',' .. (my_group or 0)
        oq.WhisperRaidLeader(m)
    end
end

function oq.ping_toon(toon)
    if (toon == nil) then
        return
    end

    local name = toon
    local realm = player_realm
    if (toon:find('-')) then
        name = toon:sub(1, toon:find('-') - 1)
        realm = toon:sub(toon:find('-') + 1, -1)
        realm = oq.GetRealmNameFromID(realm)
    end
    oq.XRealmWhisper(name, realm, 'ping,' .. oq.my_tok .. ',' .. GetTime() * 1000)
end

function oq.ping_self_thru_raid()
    if (oq.nMembers() == 1) then
        return
    end
    oq.raid_announce('selfie,' .. tostring(GetTime() * 1000), 'R' .. oq.token_gen())
end

function oq.on_selfie(ts)
    ts = tonumber(ts)
    local now = GetTime() * 1000
    oq._lag = floor((now - ts) / 2)
end

function oq.remove_all_premades()
    for token, _ in pairs(oq.premades) do
        oq.remove_premade(token, true)
    end
    tbl.clear(oq.premades)
    tbl.clear(OQ_data._premade_info)
    if (OQ_data._locals) and (type(OQ_data._locals) == 'table') then
        tbl.clear(OQ_data._locals)
    else
        OQ_data._locals = tbl.new()
    end
    oq.reshuffle_premades_now()
end

function oq.remove_dead_premades()
    _source = 'cleanup'
    local now = oq.utc_time()
    local dt = floor(OQ_PREMADE_STAT_LIFETIME / 2)

    for _, v in pairs(oq.premades) do
        -- don't remove my own premade
        if (v.raid_token ~= oq.raid.raid_token) and ((v.tm == nil) or ((now - v.tm) > dt)) then
            oq.remove_premade(v.raid_token)
        end
    end
    _source = nil
end

function oq.remove_premade(token, dont_shuffle)
    local reshuffle = nil
    if (oq.premades[token] ~= nil) then
        -- hold onto the token & b-tag combo incase the user wants to ban the group lead
        oq.old_raids = oq.old_raids or tbl.new()
        if (oq.old_raids[token] == nil) and (oq.premades[token].leader_rid ~= nil) then
            oq.old_raids[token] = oq.premades[token].leader_rid
        end
        reshuffle = (oq.premades[token]._row ~= nil)
        oq.premades[token]._row = oq.DeleteFrame(oq.premades[token]._row)
        oq.premades[token].type = nil
        oq.premades[token]._isvis = nil
        oq.premades[token].__y = -1
        oq.premades[token] = tbl.delete(oq.premades[token])
    end

    OQ_data._premade_info = OQ_data._premade_info or tbl.new()
    OQ_data._premade_info[token] = nil

    if (reshuffle) and (dont_shuffle == nil) then
        oq.reshuffle_premades_now()
    end
end

function oq.get_rank_score(p)
    local top = 0
    local rank = 0
    if (p.type == OQ.TYPE_BG) then
        top = OQ.rank_breaks['pvp'][4].line
        rank = oq.get_winloss_record(p.leader_xp)
    end
    if (p.type == OQ.TYPE_RBG) then
        top = OQ.rank_breaks['rated'][4].line
        rank = oq.get_winloss_record(p.leader_xp)
    end
    if (p.type == OQ.TYPE_ARENA) then
    -- arena has no leader record; will sort to the bottom in 'all premades'
    --    top  = 2400 ;
    --    rank = oq.decode_mime64_digits(p.leader_xp:sub( 2, 4)) ;
    end
    if (p.type == OQ.TYPE_DUNGEON) or (p.type == OQ.TYPE_RAID) then
        top = OQ.rank_breaks['pve'][4].line
        rank = oq.decode_mime64_digits(p.leader_xp:sub(17, 19)) -- dragon kill pts
    end
    if (p.type == OQ.TYPE_SCENARIO) then
        top = OQ.rank_breaks['pve'][4].line
        rank = oq.decode_mime64_digits(p.leader_xp:sub(6, 8)) -- dragon kill pts
    end
    if (top == 0) then
        return 0
    end
    return rank / top
end

function oq.compare_ranks(p1, p2)
    local rank1 = oq.get_rank_score(p1)
    local rank2 = oq.get_rank_score(p2)
    if (rank1 == rank2) then
        return (strlower(p1.leader or '') < strlower(p2.leader or ''))
    end
    return (rank1 < rank2)
end

function oq.compare_premades(a, b)
    if (a == nil) and (b == nil) then
        return false
    end
    if (a == nil) then
        return false
    elseif (b == nil) then
        return true
    end
    local p1 = oq.premades[a]
    local p2 = oq.premades[b]
    if (OQ_data.premade_sort_ascending == nil) then
        p1 = oq.premades[b]
        p2 = oq.premades[a]
    end
    if (p1 == nil) and (p2 == nil) then
        return false
    end
    if (p1 == nil) then
        return false
    elseif (p2 == nil) then
        return true
    end

    OQ_data.premade_sort = OQ_data.premade_sort or 'lead'

    if (OQ_data.premade_sort == 'name') then
        return (strlower(p1.name or '') < strlower(p2.name or ''))
    end
    if (OQ_data.premade_sort == 'rank') then
        return oq.compare_ranks(p1, p2)
    end
    if (OQ_data.premade_sort == 'lead') then
        return (strlower(p1.leader or '') < strlower(p2.leader or ''))
    end
    if (OQ_data.premade_sort == 'level') then
        return ((p1.level_range or 'UNK') < (p2.level_range or 'UNK'))
    end
    if (OQ_data.premade_sort == 'ilevel') then
        local x = p1.min_ilevel or 0
        local y = p2.min_ilevel or 0
        if ((p1.type == OQ.TYPE_DUNGEON) or (p1.type == OQ.TYPE_RAID)) and (p1.min_mmr > 0) then
            x = min(x, p1.min_mmr)
        end
        if ((p2.type == OQ.TYPE_DUNGEON) or (p2.type == OQ.TYPE_RAID)) and (p2.min_mmr > 0) then
            y = min(y, p2.min_mmr)
        end
        return (x < y)
    end
    if (OQ_data.premade_sort == 'resil') then
        return ((p1.min_resil or 0) < (p2.min_resil or 0))
    end
    if (OQ_data.premade_sort == 'mmr') then
        return ((p1.min_mmr or 0) < (p2.min_mmr or 0))
    end
    return true
end

function oq.qualified(token)
    oq.__reason = nil
    oq.__reason_extra = nil
    if (token == nil) then
        return false
    end
    local p = oq.premades[token]
    if (p == nil) then
        return false
    end
    if (oq.is_pending(token)) then
        return true
    end
    if (OQ_data.premade_filter_type == OQ.TYPE_ALL_PENDING) then
        return false -- skipped previous, must not be pending
    end

    if (p.nWaiting) and (p.nWaiting >= OQ_MAX_WAITLIST) then
        oq.__reason = L['wait list full']
        return false
    end
    if (oq.get_player_level_id() ~= OQ.SHORT_LEVEL_RANGE[p.level_range]) then
        oq.__reason = L['invalid level range']
        return false
    end

    local min_ilevel = p.min_ilevel
    if ((p.type == OQ.TYPE_DUNGEON) or (p.type == OQ.TYPE_RAID)) and (p.min_mmr > 0) then
        min_ilevel = p.min_ilevel
    end
    if (oq.get_ilevel() < min_ilevel) then
        oq.__reason = L['ilevel too low']
        return false
    end
    if
        ((p.type == OQ.TYPE_BG) or (p.type == OQ.TYPE_RBG) or (p.type == OQ.TYPE_ARENA)) and
            (oq.get_resil() < p.min_resil)
     then
        oq.__reason = L['resil too low']
        return false
    end
    -- status == 2 means in a bg or rbg
    -- if in a bg and not my group, not qualified
    if (p.status == 2) and (token ~= oq.raid.raid_token) then
        return false
    end
    if
        ((p.type == OQ.TYPE_BG) or (p.type == OQ.TYPE_RBG) or (p.type == OQ.TYPE_ARENA)) and
            (oq.get_best_mmr(p.type) < p.min_mmr)
     then
        oq.__reason = L['rating too low']
        return false
    end
    if (not oq.is_set(p.role, player_role)) then
        oq.__reason = L['invalid role']
        return false
    end
    if (not oq.is_set(p.classes, OQ.CLASS_FLAG[player_class])) then
        oq.__reason = L['invalid class']
        return false
    end
    local difficulty = (p.type == OQ.TYPE_RAID) and oq.decode_mime64_digits(p.pdata:sub(4, 4))
    if (p.type == OQ.TYPE_RAID) and (difficulty >= 3) and (difficulty <= 6) and (oq.lockout_conflict(p.pdata)) then
        oq.__reason = L['raid lockout']
        return false
    end
    return true
end

function oq.premades_of_type(filter_type)
    local nPremades = 0

    for _, p in pairs(oq.premades) do
        if (p) then
            if
                ((OQ_data.premade_filter_qualified == 1) and (oq.qualified(p.raid_token))) or
                    (OQ_data.premade_filter_qualified == 0)
             then
                if ((filter_type == OQ.TYPE_NONE) or (p.type == filter_type)) and oq.pass_filter(p) then
                    nPremades = nPremades + 1
                end
            end
        end
    end
    return nPremades
end

-- this will allow me to buffer the shuffle
--
function oq.reshuffle_premades()
    oq.timer('reshuffle_premades', 0.50, oq.reshuffle_premades_now, nil)
end

local __n = 0
function oq.reshuffle_premades_now()
    if (oq._scroll_paused) or (not OQTabPage2:IsVisible()) then
        return
    end
    local x, y, cx, cy
    x = 10
    y = 10
    cy = OQ_data._rowheight or 24
    cx = oq.tab2._list:GetWidth() - 2 * x

    tbl.clear(_items)
    for raid_token, p in pairs(oq.premades) do
        if (p) then
            p._isvis = nil
            p.__y = -1
        end
        if ((OQ_data.premade_filter_qualified == 1) and (not oq.qualified(raid_token))) or (p.leader == nil) then
            if (p.leader == nil) then
                oq.remove_premade(raid_token, true)
            else
                p._row = oq.DeleteFrame(p._row)
            end
        else
            if
                (p) and
                    (((OQ_data.premade_filter_type == OQ.TYPE_ALL_PENDING) and oq.is_pending(p.raid_token)) or
                        (OQ_data.premade_filter_type == OQ.TYPE_NONE) or
                        (p.type == OQ_data.premade_filter_type)) and
                    oq.pass_filter(p)
             then
                p.__y = 1
                p._isvis = true
                table.insert(_items, raid_token)
            else
                p._row = oq.DeleteFrame(p._row)
            end
        end
    end

    oq._npremades = 0
    x = 11
    y = 4
    cy = OQ_data._rowheight or 24
    cx = oq.tab2._list:GetWidth() - 2 * x

    table.sort(_items, oq.compare_premades)
    for _, v in pairs(_items) do
        oq.setpos(oq.premades[v]._row, x, y, cx, cy)
        oq.premades[v].__x = x
        oq.premades[v].__y = y
        y = y + cy
        oq._npremades = oq._npremades + 1
    end

    oq.tab2._list:SetHeight(max(oq.tab2._scroller:GetHeight(), y + 2 * cy))
    oq.trim_big_list(oq.tab2._scroller)
    oq.update_premade_count()
end

function oq.n_waiting()
    local n = 0
    if (oq.tab7) and (oq.tab7.waitlist) then
        for _, v in pairs(oq.tab7.waitlist) do
            n = n + v.nMembers
        end
    end
    return n
end

function oq.find_premade_entry(raid_token)
    local r = oq.premades[raid_token]
    if (r == nil) or (r._row == nil) then
        return nil, nil
    end
    return r._row, r
end

--
-- ban list
--
function oq.create_ban_listitem(parent, x, y, cx, cy, btag, reason, ts)
    local f = oq.panel(parent, 'Banned', x, y, cx, cy)

    f:SetScript(
        'OnEnter',
        function(self)
            self._highlight:Show()
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            self._highlight:Hide()
        end
    )

    if (f._highlight == nil) then
        local t = f:CreateTexture(nil, 'BACKGROUND')
        t:SetDrawLayer('BACKGROUND')
        t:SetTexture('INTERFACE/QUESTFRAME/UI-QuestTitleHighlight')
        t:SetPoint('TOPLEFT', 5, 0, 'TOPLEFT', 0, 0)
        t:SetPoint('BOTTOMRIGHT', -5, 0, 'BOTTOMRIGHT', 0, 0)
        t:SetAlpha(0.6)
        t:Hide()
        f._highlight = t
    end

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)

    local x2 = 0
    f.remove_but =
        oq.texture_button(
        f,
        x2,
        2,
        27,
        27,
        OQ.X_BUTTON_UP,
        OQ.X_BUTTON_DN,
        OQ.X_BUTTON_UP,
        function(self)
            oq.remove_banlist_item(self:GetParent().btag:GetText())
        end
    )
    x2 = x2 + 40
    f.ts = oq.label(f, x2, 2, 130, cy, tostring(date('%H:%M %d-%b-%Y', ts)))
    --  f.ts:SetFont(OQ.FONT, 10, "");
    f.ts:SetFont(OQ.FONT_FIXED, 9, '')
    f.ts:SetTextColor(1, 1, 1)
    x2 = x2 + 130 + 8
    f.btag = oq.label(f, x2, 2, 200, cy, btag)
    f.btag:SetFont(OQ.FONT, 10, '')
    x2 = x2 + 200 + 4
    f.reason = oq.label(f, x2, 2, 450, cy, reason)
    f.reason:SetFont(OQ.FONT, 10, '')
    f.reason:SetTextColor(0.9, 0.9, 0.9)
    f._ts = ts
    f:Show()
    return f
end

function oq.populate_ban_list()
    if (OQ_data.banned == nil) then
        OQ_data.banned = tbl.new()
    end
    local x, y, cx, cy
    x = 1
    y = 1
    cx = 200
    cy = 22

    for i, v in pairs(OQ_data.banned) do
        local f = oq.create_ban_listitem(oq.tab6._list, x, y, cx, cy, i, v.reason, v.ts)
        table.insert(oq.tab6_banlist, f)
        y = y + cy
    end
    oq.reshuffle_banlist()
end

function oq.compare_banlist(a, b)
    if (a == nil) and (b == nil) then
        return false
    end
    if (a == nil) then
        return false
    elseif (b == nil) then
        return true
    end
    local v1 = oq.tab6_banlist[a]
    local v2 = oq.tab6_banlist[b]
    if (OQ_data.banlist_sort_ascending == nil) then
        v1 = oq.tab6_banlist[b]
        v2 = oq.tab6_banlist[a]
    end

    OQ_data.banlist_sort = OQ_data.banlist_sort or 'ts'

    if (OQ_data.banlist_sort == 'ts') then
        return (v1._ts < v2._ts)
    end
    if (OQ_data.banlist_sort == 'reason') then
        return (strlower(v1.reason:GetText() or '') < strlower(v2.reason:GetText() or ''))
    end
    -- default sort: btag
    return (strlower(v1.btag:GetText() or '') < strlower(v2.btag:GetText() or ''))
end

function oq.sort_banlist(col)
    local order = OQ_data.banlist_sort_ascending
    if (OQ_data.banlist_sort ~= col) then
        order = true
    else
        if (order) then
            order = nil
        else
            order = true
        end
    end
    OQ_data.banlist_sort = col
    OQ_data.banlist_sort_ascending = order
    oq.reshuffle_banlist()
end

function oq.reshuffle_banlist()
    local x, y, cx, cy
    x = 20
    y = 10
    cy = 25
    cx = oq.tab6._list:GetWidth() - 2 * x

    tbl.clear(_items)
    for n, _ in pairs(oq.tab6_banlist) do
        if (n ~= nil) then
            table.insert(_items, n)
        end
    end
    table.sort(_items, oq.compare_banlist)
    oq._nbanlist = 0
    for _, v in pairs(_items) do
        oq.setpos(oq.tab6_banlist[v], x, y, cx, cy)
        y = y + cy + 2
        oq._nbanlist = oq._nbanlist + 1
    end

    oq.tab6._list:SetHeight(max(15 * (cy + 2), y + (4 * (cy + 2))))
end

function oq.remove_all_banlist()
    oq.ban_clearall()

    for i, v in pairs(oq.tab6_banlist) do
        v:Hide()
        v:SetParent(nil)
        oq.tab6_banlist[i] = nil -- erased, but not cleaned up... should be reclaimed
    end

    oq.reshuffle_banlist()
end

function oq.remove_banlist_item(btag)
    local reshuffle = nil

    for i, v in pairs(oq.tab6_banlist) do
        if (v.btag:GetText() == btag) then
            reshuffle = true
            v:Hide()
            v:SetParent(nil)
            oq.tab6_banlist[i] = nil -- erased, but not cleaned up... should be reclaimed
            break
        end
    end

    if (reshuffle) then
        oq.reshuffle_banlist()
    end

    oq.ban_remove(btag)
end

function oq.is_lessthan(a, b)
    if (a == nil) then
        return true
    end
    return ((a or 0) < (b or 0))
end

--
-- wait list
--
function oq.compare_waitlist(a, b)
    if (a == nil) and (b == nil) then
        return false
    end
    if (a == nil) then
        return false
    elseif (b == nil) then
        return true
    end
    local v1 = oq.tab7.waitlist[a]
    local v2 = oq.tab7.waitlist[b]
    local p1 = oq.waitlist[v1.token]
    local p2 = oq.waitlist[v2.token]
    if (OQ_data.waitlist_sort_ascending == nil) then
        v1 = oq.tab7.waitlist[b]
        v2 = oq.tab7.waitlist[a]
        p1 = oq.waitlist[v1.token]
        p2 = oq.waitlist[v2.token]
    end
    if (p1 == nil) and (p2 == nil) then
        return false
    end
    if (p1 == nil) then
        return false
    elseif (p2 == nil) then
        return true
    end

    OQ_data.waitlist_sort = OQ_data.waitlist_sort or 'name'

    if (OQ_data.waitlist_sort == 'name') then
        return (strlower(p1.name or '') < strlower(p2.name or ''))
    end
    if (OQ_data.waitlist_sort == 'rlm') then
        return (strlower(p1.realm) < strlower(p2.realm))
    end
    if (OQ_data.waitlist_sort == 'cls') then
        return (strlower(p1.class) < strlower(p2.class))
    end
    if (OQ_data.waitlist_sort == 'role') then
        return (strlower(p1.role) < strlower(p2.role))
    end
    if (OQ_data.waitlist_sort == 'level') then
        return (p1.level < p2.level)
    end
    if (OQ_data.waitlist_sort == 'ilevel') then
        return oq.is_lessthan(p1.ilevel, p2.ilevel)
    end
    if (OQ_data.waitlist_sort == 'resil') then
        return oq.is_lessthan(p1.resil, p2.resil)
    end
    if (OQ_data.waitlist_sort == 'mmr') then
        return oq.is_lessthan(p1.mmr, p2.mmr)
    end
    if (OQ_data.waitlist_sort == 'power') then
        return oq.is_lessthan(p1.pvppower, p2.pvppower)
    end
    if (OQ_data.waitlist_sort == 'haste') then
        return oq.is_lessthan(p1.haste, p2.haste)
    end
    if (OQ_data.waitlist_sort == 'mastery') then
        return oq.is_lessthan(p1.mastery, p2.mastery)
    end
    if (OQ_data.waitlist_sort == 'hit') then
        return oq.is_lessthan(p1.hit, p2.hit)
    end
    if (OQ_data.waitlist_sort == 'time') then
        return oq.is_lessthan(p1.create_tm, p2.create_tm)
    end
    return true
end

function oq.reshuffle_waitlist()
    local x, y, cx, cy
    x = 6
    y = 10
    cy = 25
    cx = oq.tab7._list:GetWidth() - 2 * x

    tbl.clear(_items)
    for n, v in pairs(oq.tab7.waitlist) do
        if (v.token) and (oq.waitlist[v.token]) then
            if (oq.waitlist[v.token].realid == nil) then
                oq.tab7.waitlist[n] = oq.DeleteFrame(v)
                oq.waitlist[v.token] = tbl.delete(oq.waitlist[v.token])
            else
                if (n ~= nil) then
                    table.insert(_items, n)
                end
            end
        end
    end
    oq._nwaitlist = 0

    local n = 0
    table.sort(_items, oq.compare_waitlist)
    for _, v in pairs(_items) do
        oq.setpos(oq.tab7.waitlist[v], x, y, cx, cy)
        y = y + cy + 2
        n = n + oq.tab7.waitlist[v].nMembers
        oq._nwaitlist = oq._nwaitlist + 1
    end

    oq.tab7._list:SetHeight(max(oq.tab7._scroller:GetHeight(), y + 2 * cy))

    if (n > 0) then
        OQMainFrameTab7:SetText(string.format(OQ.TAB_WAITLISTN, n))
        local max_inv = min(40 - GetNumGroupMembers(), 10)
        oq.tab7.inviteall_button:SetText(string.format('%s (%d)', OQ.BUT_INVITE_ALL, min(n, max_inv)))
    else
        OQMainFrameTab7:SetText(OQ.TAB_WAITLIST)
        oq.tab7.inviteall_button:SetText(OQ.BUT_INVITE_ALL)
    end

    oq.mini_count_update(oq._nwaitlist)
end

function oq.remove_all_waitlist()
    tbl.clear(oq.waitlist)
    tbl.clear(oq.names)

    for i, v in pairs(oq.tab7.waitlist) do
        oq.DeleteFrame(v)
        oq.tab7.waitlist[i] = nil -- erased, but not cleaned up... should be reclaimed
    end
    oq.reshuffle_waitlist()
end

function oq.send_removed_notice(token)
    local r = oq.waitlist[token]
    if (r ~= nil) then
        oq.timer_oneshot(
            1,
            oq.XRealmWhisper,
            r.name,
            r.realm,
            OQ_MSGHEADER ..
                '' .. OQ_BUILD_STR .. ',' .. 'W1,' .. '0,' .. 'removed_from_waitlist,' .. oq.raid.raid_token .. ',' .. token
        )
    end
end

function oq.reject_all_waitlist()
    for _, v in pairs(oq.tab7.waitlist) do
        oq.send_removed_notice(v.token)
    end
    oq.remove_all_waitlist()
end

function oq.find_waitlist_row(token)
    for _, v in pairs(oq.tab7.waitlist) do
        if (v.token == token) then
            return v
        end
    end
    return nil
end

function oq.remove_waitlist(token)
    local reshuffle = nil

    for i, v in pairs(oq.tab7.waitlist) do
        if (v.token == token) then
            reshuffle = true
            oq.DeleteFrame(v)
            oq.tab7.waitlist[i] = nil -- erased, but not cleaned up... should be reclaimed
            break
        end
    end

    if (reshuffle) then
        oq.reshuffle_waitlist()
    end

    -- now tell the remote user he has been removed
    oq.send_removed_notice(token)

    -- clean up the waitlist
    if (oq.waitlist[token] ~= nil) then
        local r = oq.waitlist[token]
        oq.names[strlower(r.name .. '-' .. r.realm)] = nil
        oq.waitlist[token] = tbl.delete(oq.waitlist[token])
    end
end

function oq.on_removed_from_waitlist(raid_token, req_token, hide_sounds)
    if (not oq.is_my_token(req_token)) then
        return
    end
    -- set the premade button from 'pending' back to 'waitlist'
    oq.set_premade_pending(raid_token, nil, hide_sounds)

    -- remove from oq.pending
    oq.pending[raid_token] = tbl.delete(oq.pending[raid_token])

    oq.clear_my_token(req_token)
end

function oq.on_leave_waitlist(raid_token, req_token)
    if (raid_token ~= oq.raid.raid_token) then
        -- not for me
        return
    end
    oq.remove_waitlist(req_token)
end

function oq.send_leave_waitlist(raid_token)
    if (raid_token == nil) then
        return
    end
    local now = oq.utc_time()
    local req = oq.pending[raid_token]
    local raid = oq.premades[raid_token]
    if (req == nil) or (raid == nil) or (req.next_msg_tm > now) or (req.req_token == nil) then
        return
    end
    req.next_msg_tm = now + 2

    if (raid_token == oq.raid.raid_token) then
        -- i've joined the raid.  just remove the entry
        oq.set_premade_pending(raid_token, nil)
        oq.pending[raid_token] = tbl.delete(oq.pending[raid_token])
    else
        local msg =
            OQ_MSGHEADER ..
            '' .. OQ_BUILD_STR .. ',' .. 'W1,' .. '0,' .. 'leave_waitlist,' .. raid_token .. ',' .. req.req_token
        oq.XRealmWhisper(raid.leader, raid.leader_realm, msg)
    end

    -- remove it from this end
    if (req) then
        oq.on_removed_from_waitlist(raid_token, req.req_token, true)
    end
end

--
-- this is called to remove the player from all waitlists they may have put themselves on
--
function oq.clear_pending()
    for raid_token, req in pairs(oq.pending) do
        req.next_msg_tm = 0 -- force the send
        oq.send_leave_waitlist(raid_token)
    end
end

function oq.check_and_send_request(raid_token)
    local in_party = (GetNumGroupMembers() > 0)
    local raid = oq.premades[raid_token]
    if (raid == nil) then
        return
    end
    if (oq.raid.raid_token ~= nil) then
        if (my_group == 1) and (my_slot == 1) then
            local dlg = StaticPopup_Show('OQ_NoWaitlistWhilePremadeLead')
            if (dlg) then
                dlg._token = raid_token
            end
        else
            local dlg = StaticPopup_Show('OQ_NoWaitlistWhilePremade')
            if (dlg) then
                dlg._token = raid_token
            end
        end
        return
    end

    if (in_party and not UnitIsGroupLeader('player')) then
        local dlg = StaticPopup_Show('OQ_NotPartyLead')
        if (dlg) then
            dlg._token = raid_token
        end
        return
    end
    if (in_party) then
        StaticPopup_Show('OQ_NoPartyWaitlists')
        return
    end
    if (raid ~= nil) then
        if (raid.has_pword ~= nil) then
            PlaySoundFile('Sound\\interface\\KeyRingOpen.wav')
            local dialog = StaticPopup_Show('OQ_EnterPword')
            dialog.data = raid_token
        else
            oq.send_req_waitlist(raid_token, '')
        end
    end
end
function oq.send_req_waitlist(raid_token, pword)
    local in_party = (GetNumGroupMembers() > 0)

    local now = oq.utc_time()
    local req = oq.pending[raid_token]
    if (req == nil) then
        oq.pending[raid_token] = tbl.new()
        req = oq.pending[raid_token]
    elseif (req.next_msg_tm) and (req.next_msg_tm > now) then
        -- too soon for resend. no more then once every 5 seconds
        return
    end
    req.next_msg_tm = now + 5

    local req_token = req.req_token

    if (req_token == nil) then
        req_token = 'Q' .. oq.token_gen()
        req.req_token = req_token
        oq.store_my_token(req_token)
    end

    oq.gather_my_stats()
    local flags = OQ.FLAG_ONLINE
    local raid = oq.premades[raid_token]
    local dest_realm = raid.leader_realm

    if (raid == nil) then
        return
    end

    if (player_realm ~= dest_realm) and (not oq.valid_rid(oq.player_realid)) then
        message(OQ.BAD_REALID .. ' ' .. tostring(oq.player_realid))
        return
    end

    if (in_party) then
        -- must be party leader.
        local party_avg_ilevel = 0
        local party_avg_resil = 0
        local mmr = oq.get_best_mmr(raid.type)
        local pvppower = oq.get_pvppower()
        local stats =
            oq.encode_short_stats(
            player_level,
            oq.player_faction,
            player_class,
            party_avg_resil,
            party_avg_ilevel,
            player_role,
            mmr,
            pvppower,
            0
        )
        local enc_data = oq.encode_data('abc123', player_name, player_realm, oq.player_realid)
        local msg =
            OQ_MSGHEADER ..
            '' ..
                OQ_BUILD_STR ..
                    ',' ..
                        'W1,' ..
                            '0,' ..
                                'ri,' ..
                                    raid_token ..
                                        ',' ..
                                            tostring(raid.type or 0) ..
                                                ',' ..
                                                    tostring(GetNumGroupMembers()) ..
                                                        ',' ..
                                                            req_token ..
                                                                ',' ..
                                                                    enc_data ..
                                                                        ',' .. stats .. ',' .. oq.encode_pword(pword)

        oq.XRealmWhisper(raid.leader, raid.leader_realm, msg)
    else
        local mmr = oq.get_best_mmr(raid.type)
        local pvppower = oq.get_pvppower()
        local class, spec, spec_id = oq.get_spec()
        local stats = oq.encode_my_stats(0, 0, 0, 'A', 'A', true, raid.type)
        local enc_data = oq.encode_data('abc123', player_name, player_realm, oq.player_realid)
        local pdata = oq.get_pdata(raid.type, raid.subtype) -- include the raid.type to get specific pdata
        if (pdata == '') then
            pdata = 'AAA'
        end

        local msg =
            OQ_MSGHEADER ..
            '' ..
                OQ_BUILD_STR ..
                    ',' ..
                        'W1,' ..
                            '0,' ..
                                'ri,' ..
                                    raid_token ..
                                        ',' ..
                                            tostring(raid.type or 0) ..
                                                ',' ..
                                                    '1,' ..
                                                        req_token ..
                                                            ',' ..
                                                                enc_data ..
                                                                    ',' ..
                                                                        stats ..
                                                                            ',' ..
                                                                                oq.encode_pword(pword) .. ',' .. pdata

        oq.XRealmWhisper(raid.leader, raid.leader_realm, msg)
    end
end

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
function oq.bg_name(tid)
    for i, v in pairs(OQ.BG_NAMES) do
        if (v.type_id == tid) then
            return i
        end
    end
end

function oq.bg_type_id(name)
    if (name == nil) then
        return -1
    end
    if (OQ.BG_NAMES[name] == nil) then
        return -2
    end
    return OQ.BG_NAMES[name].type_id
end

function oq.get_player_level_id()
    player_level = UnitLevel('player') -- the level could have changed since the group was formed
    if (player_level == OQ.TOP_LEVEL) then
        return OQ.SHORT_LEVEL_RANGE[tostring(OQ.TOP_LEVEL)]
    elseif (player_level < 10) then
        return OQ.SHORT_LEVEL_RANGE['UNK']
    end
    local minlevel = floor(player_level / 5) * 5
    local maxlevel = floor((player_level + 5) / 5) * 5 - 1
    return OQ.SHORT_LEVEL_RANGE[string.format('%d - %d', minlevel, maxlevel)]
end

function oq.get_player_level_range()
    player_level = UnitLevel('player') -- the level could have changed since the group was formed
    if (player_level == OQ.TOP_LEVEL) then
        return OQ.TOP_LEVEL, OQ.TOP_LEVEL
    elseif (player_level < 10) then
        return 0, 0
    end
    local minlevel, maxlevel

    minlevel = floor(player_level / 5) * 5
    maxlevel = floor((player_level + 5) / 5) * 5 - 1

    return minlevel, maxlevel
end

function oq.nVisible(type)
    if (type == 'banlist') then
        return oq._nbanlist or 0
    elseif (type == 'waitlist') then
        return oq._nwaitlist or 0
    elseif (type == 'premades') then
        return oq._npremades or 0
    end
    return 0
end

function OQ_ModScrollBar_Update(f)
    local nItems = max(14, oq.nVisible(f._type))
    FauxScrollFrame_Update(f, nItems, 5, 25)
end

function oq.show_version()
    print('oQueue v' .. OQUEUE_VERSION .. '  build ' .. OQ_BUILD .. '' .. ' (' .. tostring(OQ.REGION) .. ')')

    if (player_level > 20) and (oq.get_role() == 'None') then
        oq.warning_no_role()
    end
end

function oq.hint(button, txt, show)
    if (not show) or (txt == nil) or (txt == '') then
        -- clear & hide the tooltip
        oq.gen_tooltip_hide()
        return
    end
    oq.gen_tooltip_set(button, txt)
end

function oq.normalize_static_button_height()
    if (HonorFrameSoloQueueButton) then
        if (not HonorFrameSoloQueueButton:IsVisible()) then
            oq.reset_button(HonorFrameSoloQueueButton)
        end
        HonorFrameSoloQueueButton:Show()
    end
    if (HonorFrameGroupQueueButton) then
        if (not HonorFrameGroupQueueButton:IsVisible()) then
            oq.reset_button(HonorFrameGroupQueueButton)
        end
        HonorFrameGroupQueueButton:Show()
    end

    if (PVPReadyDialogEnterBattleButton and (not PVPReadyDialogEnterBattleButton:IsVisible())) then
        oq.reset_button(PVPReadyDialogEnterBattleButton)
    end
    if (PVPReadyDialogLeaveQueueButton and (not PVPReadyDialogLeaveQueueButton:IsVisible())) then
        oq.reset_button(PVPReadyDialogLeaveQueueButton)
    end
end

function oq.battleground_leave(ndx)
    if (_inside_bg or (my_group == 0) or (my_slot == 0)) then
        return
    end

    -- are we still in a bg?
    if (GetBattlefieldStatInfo(ndx)) then
        return
    end

    local s1 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(ndx))]
    if (s1 == '0') then
        -- nothing to do
        return
    end

    local dlg = PVPReadyDialog
    if (s1 == '1') or (not dlg:IsVisible()) then
        -- queue not popped, move macro button into position
        oq.leaveQ:SetText(OQ.DLG_LEAVE)
        oq.make_big(oq.leaveQ)
        return
    end

    -- queue popped, move button to be clicked
    local enter_button = PVPReadyDialogEnterBattleButton
    enter_button:Disable()

    local leave_button = PVPReadyDialogLeaveQueueButton
    leave_button:Show()
    leave_button:Enable()
    leave_button:SetText(OQ.DLG_LEAVE)

    if (oq.leaveQ:IsVisible()) then
        oq.reset_button(oq.leaveQ)
        oq.leaveQ:Hide()
    end
    oq.reset_button(leave_button)
    oq.make_big(leave_button)

    --
    --  leaving queue now requires a hardware event
    --  pop up a box for the user to hit ok or esc (any input)
    --
end

function oq.create_alt_listitem(parent, x, y, cx, cy, name)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'Alt'
    local f = oq.panel(parent, n, x, y, cx, cy)

    f.name = name
    f.texture:SetTexture(0.0, 0.0, 0.0, 1)

    local x2 = 1
    f.remove_but =
        oq.button(
        f,
        x2,
        2,
        18,
        cy - 2,
        'x',
        function(self)
            oq.remove_alt_listitem(self:GetParent().name)
        end
    )
    x2 = x2 + 18 + 4
    f.toonName = oq.label(f, x2, 2, 150, cy, name)
    f:Show()
    return f
end

function oq.clear_alt_list()
    for i, v in pairs(oq.tab5_alts) do
        v:Hide()
        v:SetParent(nil)
        oq.tab5_alts[i] = nil -- erased, but not cleaned up... should be reclaimed
    end
    tbl.clear(oq.toon.my_toons)
end

function oq.remove_alt_listitem(name)
    local reshuffle = nil

    for i, v in pairs(oq.tab5_alts) do
        if (v.name == name) then
            reshuffle = true
            v:Hide()
            v:SetParent(nil)
            oq.tab5_alts[i] = nil -- erased, but not cleaned up... should be reclaimed
            break
        end
    end

    for i, v in pairs(oq.toon.my_toons) do
        if (v.name == name) then
            oq.toon.my_toons[i] = nil
            break
        end
    end

    if (reshuffle) then
        oq.reshuffle_alts()
    end
end

function oq.reshuffle_alts()
    if (oq.tab5_alts == nil) then
        oq.tab5_alts = tbl.new()
        return
    end

    local x, y, cx, cy
    x = 20
    y = 10
    cy = 20
    cx = oq.tab5._list:GetWidth() - 2 * x
    for _, v in pairs(oq.tab5_alts) do
        oq.setpos(v, x, y, cx, cy)
        y = y + cy + 2
    end

    oq.tab5._list:SetHeight(max(6 * (cy + 2), y + (1 * (cy + 2))))
end

function oq.add_toon(toonName)
    if (toonName == nil) or (toonName == '') then
        return
    end
    if (oq.toon.my_toons == nil) then
        oq.toon.my_toons = tbl.new()
    end

    for _, v in pairs(oq.toon.my_toons) do
        if (v.name == toonName) then
            return
        end
    end

    local d = tbl.new()
    d.name = toonName
    table.insert(oq.toon.my_toons, d)

    -- now update ui
    local f = oq.create_alt_listitem(oq.tab5._list, 1, 1, 200, 22, toonName)
    f.toonName:SetText(toonName)
    table.insert(oq.tab5_alts, f)
    oq.reshuffle_alts()
end

function oq.populate_alt_list()
    if (oq.toon.my_toons == nil) then
        oq.toon.my_toons = tbl.new()
    end
    local x, y, cx, cy

    x = 1
    y = 1
    cx = 200
    cy = 22
    for _, v in pairs(oq.toon.my_toons) do
        local f = oq.create_alt_listitem(oq.tab5._list, x, y, cx, cy, v.name)
        f.toonName:SetText(v.name)
        y = y + cy
        table.insert(oq.tab5_alts, f)
    end
    oq.reshuffle_alts()
end

function oq.populate_waitlist()
    local x, y, cy
    x = 2
    cy = 25
    y = 10
    for req_token, v in pairs(oq.waitlist) do
        if (v) and (v.name) then
            local f = oq.insert_waitlist_item(x, y, req_token, v.n_members, v.name, v.realm, v)
            if (v._pending_text) and (v._pending_text ~= '') then
                f.note_txt:Show()
            else
                f.note_txt:Hide()
            end
            table.insert(oq.tab7.waitlist, f)
            y = y + cy
        else
            oq.waitlist[req_token] = tbl.delete(oq.waitlist[req_token])
        end
    end
    oq.reshuffle_waitlist()
end

--------------------------------------------------------------------------
--
--------------------------------------------------------------------------
function oq.on_enter_bg()
    if (oq.raid.raid_token == nil) or (oq.raid.type ~= OQ.TYPE_BG) then
        return
    end
    PVPReadyDialogEnterBattleButton:Enable()
    PVPReadyDialogLeaveQueueButton:Disable()
    oq.reset_button(PVPReadyDialogEnterBattleButton)
    if (oq._inside_instance ~= 1) then
        oq.make_big(PVPReadyDialogEnterBattleButton)
    end
end

function oq.getpos(f, p)
    if (f == nil) or (f:GetLeft() == nil) then
        return {left = 0, top = 0, width = 10, height = 10}
    end
    if (p == nil) then
        p = tbl.new()
    end
    p.left = ceil(f:GetLeft() - 0.5)
    p.top = ceil(f:GetTop() - 0.5)
    p.width = ceil(f:GetWidth() - 0.5)
    p.height = ceil(f:GetHeight() - 0.5)
    if (f:GetParent() ~= UIParent) then
        p.left = ceil(p.left - f:GetParent():GetLeft() - 0.5)
        p.top = ceil(p.top - f:GetParent():GetTop() - 0.5)
    end
    p.top = abs(p.top)
    return p
end

function oq.center(f)
    local x = ceil(((GetScreenWidth() - f:GetWidth()) / 2) - 0.5)
    local y = ceil(((GetScreenHeight() - f:GetHeight()) / 2) - 0.5)
    f:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', x, -1 * y)
    return f
end

function oq.make_big(f)
    if (_inside_bg) or (f == nil) then
        return
    end
    f._was_vis = f:IsVisible()
    if (not f:IsVisible()) then
        f:Show()
    end
    if (f._is_big) then
        return
    end
    f._is_big = true
    f._original_pos = oq.getpos(f, f._original_pos)
    f._original_level = f:GetFrameLevel()
    f:SetFrameLevel(99)
    f:ClearAllPoints()
    if (f:IsEnabled()) then
        f._original_enable = 1
    else
        f._original_enable = 0
    end
    f:Enable()
    oq.center(oq.setpos(f, 100, 100, 300, 300))

    oq.angry_lil_button(f)
    f:SetScript(
        'PostClick',
        function(self)
            oq.angry_lil_button_done(self)
        end
    )
end

function oq.reset_button(f)
    if (not f._is_big) then
        return
    end
    if (f._original_pos ~= nil) then
        local o = f._original_pos
        oq.setpos(f, o.left, o.top, o.width, o.height)
    end
    if (f._original_level) then
        f:SetFrameLevel(f._original_level)
    end
    if (f._was_vis) then
        f:Show()
    else
        f:Hide()
    end
    if (f._original_enable == 0) then
        f:Disable()
    else
        f:Enable()
    end
    f:SetScript(
        'PostClick',
        function()
        end
    )
    f._is_big = nil
end

function oq.on_leave_queue(ndx)
    StaticPopup_Hide('OQ_QueuePoppedMember')

    -- this may require hardware event
    oq.battleground_leave(tonumber(ndx))
end

function oq.quit_raid()
    if (not _inside_bg) then
        local dialog = StaticPopup_Show('OQ_QuitRaidConfirm')
    end
end

function oq.is_seat_empty(i, j)
    if
        (oq.raid.raid_token == nil) or (oq.raid.group == nil) or (oq.raid.group[i] == nil) or
            (oq.raid.group[i].member == nil) or
            (oq.raid.group[i].member[j] == nil)
     then
        return true
    end
    if
        (oq.raid.group[i].member[j].name == nil) and (oq.raid.group[i].member[j].realm == nil) and
            (oq.raid.group[i].member[j].class == 'XX')
     then
        return true
    end
    return nil
end

function oq.raid_cleanup_slot(i, j)
    if (j == 1) then
        oq.raid.group[i]._last_ping = nil
        oq.raid.group[i]._names = nil
        oq.raid.group[i]._stats = nil
        oq.raid.group[i].member[1].lag = nil
        oq.tab1_group[i].lag:SetText('')
    end
    oq.set_group_member(i, j, nil, nil, 'XX', nil, '0', '0')
    oq.set_deserter(i, j, nil)
    oq.set_role(i, j, OQ.ROLES['NONE'])
    oq.set_textures(i, j)
    -- Commenting this out. Loot method change should be triggered by wow event anyway
    -- OQ_data.loot_method = nil
end

function oq.ui_raidleader()
    if (oq.raid.type == OQ.TYPE_BG) then
        --    oq.tab1_bg[2].queue_button:Show();
        oq.tab1_bg[1].queue_button:Show()
    else
        oq.tab1_bg[1].queue_button:Hide()
        oq.tab1_bg[2].queue_button:Hide()
    end
    oq.tab1._quit_button:SetText(OQ.DISBAND_PREMADE)
    oq.tab1._readycheck_button:Show()
    oq.tab1._rolecheck_button:Show()
    oq.tab1._brb_button:Show()
    oq.tab1._lucky_charms:Show()
    OQMainFrameTab7:Show()
end

function oq.ui_player()
    if (oq.raid.raid_token) and (oq.iam_raid_leader()) then
        oq.ui_raidleader()
        return
    end

    oq.tab1_bg[1].queue_button:Hide()
    oq.tab1_bg[2].queue_button:Hide()
    oq.tab1._quit_button:SetText(OQ.LEAVE_PREMADE)
    oq.tab1._readycheck_button:Hide()
    oq.tab1._rolecheck_button:Hide()
    OQMainFrameTab7:Hide()
    if (my_slot == 0) then
        oq.tab1._brb_button:Hide()
    else
        oq.tab1._brb_button:Show()
    end
    oq.tab1._lucky_charms:Hide()
end

function oq.raid_cleanup()
    -- leave party
    if (oq.iam_in_a_party()) then
        oq._error_ignore_tm = GetTime() + 5
    end

    oq._send_immediate = true
    oq.reject_all_waitlist()
    oq._send_immediate = nil

    oq.set_premade_type(OQ.TYPE_BG)

    for i = 1, 8 do
        oq.tab1_group[i].lag:SetText('')
        for j = 1, 5 do
            oq.raid_cleanup_slot(i, j)
        end
    end

    oq.tab3._create_but:SetText(OQ.CREATE_BUTTON)
    oq.tab1._raid_stats:SetText('')

    -- update status
    if (oq._last_raid_token == nil) then
        oq._last_raid_token = oq.raid.raid_token
    end
    local raid = oq.premades[oq._last_raid_token]
    if (raid) then
        local line = oq.find_premade_entry(oq._last_raid_token)
        if (line) then
            if (raid.status == 2) then -- if inside, disable the waitlist button
                line.req_but:Disable()
            else
                line.req_but:Enable()
            end
        end
    end

    -- clear settings
    tbl.clear(oq.raid, true)
    oq.raid.group = tbl.new()
    for i = 1, 8 do
        oq.raid.group[i] = tbl.new()
        oq.raid.group[i].member = tbl.new()
        for j = 1, 5 do
            oq.raid.group[i].member[j] = tbl.new()
            oq.raid.group[i].member[j].flags = 0
            oq.raid.group[i].member[j].charm = 0
            oq.raid.group[i].member[j].check = OQ.FLAG_CLEAR
            oq.raid.group[i].member[j].bg = tbl.new()
            for k = 1, 2 do
                oq.raid.group[i].member[j].bg[k] = tbl.new()
                oq.raid.group[i].member[j].bg[k].start_tm = 0
                oq.raid.group[i].member[j].bg[k].queue_ts = 0
                oq.raid.group[i].member[j].bg[k].dt = 0
                oq.raid.group[i].member[j].bg[k].confirm_tm = 0
                oq.raid.group[i].member[j].bg[k].status = '0'
            end
        end
    end

    tbl.clear(oq.waitlist, true)
    tbl.clear(oq.names, true)

    my_group = 0
    my_slot = 0
    oq.raid.name = ''
    oq.raid.notes = ''
    oq.raid.voip = 0
    oq.raid.lang = 0

    oq.tab1_name:SetText('')
    oq.tab1._notes:SetText('')
    oq.tab1._voip:SetTexture(nil)
    oq.tab1._lang:SetTexture(nil)

    oq.reform_clear()
    if (oq.ui.battleground_frame) and (oq.ui.battleground_frame._chart) then
        oq.ui.battleground_frame._chart:zero_data()
    end
    oq.update_tab1_common()

    -- remove raid-only procs
    oq.procs_no_raid()

    oq.ui_player()
    oq.set_premade_type(OQ.TYPE_BG)

    -- reset buttons
    PVPReadyDialogEnterBattleButton:Show()
    PVPReadyDialogLeaveQueueButton:Show()
    PVPReadyDialogEnterBattleButton:Enable()
    PVPReadyDialogLeaveQueueButton:Enable()
end

function oq.quit_raid_now()
    --
    -- clear out raid settings
    --
    if (oq.iam_raid_leader()) then
        oq.leader_quit_raid()
    else
        oq.member_quit_raid()
    end
end

function oq.member_quit_raid()
    oq._send_immediate = true
    oq.raid_announce('leave_slot,' .. my_group .. ',' .. my_slot)
    oq._send_immediate = nil

    -- make sure we left any queues we might've been in
    if (not _inside_bg) then
        oq.battleground_leave(1)
        oq.battleground_leave(2)
    end

    -- clean up raid tab
    oq._last_raid_token = oq.raid.raid_token
    LeaveParty()
    oq.raid_init()
    oq.raid_cleanup()
end

function oq.leader_quit_raid()
    oq._send_immediate = true
    oq.raid_disband() -- only triggers if i am raid leader; sends msg and clears waitlist
    oq._send_immediate = nil

    -- make sure we left any queues we might've been in
    if (not _inside_bg) then
    --    oq.battleground_leave(1);
    --    oq.battleground_leave(2);
    end

    -- clean up raid tab
    oq._last_raid_token = oq.raid.raid_token
    oq.raid_init()
    oq.raid_cleanup()
end

function oq.waitlist_clear_token(req_token)
    if (oq.waitlist[req_token] ~= nil) then
        oq.waitlist[req_token]._invited = true
    end
    oq.remove_waitlist(req_token)
end

function oq.UninviteUnit(name)
    UninviteUnit(name)
end

-- TODO remove this, since we will always operate on either only char_name or char_name-realm_short
function oq.InviteUnit(name, realm, req_token)
    oq.log(true, 'oq.InviteUnit - please convert to InviteUnitRealID')
    if (realm == nil) or (realm == player_realm) then
        InviteUnit(name)
    else
        InviteUnit(name .. '-' .. realm)
    end
    oq.waitlist_clear_token(req_token)

    local key = name .. '-' .. realm
    if (oq.pending_invites) and (oq.pending_invites[key]) then
        oq.pending_invites[key] = tbl.delete(oq.pending_invites[key])
    end
    oq.timer('briefing', 3.5, oq.brief_player, nil) -- one shot, but replaced if more members show
    next_invite_tm = 0 -- able to invite another player now
end

function oq.InviteUnitRealID(realId, reqToken)
    if (realId == nil or realId == '' or strlower(realId) == 'nil') then
        return
    end

    InviteUnit(realId)
    oq.waitlist_clear_token(reqToken)

    if (oq.pending_invites) and (oq.pending_invites[realId]) then
        oq.pending_invites[realId] = tbl.delete(oq.pending_invites[realId])
    end
    oq.timer('briefing', 3.5, oq.brief_player, nil) -- one shot, but replaced if more members show
    next_invite_tm = 0 -- able to invite another player now
end

function oq.find_first_available_slot(p)
    if (p == nil) then
        return 0, 0
    end
    -- check to see if player already assigned a slot

    for i = 1, 8 do
        for j = 1, 5 do
            if ((oq.raid.group[i].member[j].name == p.name) and (oq.raid.group[i].member[j].realm == p.realm)) then
                oq.raid.group[i].member[j].charm = 0
                oq.raid.group[i].member[j].check = OQ.FLAG_CLEAR
                return i, j
            end
        end
    end

    for i = 1, 8 do
        for j = 1, 5 do
            if ((oq.raid.group[i].member[j].name == nil) or (oq.raid.group[i].member[j].name == '-')) then
                oq.raid.group[i].member[j].name = p.name -- reserve spot so we don't get overlap due to slow messaging
                oq.raid.group[i].member[j].realm = p.realm
                oq.raid.group[i].member[j].class = 'XX'
                oq.raid.group[i].member[j].charm = 0
                oq.raid.group[i].member[j].check = OQ.FLAG_CLEAR
                return i, j
            end
        end
    end
    return 0, 0
end

function oq.group_invite_slot(req_token, group_id, slot)
    if (not oq.iam_raid_leader()) then
        -- not possible
        return
    end
    --
    -- slot will NOT be 1
    --
    local r = oq.waitlist[req_token]
    if (r == nil) or (r.realid == nil) then
        oq.remove_waitlist(req_token)
        return
    end

    group_id = tonumber(group_id) or 0
    slot = tonumber(slot) or 0
    if (group_id == 0) or (slot == 0) then
        return
    end

    r._expires = oq.utc_time() + 10 -- invite expires in 10 seconds

    if
        ((oq.raid.type ~= OQ.TYPE_BG) and (oq.raid.type ~= OQ.TYPE_RBG) and (oq.raid.type ~= OQ.TYPE_RAID) and
            (oq.raid.type ~= OQ.TYPE_ROLEPLAY) and
            (group_id ~= my_group))
     then
        -- proxy_invite needed
        oq.proxy_invite(group_id, slot, r.name, r.realm, r.realid, req_token)
        oq.timer('brief_leader', 2.5, oq.brief_group_lead, nil, group_id)
        oq.remove_waitlist(req_token)
        return
    end

    -- the 'W' stands for 'whisper' and should not be echo'd far and wide
    local msg_tok = 'W' .. oq.token_gen()
    local g_leader_rid = oq.raid.group[group_id].member[1].realid
    if (g_leader_rid == nil) then
        g_leader_rid = OQ_NOEMAIL
    end

    oq.token_push(msg_tok)
    local enc_data = oq.encode_data('abc123', oq.raid.leader, oq.raid.leader_realm, oq.raid.leader_rid)
    local msg =
        'invite_group,' ..
        req_token ..
            ',' ..
                group_id ..
                    ',' ..
                        slot ..
                            ',' ..
                                oq.encode_name(oq.raid.name) ..
                                    ',' ..
                                        oq.raid.leader_class ..
                                            ',' ..
                                                enc_data ..
                                                    ',' .. oq.raid.raid_token .. ',' .. oq.encode_note(oq.raid.notes)

    r._2binvited = true

    local key = r.realid
    oq.pending_invites = oq.pending_invites or tbl.new()
    oq.pending_invites[key] = tbl.new()
    oq.pending_invites[key].raid_tok = oq.raid.raid_token
    oq.pending_invites[key].gid = group_id
    oq.pending_invites[key].slot = slot
    oq.pending_invites[key].rid = r.realid
    oq.pending_invites[key].req_token = req_token

    local enc_data_ = oq.encode_data('abc123', r.name, r.realm, r.realid)
    oq.reform_keep(r.name, r.realm, enc_data_, req_token)

    oq.XRealmWhisper(r.name, r.realm, msg)
    oq.timer_oneshot(1.0, oq.InviteUnitRealID, r.realid)
end

function oq.group_invite_first_available(req_token)
    if (not oq.iam_raid_leader()) then
        -- not possible
        return
    end
    local r = oq.waitlist[req_token]
    local group_id, slot = oq.find_first_available_slot(r)
    if (group_id == 0) then
        print(L['OQ: no slots available'])
        return
    end
    oq.group_invite_slot(req_token, group_id, slot)
end

--
-- name to whisper.  could be real-id, could be on leader's realm
--
function oq.on_remove(g_id, slot)
    -- remove from cell
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    if ((my_group == g_id) and (my_slot == slot)) then
        -- remove myself
        oq.quit_raid_now()
    end
    oq.raid_cleanup_slot(g_id, slot)
end

function oq.on_new_lead(raid_token, name, realm, rid)
    if (raid_token == nil) or (raid_token ~= oq.raid.raid_token) then
        return
    end
    if (name == player_name) then
        -- i am the new oq leader
    elseif (my_slot == 1) then
    -- send real-id request if needed
    end
    -- update oq leader info
    oq.raid.leader = name
    oq.raid.leader_realm = realm
    oq.raid.leader_rid = rid
end

function oq.new_oq_leader(name, realm, rid)
    oq.raid_announce('new_lead,' .. oq.raid.raid_token .. ',' .. name .. ',' .. realm .. ',' .. tostring(rid or ''))
end

function oq.remove_member(g_id, slot)
    if (not oq.iam_raid_leader()) then
        return
    end
    oq.raid_announce('remove,' .. g_id .. ',' .. slot)
    local m = oq.raid.group[g_id].member[slot]
    local n = m.name
    if (m.realm) and (m.realm ~= player_realm) then
        n = n .. '-' .. m.realm
    end
    oq.UninviteUnit(n)
end

function oq.member_left(g_id, slot)
    oq.raid_cleanup_slot(g_id, slot)
end

function oq.on_classdot_enter(self)
    local gid = self.gid
    local slot = self.slot
    if (gid == nil) or (slot == nil) then
        return
    end
    if (oq.raid.group[gid] == nil) or (oq.raid.group[gid].member[slot] == nil) then
        return
    end
    --
    -- generate tooltip
    --
    local m = oq.raid.group[gid].member[slot]
    if ((m == nil) or (m.name == nil) or (m.name == '-')) then
        return
    end
    oq.tooltip_set2(self, m)
end

function oq.on_classdot_exit()
    oq.tooltip_hide()
end

function oq.on_ladderdot_enter(self)
    local gid = self.gid
    local slot = self.slot
    print('[on_ladderdot_enter] ' .. gid .. ' . ' .. slot)
    --
    -- generate tooltip
    --
    local m = oq.raid.group[gid].member[slot]
    if ((m == nil) or (m.name == nil) or (m.name == '-')) then
        return
    end
    oq.tooltip_set2(self, m)
end

function oq.on_ladderdot_exit()
    oq.tooltip_hide()
end

function oq.btag_link(desc, name, realm, btag)
    local str =
        '|cFF808080' ..
        desc ..
            '|r |Hbtag:' ..
                tostring(strlower(btag or '')) ..
                    ':' .. oq.utc_time() .. '|h' .. tostring(name or '') .. '-' .. tostring(realm or '') .. '|h'
    return str
end

function oq.btag_link2(desc, name, realm, btag)
    local str =
        '|Hbtag:' ..
        tostring(strlower(btag)) ..
            ':' .. oq.utc_time() .. '|h' .. tostring(name) .. '-' .. tostring(realm) .. ' |cFF808080' .. desc .. '|r |h'
    return str
end

function oq.btag_link3(desc, name_realm, btag)
    local str =
        '|Hbtag:' ..
        tostring(strlower(btag)) ..
            ':' .. oq.utc_time() .. '|h' .. tostring(name_realm) .. ' |cFF808080' .. desc .. '|r |h'
    return str
end

function oq.on_btag(name, realm_id, rid, stats)
    _ok2relay = 1
    realm_id = tonumber(realm_id)
    local g, s = oq.find_members_seat(oq.raid.group, name)
    if (g) then
        local p = oq.raid.group[g].member[s]
        p.name, p.realm_id, p.realm = oq.name_sanity(p.name, p.realm_id)
        p.realid = strlower(rid)
        if (stats) and (stats:find('#') == nil) then
            local demos = oq.decode_their_stats(p, stats)
        end
    end
end

function oq.on_need_btag(name, realm)
    _ok2relay = 1
    if (name == player_name) and (realm == player_realm) and (oq.player_realid ~= nil) then
        oq._sender = nil -- clear to allow it to be sent
        oq.raid_announce('btag,' .. player_name .. ',' .. oq.GetRealmID(player_realm) .. ',' .. oq.player_realid)
    end
end

function oq.on_classdot_promote(g_id, slot)
    -- promote to group lead
    local m1 = oq.raid.group[g_id].member[1]
    local m2 = oq.raid.group[g_id].member[slot]
    local req_token = 'D' .. oq.token_gen()
    oq.token_push(req_token) -- hang onto it for return
    if (m2.realid == nil) or (m2.realid == '') then
        print(OQ.LILREDX_ICON .. '' .. OQ.NOBTAG_01)
        print(OQ.LILREDX_ICON .. '' .. OQ.NOBTAG_02)
        return
    end

    if (g_id == 1) then
        -- push as new oq-leader
        oq.new_oq_leader(m2.name, m2.realm, m2.realid)
        -- need to manually push the promote
        oq.raid_announce(
            'promote,' ..
                g_id ..
                    ',' ..
                        m2.name ..
                            ',' ..
                                m2.realm .. ',' .. tostring(m2.realid) .. ',' .. tostring(m2.realm) .. ',' .. req_token
        )
        oq.on_promote(g_id, m2.name, m2.realm, m2.realid, m2.realm, req_token)
        oq.ui_player()
    else
        oq.raid_announce(
            'promote,' ..
                g_id ..
                    ',' ..
                        m2.name .. ',' .. m2.realm .. ',' .. oq.player_realid .. ',' .. player_realm .. ',' .. req_token
        )
    end
    -- update info
    oq.set_group_lead(g_id, m2.name, m2.realm, m2.class, m2.realid)
    oq.set_name(g_id, slot, m1.name, m1.realm, m1.class, m1.realid)
end

function oq.is_my_toon(name, realm)
    if (realm ~= player_realm) then
        return nil
    end
    name = strlower(name)

    for _, v in pairs(oq.toon.my_toons) do
        if (name == strlower(v.name)) then
            return true
        end
    end
    return nil
end

function oq.on_classdot_menu_select(g_id, slot, action)
    if (action == 'promote') then
        local p = oq.raid.group[g_id].member[slot]
        if (oq.is_my_toon(p.name, p.realm)) then
            p.realid = oq.player_realid
        end
        if (p.realid == nil) or (p.realid == '') then
            -- delay to allow btag to be delivered
            oq.timer_oneshot(2, oq.on_classdot_promote, g_id, slot)
        else
            oq.on_classdot_promote(g_id, slot)
        end
    elseif (action == 'ban') then
        local m = oq.raid.group[tonumber(g_id)].member[tonumber(slot)]
        local dialog = StaticPopup_Show('OQ_BanUser', m.realid)
        if (dialog ~= nil) then
            dialog.data2 = {flag = 1, gid = g_id, slot_ = slot}
        end
    elseif (action == 'friend') then
        local m = oq.raid.group[tonumber(g_id)].member[tonumber(slot)]
        local isFriend = oq.IsFriend(m.realid)
        if (isFriend) then
            print(OQ.LILTRIANGLE_ICON .. ' ' .. string.format(OQ.ALREADY_FRIENDED, m.realid))
        else
            AddFriend(m.realid)
        end
    elseif (action == 'kick') then
        oq.remove_member(g_id, slot)
    elseif (type(action) == 'number') then
        oq.leader_set_charm(g_id, slot, action)
    end
end

local _dropdown_options = {
    {val = 'promote', f = 0x10, msg = OQ.DD_PROMOTE},
    {val = 'spacer', f = 0x10, msg = '---------------', notClickable = 1},
    {val = 1, f = 0x04, msg = OQ.STAR_ICON .. '  ' .. OQ.DD_STAR},
    {val = 2, f = 0x04, msg = OQ.CIRCLE_ICON .. '  ' .. OQ.DD_CIRCLE},
    {val = 3, f = 0x04, msg = OQ.BIGDIAMOND_ICON .. '  ' .. OQ.DD_DIAMOND},
    {val = 4, f = 0x04, msg = OQ.TRIANGLE_ICON .. '  ' .. OQ.DD_TRIANGLE},
    {val = 5, f = 0x04, msg = OQ.MOON_ICON .. '  ' .. OQ.DD_MOON},
    {val = 6, f = 0x04, msg = OQ.SQUARE_ICON .. '  ' .. OQ.DD_SQUARE},
    {val = 7, f = 0x04, msg = OQ.REDX_ICON .. '  ' .. OQ.DD_REDX},
    {val = 8, f = 0x04, msg = OQ.SKULL_ICON .. '  ' .. OQ.DD_SKULL},
    {val = 0, f = 0x04, msg = OQ.DD_NONE},
    {val = 'spacer2', f = 0x20, msg = '---------------', notClickable = 1},
    {val = 'kick', f = 0x20, msg = OQ.DD_KICK},
    {val = 'friend', f = 0x08, msg = OQ.TT_FRIEND_REQUEST},
    {val = 'ban', f = 0x08, msg = OQ.DD_BAN}
}
function oq.make_classdot_dropdown(cell)
    local options = _dropdown_options
    local mask = 0x01 -- member
    if (my_slot == 1) then
        mask = mask + 0x02 -- group leader
    end
    if (my_group == 1) and (my_slot == 1) then
        mask = mask + 0x04 -- oq leader
        if (cell.slot ~= 1) then
            mask = mask + 0x10 -- NOT group leader
        end
        if (my_group ~= cell.gid) or (my_slot ~= cell.slot) then
            mask = mask + 0x20 -- i'm OQ leader but not clicking on my cell
        end
    end
    -- only available to raidleader in bg premade and only if clicking a group leader's cell
    if (oq.raid.type == OQ.TYPE_BG) and (my_slot == 1) and (my_group == 1) and (cell.slot == 1) then
        mask = mask + 0x40
    end
    if (my_group ~= cell.gid) or (my_slot ~= cell.slot) then
        mask = mask + 0x08 -- not my cell
    end

    oq.menu_create()

    for _, v in pairs(options) do
        if (oq.is_set(v.f, mask)) then
            local func = nil
            if (v.notClickable == nil) then
                func = function(_, arg1, arg2)
                    oq.on_classdot_menu_select(arg2.gid, arg2.slot, arg1)
                end
            end
            oq.menu_add(v.msg, v.val, cell, nil, func)
        end
    end
    oq.menu_show_at_cursor(150, 20, 0)

    local p = oq.raid.group[cell.gid].member[cell.slot]
    if ((p.realid == nil) or (p.realid == '')) and (p.name ~= nil) and (p.realm ~= nil) then
        oq._sender = nil
        oq.raid_announce('need_btag,' .. p.name .. ',' .. p.realm)
    end
end

function oq.cell_occupied(g_id, slot)
    if (oq.raid.group[g_id] == nil) or (oq.raid.group[g_id].member[slot] == nil) then
        return nil
    end
    local m = oq.raid.group[g_id].member[slot]
    if ((m == nil) or (m.name == nil) or (m.name == '') or (m.name == '-')) then
        return nil
    end
    return true
end

function oq.my_cell(gid, slot)
    return ((my_group == gid) and (my_slot == slot))
end

function oq.target_cell_player(cell)
    local m = oq.raid.group[cell.gid].member[cell.slot]
    if (m == nil) or (m.name == nil) or (m.name == '-') then
        return
    end

    if (m.name == player_name) then
        TargetUnit('player')
        return
    end

    local n, key, r
    for i = 1, 4 do
        key = 'party' .. tostring(i)
        n, r = UnitName(key)
        if (n) and (n == m.name) then
            TargetUnit(key)
            return
        end
    end
    for i = 1, 40 do
        key = 'raid' .. tostring(i)
        n, r = UnitName(key)
        if (n) and (n == m.name) then
            TargetUnit(key)
            return
        end
    end
end

function oq.on_classdot_click(cell, button)
    if (button == 'LeftButton') then
        --    oq.target_cell_player(cell);
        return
    end
    if (oq.iam_raid_leader() and oq.cell_occupied(cell.gid, cell.slot)) then
        cell:SetPoint('Center', UIParent, 'Center')
        oq.make_classdot_dropdown(cell)
        cell:SetHeight(cell.cy) -- forcing hieght; EasyMenu seems to resize the cell for some reason
    elseif oq.cell_occupied(cell.gid, cell.slot) and not oq.my_cell(cell.gid, cell.slot) then
        cell:SetPoint('Center', UIParent, 'Center')
        oq.make_classdot_dropdown(cell)
        cell:SetHeight(cell.cy) -- forcing hieght; EasyMenu seems to resize the cell for some reason
    end
end

function oq.create_class_dot(parent, x, y, cx, cy)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'CDotRegion'
    local f = oq.panel(parent, n, x, y, cx, cy)
    local val = 5
    if (oq.__backdrop25 == nil) then
        oq.__backdrop25 = {
            bgFile = 'Interface/Tooltips/CHATBUBBLE-BACKGROUND',
            edgeFile = nil,
            tile = true,
            tileSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 2}
        }
    end
    f:SetBackdrop(nil)
    f.cy = cy
    f.gid = 0
    f.slot = 0
    n = 'DotTexture' .. oq.nthings
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(0.2, 0.2, 0.0, 1)

    -- label
    f.txt = oq.label(f, 0, 0, cx, cy, '', 'MIDDLE', 'CENTER', nil, 'OVERLAY')
    f.txt:SetFont(OQ.FONT, 8, '')
    f.txt:Hide()

    -- deserter
    f.status = f:CreateTexture(n .. 'Deserter', 'OVERLAY')
    --  f.status:SetPoint("TOPLEFT", f,"TOPLEFT", 2, -3);
    --  f.status:SetPoint("BOTTOMRIGHT", f,"BOTTOMRIGHT", -2, 3);
    f.status:SetPoint('TOPLEFT', f, 'TOPLEFT', -2, 1)
    f.status:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 2, -3)
    f.status:SetTexture(nil)

    -- class
    f.class = f:CreateTexture(n .. 'Class', 'OVERLAY')
    f.class:SetPoint('TOPLEFT', f, 'CENTER', -8, -8)
    f.class:SetPoint('BOTTOMRIGHT', f, 'CENTER', 8, 8)
    f.class:SetTexture(nil)

    -- role
    f.role = f:CreateTexture(n .. 'Role', 'OVERLAY')
    f.role:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -14, 14)
    f.role:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 4, -4)
    f.role:SetTexture(nil)

    -- lucky charm
    f.charm = f:CreateTexture(n .. 'Charm', 'OVERLAY')
    f.charm:SetPoint('TOPLEFT', f, 'TOPLEFT', -3, 3)
    f.charm:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -15, 15)
    f.charm:SetTexture(nil)

    -- add tooltip event handler
    --
    f:SetScript(
        'OnEnter',
        function(self)
            oq.on_classdot_enter(self)
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            oq.on_classdot_exit(self)
        end
    )

    f:SetScript(
        'OnMouseUp',
        function(self, frame)
            oq.on_classdot_click(self, frame)
        end
    )

    oq.moveto(f, x, y)
    f:SetSize(cx, cy)
    f:Show()
    return f
end

function oq.create_dungeon_dot(parent, x, y, cx, cy)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'DotRegion'
    local f = oq.panel(parent, n, x, y, cx, cy)
    local val = 5
    f.cy = cy
    f.gid = 0
    f.slot = 0

    n = 'DotTexture' .. oq.nthings
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(0.2, 0.2, 0.0, 1)

    -- label
    f.txt = oq.label(f, 0, 0, cx, cy, '', 'MIDDLE', 'CENTER', nil, 'OVERLAY')
    f.txt:SetFont(OQ.FONT, 8, '')
    f.txt:Hide()

    -- status
    f.status = f:CreateTexture(n .. 'Deserter', 'OVERLAY')
    f.status:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -25, 16)
    f.status:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -1, -8)

    f.status:SetTexture(nil)

    -- class
    f.class = f:CreateTexture(n .. 'Class', 'OVERLAY')
    f.class:SetPoint('TOPLEFT', f, 'TOPLEFT', -17, -12)
    f.class:SetPoint('BOTTOMRIGHT', f, 'TOPLEFT', -1, -28)
    f.class:SetTexture(nil)

    -- role
    f.role = f:CreateTexture(n .. 'Role', 'OVERLAY')
    f.role:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 1, 14)
    f.role:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 17, -4)
    f.role:SetTexture(nil)

    -- lucky charm
    f.charm = f:CreateTexture(n .. 'Charm', 'OVERLAY')
    f.charm:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 19, 14)
    f.charm:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 35, -2)
    f.charm:SetTexture(nil)

    -- add tooltip event handler
    --
    f:SetScript(
        'OnEnter',
        function(self)
            oq.on_classdot_enter(self)
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            oq.on_classdot_exit(self)
        end
    )

    f:SetScript(
        'OnMouseUp',
        function(self, frame)
            oq.on_classdot_click(self, frame)
        end
    )

    --  unable to allow player to target party members
    --  f:SetAttribute("type"     , "macro");
    --  f:SetAttribute("macrotext", "/script print('worked')");

    oq.moveto(f, x, y)
    f:SetSize(cx, cy)
    f:Show()
    return f
end

function oq.create_challenge_dot(parent, x, y, cx, cy)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'DotRegion'
    local f = oq.panel(parent, n, x, y, cx, cy)
    local val = 5

    f.cy = cy

    f.gid = 0
    f.slot = 0
    n = 'DotTexture' .. oq.nthings
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(0.2, 0.2, 0.0, 1)

    -- label
    f.txt = oq.label(f, 0, 0, cx, cy, '', 'MIDDLE', 'CENTER', nil, 'OVERLAY')
    f.txt:SetFont(OQ.FONT, 8, '')
    f.txt:Hide()

    -- status
    f.status = f:CreateTexture(n .. 'Deserter', 'OVERLAY')
    f.status:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -25, 16)
    f.status:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -1, -8)

    f.status:SetTexture(nil)

    -- class
    f.class = f:CreateTexture(n .. 'Class', 'OVERLAY')
    f.class:SetPoint('TOPLEFT', f, 'TOPLEFT', -17, -12)
    f.class:SetPoint('BOTTOMRIGHT', f, 'TOPLEFT', -1, -28)
    f.class:SetTexture(nil)

    -- role
    f.role = f:CreateTexture(n .. 'Role', 'OVERLAY')
    f.role:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 1, 14)
    f.role:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 17, -4)
    f.role:SetTexture(nil)

    -- lucky charm
    f.charm = f:CreateTexture(n .. 'Charm', 'OVERLAY')
    f.charm:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 19, 14)
    f.charm:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 35, -2)
    f.charm:SetTexture(nil)

    -- add tooltip event handler
    --
    f:SetScript(
        'OnEnter',
        function(self)
            oq.on_classdot_enter(self)
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            oq.on_classdot_exit(self)
        end
    )

    f:SetScript(
        'OnMouseUp',
        function(self, button)
            oq.on_classdot_click(self, button)
        end
    )

    oq.moveto(f, x, y)
    f:SetSize(cx, cy)
    f:Show()
    return f
end

function oq.on_ladderdot_click(cell)
    if (oq.iam_raid_leader() and oq.cell_occupied(cell.gid, cell.slot)) then
        cell:SetPoint('Center', UIParent, 'Center')
        oq.make_classdot_dropdown(cell)
        cell:SetHeight(cell.cy) -- forcing hieght; EasyMenu seems to resize the cell for some reason
    elseif oq.cell_occupied(cell.gid, cell.slot) and not oq.my_cell(cell.gid, cell.slot) then
        cell:SetPoint('Center', UIParent, 'Center')
        oq.make_classdot_dropdown(cell)
        cell:SetHeight(cell.cy) -- forcing hieght; EasyMenu seems to resize the cell for some reason
    end
end

function oq.create_ladder_dot(parent, x, y, cx, cy)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'DotRegion'
    local f = oq.panel(parent, n, x, y, cx, cy)
    local val = 5

    f.cy = cy

    f.gid = 0
    f.slot = 0
    n = 'DotTexture' .. oq.nthings
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(0.2, 0.2, 0.0, 1)

    -- status
    f.status = f:CreateTexture(n .. 'Deserter', 'OVERLAY')
    f.status:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -25, 16)
    f.status:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -1, -8)

    f.status:SetTexture(nil)

    -- class
    f.class = f:CreateTexture(n .. 'Class', 'OVERLAY')
    f.class:SetPoint('TOPLEFT', f, 'TOPLEFT', -17, -12)
    f.class:SetPoint('BOTTOMRIGHT', f, 'TOPLEFT', -1, -28)
    f.class:SetTexture(nil)

    -- role
    f.role = f:CreateTexture(n .. 'Role', 'OVERLAY')
    f.role:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 1, 14)
    f.role:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 17, -4)
    f.role:SetTexture(nil)

    -- lucky charm
    f.charm = f:CreateTexture(n .. 'Charm', 'OVERLAY')
    f.charm:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 19, 14)
    f.charm:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 35, -2)
    f.charm:SetTexture(nil)

    -- add tooltip event handler
    --
    f.on_dot_enter = oq.on_ladderdot_enter
    f.on_dot_exit = oq.on_ladderdot_exit
    f.on_dot_click = oq.on_ladderdot_click
    f:SetScript(
        'OnEnter',
        function(self)
            self.on_dot_enter(self)
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            self.on_dot_exit(self)
        end
    )

    f:SetScript(
        'OnMouseUp',
        function(self, button)
            self.on_dot_click(self, button)
        end
    )

    oq.moveto(f, x, y)
    f:SetSize(cx, cy)
    f:Show()
    return f
end

function oq.create_ladder_seat(parent, x, y, cx, cy)
    oq.nthings = (oq.nthings or 0) + 1
    local f = oq.panel(parent, "DotRegion", x, y, cx, cy)

    f.cy = cy

    f.ndx = 0
    f.texture:SetAllPoints(f)
    f.texture:SetTexture(0.2, 0.2, 0.0, 1)

    oq.moveto(f, x, y)
    f:SetSize(cx, cy)
    f:Show()
    return f
end

function oq.create_group(parent, x, y, cx, cy, _, title, group_id)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'GroupRegion'
    local f = oq.panel(parent, n, x, y, cx, cy)

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)

    f.gid = oq.label(f, 2, 2, 16, cy - 8, title)

    f.realm = oq.label(f, 50, 2, 75, cy - 8, '-')
    f.realm:SetTextColor(0.6, 0.6, 0.6)
    f.leader = oq.label(f, 135, 2, 125, cy - 8, '-')
    f.leader:SetFont(OQ.FONT, 12, '')
    f.lag = oq.label(f, 135, 2, 120, cy - 8, '-')
    f.lag:SetTextColor(0.7, 0.7, 0.7, 1)
    f.lag:SetFont(OQ.FONT, 8, '')
    f.lag:SetJustifyV('BOTTOM')
    f.lag:SetJustifyH('RIGHT')

    f.slots = tbl.new()
    local cx = cy - 2 * 2 -- to make them square

    for i = 1, 5 do
        f.slots[i] = oq.create_class_dot(f, 255 + 5 + (cx + 4) * (i - 1), 2, cx, cy - 2 * 2)
        f.slots[i].gid = group_id
        f.slots[i].slot = i
    end
    f:Show()
    return f
end

function oq.create_dungeon_group(parent, x_, y_, ix, iy, _, title, group_id)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'GroupRegion'
    local f = oq.panel(parent, n, x_, y_, ix, iy)

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)
    f.texture:SetAllPoints(f)

    local cy = iy - 2 * 5
    local cx = floor((ix - 4 * 10 - 2 * 10) / 5)

    f.gid = oq.label(f, 2, 2, 16, cy - 8, title)

    f.slots = tbl.new()
    local x = 10

    for i = 1, 5 do
        f.slots[i] = oq.create_dungeon_dot(f, x, 5, cx, cy)
        f.slots[i].gid = group_id
        f.slots[i].slot = i
        x = x + cx + 10
    end

    f:Show()
    return f
end

function oq.create_challenge_group(parent, x_, y_, ix, iy, _, title, group_id)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'GroupRegion'
    local f = oq.panel(parent, n, x_, y_, ix, iy)

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)
    f.texture:SetAllPoints(f)

    local cy = iy - 2 * 5
    local cx = floor((ix - 4 * 10 - 2 * 10) / 5)

    f.gid = oq.label(f, 2, 2, 16, cy - 8, title)

    f.slots = tbl.new()
    local x = 10

    for i = 1, 5 do
        f.slots[i] = oq.create_challenge_dot(f, x, 5, cx, cy)
        f.slots[i].gid = group_id
        f.slots[i].slot = i
        x = x + cx + 10
    end

    f:Show()
    return f
end

function oq.create_scenario_group(parent, x, y, ix, iy, _, title, group_id)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'GroupRegion'
    local f = oq.panel(parent, n, x, y, ix, iy)

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)
    f.texture:SetAllPoints(f)

    local cy = iy - 2 * 5
    local cx = floor((ix - 4 * 10 - 2 * 10) / 5)

    f.gid = oq.label(f, 2, 2, 16, cy - 8, title)
    f.slots = tbl.new()
    local x = 10

    x = x + cx + 10 -- bump ahead one panel to center it
    for i = 1, 3 do
        f.slots[i] = oq.create_dungeon_dot(f, x, 5, cx, cy)
        f.slots[i].gid = group_id
        f.slots[i].slot = i
        x = x + cx + 10
    end
    f:Show()
    return f
end

function oq.create_arena_group(parent, x_, y_, ix, iy, label_cx, title, group_id)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'ArenaRegion'
    local f = oq.panel(parent, n, x_, y_, ix, iy)

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)
    f.texture:SetAllPoints(f)

    local cy = iy - 2 * 5
    local cx = floor((ix - 4 * 10 - 2 * 10) / 5)

    f.gid = oq.label(f, 2, 2, 16, cy - 8, title)

    f.slots = tbl.new()
    local x = 10

    for i = 1, 5 do
        f.slots[i] = oq.create_dungeon_dot(f, x, 5, cx, cy)
        f.slots[i].gid = group_id
        f.slots[i].slot = i
        x = x + cx + 10
    end

    f:Show()
    return f
end

function oq.create_ladder_group(parent, x_, y_, ix, iy, _, title, group_id)
    oq.nthings = (oq.nthings or 0) + 1
    local n = 'LadderRegion'
    local f = oq.panel(parent, n, x_, y_, ix, iy)

    f.texture:SetTexture(0.0, 0.0, 0.0, 1)
    f.texture:SetAllPoints(f)

    local cy = 16
    local cx = 16

    f.gid = oq.label(f, 2, 2, 16, cy - 8, title)

    f.slots = tbl.new()
    local x
    local y = (iy / 2) - 2 * (cy + 2)
    local ndx = 2
    for _ = 1, 4 do
        x = (ix / 2) - 2 * (cx + 2)
        for _ = 1, 4 do
            f.slots[ndx] = oq.create_ladder_dot(f, x, y, cx, cy)
            f.slots[ndx].gid = group_id
            f.slots[ndx].slot = ndx
            x = x + cx + 2
            ndx = ndx + 1
        end
        y = y + cy + 2
    end

    f.slots[1] = oq.create_ladder_dot(f, (ix - cx) / 2, 10, cx, cy) -- referee / ladder owner
    f.slots[1].gid = group_id
    f.slots[1].slot = 1

    f:Show()
    return f
end

function oq.on_premade_item_enter(self)
    oq.pm_tooltip_set(self, self.token)
    if (self._highlight) then
        self._highlight:SetVertexColor(255 / 255, 255 / 255, 192 / 255)
        self._highlight:Show()
    end
end

function oq.on_premade_item_exit(self)
    oq.pm_tooltip_hide()
    if (self._highlight) then
        if (self.req_but:GetText() == OQ.BUT_PENDING) then
            self._highlight:SetVertexColor(0 / 255, 225 / 255, 0 / 255)
            self._highlight:Show()
        else
            self._highlight:SetVertexColor(255 / 255, 255 / 255, 192 / 255)
            self._highlight:Hide()
        end
    end
end

function oq.on_premade_item_click(self, button)
    if (button == 'LeftButton') then
        local r = oq.premades[self.raid_token]
        if (r) then
            if (Icebox) then
                Icebox.armory(r.leader, r.leader_realm)
            end
        end
    end
    if (button ~= 'LeftButton') or (not IsControlKeyDown()) then
        return
    end
    if (self.raid_token) then
        local r = oq.premades[self.raid_token]
        if (r) then
            local url =
                string.format('https://tauriwow.com/armory#character-sheet.xml?r=%s&n=%s', r.leader_realm, r.leader)
            local dialog = StaticPopup_Show('OQ_ArmoryPopup', url)
            if (dialog ~= nil) then
                dialog.data = url
                dialog.text:SetJustifyH('LEFT')
                dialog.editBox:SetText(url)
                dialog.editBox:HighlightText()
            end
        end
    end
end

function oq.on_waitlist_item_click(self, button)
    if (button == 'LeftButton') then
        local r = oq.waitlist[self.token]
        if (r) then
            if (Icebox) then
                Icebox.armory(r.name, r.realm)
            end
        end
    end
    if (button ~= 'LeftButton') or (not IsControlKeyDown()) then
        return
    end
    if (self.token) then
        local r = oq.waitlist[self.token]
        if (r) then
            local url = string.format('https://tauriwow.com/armory#character-sheet.xml?r=%s&n=%s', r.realm, r.name)
            local dialog = StaticPopup_Show('OQ_ArmoryPopup', url)
            if (dialog ~= nil) then
                dialog.data = url
                dialog.text:SetJustifyH('LEFT')
                dialog.editBox:SetText(url)
                dialog.editBox:HighlightText()
            end
        end
    end
end

function oq.orbit_show(f)
    if (f.__orbit == nil) then
        f.__orbit = oq.CreateFrame('Frame', 'oQueueModel', f)
        f.__orbit:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
        f.__orbit:SetFrameStrata('HIGH')
    end
    local o = f.__orbit
    o._size = 30
    o._alpha = 0
    o._r = 45
    o._hypotenuse = UIParent:GetEffectiveScale() * (GetScreenWidth() ^ 2 + GetScreenHeight() ^ 2) ^ 0.5

    if (f:GetName() == 'oqlongtooltip') then
        o._adjx = 65
        o._adjy = 270
    elseif (f:GetName() == 'oqtooltip') then
        o._adjx = 60
        o._adjy = 230
    elseif (f:GetName() == 'oqpmtooltip') then
        o._adjx = 60
        o._adjy = 205
    end

    o._ctrx = floor(f:GetWidth() / 2) - o._adjx
    o._ctry = floor(f:GetHeight() - o._adjy)

    o._offx = o._r * cos(o._alpha)
    o._offy = o._r * sin(o._alpha)
    local n = floor(o._size / 2)
    o:SetWidth(o._size)
    o:SetHeight(o._size)
    o:SetPoint('TOPRIGHT', o:GetParent(), 'BOTTOMLEFT', o._offx - n, o._offy - n)
    o:SetPoint('BOTTOMLEFT', o:GetParent(), 'BOTTOMLEFT', o._offx + n, o._offy + n)
    o:Show()
    if (o.__model == nil) then
        o.__model = oq.CreateFrame('Model', 'oQueueModel', o)

        if (o.__model == nil) or (o.__model.SetAllPoints == nil) then
            -- error; clean up and eject
            f.__orbit:Hide()
            f.__orbit.__model = oq.DeleteFrame(f.__orbit.__model)
            f.__orbit = oq.DeleteFrame(f.__orbit)
            return
        end
        o.__model:SetAllPoints(o)
    end
    local m = o.__model
    m:SetLight(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) -- Allows trails like warriors' intervene to work
    m:SetModel('spells\\soulshatter_missile.mdx')
    m._Scale = 0.025
    m._size = 75
    local Facing = 0
    m:SetModelScale(m._Scale)
    m:SetFacing(Facing)
    m:SetFrameStrata('TOOLTIP')
    m:Show()

    f:SetScript(
        'OnUpdate',
        function(self)
            oq.orbit_update(self)
        end
    )
end

function oq.orbit_update(f)
    if (f.__orbit ~= nil) then
        local o = f.__orbit

        -- counter-clockwise
        --    o._alpha = (((o._alpha or 0) + 3) % 360);

        -- clockwise
        o._alpha = o._alpha - 3
        if (o._alpha <= 0) then
            o._alpha = 359
        end

        o._offx = o._ctrx + o._r * cos(o._alpha)
        o._offy = o._ctry + o._r * sin(o._alpha)
        local n = floor(o._size / 2)
        o:SetPoint('TOPRIGHT', o:GetParent(), 'BOTTOMLEFT', o._offx - n, o._offy - n)
        o:SetPoint('BOTTOMLEFT', o:GetParent(), 'BOTTOMLEFT', o._offx + n, o._offy + n)

        local m = f.__orbit.__model
        m:SetPosition(o._offx / o._hypotenuse, o._offy / o._hypotenuse)
        m:Show()
    end
end

function oq.orbit_hide(f)
    if (f.__orbit ~= nil) then
        f.__orbit:Hide()
        f.__orbit.__model:Hide()
    end
    f:SetScript('OnUpdate', nil)
end

function oq.toggle_raid_scroll(state)
    if (state == 0) then
        oq._scroll_paused = nil
        oq.reshuffle_premades_now() -- force the reshuffle
        oq.tab2_paused.label:SetTextColor(111 / 255, 111 / 255, 111 / 255, 1)
        oq.tab2_paused.label:SetText(L['Pause'])
    else
        oq._scroll_paused = 1
        oq.tab2_paused.label:SetTextColor(247 / 255, 207 / 255, 131 / 255, 1)
        oq.tab2_paused.label:SetText(L['** PAUSED **'])
    end
end

function oq.timed_pause(self, button)
    -- toggle: off
    if (button == 'RightButton') or (oq.tab2_paused._bar:IsVisible()) then
        oq.toggle_raid_scroll(0)
        return
    end

    -- toggle: on
    oq.toggle_raid_scroll(1)
    self._bar.max_cnt = (OQ_data.pause_dmswitch or 10) * 20 -- 15 seconds, 20 updates/sec
    self._bar.cnt = self._bar.max_cnt
    self._bar:SetWidth(self:GetWidth())
    oq.tab2_paused._bar:Show()
    oq.timer('pause_bar', 0.05, oq.pause_bar_render, true, self)
end

function oq.pause_bar_render(self)
    self._bar.cnt = max(0, self._bar.cnt - 1)
    local cx = floor(self:GetWidth() * self._bar.cnt / self._bar.max_cnt)
    self._bar:SetWidth(cx)
    if (self._bar.cnt == 0) or (oq._scroll_paused == nil) then
        oq.toggle_raid_scroll(0)
        oq.tab2_paused._bar:Hide()
        return 1 -- kill timer
    end
end

function oq.hook_modifier(f)
    f:RegisterEvent('MODIFIER_STATE_CHANGED')
    f:SetScript(
        'OnEvent',
        function(self, event, ...)
            if self[event] then
                return self[event](...)
            end
        end
    )
    function f.MODIFIER_STATE_CHANGED(...)
        local key, state = ...
        if (f:IsVisible()) and (key == 'LSHIFT' or key == 'RSHIFT') then
            oq.toggle_raid_scroll(state)
        end
    end
end

function oq.unhook_modifier(f)
    f:UnregisterEvent('MODIFIER_STATE_CHANGED')
end

function oq.find_lost_row(token)
    for i, v in pairs(oq.__frame_pool['#check']) do
        if (v:find('listingregion')) then
            if (i.raid_token == token) then
                return i
            end
        end
    end
end

function oq.remove_wayward_rows()
    for i, v in pairs(oq.__frame_pool['#check']) do
        if (v:find('listingregion')) then
            if (i.raid_token) and (oq.premades[i.raid_token] == nil) then
                oq.DeleteFrame(i)
            end
        end
    end
end

function oq.create_premade_listing(parent, x, y, cx, cy, token, type)
    local r = oq.premades[token]
    if (r == nil) then
        return
    end
    if (r._row == nil) then
        -- search before creating
        r._row = oq.find_lost_row(token)
        if (r._row == nil) then
            -- not found, create
            r._row = oq.click_panel(parent, 'ListingRegion', x, y, cx, cy, true)
            r._row.token = token
            r._row.raid_token = token
        end
    end

    r._row.cy = cy
    --
    -- hilight
    --
    local f = r._row
    if (f._highlight == nil) then
        local t = f:CreateTexture(nil, 'BACKGROUND')
        t:SetDrawLayer('BACKGROUND')
        t:SetTexture('INTERFACE/QUESTFRAME/UI-QuestTitleHighlight')
        t:SetPoint('TOPLEFT', -5, 0, 'TOPLEFT', 0, 0)
        t:SetPoint('BOTTOMRIGHT', 5, 0, 'BOTTOMRIGHT', 0, 0)
        t:SetAlpha(0.6)
        t:Hide()
        f._highlight = t
    else
        f._highlight:SetVertexColor(255 / 255, 255 / 255, 192 / 255)
        f._highlight:Hide()
    end

    local x2 = 0

    f.voip = f.voip or f:CreateTexture(nil, 'OVERLAY')
    oq.setpos(f.voip, x2, 2, 18, 18)
    f.voip:SetAlpha(0.8)
    f.voip:SetTexture(OQ.VOIP_ICON[VOIP_UNSPECIFIED])
    x2 = x2 + 20 + 2

    f.lang = f.lang or f:CreateTexture(nil, 'OVERLAY')
    oq.setpos(f.lang, x2, 5, 18, 14)
    f.lang:SetAlpha(0.8)
    f.lang:SetTexture(OQ.LANG_ICON[OQ.LANG_UNSPECIFIED])
    x2 = x2 + 20 + 3

    f.raid_name = f.raid_name or oq.label(f, x2, 2, 175, cy, '')
    x2 = x2 + 185
    f.raid_name:SetFont(OQ.FONT, 11, '')

    --
    -- dragon
    --
    f.dragon = f.dragon or f:CreateTexture(nil, 'OVERLAY')
    oq.setpos(f.dragon, x2, 0, 32, 32)
    f.dragon:SetTexture(nil)

    f.leader = f.leader or oq.label(f, x2, 2, 90, cy, '')
    x2 = x2 + 90
    f.leader:SetFont(OQ.FONT, 11, '')
    f.leader:SetTextColor(0.9, 0.9, 0.9)
    f.leader:SetText(r.leader or '')

    f.levels = f.levels or oq.label(f, x2, 2, 45, cy, '')
    x2 = x2 + 45 + 2 -- keep these 2 lines balanced to line up
    f.min_ilvl = f.min_ilvl or oq.label(f, x2, 2, 40, cy, '-')
    x2 = x2 + 40 - 2 -- keep these 2 lines balanced to line up
    f.min_resil = f.min_resil or oq.label(f, x2, 2, 2 * 48, cy, '-')
    x2 = x2 + 45 -- extra wide for dungeon icons
    f.min_mmr = f.min_mmr or oq.label(f, x2, 2, 45, cy, '-')
    x2 = x2 + 45 - 5
    f.zones = f.zones or oq.label(f, x2, 2, 200, cy, '')
    x2 = x2 + 170
    f.zones:SetTextColor(0.9, 0.9, 0.9)
    f.zones:SetFont(OQ.FONT, 10, '')

    f.has_pword = f.has_pword or f:CreateTexture(nil, 'OVERLAY')
    oq.setpos(f.has_pword, x2, 2, 28, 38)
    f.has_pword:SetTexture(nil)
    f.has_pword:SetAlpha(1.0)

    f.pending_note =
        f.pending_note or
        oq.texture_button(f, x2, 4, 16, 16, OQ.PENDING_NOTE_UP, OQ.PENDING_NOTE_DN, nil, oq.pending_note_shade)
    f.pending_note:Hide()

    x2 = x2 + 22

    f.levels:SetText(r.level_range or '')

    f.req_but =
        f.req_but or
        oq.button(
            f,
            x2,
            2,
            60,
            cy - 2,
            OQ.BUT_WAITLIST,
            function(self)
                if ((oq.player_realid == nil) or (oq.player_realid == '')) then
                    return
                end
                oq.check_and_send_request(self:GetParent().token)
            end
        )
    f.req_but:SetText(OQ.BUT_WAITLIST)
    f.req_but:SetBackdropColor(0.5, 0.5, 0.5, 1)

    f.pending_clik = f.pending_clik or oq.click_label(f, x2, 2, 60, cy - 2, OQ.BUT_PENDING, 'CENTER', 'CENTER')
    f.pending_clik:SetScript(
        'OnClick',
        function(self)
            if ((oq.player_realid == nil) or (oq.player_realid == '')) then
                return
            end
            oq.check_and_send_request(self:GetParent().token)
        end
    )
    f.pending_clik.label:SetText(OQ.BUT_PENDING)
    f.pending_clik:Hide()

    x2 = x2 + 55
    f.unlist_but =
        f.unlist_but or
        oq.texture_button(
            f,
            x2,
            2,
            24,
            24,
            OQ.X_BUTTON_UP,
            OQ.X_BUTTON_DN,
            OQ.X_BUTTON_UP,
            function(self, button)
                local tok = self:GetParent().token
                if (button == 'LeftButton') then
                    oq.send_leave_waitlist(tok)
                elseif (button == 'RightButton') then
                    local premade = oq.premades[tok]
                    if (premade ~= nil) then
                        local dialog = StaticPopup_Show('OQ_BanUser', premade.leader_rid)
                        if (dialog ~= nil) then
                            dialog.data2 = {flag = 4, btag = premade.leader_rid, raid_tok = tok}
                        end
                    end
                end
            end
        )

    f.unlist_but:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    f.unlist_but.tt = OQ.TT_LEAVEPREMADE
    -- add tooltip event handler
    --
    f:SetScript(
        'OnEnter',
        function(self)
            oq.on_premade_item_enter(self)
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            oq.on_premade_item_exit(self)
        end
    )
    f:SetScript(
        'OnClick',
        function(self, button)
            oq.on_premade_item_click(self, button)
        end
    )

    f:Show()
    return f
end

function oq.set_waitlist_tooltip(f)
    if (f ~= nil) and (f.token ~= nil) then
        oq.tooltip_set2(f, oq.waitlist[f.token])
    end
end

function oq.create_waitlist_item(parent, x, y, cx, cy, token, n_members)
    oq.nthings = (oq.nthings or 0) + 1
    local i = 1
    local n = 'WaitRegion'
    local f = oq.click_panel(parent, n, x, y, cx, cy, true)
    f:SetFrameLevel(parent:GetFrameLevel() + 10)
    f:SetScript(
        'OnEnter',
        function(self)
            oq.set_waitlist_tooltip(self)
            self._highlight:Show()
        end
    )
    f:SetScript(
        'OnLeave',
        function(self)
            oq.tooltip_hide()
            self._highlight:Hide()
        end
    )
    f:SetScript(
        'OnClick',
        function(self, button)
            oq.on_waitlist_item_click(self, button)
        end
    )

    --
    -- highlight
    --
    if (f._highlight == nil) then
        local t = f:CreateTexture(nil, 'BACKGROUND')
        t:SetDrawLayer('BACKGROUND')
        t:SetTexture('INTERFACE/QUESTFRAME/UI-QuestTitleHighlight')
        t:SetPoint('TOPLEFT', 5, 0, 'TOPLEFT', 0, 0)
        t:SetPoint('BOTTOMRIGHT', -5, 0, 'BOTTOMRIGHT', 0, 0)
        t:SetAlpha(0.6)
        t:Hide()
        f._highlight = t
    end

    f.cy = cy
    f.token = token
    local x2 = 0
    if (f.remove_but == nil) then
        f.remove_but =
            oq.texture_button(
            f,
            x2,
            2,
            24,
            24,
            OQ.X_BUTTON_UP,
            OQ.X_BUTTON_DN,
            OQ.X_BUTTON_UP,
            function(self, button)
                local tok = self:GetParent().token
                if (button == 'LeftButton') then
                    oq.remove_waitlist(tok)
                elseif (button == 'RightButton') then
                    local req = oq.waitlist[tok]
                    if (req ~= nil) then
                        local dialog = StaticPopup_Show('OQ_BanUser', req.realid)
                        if (dialog ~= nil) then
                            dialog.data2 = {flag = 2, btag = req.realid, req_token = tok}
                        end
                    end
                end
            end
        )
        f.remove_but:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    end
    x2 = x2 + 20 + 4
    --  f.class      = f.class or oq.simple_texture( f, x2, 2,  22, 22, nil ) ;  x2 = x2 + 30 ;
    f.class = f.class or oq.label(f, x2, 1, 25, 27, '')
    x2 = x2 + 25 + 5
    f.spec = f.spec or oq.label(f, x2, 2, 25, 25, '')
    x2 = x2 + 25 + 5
    f.role = f.role or oq.label(f, x2, 2, 25, 25, '')
    x2 = x2 + 25 + 5
    --  f.role:SetJustifyV( "middle" ) ;
    f.toon_name = f.toon_name or oq.label(f, x2, 2, 120, cy, '')
    x2 = x2 + 120
    f.toon_name:SetFont(OQ.FONT, 12, '')
    f.realm = f.realm or oq.label(f, x2, 2, 100, cy, '')
    x2 = x2 + 100
    f.level = f.level or oq.label(f, x2, 2, 40, cy, '85')
    f.level:SetJustifyH('right')
    x2 = x2 + 40
    f.ilevel = f.ilevel or oq.label(f, x2, 2, 40, cy, '395')
    f.ilevel:SetJustifyH('right')
    f.ilevel:SetTextColor(0.9, 0.9, 0.9)
    x2 = x2 + 40

    -- x2 = x2 + 10
    -- f.stat_1 = f.stat_1 or oq.label(f, x2, 2, 45, 25, '')
    -- f.stat_1:SetJustifyH('RIGHT')
    -- x2 = x2 + 45 + 5
    -- f.stat_2 = f.stat_2 or oq.label(f, x2, 2, 45, 25, '')
    -- f.stat_2:SetJustifyH('RIGHT')
    -- x2 = x2 + 45 + 5

    f.resil = f.resil or oq.label(f, x2, 2, 40, cy, '4100')
    f.resil:SetJustifyH('right')
    x2 = x2 + 40
    f.pvppower = f.pvppower or oq.label(f, x2, 2, 40, cy, '99999')
    f.pvppower:SetJustifyH('right')
    f.pvppower:SetTextColor(0.9, 0.9, 0.9)
    x2 = x2 + 50
    f.mmr = f.mmr or oq.label(f, x2, 2, 40, cy, '1500')
    f.mmr:SetJustifyH('right')
    x2 = x2 + 40

    f.nMembers = n_members
    x2 = x2 + 35

    if (n_members == 1) then
        f.invite_but =
            f.invite_but or
            oq.button(
                f,
                x2,
                2,
                75,
                cy - 2,
                OQ.BUT_INVITE,
                function(self, button)
                    if (oq.player_realid == nil) then
                        return
                    else
                        local now = oq.utc_time()
                        if (now < next_invite_tm) then
                            return
                        end
                        --                                                   next_invite_tm = now + 4 ;
                        if (button == 'LeftButton') then
                            -- right button should not work, as you cannot invite directly into a group
                            local tok = self:GetParent().req_token
                            local g, s = oq.first_raid_slot()
                            oq.group_invite_slot(tok, g, s) -- always 1,5 ... will be reassigned later
                        end
                    end
                end
            )
        f.invite_but:Show()
        f.invite_but:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
        x2 = x2 + 75 + 5
    end
    f.wait_tm = f.wait_tm or oq.label(f, x2 + 10, 2, 70, cy, '00:00')
    x2 = x2 + 60
    f.wait_tm:SetTextColor(0.9, 0.9, 0.9)

    -- change to texture-button for chat
    --
    f.note_txt = f.note_txt or oq.texture(f, x2 + 8, 6, 16, 16, OQ.PENDING_NOTE_UP)
    f.note_txt:Hide()

    f:Show()
    return f
end

function oq.update_waitlist_note(req_token, txt)
    local f = oq.find_waitlist_row(req_token)
    if (f ~= nil) then
        if (txt) and (txt ~= '') then
            f.note_txt:Show()
        else
            f.note_txt:Hide()
        end
    end
end

function oq.set_class(g_id, slot, class)
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    local color = OQ.CLASS_COLORS[class]
    oq.raid.group[g_id].member[slot].class = class

    if (color == nil) then
        color = OQ.CLASS_COLORS[OQ.SHORT_CLASS[class]]
        if (color == nil) then
            return
        end
    end
    if (slot == 1) then
        if (class ~= nil) and (OQ.CLASS_COLORS[class] ~= nil) then
            oq.tab1_group[g_id].leader:SetTextColor(
                OQ.CLASS_COLORS[class].r,
                OQ.CLASS_COLORS[class].g,
                OQ.CLASS_COLORS[class].b
            )
        end
    end
    if (oq.tab1_group[g_id]) and (oq.tab1_group[g_id].slots[slot]) and (oq.tab1_group[g_id].slots[slot].texture) then
        oq.tab1_group[g_id].slots[slot].texture:SetTexture(color.r, color.g, color.b, 1)
        oq.tab1_group[g_id].slots[slot].txt:SetText('')
        oq.set_textures(g_id, slot)
    end
end

function oq.assure_slot_exists(group_id, slot)
    if (group_id == 0) or (slot == 0) then
        return
    end
    if (oq.raid.group[group_id] == nil) then
        oq.raid.group[group_id] = tbl.new()
        oq.raid.group[group_id].member = tbl.new()
    end
    if (oq.raid.group[group_id].member == nil) then
        oq.raid.group[group_id].member = tbl.new()
    end
    if (oq.raid.group[group_id].member[slot] == nil) then
        oq.raid.group[group_id].member[slot] = tbl.new()
    end
end

function oq.set_group_member(group_id, slot, name_, realm_, class_, rid, s1, s2)
    group_id = tonumber(group_id) or 0
    slot = tonumber(slot) or 0
    if (group_id == 0) or (slot == 0) then
        return
    end
    if (name_) and (name_ == '-') then
        name_ = nil
        realm_ = nil
    end
    local realm_id = realm_
    if (tonumber(realm_) ~= nil) then
        realm_ = oq.GetRealmNameFromID(realm_)
    else
        realm_id = oq.GetRealmID(realm_)
    end
    if (class_ == nil) then
        class_ = 'XX'
    end
    if (class_ == nil) or (class_:len() > 2) then
        class_ = OQ.SHORT_CLASS[class_] or 'ZZ'
    end
    oq.assure_slot_exists(group_id, slot)

    local m = oq.raid.group[group_id].member[slot]

    m.name = name_
    m.class = class_
    m.realm = realm_
    m.realm_id = realm_id
    m.realid = rid

    if (s1) and (s2) and (m.bg) then
        m.bg[1].status = (s1 or '3')
        m.bg[2].status = (s2 or '4')
    end

    if (class_ ~= nil) then
        oq.set_class(group_id, slot, class_)
    end

    if (slot == 1) and (m.realm) and (m.name) then
        oq.tab1_group[group_id].realm:SetText(m.realm)
        oq.tab1_group[group_id].leader:SetText(m.name)
        if (class_ ~= nil) and (OQ.CLASS_COLORS[class_] ~= nil) then
            oq.tab1_group[group_id].leader:SetTextColor(
                OQ.CLASS_COLORS[class_].r,
                OQ.CLASS_COLORS[class_].g,
                OQ.CLASS_COLORS[class_].b
            )
        end
    elseif (slot == 1) then
        -- clear it out
        oq.tab1_group[group_id].realm:SetText('')
        oq.tab1_group[group_id].leader:SetText('')
    end
end

function oq.set_group_lead(g_id, name, realm, class, rid)
    oq.set_group_member(g_id, 1, name, realm, class, rid)
end

function oq.queue_button_action(self, button, ndx)
    if (self:GetText() == OQ.LEAVE_QUEUE) or (button == 'RightButton') then
        if (oq.iam_raid_leader()) then
            oq.raid_announce('leave_queue,' .. ndx)
        end
        oq.battleground_leave(ndx)
    elseif (self:GetText() == OQ.JOIN_QUEUE) then
        if (oq.iam_raid_leader()) then
            -- will trigger exception
            oq.raid_announce('join,' .. ndx)
        end
    end
    oq.update_tab1_queue_controls()
end

function oq.on_reload_now()
    ReloadUI()
end
function oq.tab3_create_activate()
    local in_party = (GetNumGroupMembers() > 0)
    if (in_party and not UnitIsGroupLeader('player')) then
        StaticPopup_Show('OQ_CannotCreatePremade')
        return
    end

    local name = oq.rtrim(oq.tab3_raid_name:GetText())
    if ((name == nil) or (name == '')) then
        message(OQ.MSG_MISSINGNAME)
        return
    end
    if (oq.tab3._voip._id == OQ.VOIP_UNSPECIFIED) then
        message(OQ.MSG_MISSINGVOIP)
        return
    end
    local low_name = strlower(name)
    if (low_name:find('lfg')) then
        message(OQ.MSG_NOTLFG)
        return
    end

    if ((oq.player_realid == nil) or (oq.player_realid == '')) then
        return
    elseif (not oq.valid_rid(oq.player_realid)) then
        message(OQ.BAD_REALID .. ' ' .. tostring(oq.player_realid))
        return
    end
    local old_type = oq.raid.type
    if (oq.tab3_radio_selected == nil) or (oq.tab3_radio_selected == OQ.TYPE_NONE) then
        message(OQ.MSG_MISSINGTYPE)
        return
    end
    oq.set_premade_type(oq.tab3_radio_selected)
    if (old_type ~= oq.raid.type) then
        oq.reject_all_waitlist()
    end

    local rc = nil
    if (oq.tab3._create_but:GetText() == OQ.CREATE_BUTTON) then
        rc = oq.raid_create()
        if (rc) then
            rc = oq.update_premade_note()
            oq.tab3._create_but:SetText(OQ.UPDATE_BUTTON)
        end
    elseif (oq.tab3._create_but:GetText() == OQ.UPDATE_BUTTON) then
        rc = oq.update_premade_note()
    end
    if (rc) then
        -- do not let the user create, update, or disband the premade for 15 seconds
        oq.tab3._create_but:Disable()
        oq.timer_oneshot(OQ_CREATEPREMADE_CD, oq.enable_button, oq.tab3._create_but)
        oq.tab1._quit_button:Disable()
        oq.timer_oneshot(OQ_CREATEPREMADE_CD, oq.enable_button, oq.tab1._quit_button)
    end
    oq.send_my_premade_info()
end

function oq.enable_button(but)
    if (but ~= nil) then
        but:Enable()
    end
end

function oq.try_to_connect()
    local nShown, nPremades = oq.n_premades()
    local nOQlocals = oq.get_nConnections()
    if (nPremades == 0) and (nOQlocals > 15) then
        -- no premades and connected to mesh... clear out time adjustment and let scorekeeper re-sync
        oq.timezone_adjust(0)
    end

    -- make sure to be connected locally
    if (OQ_data.auto_join_oqgeneral == 0) then
        OQ_data.auto_join_oqgeneral = 1
        oq.oqgeneral_join()
        oq.log(true, OQ.LILDIAMOND_ICON .. ' ' .. L['connecting to in-realm oQueue data stream'])
    end
end

function oq.toggle_filter(is_checked)
    local b = oq._filter
    if (is_checked) then
        -- show edit
        if (b._edit) then
            oq._filter._text = OQ_data._filter_text
            b._edit:SetText(oq._filter._text or '')
            b._edit:Show()
            if (OQ_data._was_filter_editing) then
                b._edit:SetFocus()
            end
        end
        OQ_data._filter_open = true
        OQ_data._was_filtering = true
        PlaySound('igMainMenuOptionCheckBoxOn')
        oq.reshuffle_premades_now()
    else
        -- hide edit & clear filter text
        if (b._edit) then
            b._edit:Hide()
        end
        b._text = nil
        oq.reshuffle_premades_now() -- filter removed, force ui update
        OQ_data._filter_open = nil
        OQ_data._was_filtering = nil
        PlaySound('igMainMenuOptionCheckBoxOff')
        oq.reshuffle_premades_now()
    end
end

function oq.sanitize_filter(txt)
    txt = txt:gsub('%%', '')
    txt = txt:gsub('+', '')
    txt = txt:gsub('-', '')
    txt = txt:gsub('/', '')
    txt = txt:gsub('%^', '')
    txt = txt:gsub('#', '')
    txt = txt:gsub('<', '')
    txt = txt:gsub('>', '')
    txt = txt:gsub('=', '')
    txt = txt:gsub('%(', '')
    txt = txt:gsub('%)', '')
    txt = txt:gsub('%[', '')
    txt = txt:gsub('%]', '')
    txt = txt:gsub('{', '')
    txt = txt:gsub('}', '')
    txt = txt:gsub(';', '')
    txt = txt:gsub(',', '')
    return txt
end

function oq.update_filter(txt)
    oq._filter._text = oq.sanitize_filter(txt)
    OQ_data._filter_text = oq._filter._text
    oq.reshuffle_premades_now()
end

function oq.strcspn(s, reject)
    local n = strlen(s)

    for i = 1, n, 1 do
        local ch = s:sub(i, i)
        local p = reject:find(ch)
        if (p) and (p > 0) then
            return s:find(reject:sub(p, p)), reject:sub(p, p)
        end
    end
    return 0, nil
end

function oq.pass_filter_condition(f, p)
    local firstchar = f:sub(1, 1)
    local negate = (firstchar == '!')
    f = strlower(f)
    if (negate) then
        f = f:sub(2, -1)
    elseif (firstchar == 'i') or (firstchar == 'r') then
        local n = tonumber(f:sub(2, -1))
        if (n ~= nil) then
            if (firstchar == 'i') then
                local min_ilevel = p.min_ilevel
                if ((p.type == OQ.TYPE_DUNGEON) or (p.type == OQ.TYPE_RAID)) and (p.min_mmr > 0) then
                    min_ilevel = min(min_ilevel, p.min_mmr)
                end
                if (min_ilevel >= n) then
                    return true
                else
                    return nil
                end
            else
                if (p.min_mmr >= n) then
                    return true
                else
                    return nil
                end
            end
        end
    end

    if (f == 'pvp') then
        return (p.type == OQ.TYPE_BG) or (p.type == OQ.TYPE_RBG) or (p.type == OQ.TYPE_ARENA)
    elseif (f == 'pve') then
        return (p.type ~= OQ.TYPE_BG) and (p.type ~= OQ.TYPE_RBG) and (p.type ~= OQ.TYPE_ARENA) and
            (p.type ~= OQ.TYPE_ROLEPLAY)
    end

    local t = strlower(p.name or '')
    local flag = nil
    if (t:find(f)) then
        flag = true
    end
    t = strlower(p.leader or '')
    if (t:find(f)) then
        flag = true
    end
    t = strlower(p.bgs or '')
    if (t:find(f)) then
        flag = true
    end
    t = strlower(p.leader_realm or '')
    if (t:find(f)) then
        flag = true
    end
    if (p.type == OQ.TYPE_RAID) and (p.pdata) and (#p.pdata > 8) then
        local D = oq.decode_mime64_digits(p.pdata:sub(4, 4))
        local R = oq.decode_mime64_digits(p.pdata:sub(5, 5))
        t = strlower(OQ.raid_abbrevation[R] or '')
        if (t:find(f)) then
            flag = true
        end
        if (OQ._difficulty[D]) then
            t = t .. strlower(OQ.difficulty_abbr[D] or '') -- for things like: soo10 or soo25
            if (t:find(f)) then
                flag = true
            end
            t = strlower(OQ._difficulty[D].diff or '') -- for things like:  heroic  or   normal
            if (t:find(f)) then
                flag = true
            end
        end
    end
    -- ternary operator would be so nice...
    if (negate) then
        if (flag == nil) then
            return true
        end
    elseif (flag) then
        return true
    end
    return nil
end

function oq.pass_preference_filter(p)
    -- my preferences (voip, lang)
    if (oq.tab2._voip._id ~= OQ.VOIP_UNSPECIFIED) and (oq.tab2._voip._id ~= p.voip) then
        return false
    end
    if (oq.tab2._lang._id ~= OQ.LANG_UNSPECIFIED) and (oq.tab2._lang._id ~= p.lang) then
        return false
    end
    if oq.is_voip_excluded(p.voip) or oq.is_lang_excluded(p.lang) or oq.is_premade_excluded(p.type) then
        return false
    end
    return true
end

function oq.pass_filter(premade)
    if (premade == nil) then
        return nil
    end
    if (not oq.pass_preference_filter(premade)) then
        return nil
    end
    local str = oq._filter._text
    if (str == nil) or (str == '') then
        return true
    end
    local result = nil
    local cond = nil
    local p1 = 1
    local p2
    local c1, r, f
    while (str) do
        p2, c1 = oq.strcspn(str, '&|')
        f = oq.trim(str:sub(p1, (p2 or 0) - 1))
        r = oq.pass_filter_condition(f, premade)
        if (p2) and (p2 > 0) then
            str = str:sub(p2 + 2, -1)
            p1 = 1
        else
            str = nil
        end
        if (cond) then
            if (cond == '|') then
                result = result or r
            elseif (cond == '&') then
                result = result and r
            end
        else
            result = r
        end
        cond = c1
    end
    return result
end

function oq.filter_show()
    oq._filter:Show()
    if (OQ_data._was_filtering) then
        oq.toggle_filter(true)
    else
        oq.toggle_filter(nil)
    end
end

function oq.filter_hide()
    oq._filter:Hide()
    OQ_data._was_filtering = oq._filter._edit:IsVisible()
    oq._filter._edit:Hide()
end

function oq.create_filter_button(parent)
    local x = 90 -- old: 140 ;
    local y = 4
    local cx = 24
    local cy = 26
    local b = CreateFrame('CheckButton', 'OQFilterButton', parent)
    b:SetFrameLevel(parent:GetFrameLevel() + 1)
    b:RegisterForClicks('anyUp')
    b:SetWidth(cx)
    b:SetHeight(cy)
    b:SetPoint('TOPLEFT', x, y)

    local pt = b:CreateTexture()
    pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
    pt:SetAllPoints(b)
    b:SetPushedTexture(pt)

    local ht = b:CreateTexture()
    ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
    ht:SetAllPoints(b)
    b:SetHighlightTexture(ht)

    local ct = b:CreateTexture()
    ct:SetTexture([[Interface\Buttons\CheckButtonHilight]])
    ct:SetAllPoints(b)
    ct:SetBlendMode('ADD')
    ct:SetAlpha(0.5)
    b:SetCheckedTexture(ct)

    local bdrop = b:CreateTexture(nil, 'BORDER')
    bdrop:SetAllPoints(b)
    bdrop:SetTexture(0, 0, 0.1, 1)

    local icon = b:CreateTexture()
    icon:SetTexture([[Interface\Icons\INV_Misc_Spyglass_03]])
    icon:SetPoint('TOPLEFT', 2, -2)
    icon:SetPoint('BOTTOMRIGHT', -2, 2)
    icon:SetTexCoord(3 / 64, 60 / 64, 3 / 64, 60 / 64)

    b._edit = oq.editline(parent, 'Filter', x, y, 120, cy, 80)
    b._edit:SetPoint('TOPLEFT', x + cx + 8, y - 4)
    b._edit:SetWidth(120 + 30)
    b._edit:SetHeight(cy)
    b._edit:SetAlpha(1.0)
    if (OQ_data._filter_text ~= nil) then
        b._edit:SetText(OQ_data._filter_text)
        b._edit:Show()
    else
        b._edit:Hide()
    end
    --
    --[[ will clear filter text; removed to allow user to hit esc to close the ui while keeping filter text
  b._edit:SetScript( "OnEscapePressed",
          function(self)
            self:ClearFocus();
            self:SetText("");
            oq._filter:Click();
          end );
]] b._edit:SetScript(
        'OnEditFocusGained',
        function()
            OQ_data._was_filter_editing = true
        end
    )
    b._edit:SetScript(
        'OnEditFocusLost',
        function()
            OQ_data._was_filter_editing = nil
        end
    )
    b._edit:SetScript(
        'OnTextChanged',
        function(self)
            oq.update_filter(self:GetText())
        end
    )
    b:SetScript(
        'OnClick',
        function(self)
            oq.toggle_filter(self:GetChecked())
            if (oq._filter._edit:IsVisible()) then
                oq._filter._edit:SetFocus()
            end
        end
    )

    b:SetChecked(nil)
    b._edit:Hide()
    b:Hide()

    oq._filter = b
    return b
end

function oq.log(echo, ...)
    if (oq._log == nil) then
        return
    end
    if (OQ_data._history == nil) then
        OQ_data._history = tbl.new()
    end
    local now = oq.utc_time()
    tinsert(OQ_data._history, '|cFF00B000' .. date('%H:%M:%S', now) .. '|r  ' .. tostring(...))
    if (table.getn(OQ_data._history) > OQ.MAX_LOG_LINES) then
        local n = table.getn(OQ_data._history) - OQ.MAX_LOG_LINES
        for _ = 1, n do
            table.remove(OQ_data._history, 1)
        end
    end
    if (oq._log:IsVisible()) then
        oq._log:update_text()
    end
    if (echo) then
        print('[OQUEUE]', ...)
    end
end

function oq.toggle_log()
    if (oq._log) and (oq._log:IsVisible()) then
        oq._log:Hide()
    elseif (oq._log) then
        oq._log:Show()
        oq._log:Raise()
    end
end

function oq.log_realm_name()
    oq.log(nil, 'entering |cFFE0E000' .. tostring(GetRealZoneText()) .. '|r')
end

function oq.create_log_button(parent)
    local x = 60 -- old: 84 ;
    local y = 4
    local cx = 24
    local cy = 26
    local b = CreateFrame('CheckButton', 'OQLogButton', parent)
    b:SetFrameLevel(parent:GetFrameLevel() + 1)
    b:RegisterForClicks('anyUp')
    b:SetWidth(cx)
    b:SetHeight(cy)
    b:SetPoint('TOPLEFT', x, y)

    local pt = b:CreateTexture()
    pt:SetTexture([[INTERFACE/BUTTONS/UI-MicroButton-Spellbook-Down]])
    pt:SetAllPoints(b)
    --  pt:SetTexCoord(2/32,29/32,25/64,61/64);
    pt:SetTexCoord(4 / 32, 26 / 32, 30 / 64, 59 / 64)
    b:SetPushedTexture(pt)

    local ht = b:CreateTexture()
    ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
    ht:SetAllPoints(b)
    b:SetHighlightTexture(ht)

    local ct = b:CreateTexture()
    ct:SetTexture([[Interface\Buttons\CheckButtonHilight]])
    ct:SetAllPoints(b)
    ct:SetBlendMode('ADD')
    ct:SetAlpha(0.5)
    b:SetCheckedTexture(ct)

    local icon = b:CreateTexture()
    icon:SetAllPoints(b)
    icon:SetTexture('INTERFACE/BUTTONS/UI-MicroButton-Spellbook-Up')
    icon:SetTexCoord(4 / 32, 26 / 32, 30 / 64, 59 / 64)

    b:SetScript(
        'OnClick',
        function()
            oq.toggle_log()
        end
    )
    b:Show()

    local ht = b:CreateTexture()
    ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
    ht:SetAllPoints(b)
    b:SetHighlightTexture(ht)

    local d = oq.CreateFrame('FRAME', 'OQLogBoard', UIParent)
    d._save_position = function(self)
        OQ_data.log_x = max(0, floor(self:GetLeft()))
        OQ_data.log_y = max(0, floor(self:GetTop()))
    end

    d:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
    oq.make_frame_moveable(d)
    oq.closebox(d)
    d:SetScript(
        'OnShow',
        function(self)
            tinsert(UISpecialFrames, self:GetName())
            self:SetFrameLevel(52) -- minimap button == 50
            self:update_text()
            PlaySound('igCharacterInfoOpen')
        end
    )
    d:SetScript(
        'OnHide',
        function()
            if (oq.log_button) then
                oq.log_button:SetChecked(nil)
            end
            PlaySound('igCharacterInfoClose')
        end
    )

    d:SetPoint('TOPLEFT', 100, -100)
    d:SetWidth(535)
    d:SetHeight(OQ.MIN_FRAME_HEIGHT) -- 518
    d:SetFrameLevel(max(OQ_MinimapButton:GetFrameLevel(), parent:GetFrameLevel()) + 10)

    d.update_text = function(self)
        local str = '<html><body>'
        for _, v in pairs(OQ_data._history) do
            str = str .. '<h3>' .. tostring(v) .. '</h3>'
        end
        str = str .. '</body></html>'
        self._text:SetText(str)
    end

    local t = d:CreateTexture(nil, 'ARTWORK')
    t:SetTexture('INTERFACE/GUILDFRAME/GuildExtra')
    t:SetTexCoord(0 / 512, 289 / 512, 0 / 128, 28 / 128)
    t:SetPoint('TOPLEFT', d, 'TOPLEFT', 0, 0)
    t:SetPoint('BOTTOMRIGHT', d, 'TOPRIGHT', 0, -28)
    t:SetAlpha(0.7)
    d.top_texture = t

    t = d:CreateTexture(nil, 'ARTWORK')
    t:SetTexture('INTERFACE/GUILDFRAME/GuildExtra')
    t:SetTexCoord(0 / 512, 289 / 512, 36 / 128, 66 / 128)
    t:SetPoint('TOPLEFT', d, 'TOPLEFT', 0, -28)
    t:SetPoint('BOTTOMRIGHT', d, 'BOTTOMRIGHT', 0, 39)
    t:SetAlpha(0.7)
    d.middle_texture = t

    t = d:CreateTexture(nil, 'ARTWORK')
    t:SetTexture('INTERFACE/GUILDFRAME/GuildExtra')
    t:SetTexCoord(0 / 512, 289 / 512, 80 / 128, 119 / 128)
    t:SetPoint('TOPLEFT', d, 'BOTTOMLEFT', 0, 39)
    t:SetPoint('BOTTOMRIGHT', d, 'BOTTOMRIGHT', 0, 0)
    t:SetAlpha(0.7)
    d.bottom_texture = t

    t = d:CreateTexture(nil, 'BACKGROUND')
    t:SetTexture('INTERFACE/DialogFrame/UI-DialogBox-Background-Dark')
    t:SetPoint('TOPLEFT', d, 'TOPLEFT', 10, -10)
    t:SetPoint('BOTTOMRIGHT', d, 'BOTTOMRIGHT', -10, 10)
    t:SetAlpha(1.0)
    d.backdrop_texture = t

    x = 25
    y = -23
    d._text = oq.CreateFrame('SimpleHTML', 'OQLogPoster', d)
    d._text:SetScript('OnHyperLinkClick', oq.onHyperlinkClick)
    d._text:SetPoint('TOPLEFT', x, y)
    d._text:SetFont('Fonts\\FRIZQT__.TTF', 10)
    d._text:SetWidth(d:GetWidth() - 2 * x)
    d._text:SetHeight(d:GetHeight() - 2 * abs(y))
    d._text:SetFont('h1', 'Fonts\\FRIZQT__.TTF', 16)
    d._text:SetTextColor('h1', 0.9, 0.9, 0.9, 0.8)

    d._text:SetFont('h2', 'Fonts\\MORPHEUS.ttf', 40)
    d._text:SetShadowColor('h2', 0, 0, 0, 1)
    d._text:SetShadowOffset('h2', 1, -1)
    d._text:SetTextColor('h2', 128 / 255, 0 / 255, 0 / 255, 1.0)

    d._text:SetFont('h3', OQ.FONT_FIXED, 10)
    d._text:SetShadowColor('h3', 0, 0, 0, 1)
    d._text:SetShadowOffset('h3', 0, 0)
    d._text:SetTextColor('h3', 0.9, 0.9, 0.9, 1.0)

    d._text:SetText('')

    d:Hide()
    oq._log = d

    if (OQ_data.log_x or OQ_data.log_y) then
        d:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', OQ_data.log_x, OQ_data.log_y)
    end

    return b
end

function oq.onHyperlinkClick(self, link, text, button)
    local n = link:find(':') or 0
    local service = link:sub(1, n - 1)
    if (oq._hyperlinks[service]) then
        oq._hyperlinks[service](link, text, button)
    else
        if (oq.old_hyperlink_handler) then
            oq.old_hyperlink_handler(self, link, text, button)
        end
    end
end

function oq.tooltip_game_record(a, b)
    local s = '|cFFA0A0A0' .. tostring(a or 0) .. '|r'
    s = s .. '|cFFB0B0B0' .. ' - ' .. '|r'
    s = s .. '|cFFFFFF31' .. tostring(b or 0) .. '|r'
    return s
end

function oq.tooltip_game_record2(a, b, is_lead)
    local s = '|cFFA0A0A0'
    if (is_lead) then
        s = '|cFFFFFF31'
    end
    s = s .. tostring(a or 0) .. ' - ' .. tostring(b or 0) .. '|r'
    return s
end

function oq.tooltip_me_hide()
    local tooltip = oq.long_tooltip_create()
    tooltip:Hide()
end

function oq.tooltip_me()
    local tooltip = oq.long_tooltip_create()

    oq.gather_my_stats() -- force stats gather for display

    tooltip:ClearAllPoints()
    tooltip:SetParent(OQMainFrame, 'ANCHOR_RIGHT')
    tooltip:SetPoint('TOPRIGHT', OQMainFrame, 'TOPLEFT', -5, -20)
    tooltip:SetFrameLevel(OQMainFrame:GetFrameLevel() + 10)
    oq.tooltip_clear()

    if (OQ.CLASS_COLORS[player_class] == nil) then
        return
    end

    local t = CLASS_ICON_TCOORDS[OQ.LONG_CLASS[player_class]]
    if t then
        tooltip.portrait.texture:SetTexture('Interface\\TargetingFrame\\UI-Classes-Circles')
        tooltip.portrait.texture:SetTexCoord(unpack(t))
        tooltip.portrait.texture:SetAlpha(1.0)
    end

    local color = OQ.CLASS_COLORS[player_class]

    tooltip.left[1]:SetText(tostring(player_name or '') .. ' (' .. tostring(player_level or 0) .. ')')
    tooltip.left[1]:SetTextColor(color.r, color.g, color.b, 1)
    tooltip.left[2]:SetText(player_realm or '')
    tooltip.left[2]:SetTextColor(0.0, 0.9, 0.9, 1)

    tooltip.right[2]:SetText(oq.get_rank_icons(oq.get_pvp_experience()) or '')

    tooltip.left[3]:SetText(OQ.TT_BATTLE_TAG)
    tooltip.right[3]:SetText(oq.player_realid or '')

    tooltip.left[5]:SetText(OQ.TT_ILEVEL)
    tooltip.right[5]:SetText(player_ilevel)

    tooltip.left[6]:SetText(OQ.TT_TEARS)
    tooltip.right[6]:SetText(tostring(oq.total_tears()))

    tooltip.left[7]:SetText(OQ.TT_REGULAR_BG)
    tooltip.right[7]:SetText('')
    --  tooltip.right[7]:SetText(oq.tooltip_game_record( oq.toon.stats["bg"].nGames, OQ_data.leader["bg"].nGames));

    tooltip.left[8]:SetText('-  ' .. OQ.TT_PERSONAL)
    tooltip.right[8]:SetText(oq.tooltip_game_record2(oq.toon.stats['bg'].nWins, oq.toon.stats['bg'].nLosses, nil))

    tooltip.left[9]:SetText('-  ' .. OQ.TT_ASLEAD)
    tooltip.right[9]:SetText(
        oq.tooltip_game_record2(OQ_data.leader['bg'].nWins, OQ_data.leader['bg'].nLosses, true)
    )

    tooltip.left[10]:SetText(OQ.LABEL_RBGS)
    tooltip.right[10]:SetText('')
    --  tooltip.right[10]:SetText(oq.tooltip_game_record( oq.toon.stats["rbg"].nGames, OQ_data.leader["rbg"].nGames));

    tooltip.left[11]:SetText('-  ' .. OQ.TT_PERSONAL)
    tooltip.right[11]:SetText(oq.tooltip_game_record2(oq.toon.stats['rbg'].nWins, oq.toon.stats['rbg'].nLosses, nil))

    tooltip.left[12]:SetText('-  ' .. OQ.TT_ASLEAD)
    tooltip.right[12]:SetText(
        oq.tooltip_game_record2(OQ_data.leader['rbg'].nWins, OQ_data.leader['rbg'].nLosses, true)
    )

    tooltip.left[13]:SetText(OQ.TT_MMR)
    local s =
        '|cFFF08040' ..
        tostring(oq.get_arena_rating(1)) ..
            '|r ' ..
                '|cFFF0F0A0' ..
                    tostring(oq.get_arena_rating(2)) ..
                        '|r ' ..
                            '|cFFF08040' ..
                                tostring(oq.get_arena_rating(3)) ..
                                    '|r ' .. '|cFFF0F0A0' .. tostring(oq.get_mmr()) .. '|r'

    tooltip.right[13]:SetText(s)

    tooltip.left[14]:SetText(OQ.TT_5MANS)
    tooltip.right[14]:SetText(
        tostring(OQ_data.leader['pve.5man'].nBosses or 0) .. ' - ' .. tostring(OQ_data.leader['pve.5man'].nWipes or 0)
    )

    tooltip.left[15]:SetText(OQ.TT_RAIDS)
    tooltip.right[15]:SetText(
        tostring(OQ_data.leader['pve.raid'].nBosses or 0) .. ' - ' .. tostring(OQ_data.leader['pve.raid'].nWipes or 0)
    )

    tooltip.left[16]:SetText(OQ.TT_CHALLENGES)
    tooltip.right[16]:SetText(
        tostring(OQ_data.leader['pve.challenge'].nBosses or 0) ..
            ' - ' .. tostring(OQ_data.leader['pve.challenge'].nWipes or 0)
    )

    tooltip.left[tooltip.nRows - 0]:SetText(oq.get_rank_achieves(oq.get_pvp_experience()))
    tooltip.right[tooltip.nRows - 0]:SetText('')

    -- adjust dimensions of the box
    local w = tooltip.left[1]:GetStringWidth()
    for i = 4, tooltip.nRows do
        tooltip.right[i]:SetWidth(tooltip:GetWidth() - 30)
    end

    tooltip:Show()
end

ChartBar = {}
function ChartBar:new(parent, x_, y_, cx_, cy_, prev_bar)
    local o = tbl.new()
    o._cnt = 0
    o._parent = parent
    o._x = x_ -- center-x
    o._y = y_ -- center-y
    o._cx = cx_
    o._cy = cy_
    o._texture = nil
    setmetatable(o, {__index = ChartBar})
    o:create_texture(prev_bar)
    o:set_zero()
    o:update(1) -- force the bars to zero themselves
    return o
end

function ChartBar:create_texture(prev_bar)
    if (self._texture) then
        return
    end
    self._texture = self._parent:new_texture()
    self._texture:SetTexture(unpack(OQ.CHART_COLORS['base']))
    self._texture:SetAlpha(1)
    self._texture:ClearAllPoints()
    self._texture:SetPoint('BOTTOMLEFT', self._parent, 'BOTTOMLEFT', self._x, -1 * self._y)
    self._texture:SetWidth(self._cx)
    self._texture:SetHeight(self._cy)
    self._texture:Show()
    if (prev_bar) then
        self._texture:SetPoint('LEFT', prev_bar._texture, 'RIGHT')
    end

    self._tip = self._parent:new_texture()
    self._tip:SetTexture(0 / 255, 60 / 255, 0 / 255)
    self._tip:SetAlpha(1)
    self._tip:ClearAllPoints()
    self._tip:SetPoint('BOTTOM', self._texture, 'TOP')
    self._tip:SetWidth(self._cx)
    self._tip:SetHeight(6)
    self._tip:Show()
end

-- sets the 'color' of the bar tip
-- won't update on screen until 'update' is called
--
function ChartBar:set_color(c)
    self._color = c
end

function ChartBar:set_zero()
    self._color = 'black'
    self._cnt = 0
end

OQ.CHART_COLORS = {
    ['green'] = {0 / 255, 192 / 255, 0 / 255},
    ['yellow'] = {192 / 255, 192 / 255, 0 / 255},
    ['red'] = {120 / 255, 6 / 255, 57 / 255},
    ['black'] = {0 / 255, 100 / 255, 100 / 255},
    ['nopop'] = {0 / 255, 0 / 255, 192 / 255},
    ['background'] = {30 / 255, 30 / 255, 0 / 255},
    ['darkgreen'] = {0 / 255, 96 / 255, 0 / 255},
    ['base'] = {0 / 255, 66 / 255, 0 / 255}
}

function ChartBar:update(max_cnt)
    local cy = 0
    if (max_cnt) and (max_cnt > 0) then
        cy = self._cy * (self._cnt / max_cnt)
    end
    self._texture:SetHeight(cy)
    if (cy == 0) then
        self._tip:Hide()
        self._texture:Hide()
    else
        self._texture:Show()
        self._tip:Show()
        self._tip:SetTexture(unpack(OQ.CHART_COLORS[self._color or 'black'] or OQ.CHART_COLORS['black']))
    end
end

OQ.GRAPH_TIMESPAN = 2500 -- milliseconds
OQ.GRAPH_TIMESLICE = 200 -- milliseconds
OQ.GRAPH_GREEN = 500
OQ.GRAPH_YELLOW = 500
OQ.GRAPH_RED = 1000
OQ.GRAPH_BLACK = 1500
OQ.GRAPH_NSLICES = 25

function oq.create_bg_queue_chart(parent, x, y, cx, cy)
    if (parent._chart) then
        return parent._chart
    end
    local f = oq.panel(parent, 'OQBGChart', x, y, cx, cy)
    f.texture:SetTexture(30 / 255, 30 / 255, 0 / 255)
    f._texture_pool = tbl.new()

    f.new_texture = function(self)
        local t = next(self._texture_pool)
        if t then
            self._texture_pool[t] = nil
        else
            self._nTextures = (self._nTextures or 0) + 1
            t = self:CreateTexture(self:GetName() .. 'Tex' .. self._nTextures, 'ARTWORK', nil, 5)
        end
        return t
    end
    f.del_texture = function(self, tex)
        if (tex) then
            tex:Hide()
            tex:SetTexture('')
            tex:ClearAllPoints()
            self._texture_pool[tex] = true
        end
    end
    f.clear_data = function(self)
        tbl.clear(self._data)
    end
    f.create_bars = function(self)
        self._bars = tbl.new()
        local x1, y1, w, h
        x1 = 10
        y1 = -20
        w = (cx - 2 * x1) / (OQ.GRAPH_NSLICES + 2)
        h = cy - 2 * 20
        for i = 0, (OQ.GRAPH_NSLICES + 1) do
            self._bars[i] = ChartBar:new(self, x1 + i * w, y1, w, h, self._bars[i - 1])
            x1 = x1 + w
        end
    end
    f.create_base = function(self)
        self._base = self:new_texture()
        self._base:SetTexture(unpack(OQ.CHART_COLORS['base']))
        self._base:SetAlpha(1)
        self._base:ClearAllPoints()
        self._base:SetPoint('LEFT', self, 'BOTTOMLEFT', 10, 20)
        self._base:SetWidth(self:GetWidth() - 2 * 10)
        self._base:SetHeight(4)
        self._base:Show()
    end
    f.create_labels = function(self)
        local cx = floor(self:GetWidth())
        local cy = floor(self:GetHeight())

        -- count
        self.line1 = oq.label(self, cx - 10, 10, 100, 15, L['n = 0'], 'CENTER', 'RIGHT')
        self.line1:SetFont(OQ.FONT, 10, '')
        self.line1:SetTextColor(0.7, 0.7, 0.7, 1)
        self.line1:ClearAllPoints()
        self.line1:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -10, 2)
        self.line1:Show()

        -- legend
        self.key = tbl.new()
        self.key['green'] = self:create_legend(10, 'green')
        self.key['yellow'] = self:create_legend(25, 'yellow')
        self.key['red'] = self:create_legend(40, 'red')
        self.key['black'] = self:create_legend(55, 'black')
    end
    f.create_legend = function(self, y, color)
        local block
        block = self:new_texture()
        block:SetTexture(unpack(OQ.CHART_COLORS[color]))
        block:SetAlpha(1)
        block:ClearAllPoints()
        block:SetPoint('RIGHT', self, 'TOPRIGHT', -10, -1 * y)
        block:SetWidth(10)
        block:SetHeight(10)
        block:Show()

        local str
        str = oq.label(self, cx - 10, y, 100, 15, L['-'], 'CENTER', 'RIGHT')
        str:SetFont(OQ.FONT, 10, '')
        str:SetTextColor(0.7, 0.7, 0.7, 1)
        str:ClearAllPoints()
        str:SetPoint('RIGHT', block, 'LEFT', -5, 0)
        str:Show()
        return str
    end
    f.gather_data = function(self)
        local hi = -math.huge
        local lo = math.huge
        local sum = 0
        local cnt = 0
        local total_cnt = 0
        for _, v in pairs(self._data) do
            if (v > 0) then
                hi = math.max(hi, v)
                if (v > 0) then
                    lo = math.min(lo, v)
                end
                cnt = cnt + 1
                sum = sum + v
            end
            total_cnt = total_cnt + 1
        end
        if (total_cnt == 0) then
            return 0, 0, 0, 0, 0
        end
        return lo, hi, (sum / cnt), cnt, total_cnt
    end
    f.init_data = function(self)
        self._data = tbl.new()
    end
    f.render_median = function(self)
        local lo, hi, avg, cnt, total_cnt = self:gather_data()
        local median = oq.stats.median(self._data, true)
        local max_cnt = 0
        local ndx, lowest, highest, dt
        -- reset all bar counts
        for i = 0, (OQ.GRAPH_NSLICES + 1) do
            self._bars[i]:set_zero()
        end
        self.key['green']._cnt = 0
        self.key['yellow']._cnt = 0
        self.key['red']._cnt = 0
        self.key['black']._cnt = 0

        lowest = median - OQ.GRAPH_TIMESPAN -- 10 second span around the pop; each bar == 200ms
        highest = median + OQ.GRAPH_TIMESPAN -- 10 second span around the pop; each bar == 200ms
        for key, v in pairs(self._data) do
            if (v) and (v > 0) then
                if (v < lowest) then
                    ndx = 0
                elseif (v > highest) then
                    ndx = (OQ.GRAPH_NSLICES + 1)
                else
                    ndx = math.min(OQ.GRAPH_NSLICES, math.max(1, floor((v - lowest) / OQ.GRAPH_TIMESLICE)))
                    dt = (v - median)
                    if (math.abs(dt) > OQ.GRAPH_BLACK) then -- blue; out of the running
                        self:set_bar(key, ndx, 'black', median)
                    elseif (math.abs(dt) > OQ.GRAPH_RED) then -- red; 1000 before and after... 2000ms window
                        self:set_bar(key, ndx, 'red', median)
                    elseif (math.abs(dt) > OQ.GRAPH_YELLOW) then -- yellow; 500 before and after... 1000ms window
                        self:set_bar(key, ndx, 'yellow', median)
                    else -- green
                        self:set_bar(key, ndx, 'green', median)
                    end
                end
                self._bars[ndx]._cnt = self._bars[ndx]._cnt + 1
                max_cnt = math.max(max_cnt, self._bars[ndx]._cnt)
            else
                self:set_bar(key, -1, 'nopop', median)
            end
        end
        for i = 0, (OQ.GRAPH_NSLICES + 1) do
            self._bars[i]:update(max_cnt)
        end
        self:set_key(total_cnt)
    end
    f.set_bar = function(self, key, ndx, color, median)
        if (ndx > -1) then
            self._bars[ndx]:set_color(color)
            self.key[color]._cnt = self.key[color]._cnt + 1
        end
        oq.set_member_pop_color(key, color, median)
    end
    f.set_data = function(self, ndx, value, donot_render)
        self._data[ndx] = value or 0
        if (not donot_render) then
            self:render_median()
        end
    end
    f.set_key = function(self, n)
        self.key['green']:SetText((self.key['green']._cnt == 0) and '-' or tostring(self.key['green']._cnt))
        self.key['yellow']:SetText((self.key['yellow']._cnt == 0) and '-' or tostring(self.key['yellow']._cnt))
        self.key['red']:SetText((self.key['red']._cnt == 0) and '-' or tostring(self.key['red']._cnt))
        self.key['black']:SetText((self.key['black']._cnt == 0) and '-' or tostring(self.key['black']._cnt))
        self.line1:SetText(string.format('n = %d', n))
    end
    f.zero_data = function(self)
        for key, _ in pairs(self._data) do
            self._data[key] = 0
        end
    end

    f:create_base()
    f:create_bars()
    f:create_labels()
    f:init_data()
    f:Show()
    return f
end

function oq.set_member_pop_color(ndx, color, median)
    local g_id = floor(ndx / 5) + 1
    local slot = floor(ndx % 5)
    if (oq.is_seat_empty(g_id, slot)) then
        return
    end
    if (oq.raid.raid_token) then
        local m = oq.raid.group[g_id].member[slot]
        m._queue_color = color
        m.bg[1].dt = (m.bg[1].queue_ts - median)
        oq.set_textures(g_id, slot)
    end
end

OQ.QUEUE_CONTROL_LABELS = {
    ['0'] = OQ.JOIN_QUEUE, -- none
    ['1'] = OQ.LEAVE_QUEUE, -- queue'd
    ['2'] = OQ.LEAVE_QUEUE, -- confirm
    ['3'] = OQ.LEAVE_QUEUE, -- inside
    ['4'] = OQ.LEAVE_QUEUE -- error
}
local tick01 = 0
function oq.update_tab1_queue_controls()
    local s1 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(1))]
    local s2 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(2))]

    oq.tab1_bg[1].queue_button:SetText(OQ.QUEUE_CONTROL_LABELS[s1])
    oq.tab1_bg[2].queue_button:SetText(OQ.QUEUE_CONTROL_LABELS[s2])
    if (s1 == '0') then
        oq.tab1_bg[1].queue_button:Disable()
    else
        oq.tab1_bg[1].queue_button:Enable()
    end
    if (s2 == '0') then
        oq.tab1_bg[2].queue_button:Disable()
    else
        oq.tab1_bg[2].queue_button:Enable()
    end

    oq.update_tab1_bg_count()
end

function oq.update_tab1_bg_count()
    oq.tab1._nInBattleground:SetText(tostring(oq.count_in_bg() or '-'))
end

-- how many from the premade are in the instance
--
function oq.count_in_bg()
    local n = nil
    if (oq.raid.raid_token == nil) then
        return nil
    end
    if (oq._inside_instance == 1) and (oq._instance_type == 'pvp') and (oq.raid.type == OQ.TYPE_BG) then
        SetBattlefieldScoreFaction(nil)
        local nplayers = GetNumBattlefieldScores()
        if (nplayers <= 10) then
            -- not inside, the call failed, or in an arena match
            return nil
        end
        if (WorldStateScoreFrame:IsVisible()) then
            return nil
        end
        local p_faction = 0 -- 0 == horde, 1 == alliance, -1 == offline
        if (oq.get_bg_faction() == 'A') then
            p_faction = 1
        end
        local statndx
        for i = 1, nplayers do
            local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class =
                GetBattlefieldScore(i)
            if (name) and (faction) and (faction == p_faction) and (oq.in_my_premade(name)) then
                n = (n or 0) + 1
            end
        end
    end
    return n
end

function oq.in_my_premade(name)
    return oq.is_in_raid(name)
end

function oq.create_tab1_battlegrounds(parent)
    local x, y, cx, cy, label_cx, t

    oq.tab1_group = oq.tab1_group or tbl.new()
    x = 20
    y = 65
    cx = parent:GetWidth() - 2 * x
    cy = (425 - 2 * y) / 10
    label_cx = 150

    -- groups
    for i = 1, 8 do
        local f = oq.create_group(parent, x, y, cx, cy, label_cx, tostring(i), i)
        f.slot = i
        f:Show()
        y = y + cy + 2
        oq.tab1_group[i] = f
    end

    -- battleground selector
    oq.tab1_bg = oq.tab1_bg or tbl.new()
    oq.tab1_bg[1] = oq.tab1_bg[1] or tbl.new()
    oq.tab1_bg[1].queue_button =
        oq.tab1_bg[1].queue_button or
        oq.button(
            parent,
            300,
            y + 15,
            100,
            28,
            'queue',
            function(self, button)
                oq.queue_button_action(self, button, 1)
            end
        )
    oq.tab1_bg[1].queue_button:RegisterForClicks('AnyUp')
    oq.tab1_bg[1].queue_button:SetText(OQ.JOIN_QUEUE)
    oq.tab1_bg[1].queue_button:Show()
    oq.tab1_bg[1].status = '0'

    oq.tab1_bg = oq.tab1_bg or tbl.new()
    oq.tab1_bg[2] = oq.tab1_bg[2] or tbl.new()
    oq.tab1_bg[2].queue_button =
        oq.tab1_bg[2].queue_button or
        oq.button(
            parent,
            650,
            y,
            100,
            28,
            'queue',
            function(self, button)
                oq.queue_button_action(self, button, 2)
            end
        )
    oq.tab1_bg[2].queue_button:RegisterForClicks('AnyUp')
    oq.tab1_bg[2].queue_button:SetText(OQ.JOIN_QUEUE)
    --  oq.tab1_bg[2].queue_button:Show();
    oq.tab1_bg[2].status = '0'

    parent._chart = oq.create_bg_queue_chart(parent, 450, 65, 300, 250)

    -- in-battleground count
    x = 450
    y = 65 + 250 + 20
    t = oq.label(parent, x + 175, y, 100, 20, L['# in battleground'])
    t = oq.label(parent, x + 300 - 58, y, 50, 20, L['0'], 'MIDDLE', 'RIGHT')
    oq.tab1._nInBattleground = t
end

function oq.create_tab1_dungeon(parent)
    local x, y, cx, cy, label_cx
    local group_id = 1 -- only one group

    x = 20
    y = 65
    cx = 50
    cy = 50
    label_cx = 150

    oq.dungeon_group = oq.create_dungeon_group(parent, x, y, parent:GetWidth() - x * 2, 250, label_cx, title, group_id)
end

function oq.create_tab1_challenge(parent)
    local x, y, label_cx
    local group_id = 1 -- only one group

    x = 20
    y = 65
    label_cx = 150

    oq.challenge_group =
        oq.create_challenge_group(parent, x, y, parent:GetWidth() - x * 2, 250, label_cx, title, group_id)
end

function oq.create_tab1_ratedbgs(parent)
    local x, y

    x = 20
    y = 65

    -- group menus
    oq.nthings = (oq.nthings or 0) + 1
    local space_x = 4
    local space_y = 4
    local ix = parent:GetWidth() - 2 * x - 4 * space_x
    local iy = parent:GetHeight() - (y + 105) - 1 * space_y
    local n = 'GroupRegion' .. oq.nthings

    local pcx = floor(ix / 5)
    local pcy = floor(iy / 2)

    oq.rbgs_group = tbl.new()

    for i = 1, 2 do
        x = 20
        oq.rbgs_group[i] = tbl.new()
        oq.rbgs_group[i].slots = tbl.new()
        for j = 1, 5 do
            oq.rbgs_group[i].slots[j] = oq.create_dungeon_dot(parent, x, y, pcx, pcy)
            oq.rbgs_group[i].slots[j].gid = i
            oq.rbgs_group[i].slots[j].slot = j
            oq.rbgs_group[i].slots[j]:Show()
            x = x + pcx + space_x
        end
        y = y + pcy + space_y
    end
end

function oq.create_tab1_raid(parent)
    local x, y, cx, cy, label_cx

    oq.raid_group = tbl.new()
    x = 20
    y = 65
    cx = parent:GetWidth() - 2 * x
    cy = (425 - 2 * y) / 10
    label_cx = 150

    -- groups
    for i = 1, 8 do
        local f = oq.create_group(parent, x, y, cx, cy, label_cx, tostring(i), i)
        f.slot = i
        f:Show()
        y = y + cy + 2
        oq.raid_group[i] = f
    end
end

function oq.create_tab1_scenario(parent)
    local x, y, label_cx
    local group_id = 1 -- only one group

    x = 20
    y = 65
    label_cx = 150

    oq.scenario_group =
        oq.create_scenario_group(parent, x, y, parent:GetWidth() - x * 2, 250, label_cx, title, group_id)
end

function oq.create_tab1_arena(parent)
    local x, y, label_cx
    local group_id = 1 -- only one group

    x = 20
    y = 65
    label_cx = 150

    oq.arena_group = oq.create_arena_group(parent, x, y, parent:GetWidth() - x * 2, 250, label_cx, title, group_id)
end

function oq.create_tab1_ladder(parent)
    local x, y, cx, cy, label_cx
    local group_id = 1 -- only one group

    x = 20
    y = 65
    cx = parent:GetWidth() - 2 * x
    cy = 250
    label_cx = 150

    oq.ladder_group = oq.create_ladder_group(parent, x, y, cx, cy, label_cx, title, group_id)

    -- create ladder seats
    oq.ladder_seats = oq.create_ladder_seats(parent, x, y, cx, cy)

    x = x + (cx - 100) / 2
    oq.button(
        parent,
        x,
        cy,
        100,
        28,
        OQ.MATCHUP,
        function(self)
            self:GetParent().matchup(self)
        end
    )
end

function oq.create_ladder_seats(parent, x_, y_, cx_, cy_)
    local seats = tbl.new()
    local ndx = 1
    local x, y, cx, cy, dy

    cx = 20
    cy = 20
    --

    --[[ 1st round - elimination round ]] dy = 8
    -- left side
    x = x_ + cx / 2
    y = y_

    for i = 1, 8 do
        seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
        ndx = ndx + 1
        y = y + cy + dy
        if ((i % 2) == 0) then
            y = y + dy
        end
    end

    -- right side
    x = x_ + cx_ - 3 * cx / 2
    y = y_
    for i = 1, 8 do
        seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
        ndx = ndx + 1
        y = y + cy + dy
        if ((i % 2) == 0) then
            y = y + dy
        end
    end
    --

    --[[ 2nd round - quarter finals ]] dy = 12
    -- left side
    x = x_ + (cx_ / 8)
    y = y_ + (cy_ / 4) - (cy + dy)
    for i = 1, 4 do
        seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
        ndx = ndx + 1
        y = y + cy + dy
        if ((i % 2) == 0) then
            y = y_ + (3 * cy_ / 4) - (cy + dy)
        end
    end
    -- right side
    x = x_ + cx_ - (cx_ / 8) - cx
    y = y_ + (cy_ / 4) - (cy + dy)
    for i = 1, 4 do
        seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
        ndx = ndx + 1
        y = y + cy + dy
        if ((i % 2) == 0) then
            y = y_ + (3 * cy_ / 4) - (cy + dy)
        end
    end
    --

    --[[ 3rd round - semi finals ]] dy = 16
    -- left side
    x = x_ + (2 * cx_ / 8)
    y = y_ + (cy_ / 2) - (cy + dy)
    seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
    ndx = ndx + 1
    y = y_ + (cy_ / 2) + dy
    seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
    ndx = ndx + 1

    -- right side
    x = x_ + cx_ - (2 * cx_ / 8) - cx
    y = y_ + (cy_ / 2) - (cy + dy)
    seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
    ndx = ndx + 1
    y = y_ + (cy_ / 2) + dy
    seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
    ndx = ndx + 1 -- left side
    --

    --[[ final round ]] x = x_ + (3 * cx_ / 8)
    y = y_ + (cy_ / 2) - cy / 2
    seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)
    ndx = ndx + 1
    -- right side
    x = x_ + cx_ - (3 * cx_ / 8) - cx
    y = y_ + (cy_ / 2) - cy / 2
    seats[ndx] = oq.create_ladder_seat(parent, x, y, cx, cy)

    return seats
end

function oq.update_tab1_common()
    local r = oq.premades[oq.raid.raid_token]
    if (r == nil) then
        return
    end
    oq.tab1_name:SetText(r.name)
    oq.tab1._notes:SetText(oq.raid.notes)
    oq.tab1._voip:SetTexture(OQ.VOIP_ICON[r.voip])
    oq.tab1._lang:SetTexture(OQ.LANG_ICON[r.lang])
end

function oq.create_tab1_common(parent)
    local x, y, cx, cy, label_cx
    x = 20
    y = 65

    cx = parent:GetWidth() - 2 * x
    cy = (425 - 2 * y) / 10
    label_cx = 150

    -- raid title
    oq.tab1_name = oq.label(parent, x, 30, 300, 30, '')
    oq.tab1_name:SetFont(OQ.FONT, 14, '')

    -- voip and language flags
    y = parent:GetHeight() - cy * 3 - 45
    oq.tab1._voip = parent:CreateTexture(nil, 'OVERLAY')
    oq.tab1._voip:SetWidth(22)
    oq.tab1._voip:SetHeight(22)
    oq.tab1._voip:SetAlpha(0.85)
    oq.tab1._voip:Show()
    oq.tab1._voip:SetTexture(nil)
    oq.moveto(oq.tab1._voip, x, y)

    oq.tab1._lang = parent:CreateTexture(nil, 'OVERLAY')
    oq.tab1._lang:SetWidth(22)
    oq.tab1._lang:SetHeight(22)
    oq.tab1._lang:SetAlpha(0.85)
    oq.tab1._lang:Show()
    oq.tab1._lang:SetTexture(nil)
    oq.moveto(oq.tab1._lang, x + 25, y)

    -- raid notes
    y = y + 35
    oq.tab1._notes_label = oq.label(parent, x, y, 100, 20, L['Notes:'])
    oq.tab1._notes = oq.label(parent, x, y + 12, 285, cy * 2 - 10, '')
    oq.tab1._notes:SetNonSpaceWrap(true)
    oq.tab1._notes_label:SetTextColor(0.7, 0.7, 0.7, 1)
    oq.tab1._notes:SetTextColor(0.9, 0.9, 0.9, 1)
    --

    --[[ tag and version ]]
    OQFrameHeaderLogo:SetText(OQ.TITLE_LEFT .. OQUEUE_VERSION .. OQ.TITLE_RIGHT)

    -- brb button
    oq.tab1._brb_button =
        oq.button(
        parent,
        300,
        y,
        100,
        28,
        OQ.ILL_BRB,
        function()
            oq.brb()
        end
    )

    -- lucky charms
    y = y + 30
    oq.tab1._lucky_charms =
        oq.button(
        parent,
        200,
        parent:GetHeight() - 40,
        100,
        25,
        OQ.LUCKY_CHARMS,
        function()
            oq.assign_lucky_charms()
        end
    )
    oq.tab1._lucky_charms:Hide()
    -- ready check
    oq.tab1._readycheck_button =
        oq.button(
        parent,
        300,
        parent:GetHeight() - 40,
        100,
        25,
        OQ.READY_CHK,
        function()
            oq.start_ready_check()
        end
    )

    -- roll check
    oq.tab1._rolecheck_button =
        oq.button(
        parent,
        400,
        parent:GetHeight() - 40,
        100,
        25,
        OQ.ROLE_CHK,
        function()
            InitiateRolePoll()
        end
    )

    -- quit premade
    oq.tab1._quit_button =
        oq.button(
        parent,
        parent:GetWidth() - 155,
        parent:GetHeight() - 40,
        145,
        25,
        OQ.LEAVE_PREMADE,
        function()
            oq.quit_raid()
        end
    )

    -- raid stats (ie: "5 / 4000 / 455" )
    x = parent:GetWidth() - 265
    y = parent:GetHeight() - 35
    oq.tab1._raid_stats = oq.label(parent, x, y, 100, 15, '')
    oq.tab1._raid_stats:SetJustifyH('RIGHT')
    oq.tab1._raid_stats:SetTextColor(0.8, 0.8, 0.8, 1)

    parent._resize = function(self)
        local cy = self:GetHeight()
        oq.move_y(self._voip, cy - 25 * 2 - 70)
        oq.move_y(self._lang, cy - 25 * 2 - 70)
        oq.move_y(self._notes_label, cy - 25 * 2 - 50)
        oq.move_y(self._brb_button, cy - 25 * 2 - 45)
        oq.move_y(self._notes, cy - 25 * 2 - 38)
        oq.move_y(self._lucky_charms, cy - 40)
        oq.move_y(self._readycheck_button, cy - 40)
        oq.move_y(self._rolecheck_button, cy - 40)
        oq.move_y(self._raid_stats, cy - 35)
        oq.move_y(self._quit_button, cy - 40)
        oq.theme_resize(self)
    end
end

function oq.set_premade_type(t)
    oq.raid.type = t
    if (oq.iam_raid_leader()) then
        -- bg2
        if
            (t == OQ.TYPE_BG) or (t == OQ.TYPE_RBG) or (t == OQ.TYPE_RAID) or (t == OQ.TYPE_MISC) or
                (t == OQ.TYPE_ROLEPLAY)
         then
            ConvertToRaid()
        else
            ConvertToParty()
        end
    end

    if (OQTabPage7.header1 ~= nil) then
        if (oq.is_dungeon_premade(oq.raid.type) or (oq.raid.type == OQ.TYPE_RAID)) then
            -- change headers
            OQTabPage7.header1.label:SetText(OQ.HDR_HASTE)
            OQTabPage7.header1.sortby = 'haste'
            OQTabPage7.header2.label:SetText(OQ.HDR_MASTERY)
            OQTabPage7.header2.sortby = 'mastery'
            OQTabPage7.header3.label:SetText(OQ.HDR_HIT)
            OQTabPage7.header3.sortby = 'hit'
        else
            -- change headers
            OQTabPage7.header1.label:SetText(OQ.HDR_RESIL)
            OQTabPage7.header1.sortby = 'resil'
            OQTabPage7.header2.label:SetText(OQ.HDR_PVPPOWER)
            OQTabPage7.header2.sortby = 'power'
            OQTabPage7.header3.label:SetText(OQ.HDR_MMR)
            OQTabPage7.header3.sortby = 'mmr'
        end
    end

    -- hide all
    oq.ui.battleground_frame:Hide()
    oq.ui.challenge_frame:Hide()
    oq.ui.dungeon_frame:Hide()
    oq.ui.ratedbgs_frame:Hide()
    oq.ui.arena_frame:Hide()
    oq.ui.raid_frame:Hide()
    oq.ui.scenario_frame:Hide()
    --  oq.ui.ladder_frame   :Hide();

    if (OQTabPage1:IsVisible()) then
        -- force the showing of the frame, incase the type changed
        oq.onShow_tab1()
        oq.refresh_textures()
    end
end

function oq.onShow_tab1()
    -- hide all
    oq.ui.battleground_frame:Hide()
    oq.ui.challenge_frame:Hide()
    oq.ui.dungeon_frame:Hide()
    oq.ui.ratedbgs_frame:Hide()
    oq.ui.arena_frame:Hide()
    oq.ui.raid_frame:Hide()
    oq.ui.scenario_frame:Hide()
    --  oq.ui.ladder_frame   :Hide();

    if (oq.raid.type == OQ.TYPE_BG) then
        oq.ui.battleground_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_CHALLENGE) then
        oq.ui.challenge_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_DUNGEON) then
        oq.ui.dungeon_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_MISC) then
        oq.ui.ratedbgs_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_RBG) then
        oq.ui.ratedbgs_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_RAID) then
        oq.ui.raid_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_ROLEPLAY) then
        oq.ui.raid_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_SCENARIO) then
        oq.ui.scenario_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_ARENA) then
        oq.ui.arena_frame:Show()
    elseif (oq.raid.type == OQ.TYPE_QUESTS) then
        oq.ui.challenge_frame:Show()
    --  elseif (oq.raid.type == OQ.TYPE_LADDER) then
    --    oq.ui.ladder_frame:Show();
    end
end

function oq.theme_resize(parent)
    if (parent) and (parent.backdrop) then
        parent.backdrop:SetWidth(floor(parent:GetWidth()) - 10)
        parent.backdrop:SetHeight(floor(parent:GetHeight()) - 10)
    end
end

function oq.create_tab1()
    local cx = OQTabPage1:GetWidth()
    local cy = OQTabPage1:GetHeight()
    local level = OQTabPage1:GetFrameLevel() + 2

    oq.tab1 = OQTabPage1

    OQTabPage1:SetScript(
        'OnShow',
        function()
            oq.onShow_tab1()
            oq.refresh_textures()
            if (oq.iam_raid_leader()) then
                oq.ui_raidleader()
            else
                oq.ui_player()
            end
            oq.timer('upd_bg_count', 5, oq.update_tab1_bg_count, true)
            oq.update_tab1_bg_count()
        end
    )

    OQTabPage1:SetScript(
        'OnHide',
        function()
            oq.timer('upd_bg_count', 5, nil, true)
        end
    )

    -- create common elements
    oq.create_tab1_common(OQTabPage1)

    -- create specific component: battlegrounds
    oq.ui.battleground_frame = oq.panel(OQTabPage1, 'OQBattlegrounds', 0, 0, cx, cy, true)
    oq.ui.battleground_frame:SetFrameLevel(level)
    oq.create_tab1_battlegrounds(oq.ui.battleground_frame)
    oq.update_tab1_queue_controls()

    -- create specific component: dungeons
    oq.ui.dungeon_frame = oq.panel(OQTabPage1, 'OQPage1Dungeon', 0, 0, cx, cy, true)
    oq.ui.dungeon_frame:SetFrameLevel(level)
    oq.create_tab1_dungeon(oq.ui.dungeon_frame)

    -- create specific component: challenge
    oq.ui.challenge_frame = oq.panel(OQTabPage1, 'OQPage1Challenge', 0, 0, cx, cy, true)
    oq.ui.challenge_frame:SetFrameLevel(level)
    oq.create_tab1_challenge(oq.ui.challenge_frame)

    -- create specific component: rated-bgs
    oq.ui.ratedbgs_frame = oq.panel(OQTabPage1, 'OQPage1RatedBGs', 0, 0, cx, cy, true)
    oq.ui.ratedbgs_frame:SetFrameLevel(level)
    oq.create_tab1_ratedbgs(oq.ui.ratedbgs_frame)

    -- create specific component: raid
    oq.ui.raid_frame = oq.panel(OQTabPage1, 'OQPage1Raid', 0, 0, cx, cy, true)
    oq.ui.raid_frame:SetFrameLevel(level)
    oq.create_tab1_raid(oq.ui.raid_frame)

    -- create specific component: scenario
    oq.ui.scenario_frame = oq.panel(OQTabPage1, 'OQPage1Scenario', 0, 0, cx, cy, true)
    oq.ui.scenario_frame:SetFrameLevel(level)
    oq.create_tab1_scenario(oq.ui.scenario_frame)

    -- create specific component: arena
    oq.ui.arena_frame = oq.panel(OQTabPage1, 'OQPage1Arena', 0, 0, cx, cy, true)
    oq.ui.arena_frame:SetFrameLevel(level)
    oq.create_tab1_arena(oq.ui.arena_frame)

    -- create specific component: ladder
    --  oq.ui.ladder_frame = oq.panel(OQTabPage1, "OQPage1Ladder", 0, 0, cx, cy, true);
    --  oq.ui.ladder_frame:SetFrameLevel(level);
    --  oq.create_tab1_ladder(oq.ui.ladder_frame);
    --  oq.ui.ladder_frame.matchup = oq.ladder_matchup ;

    -- show appropriate frame
    if (oq.raid == nil) or (oq.raid.type == nil) then
        oq.set_premade_type(OQ.TYPE_BG)
    else
        oq.set_premade_type(oq.raid.type)
    end

    -- enable proper controls
    oq.ui_player()
end

function oq.ladder_matchup()
    print('match up')
    local slots = oq.ladder_group.slots
    -- move dots 2-16 into ladder positions... randomly
end

--  TODO: lighter weight scrolling:
--
--  http://us.battle.net/wow/en/forum/topic/9499431654
--
function oq.create_scrolling_list(parent, type_)
    local scroll = oq.CreateFrame('ScrollFrame', parent:GetName() .. 'ListScrollBar', parent, 'FauxScrollFrameTemplate')
    scroll.scroll_update = scroll_update_ or OQ_ModScrollBar_Update
    scroll:SetScript(
        'OnShow',
        function(self)
            self:scroll_update()
        end
    )
    scroll:SetScript(
        'OnVerticalScroll',
        function(self, offset)
            if (self._scroll_func) then
                self._scroll_func(self, offset, 16, self.scroll_update)
            else
                FauxScrollFrame_OnVerticalScroll(self, offset, 16, self.scroll_update)
            end
        end
    )
    scroll._type = type_

    local list = oq.CreateFrame(list_frame_type_ or 'Frame', parent:GetName() .. 'List', scroll)
    if (oq.__backdrop06 == nil) then
        oq.__backdrop06 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    list:SetBackdrop(oq.__backdrop06)
    list:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    oq.setpos(list, 0, 0, parent:GetWidth() - 2 * 30, 1000)

    scroll:SetScrollChild(list)
    scroll:Show()

    return scroll, list
end

function oq.sort_premades(col)
    local order = OQ_data.premade_sort_ascending
    if (OQ_data.premade_sort ~= col) then
        order = true
    else
        if (order) then
            order = nil
        else
            order = true
        end
    end
    OQ_data.premade_sort = col
    OQ_data.premade_sort_ascending = order
    oq.reshuffle_premades_now()
end

function oq.on_premade_filter(arg1, arg2, exclude, force_off)
    if (arg1) and (exclude) then
        OQ_data._premade_exclusion = OQ_data._premade_exclusion or tbl.new()

        if (OQ_data._premade_exclusion[arg1]) and (force_off == nil) then
            OQ_data._premade_exclusion[arg1] = nil
        else
            OQ_data._premade_exclusion[arg1] = 1
            if (arg1 == OQ_data.premade_filter_type) and (OQ_data.premade_filter_type ~= OQ.TYPE_NONE) then
                oq.on_premade_filter(OQ.TYPE_NONE, OQ.LABEL_ALL) -- if you exclude what you've selected, you unselect
            end
        end
    elseif (arg1) then
        OQ_data.premade_filter_type = arg1
        oq.tab2._filter._edit:SetText(arg2 or '')
        if (OQ_data._premade_exclusion) and (OQ_data._premade_exclusion[arg1]) then
            OQ_data._premade_exclusion[arg1] = nil -- if you filter FOR a premade you had excluded, it will re-include it
        end
    end
    oq.tab2._scroller:SetVerticalScroll(0)
    oq.reshuffle_premades_now()
end

function oq.premade_type_selection(id)
    oq.tab3_radio_buttons(id, OQ.premade_selections[id] or '')
    OQ_data._premade_type = id
end

OQ.premade_selections = {
    [OQ.TYPE_BG] = OQ.LABEL_BG,
    [OQ.TYPE_ARENA] = OQ.LABEL_ARENA,
    [OQ.TYPE_CHALLENGE] = OQ.LABEL_CHALLENGE,
    [OQ.TYPE_DUNGEON] = OQ.LABEL_DUNGEON,
    [OQ.TYPE_QUESTS] = OQ.LABEL_QUESTING,
    [OQ.TYPE_RBG] = OQ.LABEL_RBG,
    [OQ.TYPE_RAID] = OQ.LABEL_RAID,
    [OQ.TYPE_SCENARIO] = OQ.LABEL_SCENARIO,
    [OQ.TYPE_MISC] = OQ.LABEL_MISC,
    [OQ.TYPE_ROLEPLAY] = OQ.LABEL_ROLEPLAY
}
function oq.make_dropdown_premade_type_selector()
    local m = oq.menu_create()
    for arg, text in tbl.orderedByValuePairs(OQ.premade_selections) do
        oq.menu_add(text, arg, text, nil,
            function(_, arg1)
                oq.premade_type_selection(arg1)
            end
        )
    end
    return m
end

function oq.premade_difficulty_selection(id)
    OQ_data._premade_diff = id
    oq.tab3._diff.texture:SetTexture(OQ.DIFFICULTY_ICON[id or 0])
end

OQ.difficulty_selections = {
    [3] = L['10N'],
    [4] = L['25N'],
    [5] = L['10H'],
    [6] = L['25H'],
    [7] = L['LFR'],
    [14] = L['flex']
}

function oq.make_dropdown_difficulty_filter()
    local m = oq.menu_create()
    local arg, text
    for diff_id, _ in tbl.orderedPairs(OQ.difficulty_selections) do
        local desc = OQ._difficulty[diff_id].desc
        oq.menu_add(
            desc,
            diff_id,
            desc,
            nil,
            function(_, arg1, arg2)
                oq.premade_difficulty_selection(arg1, arg2)
            end
        )
    end
    return m
end

--
function oq.enable_premade_subtypes()
    oq.tab3._subtype:Enable()
    oq.tab3._diff:Enable()
    oq.premade_subtype_selection(OQ_data._premade_subtype)
    oq.premade_difficulty_selection(OQ_data._premade_diff)
end

function oq.disable_premade_subtypes()
    oq.tab3._subtype:Disable()
    oq.tab3._diff:Disable()
    oq.tab3._diff.texture:SetTexture(nil)
    oq.tab3._subtype._edit:SetText('')
end

function oq.premade_subtype_selection(id, text)
    OQ_data._premade_subtype = id
    oq.tab3._subtype._edit:SetText(oq.get_raid_name(id) or text or '')
    if (id == 0) or (id == 63) then
        OQ_data._premade_subtype = 0
        oq.premade_difficulty_selection(0)
    end
end

function oq.make_dropdown_premade_subtype_selector()
    if (OQ_data._premade_type ~= OQ.TYPE_RAID) then
        return
    end
    local m = oq.menu_create()

    oq.menu_add(
        L['< general >'],
        0,
        '',
        nil,
        function(_, arg1, arg2)
            oq.premade_subtype_selection(arg1, arg2)
        end
    )
    oq.menu_add(
        L['< world boss >'],
        63,
        '',
        nil,
        function(_, arg1, arg2)
            oq.premade_subtype_selection(arg1, arg2)
        end
    )

    for raid_id, text in tbl.orderedByValuePairs(OQ.raid_ids) do
        if (raid_id ~= L['World Boss']) then
            oq.menu_add(
                raid_id,
                text,
                raid_id,
                nil,
                function(_, arg1, arg2)
                    oq.premade_subtype_selection(arg1, arg2)
                end
            )
        end
    end
    return m
end
--

function oq.get_voip_count(id)
    local n = 0
    local ex1 = OQ_data._voip_exclusion[id]
    local ex2 = oq.tab2._voip._id
    OQ_data._voip_exclusion[id] = nil
    oq.tab2._voip._id = OQ.VOIP_UNSPECIFIED
    for _, p in pairs(oq.premades) do
        if (p.voip == id) then
            if
                (((OQ_data.premade_filter_qualified == 1) and (oq.qualified(p.raid_token))) or
                    (OQ_data.premade_filter_qualified == 0)) and
                    oq.pass_filter(p)
             then
                n = n + 1
            end
        end
    end
    OQ_data._voip_exclusion[id] = ex1
    oq.tab2._voip._id = ex2
    if (n == 0) then
        return ''
    end
    return ' (|cFFFFD331' .. tostring(n) .. '|r)'
end

function oq.get_lang_count(id)
    local n = 0
    local ex1 = OQ_data._lang_exclusion[id]
    local ex2 = oq.tab2._lang._id
    OQ_data._lang_exclusion[id] = nil
    oq.tab2._lang._id = OQ.LANG_UNSPECIFIED

    for _, p in pairs(oq.premades) do
        if (p.lang == id) then
            if
                (((OQ_data.premade_filter_qualified == 1) and (oq.qualified(p.raid_token))) or
                    (OQ_data.premade_filter_qualified == 0)) and
                    oq.pass_filter(p)
             then
                n = n + 1
            end
        end
    end
    OQ_data._lang_exclusion[id] = ex1
    oq.tab2._lang._id = ex2
    if (n == 0) then
        return ''
    end
    return ' (|cFFFFD331' .. tostring(n) .. '|r)'
end

function oq.is_voip_excluded(id)
    return (OQ_data._voip_exclusion) and (OQ_data._voip_exclusion[id])
end

function oq.is_lang_excluded(id)
    return (OQ_data._lang_exclusion) and (OQ_data._lang_exclusion[id])
end

function oq.is_premade_excluded(id)
    return (OQ_data._premade_exclusion) and (OQ_data._premade_exclusion[id])
end

function oq.voip_selection(id)
    oq.tab3._voip._edit:SetText(OQ.voip_selections[id] or '')
    oq.tab3._voip_emblem:SetTexture(OQ.VOIP_ICON[id])
    oq.tab3._voip._id = id
    OQ_data._voip = id
end

OQ.voip_selections = {
    [OQ.VOIP_UNSPECIFIED] = OQ.LABEL_UNSPECIFIED,
    [OQ.VOIP_DISCORD] = OQ.LABEL_DISCORD,
    [OQ.VOIP_NOVOICE] = OQ.LABEL_NOVOICE,
    [OQ.VOIP_TEAMSPEAK] = OQ.LABEL_TEAMSPEAK,
    [OQ.VOIP_VENTRILO] = OQ.LABEL_VENTRILO,
    [OQ.VOIP_WOWVOIP] = OQ.LABEL_WOWVOIP
}
function oq.add_voip_subselection(arg, text, func)
    local t = '|T'
    if (OQ.VOIP_ICON[arg]) then
        t = t .. OQ.VOIP_ICON[arg]
    else
        t = t .. 'Interface\\Addons\\oqueue\\art\\voip\\unk.tga'
    end
    t = t .. ':20:20:0:0|t  ' .. text
    oq.menu_add(t, arg, t, nil, func)
end

function oq.make_dropdown_voip_selector()
    local m = oq.menu_create()

    oq.add_voip_subselection(
        OQ.VOIP_NOVOICE,
        OQ.LABEL_NOVOICE,
        function(_, arg1)
            oq.voip_selection(arg1)
        end
    )
    for arg, text in tbl.orderedByValuePairs(OQ.voip_selections) do
        if (arg ~= OQ.VOIP_UNSPECIFIED) and (arg ~= OQ.VOIP_NOVOICE) then
            oq.add_voip_subselection(
                arg,
                text,
                function(_, arg1)
                    oq.voip_selection(arg1)
                end
            )
        end
    end
    return m
end

function oq.add_voip_suboption(arg, text, func)
    local t = '|T'
    local cnt = ''
    if (OQ.VOIP_ICON[arg]) then
        t = t .. OQ.VOIP_ICON[arg]
        cnt = oq.get_voip_count(arg)
    else
        t = t .. 'Interface\\Addons\\oqueue\\art\\voip\\unk.tga'
    end
    if (oq.is_voip_excluded(arg)) then
        t = t .. ':20:20:0:0|t  |cFF606060' .. text .. '|r' .. cnt
    else
        t = t .. ':20:20:0:0|t  ' .. text .. cnt
    end
    oq.menu_add(t, arg, t, nil, func)
end

function oq.make_dropdown_voip_filter()
    if (OQ_data._voip_exclusion == nil) then
        OQ_data._voip_exclusion = tbl.new()
    end
    local m = oq.menu_create()

    oq.add_voip_suboption(
        OQ.VOIP_UNSPECIFIED,
        OQ.LABEL_UNSPECIFIED,
        function(_, arg1, _, button)
            oq.set_voip_filter(arg1, (button == 'RightButton'))
        end
    )
    oq.add_voip_suboption(
        OQ.VOIP_NOVOICE,
        OQ.LABEL_NOVOICE,
        function(_, arg1, _, button)
            oq.set_voip_filter(arg1, (button == 'RightButton'))
        end
    )
    for arg, text in tbl.orderedByValuePairs(OQ.voip_selections) do
        if (arg ~= OQ.VOIP_UNSPECIFIED) and (arg ~= OQ.VOIP_NOVOICE) then
            oq.add_voip_suboption(
                arg,
                text,
                function(_, arg1, _, button)
                    oq.set_voip_filter(arg1, (button == 'RightButton'))
                end
            )
        end
    end
    return m
end

OQ.lang_selections = {
    [OQ.LANG_UNSPECIFIED] = OQ.LABEL_UNSPECIFIED,
    [OQ.LANG_US_ENGLISH] = OQ.LABEL_US_ENGLISH,
    [OQ.LANG_UK_ENGLISH] = OQ.LABEL_UK_ENGLISH,
    [OQ.LANG_OC_ENGLISH] = OQ.LABEL_OC_ENGLISH,
    [OQ.LANG_FRENCH] = OQ.LABEL_FRENCH,
    [OQ.LANG_GERMAN] = OQ.LABEL_GERMAN,
    [OQ.LANG_ITALIAN] = OQ.LABEL_ITALIAN,
    [OQ.LANG_BR_PORTUGUESE] = OQ.LABEL_BR_PORTUGUESE,
    [OQ.LANG_PT_PORTUGUESE] = OQ.LABEL_PT_PORTUGUESE,
    [OQ.LANG_RUSSIAN] = OQ.LABEL_RUSSIAN,
    [OQ.LANG_ES_SPANISH] = OQ.LABEL_ES_SPANISH,
    [OQ.LANG_MX_SPANISH] = OQ.LABEL_MX_SPANISH,
    [OQ.LANG_TURKISH] = OQ.LABEL_TURKISH,
    [OQ.LANG_GREEK] = OQ.LABEL_GREEK,
    [OQ.LANG_EURO] = OQ.LABEL_EURO,
    [OQ.LANG_DUTCH] = OQ.LABEL_DUTCH,
    [OQ.LANG_SWEDISH] = OQ.LABEL_SWEDISH,
    [OQ.LANG_ARABIC] = OQ.LABEL_ARABIC,
    [OQ.LANG_KOREAN] = OQ.LABEL_KOREAN
}
function oq.add_lang_subselection(arg, text, func)
    local t = '|T'
    if (OQ.LANG_ICON[arg]) then
        t = t .. OQ.LANG_ICON[arg]
    else
        t = t .. 'Interface\\Addons\\oqueue\\art\\lang\\unk.tga'
    end
    t = t .. ':16:20:0:0|t  ' .. text
    oq.menu_add(t, arg, t, nil, func)
end

function oq.make_dropdown_lang_selector()
    local m = oq.menu_create()

    oq.add_lang_subselection(
        OQ.LANG_US_ENGLISH,
        OQ.LABEL_US_ENGLISH,
        function(_, arg1)
            oq.set_lang_preference(arg1)
        end
    )
    oq.add_lang_subselection(
        OQ.LANG_UK_ENGLISH,
        OQ.LABEL_UK_ENGLISH,
        function(_, arg1)
            oq.set_lang_preference(arg1)
        end
    )
    oq.add_lang_subselection(
        OQ.LANG_OC_ENGLISH,
        OQ.LABEL_OC_ENGLISH,
        function(_, arg1)
            oq.set_lang_preference(arg1)
        end
    )
    for arg, text in tbl.orderedByValuePairs(OQ.lang_selections) do
        if
            (arg ~= OQ.LANG_UNSPECIFIED) and (arg ~= OQ.LANG_US_ENGLISH) and (arg ~= OQ.LANG_UK_ENGLISH) and
                (arg ~= OQ.LANG_OC_ENGLISH)
         then
            oq.add_lang_subselection(
                arg,
                text,
                function(_, arg1)
                    oq.set_lang_preference(arg1)
                end
            )
        end
    end
    return m
end

function oq.add_lang_suboption(arg, text, func)
    local t = '|T'
    local cnt = ''
    if (OQ.LANG_ICON[arg]) then
        t = t .. OQ.LANG_ICON[arg]
        cnt = oq.get_lang_count(arg)
    else
        t = t .. 'Interface\\Addons\\oqueue\\art\\lang\\unk.tga'
    end
    if (oq.is_lang_excluded(arg)) then
        t = t .. ':16:20:0:0|t  |cFF606060' .. text .. '|r' .. cnt
    else
        t = t .. ':16:20:0:0|t  ' .. text .. cnt
    end
    oq.menu_add(t, arg, t, nil, func)
end

function oq.make_dropdown_lang_filter()
    if (OQ_data._lang_exclusion == nil) then
        OQ_data._lang_exclusion = tbl.new()
    end
    local m = oq.menu_create()

    oq.add_lang_suboption(
        OQ.LANG_UNSPECIFIED,
        OQ.LABEL_UNSPECIFIED,
        function(_, arg1, _, button)
            oq.set_lang_filter(arg1, (button == 'RightButton'))
        end
    )
    oq.add_lang_suboption(
        OQ.LANG_US_ENGLISH,
        OQ.LABEL_US_ENGLISH,
        function(_, arg1, _, button)
            oq.set_lang_filter(arg1, (button == 'RightButton'))
        end
    )
    oq.add_lang_suboption(
        OQ.LANG_UK_ENGLISH,
        OQ.LABEL_UK_ENGLISH,
        function(_, arg1, _, button)
            oq.set_lang_filter(arg1, (button == 'RightButton'))
        end
    )
    oq.add_lang_suboption(
        OQ.LANG_OC_ENGLISH,
        OQ.LABEL_OC_ENGLISH,
        function(_, arg1, _, button)
            oq.set_lang_filter(arg1, (button == 'RightButton'))
        end
    )
    for arg, text in tbl.orderedByValuePairs(OQ.lang_selections) do
        if
            (arg ~= OQ.LANG_UNSPECIFIED) and (arg ~= OQ.LANG_US_ENGLISH) and (arg ~= OQ.LANG_UK_ENGLISH) and
                (arg ~= OQ.LANG_OC_ENGLISH)
         then
            oq.add_lang_suboption(
                arg,
                text,
                function(_, arg1, _, button)
                    oq.set_lang_filter(arg1, (button == 'RightButton'))
                end
            )
        end
    end
    return m
end

OQ._premade_types = {
    [OQ.TYPE_NONE] = OQ.LABEL_ALL,
    [OQ.TYPE_ARENA] = OQ.LABEL_ARENAS,
    [OQ.TYPE_BG] = OQ.LABEL_BGS,
    [OQ.TYPE_DUNGEON] = OQ.LABEL_DUNGEONS,
    [OQ.TYPE_QUESTS] = OQ.LABEL_QUESTING,
    [OQ.TYPE_RBG] = OQ.LABEL_RBGS,
    [OQ.TYPE_RAID] = OQ.LABEL_RAIDS,
    [OQ.TYPE_SCENARIO] = OQ.LABEL_SCENARIOS,
    [OQ.TYPE_CHALLENGE] = OQ.LABEL_CHALLENGES,
    [OQ.TYPE_MISC] = OQ.LABEL_MISC,
    [OQ.TYPE_ROLEPLAY] = OQ.LABEL_ROLEPLAY,
    [OQ.TYPE_ALL_PENDING] = OQ.LABEL_ALL_PENDING
}
function oq.get_premade_type_desc(t)
    return OQ._premade_types[t] or ''
end

--
-- good page for docs:
-- http://www.wowpedia.org/API_UIDropDownMenu_AddButton
--

OQ.findpremade_types = {
    [OQ.TYPE_NONE] = OQ.LABEL_ALL,
    [OQ.TYPE_ALL_PENDING] = OQ.LABEL_ALL_PENDING,
    [OQ.TYPE_ARENA] = OQ.LABEL_ARENAS,
    [OQ.TYPE_BG] = OQ.LABEL_BGS,
    [OQ.TYPE_CHALLENGE] = OQ.LABEL_CHALLENGES,
    [OQ.TYPE_DUNGEON] = OQ.LABEL_DUNGEONS,
    [OQ.TYPE_QUESTS] = OQ.LABEL_QUESTING,
    [OQ.TYPE_RBG] = OQ.LABEL_RBGS,
    [OQ.TYPE_RAID] = OQ.LABEL_RAIDS,
    [OQ.TYPE_SCENARIO] = OQ.LABEL_SCENARIOS,
    [OQ.TYPE_MISC] = OQ.LABEL_MISC,
    [OQ.TYPE_ROLEPLAY] = OQ.LABEL_ROLEPLAY
}

function oq.get_premade_type_id(text)
    if (text) then
        for i, v in pairs(OQ.findpremade_types) do
            if (text:find(v)) then
                return i
            end
        end
    end
    return OQ.TYPE_NONE
end

function oq.add_premade_suboption(id, desc, func)
    local text = desc
    if (oq.is_premade_excluded(id)) then
        text = '|cFF606060' .. text .. '|r'
    end
    if (desc ~= OQ.LABEL_ALL) then
        local ex = OQ_data._premade_exclusion[id]
        OQ_data._premade_exclusion[id] = nil
        local n = oq.premades_of_type(id)
        OQ_data._premade_exclusion[id] = ex
        if (n > 0) then
            text = text .. ' (' .. string.format('|cFFFFD331%d|r', n) .. ')'
        end
    end
    oq.menu_add(text, id, text, nil, func)
end

function oq.make_dropdown_premade_filter()
    if (OQ_data._premade_exclusion == nil) then
        OQ_data._premade_exclusion = tbl.new()
    end
    local m = oq.menu_create()

    oq.add_premade_suboption(
        OQ.TYPE_NONE,
        OQ.LABEL_ALL,
        function(_, arg1, arg2, button)
            oq.on_premade_filter(arg1, arg2, (button == 'RightButton'))
        end
    )
    for arg, text in tbl.orderedByValuePairs(OQ.findpremade_types) do
        if (arg ~= OQ.TYPE_NONE) then
            oq.add_premade_suboption(
                arg,
                text,
                function(_, arg1, arg2, button)
                    oq.on_premade_filter(arg1, arg2, (button == 'RightButton'))
                end
            )
        end
    end
    return m
end

function oq.update_findpremade_selection()
    if (OQ_data.premade_filter_type ~= OQ.TYPE_NONE) then
        local n = oq.premades_of_type(OQ_data.premade_filter_type)
        local text = oq.get_premade_type_desc(OQ_data.premade_filter_type)
        if (n > 0) then
            text = text .. ' (' .. string.format('|cFFFFD331%d|r', n) .. ')'
        end
        oq.tab2._filter._edit:SetText(text)
    end
end

function oq.update_premade_count()
    local nShown, nPremades = oq.n_premades()

    local str = string.format('%s  (|cFFE0E0E0%d|r - |cFF808080%d|r)', OQ.HDR_PREMADE_NAME, nShown, nPremades)
    oq.premade_hdr.label:SetText(str)
    oq.update_findpremade_selection()
end

function oq.premade_row_hide(p)
    if (p) then
        p._row = oq.DeleteFrame(p._row)
    end
end

function oq.premade_row_show(p)
    if (p) and (p._row) then
        p._row:Show()
        oq.moveto(p._row, p.__x or 10, p.__y)
        return
    end
    oq.create_premade_listing(
        oq.tab2._list,
        p.__x or 10,
        p.__y,
        oq.tab2._list:GetWidth() - 2 * 23,
        25,
        p.raid_token,
        p.type
    )
    oq.on_premade_stats(p.raid_token, p.nMembers, 1, p.tm, p.status, p.nWaiting, p.type, p.subtype)
    oq.update_premade_listitem(
        p.raid_token,
        p.name,
        p.min_ilevel,
        p.min_resil or 0,
        p.min_mmr or 0,
        p.bgs,
        p.tm,
        p.status,
        p.has_pword,
        p.leader,
        p.pdata,
        p.type,
        p.karma
    )
    oq.set_premade_pending(p.raid_token, p.pending, true)
end

function oq.valid_premade_type(t)
    if (t == nil) then
        return nil
    end
    return OQ.PREMADE_TYPES[t]
end

function oq.trim_big_list(self)
    local offset = self._offset or 0
    local cy = floor(oq.tab2._scroller:GetHeight())
    local y1 = offset - 20
    local y2 = y1 + cy + 20

    for _, p in pairs(oq.premades) do
        if (p) and (p._isvis) and (oq.valid_premade_type(p.type)) and (p.__y >= 0) then
            local y = floor(p.__y or 0)
            if (y >= y1) and (y <= y2) then
                oq.premade_row_show(p)
            else
                oq.premade_row_hide(p)
            end
        elseif (p) and (p._row) then
            oq.premade_row_hide(p)
        end
    end
    oq.remove_wayward_rows()
end

function oq.big_scroller(self, offset, n, f)
    self._offset = offset
    oq.trim_big_list(self)
    FauxScrollFrame_OnVerticalScroll(self, offset, n, f)
end

function oq.create_tab2()
    local parent = OQTabPage2
    local x, y, cx, cy

    oq.tab2 = parent

    -- sorting and filtering presets
    OQ_data.premade_filter_type = OQ_data.premade_filter_type or OQ.TYPE_NONE -- show all premade types

    parent:SetScript(
        'OnShow',
        function()
            oq.populate_tab2()
            oq.filter_show()
        end
    )
    parent:SetScript(
        'OnHide',
        function()
            oq.filter_hide()
        end
    )

    oq.tab2._scroller, oq.tab2._list = oq.create_scrolling_list(parent, 'premades')
    oq.tab2._scroller._scroll_func = oq.big_scroller

    local f = oq.tab2._scroller
    oq.setpos(f, 20, 50, f:GetParent():GetWidth() - 2 * 30, f:GetParent():GetHeight() - (50 + 38))

    -- list header
    y = 27
    cy = 20
    x = 20 + 15
    x = x + 20 -- flag icon
    x = x + 20 -- voip icon
    f = oq.click_label(parent, x, y, 185, cy, OQ.HDR_PREMADE_NAME)
    x = x + 185
    f:SetScript(
        'OnClick',
        function()
            oq.sort_premades('name')
        end
    )
    oq.premade_hdr = f

    f = oq.click_label(parent, x, y, 90, cy, OQ.HDR_LEADER)
    x = x + 90
    f:SetScript(
        'OnClick',
        function()
            oq.sort_premades('lead')
        end
    )
    f = oq.click_label(parent, x, y, 45, cy, OQ.HDR_LEVEL_RANGE)
    x = x + 47
    f:SetScript(
        'OnClick',
        function()
            oq.sort_premades('level')
        end
    )
    f = oq.click_label(parent, x, y, 40, cy, OQ.HDR_ILEVEL)
    x = x + 40
    f:SetScript(
        'OnClick',
        function()
            oq.sort_premades('ilevel')
        end
    )
    f = oq.click_label(parent, x, y, 45, cy, OQ.HDR_RESIL)
    x = x + 45
    f:SetScript(
        'OnClick',
        function()
            oq.sort_premades('resil')
        end
    )
    f = oq.click_label(parent, x, y, 45, cy, OQ.HDR_MMR)
    x = x + 45
    f:SetScript(
        'OnClick',
        function()
            oq.sort_premades('mmr')
        end
    )

    x = x + 35
    oq.tab2_paused = oq.click_label(parent, x, y - 6, 90, cy + 12, L['Pause'])
    oq.tab2_paused.label:SetJustifyH('middle')
    oq.tab2_paused.label:SetTextColor(111 / 255, 111 / 255, 111 / 255, 1)
    oq.tab2_paused:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    oq.tab2_paused:SetScript(
        'OnClick',
        function(self, button)
            oq.timed_pause(self, button)
        end
    )
    oq.tab2_paused._bar = oq.tab2_paused:CreateTexture(nil, 'BACKGROUND')
    oq.tab2_paused._bar:SetTexture(unpack(OQ.CHART_COLORS['darkgreen']))
    oq.tab2_paused._bar:ClearAllPoints()
    oq.tab2_paused._bar:SetPoint('BOTTOMLEFT', oq.tab2_paused, 'BOTTOMLEFT', 0, 3)
    oq.tab2_paused._bar:SetHeight(oq.tab2_paused:GetHeight() - 2 * 3)
    oq.tab2_paused._bar:Hide()

    oq.hook_modifier(parent) -- hooked to the main tab window
    oq.tab2_paused:Show()

    x = parent:GetWidth() - (120 + 50)
    y = parent:GetHeight() - 32
    oq.tab2._connection = oq.label(parent, x, y, 120, 24, 'connection  0 - 0')
    oq.tab2._connection:SetJustifyH('right')
    oq.tab2._connection:SetJustifyV('middle')

    x = x - 95
    oq.tab2._clearfilters_but =
        oq.button2(
        parent,
        x,
        y - 5,
        90,
        24,
        OQ.BUT_CLEARFILTERS,
        14,
        function(_, button)
            if (button == 'RightButton') then
                oq.invert_exclusions()
            else
                oq.clear_exclusions()
            end
        end
    )
    oq.tab2._clearfilters_but.string:SetFont(OQ.FONT, 10, '')
    oq.tab2._clearfilters_but:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

    x = 110 + 10
    oq.tab2._enforce =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        90,
        OQ.QUALIFIED,
        (OQ_data.premade_filter_qualified == 1),
        function(self)
            oq.toggle_premade_qualified(self)
        end
    )

    x = x + 95
    oq.tab2._voip = oq.button_pulldown(parent, x, y, 20, 20, oq.make_dropdown_voip_filter, nil)
    oq.tab2._voip._selected.texture:SetAlpha(0.80)
    oq.tab2._voip._id = OQ.VOIP_UNSPECIFIED
    oq.tab2._voip.__width = 150

    x = x + 50
    oq.tab2._lang = oq.button_pulldown(parent, x, y, 25, 20, oq.make_dropdown_lang_filter, nil)
    oq.tab2._lang._selected.texture:SetAlpha(0.80)
    oq.tab2._lang._id = OQ.LANG_UNSPECIFIED
    oq.tab2._lang.__width = 130

    x = x + 55
    oq.tab2._filter = oq.combo_box(parent, x, y - 4, 125, 25, oq.make_dropdown_premade_filter, OQ.LABEL_ALL)
    oq.tab2._filter.__width = 150
    oq.tab2._filter._edit:SetMaxLetters(50)

    -- tooltips
    parent._resize = function(self)
        local cy = self:GetHeight()
        oq.move_y(self._clearfilters_but, cy - 30)
        oq.move_y(self._filter, cy - 32)
        oq.move_y(self._filter._edit, cy - 32, true)
        oq.move_y(self._enforce, cy - 30)
        oq.move_y(self._connection, cy - 30)
        oq.move_y(self._voip, cy - 30)
        oq.move_y(self._voip._selected, cy - 30)
        oq.move_y(self._lang, cy - 30)
        oq.move_y(self._lang._selected, cy - 30)
        self._scroller:SetHeight(cy - (50 + 38))
        oq.theme_resize(self)
    end

    oq.reshuffle_premades_now()
end

function oq.tab3_radio_buttons_clear()
    oq.tab3._type._edit:SetText('')
    oq.tab3_radio_selected = OQ.TYPE_NONE
end

function oq.tab3_radio_buttons(value, txt)
    local nmembers = oq.nMembers()
    if (value == OQ.TYPE_SCENARIO) and (nmembers > 3) then
        message(string.format(OQ.DLG_16, 3))
        oq.tab3_radio_buttons_clear()
        return
    end
    if (value == OQ.TYPE_DUNGEON) and (nmembers > 5) then
        message(string.format(OQ.DLG_16, 5))
        oq.tab3_radio_buttons_clear()
        return
    end
    if (value == OQ.TYPE_CHALLENGE) and (nmembers > 5) then
        message(string.format(OQ.DLG_16, 5))
        oq.tab3_radio_buttons_clear()
        return
    end
    if (value == OQ.TYPE_QUESTS) and (nmembers > 5) then
        message(string.format(OQ.DLG_16, 5))
        oq.tab3_radio_buttons_clear()
        return
    end
    if (value == OQ.TYPE_ARENA) and (nmembers > 5) then
        message(string.format(OQ.DLG_16, 5))
        oq.tab3_radio_buttons_clear()
        return
    end
    if (value == OQ.TYPE_RBG) and (nmembers > 10) then
        message(string.format(OQ.DLG_16, 10))
        oq.tab3_radio_buttons_clear()
        return
    end

    oq.tab3._type._edit:SetText(txt or OQ.premade_selections[value])
    oq.tab3_radio_selected = value

    if (value == OQ.TYPE_RAID) then
        oq.enable_premade_subtypes()
    else
        oq.disable_premade_subtypes()
    end
end

function oq.tab3_set_radiobutton(value)
    oq.tab3_radio_selected = value
end

function oq.create_tab3()
    local x, y, cx, cy

    oq.tab3 = OQTabPage3

    OQTabPage3:SetScript(
        'OnShow',
        function()
            oq.populate_tab3()
        end
    )
    x = 20
    y = 30
    cy = 25
    local t = oq.label(OQTabPage3, x, y, 400, 30, OQ.CREATEURPREMADE)
    t:SetFont(OQ.FONT, 14, '')
    t:SetTextColor(1.0, 1.0, 1.0, 1)

    y = 65
    x = 40
    oq.label(OQTabPage3, x, y, 100, cy, OQ.PREMADE_NAME)
    y = y + cy + 4
    oq.label(OQTabPage3, x, y, 100, cy, OQ.MIN_ILEVEL)
    y = y + cy + 4
    oq.label(OQTabPage3, x, y, 100, cy, OQ.MIN_RESIL)
    y = y + cy + 4
    oq.label(OQTabPage3, x, y, 125, cy, OQ.MIN_MMR)
    y = y + cy + 4
    oq.label(OQTabPage3, x, y, 100, cy, OQ.BATTLEGROUNDS)
    y = y + cy + 4
    oq.label(OQTabPage3, x, y, 100, cy, OQ.NOTES)
    y = y + 3 * cy + 4
    oq.label(OQTabPage3, x, y, 100, cy, OQ.PASSWORD)

    -- set faciton emblem
    local txt
    if (oq.player_faction == 'A') then
        txt = 'Interface\\FriendsFrame\\PlusManz-Alliance'
    else
        txt = 'Interface\\FriendsFrame\\PlusManz-Horde'
    end
    oq.tab3._faction_emblem = oq.tab3:CreateTexture(nil, 'OVERLAY')
    oq.setpos(oq.tab3._faction_emblem, 375, 55, 160, 160)
    oq.tab3._faction_emblem:SetTexture(txt)

    -- set level range
    x = floor(oq.tab3:GetWidth() - 280)
    if (player_level == OQ.TOP_LEVEL) then
        t = oq.label(OQTabPage3, x, 55, 100, 50, OQ.LABEL_LEVEL)
    else
        t = oq.label(OQTabPage3, x, 55, 100, 50, OQ.LABEL_LEVELS)
    end
    t:SetFont(OQ.FONT, 22, '')
    t:SetJustifyH('LEFT')

    local minlevel, maxlevel = oq.get_player_level_range()
    if (minlevel == 0) then
        txt = 'UNK'
    elseif (minlevel == OQ.TOP_LEVEL) then
        txt = tostring(OQ.TOP_LEVEL)
    else
        txt = minlevel .. ' - ' .. maxlevel
    end
    oq.tab3_level_range = txt
    x = floor(oq.tab3:GetWidth() - 175)
    oq.tab3._level_range = oq.label(OQTabPage3, x, 55, 125, 50, txt)
    oq.tab3._level_range:SetFont(OQ.FONT, 22, '')
    oq.tab3._level_range:SetJustifyH('center')

    y = 65
    x = 175
    cx = 200
    cy = 25
    oq.tab3_raid_name = oq.editline(OQTabPage3, 'RaidName', x, y, cx, cy, 25)
    y = y + cy + 4
    oq.tab3_min_ilevel = oq.editline(OQTabPage3, 'MinIlevel', x, y, cx, cy, 10)
    y = y + cy + 4
    oq.tab3_min_resil = oq.editline(OQTabPage3, 'MinResil', x, y, cx, cy, 10)
    y = y + cy + 4
    oq.tab3_min_mmr = oq.editline(OQTabPage3, 'MinMMR', x, y, cx, cy, 10)
    y = y + cy + 4

    oq.tab3_enforce =
        oq.checkbox(
        OQTabPage3,
        x + cx + 10,
        y,
        23,
        cy,
        200,
        OQ.ENFORCE_LEVELS,
        (oq.raid.enforce_levels == 1),
        function(self)
            oq.toggle_enforce_levels(self)
        end
    )

    oq.tab3_bgs = oq.editline(OQTabPage3, 'Battlegrounds', x, y, cx, cy, 35)
    y = y + cy + 4
    oq.tab3_notes = oq.editbox(OQTabPage3, 'Notes', x, y, 350, 3 * cy, 150)
    y = y + 3 * cy + 4
    oq.tab3_notes:SetMaxLetters(125)
    oq.tab3_notes:SetFont(OQ.FONT, 10, '')
    oq.tab3_notes:SetTextColor(0.9, 0.9, 0.9, 1)
    oq.tab3_notes:SetText(OQ.DEFAULT_PREMADE_TEXT)

    oq.tab3_pword = oq.editline(OQTabPage3, 'password', x, y, cx, cy, 10)
    y = y + cy + 6

    oq.tab3_faction = oq.player_faction
    oq.tab3_channel_pword = 'p' .. oq.token_gen() -- no reason for the leader to set password.  just auto generate

    -- premade type selector
    y = 110
    x = floor(oq.tab3:GetWidth() - 280)
    cy = 20
    oq.label(OQTabPage3, x, y + 2, 100, cy, L['Premade type'])
    oq.tab3._type = oq.combo_box(OQTabPage3, x + 105, y, 125, 28, oq.make_dropdown_premade_type_selector, '')

    y = y + cy + 10
    oq.label(OQTabPage3, x, y + 2., 100, cy, L['Sub type'])

    oq.tab3._diff = oq.pushbutton_pulldown(OQTabPage3, x + 75, y + 2, 22, 22, oq.make_dropdown_difficulty_filter)
    oq.tab3._diff.texture:SetAlpha(0.80)
    oq.tab3._diff._id = 0
    oq.tab3._diff.__width = 90 -- pulldown list width

    oq.tab3._subtype = oq.combo_box(OQTabPage3, x + 105, y, 125, 28, oq.make_dropdown_premade_subtype_selector, '')
    oq.tab3._subtype.__width = 170

    oq.disable_premade_subtypes()

    y = y + cy + 10
    oq.label(OQTabPage3, x, y + 2, 100, cy, L['VoIP'])
    oq.tab3._voip = oq.combo_box(OQTabPage3, x + 105, y, 125, 28, oq.make_dropdown_voip_selector, '')
    oq.tab3._voip_emblem = oq.tab3:CreateTexture(nil, 'OVERLAY')
    local x2 = x + 75
    oq.setpos(oq.tab3._voip_emblem, x2, y + 2, 22, 22)
    oq.tab3._voip_emblem:Show()
    oq.voip_selection(OQ_data._voip or OQ.VOIP_UNSPECIFIED)

    y = y + cy + 10

    oq.label(OQTabPage3, x, y + 2, 100, cy, L['Language'])
    oq.tab3._lang = oq.combo_box(OQTabPage3, oq.tab3:GetWidth() - 175, y, 125, 28, oq.make_dropdown_lang_selector, '')
    oq.tab3._lang_emblem = oq.tab3:CreateTexture(nil, 'OVERLAY')
    oq.setpos(oq.tab3._lang_emblem, x2, y + 6, 20, 16)
    oq.tab3._lang_emblem:Show()
    oq.set_lang_preference(OQ_data._lang)

    y = y + cy + 10

    oq.label(OQTabPage3, x, y + 2, 100, cy, L['Role'])
    x2 = oq.tab3:GetWidth() - 185
    oq.tab3._role_tank =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_role_icon('T', 22, 22),
        true,
        function(self)
            oq.tab3_role(self, 'tank')
        end
    )
    x2 = x2 + 55
    oq.tab3._role_heal =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_role_icon('H', 22, 22),
        true,
        function(self)
            oq.tab3_role(self, 'heal')
        end
    )
    x2 = x2 + 55
    oq.tab3._role_dps =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_role_icon('D', 22, 22),
        true,
        function(self)
            oq.tab3_role(self, 'dps')
        end
    )
    y = y + cy + 10

    y = y + 10
    oq.label(OQTabPage3, x, y + 2, 100, cy, L['Classes'])
    oq.tab3._class_all_but =
        oq.button2(
        oq.tab3,
        x + 15,
        y + 1 * cy + 10,
        50,
        cy + 4,
        L['All'],
        10,
        function()
            oq.tab3_class_all()
        end
    )
    oq.tab3._class_none_but =
        oq.button2(
        oq.tab3,
        x + 15,
        y + 2 * cy + 15,
        50,
        cy + 4,
        L['None'],
        10,
        function()
            oq.tab3_class_none()
        end
    )

    x2 = oq.tab3:GetWidth() - 185
    oq.tab3._class_dk =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('DK', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'dk')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_dr =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('DR', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'dr')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_hn =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('HN', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'hn')
        end
    )
    y = y + cy + 10

    x2 = oq.tab3:GetWidth() - 185
    oq.tab3._class_mg =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('MG', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'mg')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_mk =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('MK', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'mk')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_pa =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('PA', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'pa')
        end
    )
    y = y + cy + 10

    x2 = oq.tab3:GetWidth() - 185
    oq.tab3._class_pr =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('PR', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'pr')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_ro =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('RO', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'ro')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_sh =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('SH', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'sh')
        end
    )
    y = y + cy + 10

    x2 = oq.tab3:GetWidth() - 185
    oq.tab3._class_lk =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('LK', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'lk')
        end
    )
    x2 = x2 + 55
    oq.tab3._class_wa =
        oq.checkbox(
        oq.tab3,
        x2,
        y + 2,
        18,
        cy,
        35,
        oq.get_class_icon('WA', 22, 22),
        true,
        function(self)
            oq.tab3_class(self, 'wa')
        end
    )
    -- y = y + cy + 10

    if (oq.raid.type == nil) or (oq.raid.raid_token == nil) then
        oq.tab3_radio_buttons_clear()
    else
        oq.tab3_set_radiobutton(oq.raid.type)
    end

    -- harddrop button
    oq.tab3._harddrop_but =
        oq.button2(
        OQTabPage3,
        OQTabPage3:GetWidth() - 270,
        OQTabPage3:GetHeight() - 50,
        80,
        25,
        L['hard drop'],
        14,
        function()
            oq.harddrop()
        end
    )
    oq.tab3._harddrop_but.string:SetFont(OQ.FONT, 10, '')

    -- create/update button
    oq.tab3._create_but =
        oq.button2(
        OQTabPage3,
        OQTabPage3:GetWidth() - 175,
        OQTabPage3:GetHeight() - 70,
        150,
        45,
        OQ.CREATE_BUTTON,
        14,
        function()
            oq.tab3_create_activate()
        end
    )
    oq.tab3._create_but.string:SetFont(OQ.FONT, 14, '')

    -- tabbing order
    oq.set_tab_order(oq.tab3_raid_name, oq.tab3_min_ilevel)
    oq.set_tab_order(oq.tab3_min_ilevel, oq.tab3_min_resil)
    oq.set_tab_order(oq.tab3_min_resil, oq.tab3_min_mmr)
    oq.set_tab_order(oq.tab3_min_mmr, oq.tab3_bgs)
    oq.set_tab_order(oq.tab3_bgs, oq.tab3_notes)
    oq.set_tab_order(oq.tab3_notes, oq.tab3_pword)
    oq.set_tab_order(oq.tab3_pword, oq.tab3_raid_name)

    oq.tab3._resize = function(self)
        local cy = self:GetHeight()
        oq.move_y(self._harddrop_but, cy - 50)
        oq.move_y(self._create_but, cy - 70)
        oq.theme_resize(self)
    end
end

function oq.tab3_class_all()
    for i, _ in pairs(OQ.CLASS_FLAG) do
        local cb = oq.tab3['_class_' .. strlower(i)]
        if (cb) then
            cb:SetChecked(true)
        end
    end
end

function oq.tab3_class_none()
    local cb
    for i, _ in pairs(OQ.CLASS_FLAG) do
        cb = oq.tab3['_class_' .. strlower(i)]
        if (cb) then
            cb:SetChecked(nil)
        end
    end
end

function oq.tab3_role()
    oq.get_role_preference()
end

function oq.get_role_preference()
    local p = 0x0000
    local cb
    for i, v in pairs(OQ.ROLE_FLAG) do
        cb = oq.tab3['_role_' .. strlower(i)]
        if (cb) and (cb:GetChecked()) then
            p = p + v
        end
    end
    return p
end

function oq.set_role_preference(p)
    for i, v in pairs(OQ.ROLE_FLAG) do
        local cb = oq.tab3['_role_' .. strlower(i)]
        if (cb) then
            cb:SetChecked(oq.is_set(p, v))
        end
    end
end

function oq.tab3_class()
    oq.get_class_preference()
end

function oq.get_class_preference()
    local p = 0x0000
    local cb
    for i, v in pairs(OQ.CLASS_FLAG) do
        cb = oq.tab3['_class_' .. strlower(i)]
        if (cb) and (cb:GetChecked()) then
            p = p + v
        end
    end
    return p
end

function oq.set_class_preference(p)
    local cb
    for i, v in pairs(OQ.CLASS_FLAG) do
        cb = oq.tab3['_class_' .. strlower(i)]
        if (cb) then
            cb:SetChecked(oq.is_set(p, v))
        end
    end
end

function oq.get_preference(preference)
    if (preference == 'voip') then
        return oq.tab3._voip._id or OQ.VOIP_UNSPECIFIED
    elseif (preference == 'role') then
        return oq.get_role_preference()
    elseif (preference == 'lang') then
        return oq.tab3._lang._id or OQ.LANG_UNSPECIFIED
    elseif (preference == 'class') then
        return oq.get_class_preference()
    end
    return 'A' -- 'A' == 0 for mime-type
end

function oq.set_lang_preference(lang)
    oq.tab3._lang._edit:SetText(OQ.lang_selections[lang or OQ.LANG_UNSPECIFIED] or '')
    oq.tab3._lang_emblem:SetTexture(OQ.LANG_ICON[lang or OQ.LANG_UNSPECIFIED] or '')
    oq.tab3._lang._id = lang or OQ.LANG_UNSPECIFIED
end

function oq.set_voip_preference(voip)
    oq.tab3._voip._edit:SetText(OQ.voip_selections[voip or OQ.VOIP_UNSPECIFIED] or '')
    oq.tab3._voip_emblem:SetTexture(OQ.VOIP_ICON[voip or OQ.VOIP_UNSPECIFIED] or '')
    oq.tab3._voip._id = voip or OQ.VOIP_UNSPECIFIED
end

function oq.set_voip_filter(voip, exclude, force_off)
    if (voip) and (exclude) then
        if (OQ_data._voip_exclusion == nil) then
            OQ_data._voip_exclusion = tbl.new()
        end
        if (OQ_data._voip_exclusion[voip]) and (force_off == nil) then
            OQ_data._voip_exclusion[voip] = nil
        else
            OQ_data._voip_exclusion[voip] = 1
            if (voip == OQ_data._voip_filter) and (OQ_data._voip_filter ~= OQ.VOIP_UNSPECIFIED) then
                oq.set_voip_filter(OQ.VOIP_UNSPECIFIED) -- if you exclude what you've selected, you unselect
            end
        end
    elseif (voip) then
        oq.tab2._voip._id = voip or OQ.VOIP_UNSPECIFIED
        oq.tab2._voip._selected.texture:SetTexture(OQ.VOIP_ICON[oq.tab2._voip._id])
        if (OQ.VOIP_ICON[oq.tab2._voip._id] == nil) then
            oq.tab2._voip._selected.texture:SetWidth(25)
            oq.tab2._voip._selected.texture:SetTexture(OQ.PLACEHOLDER)
        else
            oq.tab2._voip._selected.texture:SetWidth(20)
        end
        OQ_data._voip_filter = oq.tab2._voip._id
        if (OQ_data._voip_exclusion) and (OQ_data._voip_exclusion[voip]) then
            OQ_data._voip_exclusion[voip] = nil -- if you filter FOR a voip you had excluded, it will re-include it
        end
    end
    oq.tab2._scroller:SetVerticalScroll(0)
    oq.reshuffle_premades_now()
end

function oq.set_lang_filter(lang, exclude, force_off)
    if (lang) and (exclude) then
        if (OQ_data._lang_exclusion == nil) then
            OQ_data._lang_exclusion = tbl.new()
        end
        if (OQ_data._lang_exclusion[lang]) and (force_off == nil) then
            OQ_data._lang_exclusion[lang] = nil
        else
            OQ_data._lang_exclusion[lang] = 1
            if (lang == OQ_data._lang_filter) and (OQ_data._lang_filter ~= OQ.LANG_UNSPECIFIED) then
                oq.set_lang_filter(OQ.LANG_UNSPECIFIED) -- if you exclude what you've selected, you unselect
            end
        end
    elseif (lang) then
        oq.tab2._lang._id = lang or OQ.LANG_UNSPECIFIED
        oq.tab2._lang._selected.texture:SetTexture(OQ.LANG_ICON[oq.tab2._lang._id])
        if (OQ.LANG_ICON[oq.tab2._lang._id] == nil) then
            oq.tab2._lang._selected.texture:SetTexture(OQ.PLACEHOLDER)
        end
        OQ_data._lang_filter = oq.tab2._lang._id
        if (OQ_data._lang_exclusion) and (OQ_data._lang_exclusion[lang]) then
            OQ_data._lang_exclusion[lang] = nil -- if you filter FOR a lang you had excluded, it will re-include it
        end
    end
    oq.tab2._scroller:SetVerticalScroll(0)
    oq.reshuffle_premades_now()
end

function oq.set_preferences(preferences)
    local voip_, role_, classes_, lang_ = oq.decode_preferences(preferences)
    oq.set_voip_preference(voip_)
    oq.set_role_preference(role_)
    oq.set_lang_preference(lang_)
    oq.set_class_preference(classes_)
end

function oq.sort_waitlist(col)
    local order = OQ_data.waitlist_sort_ascending
    if (OQ_data.waitlist_sort ~= col) then
        order = true
    else
        if (order) then
            order = nil
        else
            order = true
        end
    end
    OQ_data.waitlist_sort = col
    OQ_data.waitlist_sort_ascending = order
    oq.reshuffle_waitlist()
end

function oq.create_tab_waitlist()
    local x, y, cx, cy
    local parent = OQTabPage7

    oq.tab7 = parent

    oq.tab7._scroller, oq.tab7._list = oq.create_scrolling_list(parent, 'waitlist')
    local f = oq.tab7._scroller
    oq.setpos(f, -40, 50, f:GetParent():GetWidth() - 2 * 30, f:GetParent():GetHeight() - (50 + 38))

    -- list header
    cy = 20
    x = 50
    y = 27

    f = oq.click_label(parent, x, y, 50, cy, OQ.HDR_CLASS)
    x = x + (25 + 5 + 25 + 5)
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('cls')
        end
    )
    f = oq.click_label(parent, x, y, 30, cy, OQ.HDR_ROLE)
    x = x + (25 + 5)
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('role')
        end
    )
    f = oq.click_label(parent, x, y, 120, cy, OQ.HDR_TOONNAME)
    x = x + 120
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('name')
        end
    )
    f = oq.click_label(parent, x, y, 100, cy, OQ.HDR_REALM)
    x = x + 100
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('rlm')
        end
    )
    f = oq.click_label(parent, x, y, 40, cy, OQ.HDR_LEVEL)
    f.label:SetJustifyH('right')
    x = x + 40
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('level')
        end
    )
    f = oq.click_label(parent, x, y, 40, cy, OQ.HDR_ILEVEL)
    f.label:SetJustifyH('right')
    x = x + 40
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('ilevel')
        end
    )

    f = oq.click_label(parent, x, y, 50, cy, OQ.HDR_RESIL)
    f.label:SetJustifyH('right')
    x = x + 41
    f:SetScript(
        'OnClick',
        function(self)
            oq.sort_waitlist(self.sortby)
        end
    )
    f.sortby = 'resil'
    parent.header1 = f
    f = oq.click_label(parent, x, y, 48, cy, OQ.HDR_PVPPOWER)
    f.label:SetJustifyH('right')
    x = x + 50
    f:SetScript(
        'OnClick',
        function(self)
            oq.sort_waitlist(self.sortby)
        end
    )
    f.sortby = 'power'
    parent.header2 = f
    f = oq.click_label(parent, x, y, 40, cy, OQ.HDR_MMR)
    f.label:SetJustifyH('right')
    x = x + 30
    f:SetScript(
        'OnClick',
        function(self)
            oq.sort_waitlist(self.sortby)
        end
    )
    f.sortby = 'mmr'

    parent.header3 = f
    f = oq.click_label(parent, x + 165, y, 40, cy, OQ.HDR_TIME)
    f.label:SetJustifyH('right')
    f:SetScript(
        'OnClick',
        function()
            oq.sort_waitlist('time')
        end
    )

    -- invite-all button
    x = parent:GetWidth() - 135
    y = parent:GetHeight() - 30
    f =
        oq.button2(
        parent,
        x,
        y - 4,
        90,
        24,
        OQ.BUT_INVITE_ALL,
        14,
        function()
            oq.waitlist_invite_all()
        end
    )
    f.string:SetFont(OQ.FONT, 10, '')
    oq.tab7.inviteall_button = f

    x = 120
    f =
        oq.button2(
        parent,
        x,
        y - 4,
        100,
        24,
        OQ.BUT_REMOVE_OFFLINE,
        14,
        function()
            oq.remove_offline_members()
        end
    )
    f.string:SetFont(OQ.FONT, 10, '')
    oq.tab7.remove_offline = f

    -- add samples
    oq.tab7.waitlist = tbl.new()

    parent._resize = function(self)
        cy = self:GetHeight()
        oq.move_y(self.remove_offline, cy - 32)
        oq.move_y(self.waitlist_nfriends, cy - 30)
        oq.move_y(self.inviteall_button, cy - 32)
        self._scroller:SetHeight(cy - (50 + 38))
        oq.theme_resize(self)
    end

    oq.reshuffle_waitlist()
end

function oq.create_tab_banlist()
    local x, y, cx, cy
    local parent = OQTabPage6

    oq.tab6 = parent
    oq.tab6._scroller, oq.tab6._list = oq.create_scrolling_list(parent, 'banlist')
    local f = oq.tab6._scroller
    oq.setpos(f, 20, 50, f:GetParent():GetWidth() - 2 * 30, f:GetParent():GetHeight() - (50 + 38))

    -- list header
    cy = 20
    x = 80
    y = 27

    f = oq.click_label(parent, x, y, 130, cy, OQ.HDR_DATE)
    x = x + 130 + 6
    f:SetScript(
        'OnClick',
        function()
            oq.sort_banlist('ts')
        end
    )
    f = oq.click_label(parent, x, y, 200, cy, OQ.HDR_BTAG)
    x = x + 200 + 4
    f:SetScript(
        'OnClick',
        function()
            oq.sort_banlist('btag')
        end
    )
    f = oq.click_label(parent, x, y, 450, cy, OQ.HDR_REASON)
    f:SetScript(
        'OnClick',
        function()
            oq.sort_banlist('reason')
        end
    )

    x = parent:GetWidth() - 135
    y = parent:GetHeight() - 30
    oq.tab6._ban_but =
        oq.button2(
        parent,
        x,
        y - 4,
        90,
        24,
        OQ.BUT_BAN_BTAG,
        14,
        function()
            StaticPopup_Show('OQ_BanBTag')
        end
    )
    oq.tab6._ban_but.string:SetFont(OQ.FONT, 10, '')

    -- add samples
    oq.tab6_banlist = tbl.new()

    parent._resize = function(self)
        cy = self:GetHeight()
        oq.move_y(self._ban_but, cy - 30)
        self._scroller:SetHeight(cy - (50 + 38))
        oq.theme_resize(self)
    end

    oq.populate_ban_list()
end

function oq.create_banbox(parent, troll_ban)
    if (parent._banned) then
        if (troll_ban) then
            -- yes, i saw you ...
            oq.timer('troll_ban', 2.0, oq.hide_shade, nil)
        end
        return parent._banned
    end
    local pcx = parent:GetWidth()
    local pcy = parent:GetHeight()
    local cx = floor(pcx / 2)
    local cy = floor(4 * pcy / 5)
    local f = oq.panel(parent, 'BanBox', floor((pcx - cx) / 2), floor((pcy - cy) / 2), cx, cy)
    if (oq.__backdrop07 == nil) then
        oq.__backdrop07 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    f:SetBackdrop(oq.__backdrop07)
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
    f:SetAlpha(1.0)

    local x, y
    x = 40
    y = -50
    local msg = oq.CreateFrame('SimpleHTML', 'OQBannedPoster', f)
    msg:SetPoint('TOPLEFT', x, y)
    msg:SetFont(OQ.FONT, 12)
    msg:SetWidth(cx - 2 * x)
    msg:SetHeight(cy - 2 * y)
    msg:SetFont(OQ.FONT, 14)
    msg:SetTextColor(136 / 256, 221 / 256, 221 / 256, 0.8)

    msg:SetFont('p', OQ.FONT, 14)
    msg:SetTextColor('p', 225 / 256, 225 / 256, 225 / 256, 0.8)

    msg:SetFont('h1', OQ.FONT, 16)
    msg:SetTextColor('h1', 221 / 256, 36 / 256, 36 / 256, 0.8)

    msg:SetFont('h2', 'Fonts\\MORPHEUS.ttf', 36)
    msg:SetShadowColor('h2', 0, 0, 0, 1)
    msg:SetShadowOffset('h2', 1, -1)
    msg:SetTextColor('h2', 221 / 256, 36 / 256, 36 / 256, 0.8)

    msg:SetFont('h3', OQ.FONT, 22)
    msg:SetShadowColor('h3', 0, 0, 0, 1)
    msg:SetShadowOffset('h3', 0, 0)
    msg:SetTextColor('h3', 221 / 256, 36 / 256, 36 / 256, 0.8)

    local reason = L['behavior']
    local offense = L["You're BANNED"]
    local from = L['from oQueue']
    if (OQ.gbl[strlower(oq.player_realid)]) then
        reason = OQ.gbl[strlower(oq.player_realid)]
    elseif (troll_ban) then
        offense = L["You've been SPANKED"]
        reason = L['being naughty']
        from = L['by oQueue']
    end

    msg:SetText(
        string.format(
            L[
                '<html><body>' ..
                    '<h2 align="center">%s</h2>' ..
                        '<br/>' ..
                            '<h3 align="center">%s</h3>' ..
                                '<br/>' ..
                                    '<h1 align="left">reason:</h1>' ..
                                        '<h2 align="center">%s</h2>' ..
                                            '<br/>' ..
                                                '<p>If you would like to plead your case, you may request ' ..
                                                    'an appeal on the forums.</p>' ..
                                                        '<br/>' ..
                                                            '<h1 align="left">forums</h1>' ..
                                                                '<p><a href="forums">solidice.com/forums</a></p>' ..
                                                                    '<br/>' .. '</body></html>'
            ],
            offense,
            from,
            reason
        )
    )
    msg:Show()
    msg:SetScript('OnHyperLinkClick', oq.href)

    f.html = msg

    parent._banned = f

    if (troll_ban) then
        -- yes, i saw you ...
        oq.timer('troll_ban', 2.0, oq.hide_shade, nil)
    end
    return f
end

function oq.is_naughty()
    if (oq.player_realid) and (OQ.naughty_list) and (OQ.naughty_list[oq.player_realid]) then
        return true
    end
    return nil
end

function oq.on_pending_note(raid_token, btag, txt, token)
    if (raid_token == nil) or (oq.raid.raid_token ~= raid_token) or (not oq.iam_raid_leader()) then
        return
    end
    txt = oq.decode_note(txt)
    -- is this btag on the wait list?

    for req_token, v in pairs(oq.waitlist) do
        if (v.realid == btag) and ((req_token == token) or (token == nil)) then
            v._pending_text = txt
            oq.update_waitlist_note(req_token, txt)
            if (oq.tooltip) and (oq.tooltip.m) and (oq.tooltip.m.realid == btag) then
                oq.tooltip._extra.note:SetText(txt)
                if (txt) and (txt ~= '') then
                    oq.tooltip._extra:Show()
                else
                    oq.tooltip._extra:Hide()
                end
            end
            return
        end
    end
end

function oq.pending_note_update(self, str)
    if (str ~= nil) then
        local remaining = OQ.MAX_PENDING_NOTE - string.len(str)
        self:GetParent().remaining:SetText(remaining)
    end
end

function oq.on_pending_note_enter_pressed(self)
    if (IsShiftKeyDown()) then
        self:SetText(self:GetText() .. '\n')
        return
    end
    oq.send_pending_note(self:GetParent().send_pb)
end

function oq.on_pending_note_escape_pressed()
    oq.hide_shade()
end

function oq.send_pending_note(self)
    self:Disable()
    local raid_token = self:GetParent().token
    local r = oq.premades[raid_token]
    if (r == nil) then
        return
    end
    local req = oq.pending[raid_token]
    if (req == nil) then
        return
    end
    local req_token = ''
    if (req and req.req_token) then
        req_token = req.req_token
    end

    oq.timer_oneshot(OQ_PENDINGNOTE_UPDATE_CD, oq.enable_button, self)
    local txt = self:GetParent().msg:GetText()
    if (txt ~= r._my_note) then
        r._my_note = txt
        -- send note
        local msg =
            OQ_MSGHEADER ..
            '' ..
                OQ_BUILD_STR ..
                    ',' ..
                        'W1,' ..
                            '0,' ..
                                'pending_note,' ..
                                    raid_token ..
                                        ',' ..
                                            tostring(oq.player_realid) ..
                                                ',' .. oq.encode_note(txt) .. ',' .. tostring(req.req_token)

        oq.XRealmWhisper(r.leader, r.leader_realm, msg)
    end
    oq.set_premade_pending(raid_token, r.pending, true) -- force update for the icon
    oq.hide_shade()
end

function oq.on_edit_pending_note(self)
    local r = oq.premades[self.token]
    oq.enable_button(self.send_pb)
    self.msg:SetText(r._my_note or '')
    --  self.msg:HighlightText();
    self.msg:SetFocus()
    self.msg:SetCursorPosition(self.msg:GetNumLetters())
end

function oq.create_pending_note(parent, token)
    if (parent._pending_note) then
        if (parent._pending_note._resize) then
            parent._pending_note:_resize()
        end
        parent._pending_note.token = token
        return parent._pending_note
    end

    local pcx = parent:GetWidth()
    local pcy = parent:GetHeight()
    local cx = floor(pcx / 2)
    local cy = floor(200)

    local f = oq.panel(parent, 'PendingNote', floor((pcx - cx) / 2), floor((pcy - cy) / 2), cx, cy)
    if (oq.__backdrop08 == nil) then
        oq.__backdrop08 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    f:SetWidth(cx)
    f:SetHeight(cy)
    f:SetBackdrop(oq.__backdrop08)
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
    f:SetAlpha(1.0)
    oq.closebox(
        f,
        function()
            oq.hide_shade()
        end
    )
    f:SetScript('OnShow', oq.on_edit_pending_note)

    local x, y
    x = 25
    y = 25

    f.header = oq.label(f, x, y, cx - 2 * x, 25, L['Send the leader a note'], 'MIDDLE', 'LEFT')
    f.header:SetFont('Fonts\\FRIZQT__.TTF', 12, '')

    y = y + 25
    f.msg = oq.editbox(f, 'OQMessage', x, y, cx - 2 * x, 4 * 25, OQ.MAX_PENDING_NOTE, oq.pending_note_update, '')
    f.msg:SetScript(
        'OnEnterPressed',
        function(self)
            oq.on_pending_note_enter_pressed(self)
        end
    )
    f.msg:SetScript(
        'OnEscapePressed',
        function(self)
            oq.on_pending_note_escape_pressed(self)
        end
    )

    y = y + 4 * 25 + 10
    f.remaining = oq.label(f, cx - x - 100, y, 100, 25, '', 'MIDDLE', 'RIGHT')
    f.remaining:SetFont('Fonts\\FRIZQT__.TTF', 12, '')
    f.remaining:SetAlpha(0.5)

    f.instruction = oq.label(f, x + 70 + 5, y, 150, 25, L['shift-enter for new line'], 'MIDDLE', 'LEFT')
    f.instruction:SetFont('Fonts\\FRIZQT__.TTF', 10, '')
    f.instruction:SetAlpha(0.5)

    f.send_pb = oq.button(f, x - 5, y, 70, 24, L['send'], oq.send_pending_note)

    f.token = token
    oq.on_edit_pending_note(f)
    parent._pending_note = f
    return f
end

function oq.href(_, link)
    if (Icebox) then
        Icebox.link(link)
    end
end

function oq.onShadeHide(f)
    oq.tremove_value(getglobal('UISpecialFrames'), f:GetName())
    tinsert(getglobal('UISpecialFrames'), oq.ui:GetName())
    PlaySound('igCharacterInfoClose')
end

function oq.onShadeShow(f)
    tinsert(getglobal('UISpecialFrames'), f:GetName())
    oq.tremove_value(getglobal('UISpecialFrames'), oq.ui:GetName())
end

function oq.create_ui_shade()
    if (oq.ui_shade ~= nil) then
        oq.ui_shade:SetHeight(floor(oq.ui:GetHeight()) + 30 + 10)
        return oq.ui_shade
    end
    local parent = oq.ui
    local cx = floor(parent:GetWidth())
    local cy = floor(parent:GetHeight()) + 30 + 10
    local f = oq.panel(parent, 'Shade', 0, -10, cx, cy)
    if (oq.__backdrop09 == nil) then
        oq.__backdrop09 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = nil,
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    f:SetBackdrop(oq.__backdrop09)
    f:SetBackdropColor(0.2, 0.2, 0.2, 0.75)
    f:SetFrameLevel(125)
    f:EnableMouse(true)
    f:SetScript(
        'OnShow',
        function(self)
            if (self._locked == nil) then
                oq.onShadeShow(self)
            end
        end
    )
    f:SetScript(
        'OnHide',
        function(self)
            if (self._locked == nil) then
                oq.onShadeHide(self)
            end
        end
    )
    f._child = nil
    oq.onShadeShow(f) -- first time
    oq.ui_shade = f

    -- HELP PLATE?
    -- http://wowprogramming.com/utils/xmlbrowser/live/AddOns/Blizzard_TalentUI/Blizzard_TalentUI.lua
    -- HelpPlate_Show
    -- HelpPlate_Hide

    return oq.ui_shade
end

function oq.shaded_dialog(child, is_locked)
    local shade = oq.create_ui_shade()
    if (shade._child ~= nil) then
        shade._child:Hide()
    end
    shade._child = child
    shade._locked = is_locked
    child:Show()
    if (is_locked) then
        -- remove esc to clear
        oq.onShadeHide(shade)
    end
    shade:Show()
    PlaySound('igCharacterInfoTab')
    return shade
end

function oq.banned_shade()
    oq.shaded_dialog(oq.create_banbox(oq.create_ui_shade(), oq.is_naughty()), true)
end

function oq.pending_note_shade(self)
    oq.shaded_dialog(oq.create_pending_note(oq.create_ui_shade(), self:GetParent().token), nil)
end

function oq.create_tab_setup()
    local x, y, cx, cy, x2
    local parent = OQTabPage5

    oq.tab5 = parent

    parent:SetScript(
        'OnShow',
        function()
            oq.populate_tab_setup()
        end
    )
    parent:SetScript(
        'OnHide',
        function()
            oq.onhide_tab_setup()
        end
    )
    x = 20
    y = 30
    cx = 200
    cy = 25
    local t = oq.label(parent, x, y, 400, 30, OQ.SETUP_HEADING)
    t:SetFont(OQ.FONT, 14, '')
    t:SetTextColor(1.0, 1.0, 1.0, 1)

    y = 65
    x = 20
    oq.label(parent, x, y, cx, cy, OQ.REALID_MOP)

    --
    -- alt list
    --

    y = y + cy * 2
    oq.label(parent, x, y, cx, cy * 2, OQ.SETUP_ALTLIST)

    x = 250
    local f = oq.CreateFrame('Frame', 'OQTabPage5List', parent)
    if (oq.__backdrop10 == nil) then
        oq.__backdrop10 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    f:SetBackdrop(oq.__backdrop10)
    f:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    oq.setpos(f, x, y, 175, 150)
    oq.tab5._list = f

    f = oq.CreateFrame('ScrollFrame', 'OQTabPage5ListScrollBar', OQTabPage5, 'FauxScrollFrameTemplate')
    f:SetScript(
        'OnVerticalScroll',
        function(self, offset)
            FauxScrollFrame_OnVerticalScroll(self, offset, 16, OQ_ModScrollBar_Update)
        end
    )
    f:SetScript(
        'OnShow',
        function(self)
            OQ_ModScrollBar_Update(self)
        end
    )
    f:SetScrollChild(oq.tab5._list)
    f:Show()

    oq.setpos(f, x, y, 175, oq.tab5._list:GetHeight() - 15)
    oq.tab5._scroller = f

    oq.tab5_add_alt =
        oq.button(
        parent,
        x + 200,
        y,
        75,
        cy,
        OQ.SETUP_ADD,
        function()
            StaticPopup_Show('OQ_AddToonName')
        end
    )
    y = y + cy + 2
    oq.tab5_add_mycrew =
        oq.button(
        parent,
        x + 200,
        y,
        75,
        cy,
        OQ.SETUP_MYCREW,
        function()
            oq.mycrew()
        end
    )
    y = y + cy + 2
    oq.tab5_clear =
        oq.button(
        parent,
        x + 200,
        y,
        75,
        cy,
        OQ.SETUP_CLEAR,
        function()
            oq.mycrew('clear')
        end
    )
    if (oq.tab5_alts == nil) then
        oq.tab5_alts = tbl.new()
    end

    --
    -- option check list
    --
    x = parent:GetWidth() - 225
    y = 25
    cy = 20
    oq.tab5_ar =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        200,
        OQ.SETUP_AUTOROLE,
        (oq.toon.auto_role == 1),
        function(self)
            oq.toggle_auto_role(self)
        end
    )
    y = y + cy
    oq.tab5_cp =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        200,
        OQ.SETUP_CLASSPORTRAIT,
        (oq.toon.class_portrait == 1),
        function(self)
            oq.toggle_class_portraits(self)
        end
    )
    y = y + cy
    oq.tab5_autoinspect =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        200,
        OQ.AUTO_INSPECT,
        (OQ_data.ok2autoinspect == 1),
        function(self)
            oq.toggle_autoinspect(self)
        end
    )

    y = y + cy
    oq.tab5_shoutads =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        200,
        OQ.SETUP_SHOUTADS,
        (OQ_data.show_premade_ads == 1),
        function(self)
            oq.toggle_premade_ads(self)
        end
    )

    y = y + cy
    oq.tab5_autohide_friendreqs =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        200,
        OQ.SETUP_AUTOHIDE_FRIENDREQS,
        (OQ_data.autohide_friendreqs == 1),
        function(self)
            oq.toggle_autohide_friendreqs(self)
        end
    )

    y = y + cy
    oq.loot_acceptance_cb =
        oq.checkbox(
        parent,
        x,
        y,
        23,
        cy,
        200,
        OQ.SETUP_LOOT_ACCEPTANCE,
        (OQ_data.loot_acceptance == 1),
        function(self)
            oq.toggle_loot_acceptance(self)
        end
    )

    --
    -- edits and buttons
    --
    y = 65 -- skip comment
    x = 250
    cy = 25
    cx = 145
    oq.tab5_bnet = oq.editline(parent, 'BnetAddress', x, y, cx - 4, cy, 60)
    oq.tab5_bnet:Disable()

    y = y + cy

    --
    --  geek corner
    --
    x = parent:GetWidth() - 200
    x2 = parent:GetWidth() - 90
    y = parent:GetHeight() - 37
    cy = 18
    oq.tab5._oq_pktsent_label = oq.label(parent, x, y, 150, cy, OQ.PPS_SENT)
    oq.tab5._oq_pktsent = oq.label(parent, x2, y, 60, cy, '0', 'MIDDLE', 'RIGHT')
    oq.tab5._oq_send_queuesz = oq.label(parent, x - 30, y, 24, cy, '--', 'MIDDLE', 'RIGHT')
    oq.tab5._oq_pktsent:SetFont(OQ.FONT_FIXED, 10, '')
    oq.tab5._oq_pktsent:SetTextColor(1, 1, 1)

    y = y - cy -- moving up

    oq.tab5._oq_pktprocessed_label = oq.label(parent, x, y, 150, cy, OQ.PPS_PROCESSED)
    oq.tab5._oq_pktprocessed = oq.label(parent, x2, y, 60, cy, '0', 'CENTER', 'RIGHT')
    oq.tab5._oq_pktprocessed:SetFont(OQ.FONT_FIXED, 10, '')
    oq.tab5._oq_pktprocessed:SetTextColor(1, 1, 1)
    y = y - cy -- moving up

    oq.tab5._oq_pktrecv_label = oq.label(parent, x, y, 150, cy, OQ.PPS_RECVD)
    oq.tab5._oq_pktrecv = oq.label(parent, x2, y, 60, cy, '0', 'CENTER', 'RIGHT')
    oq.tab5._oq_pktrecv:SetFont(OQ.FONT_FIXED, 10, '')
    oq.tab5._oq_pktrecv:SetTextColor(1, 1, 1)
    y = y - cy -- moving up

    oq.tab5._oq_timedrift_label = oq.label(parent, x, y, 150, cy, OQ.TIME_DRIFT)
    oq.tab5._oq_timedrift = oq.label(parent, x2, y, 60, cy, '0', 'CENTER', 'RIGHT')
    oq.tab5._oq_timedrift:SetFont(OQ.FONT_FIXED, 10, '')
    oq.tab5._oq_timedrift:SetTextColor(1, 1, 1)
    y = y - cy -- moving up

    oq.tab5._oq_gmt_label = oq.label(parent, x, y, 150, cy, L['GMT'])
    oq.tab5._oq_gmt = oq.label(parent, x2 - 66, y, 125, cy, '0', 'CENTER', 'RIGHT')
    oq.tab5._oq_gmt:SetFont(OQ.FONT_FIXED, 10, '')
    oq.tab5._oq_gmt:SetTextColor(1, 1, 1)
    -- y = y - cy -- moving up

    parent._resize = function(self)
        local h = self:GetHeight()
        local y = h - 37
        cy = 18
        oq.move_y(self._oq_pktsent_label, y)
        oq.move_y(self._oq_pktsent, y)
        oq.move_y(self._oq_send_queuesz, y)
        y = y - cy
        oq.move_y(self._oq_pktprocessed_label, y)
        oq.move_y(self._oq_pktprocessed, y)
        y = y - cy
        oq.move_y(self._oq_pktrecv_label, y)
        oq.move_y(self._oq_pktrecv, y)
        y = y - cy
        oq.move_y(self._oq_timedrift_label, y)
        oq.move_y(self._oq_timedrift, y)
        y = y - cy
        oq.move_y(self._oq_gmt, y)
        oq.move_y(self._oq_gmt_label, y)
        -- y = y - cy
        oq.theme_resize(self)
    end

    -- populate alt list
    oq.populate_alt_list()
end

function oq.update_alltab_text()
    OQMainFrameTab1:SetText(OQ.TAB_PREMADE)
    OQMainFrameTab2:SetText(OQ.TAB_FINDPREMADE)
    OQMainFrameTab3:SetText(OQ.TAB_CREATEPREMADE)
    OQMainFrameTab5:SetText(OQ.TAB_SETUP)
    OQMainFrameTab6:SetText(OQ.TAB_BANLIST)

    local nWaiting = oq.n_waiting()
    if (nWaiting > 0) then
        OQMainFrameTab7:SetText(string.format(OQ.TAB_WAITLISTN, nWaiting))
    else
        OQMainFrameTab7:SetText(OQ.TAB_WAITLIST)
    end
end

function oq.attach_pvp_queue()
    --
    -- hook pvp frame join-as-group button
    -- note: the bg-index and bg-type are now irrelevant since selection must be manual by the leaders
    --
    if (PVPUIFrame == nil) then
        return
    end
    local but = HonorFrameSoloQueueButton -- 5.2 update
    but:SetScript(
        'PostClick',
        function(self)
            if (oq.iam_raid_leader()) then
                oq.raid_join(1, OQ.AB)
            end
            oq.reset_button(self)
            self:Show()
        end
    )
    but = HonorFrameGroupQueueButton -- 5.2 update
    but:SetScript(
        'PostClick',
        function(self)
            if (oq.iam_raid_leader()) then
                oq.raid_join(1, OQ.AB)
            end
            oq.reset_button(self)
            self:Show()
        end
    )
    return 1 -- done
end

function oq.create_main_ui()
    OQMainFrame:SetWidth(OQ.DEFAULT_WIDTH)

    oq.log_button = oq.create_log_button(OQMainFrame) -- 84
    oq.filter_button = oq.create_filter_button(OQMainFrame) -- 140

    ------------------------------------------------------------------------
    --  tab 1: current premade
    ------------------------------------------------------------------------
    oq.create_tab1()

    ------------------------------------------------------------------------
    --  tab 2: find premade
    ------------------------------------------------------------------------
    oq.create_tab2()

    ------------------------------------------------------------------------
    --  tab 3: create premade
    ------------------------------------------------------------------------
    oq.create_tab3()

    ------------------------------------------------------------------------
    --  tab 5: setup
    ------------------------------------------------------------------------
    oq.create_tab_setup()

    ------------------------------------------------------------------------
    --  tab 6: ban list
    ------------------------------------------------------------------------
    oq.create_tab_banlist()

    ------------------------------------------------------------------------
    --  tab 7: waiting list
    ------------------------------------------------------------------------
    oq.create_tab_waitlist()

    oq.update_alltab_text()

    oq.timer('attach_pvpui', 2, oq.attach_pvp_queue, true)

    --
    -- leave queue macro button
    --
    oq.leaveQ = oq.CreateFrame('Button', 'OQLeaveQBut', UIParent, 'SecureActionButtonTemplate UIPanelButtonTemplate')
    oq.leaveQ:SetAttribute('type', 'macro')

    oq.leaveQ:SetAttribute(
        'macrotext',
        '/click QueueStatusMinimapButton \n/click DropDownList1Button3\n/click DropDownList1Button2'
    )

    local t = oq.leaveQ:CreateTexture()
    t:SetParent(oq.leaveQ)
    t:SetTexture('Interface\\Addons\\Buttons\\UI-Panel-Button-Up.blp')
    oq.leaveQ:SetText(OQ.DLG_LEAVE)
    oq.setpos(oq.leaveQ, 5, 65, 75, 25)
    oq.leaveQ:Hide()
    SecureHandlerWrapScript(oq.leaveQ, 'OnClick', oq.leaveQ, [[ self:Hide(); return nil,"done"]], [[ ]])
    oq.leaveQ:SetScript(
        'OnHide',
        function(self)
            oq.angry_lil_button_done(self)
        end
    )
end

function oq.populate_tab2()
    oq.n_connections()
    oq.update_premade_count()
end

function oq.create_tab3_notice(parent)
    local pcx = parent:GetWidth()
    local pcy = parent:GetHeight()
    local cx = floor(pcx / 2)
    local cy = floor(4 * pcy / 5)
    local f = oq.panel(parent, 'Notice', floor((pcx - cx) / 2), floor((pcy - cy) / 2), cx, cy)
    if (oq.__backdrop11 == nil) then
        oq.__backdrop11 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    f:SetBackdrop(oq.__backdrop11)
    f:SetBackdropColor(0.2, 0.2, 0.2, 1.0)
    f:SetAlpha(1.0)
    oq.closebox(
        f,
        function(self)
            self:GetParent():GetParent():Hide()
        end
    )

    local x = 15
    local y = 20

    for i, v in pairs(OQ.LFGNOTICE_DLG) do
        local s = v
        if (i ~= 2) then
            s = '|cFFE0E0E0' .. v .. '|r'
        end
        local t = oq.label(f, x, y, cx - 2 * 15, 20, s, 'CENTER', 'LEFT')
        t:SetFont(OQ.FONT, 16, '')
        y = y + 24
    end

    f.ok_but =
        oq.button(
        f,
        floor((cx - 80) / 2),
        cy - 50,
        80,
        32,
        'Okay',
        function(self)
            self:GetParent():GetParent():Hide()
        end
    )
    return f
end

function oq.create_tab3_shade(parent)
    local cx = floor(parent:GetWidth())
    local cy = floor(parent:GetHeight())
    local f = oq.panel(parent, 'Shade', 0, 0, cx, cy)
    if (oq.__backdrop12 == nil) then
        oq.__backdrop12 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = nil,
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    f:SetBackdrop(oq.__backdrop12)
    f:SetBackdropColor(0.2, 0.2, 0.2, 0.75)
    f:SetFrameLevel(125)
    f:EnableMouse(true)
    return f
end

function oq.populate_tab3()
    local now = oq.utc_time()
    if (oq.toon.tab3_notice == nil) or (oq.toon.tab3_notice < now) then
        -- notice
        oq.shaded_dialog(oq.create_tab3_notice(oq.create_ui_shade()), nil)
        oq.toon.tab3_notice = now + 7 * 24 * 60 * 60 -- once per week
    end
end

function oq.populate_tab_setup()
    oq.tab5_bnet:SetText(oq.player_realid or '')
    if (_oqgeneral_id) then
        SetSelectedDisplayChannel(_oqgeneral_id)
    end
    oq.calc_pkt_stats()
end

function oq.onhide_tab_setup()
end

function oq.is_my_req_token(req_tok)
    return oq.token_was_seen(req_tok)
end

function oq.on_disband(raid_tok, token, local_override)
    if (oq.iam_raid_leader()) and (oq.raid.raid_token == raid_tok) and (oq._local == nil) then
        _ok2relay = nil
        return
    end
    if (oq.bad_source(raid_tok)) then
        _ok2relay = nil
        return
    end
    if (_source == 'bnfinvite') then
        _ok2relay = nil
        return
    end
    oq._error_ignore_tm = GetTime() + 5
    if (oq.token_was_seen(token) and (local_override == nil)) then
        _ok2relay = nil
        return
    end
    if (raid_tok == nil) or (oq.premades[raid_tok] == nil) then
        _ok2relay = nil
        return
    end
    oq.recently_disbanded(raid_tok)

    oq.token_push(token)
    oq.remove_premade(raid_tok)
    -- clear from cache
    if (raid_tok) and (OQ_data._premade_info) then
        OQ_data._premade_info[raid_tok] = nil
        OQ_data._pending_info[raid_tok] = nil
    end
    if (oq.raid.raid_token ~= raid_tok) then
        -- not my raid
        return
    end
    oq.raid_cleanup()
end

function oq.on_leave(ndx)
    oq.battleground_leave(tonumber(ndx))
end

function oq.on_leave_group(name, realm)
    -- clean up the raid ui
    for i = 1, 8 do
        for j = 1, 5 do
            local mem = oq.raid.group[i].member[j]
            if ((mem ~= nil) and (mem.name == name) and (mem.realm == realm)) then
                -- clean out the locker
                mem.name = nil
                mem.class = 'XX'
                mem.realm = nil
                mem.realid = nil
                oq.set_group_member(i, j, nil, nil, 'XX', nil, '0', '0')
                oq.set_deserter(i, j, nil)
                oq.set_role(i, j, OQ.ROLES['NONE'])
                oq.set_textures(i, j)
                oq.member_left(i, j)
                return
            end
        end
    end
end

function oq.on_leave_slot(g_id, slot)
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    if (g_id == 0) or (slot == 0) then
        return
    end
    local mem = oq.raid.group[g_id].member[slot]
    if (mem == nil) then
        return
    end
    mem.name = nil
    mem.class = 'XX'
    mem.realm = nil
    mem.realid = nil
    oq.set_group_member(g_id, slot, nil, nil, 'XX', nil)
    oq.set_deserter(g_id, slot, nil)
    oq.set_role(g_id, slot, OQ.ROLES['NONE'])
    oq.set_textures(g_id, slot)
    oq.member_left(g_id, slot)
end

function oq.reform_keep(name, realm, enc_data, req_token)
    if (oq.raid.raid_token == nil) or (name == nil) or (realm == nil) or (enc_data == nil) or (req_token == nil) then
        return
    end
    if (OQ_data.reform == nil) then
        OQ_data.reform = tbl.new()
    end
    if (OQ_data.reform[oq.raid.raid_token] == nil) then
        OQ_data.reform[oq.raid.raid_token] = tbl.new()
    end
    local key = strlower(name .. '-' .. realm)
    local r = OQ_data.reform[oq.raid.raid_token]
    if (r[key] == nil) then
        r[key] = tbl.new()
    end
    r[key].name = name
    r[key].realm = realm
    r[key].enc_data = enc_data
    r[key].req_token = req_token
end

function oq.reform_show_keys()
    if (OQ_data.reform == nil) then
        return
    end
    print('-- show reform keys')

    for i, v in pairs(OQ_data.reform) do
        print('raid-token: ' .. tostring(i))
        for k, x in pairs(v) do
            print(
                '  ' ..
                    tostring(k) ..
                        '  n(' ..
                            tostring(x.name) .. ') r(' .. tostring(x.realm) .. ') t(' .. tostring(x.req_token) .. ')'
            )
        end
    end
    print('--')
end

function oq.reform_clear()
    if (OQ_data.reform == nil) then
        return
    end

    for raid_token, group in pairs(OQ_data.reform) do
        for key, _ in pairs(group) do
            group[key] = tbl.delete(group[key], true)
        end
        OQ_data.reform[raid_token] = tbl.delete(OQ_data.reform[raid_token], true)
    end
end

--
-- intended for group leader
--
function oq.on_proxy_invite(group_id, slot_, enc_data_, req_token_)
    _ok2relay = nil
    group_id = tonumber(group_id)
    slot_ = tonumber(slot_)
    if (not oq.iam_party_leader()) or (group_id == nil) then
        return
    end
    if (oq.raid.raid_token == nil) or (_source == 'bnfinvite') or (_source == OQ_REALM_CHANNEL) or (_source == 'party') then
        return
    end
    if (not oq.iam_raid_leader()) and (oq.raid.type ~= OQ.TYPE_BG) then
        return
    end
    local enc_data = oq.encode_data('abc123', player_name, player_realm, oq.player_realid)
    local msg =
        'OQ,' ..
        OQ_BUILD_STR ..
            ',' ..
                'W1,' ..
                    '1,' ..
                        'proxy_target,' ..
                            tostring(group_id) ..
                                ',' ..
                                    tostring(slot_) ..
                                        ',' .. enc_data .. ',' .. oq.raid.raid_token .. ',' .. tostring(req_token_ or 0)

    -- this is the target name, realm, and real-id
    local name, realm, rid_, realmid_ = oq.decode_data('abc123', enc_data_)
    oq.reform_keep(name, realm, enc_data_, req_token_)

    oq.XRealmWhisper(name, realm, msg)
    oq.timer_oneshot(1.0, oq.InviteUnitRealID, rid_, req_token_)

    local key = rid_

    oq.pending_invites = oq.pending_invites or tbl.new()
    oq.pending_invites[key] = tbl.new()
    oq.pending_invites[key].raid_tok = oq.raid.raid_token
    oq.pending_invites[key].gid = group_id
    oq.pending_invites[key].slot = slot_
    oq.pending_invites[key].rid = rid_
    oq.pending_invites[key].req_token = req_token_

    oq.names[strlower(key)] = rid_
end

--
-- intended for recruit
--
function oq.on_proxy_target(group_id, slot, enc_data, raid_token, req_token)
    group_id = tonumber(group_id)
    slot = tonumber(slot)

    if (not oq.is_my_token(req_token)) then
        return
    end

    local gl_name, gl_realm, gl_rid, gl_realmid_ = oq.decode_data('abc123', enc_data)
    my_group = group_id
    my_slot = slot

    oq.ui_player()

    oq.clear_pending()
    oq.update_my_premade_line()

    -- set group leader to prepare for invite
    oq.raid.group[group_id].member[1].name = gl_name
    oq.raid.group[group_id].member[1].realm = gl_realm
    oq.raid.group[group_id].member[1].realid = gl_rid
    oq.raid.raid_token = raid_token
end

--
-- fired by raid leader
--
function oq.proxy_invite(group_id, slot, name, realm, rid, req_token)
    if ((oq.raid.group[group_id].member[1].name == nil) or (oq.raid.group[group_id].member[1].name == '-')) then
        return
    end

    --
    -- creating new msgs... ok to turn off sender info
    --
    oq._sender = nil

    local enc_data = oq.encode_data('abc123', name, realm, rid)
    oq.on_proxy_invite(group_id, slot, enc_data, req_token)
end

function oq.valid_rid(rid)
    if (rid == nil) then
        return nil
    end

    -- good tauri-tag has a '-' in the middle
    if (rid:find('-') ~= nil) then
        -- battle-tag
        return true
    end

    return nil
end

function oq.raid_identify_self()
    oq.raid_announce('identify,0')
end

function oq.brief_group_lead(group_id)
    local name = oq.raid.group[group_id].member[1].name
    local realm = oq.raid.group[group_id].member[1].realm
    if (name == nil) or (realm == nil) then
        return
    end
    oq._sender = nil

    for i = 1, 8 do
        if (i ~= group_id) then
            local grp = oq.raid.group[i]
            if (grp._names ~= nil) then
                oq.XRealmWhisper(name, realm, grp._names)
            end
            if (grp._stats ~= nil) then
                oq.XRealmWhisper(name, realm, grp._stats)
            end
        end
    end
end

function oq.assign_lucky_charms()
    if (oq.raid.raid_token == nil) then
        return
    end
    -- assigning lucky charms, first come first served
    local charm = 1

    for i = 1, 8 do
        if (oq.raid.group[i]) then
            for j = 1, 5 do
                if (oq.raid.group[i].member) then
                    local m = oq.raid.group[i].member[j]
                    if (m) and (m.name) and (m.name ~= '-') and (m.name ~= '') then
                        if (m.role == OQ.ROLES['HEALER']) and (charm < 8) then
                            if (m.charm ~= charm) then
                                oq.leader_set_charm(i, j, charm)
                            end
                            charm = charm + 1
                        elseif (m.charm ~= 0) then
                            oq.leader_set_charm(i, j, 0)
                        end

                        -- set the charm if currently in the bg
                        if (oq.iam_raid_leader()) then
                            if (m.name == player_name) then
                                SetRaidTarget('player', m.charm or 0)
                            else
                                local n = m.name
                                if (m.realm ~= player_realm) then
                                    n = n .. '-' .. m.realm
                                end
                                SetRaidTarget(n, m.charm or 0)
                            end
                        end
                    end
                end
            end
        end
    end
    _lucky_charms = (_inside_bg and oq.IsRaidLeader())
end

function oq.handout_lucky_charms()
    if (not oq.IsRaidLeader()) or (oq.raid.raid_token == nil) then
        return
    end

    -- i am the bg leader and we are inside, hand out lucky charms
    for i = 1, 8 do
        for j = 1, 5 do
            local m = oq.raid.group[i].member[j]
            if (m.name) and (m.name ~= '-') and (m.name ~= '') and (m.realm) then
                if (m.name == player_name) and (m.charm) and (m.charm > 0) then
                    SetRaidTarget('player', m.charm or 0)
                elseif (m.charm) and (m.charm > 0) then
                    local n = m.name
                    if (m.realm) and (m.realm ~= player_realm) then
                        n = n .. '-' .. m.realm
                    end
                    SetRaidTarget(n, m.charm or 0)
                end
            end
        end
    end
    _lucky_charms = true
end

function oq.IsRaidLeader()
    if (oq._instance_type and ((oq._instance_type == 'party') or (oq._instance_type == 'raid'))) then
        return oq.iam_raid_leader() -- OQ leader is the lead
    else
        return UnitIsGroupLeader('player') -- pandaria update
    end
end

local last_group_brief = 0
function oq.group_lead_bookkeeping()
    if (oq.iam_raid_leader() and _inside_bg and (not _lucky_charms) and oq.IsRaidLeader()) then
        oq.timer_oneshot(30, oq.handout_lucky_charms)
    end

    if (_inside_bg) then
        return
    end
    local now = oq.utc_time()
    if (now < (last_group_brief + OQ_BOOKKEEPING_INTERVAL)) then
        return
    end
    last_group_brief = now

    -- update online status

    for group = 1, 8 do
        for slot = 2, 5 do
            local m = oq.raid.group[group].member[slot]
            if (m.name) and (m.name ~= '-') then
                local n = m.name
                if (m.realm ~= player_realm) then
                    n = n .. '-' .. m.realm
                end
                -- online status check
                oq.set_status_online(group, slot, UnitIsConnected(n))
                oq.set_textures(group, slot)
            end
        end
    end
end

function oq.ready_check(g_id, slot, stat)
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    stat = tonumber(stat)
    if (g_id == 0) or (slot == 0) then
        return
    end
    oq.raid.group[g_id].member[slot].check = stat
    oq.set_textures(g_id, slot)
end

function oq.on_ready_check_complete()
    for grp = 1, 8 do
        for s = 1, 5 do
            oq.raid.group[grp].member[s].check = OQ.FLAG_CLEAR
            oq.set_textures(grp, s)
        end
    end
end

--
--  received by the raid-leader
--
function oq.on_invite_accepted(raid_token, group_id, slot, class, enc_data, req_token)
    _ok2relay = nil
    if (oq.raid.raid_token ~= raid_token) then
        return
    end
    if (not oq.iam_raid_leader()) then
        return
    end

    group_id = tonumber(group_id)
    slot = tonumber(slot)

    local name, realm, rid, realmid_ = oq.decode_data('abc123', enc_data)
    oq.set_group_member(group_id, slot, name, realm, class, rid)

    if (slot == 1) then
        -- unit is new group leader, brief him
        oq.timer('brief_leader', 1.5, oq.brief_group_lead, nil, group_id)
        return
    end

    oq.proxy_invite(group_id, slot, name, realm, rid, req_token)
end

function oq.update_my_premade_line()
    if (oq.raid.raid_token == nil) then
        return
    end

    -- update status
    local raid = oq.premades[oq.raid.raid_token]
    if (raid ~= nil) then
        local line = oq.find_premade_entry(raid.raid_token)
        if (line) then
            line.req_but:Disable()
            if (raid.has_pword) then
                line.has_pword:Show()
                line.has_pword:SetTexture(OQ.KEY)
            else
                line.has_pword:Hide()
                line.has_pword:SetTexture(nil)
            end
        end
    end
end

function oq.announce_raid_leader()
    -- send party members raid info and slot assignment
    if (not oq.iam_raid_leader()) or (oq.raid.raid_token == nil) then
        return
    end
    oq.brief_player()
end

function oq.on_raid_join(raid_name, premade_type, raid_leader_class, enc_data, raid_token, raid_notes)
    if (_msg_type ~= 'R') then
        return
    end

    local raid_leader, raid_leader_realm, raid_leader_rid, realmid_ = oq.decode_data('abc123', enc_data)
    _received = true

    raid_name = oq.decode_name(raid_name)
    raid_notes = oq.decode_note(raid_notes)

    oq.raid.name = raid_name
    oq.raid.leader = raid_leader
    oq.raid.leader_class = raid_leader_class
    oq.raid.leader_realm = raid_leader_realm
    oq.raid.leader_rid = raid_leader_rid
    oq.raid.notes = raid_notes or ''
    oq.raid.raid_token = raid_token

    oq.set_group_member(1, 1, raid_leader, raid_leader_realm, raid_leader_class, raid_leader_rid, '0', '0')

    oq.update_tab1_common()

    -- activate in-raid only procs
    oq.procs_join_raid()
    if (oq.raid.type ~= premade_type) then
        oq.set_premade_type(premade_type)
    end
    oq.ui_player()
    oq.update_my_premade_line()
    oq.timer_oneshot(3, oq.check_stats)
end

function oq.on_party_join(_, raid_name, raid_leader_class, enc_data, raid_token, raid_notes, raid_type)
    if ((_msg_type ~= 'P') and (_msg_type ~= 'R')) then
        return
    end

    local raid_leader, raid_leader_realm, raid_leader_rid, realmid_ = oq.decode_data('abc123', enc_data)
    _received = true

    raid_name = oq.decode_name(raid_name)
    raid_notes = oq.decode_note(raid_notes)

    my_group, my_slot = oq.find_my_group_id()

    oq.raid.name = raid_name
    oq.raid.leader = raid_leader
    oq.raid.leader_class = raid_leader_class
    oq.raid.leader_realm = raid_leader_realm
    oq.raid.leader_rid = raid_leader_rid
    oq.raid.notes = raid_notes or ''
    oq.raid.raid_token = raid_token
    oq.raid.type = raid_type or OQ.TYPE_BG

    oq.set_group_member(1, 1, raid_leader, raid_leader_realm, raid_leader_class, raid_leader_rid, '0', '0')

    oq.update_tab1_common()

    -- activate in-raid only procs
    oq.procs_join_raid()
    oq.ui_player()
    oq.update_my_premade_line()
    oq.timer_oneshot(3, oq.check_stats)
end

function oq.player_demographic()
    local _, raceId = UnitRace('player')
    local gender = UnitSex('player')
    -- gender can now be: 2(male) 3(female) or 1(neutrum/unknown) ......
    if (gender == 2) then
        gender = 0 -- represented in a bit flag, 0 and 1 are better
    else
        gender = 1
    end
    return gender, OQ.RACE[raceId] -- 1 == female, 0 == male
end

function oq.mmr_check(base)
    if (base == 0) then
        return true
    end
    if (oq.raid.type == OQ.TYPE_ARENA) then
        if (oq.get_arena_rating(1) < base) and (oq.get_arena_rating(2) < base) and (oq.get_arena_rating(3) < base) then
            return nil
        end
    elseif (base > oq.get_mmr()) then
        return nil
    end
    return true
end

function oq.send_premade_note(force)
    if ((force) or (oq.raid._last_note ~= oq.raid.notes)) and (oq.raid.raid_token) then
        oq.raid._last_note = oq.raid.notes

        oq.raid_announce(
            'premade_note,' ..
                oq.raid.raid_token .. ',' .. oq.encode_name(oq.raid.name) .. ',' .. oq.encode_note(oq.raid.notes)
        )
    end
end

function oq.update_premade_note()
    if (not oq.iam_raid_leader()) then
        return
    end

    local name = oq.tab3_raid_name:GetText()
    local note = oq.tab3_notes:GetText()

    oq.raid.name = name
    oq.raid.notes = note

    if
        (oq.get_resil() < oq.numeric_sanity(oq.tab3_min_resil:GetText())) or
            (oq.get_ilevel() < oq.numeric_sanity(oq.tab3_min_ilevel:GetText())) or
            (not oq.mmr_check(oq.numeric_sanity(oq.tab3_min_mmr:GetText())))
     then
        StaticPopup_Show('OQ_DoNotQualifyPremade')
        return
    end

    oq.raid.level_range = oq.tab3_level_range
    oq.raid.subtype = OQ_data._premade_subtype
    oq.raid.min_ilevel = oq.numeric_sanity(oq.tab3_min_ilevel:GetText())
    oq.raid.min_resil = oq.numeric_sanity(oq.tab3_min_resil:GetText())
    oq.raid.min_mmr = oq.numeric_sanity(oq.tab3_min_mmr:GetText())
    oq.raid.bgs = string.gsub(oq.tab3_bgs:GetText() or '.', ',', ';')
    oq.raid.pword = oq.tab3_pword:GetText() or ''

    local voip_ = oq.get_preference('voip')
    local role_ = oq.get_preference('role')
    local lang_ = oq.get_preference('lang')
    local class_ = oq.get_preference('class')
    oq.raid._preferences = oq.encode_preferences(voip_, role_, class_, lang_)

    oq.raid.voip = voip_
    oq.raid.lang = lang_
    oq.update_tab1_common()

    if (oq.raid.pword == nil) or (oq.raid.pword == '') then
        oq.raid.has_pword = nil
    else
        oq.raid.has_pword = true
    end

    oq.send_premade_note()

    local premade = oq.premades[oq.raid.raid_token]
    if (premade ~= nil) then
        premade.tm = 0
        premade.last_seen = oq.utc_time()
        premade.next_advert = 0
        premade.min_ilevel = oq.raid.min_ilevel
        premade.min_resil = oq.raid.min_resil
        premade.min_mmr = oq.raid.min_mmr
        premade.pdata = oq.get_pdata(oq.raid.type, oq.raid.subtype)
    end
    return 1
end

function oq.on_premade_note(raid_token, name, note)
    if (oq.raid.raid_token == nil) or (oq.raid.raid_token ~= raid_token) then
        _ok2relay = nil
        return
    end
    name = oq.decode_name(name)
    note = oq.decode_note(note)

    oq.raid.name = name
    oq.raid.notes = note

    oq.update_tab1_common()
end

function oq.find_player_slot(g_id, name, realm)
    for i = 1, 5 do
        local p = oq.raid.group[g_id].member[i]
        if (p.name ~= nil) and (p.name == name) and (p.realm == realm) then
            return i
        end
    end
    return 0
end

function oq.on_promote(g_id, name, realm, _, _, req_token)
    g_id = tonumber(g_id)
    local slot = 1
    if (my_group ~= g_id) and (g_id ~= 1) then
        return
    end
    oq.token_push(req_token) -- push it to the list so auto-realid-invites can happen

    if (player_name == name) then
        -- change my_slot
        local p_slot = my_slot
        my_slot = 1
        -- update info
        local p = oq.raid.group[g_id].member[1]
        oq.set_name(g_id, p_slot, p.name, p.realm, p.class)
        oq.set_group_lead(g_id, name, realm, player_class, oq.player_realid)
        -- push info
        oq.timer_oneshot(3, oq.force_stats)
        if (g_id == 1) then
            oq.ui_raidleader()
        end

        if (g_id ~= 1) then
            local r = oq.raid.group[1].member[1]
            oq.XRealmWhisper(r.name, r.realm, '#tok:' .. req_token .. ',#lead')
        end
        -- push info
        oq.timer_oneshot(1, oq.force_stats)
    end
end

function oq.on_invite_group(req_token, group_id, slot, raid_name, raid_leader_class, enc_data, raid_token, raid_notes)
    _ok2relay = nil
    if (req_token == nil) or (req_token:sub(1, 1) ~= 'Q') or (not oq.is_my_token(req_token)) then
        return
    end
    local raid_leader, raid_leader_realm, raid_leader_rid, realmid_ = oq.decode_data('abc123', enc_data)
    _received = true
    _ok2relay = nil

    if (oq.iam_raid_leader() and (oq.raid.raid_token ~= raid_token)) then
        return
    end

    -- activate in-raid only procs
    oq.procs_join_raid()

    -- make sure i'm not queue'd
    oq.battleground_leave(1)
    oq.battleground_leave(2)

    oq.clear_pending()

    raid_name = oq.decode_name(raid_name)
    raid_notes = oq.decode_note(raid_notes)

    my_group = tonumber(group_id)
    my_slot = tonumber(slot)
    oq.raid.name = raid_name
    oq.raid.leader = raid_leader
    oq.raid.leader_class = raid_leader_class
    oq.raid.leader_realm = raid_leader_realm
    oq.raid.leader_rid = raid_leader_rid
    oq.raid.notes = raid_notes
    oq.raid.raid_token = raid_token

    oq.log(nil, '|cFF808080joined group:|r ' .. tostring(oq.raid.name) .. '')
    oq.log(nil, oq.btag_link('group leader', oq.raid.leader, oq.raid.leader_realm, oq.raid.leader_rid))

    local me = oq.raid.group[my_group].member[my_slot]
    me.name = player_name
    me.realm = player_realm
    me.level = player_level
    me.class = player_class
    me.resil = player_resil
    me.ilevel = player_ilevel
    me.realid = oq.player_realid
    me.check = OQ.FLAG_CLEAR
    me.charm = 0

    player_role = 0 -- force reset

    oq.update_tab1_common()

    oq.set_group_lead(1, raid_leader, raid_leader_realm, raid_leader_class, raid_leader_rid)
    oq.set_group_member(group_id, slot, player_name, player_realm, player_class, oq.player_realid, '0', '0')

    -- send out invite acceptance
    oq.send_invite_accept(
        raid_token,
        group_id,
        slot,
        player_name,
        player_class,
        player_realm,
        oq.player_realid,
        req_token
    )

    -- send out my status (give it time for the group invites to settle)
    --  oq.timer("mystatus", 2, oq.send_my_status);

    -- remove myself from other waitlists
    oq.ui_player()
    --  oq.update_my_premade_line();
    oq.timer_oneshot(3, oq.check_stats)

    -- null out the group stats will force stats send
    last_stats = nil
    oq.raid.group[my_group]._stats = nil
    oq.raid.group[my_group]._names = nil
end

function oq.on_member(group_id, slot, class, name, realm)
    realm = oq.GetRealmNameFromID(realm)
    oq.set_group_member(group_id, slot, name, realm, class, nil)
end

function oq.on_pass_lead(_, nuleader, nuleader_realm, nuleader_rid)
    oq.raid.leader = nuleader
    oq.raid.leader_realm = nuleader_realm
    oq.raid.leader_realid = nuleader_rid
end

function oq.on_party_update(raid_token)
    oq.raid.raid_token = raid_token
end

function oq.on_ping(token, ts)
    if (_to_name == _player_name) then
        _ok2relay = nil
    end
    if (not oq.iam_party_leader()) then
        return
    end
    oq.raid_ping_ack(token, ts)
end

function oq.on_ping_ack(token, ts, g_id)
    local now = GetTime() * 1000
    if (token ~= oq.my_tok) then
        return
    end
    local lag = floor((now - tonumber(ts)) / 2)
    g_id = tonumber(g_id)
    if (g_id ~= nil) and (g_id > 0) and (g_id <= 8) then
        local grp = oq.raid.group[g_id]
        local m = grp.member[1]
        grp._last_ping = oq.utc_time()
        m.lag = lag
        oq.tab1_group[g_id].lag:SetText(string.format('%5.2f', m.lag / 1000))
        oq.timer('push_lagtimes', 1, oq.send_lag_times)
        return
    end

    -- update lag on group leaders
    for i, grp in pairs(oq.raid.group) do
        if ((grp.member[1].name) and (grp.member[1].name ~= '') and (grp.member[1].name ~= '-')) then
            local m = grp.member[1]
            local n = m.name
            if (m.realm ~= player_realm) then
                n = n .. '-' .. m.realm
            end
            if (m.name == oq._sender) then
                grp._last_ping = oq.utc_time()
                m.lag = lag
                oq.tab1_group[i].lag:SetText(string.format('%5.2f', m.lag / 1000))
                oq.timer('push_lagtimes', 1, oq.send_lag_times)
                break
            end
        end
    end
end

function oq.premade_remove(lead_rid, tm)
    local found = nil

    for _, v in pairs(oq.premades) do
        --    if ((v.leader == lead_name) and (v.leader_realm == lead_realm) and (v.leader_rid == lead_rid)) then
        if (v.leader_rid == lead_rid) then
            if ((tm == nil) or (v.tm == nil) or (v.tm < tm)) then
                oq.remove_premade(v.raid_token)
                found = true
            end
        end
    end
    return found
end

function oq.get_role_icon(n, cx, cy)
    cx = tostring(cx or 16)
    cy = tostring(cy or 16)
    if (n == 'T') then
        -- OQ_TANK_ICON
        return '|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:' .. cx .. ':' .. cy .. ':0:0:64:64:0:19:22:41|t'
    elseif (n == 'H') then
        -- OQ_HEALER_ICON
        return '|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:' .. cx .. ':' .. cy .. ':0:0:64:64:20:39:1:20|t'
    elseif (n == 'D') then
        -- OQ_DAMAGE_ICON
        return '|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:' .. cx .. ':' .. cy .. ':0:0:64:64:20:39:22:41|t'
    end
    -- OQ_EMPTY_ICON
    return '|TInterface\\TARGETINGFRAME\\UI-PhasingIcon.blp:' .. cx .. ':' .. cy .. ':0:0:64:64:0:64:0:64|t'
    --  return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:%d:64:64:0:0:0:0|t";
end

function oq.get_class_icon(n, cx, cy)
    cx = tostring(cx or 16)
    cy = tostring(cy or 16)

    local t = CLASS_ICON_TCOORDS[OQ.LONG_CLASS[n]]
    if t then
        return '|TInterface\\TargetingFrame\\UI-Classes-Circles.blp:' ..
            cx ..
                ':' ..
                    cy ..
                        ':' ..
                            '0:0:64:64:' ..
                                tostring(floor(64 * t[1])) ..
                                    ':' ..
                                        tostring(floor(64 * t[2])) ..
                                            ':' ..
                                                tostring(floor(64 * t[3])) .. ':' .. tostring(floor(64 * t[4])) .. '|t'
    end
    return ''
end

function oq.nMaxGroups()
    if (oq.raid.type == OQ.TYPE_RBG) then
        return 2
    elseif (oq.raid.type == OQ.TYPE_MISC) then
        return 2
    elseif (oq.raid.type == OQ.TYPE_ROLEPLAY) then
        return 1
    elseif (oq.raid.type == OQ.TYPE_ARENA) then
        return 1
    elseif (oq.raid.type == OQ.TYPE_SCENARIO) then
        return 1
    elseif (oq.raid.type == OQ.TYPE_DUNGEON) then
        return 1
    elseif (oq.raid.type == OQ.TYPE_CHALLENGE) then
        return 1
    elseif (oq.raid.type == OQ.TYPE_QUESTS) then
        return 1
    elseif (oq.raid.type == OQ.TYPE_LADDER) then
        return 1
    end
    return 8
end

function oq.get_n_roles()
    local ntanks = 0
    local nheals = 0
    local ndps = 0
    local ngroups = oq.nMaxGroups()

    for i = 1, ngroups do
        if (oq.raid.group[i]) then
            for j = 1, 5 do
                if (oq.raid.group[i].member) then
                    local m = oq.raid.group[i].member[j]
                    if (m.name) and (m.name ~= '-') then
                        if (OQ.ROLES[m.role] == 'TANK') then
                            ntanks = ntanks + 1
                        elseif (OQ.ROLES[m.role] == 'HEALER') then
                            nheals = nheals + 1
                        else
                            ndps = ndps + 1
                        end
                    end
                end
            end
        end
    end
    return ntanks, nheals, ndps
end

function oq.get_karma_color(karma)
    local perc = 1.0 - abs(karma) / 25.0
    local r, g, b
    if (karma < 0) then
        r = 1.0
        g = perc
        b = perc
    else
        r = perc
        g = 1.0
        b = perc
    end
    return r, g, b
end

function oq.update_premade_listitem(
    raid_tok,
    raid_name,
    ilevel,
    resil,
    mmr,
    battlegrounds,
    tm_,
    status,
    has_pword,
    lead_name,
    pdata,
    type,
    karma_)
    status = tonumber(status)
    local r = oq.premades[raid_tok]
    if (r == nil) then
        return
    end
    if (_msg) then
        OQ_data._premade_info = OQ_data._premade_info or tbl.new()
        OQ_data._pending_info = OQ_data._pending_info or tbl.new()
        OQ_data._premade_info[raid_tok] = tostring(oq.player_faction) .. '.' .. tostring(oq.utc_time()) .. '.' .. _msg
    end

    r.leader = lead_name
    r.name = raid_name
    r.min_ilevel = ilevel
    r.min_resil = resil
    r.min_mmr = mmr
    r.tm = tm_
    r.bgs = battlegrounds

    local bg_text = r.bgs
    if (type == OQ.TYPE_RAID) then
        -- hang onto raid completion data to be used to find eligible progression raids
        --
        local desc, raid_id, boss_dead, max_boss, curr_boss = oq.render_raid_status(pdata)
        if (desc == nil) or (desc == '') then
            bg_text = battlegrounds
        elseif (curr_boss == 0) then
            bg_text = desc .. ' ' .. battlegrounds
        else
            bg_text = desc
        end
        r.subtype = raid_id
        r.boss_dead = boss_dead
    else
        r.subtype = nil
        r.boss_dead = nil
    end

    if (r._row == nil) then
        return
    end
    local f = r._row

    f.leader:SetText(lead_name)
    f.leader:SetTextColor(oq.get_karma_color(karma_))
    f.raid_name:SetText(raid_name)
    f.levels:SetText(r.level_range)
    if ((type == OQ.TYPE_DUNGEON) or (type == OQ.TYPE_RAID)) and (mmr > 0) then
        if (mmr < ilevel) then -- mmr == lowest ilevel in the group; ilevel == lowest required; member being carried
            f.min_ilvl:SetText('|cFFD08080' .. mmr .. '|r')
        else
            f.min_ilvl:SetText(ilevel)
        end
    else
        f.min_ilvl:SetText(ilevel)
    end
    f.min_ilvl:SetText(ilevel)

    f.voip:SetTexture(OQ.VOIP_ICON[r.voip])
    f.lang:SetTexture(OQ.LANG_ICON[r.lang])

    if (type == OQ.TYPE_DUNGEON) or (type == OQ.TYPE_CHALLENGE) or (type == OQ.TYPE_QUESTS) then
        local s = ''
        pdata = pdata or '-----'
        for j = 1, 5 do
            local ch = pdata:sub(j, j)
            if (ch ~= '') and (ch ~= '-') then
                s = s .. oq.get_role_icon(ch)
            else
                s = s .. oq.get_role_icon('X') -- empty slot
            end
        end
        f.min_resil:SetText(s)
        f.min_mmr:SetText('')
    elseif (type == OQ.TYPE_SCENARIO) then
        local s = ''
        pdata = pdata or '---'
        for j = 1, 3 do
            local ch = pdata:sub(j, j)
            if (ch ~= '') and (ch ~= '-') then
                s = s .. oq.get_role_icon(ch)
            else
                s = s .. oq.get_role_icon('X') -- empty slot
            end
        end
        f.min_resil:SetText(s)
        f.min_mmr:SetText('')
    elseif (type == OQ.TYPE_BG) or (type == OQ.TYPE_RAID) then
        if (pdata == nil) or (pdata:sub(1, 3) == '---') then
            pdata = 'AAA' -- equivalent to 000 in mime64
        end
        local ntanks = oq.decode_mime64_digits(pdata:sub(1, 1))
        local nheals = oq.decode_mime64_digits(pdata:sub(2, 2))
        local ndps = oq.decode_mime64_digits(pdata:sub(3, 3))
        local s = string.format('%01d', ntanks) .. oq.get_role_icon('T')
        s = s .. ' ' .. string.format('%01d', nheals) .. oq.get_role_icon('H')
        s = s .. ' ' .. string.format('%02d', ndps) .. oq.get_role_icon('D')
        f.min_resil:SetText(s)
        f.min_mmr:SetText('')
    else
        f.min_resil:SetText(resil)
        f.min_mmr:SetText(mmr)
    end
    f.zones:SetText(bg_text)

    -- update status
    if (status == 2) or (raid_tok == oq.raid.raid_token) then
        -- inside, disable button
        f.req_but:Disable()
    else
        f.req_but:Enable()
    end
    if (has_pword) then
        f.has_pword:Show()
        f.has_pword:SetTexture(OQ.KEY)
    else
        f.has_pword:Hide()
        f.has_pword:SetTexture(nil)
    end
end

function oq.trim_oldies(now)
    if (OQ_data._locals == nil) then
        OQ_data._locals = tbl.new()
        return
    end
    -- trim trash

    local spam_window = (OQ_PREMADE_STAT_LIFETIME / 5)
    for i, v in pairs(OQ_data._locals) do
        local cnt = 0
        if (type(v) ~= 'table') then
            OQ_data._locals[i] = nil
        else
            for j, tm in pairs(v) do
                if (type(tm) ~= 'number') or ((now - tm) > spam_window) then
                    v[j] = nil
                else
                    cnt = cnt + 1
                end
            end
            if (cnt == 0) then
                tbl.__inuse[OQ_data._locals[i]] = 1
                OQ_data._locals[i] = tbl.delete(OQ_data._locals[i], true)
            end
        end
    end
end

function oq.show_locals()
    local now = oq.utc_time()
    oq.trim_oldies(now)
    print('--[ local premade leaders ]--')

    for sender, v in pairs(OQ_data._locals) do
        for raid_tok, _ in pairs(v) do
            local p = oq.premades[raid_tok]
            if (p) then
                print('  ' .. tostring(sender) .. ': [' .. tostring(raid_tok) .. '] ' .. tostring(p.name))
            else
                print('  ' .. tostring(sender) .. ': [' .. tostring(raid_tok) .. ']  ' .. OQ.LILREDX_ICON)
            end
        end
    end
    print('--')
end

OQ.MAX_ORIGINALS = 5
function oq.bad_source(raid_tok)
    if ((_source ~= OQ_REALM_CHANNEL) and (_source ~= 'addon')) or (_hop < OQ_TTL) or (oq._sender == '#backup') then
        return
    end
    local now = oq.utc_time()

    oq.trim_oldies(now)

    local sender = oq._sender
    if (sender:find('-') == nil) then
        sender = sender .. '-' .. player_realm
    end
    sender = strlower(sender)

    if (OQ_data._locals[sender] == nil) then
        OQ_data._locals[sender] = tbl.new()
    end
    OQ_data._locals[sender][raid_tok] = now

    if (oq.is_banned(sender)) then
        return true
    else
        local cnt = 0
        for _ in pairs(OQ_data._locals[sender]) do
            cnt = cnt + 1
        end
        if (cnt > OQ.MAX_ORIGINALS) then
            print(
                OQ.LILSKULL_ICON ..
                    '  ' .. L['group spammer spotted.'] .. '  ' .. tostring(sender) .. ' ' .. L['added to the ban list']
            )
            oq.ban_add(sender, L['auto-add: group spammer'])
            for i, _ in pairs(OQ_data._locals[sender]) do
                oq.remove_premade(i)
            end
            return true
        end
    end
end

function oq.is_recently_disbanded(raid_tok, now)
    oq._disbanded = oq._disbanded or tbl.new()
    if (oq._disbanded[raid_tok]) and ((now - oq._disbanded[raid_tok]) < 15) then
        -- 15 seconds in disband window
        return true
    end
    return nil
end

function oq.recently_disbanded(raid_tok)
    oq._disbanded = oq._disbanded or tbl.new()
    oq._disbanded[raid_tok] = oq.utc_time()
    oq._p8s = oq._p8s or tbl.new()
    oq._p8s[raid_tok] = nil -- clear out token
end

local npremades = 0
local _premadeinfo = nil
function oq.on_premade(
    raid_tok,
    raid_name,
    premade_info,
    enc_data,
    bgs_,
    type_,
    pdata_,
    leader_xp_,
    subtype_,
    preferences_)
    if (enc_data == nil) or (oq.toon.disabled) then
        return
    end
    if (_source == 'bnfinvite') then
        _ok2relay = nil
        _reason = 'bad src(bnfinvite)'
        return
    end
    if (subtype_) and ((subtype_:find('#') ~= nil) or (#subtype_ > 1)) then
        subtype_ = nil -- old msg types had fields appended
    end
    subtype_ = oq.decode_mime64_digits(subtype_)
    if (type_ == nil) then
        type_ = OQ.TYPE_BG -- default type, regular battlegrounds
    end
    if (pdata_ == nil) or (pdata_:find('#rlm')) then
        pdata_ = '-----'
    end
    if (oq.bad_source(raid_tok)) then
        _ok2relay = nil
        _reason = 'bad source'
        return
    end
    local now = oq.utc_time()
    if (oq.is_recently_disbanded(raid_tok, now)) then
        _ok2relay = nil
        _reason = 'recently disbanded'
        return
    end
    oq._raid_token = raid_tok
    _premadeinfo = premade_info
    local faction,
        has_pword,
        is_realm_specific,
        is_source,
        level_range,
        min_ilevel,
        min_resil,
        nmembers,
        nwaiting,
        status,
        tm_,
        min_mmr,
        karma,
        oq_ver = oq.decode_premade_info(premade_info)
    local raid_tm_token = raid_tok .. '.' .. tm_
    if (oq.token_was_seen(raid_tm_token) or (faction ~= oq.player_faction)) then
        _ok2relay = nil
        _reason = 'token seen'
        return
    end
    oq.token_push(raid_tm_token)

    oq._p8s = oq._p8s or tbl.new()
    -- Removing this so table is being more dynamic. Let's see how it goes.
    -- if ((now - (oq._p8s[raid_tok] or 0)) < OQ_MIN_PROMO_TIME) then
    --     _ok2relay = nil
    --     _reason = 'too soon  ' .. tostring(now - oq._p8s[raid_tok]) .. ' sec'
    --     return
    -- end
    oq._p8s[raid_tok] = now

    _ok2relay = 1 -- initially able to forward, will clear if a problem is found
    oq.process_premade_info(
        raid_tok,
        raid_name,
        faction,
        level_range,
        min_ilevel,
        min_resil,
        min_mmr,
        enc_data,
        bgs_,
        nmembers,
        is_source,
        tm_,
        status,
        nwaiting,
        has_pword,
        is_realm_specific,
        type_,
        subtype_,
        pdata_,
        leader_xp_,
        karma,
        preferences_,
        oq_ver
    )

    --
    -- oq.pkt_recv._aps is being used to determine if the mesh is 'busy' and to back off if it is
    if (oq.pkt_recv._aps > OQ.RELAY_OVERLOAD) then
        _ok2relay = nil
        _reason = 'mesh load'
    end
end

function oq.process_premade_info(
    raid_tok,
    raid_name,
    faction,
    level_range,
    ilevel,
    resil,
    mmr,
    enc_data,
    bgs_,
    nMem,
    is_source,
    tm_,
    status_,
    nWait,
    has_pword,
    is_realm_specific,
    type_,
    subtype_,
    pdata_,
    leader_xp_,
    karma_,
    preferences_,
    oq_ver)
    if (oq.toon.disabled) then
        return
    end
    local now = oq.utc_time()
    local wins = 0
    local battlegrounds = oq.decode_bg(bgs_)
    raid_name = oq.ltrim(oq.decode_name(raid_name))
    -- decode data
    local lead_name, lead_realm, lead_rid, realmid_ = oq.decode_data('abc123', enc_data)
    local voip_, role_, classes_, lang_ = oq.decode_preferences(preferences_)

    if (lead_name == nil) or (lead_realm == nil) or (lead_rid == nil) or (lead_name == '') then
        _ok2relay = nil
        _reason = 'bad leader info'
        return
    end

    local r1 = strlower(lead_realm)
    local r2 = strlower(player_realm)
    if (raid_name == nil) or (raid_name == '') then
        -- do not record or relay premade info for banned people
        _ok2relay = nil
        _reason = 'invalid premade info'
        return
    end

    oq.gmt_diff_track:push((now - tm_), true)

    if (abs(now - tm_) >= (OQ_PREMADE_STAT_LIFETIME / 2)) then
        -- premade leader's time is off.  ignore
        _ok2relay = nil
        _reason = 'out of sync  dt: ' .. tostring(now - tm_) .. ' sec'
        return
    end

    -- if (oq._my_group == nil and lead_rid == oq.player_realid and my_group == 1 and my_slot == 1 and oq.raid.raid_token) then
    --     _ok2relay = nil ;
    --     _reason = "bad msg" ;
    --     return ;
    -- end

    if (oq.is_banned(lead_rid)) then
        -- do not record or relay premade info for banned people
        _ok2relay = nil
        _reason = 'banned'
        return
    end

    if (oq.valid_premade_type(type_) == nil) then
        _ok2relay = nil
        _reason = 'invalid type'
        return
    end

    if (raid_tok == oq.raid.raid_token) then
        if (type_ ~= oq.raid.type) then
            oq.set_premade_type(type_)
        end
        oq.update_my_premade_line()
    end

    for i, v in pairs(oq.premades) do
        if ((v.leader_rid == lead_rid) or (v.leader == lead_name)) and (i ~= raid_tok) then
            if (tm_ < v.tm) then
                _ok2relay = nil
                _reason = 'old msg'
                return
            end
            oq.remove_premade(v.raid_token)
        end
    end

    if (oq.premades[raid_tok] ~= nil) then
        -- already seen
        local premade = oq.premades[raid_tok]
        if (tm_) and (premade.tm) and (tm_ < premade.tm) then
            -- drop old data
            _ok2relay = nil
            _reason = 'old msg'
            return
        end
        -- data is newer then what i have.. replace
        local is_update = nil

        if ((raid_name) and (premade.name ~= raid_name)) then
            is_update = 1
        end

        premade.leader = lead_name
        premade.leader_realm = lead_realm
        premade.leader_rid = lead_rid
        premade.level_range = level_range or premade.level_range
        premade.last_seen = now
        premade.type = type_
        premade.subtype = subtype_
        premade.pdata = pdata_
        premade.leader_xp = leader_xp_
        premade.karma = karma_
        premade.voip = voip_
        premade.role = role_
        premade.lang = lang_
        premade.classes = classes_
        premade.min_mmr = mmr
        premade.oq_ver = oq_ver or 0
        if (is_source == 0) then
            premade.next_advert = now + OQ_SEC_BETWEEN_ADS
        end
        premade.has_pword = has_pword
        premade.is_realm_specific = is_realm_specific
        oq.on_premade_stats(raid_tok, nMem, is_source, tm_, status_, nWait, type_, subtype_)
        oq.update_premade_listitem(
            raid_tok,
            raid_name,
            ilevel,
            resil or 0,
            mmr or 0,
            battlegrounds,
            tm_,
            status_,
            has_pword,
            lead_name,
            pdata_,
            type_,
            karma_
        )
        if (is_update) then
            -- announce premade name change
            local rc = oq.announce_new_premade(raid_name, true, raid_tok)
        end
        return
    end

    oq.premade_remove(lead_rid, tm_)
    local r = tbl.new()
    r.raid_token = raid_tok
    r.name = raid_name
    r.leader = lead_name
    r.leader_realm = lead_realm
    r.leader_rid = lead_rid
    r.level_range = level_range
    r.faction = faction
    r.min_ilevel = ilevel
    r.min_resil = resil
    r.min_mmr = mmr
    r.bgs = battlegrounds
    r.type = type_
    r.subtype = subtype_
    r.pdata = pdata_
    r.leader_xp = leader_xp_
    r.karma = karma_
    r.tm = tm_ -- owner's time
    r.last_seen = now -- my time
    r.next_advert = now + OQ_SEC_BETWEEN_ADS
    r.nMembers = tonumber(nMem) or 0
    r.nWaiting = tonumber(nWait) or 0
    r.status = status_
    r.has_pword = has_pword
    r.is_realm_specific = is_realm_specific
    r._row = nil -- row frame for find-premade list
    r.__y = 0
    r.voip = voip_
    r.role = role_
    r.lang = lang_
    r.classes = classes_

    oq.premades[raid_tok] = r

    local x, y, cy
    cy = 25
    x = 20
    y = npremades * (cy + 2) + 10
    npremades = npremades + 1

    oq.on_premade_stats(raid_tok, nMem, is_source, tm_, status_, nWait, type_, subtype_)
    oq.update_premade_listitem(
        raid_tok,
        raid_name,
        ilevel,
        resil,
        mmr,
        battlegrounds,
        tm_,
        status_,
        has_pword,
        lead_name,
        pdata_,
        type_,
        karma_
    )
    oq.reshuffle_premades()
    if (raid_tok == oq.raid.raid_token) then
        oq.update_my_premade_line()
    end

    local rc = oq.announce_new_premade(raid_name, nil, raid_tok)
end

function oq.on_premade_stats(raid_token, nMem, is_source, tm, status, nWait, type_, subtype_)
    _ok2relay = 'bnet' -- should only bounce to bn-friends and oqgeneral, if raid-leader not on realm and msg never seen
    local raid = oq.premades[raid_token]
    if (raid == nil) then
        -- never seen, nothing to do
        return
    end
    local wins = 0
    tm = tonumber(tm)
    if ((raid.tm == nil) or (raid.tm <= tm)) then
        raid.nMembers = tonumber(nMem) or 0
        raid.nWaiting = tonumber(nWait) or 0
        raid.status = tonumber(status) or 0
        if (is_source) then
            raid.tm = tm -- so only the latest data is kept
        end
        -- update status
        local line = oq.find_premade_entry(raid_token)
        if (line) and (line.req_but) then
            if (raid.status == 2) or (raid_token == oq.raid.raid_token) then
                -- if inside, disable the waitlist button
                line.req_but:Disable()
            else
                line.req_but:Enable()
            end
        end
    end
end

function oq.set_premade_pending(raid_token, is_pending, hide_sounds)
    local f, r = oq.find_premade_entry(raid_token)
    if (r) then
        r.pending = is_pending
        if (r.pending) then
            OQ_data._pending_info[raid_token] = (r.followup_allowed and '1' or '0') .. '.' .. tostring(r._my_note or '')
        else
            OQ_data._pending_info[raid_token] = nil
        end
    end
    if (f == nil) then
        return
    end
    f.pending = is_pending

    if (is_pending) then
        if (hide_sounds == nil) then
            PlaySound('AuctionWindowOpen')
        end
        f.pending_clik:Show()
        f.req_but:Hide()
        f.req_but:SetText(OQ.BUT_PENDING)
        f.req_but:SetBackdropColor(0.5, 0.5, 0.5, 1)
        f._highlight:SetVertexColor(0 / 255, 225 / 255, 0 / 255)
        f._highlight:Show()
        if (r.followup_allowed) then
            if (r._my_note) and (r._my_note ~= '') then
                f.pending_note._up_texture = OQ.PENDING_NOTE_UP
                f.pending_note._dn_texture = OQ.PENDING_NOTE_DN
            else
                f.pending_note._up_texture = OQ.PENDING_NOTE_OFF
                f.pending_note._dn_texture = OQ.PENDING_NOTE_OFF
            end
            f.pending_note.texture:SetTexture(f.pending_note._up_texture)
            f.pending_note:Show()
        else
            f.pending_note:Hide()
        end
    else
        if (oq.raid.raid_token == nil) and (hide_sounds == nil) then
            -- sad sound if no group and leaving wait list
            PlaySound('igQuestFailed')
            print(OQ.LILREDX_ICON .. '  removed by ' .. tostring(r.leader) .. ' (' .. tostring(r.name) .. ')')
        end
        f.pending_clik:Hide()
        f.req_but:Show()
        f.req_but:SetText(OQ.BUT_WAITLIST)
        f.req_but:SetBackdropColor(0.5, 0.5, 0.5, 1)
        f._highlight:SetVertexColor(255 / 255, 255 / 255, 192 / 255)
        f._highlight:Hide()
        f.pending_note:Hide()
    end
end

function oq.on_invite_req_response(raid_token, req_token, answer, reason, followup_allowed)
    if (not oq.is_my_token(req_token)) then
        return
    end
    local r = oq.premades[raid_token]
    if (r) then
        r.followup_allowed = followup_allowed
    end

    if (answer == 'N') then
        PlaySound('RaidWarning')
        oq.set_premade_pending(raid_token, nil, true)
        message(string.format(OQ.MSG_REJECT, reason))
    elseif (answer == 'Y') then
        oq.set_premade_pending(raid_token, true)
    end
end

function oq.send_invite_response(name, realm, realid, raid_token, req_token, answer, reason, followup_allowed)
    if (realid == nil) or (realid == '') then
        return
    end
    oq.timer_oneshot(
        2,
        oq.XRealmWhisper,
        name,
        realm,
        OQ_MSGHEADER ..
            '' ..
                OQ_BUILD_STR ..
                    ',' ..
                        'W1,' ..
                            '0,' ..
                                'invite_req_response,' ..
                                    raid_token ..
                                        ',' ..
                                            req_token ..
                                                ',' ..
                                                    answer ..
                                                        ',' ..
                                                            (reason or '.') .. ',' .. tostring(followup_allowed or ''), -- allows for followup msg'ing
        true
    )
end

function oq.is_banned(rid, only_local)
    if (rid == nil) or (rid == '') or (rid == 'nil') then
        return true
    end
    if (OQ_data.banned == nil) then
        OQ_data.banned = tbl.new()
    end
    if (OQ_data.banned[rid] ~= nil) then
        return true
    end
    if (only_local == nil) and (OQ.gbl[strlower(rid)] ~= nil) then
        return true
    end
    return nil
end

function oq.ban_add(rid, reason_)
    if (rid == nil) or (rid == '') or (rid == oq.player_realid) then
        print(OQ.LILREDX_ICON .. ' invalid battle-tag (' .. tostring(rid) .. ')')
        return
    end
    if (OQ_data.banned == nil) then
        OQ_data.banned = tbl.new()
    end
    OQ_data.banned[rid] = {ts = oq.utc_time(), reason = reason_}

    -- now add to the list
    local f = oq.create_ban_listitem(oq.tab6._list, 1, 1, 200, 22, rid, reason_, OQ_data.banned[rid].ts)
    table.insert(oq.tab6_banlist, f)
    oq.reshuffle_banlist()
end

function oq.ban_remove(rid)
    if (rid == nil) or (rid == '') then
        print(OQ.LILREDX_ICON .. ' invalid battle-tag (' .. tostring(rid) .. ')')
        return
    end
    if (OQ_data.banned == nil) then
        OQ_data.banned = tbl.new()
    end
    OQ_data.banned[rid] = nil
end

function oq.ban_clearall()
    OQ_data.banned = tbl.new()
end

function oq.is_pending(raid_tok)
    return ((raid_tok) and (OQ_data._pending_info) and (OQ_data._pending_info[raid_tok]))
end

function oq.is_qualified(m)
    local level_min, level_max = oq.get_player_level_range()
    if (oq.raid.enforce_levels == 1) and ((m.level < level_min) or (m.level > level_max)) then
        oq.__reason = L['invalid level range']
        return nil
    end
    if (m.ilevel == nil) then
        return nil
    end
    if (oq.raid.min_ilevel ~= 0) then
        if (oq.raid.type == OQ.TYPE_DUNGEON) or (oq.raid.type == OQ.TYPE_RAID) then
            if (oq.raid.min_mmr) and (min(oq.raid.min_ilevel, oq.raid.min_mmr) > m.ilevel) then
                oq.__reason = L['ilevel too low']
                return nil
            end
        elseif (oq.raid.min_ilevel > m.ilevel) then
            oq.__reason = L['ilevel too low']
            return nil
        end
    end
    if (oq.is_dungeon_premade(oq.raid.type) or (oq.raid.type == OQ.TYPE_RAID) or (oq.raid.type == OQ.TYPE_ROLEPLAY)) then
        return true
    end
    if (oq.raid.min_resil ~= 0) and (oq.raid.min_resil > m.resil) then
        return nil
    end
    if (oq.raid.min_mmr ~= 0) then
        if (oq.raid.min_mmr > m.mmr) then
            return nil
        end
    --[[
    if (oq.raid.type == OQ.TYPE_ARENA) then
      if (m.arena2s < oq.raid.min_mmr) and (m.arena3s < oq.raid.min_mmr) and (m.arena5s < oq.raid.min_mmr) then
        return nil ;
      end
    elseif (oq.raid.min_mmr > m.mmr) then
      return nil ;
    end
]]
    --
    end
    return true
end

function oq.role_type(spec_id)
    local s = OQ.CLASS_SPEC[spec_id]
    if (s == nil) then
        return nil
    end
    local role_type = 'dps'
    if (s.spy == 'Tank') then
        role_type = 'tank'
    elseif (s.spy == 'Healer') then
        role_type = 'heal'
    end
    local role_type_id = OQ.ROLE_FLAG[role_type]
    return role_type_id, role_type
end

function oq.qualified_role(spec_id)
    local role_type_id, role_type = oq.role_type(spec_id)
    local voip_, role_, classes_, lang_ = oq.decode_preferences(oq.raid._preferences)
    if (oq.is_set(role_, role_type_id)) then
        return true
    end
    return nil
end

function oq.qualified_class(spec_id)
    local s = OQ.CLASS_FLAG[spec_id]
    if (s == nil) then
        return nil
    end
    local voip_, role_, classes_, lang_ = oq.decode_preferences(oq.raid._preferences)
    if (oq.is_set(classes_, s)) then
        return true
    end
    return nil
end

function oq.on_req_invite(raid_token, raid_type, n_members_, req_token, enc_data, stats, pword, pdata)
    if (not oq.iam_raid_leader()) then
        return
    end
    -- not my raid
    --
    if (raid_token ~= oq.raid.raid_token) then
        return
    end
    local name_, realm_, realid_, realmid_ = oq.decode_data('abc123', enc_data)
    pword = oq.decode_pword(pword)
    n_members_ = tonumber(n_members_)
    local m = tbl.new()
    m.name = name_
    local demos = oq.decode_their_stats(m, stats)
    local flags_ = 0
    local hp_ = 0
    m.spec_id = select(3, oq.get_class_spec_type(m.spec_id))
    if (oq.n_waiting() >= OQ_MAX_WAITLIST) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['wait list full'])
        tbl.delete(m)
        return
    elseif (not m.class) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['invalid class'])
        tbl.delete(m)
        return
    elseif (oq.is_banned(realid_)) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['banned'])
        tbl.delete(m)
        return
    elseif (n_members_ == 1) and (not oq.is_qualified(m)) then
        --
        -- todo: if stats are off by less then 10%, give token to allow the wait-lister to send a note
        -- todo: and possibly start a conversation with the RL
        --
        oq.send_invite_response(
            name_,
            realm_,
            realid_,
            raid_token,
            req_token,
            'N',
            L['not qualified'] .. ((oq.__reason) and (': ' .. L[oq.__reason]) or '')
        )
        tbl.delete(m)
        return
    elseif (not oq.qualified_role(m.spec_id)) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['incorrect role'])
        tbl.delete(m)
        return
    elseif (not oq.qualified_class(m.class)) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['incorrect class'])
        tbl.delete(m)
        return
    elseif (oq.raid.has_pword and (oq.raid.pword ~= pword)) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['invalid password'])
        tbl.delete(m)
        return
    elseif ((m.oq_ver + 1) < OQ_BUILD) or (raid_type ~= oq.raid.type) or (raid_type ~= m.premade_type) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'N', L['outdated oQueue. please update'])
        tbl.delete(m)
        return
    elseif (oq.raid.type == OQ.TYPE_RAID) then
        local difficulty = oq.decode_mime64_digits(pdata:sub(4, 4))
        if (difficulty >= 3) and (difficulty <= 6) and (oq.pdata_raid_conflict(pdata)) then
            oq.send_invite_response(
                name_,
                realm_,
                realid_,
                raid_token,
                req_token,
                'N',
                L['raid lockout conflict'] .. ((oq.__reason) and (L['\nboss: '] .. L[oq.__reason]) or '')
            )
            tbl.delete(m)
            return
        end
    end

    oq.waitlist = oq.waitlist or tbl.new()

    -- check to see if the toon is already queue'd
    local token = oq.is_waitlisted(name_, realm_)
    if (token) then
        oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'Y', '', '1')
        tbl.delete(m)
        return
    end

    if (not oq.ok_for_waitlist(name_, realm_)) then
        tbl.delete(m)
        return
    end

    oq.waitlist[req_token] = m
    oq.waitlist[req_token].name = name_
    oq.waitlist[req_token].realm = realm_
    oq.waitlist[req_token].realmid = realmid_
    oq.waitlist[req_token].realid = realid_
    oq.waitlist[req_token].premade_type = raid_type
    oq.waitlist[req_token].n_members = n_members_
    oq.waitlist[req_token].create_tm = oq.utc_time()
    oq.waitlist[req_token].pdata = pdata
    oq.waitlist[req_token].raid_token = raid_token
    oq.waitlist[req_token].req_token = req_token

    oq.names[strlower(name_ .. '-' .. realm_)] = realid_

    local x, y, cy
    x = 2
    cy = 25
    y = oq.nwaitlist * (cy + 2) + 10
    oq.nwaitlist = oq.nwaitlist + 1

    local f = oq.insert_waitlist_item(x, y, req_token, n_members_, name_, realm_, oq.waitlist[req_token])
    table.insert(oq.tab7.waitlist, f)
    oq.reshuffle_waitlist()
    oq.send_invite_response(name_, realm_, realid_, raid_token, req_token, 'Y', '', '1')

    -- play sound to alert raid leader
    PlaySound('AuctionWindowOpen')
end

function oq.waitlist_check(name, realm)
    if (oq.waitlist == nil) or (name == nil) or (realm == nil) then
        return
    end

    for req_token, v in pairs(oq.waitlist) do
        if ((v.name == name) and (v._2binvited == true)) then
            oq.InviteUnit(name, realm, req_token)
            return
        end
    end
    local key = name .. '-' .. realm
    if (oq.pending_invites) then
        for id, v in pairs(oq.pending_invites) do
            if (id == key) then
                oq.InviteUnitRealID(id, v.req_token)
                return
            end
        end
    end
end

function oq.get_spec_icon_text(spec_id)
    if (spec_id == nil) or (spec_id == 0) then
        return ''
    end

    local id, name, description, icon, background, role, class = GetSpecializationInfoByID(spec_id)
    if (icon ~= nil) then
        return '|T' .. icon .. ':20:20:0:0|t'
    else
        return '--'
    end
end

function oq.get_role_stats(m)
    if (m.spec_type == OQ.TANK) then
        return string.format('%.2f%%', m.melee_hit), m.armor
    end
    if (m.spec_type == OQ.CASTER) then
        return string.format('%.2f%%', m.spell_hit), m.spell_dmg
    end
    if (m.spec_type == OQ.HEALER) then
        return m.bonus_heal, m.spr
    end
    if (m.spec_type == OQ.RDPS) then
        return string.format('%.2f%%', m.ranged_hit), m.agil
    end
    if (m.spec_type == OQ.MDPS) then
        return string.format('%.2f%%', m.melee_hit or 0), m.str
    end
    if (m.spec_type == OQ.NONE) then
        return '-', '-'
    end
    return '', ''
end

function oq.insert_waitlist_item(x, y, req_token, n_members_, name_, realm_, m)
    local f = oq.create_waitlist_item(oq.tab7._list, x, y, oq.tab7._list:GetWidth() - 2 * x, 25, req_token, n_members_)

    -- class
    f.class:SetText(oq.get_class_icon(m.class, 25, 25))

    -- spec
    f.spec:SetText(oq.get_spec_icon_text(m.spec_id))

    -- role
    if (m.role_type_id == 0x0004) then -- tank
        f.role:SetText(oq.get_role_icon('T', 20, 20))
    elseif (m.role == 0x0002) then -- heal
        f.role:SetText(oq.get_role_icon('H', 20, 20))
    else -- everyone else, dps
        f.role:SetText(oq.get_role_icon('D', 20, 20))
    end
    --  f.create_tm = oq.utc_time() ;
    f.m = m -- hopefully a ptr to the table
    f.toon_name:SetText(name_)
    f.realm:SetText(realm_)
    f.level:SetText(m.level)
    f.ilevel:SetText(m.ilevel)

    -- role based stats
    -- local s1, s2 = oq.get_role_stats(m)
    -- f.stat_1:SetText(s1)
    -- f.stat_2:SetText(s2)

    if (oq.is_dungeon_premade() or (oq.raid.type == OQ.TYPE_RAID)) then
        f.resil:SetText(m.haste)
        f.pvppower:SetText(m.mastery)
        f.mmr:SetText(m.hit)
    else
        f.resil:SetText(m.resil)
        f.pvppower:SetText(m.pvppower)
        f.mmr:SetText(m.mmr)
    end

    f.toon_name:SetTextColor(OQ.CLASS_COLORS[m.class].r, OQ.CLASS_COLORS[m.class].g, OQ.CLASS_COLORS[m.class].b, 1)
    --
    -- set texture for role (might not work as ppl can't set role without a party/raid)
    --
    f.req_token = req_token
    return f
end

function oq.update_wait_times()
    local now = oq.utc_time()

    for _, v in pairs(oq.tab7.waitlist) do
        if (v.m.create_tm) then
            v.wait_tm:SetText(date('!%H:%M:%S', (now - v.m.create_tm)))
        end
    end
end

function oq.is_waitlisted(name, realm)
    for i, v in pairs(oq.waitlist) do
        if ((name == v.name) and (realm == v.realm)) then
            return i
        end
    end
    return nil
end

function oq.remove_offline_members()
    for i = 1, GetNumGroupMembers() do
        local online = select(8, GetRaidRosterInfo(i))
        if (not online) then
            oq.UninviteUnit(select(1, GetRaidRosterInfo(i)))
        end
    end
end

function oq.get_sorted_waitlist(players)
    tbl.clear(_items)
    tbl.clear(players)

    for n, _ in pairs(oq.tab7.waitlist) do
        if (n ~= nil) then
            table.insert(_items, n)
        end
    end

    table.sort(_items, oq.compare_waitlist)

    for _, v in pairs(_items) do
        table.insert(players, oq.tab7.waitlist[v].token)
    end
end

function oq.waitlist_invite_all()
    if (oq.tab7.inviteall_button == nil) then
        return --  ??
    end
    if (not oq.iam_raid_leader()) then
        -- not possible
        return
    end
    oq.tab7.inviteall_button:Disable()
    oq.timer_oneshot(OQ_INVITEALL_CD, oq.enable_button, oq.tab7.inviteall_button)

    local nfriends = select(1, GetNumFriends())
    if (nfriends < OQ.BNET_CAPB4THECAP) then
        local cnt = 0
        local max_inv = min(40 - GetNumGroupMembers(), 10)
        if (oq._sorted_wait_tokens == nil) then
            oq._sorted_wait_tokens = tbl.new()
        end
        oq.get_sorted_waitlist(oq._sorted_wait_tokens)

        for _, req_token in pairs(oq._sorted_wait_tokens) do
            oq.group_invite_first_available(req_token)
            nfriends = nfriends + 1
            cnt = cnt + 1
            if (nfriends >= OQ.BNET_CAPB4THECAP) or (cnt > max_inv) then
                break
            end
        end
    end
end

function oq.ok_for_waitlist(name, realm)
    -- check to see if the toon is already in the group
    for i = 1, 8 do
        for j = 1, 5 do
            local mem = oq.raid.group[i].member[j]
            if (mem.name == name) and (mem.realm == realm) and (mem.class ~= 'XX') then
                return nil
            end
        end
    end
    return true
end

function oq.start_ready_check()
    oq.raid_announce('ready_check')
    oq.on_ready_check()
end

function oq.start_roll_check()
    oq.raid_announce('roll_check')
    oq.on_roll_check()
end

function oq.brb()
    if (oq.raid.raid_token == nil) or (my_group == 0) or (my_slot == 0) then
        return
    end
    oq.raid_announce('brb,' .. oq.raid.raid_token .. ',' .. my_group .. ',' .. my_slot)
    player_away = true
    oq.on_brb(oq.raid.raid_token, my_group, my_slot)

    oq.brb_dlg()
    -- bg2
    if
        ((oq.raid.type == OQ.TYPE_BG) or (oq.raid.type == OQ.TYPE_RBG) or (oq.raid.type == OQ.TYPE_RAID) or
            (oq.raid.type == OQ.TYPE_ROLEPLAY))
     then
        oq.SendChatMessage('brb', 'RAID')
    else
        oq.SendChatMessage('brb', 'PARTY')
    end
end

function oq.iam_back()
    player_away = nil
    oq.raid_announce('iam_back,' .. oq.raid.raid_token .. ',' .. my_group .. ',' .. my_slot)
    oq.on_iam_back(oq.raid.raid_token, my_group, my_slot)
    if
        ((oq.raid.type == OQ.TYPE_BG) or (oq.raid.type == OQ.TYPE_RBG) or (oq.raid.type == OQ.TYPE_RAID) or
            (oq.raid.type == OQ.TYPE_ROLEPLAY))
     then
        oq.SendChatMessage('back', 'RAID')
    else
        oq.SendChatMessage('back', 'PARTY')
    end
end

function oq.on_brb(raid_token, g_id, slot)
    if (raid_token ~= oq.raid.raid_token) then
        return
    end
    g_id = tonumber(g_id)
    slot = tonumber(slot)

    if (g_id <= 0) or (slot <= 0) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]
    m.flags = oq.bset(m.flags, OQ.FLAG_BRB, true)
    m.brb_start_tm = oq.utc_time()
    oq.set_textures(g_id, slot)
end

function oq.on_iam_back(raid_token, g_id, slot)
    if (raid_token ~= oq.raid.raid_token) then
        return
    end
    g_id = tonumber(g_id)
    slot = tonumber(slot)

    if (g_id <= 0) or (slot <= 0) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]
    m.flags = oq.bset(m.flags, OQ.FLAG_BRB, nil)
    m.brb_start_tm = nil
    oq.set_textures(g_id, slot)
end

function oq.ready_check_complete()
    oq.on_ready_check_complete()
end

function oq.on_ready_check()
    local ngroups = oq.nMaxGroups()

    for grp = 1, ngroups do
        for s = 1, 5 do
            oq.raid.group[grp].member[s].check = OQ.FLAG_WAITING
            oq.set_textures(grp, s)
        end
    end

    if (my_group > 0) and (my_slot > 0) and (oq.iam_raid_leader()) then
        oq.ready_check(my_group, my_slot, OQ.FLAG_READY)
        oq.timer('rdycheck_end', 30, oq.ready_check_complete)
        return
    end
    local dialog = StaticPopup_Show('OQ_ReadyCheck')
    last_group_brief = 0 -- force the update for ready-check status
    oq.timer('rdycheck_end', 20, oq.ready_check_complete)
end

function oq.nMembers()
    local instance, instanceType = IsInInstance()
    if (instance == nil) then
        return max(1, GetNumGroupMembers())
    end
    -- in an instance, get the count from the group info
    local cnt = 0
    for i = 1, 8 do
        for j = 1, 5 do
            if (not oq.is_seat_empty(i, j)) then
                cnt = cnt + 1
            end
        end
    end
    return max(1, cnt)
end

function oq.strrep(value, insert, place)
    if (value == nil) then
        return insert
    end
    if place == nil or (place > #value) then
        place = string.len(value) + 1
    elseif (place <= 0) then
        place = 1
    end
    return string.sub(value, 1, place - 1) .. insert .. string.sub(value, place + 1, -1)
end

function oq.calc_raid_stats()
    local nMembers = oq.nMembers()
    local resil = 0
    local ilevel = 0
    local nWaiting = oq.n_waiting()
    local min_ilvl = player_ilevel
    local min_mmr = oq.get_best_mmr(oq.raid.type)

    for i = 1, 8 do
        if (oq.raid.group[i]) then
            for j = 1, 5 do
                if (oq.raid.group[i].member) then
                    local mem = oq.raid.group[i].member[j]
                    if (mem) and (mem.name) and (mem.name ~= '-') then
                        if ((mem.ilevel == 0) and (mem.name == player_name)) then
                            mem.ilevel = player_ilevel
                            mem.resil = player_resil
                        end
                        resil = resil + (mem.resil or 0)
                        ilevel = ilevel + (mem.ilevel or 0)
                        min_ilvl = math.min(min_ilvl, mem.ilevel or min_ilvl)
                        min_mmr = math.min(min_mmr, mem.mmr or min_mmr)
                    end
                end
            end
        end
    end
    if (nMembers == 0) then
        return 0, 0, 0, 0, 0, 0
    end
    return nMembers, floor(resil / nMembers), floor(ilevel / nMembers), nWaiting, min_ilvl, min_mmr
end

function oq.update_tab1_stats()
    local nMembers, avg_resil, avg_ilevel = oq.calc_raid_stats()

    if (nMembers == 0) then
        oq.tab1._raid_stats:SetText('0 / - / -')
    else
        oq.tab1._raid_stats:SetText(nMembers .. ' / ' .. avg_resil .. ' / ' .. avg_ilevel)
    end
    oq.update_premade_note()
end

function oq.update_tab3_info()
    if ((oq.raid.raid_token == nil) or (not oq.iam_raid_leader())) then
        return
    end
    oq.tab3_raid_name:SetText(oq.raid.name)
    oq.tab3_min_ilevel:SetText(oq.raid.min_ilevel or 0)
    if (oq.raid.type == OQ.TYPE_BG) or (oq.raid.type == OQ.TYPE_RBG) or (oq.raid.type == OQ.TYPE_ARENA) then
        oq.tab3_min_resil:SetText(oq.raid.min_resil or 0)
        oq.tab3_min_mmr:SetText(oq.raid.min_mmr or 0)
    else
        oq.tab3_min_resil:SetText('')
        oq.tab3_min_mmr:SetText('')
    end
    oq.tab3_bgs:SetText(oq.raid.bgs or '')
    oq.tab3_notes:SetText(oq.raid.notes or '')
    oq.tab3_pword:SetText(oq.raid.pword or '')

    oq.tab3_set_radiobutton(oq.raid.type)
end

function oq.bset(flags, mask, set)
    flags = bit.bor(flags, mask)
    if ((set == nil) or (set == 0) or (set == false)) then
        flags = bit.bxor(flags, mask)
    end
    return flags
end

function oq.is_set(flags, mask)
    if (flags) and (mask) and (bit.band(flags, mask) ~= 0) then
        return true
    end
    return nil
end

-- bitstream utility
-- 5 bits per character; bits 1..5 are in s:sub(1,1)
--
-- bs_set
-- sets bit N in stream S
-- returns: updated S
--
function oq.bs_set(s, bit)
    return oq.encode_mime64_3digit(oq.bset(oq.decode_mime64_digits(s), 2 ^ bit, 1))
end

-- bitstream utility
-- 5 bits per character; bits 1..5 are in s:sub(1,1)
--
-- bs_clear
-- clears bit N in stream S
-- returns: updated S
--
function oq.bs_clear(s, bit)
    return oq.encode_mime64_3digit(oq.bset(oq.decode_mime64_digits(s), 2 ^ bit, 0))
end

-- bitstream utility
-- 5 bits per character; bits 1..5 are in s:sub(1,1)
--
-- bs_isset
-- checks to see if bit N in stream S is on or off
-- returns: true or nil
--
function oq.bs_isset(s, bit)
    return oq.is_set(oq.decode_mime64_digits(s), 2 ^ bit)
end

function oq.refresh_textures()
    local ngroups = oq.nMaxGroups()
    for i = 1, ngroups do
        for j = 1, 5 do
            oq.set_textures(i, j)
        end
    end
end

function oq.set_textures(g_id, slot)
    if (oq.raid.type == nil) then
        return
    end
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    if (g_id == nil) or (oq.raid.group[g_id] == nil) or (slot == nil) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]
    if (m == nil) then
        return
    end
    if (oq.raid.type == OQ.TYPE_BG) then
        oq.set_textures_cell(m, oq.tab1_group[g_id].slots[slot]) -- bgs
    end
    if (oq.raid.type == OQ.TYPE_RAID) then
        oq.set_textures_cell(m, oq.raid_group[g_id].slots[slot]) -- raid
    end
    if (oq.raid.type == OQ.TYPE_ROLEPLAY) then
        oq.set_textures_cell(m, oq.raid_group[g_id].slots[slot]) -- roleplay
    end
    if (oq.raid.type == OQ.TYPE_RBG) and ((g_id == 1) or (g_id == 2)) and ((slot >= 1) and (slot <= 5)) then
        oq.set_textures_cell(m, oq.rbgs_group[g_id].slots[slot]) -- rbgs
    end
    if (oq.raid.type == OQ.TYPE_MISC) and ((g_id == 1) or (g_id == 2)) and ((slot >= 1) and (slot <= 5)) then
        oq.set_textures_cell(m, oq.rbgs_group[g_id].slots[slot]) -- rbgs
    end
    if (oq.raid.type == OQ.TYPE_ARENA) then
        oq.set_textures_cell(m, oq.arena_group.slots[slot]) -- scenario
    end
    if (oq.raid.type == OQ.TYPE_DUNGEON) then
        oq.set_textures_cell(m, oq.dungeon_group.slots[slot]) -- dungeon
    end
    if (oq.raid.type == OQ.TYPE_CHALLENGE) then
        oq.set_textures_cell(m, oq.challenge_group.slots[slot]) -- challenge
    end
    if (oq.raid.type == OQ.TYPE_QUESTS) then
        oq.set_textures_cell(m, oq.challenge_group.slots[slot]) -- challenge
    end
    --  if (oq.raid.type == OQ.TYPE_LADDER) then
    --    oq.set_textures_cell(m, oq.ladder_group.slots[slot]); -- ladder
    --  end
    if (oq.raid.type == OQ.TYPE_SCENARIO) then
        oq.set_textures_cell(m, oq.scenario_group.slots[slot]) -- scenario
    end
end

function oq.is_dungeon_premade(raid_type)
    return (raid_type == OQ.TYPE_DUNGEON) or (raid_type == OQ.TYPE_SCENARIO) or (raid_type == OQ.TYPE_CHALLENGE) or
        (raid_type == OQ.TYPE_QUESTS)
end

--
-- z : increase to lower image
-- d : decrease to move closer
-- p :
--
OQ._camsets = {
    [0] = {z = 0.9, d = 1.25, p = 1.0}, -- male default
    [1] = {z = 0.9, d = 1.25, p = 1.0}, -- female default
    ['0.1'] = {z = 0.65, d = 0.85, p = 0.5}, -- dwarf male
    ['1.1'] = {z = 0.65, d = 0.85, p = 0.5}, -- dwarf female
    ['0.2'] = {z = 1.25, d = 1.25}, -- draenei male
    ['1.2'] = {z = 1.15, d = 1.10}, -- draenei female
    ['0.3'] = {z = 0.40, d = 0.8, p = 0.5}, -- gnome male
    ['1.3'] = {z = 0.40, d = 0.8, p = 0.5}, -- gnome  female
    ['0.4'] = {z = 0.9, d = 0.90}, -- human male
    ['1.4'] = {z = 0.9, d = 0.75}, -- human female
    ['0.5'] = {z = 1.1, d = 1.30}, -- nightelf male
    ['1.5'] = {z = 1.0, d = 1.30}, -- nightelf female
    ['0.6'] = {z = 1.1, d = 1.30}, -- worgen male
    ['1.6'] = {z = 1.0, d = 1.30}, -- worgen female
    ['0.7'] = {z = 1.0, d = 0.85}, -- bloodelf male
    ['1.7'] = {z = 0.9, d = 0.65, p = 0.8}, -- bloodelf female
    ['0.8'] = {z = 0.65, d = 0.85, p = 0.5}, -- goblin male
    ['1.8'] = {z = 0.65, d = 0.85, p = 0.5}, -- goblin female
    ['0.9'] = {z = 1.0, d = 1.2, p = 1.0}, -- orc male
    ['1.9'] = {z = 0.8, d = 1.1, p = 1.0}, -- orc female
    ['0.11'] = {z = 1.1, d = 1.20}, -- troll male
    ['1.11'] = {z = 1.15, d = 0.85}, -- troll female
    ['0.12'] = {z = 0.9, d = 0.85}, -- undead male
    ['1.12'] = {z = 0.9, d = 0.85}, -- undead female
    ['0.13'] = {z = 1.1, d = 1.05}, -- panda male
    ['1.13'] = {z = 1.0, d = 1.05} -- panda female
}

function oq.camera_profile_mode(f, gender, race)
    if (f == nil) then
        return
    end
    local t = '.t' -- tall
    if (oq.raid.type == OQ.TYPE_RBG) or (oq.raid.type == OQ.TYPE_MISC) then
        t = '.s' -- short
    end
    local key = string.format('%d.%d', gender, race)
    local c = OQ._camsets[key .. t]
    if (c == nil) then
        c = OQ._camsets[key]
        if (c == nil) then
            c = OQ._camsets[gender]
        end
    end
    if (c == nil) then
        c = OQ._camsets[0]
    end
    f:SetAlpha(1)
    f:SetCustomCamera(1)
    if (f:HasCustomCamera()) then
        f:SetCameraTarget(0, 0, c.z or OQ._camsets[gender].z)
        f:SetCameraPosition(1.2, -0.8, c.p or OQ._camsets[gender].p)
        f:SetCameraDistance(c.d or OQ._camsets[gender].d)
        f:SetFacing(-0.40)
    else
        f:SetCamera(0)
    end
    f:Show()
end

function oq.model_slot_empty(panel)
    if (panel.model_frame ~= nil) and (panel.model_frame:IsVisible()) and (panel.model_frame._model ~= nil) then
        panel.model_frame._model:Hide()
        panel.model_frame._model:SetParent(nil)
        panel.model_frame._model = nil
    end
    if (panel.model) then
        panel.model:Hide()
    end
    if ((oq.raid.type == OQ.TYPE_BG) or (oq.raid.type == OQ.TYPE_RAID) or (oq.raid.type == OQ.TYPE_MISC)) then
        panel.model_frame:Hide()
    else
        panel.model_frame:Show()
    end
end

function oq.model_slot_create(panel)
    if (not oq.raid_uses_models()) then
        return
    end
    oq.nmodels = (oq.nmodels or 0) + 1
    panel.model_frame = oq.CreateFrame('Button', 'OQModelFrame' .. oq.nmodels, panel)
    if (oq.__backdrop13 == nil) then
        oq.__backdrop13 = {
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        }
    end
    panel.model_frame:SetBackdrop(oq.__backdrop13)
    panel.model_frame:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
    panel.model_frame:SetAlpha(0.8)
    panel.model_frame:Show()
    oq.setpos(panel.model_frame, 0, 0, panel:GetWidth(), panel:GetHeight() - 17)
end

function oq.model_is_valid(m)
    if (m == nil) or (m.GetModel == nil) then
        return nil
    end
    local fname = m:GetModel()
    if (fname) and (fname ~= '') then
        return 1
    end
    return nil
end

function oq.clear_cell_model(cell)
    if (cell.model_frame) and (cell.model_frame._model) then
        cell.model_frame._model:Hide()
        cell.model_frame._model:SetParent(nil)
        cell.model_frame._model = nil
    end
end

function oq.clear_model(g_id, slot)
    if (oq.raid.group[g_id] == nil) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]
    if (m == nil) then
        return
    end
    if (oq.raid.type == OQ.TYPE_BG) then
        oq.clear_cell_model(oq.tab1_group[g_id].slots[slot]) -- bgs
    end
    if (oq.raid.type == OQ.TYPE_RAID) then
        oq.clear_cell_model(oq.raid_group[g_id].slots[slot]) -- raid
    end
    if (oq.raid.type == OQ.TYPE_RBG) and ((g_id == 1) or (g_id == 2)) and ((slot >= 1) and (slot <= 5)) then
        oq.clear_cell_model(oq.rbgs_group[g_id].slots[slot]) -- rbgs
    end
    if (oq.raid.type == OQ.TYPE_MISC) and ((g_id == 1) or (g_id == 2)) and ((slot >= 1) and (slot <= 5)) then
        oq.clear_cell_model(oq.rbgs_group[g_id].slots[slot]) -- rbgs
    end
    if (oq.raid.type == OQ.TYPE_ARENA) then
        oq.clear_cell_model(oq.arena_group.slots[slot]) -- scenario
    end
    if (oq.raid.type == OQ.TYPE_DUNGEON) then
        oq.clear_cell_model(oq.dungeon_group.slots[slot]) -- dungeon
    end
    if (oq.raid.type == OQ.TYPE_CHALLENGE) then
        oq.clear_cell_model(oq.challenge_group.slots[slot]) -- challenge
    end
    if (oq.raid.type == OQ.TYPE_QUESTS) then
        oq.clear_cell_model(oq.challenge_group.slots[slot]) -- challenge
    end
    --  if (oq.raid.type == OQ.TYPE_LADDER) then
    --    oq.clear_cell_model(oq.ladder_group.slots[slot]); -- ladder
    --  end
    if (oq.raid.type == OQ.TYPE_SCENARIO) then
        oq.clear_cell_model(oq.scenario_group.slots[slot]) -- scenario
    end
end

function oq.get_model(parent, name, gender, race)
    if (name == nil) or (gender == nil) or (race == nil) then
        return nil
    end
    if (oq._models == nil) then
        oq._models = tbl.new()
    end
    name = strlower(name)
    --
    -- one model.. able to switch from model to standin
    --
    local key = tostring(gender) .. '.' .. tostring(race) .. '.' .. name
    if (oq._models[key] == nil) then
        oq._models[key] = tbl.new()
        oq._models[key] = oq.CreateFrame('DressUpModel', 'OQModel.' .. name, parent)
        oq._models[key]._standin = nil -- flag
        oq._models[key]._name = name
        oq._models[key]._race = race
        oq._models[key]._gender = gender
        oq._models[key]._fname = nil
        oq._models[key]:SetScript(
            'OnEnter',
            function(self)
                oq.on_classdot_enter(self:GetParent():GetParent())
            end
        )
        oq._models[key]:SetScript(
            'OnLeave',
            function(self)
                oq.on_classdot_exit(self:GetParent():GetParent())
            end
        )
        oq._models[key]:SetScript(
            'OnMouseUp',
            function(self, button)
                oq.on_classdot_click(self:GetParent():GetParent(), button)
            end
        )
        oq._models[key].adjust_frame = function(self)
            self:SetPoint('TOPLEFT', self:GetParent(), 'TOPLEFT', 5, -5)
            self:SetPoint('BOTTOMRIGHT', self:GetParent(), 'BOTTOMRIGHT', -5, 5)
        end
        oq._models[key].check_model = function(self)
            local now = oq.utc_time()
            if (self._next_chk_tm == nil) or (self._next_chk_tm < now) then
                self._next_chk_tm = now + OQ.MODEL_CHECK_TM
                if (self._standin == 1) then
                    self:update_model()
                end
            end
        end
        oq._models[key].is_good_model = function(self)
            local fname = self:GetModel()
            if (fname) and (fname ~= '') then
                return 1
            end
            return nil
        end
        oq._models[key].use_normal = function(self)
            self:SetUnit(self._name)
            self:SetAlpha(1.0)
            self:SetLight(1, 0, 0, -0.707, -0.707, 0.7, 1.0, 1.0, 1.0, 0.8, 1.0, 1.0, 0.8) -- some light
            self:adjust_frame()
            self:Show()
            self._standin = 0
        end
        oq._models[key].use_standin = function(self)
            if (self._fname) then
                self:SetModel(self._fname)
                self:SetCustomRace(OQ.WOW_RACE_ID[self._race], self._gender)
                self:Undress() -- want undressed model, just race and gender
                self:SetAlpha(1.0)
                self:SetLight(0) -- dark model; silhouette
                self:adjust_frame()
                self:Show()
            end
            self._standin = 1
        end
        oq._models[key].update_cam = function(self)
            oq.camera_profile_mode(self, self._gender, self._race)
        end
        oq._models[key].update_model = function(self)
            if (UnitIsVisible(self._name)) then
                self:use_normal()
            elseif (self._standin == nil) or (self._standin == 1) or (self.GetModel and (self:GetModel() == '')) then -- was visible
                self:use_standin()
            end
            oq.camera_profile_mode(self, self._gender, self._race)
        end
        oq._models[key]:SetScript(
            'OnShow',
            function(self)
                self:RegisterEvent('UNIT_MODEL_CHANGED', self.update_model)
                self:adjust_frame()
                self:update_model()
            end
        )
        oq._models[key]:SetScript(
            'OnHide',
            function(self)
                self:UnregisterEvent('UNIT_MODEL_CHANGED')
            end
        )
        oq._models[key]:SetScript(
            'OnUpdate',
            function(self)
                self:check_model()
            end
        )
        oq._models[key]:update_model()
    end

    oq._models[key]:SetParent(parent)
    return oq._models[key]
end

function oq.adjust_camera(panel, name, gender, race)
    if (not panel:IsVisible()) then
        return
    end
    name = strlower(name)
    if
        (panel.model_frame._model) and (panel.model_frame._model._name == name) and
            oq.model_is_valid(panel.model_frame._model)
     then
        if (panel.model_frame._model.update_cam) then
            panel.model_frame._model:update_cam()
        end
        return
    end

    local m = oq.get_model(panel.model_frame, name, gender, race)
    if (m == nil) then
        -- no model
        return
    end
    if (panel.model_frame._model) and (m._name == panel.model_frame._model._name) then
        -- already set
        return
    end
    if (panel.model_frame._model) and (panel.model_frame._model ~= m) then
        -- retire old model
        panel.model_frame._model:Hide()
        panel.model_frame._model:SetParent(nil)
        if (panel.model_frame._model._name:find('standin.')) then
            oq.DeleteFrame(panel.model_frame._model) -- recycling frame
        end
    end
    if (panel.model_frame._model ~= m) then
        panel.model_frame._model = m
        m:update_model()

    --    if (m.update_cam) then
    --      m:update_cam();
    --    end
    end

    -- show it
    panel.model_frame:Show()
end

function oq.raid_uses_models()
    local t = oq.raid.type
    if (t == OQ.TYPE_BG) or (t == OQ.TYPE_RAID) or (t == OQ.TYPE_ROLEPLAY) then
        return nil
    end
    return true
end

function oq.set_player_model(panel, name, gender, race)
    if (panel.model_frame == nil) and oq.raid_uses_models() then
        oq.model_slot_create(panel)
    end
    if (not panel:IsVisible()) then
        return
    end

    if
        ((name == nil) and (gender == nil) and (race == nil)) or
            (not oq.is_dungeon_premade(oq.raid.type) and (oq.raid.type ~= OQ.TYPE_ARENA) and
                (oq.raid.type ~= OQ.TYPE_RBG) and
                (oq.raid.type ~= OQ.TYPE_MISC))
     then
        if (panel) and (panel.model_frame) and (panel.model_frame._model ~= nil) then
            oq.model_slot_empty(panel)
        end
        return
    end
    local key = tostring(gender) .. '.' .. tostring(OQ.SHORT_RACE[race] or 0) .. '.' .. strlower(name)
    if (panel) and (panel.model_frame) and ((panel.model_frame._model == nil) or (panel.model_frame._model._key ~= key)) then
        oq.adjust_camera(panel, name, gender, race)
    else
        oq.camera_profile_mode(panel.model_frame._model, gender, race)
    end
end

function oq.set_textures_cell(m, cell)
    if (m == nil) or (cell == nil) or (cell.texture == nil) then
        if
            (cell ~= nil) and (cell.texture ~= nil) and
                ((oq.raid.type == OQ.TYPE_DUNGEON) or (oq.raid.type == OQ.TYPE_SCENARIO) or
                    (oq.raid.type == OQ.TYPE_ARENA) or
                    (oq.raid.type == OQ.TYPE_CHALLENGE) or
                    (oq.raid.type == OQ.TYPE_QUESTS) or
                    (oq.raid.type == OQ.TYPE_RBG) or
                    (oq.raid.type == OQ.TYPE_MISC))
         then
            cell.texture:SetPoint('TOPLEFT', cell.model_frame, 'TOPLEFT', 2, -3)
            cell.texture:SetPoint('BOTTOMRIGHT', cell.model_frame, 'BOTTOMRIGHT', -2, 3)
        end
        return
    end
    local color = OQ.CLASS_COLORS['XX']

    -- set color of cell
    if ((m.class ~= nil) and oq.is_set(m.flags, OQ.FLAG_ONLINE) and (OQ.CLASS_COLORS[m.class] ~= nil)) then
        color = OQ.CLASS_COLORS[m.class]
    end
    if (color ~= nil) then
        cell.texture:SetTexture(color.r, color.g, color.b, 1)
    else
        -- should not get here
    end

    if ((m.name == nil) or (m.name == '') or (m.name == '-')) then
        -- unused slot
        cell.status:SetTexture(nil)
        cell.class:SetTexture(nil)
        cell.role:SetTexture(nil)
        cell.charm:SetTexture(nil)
        oq.set_player_model(cell, nil, nil, nil)
        if
            (cell.texture ~= nil) and
                (oq.is_dungeon_premade(oq.raid.type) or (oq.raid.type == OQ.TYPE_ARENA) or (oq.raid.type == OQ.TYPE_RBG) or
                    (oq.raid.type == OQ.TYPE_MISC))
         then
            cell.texture:SetPoint('TOPLEFT', cell.model_frame, 'TOPLEFT', 2, -3)
            cell.texture:SetPoint('BOTTOMRIGHT', cell.model_frame, 'BOTTOMRIGHT', -2, 3)
        end
        return
    end
    -- set overlap state
    if (m.check == nil) then
        m.check = OQ.FLAG_CLEAR
    end
    cell.txt:Hide()
    if (m.check == OQ.FLAG_WAITING) then
        cell.status:SetTexCoord(0, 1.0, 0.0, 1.0)
        cell.status:SetTexture('Interface\\RAIDFRAME\\ReadyCheck-Waiting')
    elseif (m.check == OQ.FLAG_READY) then
        cell.status:SetTexCoord(0, 1.0, 0.0, 1.0)
        cell.status:SetTexture('Interface\\RAIDFRAME\\ReadyCheck-Ready')
    elseif (m.check == OQ.FLAG_NOTREADY) then
        cell.status:SetTexCoord(0, 1.0, 0.0, 1.0)
        cell.status:SetTexture('Interface\\RAIDFRAME\\ReadyCheck-NotReady')
    elseif (not oq.is_set(m.flags, OQ.FLAG_ONLINE)) then
        cell.status:SetTexCoord(0, 1.0, 0.0, 1.0)
        cell.status:SetTexture('Interface\\CHARACTERFRAME\\Disconnect-Icon') -- "Interface\\GuildFrame\\GuildLogo-NoLogoSm" );
    elseif (oq.is_set(m.flags, OQ.FLAG_BRB)) then
        cell.status:SetTexCoord(0, 0.50, 0.0, 0.50)
        cell.status:SetTexture('Interface\\CHARACTERFRAME\\UI-StateIcon') -- Interface\\RAIDFRAME\\ReadyCheck-Waiting" );
    elseif (oq.is_set(m.flags, OQ.FLAG_DESERTER)) then
        cell.status:SetTexCoord(0, 1.0, 0.0, 1.0)
        cell.status:SetTexture('Interface\\Icons\\Ability_Druid_Cower')
    elseif (oq.is_set(m.flags, OQ.FLAG_QUEUED)) then
        cell.status:SetTexCoord(0, 1.0, 0.0, 1.0)
        m.bg[1].dt = m.bg[1].dt or 0 -- in case nil
        m.bg[2].dt = m.bg[2].dt or 0 -- in case nil
        if (m._queue_color and (m._queue_color ~= 'nopop')) then
            local textureIndex = OQ.QUEUE_POPS[m._queue_color]
            local x1, x2, y1, y2 = GetObjectIconTextureCoords(textureIndex - 2) -- this map starts @ -2; indexes used in table came from wowpedia and are 0 based
            cell.status:SetTexture('Interface/Minimap/ObjectIcons.png')
            cell.status:SetTexCoord(x1, x2, y1, y2)
        else
            if (oq.player_faction == 'A') then
                cell.status:SetTexture('Interface\\BattlefieldFrame\\Battleground-Alliance')
            else
                cell.status:SetTexture('Interface\\BattlefieldFrame\\Battleground-Horde')
            end
        end
    else
        cell.status:SetTexture(nil)
    end

    -- set role
    if (oq.is_set(m.flags, OQ.FLAG_TANK)) then
        cell.role:SetTexture('Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES')
        cell.role:SetTexCoord(0, 19 / 64, 22 / 64, 41 / 64)
    elseif (oq.is_set(m.flags, OQ.FLAG_HEALER)) then
        cell.role:SetTexture('Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES')
        cell.role:SetTexCoord(20 / 64, 39 / 64, 1 / 64, 20 / 64)
    elseif oq.is_dungeon_premade() then
        cell.role:SetTexture('Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES')
        cell.role:SetTexCoord(20 / 64, 39 / 64, 22 / 64, 41 / 64)
    else
        cell.role:SetTexture(nil)
    end

    -- set model (dungeons & scenarios)
    if (m.realm_id == nil) then
        m.realm_id = 0
    end
    m.realm_id = tonumber(m.realm_id)

    if
        (cell.class ~= nil) and (m.realm_id > 0) and
            (oq.is_dungeon_premade(oq.raid.type) or (oq.raid.type == OQ.TYPE_ARENA) or (oq.raid.type == OQ.TYPE_RBG) or
                (oq.raid.type == OQ.TYPE_MISC))
     then
        local name = m.name
        if (m.realm_id ~= player_realm_id) then
            name = name .. '-' .. oq.GetRealmNameFromID(m.realm_id)
        end
        if (name ~= nil) then
            oq.set_player_model(cell, name, m.gender, m.race)
        end
        if (cell.texture ~= nil) then
            cell.texture:SetPoint('TOPLEFT', cell.model_frame, 'TOPLEFT', 2, -3)
            cell.texture:SetPoint('BOTTOMRIGHT', cell.model_frame, 'BOTTOMRIGHT', -2, 3)
        end
    end

    -- set lucky charm
    if (cell.charm ~= nil) then
        cell.charm:SetTexture('Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons')
        cell.charm:SetTexCoord(unpack(OQ.ICON_COORDS[m.charm or 0] or OQ.ICON_COORDS[0]))
    end
end

function oq.set_status(g_id, slot, deserter, queued, online)
    g_id = tonumber(g_id)
    slot = tonumber(slot)
    if ((g_id <= 0) or (slot <= 0)) then
        return
    end

    local m = oq.raid.group[g_id].member[slot]
    local old_stat = m.flags

    m.flags = oq.bset(m.flags, OQ.FLAG_DESERTER, deserter)
    m.flags = oq.bset(m.flags, OQ.FLAG_QUEUED, queued)
    m.flags = oq.bset(m.flags, OQ.FLAG_ONLINE, online)

    oq.set_textures(g_id, slot)
end

function oq.gather_my_stats()
    oq.check_for_deserter()
    my_group, my_slot = oq.find_my_group_id()
    oq.check_my_seat()
    player_ilevel = oq.get_ilevel()
    player_resil = oq.get_resil()
    if (player_realm == nil) or (player_realm == '') then
        player_realm = oq.GetRealmName()
    end
    if (player_realm_id == nil) or (player_realm_id == 0) then
        player_realm = oq.GetRealmName()
        player_realm_id = oq.GetRealmID(player_realm)
    end

    local s1 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(1))]
    local s2 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(2))]
    local old_q = player_queued
    player_queued = ((s1 ~= '0') or (s2 ~= '0'))
    player_online = true

    if ((my_group <= 0) or (my_slot <= 0)) then
        return
    end
    local me = oq.raid.group[my_group].member[my_slot]

    me.bg[1].status = s1
    me.bg[2].status = s2

    me.gender, me.race = oq.player_demographic()

    me.flags = 0 -- reset to 0
    me.flags = oq.bset(me.flags, OQ.FLAG_DESERTER, player_deserter)
    me.flags = oq.bset(me.flags, OQ.FLAG_QUEUED, player_queued)
    me.flags = oq.bset(me.flags, OQ.FLAG_ONLINE, player_online)
    me.flags = oq.bset(me.flags, OQ.FLAG_BRB, player_away)
    if (player_role == OQ.ROLES['TANK']) then
        me.flags = oq.bset(me.flags, OQ.FLAG_TANK, true)
    elseif (player_role == OQ.ROLES['HEALER']) then
        me.flags = oq.bset(me.flags, OQ.FLAG_HEALER, true)
    end

    if (me.check == nil) then
        me.check = OQ.FLAG_CLEAR
    end

    oq.set_role(my_group, my_slot, player_role)

    local s = oq.toon.stats['bg']
    if (oq.raid.type == OQ.TYPE_RBG) then
        s = oq.toon.stats['rbg']
    end

    me.resil = player_resil
    me.ilevel = player_ilevel
    me.hp = floor(UnitHealthMax('player') / 1000)
    me.wins = s.nWins or 0
    me.losses = s.nLosses or 0
    local hks = GetStatistic(588)
    if (hks == '--') then
        hks = 0
    end
    me.hks = floor(hks / 1000)
    me.oq_ver = OQ_BUILD
    me.tears = oq.total_tears()
    me.pvppower = oq.get_pvppower()
    me.mmr = oq.get_mmr()

    -- send out update if queue status changed
    if (player_queued and (old_q ~= player_queued) and (not _inside_bg)) then
        PlaySound('PVPENTERQUEUE')
    end
    --
    -- note: statistic id list
    --       http://www.wowwiki.com/Complete_list_of_Achievement_ID%27s
    --       588   Total Honorable Kills
end

function oq.set_deserter(g_id, slot, deserter)
    if ((g_id <= 0) or (slot <= 0)) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]
    if (m) then
        m.flags = oq.bset(m.flags or 0, OQ.FLAG_DESERTER, deserter)
    end
end

function oq.set_status_queued(g_id, slot, queued)
    if ((g_id <= 0) or (slot <= 0)) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]

    m.flags = oq.bset(m.flags, OQ.FLAG_QUEUED, queued)
end

function oq.set_status_online(g_id, slot, online)
    if ((g_id <= 0) or (slot <= 0)) then
        return
    end
    if (oq.raid.group[g_id] == nil) or (oq.raid.group[g_id].member == nil) or (oq.raid.group[g_id].member[slot] == nil) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]

    if (m.flags == nil) then
        m.flags = 0
    end
    m.flags = oq.bset(m.flags, OQ.FLAG_ONLINE, online)
end

function oq.set_role(g_id, slot, role)
    if ((g_id <= 0) or (slot <= 0)) then
        return
    end
    local m = oq.raid.group[g_id].member[slot]
    m.role = role

    if (role == OQ.ROLES['TANK']) then
        m.flags = oq.bset(m.flags, OQ.FLAG_HEALER, false)
        m.flags = oq.bset(m.flags, OQ.FLAG_TANK, true)
    elseif (role == OQ.ROLES['HEALER']) then
        m.flags = oq.bset(m.flags, OQ.FLAG_HEALER, true)
        m.flags = oq.bset(m.flags, OQ.FLAG_TANK, false)
    else
        m.flags = oq.bset(m.flags, OQ.FLAG_HEALER, false)
        m.flags = oq.bset(m.flags, OQ.FLAG_TANK, false)
    end
end

-- returns: alliance ngames, nleaders, nactive,
--          horde ngames, nleaders, nactive
function oq.decode_score_xdata(xdata)
    if (xdata == nil) then
        return 0, 0, 0, 0, 0, 0
    end
    return oq.decode_mime64_digits(xdata:sub(1, 3)), oq.decode_mime64_digits(xdata:sub(4, 6)), oq.decode_mime64_digits(
        xdata:sub(7, 9)
    ), oq.decode_mime64_digits(xdata:sub(10, 12)), oq.decode_mime64_digits(xdata:sub(13, 15)), oq.decode_mime64_digits(
        xdata:sub(16, 18)
    )
end

function oq.fmt_time(t)
    if (t == nil) then
        t = 0
    end
    local hrs = floor(t / (60 * 60))
    local min = floor(t / 60) % 60
    return string.format('%d:%02d', hrs, min)
end

function oq.get_officer(n, tag)
    local sz = '16'
    if (tag == 4) then -- golden
        sz = '22'
    end
    if (n == nil) or (n == 0) then
        return string.format('- |T%s:' .. sz .. ':' .. sz .. '|t', OQ.dragon_rank[tag].tag)
    else
        return string.format('%3d |T%s:' .. sz .. ':' .. sz .. '|t', n, OQ.dragon_rank[tag].tag)
    end
end

function oq.calc_queue_pop_dt(me, lead)
    me.bg[1].dt = math.abs(me.bg[1].queue_ts - lead.bg[1].queue_ts)
    me.bg[2].dt = math.abs(me.bg[2].queue_ts - lead.bg[2].queue_ts)
end

function oq.update_bg_queue_times(g_id, slot, queue_tm1, queue_tm2)
    local force_my_stats = nil
    local m = oq.raid.group[g_id].member[slot]
    local lead = oq.raid.group[1].member[1]

    if (g_id ~= my_group) or (slot ~= my_slot) then
        m.bg[1].queue_ts = queue_tm1
        m.bg[2].queue_ts = queue_tm2
    end
    oq.calc_queue_pop_dt(m, lead)

    if (g_id == 1) and (slot == 1) and ((my_group > 0) and (my_slot > 0)) then
        local me = oq.raid.group[my_group].member[my_slot]
        if (me) then
            local d1 = me.bg[1].dt
            local d2 = me.bg[2].dt

            for i = 1, 8 do
                for j = 1, 5 do
                    if (not oq.is_seat_empty(i, j)) then
                        oq.calc_queue_pop_dt(oq.raid.group[i].member[j], lead)
                    end
                end
            end

            -- push my stats
            if (d1 ~= me.bg[1].dt) or (d2 ~= me.bg[2].dt) then
                last_stats = nil
                force_my_stats = true
            end
        end
    end

    if (force_my_stats) then
        oq.check_stats()
    end
end

function oq.on_stats(name, realm_id, stats, btag, queue_tm1, queue_tm2)
    local g_id, slot = oq.decode_slot(stats)
    if (my_group == g_id) and (my_slot == slot) and (oq._override == nil) then
        -- don't tell me my own status
        return
    end
    if (g_id == 0) or (slot == 0) then
        -- bad info
        return
    end
    local realm
    name, realm = oq.name_sanity(name, realm_id)
    queue_tm1 = oq.decode_mime64_digits(queue_tm1)
    queue_tm2 = oq.decode_mime64_digits(queue_tm2)

    oq.ui.battleground_frame._chart:set_data((g_id - 1) * 5 + slot, queue_tm1)

    oq.raid.group[g_id].member[slot].realid = btag or oq.raid.group[g_id].member[slot].realid

    local rc = oq.check_seat(name, realm, g_id, slot)

    local g, s, lvl, demos = oq.decode_stats2(name, realm, stats)
    if (g) and (s) then
        oq.set_textures(g, s)
    end

    oq._override = nil
    if (g == 0) and (s == 0) then
        -- most likely my slot... ignore
        return
    end
    local realm_id = 0
    if (realm == nil) or (realm == '-') then
        realm = 'n/a'
    else
        realm_id = tonumber(realm)
        realm = oq.GetRealmNameFromID(realm)
    end

    if (oq.raid.type == OQ.TYPE_BG) then
        oq.update_bg_queue_times(g_id, slot, queue_tm1, queue_tm2)
    end

    oq.update_tab1_stats()

    if (name) and (realm) then
        local key = string.gsub(strlower(name .. '-' .. realm), ' ', '')
        if (OQ_data._members[key] == nil) or (OQ_data._members[key] == 'x') then
            OQ_data._members[key] = btag
            oq.log(nil, oq.btag_link('member', name, realm, btag))
        end
    end

    _ok2relay = nil -- do not relay the stats message
end

function oq.init_table()
    oq_ascii = oq_ascii or tbl.new()
    oq_mime64 = oq_mime64 or tbl.new()

    for i = 0, 255 do
        local c = string.format('%c', i)
        local n = i
        oq_ascii[n] = c
        oq_ascii[c] = n
    end

    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local n = strlen(charset)
    for i = 1, n do
        local c = charset:sub(i, i)
        oq_mime64[i - 1] = c
        oq_mime64[c] = i - 1
    end
end

function oq.base64(a, b, c)
    local w, x, y, z
    a = oq_ascii[a]
    b = oq_ascii[b]
    c = oq_ascii[c]

    --   w = (a & 0xFC) >> 2 ;
    w = bit.rshift(bit.band(a, 0xFC), 2)

    --   x = ((a & 0x03) << 4) + ((b & 0xF0) >> 4);
    x = bit.lshift(bit.band(a, 0x03), 4) + bit.rshift(bit.band(b, 0xF0), 4)

    --   y = ((b & 0x0F) << 2) + ((c & 0xC0) >> 6);
    y = bit.lshift(bit.band(b, 0x0F), 2) + bit.rshift(bit.band(c, 0xC0), 6)

    --   z = (c & 0x3F);
    z = bit.band(c, 0x3F)

    w = oq_mime64[w]
    x = oq_mime64[x]
    y = oq_mime64[y]
    z = oq_mime64[z]
    return w, x, y, z
end

function oq.base256(w, x, y, z)
    local a, b, c
    w = oq_mime64[w] or 0
    x = oq_mime64[x] or 0
    y = oq_mime64[y] or 0
    z = oq_mime64[z] or 0

    --   a = (w << 2) + ((x & 0x30) >> 4);
    a = bit.lshift(w, 2) + bit.rshift(bit.band(x, 0x30), 4)

    --   b = ((x & 0x0F) << 4) + ((y & 0x3C) >> 2);
    b = bit.lshift(bit.band(x, 0x0F), 4) + bit.rshift(bit.band(y, 0x3C), 2)

    --   c = ((y & 0x03) << 6) + z ;
    c = bit.lshift(bit.band(y, 0x03), 6) + z

    a = oq_ascii[a]
    b = oq_ascii[b]
    c = oq_ascii[c]
    return a, b, c
end

function oq.decode256(enc)
    local str = ''
    local n = strlen(enc)
    local w, x, y, z, a, b, c
    for i = 1, n, 4 do
        w = enc:sub(i, i)
        x = enc:sub(i + 1, i + 1)
        y = enc:sub(i + 2, i + 2)
        z = enc:sub(i + 3, i + 3)
        a, b, c = oq.base256(w, x, y, z)
        str = str .. '' .. a .. '' .. b .. '' .. c
    end
    return str
end

function oq.encode64(str)
    local enc = ''
    local n = strlen(str)
    local w, x, y, z, a, b, c
    for i = 1, n, 3 do
        a = str:sub(i, i)
        b = str:sub(i + 1, i + 1)
        c = str:sub(i + 2, i + 2)
        w, x, y, z = oq.base64(a, b, c)
        enc = enc .. '' .. w .. '' .. x .. '' .. y .. '' .. z
    end
    return enc
end

function oq.encrypt(pword, str)
    local enc = ''
    local plen = strlen(pword)
    local len = strlen(str)
    local n = 1

    for i = 1, len do
        local a = oq_ascii[str:sub(i, i)]
        local b = oq_ascii[pword:sub(n, n)]
        enc = enc .. oq_ascii[bit.bxor(a, b)]
        n = n + 1
        if (n > plen) then
            n = 1
        end
    end
    return enc
end

function oq.decrypt(pword, enc)
    local str = ''
    local plen = strlen(pword)
    local len = strlen(enc)
    local n = 1

    for i = 1, len do
        local a = oq_ascii[enc:sub(i, i)]
        local b = oq_ascii[pword:sub(n, n)]
        str = str .. oq_ascii[bit.bxor(a, b)]
        n = n + 1
        if (n > plen) then
            n = 1
        end
    end
    return str
end

function oq.encode_data(pword, name, realm, rid)
    local s = tostring(name) .. ',' .. tostring(oq.GetRealmID(realm)) .. ',' .. tostring(rid)

    -- sub then reverse
    s = string.gsub(s, ',', ';')
    s = s:reverse()

    -- encrypt
    -- current bug with encrypt / decrypt
    --  s = oq.encrypt(pword, s);

    -- put in cocoon
    return oq.encode64(s)
end

function oq.decode_data(pword, data)
    -- pull from the cocoon
    local s = oq.decode256(data)

    -- decrypt
    -- current bug with encrypt / decrypt
    --  s = oq.decrypt(pword, s);

    -- reverse then sub
    s = s:reverse()
    s = string.gsub(s, ';', ',')

    -- pull vars out of it
    tbl.fill_match(_arg, s, ',')

    local playerName = _arg[1]
    local realmId = tonumber(_arg[2])
    local playerRealId = _arg[3]

    return playerName, OQ.REALMS[realmId], _arg[3], realmId
end

function oq.encode_pword(pword)
    local s = pword or '.'
    if (s:len() > 10) then
        s = s:sub(1, 10)
    elseif (s == '') then
        s = '.'
    end

    -- sub then reverse
    s = string.gsub(s, ',', ';')
    s = s:reverse()

    -- put in cocoon
    return oq.encode64(s)
end

function oq.decode_pword(data)
    if (data == nil) or (data == '') then
        return ''
    end
    -- pull from the cocoon
    local s = oq.decode256(data)

    -- reverse then sub
    s = s:reverse()
    s = string.gsub(s, ';', ',')

    if (s == '.') then
        s = ''
    end

    return s
end

function oq.encode_name(name)
    local s = name or '.'
    if (s:len() > 25) then
        s = s:sub(1, 25)
    elseif (s == '') then
        s = '.'
    end

    -- sub then reverse
    s = string.gsub(s, ',', ';')
    s = s:reverse()

    -- put in cocoon
    return oq.encode64(s)
end

function oq.decode_name(data)
    -- pull from the cocoon
    local s = oq.decode256(data)

    -- reverse then sub
    s = s:reverse()
    s = string.gsub(s, ';', ',')

    if (s == '.') then
        s = ''
    end

    return s
end

function oq.encode_note(note)
    local s = note or '.'
    if (s:len() > 150) then
        s = s:sub(1, 150)
    elseif (s == '') then
        s = '.'
    end

    -- sub then reverse
    s = string.gsub(s, ',', ';')
    s = s:reverse()

    -- put in cocoon
    return oq.encode64(s)
end

function oq.decode_note(data)
    -- pull from the cocoon
    local s = oq.decode256(data)

    -- reverse then sub
    s = s:reverse()
    s = string.gsub(s, ';', ',')

    if (s == '.') then
        s = ''
    end

    return s
end

function oq.encode_bg(note)
    local s = note or '.'
    if (s:len() > 35) then
        s = s:sub(1, 35)
    elseif (s == '') then
        s = '.'
    end

    -- sub then reverse
    s = string.gsub(s, ',', ';')
    s = s:reverse()

    -- put in cocoon
    return oq.encode64(s)
end

function oq.decode_bg(data)
    if (data == nil) then
        return ''
    end
    -- pull from the cocoon
    local s = oq.decode256(data)

    -- reverse then sub
    s = s:reverse()
    s = string.gsub(s, ';', ',')

    if (s == '.') then
        s = ''
    end

    return s
end

function oq.encode_slot(gid, slot)
    gid = tonumber(gid) or 0
    slot = tonumber(slot) or 0
    if (gid == 0) then
        return oq.encode_mime64_1digit(gid) -- 0 == no slot assigned
    end
    return oq.encode_mime64_1digit((gid - 1) * 5 + slot)
end

function oq.decode_slot(m)
    local n = oq.decode_mime64_digits(m:sub(1, 1))
    return floor(((n - 1) / 5) + 1), floor((n - 1) % 5) + 1
end

function oq.get_class_type(spec_ndx)
    if (spec_ndx == nil) or (spec_ndx == 0) then
        return nil
    end
    return OQ.CLASS_SPEC[spec_ndx]
end

function oq.get_class_spec(spec_id)
    if (spec_id == nil) or (spec_id == 0) then
        return nil
    end

    for _, v in pairs(OQ.CLASS_SPEC) do
        if (v.id == spec_id) then
            return v
        end
    end
    return nil
end

function oq.get_class_spec_type(spec_id)
    for i, v in pairs(OQ.CLASS_SPEC) do
        if (v.id == spec_id) then
            return v.type, v.n, i
        end
    end
    return 0, nil, 0
end

function oq.get_melee_crit()
    local meleecrit = GetCritChance() or 0
    return floor(meleecrit * 100)
end

function oq.get_melee_atk_pow()
    local base, posBuff, negBuff = UnitAttackPower('player')
    local effective = base + posBuff + negBuff
    return effective
end

function oq.get_armor()
    local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor('player')
    return armor
end

function oq.get_stat_str()
    local statID = 1
    local stat, effectiveStat, posBuff, negBuff = UnitStat('player', statID)
    return effectiveStat
end

function oq.get_stat_agil()
    local statID = 2
    local stat, effectiveStat, posBuff, negBuff = UnitStat('player', statID)
    return effectiveStat
end

function oq.get_stat_stam()
    local statID = 3
    local stat, effectiveStat, posBuff, negBuff = UnitStat('player', statID)
    return effectiveStat
end

function oq.get_stat_int()
    local statID = 4
    local stat, effectiveStat, posBuff, negBuff = UnitStat('player', statID)
    return effectiveStat
end

function oq.get_stat_spr()
    local statID = 5
    local stat, effectiveStat, posBuff, negBuff = UnitStat('player', statID)
    return effectiveStat
end

function oq.get_spell_hit()
    local spellhit = (GetCombatRatingBonus(CR_HIT_SPELL) + GetSpellHitModifier()) or 0
    return floor(spellhit * 100)
end

function oq.get_spell_haste()
    local haste = UnitSpellHaste("player") or 0
    return floor(haste)
end

function oq.get_melee_hit()
    local meleehit = (GetCombatRatingBonus(CR_HIT_MELEE) + GetHitModifier()) or 0
    return floor(meleehit * 100)
end

function oq.get_melee_haste()
    local haste = GetMeleeHaste() or 0
    return floor(haste * 100)
end

function oq.get_range_hit()
    local rangehit = (GetCombatRatingBonus(CR_HIT_RANGED) + GetHitModifier()) or 0
    return floor(rangehit * 100)
end

function oq.get_ranged_crit()
    local rangecrit = GetRangedCritChance() or 0
    return floor(rangecrit * 100)
end

function oq.get_ranged_atk_pow()
    local base, posBuff, negBuff = UnitRangedAttackPower('player')
    local effective = base + posBuff + negBuff
    return effective
end

function oq.get_spell_crit()
    return GetSpellCritChance(2)
end

function oq.get_spell_mp5()
    local base, casting = GetManaRegen()
    local mp5 = floor((casting or 0) * 0.4)
    return mp5
end

function oq.get_bonus_heal()
    local bonus = GetSpellBonusHealing() or 0
    return bonus
end

function oq.get_spell_dmg()
    local dmg = 0
    for i = 1, 7 do
        dmg = max(dmg, GetSpellBonusDamage(i) or 0)
    end

    return dmg
end

function oq.encode_my_stats(flags, xflags, charm, s1, s2, ignore_raid_xp, raid_type)
    local class, spec, spec_id = oq.get_spec()
    local gender, race = oq.player_demographic()
    local faction_ = 0 -- 0 == horde, 1 == alliance
    if (oq.player_faction ~= 'H') then
        faction_ = 1
    end
    local demos = bit.lshift(race, 2) + bit.lshift(gender, 1) + faction_
    local m = nil
    raid_type = raid_type or oq.raid.type
    if (my_group > 0) then
        m = oq.raid.group[my_group].member[my_slot]
    end
    --

    --[[ all purpose header data ]] local s = oq.encode_slot(my_group, my_slot)
    s = s .. (raid_type or OQ.TYPE_NONE)
    s = s .. oq.encode_mime64_2digit(UnitLevel('player')) -- 1..90, requires 2 digits
    s = s .. oq.encode_mime64_1digit(demos)
    s = s .. OQ.TINY_CLASS[OQ.SHORT_CLASS[class]]
    s = s .. oq.encode_mime64_1digit(flags)
    s = s .. oq.encode_mime64_1digit(xflags)
    s = s .. oq.encode_mime64_1digit(charm)
    s = s .. oq.encode_mime64_2digit(floor(UnitHealthMax('player') / 1000)) -- hp
    s = s .. oq.encode_mime64_1digit(oq.get_player_role())
    s = s .. oq.encode_mime64_1digit(OQ.CLASS_SPEC[spec_id].id)
    s = s .. oq.encode_mime64_2digit(player_ilevel)
    s = s .. oq.encode_mime64_2digit(OQ_BUILD)
    --

    --[[ premade type specific data ]] if
        oq.is_dungeon_premade(raid_type) or (raid_type == OQ.TYPE_RAID) or (raid_type == OQ.TYPE_ROLEPLAY)
     then
        -- class.spec specific pve data
        local type = OQ.CLASS_SPEC[spec_id].type
        if (type == OQ.TANK) then
            --
            -- melee hit
            -- armor
            -- stam
            -- agil
            -- str
            --
            s = s .. oq.encode_mime64_2digit(floor(oq.get_melee_hit() or 0)) -- melee hit
            s = s .. oq.encode_mime64_2digit(floor(oq.get_armor() or 0)) -- armor
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_stam() or 0)) -- stam
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_agil() or 0)) -- agil
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_str() or 0)) -- str
	    s = s .. oq.encode_mime64_2digit(0) -- placeholder
            s = s .. oq.encode_mime64_2digit(0) -- placeholder
        elseif (type == OQ.CASTER) then
            --
            -- spell hit
            -- spell damage
            -- spell crit chance
            -- int
            -- spirit
            --
            s = s .. oq.encode_mime64_2digit(floor(oq.get_spell_hit() or 0)) -- spell hit
            s = s .. oq.encode_mime64_2digit(floor(oq.get_spell_dmg() or 0)) -- spell damage
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_stam() or 0)) -- stam
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_int() or 0)) -- agil
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_str() or 0)) -- str
            s = s .. oq.encode_mime64_2digit(floor(oq.get_spell_haste() or 0)) -- spell haste
            s = s .. oq.encode_mime64_2digit(0) -- placeholder
        elseif (type == OQ.HEALER) then
            --
            -- spell bonus healing
            -- spirit
            -- mp5 ( base.regen + casting.regen; GetManaRegen())
            -- int
            -- spell crit
            --
            s = s .. oq.encode_mime64_2digit(floor(oq.get_bonus_heal() or 0)) -- spell bonus healing
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_spr() or 0)) -- spirit
            s = s .. oq.encode_mime64_2digit(floor(oq.get_spell_mp5() or 0)) -- spell mp5
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_int() or 0)) -- int
            s = s .. oq.encode_mime64_2digit(floor(oq.get_spell_crit() or 0)) -- spell crit
            s = s .. oq.encode_mime64_2digit(0) -- placeholder
            s = s .. oq.encode_mime64_2digit(0) -- placeholder
        elseif (type == OQ.RDPS) then
            --
            -- range hit
            -- agi
            -- stam
            -- int
            -- spirit
            -- ranged crit
            -- ranged atk power
            --
            s = s .. oq.encode_mime64_2digit(floor(oq.get_range_hit() or 0)) -- range hit chance
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_agil() or 0)) -- agil
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_stam() or 0)) -- stam
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_int() or 0)) -- int
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_spr() or 0)) -- spirit
            s = s .. oq.encode_mime64_2digit(floor(oq.get_ranged_crit() or 0)) -- ranged crit chance
            s = s .. oq.encode_mime64_2digit(floor(oq.get_ranged_atk_pow() or 0)) -- ranged atk power
        else -- (type == OQ.MDPS)
            --
            -- melee hit
            -- str
            -- agil
            -- melee crit
            -- melee attack power ( oq.meleeAP )
            --
            s = s .. oq.encode_mime64_2digit(floor(oq.get_melee_hit() or 0)) -- melee hit
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_str() or 0)) -- str
            s = s .. oq.encode_mime64_2digit(floor(oq.get_stat_agil() or 0)) -- agil
            s = s .. oq.encode_mime64_2digit(floor(oq.get_melee_crit() or 0)) -- melee crit chance
            s = s .. oq.encode_mime64_2digit(floor(oq.get_melee_atk_pow() or 0)) -- melee atk power
            s = s .. oq.encode_mime64_2digit(floor(oq.get_melee_haste() or 0)) -- melee haste
            s = s .. oq.encode_mime64_2digit(0) -- placeholder
        end

        -- raid progression data
        if (raid_type == OQ.TYPE_CHALLENGE) then
            s = s .. oq.get_past_experience()
        elseif (ignore_raid_xp == nil) then
            s = s .. oq.get_raid_progression()
        end
    else
        --    s = s .. oq.encode_mime64_2digit( oq.get_arena_rating(1) ) ; -- 2s
        --    s = s .. oq.encode_mime64_2digit( oq.get_arena_rating(2) ) ; -- 3s
        --    s = s .. oq.encode_mime64_2digit( oq.get_arena_rating(3) ) ; -- 5s
        -- pvp stats
        local bg_stats = oq.toon.stats['rbg']
        if (raid_type == OQ.TYPE_BG) then
            bg_stats = oq.toon.stats['bg']
        end
        s = s .. oq.encode_mime64_3digit(oq.get_resil())
        s = s .. oq.encode_mime64_3digit(oq.get_pvppower())
        s = s .. oq.encode_mime64_3digit(bg_stats.nWins)
        s = s .. oq.encode_mime64_3digit(bg_stats.nLosses)
        s = s .. oq.encode_mime64_3digit(oq.total_tears()) -- the only tears that count are those of your enemy; rbgs could be same faction
        s = s .. oq.encode_mime64_2digit(oq.get_best_mmr(raid_type)) -- rbg rating
        s = s .. oq.encode_mime64_2digit(oq.get_hks()) -- total hks
        s = s .. tostring(s1 or 0)
        s = s .. tostring(s2 or 0)
        if (m ~= nil) then
            m.ranks = oq.get_pvp_experience()
            s = s .. m.ranks -- ranks & titles
        else
            s = s .. oq.get_pvp_experience()
        end
    end
    -- karma, tacked on the back to avoid protocol change and forced update
    s = s .. oq.encode_mime64_1digit(min(50, max(0, player_karma + 25)))
    if (my_group > 0) then
        oq.decode_stats2(player_name, player_realm, s, true)
    end
    return s
end

function oq.decode_their_stats(m, s)
    m.premade_type = s:sub(2, 2)
    m.stats = s -- hold onto the last stats

    m.level = oq.decode_mime64_digits(s:sub(3, 4))
    local demos = oq.decode_mime64_digits(s:sub(5, 5))
    if (demos == '0') then
        return demos
    end
    m.gender = bit.rshift(bit.band(0x02, demos), 1)
    m.race = bit.rshift(bit.band(0x3C, demos), 2)
    m.faction = 'H'
    if (bit.band(0x01, demos) ~= 0) then
        m.faction = 'A'
    end
    m.class = OQ.TINY_CLASS[s:sub(6, 6)]
    m.hp = oq.decode_mime64_digits(s:sub(10, 11))
    m.role = oq.decode_mime64_digits(s:sub(12, 12))
    m.spec_id = oq.decode_mime64_digits(s:sub(13, 13))
    m.ilevel = oq.decode_mime64_digits(s:sub(14, 15))
    m.oq_ver = oq.decode_mime64_digits(s:sub(16, 17))
    m.spec_type = oq.get_class_spec_type(m.spec_id) -- tank, healer, dmg
    m.role_type_id, m.role_type = oq.role_type(m.spec_id) -- ie: 0x0001, 'dps'
    m.karma = nil

    if oq.is_dungeon_premade(m.premade_type) or (m.premade_type == OQ.TYPE_RAID) or (m.premade_type == OQ.TYPE_ROLEPLAY) then
        if (m.spec_type == OQ.TANK) then
            --
            -- melee hit
            -- armor
            -- stam
            -- agil
            -- str
            --
            m.melee_hit = (oq.decode_mime64_digits(s:sub(18, 19)) or 0) / 100 -- now a percentage
            m.armor = (oq.decode_mime64_digits(s:sub(20, 21)) or 0)
            m.stam = (oq.decode_mime64_digits(s:sub(22, 23)) or 0)
            m.agil = (oq.decode_mime64_digits(s:sub(24, 25)) or 0)
            m.str = (oq.decode_mime64_digits(s:sub(26, 27)) or 0)
            m.raids = s:sub(32, -1)
        elseif (m.spec_type == OQ.CASTER) then
            --
            -- spell hit
            -- spell damage
            -- spell crit chance
            -- int
            -- spirit
            --
            m.spell_hit = (oq.decode_mime64_digits(s:sub(18, 19)) or 0) / 100
            m.spell_dmg = (oq.decode_mime64_digits(s:sub(20, 21)) or 0)
            m.spell_crit = (oq.decode_mime64_digits(s:sub(22, 23)) or 0) / 100
            m.int = (oq.decode_mime64_digits(s:sub(24, 25)) or 0)
            m.spr = (oq.decode_mime64_digits(s:sub(26, 27)) or 0)
	        m.spell_haste = (oq.decode_mime64_digits(s:sub(28, 29)) or 0)
            m.raids = s:sub(31, -1)
        elseif (m.spec_type == OQ.HEALER) then
            --
            -- spell bonus healing
            -- spirit
            -- mp5 ( base.regen + casting.regen; GetManaRegen())
            -- int
            -- spell crit
            --
            m.bonus_heal = (oq.decode_mime64_digits(s:sub(18, 19)) or 0)
            m.spr = (oq.decode_mime64_digits(s:sub(20, 21)) or 0)
            m.heal_mp5 = (oq.decode_mime64_digits(s:sub(22, 23)) or 0)
            m.int = (oq.decode_mime64_digits(s:sub(24, 25)) or 0)
            m.spell_crit = (oq.decode_mime64_digits(s:sub(26, 27)) or 0) / 100
            m.raids = s:sub(32, -1)
        elseif (m.spec_type == OQ.RDPS) then
            --
            -- range hit
            -- agi
            -- stam
            -- int
            -- spirit
            -- ranged crit
            -- ranged atk power
            --
            m.ranged_hit = (oq.decode_mime64_digits(s:sub(18, 19)) or 0) / 100
            m.agil = (oq.decode_mime64_digits(s:sub(20, 21)) or 0)
            m.stam = (oq.decode_mime64_digits(s:sub(22, 23)) or 0)
            m.int = (oq.decode_mime64_digits(s:sub(24, 25)) or 0)
            m.spr = (oq.decode_mime64_digits(s:sub(26, 27)) or 0)
            m.ranged_crit = (oq.decode_mime64_digits(s:sub(28, 29)) or 0) / 100
            m.ranged_atk_pow = (oq.decode_mime64_digits(s:sub(30, 31)) or 0)
            m.raids = s:sub(32, -1)
        elseif (m.spec_type == OQ.MDPS) then
            --
            -- melee hit
            -- str
            -- agil
            -- melee crit
            -- melee attack power ( oq.meleeAP )
            --
            m.melee_hit = (oq.decode_mime64_digits(s:sub(18, 19)) or 0) / 100
            m.str = (oq.decode_mime64_digits(s:sub(20, 21)) or 0)
            m.agil = (oq.decode_mime64_digits(s:sub(22, 23)) or 0)
            m.melee_crit = (oq.decode_mime64_digits(s:sub(24, 25)) or 0) / 100
            m.melee_atk_pow = (oq.decode_mime64_digits(s:sub(26, 27)) or 0)
            m.raids = s:sub(32, -1)
        end
        m.karma = m.raids:sub(-1, -1) -- last character
        m.raids = m.raids:sub(1, -2) -- trim off last character
    else --
        --[[ pvp data ]]
        m.resil = oq.decode_mime64_digits(s:sub(18, 20))
        m.pvppower = oq.decode_mime64_digits(s:sub(21, 23))
        m.wins = oq.decode_mime64_digits(s:sub(24, 26))
        m.losses = oq.decode_mime64_digits(s:sub(27, 29))
        m.tears = oq.decode_mime64_digits(s:sub(30, 32))
        m.mmr = oq.decode_mime64_digits(s:sub(33, 34))
        m.hks = oq.decode_mime64_digits(s:sub(35, 36))

        m.ranks = s:sub(39, -1)

        -- tail:  223355k
        --    m.arena2s  = oq.decode_mime64_digits( m.ranks:sub( -7, -6 ) ) ;
        --    m.arena3s  = oq.decode_mime64_digits( m.ranks:sub( -5, -4 ) ) ;
        --    m.arena5s  = oq.decode_mime64_digits( m.ranks:sub( -3, -2 ) ) ;

        m.karma = m.ranks:sub(-1, -1) -- last character
        m.ranks = m.ranks:sub(1, -2) -- trim off last character
    end
    if (m.karma == nil) or (m.karma == '') then
        m.karma = 0
    else
        m.karma = oq.decode_mime64_digits(m.karma) - 25 -- 0..50, must rebalance to -25..25
    end
    return demos
end

function oq.decode_stats2(name, realm, s, force_it)
    local g_id, slot = oq.decode_slot(s)
    local demos = oq.decode_mime64_digits(s:sub(5, 5))
    local cgid, cslot = oq.find_members_seat(oq.raid.group, name)
    if (cgid) then
        -- found data, ignore submitted - only get from partynames, coming from boss
        g_id = cgid
        slot = cslot
    end
    if (((my_group == g_id) and (my_slot == slot) and (force_it == nil)) or (g_id == 0) or (slot == 0)) then
        return 0, 0, 0, 0
    end
    oq.assure_slot_exists(g_id, slot)

    -- decode directly into member slot
    local m = oq.raid.group[g_id].member[slot]
    if (m == nil) then
        return 0, 0, 0, 0
    end
    m.name, m.realm_id, m.realm = oq.name_sanity(m.name, m.realm_id)

    if (oq.decode_their_stats(m, s) == '0') then
        return g_id, slot, m.level, '0'
    end
    if ((g_id ~= my_group) or (slot ~= my_slot)) then
        m.flags = oq.decode_mime64_digits(s:sub(7, 7))
        m.check = oq.decode_mime64_digits(s:sub(8, 8))
        oq.set_charm(g_id, slot, oq.decode_mime64_digits(s:sub(9, 9)))
    end
    oq.set_role(g_id, slot, oq.decode_mime64_digits(s:sub(12, 12)))
    if oq.is_dungeon_premade(m.premade_type) or (m.premade_type == OQ.TYPE_RAID) or (m.premade_type == OQ.TYPE_ROLEPLAY) then
        local s1 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(1))]
        local s2 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(2))]
        oq.set_group_member(g_id, slot, name, realm, m.class, m.realid, s1, s2)
    else
        oq.set_group_member(g_id, slot, name, realm, m.class, m.realid, s:sub(36, 36), s:sub(37, 37))
    end
    return g_id, slot, m.level, demos
end

function oq.decode_short_stats(s)
    local lvl = tonumber(s:sub(1, 2))
    local faction = s:sub(3, 3)
    if (faction == '0') then
        return lvl, faction
    end
    local class = s:sub(4, 5)
    local resil = oq.decode_mime64_digits(s:sub(6, 8))
    local ilevel = oq.decode_mime64_digits(s:sub(9, 10))
    local role = tonumber(s:sub(11, 11) or 3)
    local mmr = oq.decode_mime64_digits(s:sub(12, 13))
    local pvppower = oq.decode_mime64_digits(s:sub(14, 16))
    local spec_id = oq.decode_mime64_digits(s:sub(17, 18))

    return lvl, faction, class, resil, ilevel, role, mmr, pvppower, spec_id
end

function oq.encode_short_stats(level, faction, class, resil, ilevel, role, mmr, pvppower, spec_id)
    local lvl = level
    if (lvl < 10) then
        lvl = '0' .. tostring(lvl)
    end
    local cls = class
    if (cls == nil) or (cls:len() > 2) then
        cls = OQ.SHORT_CLASS[class] or 'ZZ'
    end

    local stats =
        lvl ..
        '' ..
            faction ..
                '' ..
                    cls ..
                        '' ..
                            oq.encode_mime64_3digit(resil) ..
                                '' ..
                                    oq.encode_mime64_2digit(ilevel) ..
                                        '' ..
                                            tostring(role or 3) ..
                                                '' ..
                                                    oq.encode_mime64_2digit(mmr) ..
                                                        '' ..
                                                            oq.encode_mime64_3digit(pvppower) ..
                                                                '' .. oq.encode_mime64_2digit(spec_id)
    return stats
end

function oq.encode_mime64_7digit(n_)
    local n = oq.numeric_sanity(n_)
    local g = floor(n % 64)
    n = floor(n / 64)
    local f = floor(n % 64)
    n = floor(n / 64)
    local e = floor(n % 64)
    n = floor(n / 64)
    local d = floor(n % 64)
    n = floor(n / 64)
    local c = floor(n % 64)
    n = floor(n / 64)
    local b = floor(n % 64)
    n = floor(n / 64)
    local a = floor(n % 64)
    return oq_mime64[a] .. oq_mime64[b] .. oq_mime64[c] .. oq_mime64[d] .. oq_mime64[e] .. oq_mime64[f] .. oq_mime64[g]
end

function oq.encode_mime64_6digit(n_)
    local n = oq.numeric_sanity(n_)
    local f = floor(n % 64)
    n = floor(n / 64)
    local e = floor(n % 64)
    n = floor(n / 64)
    local d = floor(n % 64)
    n = floor(n / 64)
    local c = floor(n % 64)
    n = floor(n / 64)
    local b = floor(n % 64)
    n = floor(n / 64)
    local a = floor(n % 64)
    return oq_mime64[a] .. oq_mime64[b] .. oq_mime64[c] .. oq_mime64[d] .. oq_mime64[e] .. oq_mime64[f]
end

function oq.encode_mime64_5digit(n_)
    local n = oq.numeric_sanity(n_)
    local e = floor(n % 64)
    n = floor(n / 64)
    local d = floor(n % 64)
    n = floor(n / 64)
    local c = floor(n % 64)
    n = floor(n / 64)
    local b = floor(n % 64)
    n = floor(n / 64)
    local a = floor(n % 64)
    return oq_mime64[a] .. oq_mime64[b] .. oq_mime64[c] .. oq_mime64[d] .. oq_mime64[e]
end

function oq.encode_mime64_4digit(n_)
    local n = oq.numeric_sanity(n_)
    local d = floor(n % 64)
    n = floor(n / 64)
    local c = floor(n % 64)
    n = floor(n / 64)
    local b = floor(n % 64)
    n = floor(n / 64)
    local a = floor(n % 64)
    return oq_mime64[a] .. oq_mime64[b] .. oq_mime64[c] .. oq_mime64[d]
end

function oq.encode_mime64_3digit(n_)
    local n = oq.numeric_sanity(n_)
    local c = floor(n % 64)
    n = floor(n / 64)
    local b = floor(n % 64)
    n = floor(n / 64)
    local a = floor(n % 64)
    return oq_mime64[a] .. oq_mime64[b] .. oq_mime64[c]
end

function oq.encode_mime64_2digit(n_)
    local n = oq.numeric_sanity(n_)
    local b = floor(n % 64)
    n = floor(n / 64)
    local a = floor(n % 64)
    return oq_mime64[a] .. oq_mime64[b]
end

function oq.encode_mime64_1digit(n_)
    local n = oq.numeric_sanity(n_)
    local a = floor(n % 64)
    return oq_mime64[a]
end

function oq.encode_mime64_flags(f1, f2, f3, f4, f5, f6)
    local a = 0
    a = oq.bset(a, 0x01, f1)
    a = oq.bset(a, 0x02, f2)
    a = oq.bset(a, 0x04, f3)
    a = oq.bset(a, 0x08, f4)
    a = oq.bset(a, 0x10, f5)
    a = oq.bset(a, 0x20, f6)
    return oq_mime64[a]
end

function oq.decode_mime64_digits(s)
    local n = 0
    if (s) and (s ~= '') then
        for i = 1, #s do
            n = (n * 64 + oq_mime64[s:sub(i, i) or 'A']) or 0
        end
    end
    return n
end

function oq.decode_mime64_flags(data)
    local n = oq_mime64[data]
    local f1 = oq.is_set(n, 0x01)
    local f2 = oq.is_set(n, 0x02)
    local f3 = oq.is_set(n, 0x04)
    local f4 = oq.is_set(n, 0x08)
    local f5 = oq.is_set(n, 0x10)
    return f1, f2, f3, f4, f5
end

oq.e3 = oq.encode_mime64_3digit

function oq.encode_premade_info(raid_token, stat, tm, has_pword, is_realm_specific, is_source, karma, min_ilvl)
    local raid = oq.premades[raid_token]
    if (raid == nil) then
        return
    end
    local min_number = raid.min_mmr
    if (raid.type == OQ.TYPE_RAID) or (raid.type == OQ.TYPE_DUNGEON) then
        min_number = min_ilvl
    end
    return oq.encode_mime64_flags((raid.faction == 'H'), has_pword, is_realm_specific, is_source) ..
        oq.encode_mime64_1digit(OQ.SHORT_LEVEL_RANGE[raid.level_range]) ..
            oq.encode_mime64_2digit(raid.min_ilevel) ..
                oq.encode_mime64_3digit(raid.min_resil) ..
                    oq.encode_mime64_1digit(raid.nMembers) ..
                        oq.encode_mime64_1digit(raid.nWaiting) ..
                            oq.encode_mime64_1digit(stat) ..
                                oq.encode_mime64_6digit(tm) ..
                                    oq.encode_mime64_2digit(min_number) ..
                                        oq.encode_mime64_1digit((karma or 0) + 25) .. -- will change it from -25..25 to 0..50
                                            oq.encode_mime64_2digit(OQ_BUILD)
end

function oq.decode_premade_info(data)
    local is_horde, has_pword, is_realm_specific, is_source = oq.decode_mime64_flags(data:sub(1, 1))
    local faction = 'A'
    if (is_horde) then
        faction = 'H'
    end
    local range = OQ.SHORT_LEVEL_RANGE[oq.decode_mime64_digits(data:sub(2, 2))] or OQ.SHORT_LEVEL_RANGE[1]
    local karma = data:sub(19, 19)
    if (karma == nil) or (karma == '') then
        karma = 0
    else
        karma = oq.decode_mime64_digits(karma) - 25
    end

    return faction, has_pword, is_realm_specific, is_source,
    range,
    oq.decode_mime64_digits( data:sub( 3, 4) ), -- min ilevel
    oq.decode_mime64_digits( data:sub( 5, 7) ), -- min resil
    oq.decode_mime64_digits( data:sub( 8, 8) ), -- nmembers
    oq.decode_mime64_digits( data:sub( 9, 9) ), -- nwaiting
    oq.decode_mime64_digits( data:sub(10,10) ), -- stat
--         oq.decode_mime64_digits( data:sub(11,16) ), -- raid.tm
    oq.utc_time(),  -- raid.tm is now local time since it came across a realm channel
    oq.decode_mime64_digits( data:sub(17,18) ), -- min mmr
    karma                                     , -- karma; must be -25..25
    oq.decode_mime64_digits( data:sub(20,21) )  -- oq version
end

function oq.encode_preferences(voip_, role_, classes_, lang_)
    local str = ''
    if (OQ.VOIP_ICON[voip_] == nil) then
        str = str .. OQ.VOIP_UNSPECIFIED
    else
        str = str .. voip_
    end

    str = str .. oq.encode_mime64_1digit(role_ or 0x0007) --  3 bit fields; def == 0x0x07; tank, heal, dps
    str = str .. oq.encode_mime64_2digit(classes_ or 0x07ff) -- 11 bit fields; def == 0x07ff

    if (OQ.LANG_ICON[lang_] == nil) then
        str = str .. OQ.LANG_UNSPECIFIED
    else
        str = str .. lang_
    end

    return str
end

--  voip_, spec_, classes_, lang_ = oq.decode_preferences(preferences_);
function oq.decode_preferences(data)
    if (data == nil) then
        return OQ.VOIP_UNSPECIFIED, 0x07, 0x0fff, OQ.LANG_UNSPECIFIED -- no data; assume all specs and classes
    end
    return data:sub(1, 1), oq.decode_mime64_digits(data:sub(2, 2)), oq.decode_mime64_digits(data:sub(3, 4)), data:sub( -- voip type -- bitfield: role -- bitfield: classes
        5,
        5
    ) -- language preferred
end

function oq.check_party_members()
    if (my_group == 0) then
        return
    end
    local grp = oq.raid.group[my_group]
    local new_mem = nil
    local mem_gone = nil
    local n_members = GetNumGroupMembers()
    local rost = tbl.new()

    for i = 1, 4 do
        if (grp.member[i].name) and (grp.member[i].name ~= '') and (grp.member[i].name ~= '-') then
            rost[grp.member[i].name] = tbl.new()
            rost[grp.member[i].name].ndx = i
            rost[grp.member[i].name].raidid = 0
        end
    end

    for i = 1, n_members do
        local name = UnitName('party' .. i)
        if (rost[name] == nil) then
            new_mem = true
        else
            rost[name].raidid = i
        end
    end

    for name, v in pairs(rost) do
        if (name ~= nil) and (v.raidid == 0) and (name ~= player_name) then
            mem_gone = true
            oq.raid_cleanup_slot(my_group, v.ndx)
        end
    end

    if (oq.iam_party_leader() and (new_mem or mem_gone)) then
        local now = oq.utc_time()
        if ((last_ident_tm + 5) < now) then
            last_ident_tm = now
            oq.party_announce('identify,' .. my_group)
        end
    end
    -- cleanup
    for _, v in pairs(rost) do
        tbl.delete(v)
    end
    tbl.delete(rost)
end

function oq.get_party_roles()
    local grp = oq.raid.group[my_group]
    local m = ''

    for i = 1, 5 do
        local p = grp.member[i]
        if (p.name == nil) or (p.name == '-') or (p.name == '') then
            m = m .. 'x'
        else
            m = m .. '' .. UnitGroupRolesAssigned(p.name):sub(1, 1)
        end
    end
    return m
end

function oq.first_raid_slot()
    local n = oq.nMaxGroups()

    for g = 1, n do
        for s = 1, 5 do
            local p = oq.raid.group[g].member[s]
            if (p.name == nil) or (p.name == '-') then
                return g, s
            end
        end
    end
    return 0, 0
end

function oq.set_name(gid, slot, name, realm, class, is_online)
    if ((gid == 0) or (slot == 0)) then
        return
    end
    local realm_id = realm
    if (tonumber(realm) ~= nil) then
        realm = oq.GetRealmNameFromID(realm)
    else
        realm_id = oq.GetRealmID(realm)
    end
    local m = oq.raid.group[gid].member[slot]
    if (name == '-') then
        m.name = nil
        m.realm = nil
        m.realm_id = 0
        m.class = nil
    else
        m.name = name
        m.realm = realm
        m.realm_id = realm_id
        m.class = class
        if (slot == 1) then
        -- update group leader info
        end
    end
    m.flags = oq.bset(m.flags, OQ.FLAG_ONLINE, (is_online == nil) or (is_online == 'B'))
    if (name == player_name) and ((realm == nil) or (realm == '-') or (realm == player_realm)) then
        local force_stats = nil
        if ((my_group ~= gid) or (my_slot ~= slot)) then
            force_stats = true
        end
        my_group = gid
        my_slot = slot
        m.realm = player_realm
        m.realm_id = player_realm_id
        m.class = player_class
        oq.ui_player()
        oq.update_my_premade_line()
    end
    oq.set_textures(gid, slot)
end

function oq.name_sanity(name, realm_id)
    local realm = oq.GetRealmNameFromID(realm_id)
    if (name) and (name ~= '-') and (name:find('-')) then
        realm = name:sub(name:find('-') + 1, -1)
        name = name:sub(1, name:find('-') - 1)
        realm_id = oq.GetRealmID(realm)
    end
    return name, realm_id, realm
end

function oq.on_identify(gid)
    gid = tonumber(gid)
    if (gid == 0) then
        gid = nil
    end
    _ok2relay = nil
    if (_inside_bg) or ((gid ~= nil) and (gid ~= my_group)) then
        return
    end
    local now = oq.utc_time()
    if ((last_ident_tm + 5) > now) then
        return
    end
    last_ident_tm = now
    oq.party_announce('name,' .. my_group .. ',' .. my_slot .. ',' .. player_name .. ',' .. player_realm)
end

function oq.on_name(gid, slot, name, realm)
    gid = tonumber(gid)
    slot = tonumber(slot)
    if ((oq._inside_instance == 1) or (gid == 0) or (slot == 0)) then
        return
    end
    local m = oq.raid.group[gid].member[slot]
    m.name = name
    m.realm = realm
end

function oq.get_my_stats()
    local m = oq.raid.group[my_group].member[my_slot]
    oq.gather_my_stats()

    -- pack up info and ship
    m.realid = oq.player_realid -- just in case
    m.stats = oq.encode_my_stats(m.flags, m.check, m.charm, m.bg[1].status, m.bg[2].status)

    if (last_stats == nil) or (m.stats ~= last_stats) then
        oq._override = true
        oq.on_stats(
            player_name,
            oq.GetRealmID(player_realm),
            m.stats,
            oq.player_realid,
            oq.encode_mime64_5digit(m.bg[1].queue_ts),
            oq.encode_mime64_5digit(m.bg[2].queue_ts)
        )
        oq._override = nil
    end
    return m.stats
end

function oq.force_stats()
    last_stats = nil
    if (my_group == 0) then
        return
    end
    oq.raid.group[my_group]._stats = ''
    oq.check_stats()
end

-- fired on a timer once every 5 seconds.  only send if stats change
--
function oq.check_stats()
    -- if not in an OQ raid, leave
    if
        (my_group == nil) or (my_slot == nil) or (my_group <= 0) or (my_slot <= 0) or (oq.raid.raid_token == nil) or
            (_inside_bg)
     then
        return
    end

    -- gather bg queue status
    if (oq.raid.group[my_group] == nil) or (oq.raid.group[my_group].member[my_slot] == nil) then
        return
    end
    local me = oq.raid.group[my_group].member[my_slot]

    -- check my stats, post if changed
    local my_stats = oq.get_my_stats()
    skip_stats = skip_stats + 1
    if (last_stats == nil) or (my_stats ~= last_stats) or (skip_stats >= 3) then
        last_stats = my_stats
        skip_stats = 0
        oq._override = true
        oq.raid_announce(
            'stats,' ..
                player_name ..
                    ',' ..
                        tostring(oq.GetRealmID(player_realm)) ..
                            ',' ..
                                my_stats ..
                                    ',' ..
                                        tostring(oq.player_realid) ..
                                            ',' ..
                                                oq.encode_mime64_5digit(me.bg[1].queue_ts) ..
                                                    ',' .. oq.encode_mime64_5digit(me.bg[2].queue_ts)
        )
    end
end

function oq.send_lag_times()
    local msg = 'lag_times'

    for i = 1, 8 do
        msg = msg .. ',' .. (oq.raid.group[i].member[1].lag or 0)
    end
    oq.raid_announce(msg)
end

function oq.set_lag(grp, label, tm)
    tm = tonumber(tm) or 0
    grp.member[1].lag = tm
    if (grp.member[1].name == nil) or (grp.member[1].name == '-') then
        label:SetText('')
    else
        label:SetText(string.format('%5.2f', tm / 1000))
    end
end

function oq.on_lag_times(t1, t2, t3, t4, t5, t6, t7, t8)
    oq.set_lag(oq.raid.group[1], oq.tab1_group[1].lag, t1)
    oq.set_lag(oq.raid.group[2], oq.tab1_group[2].lag, t2)
    oq.set_lag(oq.raid.group[3], oq.tab1_group[3].lag, t3)
    oq.set_lag(oq.raid.group[4], oq.tab1_group[4].lag, t4)
    oq.set_lag(oq.raid.group[5], oq.tab1_group[5].lag, t5)
    oq.set_lag(oq.raid.group[6], oq.tab1_group[6].lag, t6)
    oq.set_lag(oq.raid.group[7], oq.tab1_group[7].lag, t7)
    oq.set_lag(oq.raid.group[8], oq.tab1_group[8].lag, t8)
    oq.raid._last_lag = oq.utc_time()
end

function oq.procs_init()
    -- all procs
    --
    oq.proc = oq.proc or tbl.new()
    tbl.clear(oq.proc)
    oq.proc['boss'] = oq.on_boss
    oq.proc['brb'] = oq.on_brb
    oq.proc['btag'] = oq.on_btag
    oq.proc['charm'] = oq.on_charm
    oq.proc['disband'] = oq.on_disband
    oq.proc['enter_bg'] = oq.on_enter_bg
    oq.proc['iam_back'] = oq.on_iam_back
    oq.proc['identify'] = oq.on_identify
    oq.proc['invite_accepted'] = oq.on_invite_accepted
    oq.proc['invite_group'] = oq.on_invite_group
    oq.proc['invite_req_response'] = oq.on_invite_req_response
    oq.proc['lag_times'] = oq.on_lag_times
    oq.proc['leave'] = oq.on_leave
    oq.proc['leave_slot'] = oq.on_leave_slot
    oq.proc['leave_queue'] = oq.on_leave_queue
    oq.proc['leave_waitlist'] = oq.on_leave_waitlist
    oq.proc['mbox_bn_enable'] = oq.on_mbox_bn_enable
    oq.proc['member'] = oq.on_member
    oq.proc['name'] = oq.on_name
    oq.proc['need_btag'] = oq.on_need_btag
    oq.proc['new_lead'] = oq.on_new_lead
    oq.proc['party_join'] = oq.on_party_join
    oq.proc['party_update'] = oq.on_party_update
    oq.proc['pass_lead'] = oq.on_pass_lead
    oq.proc['pending_note'] = oq.on_pending_note
    oq.proc['ping'] = oq.on_ping
    oq.proc['ping_ack'] = oq.on_ping_ack
    oq.proc['p8'] = oq.on_premade
    oq.proc['premade_note'] = oq.on_premade_note
    oq.proc['promote'] = oq.on_promote
    oq.proc['proxy_invite'] = oq.on_proxy_invite
    oq.proc['proxy_target'] = oq.on_proxy_target
    oq.proc['oq_user'] = oq.on_oq_user
    oq.proc['oq_user_ack'] = oq.on_oq_user
    oq.proc['ready_check'] = oq.on_ready_check
    oq.proc['ready_check_complete'] = oq.on_ready_check_complete
    oq.proc['remove'] = oq.on_remove
    oq.proc['removed_from_waitlist'] = oq.on_removed_from_waitlist
    oq.proc['ri'] = oq.on_req_invite -- was "req_invite"
    oq.proc['selfie'] = oq.on_selfie
    oq.proc['stats'] = oq.on_stats

    -- these msgids will be processed while in a bg
    oq.bg_msgids = tbl.new()
    oq.bg_msgids['boss'] = 1
    oq.bg_msgids['k3'] = 1
    oq.bg_msgids['leave_waitlist'] = 1
    oq.bg_msgids['oq_user'] = 1
    oq.bg_msgids['oq_user_ack'] = 1
    oq.bg_msgids['pass_lead'] = 1
    oq.bg_msgids['p8'] = 1
    oq.bg_msgids['v8'] = 1

    -- remove raid-only procs
    oq.procs_no_raid()
end

-- in-raid only procs
--
function oq.procs_join_raid()
    -- raid required procs
    --
    oq.proc['brb'] = oq.on_brb
    oq.proc['btag'] = oq.on_btag
    oq.proc['charm'] = oq.on_charm
    oq.proc['enter_bg'] = oq.on_enter_bg
    oq.proc['iam_back'] = oq.on_iam_back
    oq.proc['identify'] = oq.on_identify
    oq.proc['lag_times'] = oq.on_lag_times
    oq.proc['leave'] = oq.on_leave
    oq.proc['leave_slot'] = oq.on_leave_slot
    oq.proc['leave_queue'] = oq.on_leave_queue
    oq.proc['member'] = oq.on_member
    oq.proc['name'] = oq.on_name
    oq.proc['need_btag'] = oq.on_need_btag
    oq.proc['new_lead'] = oq.on_new_lead
    oq.proc['party_update'] = oq.on_party_update
    oq.proc['pass_lead'] = oq.on_pass_lead
    oq.proc['ping'] = oq.on_ping
    oq.proc['ping_ack'] = oq.on_ping_ack
    oq.proc['premade_note'] = oq.on_premade_note
    oq.proc['promote'] = oq.on_promote
    oq.proc['ready_check'] = oq.on_ready_check
    oq.proc['ready_check_complete'] = oq.on_ready_check_complete
    oq.proc['remove'] = oq.on_remove
    oq.proc['selfie'] = oq.on_selfie
    oq.proc['stats'] = oq.on_stats
end

-- nulls the in-raid only procs
--
function oq.procs_no_raid()
    -- clear the associated function for raid-only procs
    --
    oq.proc['brb'] = nil
    oq.proc['btag'] = nil
    oq.proc['charm'] = nil
    oq.proc['enter_bg'] = nil
    oq.proc['gs'] = nil -- changed from "grp_stats"
    oq.proc['iam_back'] = nil
    oq.proc['identify'] = nil
    oq.proc['join'] = nil
    oq.proc['lag_times'] = nil
    oq.proc['leave'] = nil
    oq.proc['leave_group'] = nil
    oq.proc['leave_queue'] = nil
    oq.proc['member'] = nil
    oq.proc['name'] = nil
    oq.proc['need_btag'] = nil
    oq.proc['new_lead'] = nil
    oq.proc['party_msg'] = nil
    oq.proc['party_update'] = nil
    oq.proc['pass_lead'] = nil
    oq.proc['ping'] = nil
    oq.proc['ping_ack'] = nil
    oq.proc['premade_note'] = nil
    oq.proc['promote'] = nil
    oq.proc['ready_check'] = nil
    oq.proc['ready_check_complete'] = nil
    oq.proc['remove'] = nil
    oq.proc['selfie'] = nil
    oq.proc['stats'] = nil
end

--------------------------------------------------------------------------
--  event handlers
--------------------------------------------------------------------------
function oq.on_addon_event(prefix, msg, channel, sender)
    if
        (prefix ~= OQ_HEADER) or (sender == player_name) or (strlower(sender) == oq.player_realid) or (msg == nil) or
            (msg == '')
     then
        return
    end
    -- just process, do not send it on
    _source = 'addon'
    if (channel == 'PARTY') then
        _source = 'party'
    end
    _ok2relay = nil
    oq._sender = sender
    if (oq._sender:find('-') == nil) and (player_realm) then
        oq._sender = oq._sender .. '-' .. tostring(player_realm)
    end
    oq.process_msg(sender, msg)
    oq.post_process()
end

function oq.on_channel_msg(...)
    tbl.fill(_arg, ...)

    local msg = _arg[1]
    local sender = _arg[2]

    if (sender == player_name or msg == nil or msg == '') then
        oq.post_process()
        return
    end

    local chan_name = strlower(_arg[9])
    if (not oq.channel_isregistered(chan_name)) then
        oq.post_process()
        return
    end

    if (chan_name == OQ_REALM_CHANNEL) then
        local name, realm = strsplit('-', sender)

        _inc_channel = OQ_REALM_CHANNEL
        _source = OQ_REALM_CHANNEL
        oq._sender = sender
        oq._sender_name = name
        oq._sender_realm = realm

        _ok2relay = 1

        oq.process_msg(sender, msg)
    end
    oq.post_process()
end

function oq.on_received_whisper(...)
    tbl.fill(_arg, ...)

    local msg = _arg[1]
    local sender = _arg[2]

    _source = 'bnet'
    _ok2relay = nil

    local name, realm, full
    local pos = sender:find('-')
    if (pos == nil and player_realm) then
        name = sender
        realm = player_realm
    elseif (pos ~= nil) then
        name = sender:sub(1, pos - 1)
        realm = sender:sub(pos + 1, -1)
    end

    oq._sender_name = name
    oq._sender_realm = realm
    oq._sender = name .. '-' .. realm

    oq.process_msg(sender, msg)
    oq.post_process()
end

function oq.ForwardRaidMessage(msg)
    if (oq.iam_party_leader() and (_source == 'party')) then
        oq.WhisperRaidLeader(msg)
    elseif (oq.iam_party_leader() and (_source ~= 'party')) then
        oq.SendPartyMessage(msg)
    end
end

function oq.forward_msg(source, sender, msg_type, _, msg)
    -- no relaying while in a BG.  BATTLEGROUND msgs are BG-wide, everything else stops here
    --
    if _msg_id == 'p8' and _inc_channel ~= OQ_REALM_CHANNEL and my_slot ~= 1 and oq._raid_token ~= oq.raid.raid_token then
        oq.SendOQChannelMessage(msg)
        if (_hop == 0) then
            return
        end
    elseif _msg_id == 'p8' and _inc_channel ~= OQ_REALM_CHANNEL and _hop == 0 and _source == 'bnet' then
        oq.SendOQChannelMessage(msg)
        return
    end

    if (_inside_bg) then
        return
    end
    if (source == 'party') and (my_slot ~= 1) then
        return
    end

    if (_to_realm ~= nil) and (_to_name ~= nil) then
        if (_to_realm == player_realm) and (_msg_id ~= 'p8') then
            _ok2relay = nil -- on the realm, just send direct
        end
        if (_to_name == player_name) then
            -- msg was for me, do not forward unless it was an announcement ... then strip off the to & realm fields and send
            if (msg_type == 'A') then
                if (_msg_id == nil) or (_msg_id ~= 'p8') then
                    oq.announce_relay(_core_msg)
                end
            end
            return
        end
        -- delivered
        if (_ok2relay ~= 'bnet') then
            oq.SendAddonMessage(OQ_HEADER, msg, 'WHISPER', _to_name)
            return
        end
    end
    if (not _ok2relay) then
        return
    end

    if (oq.iam_raid_leader()) and ((msg_type == 'B') or (msg_type == 'R')) then
        -- relay to group leads
        oq.SendPartyMessage(msg)
        return
    end
    if
        (source == 'bnet') and ((msg_type == 'B') or (msg_type == 'P') or (msg_type == 'R')) and
            (not oq.iam_raid_leader())
     then
        -- receiving msg via an alt (happens with multi-boxers); must send to raid leader
        if (sender ~= oq.raid.leader) then -- prevent back flow
            oq.WhisperRaidLeader(msg)
        end
        oq.WhisperPartyLeader(msg)
    end
    if ((msg_type == 'A') or ((msg_type == 'W') and (not _received))) then
        oq.bn_echo_raid(msg)
        oq.announce_relay(msg)
    elseif (msg_type == 'P') or (msg_type == 'R') then
        oq.SendPartyMessage(msg)
    end
end

function oq.ping_oq_toon(toon_pid, toonName, realmName, ts, ack)
    if (oq.player_realid == nil) or (player_realm == nil) or (player_name == nil) or (player_name == nil) then
        return
    end

    -- insure we don't ping toons more then once every 5 seconds.
    --
    oq.ping_toons_ts = oq.ping_toons_ts or tbl.new()
    local now = oq.utc_time()
    if (ack == nil) and ((now - (oq.ping_toons_ts[toon_pid] or 0)) < 5) then
        return
    end
    oq.ping_toons_ts[toon_pid] = now

    local msg =
        'OQ,' ..
        OQ_BUILD_STR ..
        ',' ..
        'W1,' ..
        '1,' .. -- OQ_TTL ..",".. (only one hop... to the specified target)
        'oq_user,' ..
        player_name ..
        ',' ..
        player_realm ..
        ',' ..
        oq.player_faction ..
        ',' .. oq.player_realid .. ',' .. oq.encode_mime64_5digit(ts or 0)

    if (ack) and (ack ~= '') then
        msg = msg .. ',' .. ack
    end

    local f = oq.toon.disabled
    oq.toon.disabled = nil
    oq.XRealmWhisper(toonName, realmName, msg)
    oq.toon.disabled = f
end

function oq.send_oq_user_ack(toon_pid, toonName, realmName)
    oq.ping_oq_toon(toon_pid, toonName, realmName, oq.utc_time(), 'true')
end

function oq.on_oq_user(toonName, realmName, faction, _, ts_, is_ack)
    if (_source ~= 'bnet') then
        return
    end

    local ts = oq.decode_mime64_digits(ts_)
    local name_ndx = strlower(tostring(toonName) .. '-' .. tostring(realmName))
    local friend = OQ_data.bn_friends[name_ndx]
    if (is_ack) and (is_ack == 'stop') then
        if (friend) then
            OQ_data.bn_friends[name_ndx] = tbl.delete(OQ_data.bn_friends[name_ndx])
        end
        return
    end
    if (friend == nil) then
        OQ_data.bn_friends[name_ndx] = tbl.new()
        friend = OQ_data.bn_friends[name_ndx]
        oq.waitlist_check(toonName, realmName) -- first time thru, see if they should be invited
    end
    friend.isOnline = true
    friend.toonName = toonName
    friend.realm = realmName
    friend.pid = -1
    friend.toon_id = oq._sender_toonid -- this message should be coming in on bnet
    friend.oq_enabled = true
    friend.faction = faction

    oq.waitlist_check(toonName, realmName) -- first time thru, see if they should be invited
    if (is_ack == nil) then
        oq.send_oq_user_ack(oq._sender_toonid, toonName, realmName)
    end
    oq.n_connections()
end

function oq.CheckForUpdates(oq_ver)
    oq_ver = tonumber(oq_ver)
    if (oq_ver == nil) or (oq_ver == OQ_BUILD) then
        -- match, bail out
        return
    end

    local now = oq.utc_time()
    if (oq_ver < OQ_BUILD) then
        -- my version is the same or newer, nothing to do.
        return
    end

    if (OQ_data.next_update_notice == nil) or (OQ_data.next_update_notice < now) then
        -- notify user
        local dialog = StaticPopup_Show('OQ_NewVersionAvailable', oq.get_version_str(oq_ver))
        dialog:SetWidth(400)
        dialog:SetHeight(175)
        -- update notification cycle
        OQ_data.next_update_notice = now + OQ_NOTIFICATION_CYCLE
    end
end

function oq.stricmp(a, b)
    if (a == nil) and (b == nil) then
        return true
    end
    if (a == nil) or (b == nil) then
        return nil
    end
    if (strlower(a) == strlower(b)) then
        return true
    end
    return nil
end

function oq.iam_related_to_boss()
    if (player_realm ~= oq.raid.leader_realm) then
        return nil
    end

    for _, v in pairs(oq.toon.my_toons) do
        if (oq.stricmp(v.name, oq.raid.leader)) then
            return true
        end
    end
    return nil
end

function oq.route_to_boss(msg)
    if (oq._sender ~= oq.raid.leader) then -- prevent back flow
        oq.WhisperRaidLeader(msg)
    end
end

function oq.recover_premades()
    OQ_data._premade_info = OQ_data._premade_info or tbl.new()
    OQ_data._pending_info = OQ_data._pending_info or tbl.new()
    local now = oq.utc_time()
    local tm = nil
    local msg = nil
    local p1, p2, f
    local dt = floor(OQ_PREMADE_STAT_LIFETIME / 2)

    for i, v in pairs(OQ_data._premade_info) do
        f = v:sub(1, 1)
        p1 = 3
        p2 = v:find('%.', p1)
        if (p1) then
            tm = tonumber(v:sub(p1, p2 - 1))
            msg = v:sub(p2 + 1, -1)
        end
        if (f == oq.player_faction) then
            if (tm) and (msg) and ((now - tm) < dt) then
                _inc_channel = OQ_REALM_CHANNEL
                _source = OQ_REALM_CHANNEL
                oq._sender = '#backup'
                _ok2relay = nil
                oq.process_msg(oq._sender, msg)
                oq.post_process()
                if (OQ_data._pending_info[i]) then
                    local r = oq.premades[i]
                    if (r) then
                        r.pending = true
                        r.followup_allowed = (OQ_data._pending_info[i]:sub(1, 1) == '1')
                        r._my_note = OQ_data._pending_info[i]:sub(3, -1)
                    end
                end
            else
                OQ_data._premade_info[i] = nil -- out of date... clear
                OQ_data._pending_info[i] = nil -- out of date... clear
            end
        elseif ((now - tm) > dt) then
            OQ_data._premade_info[i] = nil -- out of date... clear
            OQ_data._pending_info[i] = nil -- out of date... clear
        end
        tm = nil
        msg = nil
    end
end

function oq.show_premade_cache()
    OQ_data._premade_info = OQ_data._premade_info or tbl.new()
    OQ_data._pending_info = OQ_data._pending_info or tbl.new()

    local now = oq.utc_time()
    local tm = nil
    local msg = nil
    local p1, p2, f
    local nCurrent = 0
    local nOld = 0
    local notInList = 0
    local nHorde = 0
    local nAlliance = 0
    local dt = floor(OQ_PREMADE_STAT_LIFETIME / 2)

    print('--[ premade cache ]--')
    for tok, v in pairs(OQ_data._premade_info) do
        f = v:sub(1, 1)
        if (f == 'H') then
            nHorde = nHorde + 1
        else
            nAlliance = nAlliance + 1
        end
        p1 = 3
        p2 = v:find('%.', p1)
        if (p2) then
            tm = tonumber(v:sub(p1, p2 - 1))
            msg = v:sub(p2 + 1, -1)
        end
        if (tm) and (msg) and ((now - tm) < dt) then
            nCurrent = nCurrent + 1
            if (oq.premades[tok] == nil) then
                notInList = notInList + 1
            end
        else
            nOld = nOld + 1
        end
        tm = nil
        msg = nil
    end
    print(tostring(nCurrent) .. ' current premades')
    print(tostring(notInList) .. ' current, but not in list')
    print(tostring(nOld) .. ' old premades')
    print(tostring(nHorde) .. ' horde')
    print(tostring(nAlliance) .. ' alliance')
end

function oq.trim_old_premades()
    OQ_data._premade_info = OQ_data._premade_info or tbl.new()
    OQ_data._pending_info = OQ_data._pending_info or tbl.new()

    local now = oq.utc_time()
    local tm = nil
    local msg = nil
    local p1, p2
    local dt = floor(OQ_PREMADE_STAT_LIFETIME / 2)
    local n = 0
    local oldies = tbl.new()

    for tok, v in pairs(OQ_data._premade_info) do
        p1 = 3
        p2 = v:find('%.', p1)
        if (p2) then
            tm = tonumber(v:sub(p1, p2 - 1))
            msg = v:sub(p2 + 1, -1)
        end
        if (tm == nil) or (msg == nil) or ((now - tm) > dt) then
            oldies[tok] = 1
            n = n + 1
        end
        tm = nil
        msg = nil
    end

    for tok, _ in pairs(oldies) do
        oq.remove_premade(tok)
    end
    tbl.delete(oldies)

    oq.old_raids = oq.old_raids or tbl.new()
    oq._p8s = oq._p8s or tbl.new()
    local dt = floor(OQ_PREMADE_STAT_LIFETIME / 2)
    for tok, v in pairs(oq._p8s) do
        if ((now - v) > dt) then
            oq._p8s[tok] = nil
            oq.old_raids[tok] = nil
        end
    end

    oq.atok_clear_old()
end

function oq.process_bundle(sender, realm, msg)
    -- up to first '|' used as a dummy msg for users not updated.
    -- msg id will be 'bundle' and not mapped, therefore ignored
    -- (working with existing users on old protocol)
    --
    if (oq._bundle == nil) then
        oq._bundle = tbl.new()
    end
    local bundle = msg:sub((msg:find('|') or 0) + 1, -1)
    tbl.fill_match(oq._bundle, bundle, '|')

    for _, v in pairs(oq._bundle) do
        _source = 'bnet'
        _ok2relay = nil
        oq._sender = sender
        oq._sender_realm = realm
        oq.process_msg(oq._sender, v)
        oq.post_process()
    end
end

function oq.process_msg(sender, msg)
    if (msg:find(OQ.DRUNK)) or (oq._isAfk) then
        return
    end

    tbl.fill_match(_vars, msg, ',')
    _msg = msg
    _core_msg, _to_name, _to_realm, _from = oq.crack_bn_msg(msg)
    --
    -- format:  "OQ,".. OQ_BUILD_STR ..",".. msg_tok ..",".. hop | raid-token ..",".. msg ;
    --
    local oq_sig = _vars[1]
    local oq_ver = _vars[2]
    local token = _vars[3]
    local msg_id = _vars[5]
    local atok

    -- every msg recv'd is counted, not just those processed
    oq.pkt_recv:inc()

    if (_inside_bg and (oq.bg_msgids[msg_id] == nil)) or (oq._banned) then
        return
    end

    if (oq_sig ~= OQ_HEADER or oq.toon.disabled) then
        -- not the same protocol, cannot proceed
        return
    end

    if (oq_ver ~= OQ_BUILD_STR) then
        -- different versions
        oq.CheckForUpdates(oq_ver)
        return
    end

    _msg_type = token:sub(1, 1)

    if (_msg_type == 'A') then
        atok = _vars[6] -- announce token
        if (not oq.atok_ok2process(atok)) then
            return
        end
    end

    --
    -- squash any echo
    --
    if ((token ~= 'W1') and oq.token_was_seen(token)) then
        return
    end
    if ((token == 'W1') and (_source == OQ_REALM_CHANNEL)) then
        -- these messages cannot come from OQgen
        return
    elseif (token == 'W1') then
        _ok2relay = nil
        _reason = 'direct whisper'
    end
    _msg_token = token
    _msg_id = msg_id
    _received = nil
    oq.pkt_processed:inc()

    if ((_msg_id ~= 'scores') and (_msg_id ~= 'p8')) then
        if
            (_source == 'bnet') and (_to_name ~= nil) and (_to_name ~= player_name) and (_to_realm ~= nil) and
                (_to_realm == player_realm)
         then
            oq.SendAddonMessage(OQ_HEADER, _core_msg, 'WHISPER', _to_name)
            return
        end
        if (_source == 'bnet') and (not oq.iam_raid_leader()) and oq.iam_related_to_boss() then
            oq.route_to_boss(_core_msg)
            return
        end
    end

    -- hang onto token to reduce echo
    -- note: hold token after sending to boss as multi-acct bnets will route the data back
    --       and dont want to ignore it when it comes back
    oq.token_push(token)

    --
    -- unseen message-token.  ok to process
    --
    local inc_channel = _inc_channel
    _inc_channel = nil -- suspend the nonsending for processing.  afterwards, put it back for relaying

    -- raid, party or boss msgs
    if ((_msg_type == 'R') or (_msg_type == 'P') or (_msg_type == 'B')) then
        local raid_token = _vars[4]
        -- check to see if it's my raid token
        if
            (((oq.raid.raid_token == nil) or (raid_token == oq.raid.raid_token) or (msg_id == 'party_join')) and
                (oq.proc[msg_id] ~= nil))
         then
            oq.proc[msg_id](
                _vars[6],
                _vars[7],
                _vars[8],
                _vars[9],
                _vars[10],
                _vars[11],
                _vars[12],
                _vars[13],
                _vars[14],
                _vars[15],
                _vars[16],
                _vars[17],
                _vars[18],
                _vars[19],
                _vars[20],
                _vars[21],
                _vars[22],
                _vars[23],
                _vars[24],
                _vars[25],
                _vars[26],
                _vars[27],
                _vars[28],
                _vars[29],
                _vars[30],
                _vars[31],
                _vars[32],
                _vars[33],
                _vars[34],
                _vars[35]
            )
        end
    elseif ((_msg_type == 'A') or (_msg_type == 'W')) then
        _hop = tonumber(_vars[4] or 0) or 0
        if (oq.proc[msg_id] ~= nil) and ((token == 'W1') or ((_hop >= 0) and (_hop <= OQ_TTL))) then
            oq.proc[msg_id](
                _vars[6],
                _vars[7],
                _vars[8],
                _vars[9],
                _vars[10],
                _vars[11],
                _vars[12],
                _vars[13],
                _vars[14],
                _vars[15],
                _vars[16],
                _vars[17],
                _vars[18],
                _vars[19],
                _vars[20],
                _vars[21],
                _vars[22],
                _vars[23],
                _vars[24],
                _vars[25],
                _vars[26],
                _vars[27],
                _vars[28],
                _vars[29],
                _vars[30],
                _vars[31],
                _vars[32],
                _vars[33],
                _vars[34],
                _vars[35]
            )
        else
            _ok2relay = nil
        end

        -- rebuild msg for transport, incrementing #hops
        if ((_msg_type == 'A') and (_hop > 0) and (_hop <= OQ_TTL)) then
            -- elseif (_msg_type == 'A') and (_hop == 0) and (_source == 'bnet') then
            --     _ok2relay = true
            if (_source ~= OQ_REALM_CHANNEL) then
                -- only decrement when crossing realms, not crossing the realm channel
                _vars[4] = _hop - 1
            end

            msg = nil

            for i = 1, #_vars do
                if (i == 1) then
                    msg = _vars[i]
                else
                    msg = msg .. ',' .. _vars[i]
                end
            end
            -- re-crack to get update the core_msg
            _core_msg, _to_name, _to_realm, _from = oq.crack_bn_msg(msg)
        elseif (_msg_type == 'A') and (_hop <= 0) then
            _ok2relay = nil
            _reason = (_reason or '') .. ' ttl'
        end
    end

    -- reset the inc channel
    _inc_channel = inc_channel

    --
    -- spread message
    --
    if
        (oq._sender ~= '#backup') and
            ((token ~= 'W1') or ((token == 'W1') and (_to_name ~= nil) and (_to_name ~= player_name)))
     then
        if (_msg_type == 'A') and (not _ok2relay) then
            -- # hops exceeded, do nothing and return
        elseif (_ok2relay) then
            oq.forward_msg(_source, sender, _msg_type, msg_id, msg)
        end
    end
end

function oq.post_process()
    oq._sender = nil
    oq._sender_name = nil
    oq._sender_realm = nil
    oq._sender_toonid = nil
    _source = nil
    _ok2relay = 1
    _msg_type = nil
    _msg_id = nil
    _core_msg = nil
    _to_name = nil
    _to_realm = nil
    _inc_channel = nil
    _msg = nil
    _core_msg = nil
    oq._raid_token = nil
    _reason = ''
    oq.__reason = nil
    oq._relay2oqgeneral = nil
    tbl.clear(_vars)
    tbl.clear(_arg)
end

function oq.excited_cheer()
    PlaySoundFile('Sound\\Events\\GuldanCheers.wav')
    PlaySound('LevelUp')
    PlaySoundFile('Sound\\interface\\levelup2.wav')
end

function oq.inspect_check()
    if
        ((OQ_data.ok2autoinspect == 1) and IsControlKeyDown() and UnitIsFriend('player', 'target') and
            CanInspect('target') and
            not InCombatLockdown())
     then
        InspectUnit('target')
    end
end

function oq.on_boss(guid, id, level)
    level = tonumber(level or 0)
    id = tonumber(id)
    if (oq.BossID[id]) and (level > 0) then
        oq._boss_level[id] = level
        oq._boss_guids[id] = guid
    end
end

-- need to track if boss is level appropriate
function oq.save_boss_level()
    local guid = UnitGUID('target')
    local type = guid:sub(5, 5)
    if (OQ._unit_type[type] ~= 'npc') and (OQ._unit_type[type] ~= 'vehicle') then
        return nil
    end
    local id = tonumber(guid:sub(6, 10), 16)
    if (oq.BossID[id]) then
        local level = UnitLevel('target')
        local nu_boss = ((oq._boss_level[id] == nil) or (oq._boss_level[id] ~= level))
        if (nu_boss) then
            oq._boss_level[id] = UnitLevel('target')
            oq._boss_guids[id] = guid
            if (oq._instance_type and ((oq._instance_type == 'party') or (oq._instance_type == 'raid'))) then
                oq.bg_announce('boss,' .. guid .. ',' .. id .. ',' .. tostring(oq._boss_level[id]))
            end
        end
    end
end

function oq.get_boss_level(id)
    id = tonumber(id)
    if (id == OQ.SCENARIO_BOSS_ID) then
        return 90 -- max level
    end
    return oq._boss_level[id] or 0
end

function oq.on_player_target_change()
    local name = GetUnitName('target', true)
    --  if (name == nil) or (oq._inside_instance == nil) then
    --    return ;
    --  end
    if (name == nil) then
        return
    end

    oq.save_boss_level() -- conditional
    oq.inspect_check()

    if (Icebox) then
        local n, r = UnitName('target')
        if (n) and UnitIsPlayer('target') then
            Icebox.armory(n, r or player_realm)
        end
    end
end

function OQ_AutoInspect()
    if (UnitIsFriend('player', 'target') and CanInspect('target') and not InCombatLockdown()) then
        InspectUnit('target')
    end
end

function oq.on_bg_event()
    if (my_group < 1) or (my_slot < 1) then
        return
    end
    local me = oq.raid.group[my_group].member[my_slot]

    for i = 1, 2 do
        if (oq.tab1_bg[i].status == '1') then
            oq.tab1_bg[i].status = '2' -- queue'd
            me.bg[i].start_tm = GetTime()
            return
        end
    end
end

function oq.clear_postclicks()
    PVPReadyDialogEnterBattleButton:SetScript('PostClick', nil)
    PVPReadyDialogLeaveQueueButton:SetScript('PostClick', nil)
end

function oq.queue_popped(ndx)
    if ((my_group == 0) or (my_slot == 0) or (oq.raid.raid_token == nil)) then
        return
    end
    -- hide wow standard dialog buttons
    -- if raid leader, show dialog with choice
    -- leader can choose to 'leave queue', abandoning the pop
    -- or choose to 'enter', which will send a msg to the raid
    -- the message will display the 'enter now' button for raid members

    --  local which = "CONFIRM_BATTLEFIELD_ENTRY" ;
    --  StaticPopup_Hide(which);

    -- would be nice to hide the buttons... but Hide() is nil
    --    local OnCancel = StaticPopupDialogs[which].OnCancel

    if (oq.iam_raid_leader()) then
        -- show raid leader dialog
        PVPReadyDialogEnterBattleButton:SetScript(
            'PostClick',
            function()
                oq._send_immediate = 1
                oq.raid_announce('enter_bg,' .. ndx)
                oq._send_immediate = nil
                oq.timer_oneshot(1, oq.clear_postclicks)
            end
        )
        PVPReadyDialogLeaveQueueButton:SetScript(
            'PostClick',
            function()
                oq.raid_announce('leave_queue,' .. ndx)
                oq.timer_oneshot(1, oq.clear_postclicks)
            end
        )
    elseif (oq.raid.type == OQ.TYPE_BG) then
        -- disable buttons so user can't click by accident
        PVPReadyDialogEnterBattleButton:Show()
        PVPReadyDialogLeaveQueueButton:Show()
        PVPReadyDialogEnterBattleButton:Disable()
        PVPReadyDialogLeaveQueueButton:Disable()

        -- show member dialog
        local dialog = StaticPopup_Show('OQ_QueuePoppedMember', nil, nil, ndx)
        if (dialog) then
            dialog.data = ndx
        end
    end
end

function oq.on_bg_score_update()
    oq.flag_watcher()

    if ((my_group == 0) or (my_slot == 0)) then
        -- not in an OQ group
        if (GetBattlefieldWinner() ~= nil) and (_winner == nil) then
            oq.game_ended()
        end
        return
    end
    if (GetBattlefieldWinner() == nil) then
        oq.game_in_process()
    elseif (_winner == nil) then
        -- there is a winner and we haven't calc'd the stats yet
        oq.game_ended()
    end
end

function oq.on_bg_status_update()
    if ((my_group == 0) or (my_slot == 0) or _inside_bg) then
        return
    end

    local s1 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(1))]
    local s2 = OQ.QUEUE_STATUS[select(1, GetBattlefieldStatus(2))]
    local m = oq.raid.group[my_group].member[my_slot]
    local lead = oq.raid.group[1].member[1]
    local queued = nil
    local changed = (m.bg[1].status ~= s1) or (m.bg[2].status ~= s2)

    if ((s1 ~= '0') or (s2 ~= '0')) then
        queued = 1
    end
    oq.set_status_queued(my_group, my_slot, queued)

    -- determine 'queue time'.  SS.ss
    --
    if ((s1 == '1') or (s1 == '0')) then
        -- reset the clock
        m.bg[1].queue_ts = 0
    end
    if ((s1 == '1') and (m.bg[1].status == '0')) then
        -- from none to queue'd
        m.bg[1].start_tm = GetTime()
        m.bg[1].queue_ts = 0
        m.bg[1].confirm_tm = 0

        -- reset buttons
        if (PVPReadyDialogEnterBattleButton) then
            PVPReadyDialogEnterBattleButton:Show()
            PVPReadyDialogEnterBattleButton:Enable()
            oq.reset_button(PVPReadyDialogEnterBattleButton)
        end
        if (PVPReadyDialogLeaveQueueButton) then
            PVPReadyDialogLeaveQueueButton:Show()
            PVPReadyDialogLeaveQueueButton:Enable()
            oq.reset_button(PVPReadyDialogLeaveQueueButton)
        end
        MiniMapTrackingButton:Click() -- open
        MiniMapTrackingButton:Click() -- close
    end
    if ((s1 == '2') and (m.bg[1].status ~= s1)) then
        -- queue popped
        MiniMapTrackingButton:Click() -- open
        MiniMapTrackingButton:Click() -- close
    end
    if ((s1 == '2') and (m.bg[1].status ~= s1)) then
        -- queue popped
        m.bg[1].confirm_tm = GetTime()
        if (m.bg[1].start_tm == nil) then
            m.bg[1].start_tm = m.bg[1].confirm_tm
        end
        m.bg[1].queue_ts = floor((m.bg[1].confirm_tm - m.bg[1].start_tm) * 1000) -- rounding to milliseconds
        m.bg[1].dt = math.abs(m.bg[1].queue_ts - (lead.bg[1].queue_ts or 0))
        oq.queue_popped(1)
    end

    if ((s2 == '1') or (s2 == '0')) then
        -- reset the clock
        m.bg[2].queue_ts = 0
    end
    if ((s2 == '1') and (m.bg[2].status == '0')) then
        -- from none to queue'd
        m.bg[2].start_tm = GetTime()
    end
    if ((s2 == '2') and (m.bg[2].status ~= s2)) then
        -- queue popped
        m.bg[2].confirm_tm = GetTime()
        if (m.bg[2].start_tm == nil) then
            m.bg[2].start_tm = m.bg[2].confirm_tm
        end
        m.bg[2].queue_ts = floor((m.bg[2].confirm_tm - m.bg[2].start_tm) * 1000) -- rounding to milliseconds
        m.bg[2].dt = math.abs(m.bg[2].queue_ts - lead.bg[2].queue_ts)
        oq.queue_popped(2)
    end

    m.bg[1].status = s1
    m.bg[2].status = s2

    oq.update_tab1_queue_controls()

    -- only insta-trip if not leader, giving the leader a chance to bundle up stats
    if (changed) then
        oq._send_immediate = true
        oq.force_stats()
        oq.check_bg_status()
        oq._send_immediate = nil
    end
    oq.set_textures(my_group, my_slot)
end

function oq.load_oq_data()
    if (OQ_data == nil) then
        OQ_data = tbl.new()
        OQ_data.bn_friends = tbl.new()
        OQ_data.show_premade_ads = 0
        OQ_data.stats = tbl.new()
        OQ_data.stats.nGames = 0
        OQ_data.stats.nWins = 0
        OQ_data.stats.nLosses = 0
        OQ_data.stats.tm = 0 -- time of last update from source.  able to know which data is the latest
    end
end

function oq.load_toon_info()
    local name = strlower(UnitName('player') .. '-' .. oq.GetRealmName())
    OQ_data.toon = OQ_data.toon or tbl.new()
    if (OQ_data.toon[name] == nil) then
        OQ_data.toon[name] = tbl.new()
        oq.toon_init(OQ_data.toon[name])
    end
    oq.toon = OQ_data.toon[name]
end

function oq.on_addon_load_init()
    if (oq.loaded) then
        return
    end

    oq.load_oq_data()
    oq.load_toon_info()
    oq.init_locals()
    oq.ui.closepb = oq.ui.closepb or oq.closebox(oq.ui)
    oq.ui.closepb:SetScript(
        'OnHide',
        function()
            oq.onHide()
        end
    )
    oq.init_if_good_region()
end

function oq.on_addon_loaded(name)
    if (name == 'oqueue' or name == 'oQueue') then
        local retOK, rc =
            pcall(
            function()
                oq.on_addon_load_init()
            end
        )
        if (retOK ~= true) then
            print(OQ.LILREDX_ICON)
            print(OQ.LILREDX_ICON .. L['  OQ error initializing'])
            print(OQ.LILREDX_ICON .. L['  realmList: '] .. tostring(GetCVar('realmList')))
            print(OQ.LILREDX_ICON .. L['  error: '] .. tostring(rc))
            print(OQ.LILREDX_ICON)
        end
    end
end

function oq.good_region_info()
    local realmlist_region = string.sub(GetCVar('realmList'), 1, 2)
    if (realmlist_region == 'us' or realmlist_region == 'eu' or realmlist_region == 'hu') then
        return true
    end
    return nil
end

function oq.init_if_good_region()
    oq.loaded = true
    if (oq.good_region_info()) and (oq.get_raid_progression ~= nil) then
        oq.on_init()
    elseif (not oq.good_region_info()) then
        -- no region info.
        print(OQ.LILREDX_ICON)
        print(OQ.LILREDX_ICON .. ' Error : oQueue disabled')
        print(OQ.LILREDX_ICON .. ' Reason: Invalid realmlist information (' .. GetCVar('realmList') .. ')')
        print(OQ.LILREDX_ICON .. ' Reason: This usually happens due to private server use.')
        print(OQ.LILREDX_ICON .. ' Action: Please exit wow, delete your config.wtf, and restart your wow')
        print(OQ.LILREDX_ICON)
    else
        print(OQ.LILREDX_ICON)
        print(OQ.LILREDX_ICON .. ' Error : oQueue did not load all modules properly.')
        print(OQ.LILREDX_ICON .. ' Reason: If you recently updated, a full restart of your wow may be required')
        print(OQ.LILREDX_ICON .. ' Action: If a restart does not resolve it, try re-installing oQueue')
        print(OQ.LILREDX_ICON .. " Action: If you're still having problems, find tiny in public vent")
        print(OQ.LILREDX_ICON .. ' Action: wow.publicvent.org : 4135')
    end
end

function oq.on_player_enter_world()
    if (oq._oqgeneral_initialized) then
        return
    end
    oq.timer('join_OQGeneral', 5, oq.initial_join_oqgeneral, true)
end

function oq.fmt_time(tm)
    local nmin, nsec
    if (tm == nil) then
        return '0:00'
    end
    nmin = floor(tm / 60)
    nsec = floor(tm % 60)
    return string.format('%d:%02d', nmin, nsec)
end

--------------------------------------------------------------------------
-- initialization functions & event handlers
--------------------------------------------------------------------------
function oq.on_event(_, event, ...)
    if (oq.msg_handler[event] ~= nil) then
        oq._event = event
        oq.msg_handler[event](...)
    end
end

function oq.get_seat(name)
    if (name:find('-')) then
        name = name:sub(1, (name:find('-') or 0) - 1)
    end

    for gid = 1, 8 do
        for slot = 1, 5 do
            if (oq.raid.group[gid].member[slot].name == name) then
                return gid, slot
            end
        end
    end
    return 0, 0
end

function oq.first_open_seat(gid)
    for j = 1, 5 do
        if ((oq.raid.group[gid].member[j].name == nil) or (oq.raid.group[gid].member[j].name == '-')) then
            return gid, j
        end
    end
    return gid, 0
end

function oq.find_member(table, name)
    if (name == nil) or (name == '-') then
        return nil
    end

    for i = 1, 8 do
        for j = 1, 5 do
            if (table[i].member[j].name ~= nil) and (table[i].member[j].name == name) then
                return table[i].member[j]
            end
        end
    end
    return nil
end

function oq.find_members_seat(table, name)
    if (name == nil) or (name == '-') then
        return nil
    end
    name = strlower(name)

    for i = 1, 8 do
        for j = 1, 5 do
            local n = strlower(table[i].member[j].name or '')
            if (n == name) then
                return i, j
            end
        end
    end
    return nil, nil
end

function oq.find_my_group_id()
    local instance, instanceType = IsInInstance()
    if (instance) then
        return my_group, my_slot -- don't change while in an instance
    end
    if (oq.raid.raid_token == nil) then
        return 0, 0
    end

    local n = GetNumGroupMembers()
    if (n == 0) then
        if (not oq.iam_raid_leader()) then
            -- clean up left over group
            oq.raid_cleanup()
            oq.raid_init()
        end
        return 1, 1
    end
    local slot, group
    slot = 0
    group = 0
    for i = 1, n do
        local name_, _, subgroup = GetRaidRosterInfo(i)
        local name, realm = oq.crack_name(name_)
        if (subgroup ~= group) then
            group = subgroup
            slot = 0
        end
        slot = slot + 1
        if (name == player_name) then
            return subgroup, slot
        end
    end
    return 0, 0
end

function oq.on_party_members_changed()
    oq.closeInvitePopup()
    local instance, instanceType = IsInInstance()
    if (instance and (instanceType == 'pvp')) then
        return
    end

    oq.clear_empty_seats()
    oq.timer('announce_leader', 4, oq.announce_raid_leader)

    local groupMembers = GetNumGroupMembers()
    if (oq.iam_raid_leader()) then
        if (my_group > 0) then
            oq.raid.group[my_group]._stats = nil
            oq.raid.group[my_group]._names = nil
        end
        if
            (oq.raid.raid_token ~= nil and groupMembers > 0 and select(1, GetLootMethod()) ~= 'freeforall' and
                instance == nil and
                oq.raid.type ~= OQ.TYPE_DUNGEON and
                oq.raid.type ~= OQ.TYPE_CHALLENGE and
                oq.raid.type ~= OQ.TYPE_QUESTS and
                oq.raid.type ~= OQ.TYPE_MISC and
                oq.raid.type ~= OQ.TYPE_ROLEPLAY and
                oq.raid.type ~= OQ.TYPE_RAID)
         then
            SetLootMethod('freeforall')
        elseif ((oq.raid.raid_token ~= nil) and (oq.raid.type == OQ.TYPE_MISC)) then
            SetLootMethod('group')
        end
        if (groupMembers == 2 and oq.iam_raid_leader()) then
            -- make sure it's a raid if required
            if
                (oq.raid.type == OQ.TYPE_BG) or (oq.raid.type == OQ.TYPE_RBG) or (oq.raid.type == OQ.TYPE_RAID) or
                    (oq.raid.type == OQ.TYPE_MISC) or
                    (oq.raid.type == OQ.TYPE_ROLEPLAY)
             then
                ConvertToRaid()
            else
                ConvertToParty()
            end
        end
    elseif (groupMembers > 0 and not oq.iam_raid_leader()) then
        my_group, my_slot = oq.find_my_group_id()
    elseif (groupMembers == 0 and not oq.iam_raid_leader()) then
        -- was a party member and manually left party... need to clean up
        oq.raid_cleanup()
        oq.raid_init()
    end
end

function oq.on_party_member_disable(member)
    if (member:find('raid') == nil) then
        return
    end
    local name = UnitName(member)
    local g, s = oq.find_members_seat(oq.raid.group, name)
    if (g == nil) or (s == nil) then
        return
    end
    oq.set_member_stats_offline(oq.raid.group[g].member[s])
    oq.set_status_online(g, s, UnitIsConnected(member))
    oq.set_textures(g, s)
end

-- hook the world map show function so we can know if the UI was forced closed by the map
function oq.WorldMap_show(...)
    local now = GetTime()
    if (oq.ui.old_show) then
        oq.ui.old_show(...)
    end
    if (now == oq.ui.hide_tm) then
        _ui_open = true
    end
end

function oq.on_channel_roster_update(id)
    if (_oqgeneral_id ~= nil) and (_oqgeneral_id == id) then
        oq.n_connections()
    end
end

function oq.toggle_autoinspect(cb)
    if (cb:GetChecked()) then
        OQ_data.ok2autoinspect = 1
    else
        OQ_data.ok2autoinspect = 0
    end
end

function oq.toggle_premade_ads(cb)
    if (cb:GetChecked()) then
        OQ_data.show_premade_ads = 1
        _announcePremades = true
    else
        OQ_data.show_premade_ads = 0
        _announcePremades = nil
    end
end

function oq.toggle_premade_qualified(cb)
    if (cb:GetChecked()) then
        OQ_data.premade_filter_qualified = 1
    else
        OQ_data.premade_filter_qualified = 0
    end
    oq.reshuffle_premades_now()
end

function oq.toggle_enforce_levels(cb)
    if (cb:GetChecked()) then
        oq.raid.enforce_levels = 1
    else
        oq.raid.enforce_levels = 0
    end
end

function oq.toggle_auto_role(cb)
    if (cb:GetChecked()) then
        oq.toon.auto_role = 1
    else
        oq.toon.auto_role = 0
    end
end

oq._blacklist = {[ERR_BN_FRIEND_REQUEST_SENT] = true}

function oq.uierrors_addmessage(frame, text, red, green, blue, id)
    if (text) and (oq._blacklist[text]) and (OQ_data.autohide_friendreqs == 1) then
        return
    end
    oq.old_uierrors_addmessage(frame, text, red, green, blue, id)
end

function oq.hook_error_frame()
    oq.old_uierrors_addmessage = UIErrorsFrame.AddMessage
    UIErrorsFrame.AddMessage = oq.uierrors_addmessage

    if (OQ_data.autohide_friendreqs == 1) then
        SetCVar('showToastFriendRequest', 0)
    end
end

function oq.toggle_autohide_friendreqs(cb)
    if (cb:GetChecked()) then
        OQ_data.autohide_friendreqs = 1
        SetCVar('showToastFriendRequest', 0)
    else
        OQ_data.autohide_friendreqs = 0
    end
end

function oq.toggle_loot_acceptance(cb)
    if (cb:GetChecked()) then
        OQ_data.loot_acceptance = 1
    else
        OQ_data.loot_acceptance = 0
    end
end

---------------------------------
-- General (local) functions --
---------------------------------

function oq.get_group_level_range()
    local highest = UnitLevel('player')
    local lowest = UnitLevel('player')
    local nMembers = GetNumGroupMembers()

    for i = 1, nMembers - 1 do
        if (IsInRaid()) then
            highest = max(highest, UnitLevel('raid' .. i))
            lowest = min(lowest, UnitLevel('raid' .. i))
        else
            highest = max(highest, UnitLevel('party' .. i))
            lowest = min(lowest, UnitLevel('party' .. i))
        end
    end
    return lowest, highest
end

-- TODO? Make sure the raid is current tier. Maybe this can be updated once a patch hits. Not a huge deal.
--
function oq.is_current_tier(name)
    return (name == L['Siege of Orgrimmar']) or (name == L['Throne of Thunder']) or (name == L["Mogu'shan Vaults"]) or
        (name == L['Heart of Fear']) or
        (name == L['Terrace of Endless Spring'])
end

function oq.on_encounter_end(encounterID, _, difficultyID, _, endStatus)
    --print("encounter end: ".. tostring(encounterID) .."  ".. encounterName .."  diff: ".. tostring(difficultyID) .."  sz: ".. tostring(raidSize) .."  end: ".. tostring(endStatus));
    -- UnitGUID doesn't work for bosses like spoils. I recommend sending the encounterID. If you do, take this GUID stuff out.
    local guid = UnitGUID('boss1')
    local name = GetInstanceInfo()

    -- endStatus is 1 for kills, 0 for wipe/boss resets.
    if ((endStatus == 1) and oq.is_current_tier(name)) then
        --print('boss kill detected: ', difficultyID, encounterName, 'arg8: ', guid, 'arg9: ', id) --debugging stuff
        -- good kill, report
        if (oq._instance_header == nil) then
            local mapid = GetCurrentMapAreaID()
            oq._instance_header = oq.encode_mime64_2digit(mapid) .. '' .. oq.encode_mime64_6digit(oq._instance_tm)
        end
        local pts = 0
        if (OQ._difficulty[difficultyID]) then
            pts = OQ._difficulty[difficultyID].n
        end

        -- now record for keeper
        -- note: some instances can change their difficulty after the start.
        --       keep difficulty with boss kill info
        oq._instance_pts = (oq._instance_pts or 0) + pts
        oq._2nd_to_last_boss_kill = oq._last_boss_kill -- 2nd to last boss
        oq._last_boss_kill = encounterID -- Changed from id to encounterID?
        if (pts > 0) then
            print(OQ.LILSKULL_ICON)
            print(
                OQ.LILSKULL_ICON ..
                    ' boss killed (pts: ' .. pts .. '  total: ' .. tostring(oq._instance_pts or 0) .. ')'
            )
            print(OQ.LILSKULL_ICON)
        end

        if (pts == 0) or (not oq.iam_raid_leader()) or (oq.iam_alone()) then
            return pts
        end

        local leader_stats = OQ_data.leader['pve.5man']
        if (IsInRaid()) then
            leader_stats = OQ_data.leader['pve.raid']
        elseif (OQ._difficulty[difficultyID].desc == 'challenge mode') then
            leader_stats = OQ_data.leader['pve.challenge']
        elseif
            (OQ._difficulty[difficultyID].desc == 'scenario') or
                (OQ._difficulty[difficultyID].desc == 'scenario (heroic)')
         then
            leader_stats = OQ_data.leader['pve.scenario']
        end
        leader_stats.nBosses = leader_stats.nBosses + 1
        leader_stats.pts = leader_stats.pts + pts
        --print('+ leader pts: ', pts)

        local submit_token = 'S' .. oq.token_gen()
        oq.token_push(submit_token)

        -- TODO: make sure to get the receipt for the transaction
        --
        local lowest, highest = oq.get_group_level_range()
        return pts
    end
    return 0
end

function oq.attr(attr, s)
    return '|cFF' .. attr .. '' .. tostring(s) .. '|r'
end

function oq.on_group_roster_update()
end

function oq.register_base_events()
    oq.msg_handler = tbl.new()
    oq.msg_handler['ADDON_LOADED'] = oq.on_addon_loaded
    oq.ui:RegisterEvent('ADDON_LOADED')
    oq.ui:SetScript('OnEvent', oq.on_event)
end

function oq.register_events()
    oq.msg_handler['ACTIVE_TALENT_GROUP_CHANGED'] = oq.get_player_role
    oq.msg_handler['CHAT_MSG_ADDON'] = oq.on_addon_event
    oq.msg_handler['CHAT_MSG_CHANNEL'] = oq.on_channel_msg
    oq.msg_handler['CHAT_MSG_WHISPER'] = oq.on_received_whisper
    oq.msg_handler['ENCOUNTER_END'] = oq.on_encounter_end
    oq.msg_handler['INSPECT_READY'] = oq.on_inspect_ready
    oq.msg_handler['PARTY_INVITE_REQUEST'] = oq.on_party_invite_request
    oq.msg_handler['PARTY_LOOT_METHOD_CHANGED'] = oq.verify_loot_rules_acceptance
    oq.msg_handler['PARTY_MEMBER_DISABLE'] = oq.on_party_member_disable
    oq.msg_handler['GROUP_ROSTER_UPDATE'] = oq.on_party_members_changed
    --  oq.msg_handler[ "PARTY_MEMBERS_CHANGED"         ] = oq.on_party_members_changed ;
    --  oq.msg_handler[ "PLAYER_ENTERING_BATTLEGROUND"  ] = oq.bg_start ;
    oq.msg_handler['PLAYER_FLAGS_CHANGED'] = oq.player_flags_changed
    oq.msg_handler['PLAYER_LEVEL_UP'] = oq.player_new_level
    oq.msg_handler['PLAYER_LOGOUT'] = oq.on_logout
    oq.msg_handler['PLAYER_ENTERING_WORLD'] = oq.on_player_enter_world
    oq.msg_handler['PLAYER_TARGET_CHANGED'] = oq.on_player_target_change
    oq.msg_handler['PVP_RATED_STATS_UPDATE'] = oq.on_player_mmr_change

    oq.msg_handler['PVPQUEUE_ANYWHERE_SHOW'] = oq.on_bg_event
    oq.msg_handler['ROLE_CHANGED_INFORM'] = oq.check_my_role
    -- too many messages for what i need.  changed to a check every 3-5 seconds via check_stats
    --  oq.msg_handler[ "UNIT_AURA"                     ] = oq.check_for_deserter ;
    oq.msg_handler['UPDATE_BATTLEFIELD_SCORE'] = oq.on_bg_score_update
    oq.msg_handler['UPDATE_BATTLEFIELD_STATUS'] = oq.on_bg_status_update
    --  oq.msg_handler[ "UPDATE_INSTANCE_INFO"          ] = oq.on_update_instance_info ;
    oq.msg_handler['WORLD_MAP_UPDATE'] = oq.on_world_map_change
    oq.msg_handler['CHANNEL_ROSTER_UPDATE'] = oq.on_channel_roster_update

    oq.ui:SetScript(
        'OnShow',
        function()
            oq.onShow()
        end
    )

    -- hook the world map show method so we can bring the OQ UI back up if it was forced-hidden
    hooksecurefunc(
        WorldMapFrame,
        'Show',
        function()
            oq.WorldMap_show()
        end
    )

    ------------------------------------------------------------------------
    --  register for events
    ------------------------------------------------------------------------
    oq.ui:RegisterEvent('PVPQUEUE_ANYWHERE_SHOW')
    oq.ui:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
    oq.ui:RegisterEvent('CHANNEL_ROSTER_UPDATE')
    oq.ui:RegisterEvent('CHAT_MSG_ADDON')
    oq.ui:RegisterEvent('CHAT_MSG_CHANNEL')
    oq.ui:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL')
    oq.ui:RegisterEvent('CHAT_MSG_WHISPER')
    oq.ui:RegisterEvent('CLOSE_WORLD_MAP')
    oq.ui:RegisterEvent('ENCOUNTER_END')
    oq.ui:RegisterEvent('ENCOUNTER_START')
    oq.ui:RegisterEvent('INSPECT_READY')
    oq.ui:RegisterEvent('PARTY_INVITE_REQUEST')
    oq.ui:RegisterEvent('PARTY_LOOT_METHOD_CHANGED')
    oq.ui:RegisterEvent('PARTY_MEMBER_DISABLE')
    oq.ui:RegisterEvent('GROUP_ROSTER_UPDATE')
    oq.ui:RegisterEvent('PLAYER_DEAD')
    oq.ui:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
    oq.ui:RegisterEvent('PLAYER_ENTERING_BATTLEGROUND')
    oq.ui:RegisterEvent('PLAYER_ENTERING_WORLD')
    oq.ui:RegisterEvent('PLAYER_FLAGS_CHANGED')
    oq.ui:RegisterEvent('PLAYER_LEVEL_UP')
    oq.ui:RegisterEvent('PLAYER_LOGOUT')
    oq.ui:RegisterEvent('PLAYER_TARGET_CHANGED')
    oq.ui:RegisterEvent('PVP_RATED_STATS_UPDATE')
    oq.ui:RegisterEvent('ROLE_CHANGED_INFORM')
    oq.ui:RegisterEvent('SOCKET_INFO_UPDATE')
    oq.ui:RegisterEvent('UNIT_AURA')
    oq.ui:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
    oq.ui:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
    oq.ui:RegisterEvent('WORLD_MAP_UPDATE')
    if (RegisterAddonMessagePrefix(OQ_HEADER) ~= true) then
        print('Error:  unable to register addon prefix: ' .. OQ_HEADER)
    end
end

function oq.init_bnet_friends()
    if (OQ_data.bn_friends) then
        tbl.clear(OQ_data.bn_friends, true)
    else
        OQ_data.bn_friends = tbl.new()
    end
end

function oq.pass_bg_leader()
    if (not _inside_bg) then
        return
    end
    if (oq.raid.raid_token == nil) then
        return
    end
    if (not oq.IsRaidLeader()) then
        return
    end
    if (oq.iam_raid_leader()) then
        return
    end

    -- i'm in a BG, have BG leader, and should pass to OQ leader
    --
    local n = oq.raid.leader
    if (oq.raid.leader_realm ~= player_realm) then
        n = n .. '-' .. oq.raid.leader_realm
    end
    if (not UnitInRaid(n)) then
        return
    end
    if (UnitExists(n)) then
        print('OQ: transferred BG leader to ' .. n)
        PromoteToLeader(n)
    end
end

function oq.player_flags_changed(unitId)
    if (unitId ~= 'player' or not OQ._track_afk) then
        return
    end

    if (UnitIsAFK('player') and oq._isAfk == nil) then
        oq._isAfk = true
        oq.oqgeneral_leave()
        oq.oq_off()
    elseif (oq._isAfk) then
        oq._isAfk = nil
        oq.oqgeneral_join()
        oq.oq_on()
    end
end

function oq.player_new_level()
    player_level = UnitLevel('player')
    if (my_group ~= 0) and (my_slot ~= 0) then
        oq.raid.group[my_group].member[my_slot].level = player_level
    end

    local minlevel, maxlevel = oq.get_player_level_range()
    local txt = tostring(minlevel) .. ' - ' .. tostring(maxlevel)
    if (minlevel == 0) then
        txt = 'UNK'
    elseif (minlevel == OQ.TOP_LEVEL) then
        txt = tostring(OQ.TOP_LEVEL)
    end
    oq.tab3_level_range = txt
end

function oq.init_locals()
    if (oq._tok_cnt) then
        return -- only initialize once
    end
    tbl.init()

    _toon = _toon or tbl.new()
    _arg = _arg or tbl.new()
    _vars = _vars or tbl.new()
    _names = _names or tbl.new()
    _items = _items or tbl.new()

    oq.channels = oq.channels or tbl.new()
    oq.premades = oq.premades or tbl.new()
    oq.raid = oq.raid or tbl.new()
    oq.waitlist = oq.waitlist or tbl.new()
    oq.pending = oq.pending or tbl.new()
    oq_ascii = oq_ascii or tbl.new()
    oq_mime64 = oq_mime64 or tbl.new()
    oq._tok_cnt = 0
    oq.random = fastrandom -- or random ;
    oq.nwaitlist = 0
    oq.send_q = oq.send_q or tbl.new()
    oq.premades = oq.premades or tbl.new()
    oq._error_ignore_tm = 0
    oq._next_gc = 0
    oq._boss_level = oq._boss_level or tbl.new()
    oq._boss_guids = oq._boss_guids or tbl.new()
    oq.toon.player_wallet = oq.toon.player_wallet or tbl.new()
    OQ_data._history = OQ_data._history or tbl.new()
    oq.__frame_pool = oq.__frame_pool or tbl.new()
    oq.__frame_pool['#check'] = oq.__frame_pool['#check'] or tbl.new()

    oq._hyperlinks = oq._hyperlinks or tbl.new()
    oq._hyperlinks['btag'] = oq.onHyperlink_btag
    oq._hyperlinks['log'] = oq.onHyperlink_log
    oq._hyperlinks['oqueue'] = oq.onHyperlink_oqueue

    oq.register_events()
end

function oq.firstToUpper(str)
    if (str == nil) then
        return str
    end
    return (str:gsub('^%l', string.upper))
end

function oq.GetRealmName()
    local name = GetRealmName()
    if (OQ.REALMS[name] ~= nil) then
        return OQ.REALMS[name]
    end

    name = strlower(name)
    if (OQ.REALMS[name] ~= nil) then
        return OQ.REALMS[name]
    end

    return nil
end

function oq.btag_hyperlink_action(realId, action)
    if (realId == nil) or (realId == '') or (realId == 'nil') then
        return
    end
    if (action == 'ban') then
        oq.ban_user(realId)
    elseif (action == 'friend') then
        local isFriend = oq.IsFriend(realId)
        if (isFriend) then
            print(OQ.LILTRIANGLE_ICON .. ' ' .. string.format(OQ.ALREADY_FRIENDED, realId))
        else
            AddFriend(realId)
        end
    end
end

OQ.btag_hyperlink = {
    {text = OQ.DD_BAN, action = 'ban'},
    {text = OQ.TT_FRIEND_REQUEST, action = 'friend'}
}

function oq.onHyperlink_btag(link)
    local n1 = link:find(':') or 0
    local n2 = link:find(':', n1 + 1) or -1
    local token = link:sub(n1 + 1, n2 - 1)
    local tm = tonumber(link:sub(n2 + 1, -1)) or 0
    local now = oq.utc_time()

    if (token == nil) or (token == 'nil') or (token:find('#') == nil) then
        return
    end
    if (token == oq.player_realid) then
        -- can't click yourself
        return
    end
    if ((now - tm) > 2 * 60 * 60) then
        -- battletag hyperlinks are only good for 2 hours
        return
    end
    -- popup menu on the battle-tag
    oq.menu_create():Raise()

    for _, v in pairs(OQ.btag_hyperlink) do
        oq.menu_add(
            v.text,
            token,
            v.action,
            nil,
            function(_, btag, action)
                oq.btag_hyperlink_action(btag, action)
            end
        )
    end
    oq.menu_show_at_cursor(150, -20, 0)
end

function oq.onHyperlink_log(link)
    local n = link:find(':') or 0
    local token = link:sub(n + 1, -1)
    if (token == nil) then
        return
    end
    -- print("log hyperlink: [".. tostring(token) .."] L[".. tostring(link) .."]");
end

OQ.premade_hyperlink = {
    {text = OQ.WAITLIST, action = 'waitlist'},
    {text = '---', action = ''},
    {text = OQ.DD_BAN, action = 'ban'}
}
function oq.onHyperlink_oqueue(link)
    local token = link:sub(link:find(':') + 1, -1)
    if (token == nil) then
        return
    end
    -- popup menu on the battle-tag
    oq.menu_create():Raise()

    for _, v in pairs(OQ.premade_hyperlink) do
        oq.menu_add(
            v.text,
            token,
            v.action,
            nil,
            function(_, token, action)
                if (action == 'waitlist') then
                    oq.check_and_send_request(token)
                elseif (action == 'ban') then
                    local premade = oq.premades[token]
                    -- troll may have disbanded, check if its on the 'old' list
                    if (premade == nil) and (oq.old_raids) and (oq.old_raids[token]) then
                        premade = tbl.new()
                        premade.leader_rid = oq.old_raids[token]
                    end
                    if (premade ~= nil) then
                        local dialog = StaticPopup_Show('OQ_BanUser', premade.leader_rid)
                        if (dialog ~= nil) then
                            dialog.data2 = {flag = 4, btag = premade.leader_rid, raid_tok = token}
                        end
                    end
                end
            end
        )
    end
    oq.menu_show_at_cursor(150, -20, 0)
end

--
--  this works:
--  /run oldf=ChatFrame1:GetScript("OnHyperLinkClick") ChatFrame1:SetScript("OnHyperLinkClick", function(...) print("."); oldf(...) end);
--
local _old_sethyperlink_handler = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink(link)
    if (oq._hyperlinks[link:sub(1, (link:find(':') or 0) - 1)]) then
        oq._hyperlinks[link:sub(1, (link:find(':') or 0) - 1)](link)
    elseif (_old_sethyperlink_handler) then
        _old_sethyperlink_handler(self, link)
    end
end

function oq.get_player_faction()
    if (oq._player_faction) then
        return oq._player_faction
    end
    oq.player_faction = 'H'
    if (strlower(select(1, UnitFactionGroup('player'))) == 'alliance') then
        oq.player_faction = 'A'
    end
    oq._player_faction = oq.player_faction
    return oq.player_faction
end

function oq.on_inspect_ready()
    if (oq._snitch) and (oq._snitch.status == 1) then
        oq.snitch_check()
        return
    end
end

local function printable(ilink)
    return gsub(ilink, '\124', '\124\124')
end

local S_ITEM_LEVEL = ITEM_LEVEL:gsub('%%d', '(%%d+)')
function oq.get_actual_ilevel(itemLink)
    -- Pass the item link to the tooltip:
    local scantip = GameTooltip
    scantip:SetOwner(UIParent, 'ANCHOR_NONE')
    scantip:SetHyperlink(itemLink)
    scantip:Show()

    -- Scan the tooltip:
    local ilevel = 0
    local enchant_text = ''

    for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
        local text = _G[scantip:GetName() .. 'TextLeft' .. i]:GetText()
        if text and text ~= '' then
            local n = tonumber(text:match(S_ITEM_LEVEL))
            if n then
                ilevel = n
            elseif (text:find(OQ.ENCHANTED)) then
                enchant_text = text
            end
        end
    end
    scantip:Hide()
    return ilevel, enchant_text
end

function oq.the_check()
    if (oq.player_realid == nil) then
        return
    end

    if (oq.is_banned(oq.player_realid)) then
        oq._banned = 1
        oq.process_msg = function()
        end
        oq.remove_all_premades()
        oq.oqgeneral_leave()
    end
    return 1
end

function oq.blizz_workarounds()
    --
    -- 5.4.1:  taint popup due to IsDisabledByParentalControls
    -- http://us.battle.net/wow/en/forum/topic/10388639018
    --
    UIParent:HookScript(
        'OnEvent',
        function(_, e, a1, a2)
            if e:find('ACTION_FORBIDDEN') and ((a1 or '') .. (a2 or '')):find('IsDisabledByParentalControls') then
                StaticPopup_Hide(e)
            end
        end
    )
end

function oq.on_init()
    if (oq._initialized) then
        return
    end
    if (oq.ui == nil) then
        print(L['OQ ui not initalized properly'])
    end

    oq.init_bnet_friends()
    oq.hook_options()
    oq.init_table()
    oq.procs_init()
    oq.load_toon_info()
    oq.raid_init()
    oq.init_stats_data()
    oq.procs_no_raid()
    oq.token_list_init()
    oq.blizz_workarounds()
    oq.my_tok = 'C' .. oq.token_gen()
    oq.make_frame_moveable(oq.ui)
    oq.BossID = LibStub('LibBossIDs-1.0').BossIDs

    player_name = UnitName('player')
    player_realm = oq.GetRealmName()
    player_realm_id = oq.GetRealmID(player_realm)
    oq.player_realid = strlower(player_name .. '-' .. player_realm)
    player_class = OQ.SHORT_CLASS[select(2, UnitClass('player'))]
    player_level = UnitLevel('player')
    player_ilevel = oq.get_ilevel()
    player_resil = oq.get_resil()
    oq.player_faction = oq.get_player_faction()
    player_karma = 0
    player_role = oq.get_player_role()

    if (oq.toon) and (oq.toon.raid) and (oq.toon.raid.type) then
        oq.raid.type = oq.toon.raid.type
    end
    oq.create_main_ui()
    oq.ui:SetFrameStrata('MEDIUM')

    ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', oq.chat_filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', oq.chat_filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', oq.chat_filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', oq.chat_filter)

    -- first time check
    oq.timer_oneshot(2, oq.hook_error_frame)
    oq.timer_oneshot(2, oq.hook_ui_resize)
    oq.timer_oneshot(2.5, oq.recover_premades)
    oq.timer_oneshot(2.7, oq.init_complete)
    oq.timer_oneshot(3, oq.cache_mmr_stats)
    oq.timer_oneshot(4, oq.advertise_my_raid)
    oq.timer_oneshot(5, oq.delayed_button_load)

    if (InspectFrame == nil) then
        LoadAddOn('Blizzard_InspectUI') -- make sure its loaded
    end

    -- define timers
    oq.timer('chk4dead_premade', 30, oq.remove_dead_premades, true)
    oq.timer('report_premades', 20, oq.report_premades, nil)
    oq.timer('advertise_premade', 15, oq.advertise_my_raid, true)
    oq.timer('update_nfriends', 15, oq.n_connections, true)
    oq.timer('auto_role_check', 15, oq.auto_set_role, true)
    oq.timer('trim_old_premades', 10, oq.trim_old_premades, true)
    oq.timer('the_check', 5, oq.the_check, true)
    oq.timer('reset_buttons', 5, oq.normalize_static_button_height, true)
    oq.timer('check_stats', 5, oq.check_stats, true) -- check party and personal stats every 5 seconds; only send if changed
    oq.timer('calc_pkt_stats', 0.5, oq.calc_pkt_stats, true)
    oq.timer('chk_bg_status', 3, oq.check_bg_status, true)
    oq.timer('waitlist update', 1, oq.update_wait_times, true)
    oq.timer('bn_send_q', 0.250, oq.send_queued_msgs, true) -- 4 times per second, throttles bn msgs

    oq.clear_old_tokens()
    oq.create_tooltips()
    oq.attempt_group_recovery()

    oq.log(
        nil,
        '|cFF808080logged on|r ' ..
            player_name ..
                '-' ..
                    player_realm ..
                        ' ' ..
                            '|cFF808080v' ..
                                OQUEUE_VERSION ..
                                    '' .. tostring(OQ_SPECIAL_TAG or '') .. ' (' .. tostring(OQ.REGION) .. ')|r'
    )

    OQ_MinimapButton_Reposition()
    if (oq.toon.mini_hide) then
        OQ_MinimapButton:Hide()
    else
        OQ_MinimapButton:Show()
    end

    oq.toon.my_toons = oq.toon.my_toons or tbl.new()

    oq._initialized = true
end

function oq.init_complete()
    oq._init_completed = true
    oq.show_version()
    oq.verify_loot_rules_acceptance()
end

function oq.cache_mmr_stats()
    -- initialize person bg ratings
    -- this will, hopefully, force the bg-rating info to come from the server (must be a better way)
    if (PVPUIFrame == nil) then
        LoadAddOn('Blizzard_PVPUI') -- make sure its loaded
    end

    if ((player_level >= 10) and PVPUIFrame) then
        PVPUIFrame:Show()
        PVPQueueFrameCategoryButton2:Click()
        PVPQueueFrameCategoryButton1:Click()
        PVPUIFrame:Hide()
    end
    oq.n_connections()
end

function oq.on_logout()
    -- leave channels
    oq.channel_leave(OQ_REALM_CHANNEL)

    oq.log(nil, 'logging out')
    -- hang onto group data if still in an OQ_group (may come back)
    local disabled = oq.toon.disabled

    OQ_data.show_premade_ads = OQ_data.show_premade_ads or 0

    oq.toon.my_group = my_group
    oq.toon.my_slot = my_slot
    if (my_group ~= 0) then
        oq.toon.last_tm = oq.utc_time()
    else
        oq.toon.last_tm = 0
    end
    oq.toon.player_role = player_role
    oq.toon.disabled = disabled
    oq.toon.raid = tbl.new()
    oq.toon.waitlist = tbl.new()

    if (oq.raid.raid_token) then
        tbl.copy(oq.raid, oq.toon.raid, true)
        tbl.copy(oq.waitlist, oq.toon.waitlist, true)
    end

    oq.toon._idata = {
        inst = oq._inside_instance,
        type = oq._instance_type,
        pts = oq._instance_pts,
        hdr = oq._instance_header,
        tm = oq._instance_tm,
        alone = oq._entered_alone
    }

    OQ_data.setup = nil -- old data; making sure it's cleaned out
    OQ_data.bn_friends = nil -- clean it out so we re-check upon login
end

function oq.attempt_group_recovery()
    local now = oq.utc_time()

    OQ_data._premade_type = OQ.TYPE_NONE

    if (oq.toon) then
        oq.toon.class_portrait = oq.toon.class_portrait or 1
        OQ_data.ok2autoinspect = OQ_data.ok2autoinspect or 1

        -- more then 60 seconds passed, recovery not an option
        my_group = oq.toon.my_group or 0
        my_slot = oq.toon.my_slot or 0
        if (my_group > 0) and ((now - oq.toon.last_tm) <= OQ_GROUP_RECOVERY_TM) then
            if (oq.toon.raid) and (oq.toon.raid.raid_token) then
                tbl.copy(oq.toon.raid, oq.raid, true)

                -- make sure all the sub tables are there
                oq.raid.group = oq.raid.group or tbl.new()
                for i = 1, 8, 1 do
                    oq.raid.group[i] = oq.raid.group[i] or tbl.new()
                    oq.raid.group[i].member = oq.raid.group[i].member or tbl.new()
                    for j = 1, 5, 1 do
                        oq.raid.group[i].member[j] = oq.raid.group[i].member[j] or tbl.new()
                        oq.raid.group[i].member[j].flags = oq.raid.group[i].member[j].flags or 0
                        oq.raid.group[i].member[j].bg = oq.raid.group[i].member[j].bg or tbl.new()
                        oq.raid.group[i].member[j].bg[1] = oq.raid.group[i].member[j].bg[1] or tbl.new()
                        oq.raid.group[i].member[j].bg[2] = oq.raid.group[i].member[j].bg[2] or tbl.new()
                    end
                end
            end
            oq.update_tab3_info()
        else
            oq.raid_init()
        end

        -- update UI elements
        if (oq.raid.raid_token) then
            if (oq.iam_raid_leader()) then
                oq.ui_raidleader()
                oq.set_group_lead(1, player_name, player_realm, player_class, oq.player_realid)
                oq.raid.group[1].member[1].resil = player_resil
                oq.raid.group[1].member[1].ilevel = player_ilevel
                oq.check_for_deserter()
                oq.tab3._create_but:SetText(OQ.UPDATE_BUTTON)
                oq.premade_type_selection(oq.raid.type)
                oq.set_preferences(oq.raid._preferences)

                tbl.copy(oq.toon.waitlist, oq.waitlist, true)

                oq.populate_waitlist()
            else
                oq.ui_player()
            end
            for i = 1, 8 do
                local grp = oq.raid.group[i]
                for j = 1, 5 do
                    local m = grp.member[j]
                    if (j == 1) then
                        oq.set_group_lead(i, m.name, m.realm, m.class, m.realid)
                    else
                        oq.set_group_member(i, j, m.name, m.realm, m.class, m.realid, m.bg[1].status, m.bg[2].status)
                    end
                    m.check = OQ.FLAG_CLEAR
                end
            end
            if (my_group ~= 0) and (my_slot ~= 0) then
                oq.raid.group[my_group].member[my_slot].level = player_level
            end

            -- update tab_1
            oq.update_tab1_common()
            oq.update_tab1_stats()
            oq.onShow_tab1()

            -- activate in-raid only procs
            oq.procs_join_raid()
        end
    else
        oq.toon = tbl.new()
    end

    oq.toon.MinimapPos = oq.toon.MinimapPos or 0
    OQ_data.show_premade_ads = OQ_data.show_premade_ads or 0 -- off by default; 'sticky' between sessions
    oq.raid.enforce_levels = oq.raid.enforce_levels or 0
    OQ_data.announce_spy = OQ_data.announce_spy or 1
    OQ_data.leader = OQ_data.leader or tbl.new()
    OQ_data.leader['pve.raid'] = OQ_data.leader['pve.raid'] or {nBosses = 0, pts = 0}
    OQ_data.leader['pve.5man'] = OQ_data.leader['pve.5man'] or {nBosses = 0, pts = 0}
    OQ_data.leader['pve.challenge'] = OQ_data.leader['pve.challenge'] or {nBosses = 0, pts = 0}
    OQ_data.leader['pve.scenario'] = OQ_data.leader['pve.scenario'] or {nBosses = 0, pts = 0}

    oq.tab3_enforce:SetChecked((oq.raid.enforce_levels == 1))

    if (oq.toon._idata) and (oq.toon._idata.tm) and ((now - oq.toon._idata.tm) < 60 * 60) then
        -- data only 'good' for an hour
        oq._inside_instance = oq.toon._idata.inst
        oq._instance_type = oq.toon._idata.type
        oq._instance_pts = oq.toon._idata.pts
        oq._instance_header = oq.toon._idata.hdr
        oq._instance_tm = oq.toon._idata.tm
        oq._entered_alone = oq.toon._idata.alone
    end

    OQ_data.auto_join_oqgeneral = 1
    OQ_data.autohide_friendreqs = OQ_data.autohide_friendreqs or 1
    OQ_data.premade_filter_qualified = OQ_data.premade_filter_qualified or 0
    OQ_data.loot_acceptance = OQ_data.loot_acceptance or 1

    -- default find-premade sorting
    if (OQ_data.premade_sort == nil) then
        OQ_data.premade_sort = 'lead'
        OQ_data.premade_sort_ascending = true
    end
    oq.t3 = oq.decode_data
    if (OQ_data.banlist_sort == nil) then
        OQ_data.banlist_sort = 'ts'
        OQ_data.banlist_sort_ascending = true
    end
    if (OQ_data.waitlist_sort == nil) then
        OQ_data.waitlist_sort = 'time'
        OQ_data.waitlist_sort_ascending = true
    end

    -- initialize UI elements
    oq.tab5_ar:SetChecked((oq.toon.auto_role == 1))
    oq.tab5_cp:SetChecked((oq.toon.class_portrait == 1))
    oq.tab5_autoinspect:SetChecked((OQ_data.ok2autoinspect == 1))
    oq.tab5_shoutads:SetChecked((OQ_data.show_premade_ads == 1))
    oq.tab5_autohide_friendreqs:SetChecked((OQ_data.autohide_friendreqs == 1))
    oq.loot_acceptance_cb:SetChecked((OQ_data.loot_acceptance == 1))

    oq._filter._text = OQ_data._filter_text or ''
    oq.set_voip_filter(OQ_data._voip_filter)
    oq.set_lang_filter(OQ_data._lang_filter)

    player_karma = 0
    OQ_data['_' .. oq.e3(121705)] = tbl.size(dtp, 'function') * 1000 + OQ_BUILD

    OQ_data._members = OQ_data._members or tbl.new()
    if (OQ_data._members['gid'] ~= oq.raid.raid_token) then
        tbl.clear(OQ_data._members)
    end
    if (oq.raid.raid_token) then
        OQ_data._members['gid'] = oq.raid.raid_token
        for i = 1, 8 do
            for j = 1, 5 do
                local m = oq.raid.group[i].member[j]
                if (m.name) and (m.name ~= '-') and (m.realm) and (m.realm ~= '-') then
                    local key = string.gsub(strlower(m.name .. '-' .. m.realm), ' ', '')
                    OQ_data._members[key] = m.realid
                end
            end
        end
    end
end

function oq.closeInvitePopup()
    if (_inside_bg) then
        return
    end
    StaticPopup_Hide('PARTY_INVITE')
end

function oq.on_party_invite_request(leader_name)
    if (my_group <= 0) then
        return
    end

    local grp_lead = oq.raid.group[my_group].member[1]
    local n = grp_lead.name

    if (grp_lead == nil) or (grp_lead.realm == nil) then
        return
    end

    if (grp_lead.realm ~= player_realm) then
        n = n .. '-' .. grp_lead.realm
    end

    if (n == leader_name) then
        AcceptGroup()
    end
end

function oq.ui_toggle()
    if (oq.ui:IsVisible()) then
        oq.ui:Hide()
        _ui_open = nil
    else
        oq.ui:Show()
        _ui_open = true
        -- check if banned
        if (oq._banned) or (oq.is_naughty()) then
            oq.banned_shade()
            return
        end
        oq.on_addon_load_init()
        local now = oq.utc_time()

        -- initial prep
        oq.oqgeneral_join()
        if (oq.toon.disabled) then
            oq.oq_on()
        end
    end
end

function OQ_onLoad(self)
    oq.ui = self
    oq.register_base_events()
end

function oq.onHide()
    _ui_open = nil
    oq.ui.hide_tm = GetTime() -- hold this in-case the UI was forced-closed when the map was brought up
    PlaySound('igCharacterInfoClose')
end

function oq.hide_shade()
    if (oq.ui_shade ~= nil) and (oq.ui_shade:IsVisible()) then
        oq.ui_shade:Hide()
    end
end

function oq.onShow()
    _ui_open = true
    PlaySound('igCharacterInfoOpen')

    if (oq._last_tab_shown) then
        return
    end
    oq._last_tab_shown = 1

    oq.hide_shade()
    OQTabPage1:Hide() -- my premade
    OQTabPage2:Hide() -- find premade
    OQTabPage3:Hide() -- create premade
    OQTabPage5:Hide() -- setup
    OQTabPage6:Hide() -- waitlist
    OQTabPage7:Hide() -- banlist

    if (oq.raid.raid_token == nil) and (GetNumGroupMembers() > 0) then
        -- not in an oQueue group but in a party
        local islead = UnitIsGroupLeader('player')
        if (islead) then
            -- party leader straight to create premade
            PanelTemplates_SetTab(OQMainFrame, 3)
            OQTabPage3:Show()
        else
            PanelTemplates_SetTab(OQMainFrame, 1)
            OQTabPage1:Show()
        end
    elseif (GetNumGroupMembers() > 0) or (oq.raid.raid_token ~= nil) then
        -- in an oQueue group
        PanelTemplates_SetTab(OQMainFrame, 1)
        OQTabPage1:Show()
    else
        -- solo toon, looking for raid
        PanelTemplates_SetTab(OQMainFrame, 2)
        OQTabPage2:Show()
    end

    -- set the text on the wait-list tab
    local nWaiting = oq.n_waiting()
    if (nWaiting > 0) then
        OQMainFrameTab7:SetText(string.format(OQ.TAB_WAITLISTN, nWaiting))
    else
        OQMainFrameTab7:SetText(OQ.TAB_WAITLIST)
    end
end

function oq.delayed_button_load()
    oq.mini:RegisterForClicks('AnyUp')
    oq.mini:RegisterForDrag('LeftButton', 'RightButton')
    if (oq.toon.mini_hide) then
        oq.mini:Hide()
    else
        oq.mini:Show()
    end
    oq.mini:SetScript('OnClick', OQ_buttonShow)
    OQ_MinimapButton:SetToplevel(true)
    OQ_MinimapButton:SetFrameStrata('MEDIUM')
    OQ_MinimapButton:SetFrameLevel(50)
end

function oq.mini_count_create()
    local d = oq.CreateFrame('BUTTON', 'OQMiniCount', oq.mini)
    d:SetPoint('TOPLEFT', oq.mini, 'TOPLEFT', -18, -15)
    d:SetWidth(32)
    d:SetHeight(34)
    d:SetFrameLevel(oq.mini:GetFrameLevel() - 2)
    d:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    d:SetScript(
        'OnClick',
        function(_, button)
            if (button == 'LeftButton') then
                -- open waitlist
                if (not oq.ui:IsVisible()) then
                    oq.ui_toggle()
                end
                OQMainFrameTab7:Click()
            else
                -- invite-all
                oq.waitlist_invite_all()
            end
        end
    )

    local i = d:CreateTexture(nil, 'BACKGROUND')
    i:SetAllPoints(d)
    i:SetAlpha(1.0)
    i:SetTexture('Interface\\Minimap\\UI-DungeonDifficulty-Button')
    i:SetTexCoord(13 / 256, 49 / 256, 73 / 128, 105 / 128)
    d.texture = i
    d.txt = oq.label(d, 6, 6, 24, 24, '', 'CENTER', 'CENTER', 'GameFontNormalSmall', 'MEDIUM')
    d.txt:SetTextColor(220 / 255, 220 / 255, 220 / 255)
    d.txt:SetAlpha(1.0)
    d.txt:SetText('--')
    oq.mini_count = d

    oq.mini_count:Hide()
end

function oq.mini_count_update(n)
    if (not oq.iam_raid_leader()) then
        if (oq.mini_count) then
            oq.mini_count:Hide()
        end
        return
    end
    if (oq.mini_count == nil) then
        oq.mini_count_create()
    end
    if (oq.mini_count) then
        oq.mini_count:Show()
        oq.mini_count.txt:SetText(string.format('%2d', n))
    end
end

function OQ_buttonLoad(self)
    oq.mini = self
end

function OQ_UI_Toggle()
    oq.ui_toggle()
end

function OQ_Snitch_Toggle()
    oq.snitch_toggle_ui()
end

function OQ_Waitlist_InviteAll()
    oq.waitlist_invite_all()
end

OQ.minimap_menu_options = {
    {
        text = OQ.MM_OPTION1,
        f = function()
            oq.ui_toggle()
        end
    },
    {
        text = OQ.MM_OPTION7,
        f = function()
            oq.reposition_ui()
        end
    }
}
function oq.make_minimap_dropdown()
    local m = oq.menu_create()

    for i, v in pairs(OQ.minimap_menu_options) do
        oq.menu_add(v.text, i, v.text, nil, v.f)
    end

    return m
end

-- left button : toggles main ui
-- right button: toggles minimap dropdown menu
--
function OQ_buttonShow(self, button, down)
    if (button == 'RightButton') and (not down) then
        if (oq.menu_is_visible()) then
            oq.menu_hide()
        else
            oq.make_minimap_dropdown()
            oq.menu_show(self, 'TOPLEFT', -150, -25, 'BOTTOMLEFT', 150)
        end
    elseif (button == 'LeftButton') and (not down) then
        oq.ui_toggle()
    end
end

function OQ_MinimapButton_Reposition()
    local xpos
    local ypos
    local minimapShape = GetMinimapShape and GetMinimapShape() or 'ROUND'
    if minimapShape == 'SQUARE' then
        xpos = 110 * cos(oq.toon.MinimapPos or 0)
        ypos = 110 * sin(oq.toon.MinimapPos or 0)
        xpos = math.max(-82, math.min(xpos, 84))
        ypos = math.max(-86, math.min(ypos, 82))
    else
        xpos = 80 * cos(oq.toon.MinimapPos or 0)
        ypos = 80 * sin(oq.toon.MinimapPos or 0)
    end
    OQ_MinimapButton:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 54 - xpos, ypos - 54)
end

function OQ_MinimapButton_DraggingFrame_OnUpdate()
    local xpos, ypos = GetCursorPosition()
    local xmin, ymin = Minimap:GetLeft() or 400, Minimap:GetBottom() or 400

    local scale = OQ_MinimapButton:GetEffectiveScale()
    xpos = xmin - xpos / scale + 70
    ypos = ypos / scale - ymin - 70

    oq.toon.MinimapPos = math.deg(math.atan2(ypos, xpos))
    OQ_MinimapButton_Reposition() -- move the button
end

function OQ_hide_menu_popup()
    oq.menu_hide()
end

function oq.hook_ui_resize()
    oq.ui:SetScript(
        'OnSizeChanged',
        function(self)
            OQ_OnSizeChanged(self)
        end
    )
    OQMainFrame:SetHeight(OQ_data._height or OQ.MIN_FRAME_HEIGHT)
    oq.frame_resize()
end

function OQ_OnSizeChanged(f)
    if (f) and (f.__resizing) and (OQTabPage2) and (OQTabPage2._resize) then
        OQ_data._height = min(1000, max(OQ.MIN_FRAME_HEIGHT, floor(f:GetHeight()) or 0))
        oq.frame_resize()
    else
        local cy = floor(f:GetHeight())
        if (cy ~= OQ_data._height) then
            f:SetHeight(OQ_data._height or OQ.MIN_FRAME_HEIGHT)
        end
    end
end

function OQ_ResizeMouse_down(f)
    local p = f:GetParent()
    local cx = floor(p:GetWidth())
    local cy = floor(p:GetHeight())
    p:StartSizing()
    -- StartSizing was resizing the frame.  solution: reset the size
    p:SetWidth(cx)
    p:SetHeight(cy)
    p.__resizing = true
end

function OQ_ResizeMouse_up(f)
    local p = f:GetParent()
    if (p.__resizing) then
        p:StopMovingOrSizing()
        p.__resizing = nil
    end
end

function oq.IsMessageWellFormed(m)
    if (m == nil) then
        return nil
    end
    local str = OQ_MSGHEADER .. '' .. OQ_BUILD_STR .. ','
    if (m:sub(1, #str) == str) then
        return true
    end
    return nil
end

function oq.EnsureMessageIsFormed(msg)
    if (not oq.IsMessageWellFormed(msg)) then
        local token = 'W' .. oq.token_gen()
        oq.token_push(token)
        msg = 'OQ,' .. OQ_BUILD_STR .. ',' .. token .. ',' .. OQ_TTL .. ',' .. msg
    end

    return msg
end
function oq.XRealmWhisper(receiverName, receiverRealm, msg)
    if (oq._isAfk) then
        return
    end

    if (receiverName == nil or receiverName == '-') then
        return
    end

    -- Sending to myself
    if (receiverName == player_name and receiverRealm == player_realm) then
        return
    end

    msg = oq.EnsureMessageIsFormed(msg)

    if (player_realm == nil or player_realm == receiverRealm) then
        SendAddonMessage(OQ_HEADER, msg, 'WHISPER', receiverName)
        oq.pkt_sent:inc()
        return
    end

    oq.SendChatMessage(msg, 'WHISPER', nil, receiverName .. '-' .. receiverRealm)
end
-- function oq.debug(msg, ...)
--   if type(msg) == "table" then
--     for k, v in pairs(msg) do
--         print("KEY")
--         print(k)
--         oq.debug(v)
--     end
--   else
--     print("VAL")
--     print(msg)
--   end
-- end
