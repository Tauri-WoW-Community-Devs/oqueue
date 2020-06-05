local addonName, OQ = ...
local oq = OQ:mod() -- thank goodness i stumbled across this trick
local _
local tbl = OQ.table

OQ.TIMER_RESOLUTION = 200 / 1000 -- 5 times per second

--------------------------------------------------------------------------
-- timer functions
--------------------------------------------------------------------------
function oq.timer(id, dt_, func_, repeater, ...)
    if (oq.timers == nil) then
        oq.timers = tbl.new()
    end

    if (func_ == nil) then
        oq.timers[id] = tbl.delete(oq.timers[id])
    else
        local timer = nil
        if (repeater) then
            timer = OQ:ScheduleRepeatingTimer(func_, dt_, ...)
        else
            timer = OQ:ScheduleTimer(func_, dt_, ...)
        end

        oq.timers[id] = timer
    end
end

function oq.is_timer(id)
    return ((oq.timers ~= nil) and (oq.timers[id] ~= nil))
end

function oq.timer_clear()
    OQ:CancelAllTimers()
    tbl.clear(oq.timers, true)
end

function oq.timer_dump()
    print('--[ timers ]------')
    for i, v in pairs(oq.timers) do
        print('  ' .. oq.render_tm(v:TimeLeft(i), true) .. '  ' .. tostring(i))
    end
    print('--')
end

oq.one_shot = 0;
function oq.timer_oneshot(dt_, func_, ...)
    oq.one_shot = oq.one_shot + 1;
    oq.timer('one_shot.' .. oq.one_shot, dt_, func_, nil, ...)
end
