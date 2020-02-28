--[[ 
  @file       alterac_valley.lua
  @brief      user timer functions to support alterac valley

  @author     rmcinnis
  @date       may 31, 2013
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local oq = OQ:mod() ; -- thank goodness i stumbled across this trick

local ALLIANCE_GENERAL = "Interface/Icons/INV_BannerPVP_02.blp" ;
local HORDE_GENERAL    = "Interface/Icons/INV_BannerPVP_01.blp" ;
local _ ; -- throw away (was getting taint warning; what happened blizz?)

local scores = { ["horde"   ] = 500,
                 ["alliance"] = 500,
                 ["tm"      ] = 0,
               } ;
               
-- points of interest
local poi = { [ 4] = "gy", 
              [ 8] = "gy", 
              [13] = "gy", 
              [14] = "gy", 
              [15] = "gy", 
              [ 6] = "tower", 
              [ 9] = "tower", 
              [10] = "tower", 
              [11] = "tower", 
              [12] = "tower", 
            } ;
            
local state = { [ 8] = -1, -- neutral / destroyed
                [15] =  1, -- alli controlled
                [13] =  2, -- horde controlled
                [ 4] =  3, -- alli assaulted
                [14] =  4, -- horde assaulted
                -- tower states
                [ 6] = -1, -- neutral / destroyed
                [11] =  1, -- alli controlled
                [10] =  2, -- horde controlled
                [ 9] =  3, -- alli assaulted
                [12] =  4, -- horde assaulted
              } ;
local units      = {} ;
local graveyards = {} ;
local towers     = {} ;
local _init      = nil ;

local bosses = { ["bal" ] = { x = 0.488, y = 0.399, state = 1, faction = "alliance", name = "Balinda"  , texture = "INTERFACE/ICONS/Spell_Frost_FrozenCore" },
                 ["vann"] = { x = 0.424, y = 0.134, state = 1, faction = "alliance", name = "Vanndar"  , texture = ALLIANCE_GENERAL },
                 ["galv"] = { x = 0.460, y = 0.574, state = 1, faction = "horde"   , name = "Galvangar", texture = "INTERFACE/ICONS/Icon_PetFamily_Humanoid" },
                 ["drek"] = { x = 0.473, y = 0.868, state = 1, faction = "horde"   , name = "Drek'Thar", texture = HORDE_GENERAL },
               } ;
               
local nodes = { { x = 0.452, y = 0.143, name = "Dun Baldar North Bunker" },
                { x = 0.440, y = 0.187, name = "Dun Baldar South Bunker" },
                { x = 0.505, y = 0.312, name = "Icewing Bunker" },
                { x = 0.524, y = 0.438, name = "Stonehearth Bunker" },
                { x = 0.482, y = 0.586, name = "Iceblood Tower" },
                { x = 0.505, y = 0.655, name = "Tower Point" },
                { x = 0.495, y = 0.845, name = "East Frostwolf Tower" },
                { x = 0.483, y = 0.844, name = "West Frostwolf Tower" },
                { x = 0.488, y = 0.399, name = "Balinda"   },
                { x = 0.424, y = 0.134, name = "Vanndar"   },
                { x = 0.460, y = 0.574, name = "Galvangar" },
                { x = 0.473, y = 0.868, name = "Drek'Thar" },
                { x = 0.549, y = 0.873, name = "Horde LZ" }, -- front of cave
                { x = 0.554, y = 0.882, name = "Horde LZ" }, -- mid cave
                { x = 0.563, y = 0.892, name = "Horde LZ" }, -- res pt
                { x = 0.536, y = 0.075, name = "Alliance LZ" }, -- front of cave
                { x = 0.536, y = 0.075, name = "Alliance LZ" }, -- res pt
                { x = 0.489, y = 0.147, name = "Stormpike Graveyard" },
                { x = 0.508, y = 0.145, name = "Stormpike Graveyard" }, -- res pt
                { x = 0.428, y = 0.157, name = "Stormpike Aid Station" },
                { x = 0.411, y = 0.156, name = "Stormpike Aid Station" }, -- res pt
                { x = 0.449, y = 0.914, name = "Frostwolf Relief Hut" },
                { x = 0.449, y = 0.914, name = "Frostwolf Relief Hut" }, -- res pt
                { x = 0.501, y = 0.767, name = "Frostwolf Graveyard" },
                { x = 0.481, y = 0.771, name = "Frostwolf Graveyard" }, -- res pt
                { x = 0.514, y = 0.600, name = "Iceblood Graveyard" },
                { x = 0.515, y = 0.571, name = "Iceblood Graveyard" }, -- res pt
                { x = 0.446, y = 0.455, name = "Snowfall Graveyard" },
                { x = 0.414, y = 0.440, name = "Snowfall Graveyard" }, -- res pt
                { x = 0.515, y = 0.357, name = "Stonehearth Graveyard" }, 
                { x = 0.537, y = 0.358, name = "Stonehearth Graveyard" }, -- res pt
              } ;

local function get_score()
  if (AlwaysUpFrame1Text == nil) or (AlwaysUpFrame2Text == nil) then
    return 500, 500 ;
  end
  local line1 = AlwaysUpFrame1Text:GetText() ;
  local line2 = AlwaysUpFrame2Text:GetText() ;
  if (line1 == nil) or (line2 == nil) then
    return scores["alliance"], scores["horde"] ;
  end
  local ally  = tonumber(line1:match( "Reinforcements: (%d+)" )) ;
  local horde = tonumber(line2:match( "Reinforcements: (%d+)" )) ;
  return ally or 500, horde or 500 ;
end

local function utimer_init_AV()
  if (_init) then
    return ;
  end
  graveyards = {} ;
  towers     = {} ;
  local nMarks = GetNumMapLandmarks() ;
  local i, v ;
  for i=1, nMarks, 1 do
    local name, _, textureIndex = GetMapLandmarkInfo(i)
    if name and textureIndex then
      local _state = state[textureIndex] ;
      if (poi[textureIndex] == "gy") then
        if (_state == 1) then
          if (oq._player_faction == "A") then
            oq.utimer_start( name, "alliance", 15, 30, 3 ) ; -- alliance graveyard timer
          else
            if (OQ_data.show_controlled == 1) then
              oq.utimer_start( name, "alliance", 15, 30, 4, true ) ; -- enemy held node
            else
              textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
            end
          end
        elseif (_state == 2) then
          if (oq._player_faction == "H") then
            oq.utimer_start( name, "horde", 13, 30, 3 ) ; -- horde graveyard timer
          else
            if (OQ_data.show_controlled == 1) then
              oq.utimer_start( name, "alliance", 13, 30, 4, true ) ; -- enemy held node
            else
              textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
            end
          end
        end
        graveyards[i] = textureIndex ;
      elseif (poi[textureIndex] == "tower") then
        if (_state == 1) then  -- alliance controlled tower
          if (OQ_data.show_controlled == 1) then
            oq.utimer_start( name, "alliance", textureIndex, 30, 4, true ) ;
          else
            textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
          end
        elseif (_state == 2) then  -- horde controlled tower
          if (OQ_data.show_controlled == 1) then
            oq.utimer_start( name, "horde", textureIndex, 30, 4, true ) ; 
          else
            textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
          end
        elseif (_state == 3) then  -- alliance capping tower
          oq.utimer_start( name, "alliance", textureIndex, 30, 1 ) ; 
        elseif (_state == 4) then  -- horde capping tower
          oq.utimer_start( name, "horde", textureIndex, 30, 1 ) ; 
        end
        towers[i] = textureIndex ;
      end
    end
  end
  
  -- show bosses; this way we can see the count of our ppl in the area/defending
  for i,v in pairs(bosses) do
    oq.utimer_start( v.name, v.faction, v.texture, 30, 5 ) ; -- node
  end

  -- initialize score  
  scores["horde"   ] = 500 ;
  scores["alliance"] = 500 ;
  scores["tm"      ] = 0 ;

  units = {} ;
  oq._boss_compare = oq.av_boss_compare ;
  
  -- initialized
  _init = 1 ; 
end

local GRAVEYARD_RANGE  = 0.01 ;
local NODE_RANGE       = 0.015 ;
                  
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

local function av_get_current_loc()
  local x, y = GetPlayerMapPosition("player") ; 
  local loc = get_location_name( x, y, nodes, NODE_RANGE ) or "" ;
  print( "location: Alterac Valley @ ".. floor(x*1000)/1000 .." , ".. floor(y*1000)/1000 .."    ".. loc ) ;
end

local dead_count = {} ;
local node_count = {} ;

local function check_ressers()
  if (WorldMapFrame:IsVisible()) then
    return ;
  end
  -- Grab our data
  dead_count = {} ;
  node_count = {} ;
  local i, v ;
  for i=1,GetNumGroupMembers() do
    local name = GetUnitName( "raid".. i, true ) ;
    local hp = UnitHealth( "raid".. i ) ;
    if (units[name] ~= nil) and (units[name] <= 1) and (hp > 1) then
      -- ressed 
      local x, y = GetPlayerMapPosition( "raid" .. i );
      local loc = get_location_name( x, y, nodes, NODE_RANGE ) ;
      oq.utimer_reset_cycle( loc ) ;
      if (loc) then
        node_count[ loc ] = (node_count[loc] or 0) + 1 ;
      end
    elseif (units[name] ~= nil) and (units[name] <= 1) then
      -- dead waiting to res.  which graveyard?
      local x, y = GetPlayerMapPosition( "raid" .. i );
      local loc = get_location_name( x, y, nodes, NODE_RANGE ) ;
      if (loc) then
        dead_count[ loc ] = (dead_count[loc] or 0) + 1 ;
      end
    else
      -- alive, which node?
      local x, y = GetPlayerMapPosition( "raid" .. i );
      local loc = get_location_name( x, y, nodes, NODE_RANGE ) ;
      if (loc) then
        node_count[ loc ] = (node_count[loc] or 0) + 1 ;
      end
    end
    units[name] = hp ;
  end
  -- set count on cycle timers
  for i,v in pairs(oq._utimers) do
    if (v._start ~= 0) then
      v._count = node_count[ v.label:GetText() ] ; 
      v._dead  = dead_count[ v.label:GetText() ] ; 
    end
  end  
  
  dead_count = {} ; -- clean it out
  node_count = {} ; -- clean it out
end

local function check_captains()
  local a, h = get_score() ;
  local da = scores["alliance"] - a ;
  local dh = scores["horde"   ] - h ;

  -- if captain dies, 100 resources are lost.  
  -- must also allow for some players to die in the same time interval
  -- a tower is 75... losing a tower and 25+ players in 1-2 seconds is highly unlikely

  if (dh >= 100) and (dh <= 125) and (h > 0) then
    -- galv died
    oq.utimer_stop( bosses["galv"].name, 5 ) ;
  end
  if (da >= 100) and (da <= 125) and (a > 0) then
    -- bal died
    oq.utimer_stop( bosses["bal"].name, 5 ) ;
  end
  scores["horde"   ] = h ;
  scores["alliance"] = a ;
end

local function av_utimer_check()
  if (WorldMapFrame:IsVisible()) then
    return ;
  end
  
  utimer_init_AV() ;
  
  local k, v ;
  for k,v in pairs(graveyards) do
    local name, _, textureIndex = GetMapLandmarkInfo(k)
    if name and textureIndex then
      if name == "Friedhof des Sturmlanzen" then
        name = "Friedhof der Sturmlanzen"
      end
      local _state = state[textureIndex] ;
      if _state and (state[v] ~= _state) then
        if (_state == 1) then
          -- alliance controlled
          oq.utimer_stop( name, -1 ) ; -- stop all timers for this node
          if (oq._player_faction == "A") then
            oq.utimer_start( name, "alliance", 15, 30, 3 ) ; -- alliance graveyard timer
          else
            if (OQ_data.show_controlled == 1) then
              oq.utimer_start( name, "alliance", textureIndex, 30, 4, true ) ; -- enemy node
            else
              textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
            end
          end
        elseif (_state == 2) then
          -- horde controlled
          oq.utimer_stop( name, -1 ) ; -- stop all timers for this node
          if (oq._player_faction == "H") then
            oq.utimer_start( name, "horde", 13, 30, 3 ) ; -- graveyard timer
          else
            if (OQ_data.show_controlled == 1) then
              oq.utimer_start( name, "horde", textureIndex, 30, 4, true ) ; -- enemy node
            else
              textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
            end
          end
        elseif (_state == 3) then
          -- alliance capping
          oq.utimer_stop( name, -1 ) ; -- stop all timers for this node
          oq.utimer_start( name, "alliance", textureIndex, 4*60, 1 ) ;
        elseif (_state == 4) then
          -- horde capping
          oq.utimer_stop( name, -1 ) ; -- stop all timers for this node
          oq.utimer_start( name, "horde", textureIndex, 4*60, 1 ) ;
        end
      end
      graveyards[k] = textureIndex
    end		 
  end

  for k,v in pairs(towers) do
    local name, _, textureIndex = GetMapLandmarkInfo(k)
    if name and textureIndex then
      local _state = state[textureIndex] ;
      if _state and (state[v] ~= _state) then
        oq.utimer_stop( name, -1 ) ; -- could be backcapped, capping, or destroyed; -1 == stop all timer bars
        if (_state == 1) then
          -- alliance controlled
          oq.utimer_stop( name, 1 ) ; -- stop capping timer
          if (OQ_data.show_controlled == 1) then
            oq.utimer_start( name, "alliance", textureIndex, 30, 4, true ) ; -- node
          else
            textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
          end
        elseif (_state == 2) then
          -- horde controlled
          oq.utimer_stop( name, 1 ) ; -- stop capping timer
          if (OQ_data.show_controlled == 1) then
            oq.utimer_start( name, "horde", textureIndex, 30, 4, true ) ; -- node
          else
            textureIndex = 0 ; -- allows for 'flipping' of show_controlled while in-game
          end
        elseif (_state == 3) then
          -- alliance capping
          oq.utimer_stop( name, 4 ) ; 
          oq.utimer_start( name, "alliance", textureIndex, 4*60, 1 ) ;
        elseif (_state == 4) then
          -- horde capping
          oq.utimer_stop( name, 4 ) ; 
          oq.utimer_start( name, "horde", textureIndex, 4*60, 1 ) ;
        end
      end
      towers[k] = textureIndex
    end		 
  end
  
  if (oq.utimer_find("Alliance LZ") == nil) and (oq._player_faction == "A") then
    oq.utimer_start( "Alliance LZ", "alliance", 15, 30, 3 ) ;
  end
  if (oq.utimer_find("Horde LZ") == nil) and (oq._player_faction == "H") then
    oq.utimer_start( "Horde LZ", "horde", 13, 30, 3 ) ;
  end
          
  check_ressers() ;  
  check_captains() ;
end

local boss_order = { ["Vanndar"  ] = 1,
                     ["Balinda"  ] = 2,
                     ["Drek'Thar"] = 3,
                     ["Galvangar"] = 4,
                   } ;                     
                     
function av_boss_compare( a, b )
  if (a == nil) then
    return false ;
  elseif (b == nil) then
    return true ;
  end
  return (boss_order[ oq._utimers[a].label:GetText() ] < boss_order[ oq._utimers[b].label:GetText() ]) ;
end

-- sort: alpha by faction
function av_compare_controlled( a, b )
  if (a == nil) then
    return false ;
  elseif (b == nil) then
    return true ;
  end
  if (oq._utimers[b]._faction ~= oq._utimers[a]._faction) then
    return oq._utimers[a]._faction == "alliance" ;
  end
  return (oq._utimers[a].label:GetText() < oq._utimers[b].label:GetText()) ;
end

local function av_shuffle()
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
      elseif (v._type == 5) then
        table.insert(oq._utimer_bosses, i) ;
      end
    end
  end  
  
  -- bosses
  n = 0 ;
  table.sort(oq._utimer_bosses, av_boss_compare) ;  
  for i,v in pairs(oq._utimer_bosses) do
    oq.setpos( oq._utimers[v], x, y, cx, cy ) ;
    y = y + cy ;
    n = n + 1 ;
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
  
  -- controlled nodes
  if (n > 0) then
    y = y + cy ;
  end
  n = 0 ;
  table.sort(oq._utimer_controlled, av_compare_controlled) ;  
  for i,v in pairs(oq._utimer_controlled) do
    oq.setpos( oq._utimers[v], x, y, cx, cy ) ;
    y = y + cy ;
    n = n + 1 ;
  end
  
  -- graveyards
  if (n > 0) then
    y = y + cy ;
  end
  table.sort(oq._utimer_gys, oq.utimer_compare_alpha) ;  
  for i,v in pairs(oq._utimer_gys) do
    oq.setpos( oq._utimers[v], x, y, cx, cy ) ;
    y = y + cy ;
  end
end

local function av_test_1()
print( "av test 1" ) ;
  oq.utimer_stop_all() ; -- clear out existing timers
end

local function av_test_2()
print( "av test 2" ) ;
  oq.utimer_stop_all() ; -- clear out existing timers
  local t ;
--  t = oq.utimer_start( "Lumber Mill", "horde"   , 24, 1*60, 1 ) ; -- horde capping lumbermill
end

local function av_start()
  -- av started
end

local function av_test( arg1 )
print( "av test" ) ;
  if (arg1 == nil) or (arg1 == "1") then
    av_test_1() ;
  elseif (arg1 == "2") then
    av_test_2() ;
  end
end

local function av_close()
  _init      = nil ;
  graveyards = {} ;
  towers     = {} ;
  oq.utimer_stop_all() ;
  oq._boss_compare = nil ;
end

local function av_show_control( show )
  if (show == 1) then
    av_utimer_check() ;
  else
    oq.utimer_stop( nil, 4 ) ; -- clear controlled towers
    local i, v ;
    for i,v in pairs(graveyards) do
      if (state[v] == 1) or (state[v] == 2) then
        graveyards[i] = 0 ;
      end
    end
    for i,v in pairs(towers) do
      if (state[v] == 1) or (state[v] == 2) then
        towers[i] = 0 ;
      end
    end
  end
end

-- hook 
if (oq._bg_checks == nil) then
  oq._bg_checks = {} ;
end
oq._bg_checks["AV"] = { check           = av_utimer_check, 
                        close           = av_close,
                        shuffle         = av_shuffle,
                        start           = av_start,
                        loc             = av_get_current_loc,
                        test            = av_test,
                        show_controlled = av_show_control 
                      } ;



