--[[ 
  @file       oqueue_tables.lua
  @brief      oqueue's table functions

  @author     rmcinnis
  @date       april 07, 2014
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered.  
              no modifications are allowed even for personal use.
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local L = OQ._T ; -- for literal string translations
local tbl = OQ.table ;

function tbl.clear(t, deep)
  if (t) then
    if (deep) then
      local k ;
      for k in pairs(t) do 
        if (type(t[k]) == "table") then
          tbl.delete( tbl.clear( t[k], deep ) ) ;    -- clear sub tables and be able to reclaim
        end
        t[k] = nil ;
      end
    else
      wipe(t) ;
    end
  end
  return t ;
end

function tbl.copy( src, dest, clear_first )
  if (dest == nil) then
    dest = tbl.new() ;
  end
  if (clear_first) then
    tbl.clear( dest, true ) ;
  end
  local i, v ;
  for i,v in pairs(src) do
    if (type(v) == "table") then
      dest[i] = tbl.copy( v, dest[i] ) ;
    else
      dest[i] = v ;
    end
  end
  return dest ;
end

function tbl.delete(t, deep)
  if (t) and (type(t) == "table") then
    tbl.clear(t, deep) ;
    if (tbl._watchlist == nil) then
      tbl._watchlist = tbl.new() ;
    end
    if (tbl._watchlist[t]) then
      print( debugstack() ) ;
      print( L["**warning:  returning watched table  "].. tostring(t) ) ;
    end
    tbl.__inuse[t] = nil ;
    tbl.push( tbl.__pool, t ) ;  
  end
  return nil ;
end

function tbl.dump( t, s ) 
   local i,v ;
   for i,v in pairs(t) do
      if (type(v) == "table") then
         tbl.dump( v, (s or "") .. "-" ) ;
      else
         print( (s or "") .." ".. tostring(i) ..": ".. tostring(v) ) ;
      end      
   end   
end

function tbl.fill( t, ... )
  if (t) then
    if (tbl._watchlist[t]) then
      print( debugstack() ) ;
      print( L["**warning:  watched table found  "].. tostring(t) ) ;
    end
    tbl.clear(t) ;
    local i ;
    for i = 1,select('#', ... ) do
      t[i] = select(i, ...) ;
    end
  end
end

function tbl.fill_match( t, str, ch )
  tbl.clear(t, true) ;
  if (str == nil) then return ; end   
  local n  = 0 ;
  local p1 = 0 ;
  local p2 = 1 ; 
  while (p2 ~= nil) do
    p2 = str:find( ch, p1, true ) ;
    n = n + 1;
    t[n] = str:sub( p1, (p2 or 0)-1  ) ;
    if (p2) then
      p1 = p2+1 ;
    end      
  end
  return n ;
end

function tbl.find_keybyvalue(t, v)
  if (t) and (v) then
    local key, val ;
    for key,val in pairs(t) do
      if (val == v) then
        return key ;
      end
    end
  end
  return nil ;
end

function tbl.init() 
  tbl._watchlist = tbl.new() ;
end

function tbl.new()
  if (tbl.__pool == nil) then
    tbl.__pool = {} ;
  end
  if (tbl.__inuse == nil) then
    tbl.__inuse = {} ;
  end
  local ndx = tbl.next(tbl.__pool) ;
  local t = nil ;
  if (ndx) then
    t = tbl.__pool[ndx] ;
    tbl.__pool[ndx] = nil ;
  else
    t = {} 
    tbl._count = (tbl._count or 0) + 1 ;
  end
  if (tbl.__inuse[t]) then
    print( debugstack() ) ;
    print( "**warning:  re-issued active table:  ".. tostring(t) ) ;
  end

  tbl.__inuse[t] = 1 ;
  return t ;
end

function tbl.next(t)
  if (t) then
    local i, v ;
    for i,v in pairs(t) do
      if (i ~= 0) then
        return i ;
      end
    end
  end
  return nil ;
end

function tbl.push(t,v)
  if (t) and (v) then
    tbl.__ticker = (tbl.__ticker or 0) + 1 ;
    t[tbl.__ticker] = v ;
  end
end

function tbl.size(t)
  if (t == nil) then
    return nil ;
  end
  local n = 0 ;
  local i, v ;
  for i,v in pairs(t) do
    n = n + 1 ;
  end
  return n ;
end

function tbl.watch( t )
  tbl._watchlist[t] = 1 ;
end

function tbl.unwatch( t )
  tbl._watchlist[t] = nil ;
end

function tbl.__genOrderedIndex( t, orderedIndex )
  if (orderedIndex == nil) then
    orderedIndex = tbl.new() ;
  else
    tbl.clear(orderedIndex) ;
  end
  local key ;
  for key in pairs(t) do
    table.insert( orderedIndex, key )
  end
  table.sort( orderedIndex )
  return orderedIndex
end

function tbl.orderedNext(t, state)
  -- Equivalent of the next function, but returns the keys in the alphabetic
  -- order. We use a temporary ordered key table that is stored in the
  -- table being iterated.

  if state == nil then
    -- the first time, generate the index
    t.__orderedIndex = tbl.__genOrderedIndex( t, t.__orderedIndex )
    local key = t.__orderedIndex[1]
    return key, t[key]
  end
  -- fetch the next value
  local key = nil
  local i ;
  for i = 1,table.getn(t.__orderedIndex) do
    if t.__orderedIndex[i] == state then
      key = t.__orderedIndex[i+1]
    end
  end

  if key then
    return key, t[key]
  end

  -- no more value to return, cleanup
  t.__orderedIndex = tbl.delete( t.__orderedIndex ) ;
  return
end

function tbl.__genOrderedValue( t, orderedIndex )
  if (orderedIndex == nil) then
    orderedIndex = tbl.new() ;
  else
    tbl.clear(orderedIndex) ;
  end
  local key, value ;
  for key, value in pairs(t) do
    table.insert( orderedIndex, value )
  end
  table.sort( orderedIndex )
  return orderedIndex
end

function tbl.orderedByValueNext(t, state)
  -- Equivalent of the next function, but returns the keys in the alphabetic
  -- order. We use a temporary ordered key table that is stored in the
  -- table being iterated.
  local key = nil ;
  local i, n ;
  if state == nil then
    -- the first time, generate the index
    t.__orderedIndex = tbl.__genOrderedValue( t, t.__orderedIndex )
    key = tbl.find_keybyvalue( t, t.__orderedIndex[1] ) ;
    return key, t.__orderedIndex[1] ;
  end
  -- fetch the next value
  for i = 1,table.getn(t.__orderedIndex) do
    if t.__orderedIndex[i] == t[state] then
      key = tbl.find_keybyvalue( t, t.__orderedIndex[i+1] ) ;
      n = i+1 ;
    end
  end

  if key then
    return key, t.__orderedIndex[n] ;
  end

  -- no more value to return, cleanup
  t.__orderedIndex = tbl.delete( t.__orderedIndex ) ;
  return
end

function tbl.orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return tbl.orderedNext, t, nil
end

function tbl.orderedByValuePairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return tbl.orderedByValueNext, t, nil
end

