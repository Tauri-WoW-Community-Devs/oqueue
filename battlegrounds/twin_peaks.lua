--[[ 
  @file       twin_peaks.lua
  @brief      user timer functions to support twin peaks

  @author     rmcinnis
  @date       june 13, 2013
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local oq = OQ:mod() ; -- thank goodness i stumbled across this trick

local ALLIANCE_WIN = "Interface/Icons/INV_BannerPVP_02.blp" ;
local HORDE_WIN = "Interface/Icons/INV_BannerPVP_01.blp" ;
local _tp_init = nil ;
local _tp_expire_tm = 0 ;
local _ ; -- throw away (was getting taint warning; what happened blizz?)

local units = {} ;
local scores = { ["horde"   ] = 0,
                 ["alliance"] = 0,
                 ["tm"      ] = 0,
               } ;
local flags = { { x = 0.529, y = 0.907, name = "Horde flag room" },
                { x = 0.615, y = 0.161, name = "Alliance flag room" },
              } ;
local graveyards = { { x = 0.590, y = 0.858, name = "Horde" },
                     { x = 0.622, y = 0.549, name = "Horde Mid" },
                     { x = 0.493, y = 0.121, name = "Alliance" },
                     { x = 0.413, y = 0.483, name = "Alliance Mid" },
                   } ;
local GRAVEYARD_RANGE  = 0.02 ;
local NODE_RANGE       = 0.08 ;
local function get_location_name( x, y, location, radius )
  local i, v ;
  for i,v in pairs(location) do
    if (x > (v.x - radius)) and (x < (v.x + radius)) and 
       (y > (v.y - radius)) and (y < (v.y + radius)) then
       return v.name ;
    end
  end
  return nil ;
end

local function get_score()
  if (AlwaysUpFrame2Text == nil) or (AlwaysUpFrame3Text == nil) then
    return 0,0 ;
  end
  local line2 = AlwaysUpFrame2Text:GetText() ;
  local line3 = AlwaysUpFrame3Text:GetText() ;
  if (line2 == nil) or (line3 == nil) then
    return 0,0 ;
  end
  if (AlwaysUpFrame1Text ~= nil) then
    local line1 = AlwaysUpFrame1Text:GetText() ;
    if (line1 ~= nil) then
      local tm = line1:match( "Remaining: (%d+)" ) ;  
      local dt = _tp_expire_tm - GetTime() ;
      tm = tonumber(tm) * 60 ;
      -- reset time if off by more then 120 seconds
      if (abs(dt - tm) > 120) then
        _tp_expire_tm = GetTime() + tm ;
      end
    end
  end
  return tonumber(line2:match( "%d+" )), tonumber(line3:match( "%d+" )) ;
end

local function tp_get_current_loc()
  local x, y = GetPlayerMapPosition("player") ; 
  local loc = get_location_name( x, y, graveyards, NODE_RANGE ) ;
  if (loc == nil) then
    loc = get_location_name( x, y, flags, NODE_RANGE ) or "" ;
  end
  print( "location: Twin Peaks @ ".. floor(x*1000)/1000 .." , ".. floor(y*1000)/1000 .."    ".. loc ) ;
end

local function tp_utimer_init()
  if (_tp_init) then
    return ;
  end
  
  oq.utimer_start( "Alliance"          , "alliance", 15, 30, 3 ) ; -- alliance graveyard timer
  oq.utimer_start( "Alliance Mid"      , "alliance", 15, 30, 3 ) ; -- alliance graveyard timer
  oq.utimer_start( "Horde"             , "horde"   , 13, 30, 3 ) ; -- horde graveyard timer
  oq.utimer_start( "Horde Mid"         , "horde"   , 13, 30, 3 ) ; -- horde graveyard timer
  oq.utimer_start( "Alliance flag room", "alliance", 43, 30, 4, true ) ; -- alliance flag room
  oq.utimer_start( "Horde flag room"   , "horde"   , 44, 30, 4, true ) ; -- horde flag room
  
  units = {} ;
  scores["horde"   ] = 0 ;
  scores["alliance"] = 0 ;
  scores["tm"      ] = GetTime() ;
  _tp_init = 1 ;
  _tp_expire_tm = GetTime() + 20 * 60 ; -- 20 min games
end

local function tp_graveyard_timers_reset()
  oq.utimer_reset_cycle( "Horde" ) ;
  oq.utimer_reset_cycle( "Alliance" ) ;
end

local dead_count = {} ;
local node_count = {} ;
local function check_ressers()
  -- Grab our data
  dead_count = {} ;
  node_count = {} ;
  local i, v ;
  for i=1,GetNumGroupMembers() do
    local name = GetUnitName( "raid".. i, true ) ;
    local hp = UnitHealth( "raid".. i ) ;
    if (units[name] ~= nil) and (units[name] <= 1) and (hp > 1) then
      -- ressed 
      local x, y = GetPlayerMapPosition( "raid" .. i ) ;
      local loc = get_location_name( x, y, graveyards, GRAVEYARD_RANGE ) ;
      tp_graveyard_timers_reset() ;
    elseif (units[name] ~= nil) and (units[name] <= 1) then
      -- dead, waiting to res.  which graveyard?
      local x, y = GetPlayerMapPosition( "raid" .. i ) ;
      local loc = get_location_name( x, y, graveyards, GRAVEYARD_RANGE ) ;
      if (loc) then
        dead_count[ loc ] = (dead_count[loc] or 0) + 1 ;
      end
    else
      -- alive, which node?
      local x, y = GetPlayerMapPosition( "raid" .. i ) ;
      local loc = get_location_name( x, y, flags, NODE_RANGE ) ;
      if (loc == nil) then
        loc = get_location_name( x, y, graveyards, NODE_RANGE ) ;
      end
      if (loc) then
        node_count[ loc ] = (node_count[loc] or 0) + 1 ;
      end
    end
    units[name] = hp ;
  end
  -- set count on cycle timers
  for i,v in pairs(oq._utimers) do
    if (v._start ~= 0) then
      if (v._type == 3) then
        v._dead  = dead_count[ v.label:GetText() ] ; 
        v._count = node_count[ v.label:GetText() ] ; 
      else
        v._count = node_count[ v.label:GetText() ] ; 
      end
    end
  end  

  dead_count = {} ; -- clean it out
  node_count = {} ; -- clean it out
end

local function tp_utimer_check()
  if (WorldMapFrame:IsVisible()) then
    return ;
  end
  
  tp_utimer_init() ;
  check_ressers() ;

  local ab, hb = get_score() ;
  if (ab == scores["alliance"]) and (hb == scores["horde"]) then
    -- flag count hasn't changed, no need to recalc time
    oq.utimer_shuffle() ;
    return ;
  end
  -- something changed.  need to update win timer
  local now  = GetTime() ;
  local game_over = _tp_expire_tm - now ;
  local tm_a = game_over ;
  local tm_h = 0 ;
  
  if (ab > hb) then
    tm_a = game_over ;
    tm_h = 0 ;
  elseif (hb > ab) then
    tm_a = 0 ;
    tm_h = game_over ;
  else
    -- flags match, last flag capped is the winner
    if (ab == scores["alliance"]) then
      -- alliance flag was last capped
      tm_a = game_over ;
      tm_h = 0 ;
    else
      -- horde flag was last capped
      tm_a = 0 ;
      tm_h = game_over ;
    end
  end
  
  if (tm_h > 0) then 
    -- horde winning
    oq.utimer_stop( "Alliance wins", 2 ) ;
    local t = oq.utimer_find("Horde wins") ;
    if (t == nil) then
      oq.utimer_start( "Horde wins", "horde", HORDE_WIN, tm_h, 2 ) ;
    else
      t._end = now + tm_h ;
    end
    if (t) then
      t._count = nil ;
    end
  else
    -- alliance winning
    oq.utimer_stop( "Horde wins", 2 ) ;
    local t = oq.utimer_find("Alliance wins") ;
    if (t == nil) then
      oq.utimer_start( "Alliance wins", "alliance", ALLIANCE_WIN, tm_a, 2 ) ;
    else
      t._end = now + tm_a ;
    end
    if (t) then
      t._count = nil ;
    end
  end
  scores["horde"   ] = hb ;
  scores["alliance"] = ab ;
  scores["tm"      ] = now ;
  oq.utimer_shuffle() ;
end

local function tp_start()
  -- reset graveyard timers
  oq.utimer_reset_cycle( "Horde" ) ;
  oq.utimer_reset_cycle( "Alliance" ) ;
  
  scores["horde"   ] = 0 ;
  scores["alliance"] = 0 ;
  scores["tm"      ] = GetTime() ;
  _tp_expire_tm = GetTime() + 20 * 60 ; -- 20 min games
end

local function tp_shuffle()
  local x  = 0 ;
  local y  = 18 ;
  local cx = OQ_data.timer_width or 200 ;
  local cy = 20 ;
  local n = 0 ;
  local i, v ;
  oq._utimer_items = {} ;
  oq._utimer_gys = {} ;
  oq._utimer_controlled = {} ;
  for i,v in pairs(oq._utimers) do
    if (v._start ~= 0) then
      if     (v._type == 1) then
        table.insert(oq._utimer_items, i) ;
      elseif (v._type == 2) then
        table.insert(oq._utimer_items, i) ;
      elseif (v._type == 3) then
        table.insert(oq._utimer_gys, i) ;
      elseif (v._type == 4) then
        table.insert(oq._utimer_controlled, i) ;
      end
    end
  end  

  -- flag rooms & win timer
  if (n > 0) then
    y = y + cy ;
  end
  n = 0 ;
  table.sort(oq._utimer_items, oq.utimer_compare) ;  
  for i,v in pairs(oq._utimer_items) do
    oq.setpos( oq._utimers[v], x, y, cx, cy ) ;
    y = y + cy ;
    n = n + 1 ;
  end
  
  -- enemy nodes
  if (n > 0) then
    y = y + cy ;
  end
  n = 0 ;
  table.sort(oq._utimer_controlled, oq.utimer_compare_alpha) ;  
  for i,v in pairs(oq._utimer_controlled) do
    oq.setpos( oq._utimers[v], x, y, cx, cy ) ;
    y = y + cy ;
    n = n + 1 ;
  end
  
  -- controlled nodes & graveyards
  if (n > 0) then
    y = y + cy ;
  end
  table.sort(oq._utimer_gys, oq.utimer_compare_alpha) ;  
  for i,v in pairs(oq._utimer_gys) do
    oq.setpos( oq._utimers[v], x, y, cx, cy ) ;
    y = y + cy ;
  end
end
  
local function tp_close()
  _tp_init = nil ;
  _tp_expire_tm = 0 ;
  oq.utimer_stop_all() ;
end

local function tp_test( arg1 )
  tp_close() ; -- clear init and timers
  tp_utimer_init() ;
end

-- hook 
if (oq._bg_checks == nil) then
  oq._bg_checks = {} ;
end

oq._bg_checks["TP"] = { check   = tp_utimer_check, 
                        close   = tp_close,
                        loc     = tp_get_current_loc,
                        shuffle = tp_shuffle,
                        start   = tp_start,
                        test    = tp_test
                      } ;



