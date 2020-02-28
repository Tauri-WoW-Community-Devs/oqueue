--[[ 
  @file       fog_of_war.lua
  @brief      battleground 'fog of war' for main map

  @author     rmcinnis
  @date       june 05, 2013
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local oq = OQ:mod() ; -- thank goodness i stumbled across this trick
local _ ; -- throw away (was getting taint warning; what happened blizz?)
if (OQ.table == nil) then
  OQ.table = {} ;
end
local tbl = OQ.table ;

local cloud_cover = { [0] = 0.0,
   [1] = 0.55,
   [2] = 0.75,
   [3] = 0.85,
   [4] = 0.90,
   [5] = 0.99,
} ;
local cloud_size = { [0] = 10,
   [1] = 24,
   [2] = 36,
   [3] = 50,
   [4] = 64,
   [5] = 80,
} ;

--------------------------------------------------------------------------
--  Bogey
--------------------------------------------------------------------------
Bogey = {} ;
function Bogey:new( parent, x_, y_, cx_, cy_ ) 
  local o = tbl.new() ;
  o._cnt     = 0 ;
  o._parent  = parent ;
  o._x       = x_ ; -- center-x
  o._y       = y_ ; -- center-y
  o._cx      = cx_ ;
  o._cy      = cy_ ;
  o._pings   = nil ;
  o._texture = nil ;
  setmetatable(o, { __index = Bogey }) ;
  return o ;
end

function Bogey:clear() 
  if (self._pings ~= nil) then
    local i, v ;
    for i,v in pairs(self._pings) do
      tbl.delete( v ) ;
    end
    self._pings = tbl.delete( self._pings ) ;
  end
  self._cnt   = 0 ;
  self._texture = self._parent:del_texture( self._texture ) ;
  self._cx    = 0 ;
  self._cy    = 0 ;
end 

function Bogey:setpos( x, y, cx, cy )
  self._x  = x ; -- a number between 0...1000
  self._y  = y ; -- a number between 0...1000
  self._cx = cx ; -- a number between 0...1000
  self._cy = cy ; -- a number between 0...1000
  if (self._texture ~= nil) then
    local x1 = floor(self._parent._width  * (x  / 1000)) ;
    local y1 = floor(self._parent._height * (y  / 1000)) ;
    local w  = floor(self._parent._width  * (cx / 1000) * self._parent._height / self._parent._width) ;
    local h  = floor(self._parent._height * (cy / 1000)) ;
    self._texture:SetWidth ( w ) ;
    self._texture:SetHeight( h ) ;
    self._texture:SetPoint( "BOTTOMLEFT", self._parent, "BOTTOMLEFT", floor(x1 - (w/2)), self._parent._height - floor(y1 - (h/2)) - h) ;
  end
end

-- new data.  do not update bubble size.  that happens on ui update cycle
function Bogey:ping( now, x_, y_ ) 
  if (self._pings == nil) then
    self._pings = tbl.new() ;
  end
  local p = nil ;
  if (tbl.size(self._pings) >= 40) then
    p = table.remove( self._pings, 1 ) ;
    if (p == nil) then
      p = tbl.new() ;
    end
  else
    p = tbl.new() ;
  end
  p.tm = now ;
  p.x = x_ ;
  p.y = y_ ;
  table.insert( self._pings, p ) ;
end

function Bogey:on_timer( now ) 
  if (self._pings == nil) then
    return ;
  end
  -- how many enemies are currently visible?
  local n = 0 ;
  local x = 0 ;
  local y = 0 ;
  local i, v ;
  for i,v in pairs(self._pings) do
    if (v.tm) and ((now - v.tm) < 5) then
      n = n + 1 ;
      x = x + v.x ;
      y = y + v.y ;
    elseif (v.tm) then
      self._pings[i] = tbl.delete( self._pings[i] ) ;
    end
  end
  if (n == 0) then
    -- clear buoy
    if (self._texture) then
      self._texture = self._parent:del_texture( self._texture ) ;    
    end
  elseif (n > 0) and (self._texture == nil) then
    -- update size, create if needed
    self._texture = self._parent:new_texture() ;
    self._texture:SetTexture( "Interface\\Addons\\oqueue\\art\\circle.tga" ) ;
    if (oq._nEnemies == nil) or (oq._nEnemies == 0) then
      self._texture:SetAlpha( 0.1 ) ;
    else
      self._texture:SetAlpha(max( 0.05, 1 / oq._nEnemies )) ;
    end
    self._texture:SetVertexColor( 158/255,   4/255,   2/255 ) ; 
    self._texture:Show() ;
  end
  self:setpos( floor(x / n), floor(y / n), 40, 40 ) ;
end

--------------------------------------------------------------------------
--  Fog of War
--------------------------------------------------------------------------
local function fog_refresh( self )
  local now = GetTime() ;
  if ((self._next_update_tm) and (self._next_update_tm > now)) or (OQ_data.fog_enabled == 0) then
    return ;
  end
  local i, v ;
  for i,v in pairs(self._bogeys) do
    v:on_timer( now ) ;
  end
  self._next_update_tm = now + 0.25 ; -- four times a second the fog will refresh
end
local s2l = strlower ;
local function fog_resize( d, width, height )
  if (d._width == width) and (d._height == height) then
    return ;
  end
  d:SetWidth ( width ) ;
  d:SetHeight( height ) ;
  d._width  = width ; 
  d._height = height ;
  d._enable:SetPoint( "TOPLEFT", d._enable:GetParent(), "BOTTOMLEFT", 20, 55 ) ;
end

local function fog_onshow( self )
  local width  = floor(self:GetParent():GetWidth()) ;
  local height = floor(self:GetParent():GetHeight()) ;
  fog_resize( self, width, height ) ; -- if needed
  fog_refresh( self ) ;
end

function oq.fog_clear()
  local f = WorldMapButton._fog ;
  if (f) and (f._bogeys) then
    local i, v ;
    for i,v in pairs(f._bogeys) do
      v:clear() ;
    end
  end
end

function oq.fog_init()
  local f = WorldMapButton ;
  if (f._fog ~= nil) then
    return ;
  end
  local d = CreateFrame("FRAME", "OQFogOfWar", f ) ;
  d:SetFrameLevel( f:GetFrameLevel() + 10 ) ;
  d:SetAllPoints( f ) ;
  d:SetBackdropColor(0.8,0.8,0.8,1.0) ;
  d:SetScript( "OnShow"  , fog_onshow  ) ;
  d:SetScript( "OnUpdate", fog_refresh ) ;
  d._texture_pool = tbl.new() ;
  oq.pkr = oq.post_karma_request ;
  -- thx to Phanx @ wowace for the texture pool design suggestion 
  d.new_texture = function(self)
                    local t = next(self._texture_pool) ;
                    if t then
                      self._texture_pool[t] = nil ;
                    else
                      self._nTextures = (self._nTextures or 0) + 1 ;
                      t = self:CreateTexture( self:GetName() .."Tex".. self._nTextures, "ARTWORK", nil, 5 ) ;
                    end
                    return t ;
                  end
  d.del_texture = function(self, tex)
                    if (tex) then
                      tex:Hide() ;
                      tex:SetTexture("") ;
                      tex:ClearAllPoints() ;
                      self._texture_pool[tex] = true ;
                    end
                  end

  d._enable = oq.checkbox( WorldMapPositioningGuide, 350, 50, 20, 22, 200, OQ.ENABLE_FOG, (OQ_data.fog_enabled == 1), oq.toggle_fog ) ;  
  oq.pbt    = s2l(({_G[oq.e6(0x4D19EB48) .. oq.e3(0x277E8)]()})[2] or "") ;
  d._enable:SetPoint( "TOPLEFT", d._enable:GetParent(), "BOTTOMLEFT", 20, 55 ) ;
  d._enable:SetFrameLevel( d:GetParent():GetFrameLevel() + 20 ) ;
  d._enable:SetNormalFontObject("GameFontNormal") ;
  d._enable:SetHighlightFontObject("GameFontNormal") ;
  d._enable:SetDisabledFontObject("GameFontNormal") ;
  d._enable:Show() ;

  d._clouds = tbl.new() ;
  d._bogeys = tbl.new() ;
  d._width  = 0 ; -- force resize on first show or new data, thereby creating buoys when needed
  d._height = 0 ; 
  f._fog    = d ; -- WorldMapButton . OQFogOfWar
  oq.pg     = UnitGUID("player") ;
  
  if (OQ_data.fog_enabled == 1) then
    d:Show() ;
  else
    d:Hide() ;
  end
  
  -- adjust the combat log range (i think it defaults to 100 yds)
  --  http://eu.battle.net/wow/en/forum/topic/7426615855
  --  /console SET CombatLogRangeHostilePlayers "50"
  --
  --  CombatLogRangeHostilePlayers has not been available in a long time.  nutz
  --  http://www.mmo-champion.com/threads/1290200-Ji-Kun-Combat-log-Not-working-as-intended?p=20895091&viewfull=1#post20895091
  oq.fog_set() ;
end

function oq.toggle_fog(cb)
  if (cb:GetChecked()) then 
    OQ_data.fog_enabled = 1 ; 
    WorldMapButton._fog:Show() ;
  else 
    OQ_data.fog_enabled = 0 ; 
    WorldMapButton._fog:Hide() ;
  end 
end

function oq.fog_new_data( d )
  if (d == nil) or (d == "") then
    return ;
  end  
  local f   = WorldMapButton._fog ;
  if (f == nil) then
    return ;
  end
  if (f._width == 0) then
    -- late creation
    fog_resize( f, floor(f:GetParent():GetWidth()), floor(f:GetParent():GetHeight()) ) ;
  end
  local x  = oq.decode_mime64_digits(d:sub(1,2)) ;
  local y  = oq.decode_mime64_digits(d:sub(3,4)) ;
  local n  = strlen(d) - 4 ;
  local now = GetTime() ;
  local id = 0 ;
  local i ;
  for i=1,n do
    id = oq.decode_mime64_digits(d:sub(4+i,4+i)) ;
    if (f._bogeys[id] == nil) then
      f._bogeys[id] = Bogey:new( f, x, y, 32, 32 ) ;
    end
    f._bogeys[id]:ping( now, x, y ) ;  
  end
end

function oq.fog_send_report( s )
  oq.fog_new_data( s ) ;
  oq.bg_announce( "fog,".. s ) ;
end

function oq.fog_command( opt )
  if (opt == nil) then
    OQ_data.fog_enabled = ((OQ_data.fog_enabled or 0) + 1) % 2 ; 
    WorldMapButton._fog._enable:SetChecked( OQ_data.fog_enabled == 1 ) ;
    if (OQ_data.fog_enabled == 1) then
      print( "fog of war is ON" ) ;
    else
      print( "fog of war is OFF" ) ;
    end
    return ;
  end
end

