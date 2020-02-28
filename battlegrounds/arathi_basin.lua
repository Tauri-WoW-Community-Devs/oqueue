--[[ 
  @file       arathi_basin.lua
  @brief      user timer functions to support arathi basin

  @author     rmcinnis
  @date       may 31, 2013
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local oq = OQ:mod() ; -- thank goodness i stumbled across this trick

local ALLIANCE_WIN = "Interface/Icons/INV_BannerPVP_02.blp" ;
local HORDE_WIN = "Interface/Icons/INV_BannerPVP_01.blp" ;
local _init = nil ;
local _ ; -- throw away (was getting taint warning; what happened blizz?)

-- points of interest
local poi = { [16]  = "GoldMine",
              [17]  = "GoldMine",
              [18]  = "GoldMine",
              [19]  = "GoldMine",
              [20]  = "GoldMine",
              [21]  = "LumberMill",
              [22]  = "LumberMill",
              [23]  = "LumberMill",
              [24]  = "LumberMill",
              [25]  = "LumberMill",
              [26]  = "Blacksmith",
              [27]  = "Blacksmith",
              [28]  = "Blacksmith",
              [29]  = "Blacksmith",
              [30]  = "Blacksmith",
              [31]  = "Farm",
              [32]  = "Farm",
              [33]  = "Farm",
              [34]  = "Farm",
              [35]  = "Farm",
              [36]  = "Stables",
              [37]  = "Stables",
              [38]  = "Stables",
              [39]  = "Stables",
              [40]  = "Stables",
            } ;
local state = { [16] = -1, -- neutral / destroyed
                [21] = -1, -- neutral / destroyed
                [26] = -1, -- neutral / destroyed
                [31] = -1, -- neutral / destroyed
                [36] = -1, -- neutral / destroyed
                
                [18] =  1, -- alli controlled
                [23] =  1, -- alli controlled
                [28] =  1, -- alli controlled
                [33] =  1, -- alli controlled
                [38] =  1, -- alli controlled
                
                [20] =  2, -- horde controlled
                [25] =  2, -- horde controlled
                [30] =  2, -- horde controlled
                [35] =  2, -- horde controlled
                [40] =  2, -- horde controlled
                
                [17] =  3, -- alli assaulted
                [22] =  3, -- alli assaulted
                [27] =  3, -- alli assaulted
                [32] =  3, -- alli assaulted
                [37] =  3, -- alli assaulted
                
                [19] =  4, -- horde assaulted
                [24] =  4, -- horde assaulted
                [29] =  4, -- horde assaulted
                [34] =  4, -- horde assaulted
                [39] =  4, -- horde assaulted
              } ;

local objectives = { ["Farm"      ] = 0,
                     ["GoldMine"  ] = 0,
                     ["LumberMill"] = 0,
                     ["Stables"   ] = 0,
                     ["Blacksmith"] = 0,
                   } ;
                   
local scores = { ["horde"   ] = 0,
                 ["alliance"] = 0,
                 ["tm"      ] = 0,
               } ;
               
local ResPerSec = { [0] = 1e-300, 
                    [1] = 10/12,
                    [2] = 10/9,
                    [3] = 10/6,
                    [4] = 10/3,
                    [5] = 30,
                  } ;
                  
local units = {} ;

local function get_score()
  if (AlwaysUpFrame1Text == nil) or (AlwaysUpFrame2Text == nil) then
    return 0,0 ;
  end
  local line1 = AlwaysUpFrame1Text:GetText() ;
  local line2 = AlwaysUpFrame2Text:GetText() ;
  if (line1 == nil) or (line2 == nil) then
    return 0,0 ;
  end
  return line1:match( "Resources: (%d+)" ), line2:match( "Resources: (%d+)" ) ;
end

local function get_basecount()
  local alliance = 0 ;
  local horde = 0 ;
  local k, v ;
  for k,v in pairs(objectives) do
    if v == 18 or v == 23 or v == 28 or v == 33 or v == 38 then 
      alliance = alliance + 1 ;
    elseif v == 20 or v == 25 or v == 30 or v == 35 or v == 40 then 
      horde = horde + 1 ;
    end
  end
  return alliance, horde ;
end

-- horde lz res'd  657 686
local flags = { { x = 0.463, y = 0.453, name = "Blacksmith" },
                { x = 0.558, y = 0.599, name = "Farm" }, 
                { x = 0.573, y = 0.308, name = "Gold Mine" }, 
                { x = 0.404, y = 0.560, name = "Lumber Mill" }, 
                { x = 0.373, y = 0.294, name = "Stables" }, 
              } ;

local graveyards = { { x = 0.693, y = 0.677, name = "Horde LZ" },
                     { x = 0.511, y = 0.420, name = "Blacksmith" },
                     { x = 0.608, y = 0.575, name = "Farms" },
                     { x = 0.610, y = 0.256, name = "Gold Mine" },
                     { x = 0.370, y = 0.627, name = "Lumber Mill" },
                     { x = 0.393, y = 0.261, name = "Stables" },
                     { x = 0.333, y = 0.131, name = "Alliance LZ" },
                   } ;
local GRAVEYARD_RANGE  = 0.01 ;
local NODE_RANGE       = 0.025 ;
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

local function ab_get_current_loc()
  local x, y = GetPlayerMapPosition("player") ; 
  local loc = get_location_name( x, y, graveyards, NODE_RANGE ) ;
  if (loc == nil) then
    loc = get_location_name( x, y, flags, NODE_RANGE ) or "" ;
  end
  print( "location: Arathi Basin @ ".. floor(x*1000)/1000 .." , ".. floor(y*1000)/1000 .."    ".. loc ) ;
end

local function utimer_init_AB()
  if (_init) then
    return ;
  end
  local i, v ;
  for i=1, GetNumMapLandmarks(), 1 do
    local name, _, textureIndex = GetMapLandmarkInfo(i)
    if name and textureIndex then
      local type = poi[ textureIndex ] ;
      if type then
        objectives[type] = 0 ;
--        objectives[type] = textureIndex ;
      end
    end
  end
  for i,v in pairs(objectives) do
    objectives[i] = 0 ;
  end
  for i,v in pairs(scores) do
    scores[i] = 0 ;
  end
  units = {} ;
  _init = 1 ;
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
      oq.utimer_reset_cycle( loc ) ;
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

local function ab_utimer_check()
  if (WorldMapFrame:IsVisible()) then
    return ;
  end
  
  utimer_init_AB() ;
  
  local i ;
  for i=1, GetNumMapLandmarks(), 1 do
    local name, _, textureIndex = GetMapLandmarkInfo(i) ;
    if name and textureIndex then
      local _type  = poi  [ textureIndex ] ;
      local _state = state[ textureIndex ] ;
      if _type and _state and (textureIndex ~= objectives[_type]) then
        oq.utimer_stop( name ) ;
        if (_state == 1) then
          -- alliance controlled
          oq.utimer_stop( name, 1 ) ; -- stop capping timer
          if (oq._player_faction == "A") then
            oq.utimer_start( name, "alliance", textureIndex, 30, 3 ) ; -- graveyard timer
          else
            oq.utimer_start( name, "alliance", textureIndex, 30, 4, true ) ; -- enemy node
          end
        elseif (_state == 2) then
          -- horde controlled
          oq.utimer_stop( name, 1 ) ; -- stop capping timer
          if (oq._player_faction == "H") then
            oq.utimer_start( name, "horde", textureIndex, 30, 3 ) ; -- graveyard timer
          else
            oq.utimer_start( name, "horde", textureIndex, 30, 4, true ) ; -- enemy node
          end
        elseif (_state == 3) then
          -- alliance capping
          oq.utimer_stop( name, 3 ) ; -- stop node timer
          oq.utimer_stop( name, 4 ) ; -- enemy timer
          oq.utimer_start( name, "alliance", textureIndex, 1*60, 1 ) ;
        elseif (_state == 4) then
          -- horde capping
          oq.utimer_stop( name, 3 ) ; -- stop node timer
          oq.utimer_stop( name, 4 ) ; -- stop enemy timer
          oq.utimer_start( name, "horde", textureIndex, 1*60, 1 ) ;
        end
        objectives[_type] = textureIndex ;
      end
    end
  end  

  if (oq.utimer_find("Alliance LZ") == nil) and (oq._player_faction == "A") then
    oq.utimer_start( "Alliance LZ", "alliance", 15, 30, 3 ) ;
  end
  if (oq.utimer_find("Horde LZ") == nil) and (oq._player_faction == "H") then
    oq.utimer_start( "Horde LZ", "horde", 13, 30, 3 ) ;
  end
          
  check_ressers() ;

  local a, h = get_score() ;
  local now  = GetTime() ;
  local ab, hb = get_basecount() ;
  if (ab == scores["alliance"]) and (hb == scores["horde"]) then
    -- bases hasn't changed, no need to recalc time
    oq.utimer_shuffle() ;
    return ;
  end
  local tm_a = floor((1600 - a) / ResPerSec[ab]) ;
  local tm_h = floor((1600 - h) / ResPerSec[hb]) ;
  if (tm_a > tm_h) then 
    -- horde winning
    oq.utimer_stop( "Alliance wins", 2 ) ;
    local t = oq.utimer_find("Horde wins") ;
    if (t == nil) then
      oq.utimer_start( "Horde wins", "horde", HORDE_WIN, tm_h, 2 ) ;
    else
      t._end   = now + tm_h ;
      t._count = nil ;
    end
  else
    -- alliance winning
    oq.utimer_stop( "Horde wins", 2 ) ;
    local t = oq.utimer_find("Alliance wins") ;
    if (t == nil) then
      oq.utimer_start( "Alliance wins", "alliance", ALLIANCE_WIN, tm_a, 2 ) ;
    else
      t._end   = now + tm_a ;
      t._count = nil ;
    end
  end
  scores["horde"   ] = hb ;
  scores["alliance"] = ab ;
  scores["tm"      ] = now ;
  oq.utimer_shuffle() ;
end

local function ab_shuffle()
  local x  = 0 ;
  local y  = 18 ;
  local cx = OQ_data.timer_width or 200 ;
  local cy = 20 ;
  local n = 0 ;
  local i, v ;
  oq._utimer_bosses = {} ;
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
  
  -- capping nodes & win timer
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

local function ab_test_1()
print( "ab test 1" ) ;

  -- test from horde side
  local t ;
  oq.utimer_stop_all() ; -- clear out existing timers
  t = oq.utimer_start( "Lumber Mill", "horde"   , 24, 1*60, 1 ) ; -- horde capping lumbermill
  t._count = 4 ; -- 4 assaulting
  t = oq.utimer_start( "Blacksmith" , "horde"   , 29, 1*60, 1 ) ; -- horde capping blacksmith
  t = oq.utimer_start( "Stables"    , "horde"   , 40, 1*60, 3 ) ; -- horde controlled stables - friendly
  t._count = 1 ; -- 1 guard
  t._dead  = 2 ; -- 2 ressers
  t = oq.utimer_start( "Farm"       , "alliance", 32, 1*60, 1 ) ; -- alliance capping farm
  t = oq.utimer_start( "Gold Mine"  , "alliance", 18, 1*60, 4 ) ; -- alliance controlled mine - enemy
  t._count = 3 ; -- 3 assaulting
  t._notime = true ;
  t = oq.utimer_start( "Horde wins" , "horde"   , HORDE_WIN, 3*60, 2 ) ; -- horde winning in 3 min
  
  t = oq.utimer_start( "Horde LZ"   , "horde"   , 13, 30, 3 ) ; -- horde lz - friendly
end

local function ab_test_2()
print( "ab test 2" ) ;
  -- test from horde side, alliance winning
  local t ;
  oq.utimer_stop_all() ; -- clear out existing timers
  t = oq.utimer_start( "Lumber Mill", "horde"   , 24, 1*60, 1 ) ; -- horde capping lumbermill
  t._count = 4 ; -- 4 assaulting
  t = oq.utimer_start( "Blacksmith" , "horde"   , 29, 1*60, 1 ) ; -- horde capping blacksmith
  t = oq.utimer_start( "Farm"       , "alliance", 32, 1*60, 1 ) ; -- alliance capping farm
  t = oq.utimer_start( "Stables"    , "alliance", 40, 1*60, 4 ) ; -- alliance controlled stables - enemy
  t._count = 3 ; -- 3 attackers
  t = oq.utimer_start( "Gold Mine"  , "alliance", 18, 1*60, 4 ) ; -- alliance controlled mine - enemy
  t._count = 3 ; -- 3 assaulting
  t._notime = true ;
  t = oq.utimer_start( "Alliance wins", "alliance", ALLIANCE_WIN, 3*60, 2 ) ; -- horde winning in 3 min
  
  t = oq.utimer_start( "Horde LZ"   , "horde"   , 13, 30, 3 ) ; -- horde lz - friendly
  t._dead = 2 ; -- 2 ressers
end

local function ab_start()
  -- ab started
end

local function ab_test( arg1 )
  if (arg1 == nil) or (arg1 == "1") then
    ab_test_1() ;
  elseif (arg1 == "2") then
    ab_test_2() ;
  end
end

local function ab_close()
  _init = nil ;
  for i,v in pairs(objectives) do
    objectives[i] = 0 ;
  end
  for i,v in pairs(scores) do
    scores[i] = 0 ;
  end
  oq.utimer_stop_all() ;
end

-- hook 
if (oq._bg_checks == nil) then
  oq._bg_checks = {} ;
end
oq._bg_checks["AB"] = { check   = ab_utimer_check, 
                        close   = ab_close,
                        shuffle = ab_shuffle,
                        start   = ab_start,
                        loc     = ab_get_current_loc,
                        test    = ab_test
                      } ;



