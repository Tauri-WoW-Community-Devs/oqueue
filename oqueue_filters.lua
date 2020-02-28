--[[ 
  @file       oqueue_chat_filter.lua
  @brief      chat filter functions for oqueue

  @author     rmcinnis
  @date       april 06, 2012
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local L = OQ._T ; -- for literal string translations
local oq = OQ:mod() ; -- thank goodness i stumbled across this trick
local _ ; -- throw away (was getting taint warning; what happened blizz?)

function oq.chat_filter(self, event, msg, author, ...)
  if (oq.is_oqueue_msg( msg )) then
    -- make sure 'author' is bn.enabled
    return true ;
  end
  
  local now = GetTime() ;
  if ((msg == L["You aren't in a party."]) and (now < oq._error_ignore_tm)) then 
    -- ignore message
--    return true ;   
  end

  -- hide error msg if scorekeeper is temporarily offline or being ignored
  if (msg:find( "No player named '".. OQ.SK_NAME .."' is currently playing") ~= nil) or
     ((msg:find( OQ.SK_NAME) ~= nil) and (msg:find( "is no longer being ignored" ) ~= nil)) then 
    -- ignore message
    return true ;   
  end
  
  -- remove duplicate afk msgs
  if (oq._last_afkmsg == nil) then
    oq._last_afkmsg = 0 ;
  end
  if ((msg:find( OQ.SYS_YOUARE_AFK ) ~= nil) or
     (msg:find( OQ.SYS_YOUARENOT_AFK ) ~= nil)) then
    if ((now - oq._last_afkmsg) < 15) then
      -- remove msg
      oq._last_afkmsg = now ;
      return true ;
    end
    oq._last_afkmsg = now ;
  end
  
  -- b-net spam 
  if (msg:find( "is not online" ) ~= nil) then
    return true ;
  end
--   return false, msg, author, ...
end

