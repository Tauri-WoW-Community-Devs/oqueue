local addonName, OQ = ...
local oq = OQ:mod() -- thank goodness i stumbled across this trick
local _  -- throw away (was getting taint warning; what happened blizz?)
local tbl = OQ.table

--------------------------------------------------------------------------
--  packet stats
--------------------------------------------------------------------------
PacketStatistics = {}
function PacketStatistics:new(max_cnt)
    local o = tbl.new()
    o._cnt = 0
    o._max = max_cnt
    o.array = tbl.new()

    for i = 1, max_cnt do
        o.array[i] = tbl.new()
        o.array[i]._x = nil
        o.array[i]._tm = nil
    end

    o._n = 0
    o._aps = 0
    o._dt = 0
    o._mean = 0
    setmetatable(o, {__index = PacketStatistics})
    return o
end

--
-- used for averaging event times
--
function PacketStatistics:avg()
    local t1 = nil
    local t2 = nil
    local n1 = 0
    local n2 = 0

    self._n = 0
    self._aps = 0 -- avg per second

    for i = 1, self._max do
        if (self.array[i]._x ~= nil) then
            self._n = self._n + 1
            if (t2 == nil) then
                t2 = self.array[i]._tm
                n2 = self.array[i]._x
            end
            t1 = self.array[i]._tm
            n1 = self.array[i]._x
        end
    end
    if (self._n < 2) then
        self._aps = 0
        self._dt = 0
        return 0
    end
    self._dt = t2 - t1
    if (self._dt > 0) then
        self._aps = (n2 - n1) / self._dt
    end
    return self._aps
end

function PacketStatistics:mean()
    local n = 0
    local sum = 0

    for i = 1, self._max do
        if (self.array[i]._x ~= nil) then
            n = n + 1
            sum = sum + self.array[i]._x
        end
    end
    if (n == 0) then
        self._mean = 0
    else
        self._mean = sum / n
    end
end

function PacketStatistics:reset()
    self._cnt = 0

    for i = 1, self._max do
        self.array[i]._x = nil
        self.array[i]._tm = nil
    end

    self._n = 0
    self._cnt = 0
    self._aps = 0
    self._dt = 0
    self._mean = 0
end

function PacketStatistics:inc()
    self:push(self._cnt)
    self._cnt = self._cnt + 1
end

-- no-op  recording nothing
--
function PacketStatistics:noop()
    self:push(self._cnt)
end

function PacketStatistics:push(x, use_mean)
    for i = self._max, 2, -1 do
        self.array[i]._x = self.array[i - 1]._x
        self.array[i]._tm = self.array[i - 1]._tm
    end
    self.array[1]._x = x
    self.array[1]._tm = GetTime()
    if (use_mean) then
        self:mean()
    else
        self:avg()
    end
end

function PacketStatistics:median()
    local t = tbl.new()
    for _, v in pairs(self.array) do
        table.insert(t, v._x)
    end
    local median = oq.stats.median(t)
    tbl.delete(t)
    return median
end

oq.pkt_sent = PacketStatistics:new(50)
oq.pkt_recv = PacketStatistics:new(50)
oq.pkt_processed = PacketStatistics:new(50)
oq.pkt_drift = PacketStatistics:new(5)
oq.gmt_diff_track = PacketStatistics:new(100)

--------------------------------------------------------------------------
--  general stats
--------------------------------------------------------------------------

oq.stats = tbl.new()

-- Get the mean value of a table
function oq.stats.mean(t)
    local sum = 0
    local count = 0

    for _, v in pairs(t) do
        if type(v) == 'number' then
            sum = sum + v
            count = count + 1
        end
    end
    return (sum / count)
end

-- Get the mode of a table.  Returns a table of values.
-- Works on anything (not just numbers).
function oq.stats.mode(t)
    local counts = tbl.new()

    for _, v in pairs(t) do
        if counts[v] == nil then
            counts[v] = 1
        else
            counts[v] = counts[v] + 1
        end
    end

    local biggestCount = 0
    for _, v in pairs(counts) do
        if (v > biggestCount) then
            biggestCount = v
        end
    end

    local temp = tbl.new()
    for k, v in pairs(counts) do
        if v == biggestCount then
            table.insert(temp, k)
        end
    end

    tbl.delete(counts)
    return temp
end

-- Get the median of a table.
function oq.stats.median(t, skip_zero)
    local temp = tbl.new()

    -- deep copy table so that when we sort it, the original is unchanged
    -- also weed out any non numbers
    for _, v in pairs(t) do
        if (type(v) == 'number') and ((skip_zero == nil) or (v > 0)) then
            table.insert(temp, v)
        end
    end
    table.sort(temp)

    -- If we have an even number of table elements or odd.
    local median = 0
    local n = #temp
    if (n > 0) then
        if math.fmod(n, 2) == 0 then
            -- return mean value of middle two elements
            median = (temp[n / 2] + temp[(n / 2) + 1]) / 2
        else
            -- return middle element
            median = temp[math.ceil(n / 2)]
        end
    end
    tbl.delete(temp)
    return median
end

-- Get the standard deviation of a table
function oq.stats.standardDeviation(t)
    local m = oq.stats.mean(t)
    local vm
    local sum = 0
    local count = 0
    local result

    for _, v in pairs(t) do
        if type(v) == 'number' then
            vm = v - m
            sum = sum + (vm * vm)
            count = count + 1
        end
    end
    result = math.sqrt(sum / (count - 1))
    return result
end

-- Get the max and min for a table
function oq.stats.maxmin(t)
    local max = -math.huge
    local min = math.huge

    for _, v in pairs(t) do
        if type(v) == 'number' then
            max = math.max(max, v)
            min = math.min(min, v)
        end
    end
    return max, min
end
