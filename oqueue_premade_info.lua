--[[ 
  @file       oqueue_premade_info.lua
  @brief      functions to gather up premade info for the leader

  @author     rmcinnis
  @date       april 06, 2012
  @copyright  Solid ICE Technologies
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;
local oq = OQ:mod() ; -- thank goodness i stumbled across this trick
local L = OQ._T ; -- for literal string translations
local _ ; -- throw away (was getting taint warning; what happened blizz?)

-- list of achieves in links:  http://mmo4ever.com/mists-of-pandaria/achievement.php?id=5359
--
OQ.rbg_rank = { [  0 ] = { id =    0, str =     "", rank = "" },
                [  1 ] = { id = 5345, str = "1100", rank = OQ.RBG_HRANK_1 },
                [  2 ] = { id = 5346, str = "1200", rank = OQ.RBG_HRANK_2 },
                [  3 ] = { id = 5347, str = "1300", rank = OQ.RBG_HRANK_3 },
                [  4 ] = { id = 5348, str = "1400", rank = OQ.RBG_HRANK_4 },
                [  5 ] = { id = 5349, str = "1500", rank = OQ.RBG_HRANK_5 },
                [  6 ] = { id = 5350, str = "1600", rank = OQ.RBG_HRANK_6 },
                [  7 ] = { id = 5351, str = "1700", rank = OQ.RBG_HRANK_7 },
                [  8 ] = { id = 5352, str = "1800", rank = OQ.RBG_HRANK_8 },
                [  9 ] = { id = 5338, str = "1900", rank = OQ.RBG_HRANK_9 },
                [ 10 ] = { id = 5353, str = "2000", rank = OQ.RBG_HRANK_10 },
                [ 11 ] = { id = 5354, str = "2100", rank = OQ.RBG_HRANK_11 },
                [ 12 ] = { id = 5355, str = "2200", rank = OQ.RBG_HRANK_12 },
                [ 13 ] = { id = 5342, str = "2300", rank = OQ.RBG_HRANK_13 },
                [ 14 ] = { id = 5356, str = "2400", rank = OQ.RBG_HRANK_14 },
                [ 15 ] = { id = 5330, str = "1100", rank = OQ.RBG_ARANK_1 },
                [ 16 ] = { id = 5331, str = "1200", rank = OQ.RBG_ARANK_2 },
                [ 17 ] = { id = 5332, str = "1300", rank = OQ.RBG_ARANK_3 },
                [ 18 ] = { id = 5333, str = "1400", rank = OQ.RBG_ARANK_4 },
                [ 19 ] = { id = 5334, str = "1500", rank = OQ.RBG_ARANK_5 },
                [ 20 ] = { id = 5335, str = "1600", rank = OQ.RBG_ARANK_6 },
                [ 21 ] = { id = 5336, str = "1700", rank = OQ.RBG_ARANK_7 },
                [ 22 ] = { id = 5337, str = "1800", rank = OQ.RBG_ARANK_8 },
                [ 23 ] = { id = 5359, str = "1900", rank = OQ.RBG_ARANK_9 },
                [ 24 ] = { id = 5339, str = "2000", rank = OQ.RBG_ARANK_10 },
                [ 25 ] = { id = 5340, str = "2100", rank = OQ.RBG_ARANK_11 },
                [ 26 ] = { id = 5341, str = "2200", rank = OQ.RBG_ARANK_12 },
                [ 27 ] = { id = 5357, str = "2300", rank = OQ.RBG_ARANK_13 },
                [ 28 ] = { id = 5343, str = "2400", rank = OQ.RBG_ARANK_14 },
              } ;

function oq.has_completed( achieve_id )
  return (achieve_id ~= nil) and (achieve_id > 0) and (GetStatistic( achieve_id ) ~= "--") ;
end

function oq.has_achieved( achieve_id )
  return (achieve_id ~= nil) and (achieve_id > 0) and (select( 4, GetAchievementInfo( achieve_id )) == true) ;
end

function oq.pve_group_wiped()
  if (oq.raid.type == OQ.TYPE_DUNGEON) then
    OQ_data.leader["pve.5man"].nWipes = (OQ_data.leader["pve.5man"].nWipes or 0) + 1 ;
  elseif (oq.raid.type == OQ.TYPE_RAID) then
    OQ_data.leader["pve.raid"].nWipes = (OQ_data.leader["pve.raid"].nWipes or 0) + 1 ;
  elseif (oq.raid.type == OQ.TYPE_CHALLENGE) then
    OQ_data.leader["pve.challenge"].nWipes = (OQ_data.leader["pve.challenge"].nWipes or 0) + 1 ;
  end
  local dt = oq.utc_time() - oq._instance_tm ;
  print( "wipe detected @ ".. tostring(floor(dt/60)) ..":".. tostring(floor(dt%60)) ) ;
end

function oq.check_for_wipe() 
  if (not oq.iam_raid_leader()) or (oq._inside_instance == nil) or ((oq._instance_type ~= "party") and (oq._instance_type ~= "raid")) then
    return ;
  end
  local hp = UnitHealth("player") ;
  if (hp > 0) then
    oq._wiped = nil ;
    return ;
  end
  local nMembers = GetNumGroupMembers() ;
  local type = "party" ;
  if (IsInRaid()) then
    type = "raid" ;
  end

  local i ;
  for i=1,nMembers-1 do
    if (UnitHealth( type .."".. tostring(i) ) > 0) then
      oq._wiped = nil ;
      return ;
    end
  end
  
  -- if here, group has wiped
  if (oq._wiped == nil) then
    oq.pve_group_wiped() ;
  end
  oq._wiped = 1 ;
end

function oq.get_nboss_kills()
  local nbosses = (OQ_data.leader["pve.5man"].nBosses or 0) ;
  nbosses = nbosses + OQ_data.leader["pve.raid"].nBosses ;
  nbosses = nbosses + OQ_data.leader["pve.challenge"].nBosses ;
  
  local nwipes = (OQ_data.leader["pve.5man"].nWipes or 0) ;
  nwipes = nwipes + (OQ_data.leader["pve.raid"].nWipes or 0) ;
  nwipes = nwipes + (OQ_data.leader["pve.challenge"].nWipes or 0) ;
  
  return nbosses, nwipes ;
end

function oq.get_raid_progression()
--  GetStatistic(588)
-- oq.bset( m.flags, OQ_FLAG_DESERTER, deserter ) ;
  local flags = 0 ;

  -- terrace of endless spring
  local toes = "" ;
  -- 10 and 25 man normal
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 6813 ) or oq.has_completed( 7965 ) ) ; -- Protectors of the Endless kills
  flags = oq.bset( flags, 0x02, oq.has_completed( 6815 ) or oq.has_completed( 7967 ) ) ; -- Tsulong
  flags = oq.bset( flags, 0x04, oq.has_completed( 6817 ) or oq.has_completed( 7969 ) ) ; -- Lei Shi
  flags = oq.bset( flags, 0x08, oq.has_completed( 6819 ) or oq.has_completed( 7971 ) ) ; -- Sha of Fear
  toes = toes .."".. oq.encode_mime64_1digit( flags ) ;
  
  -- 10 and 25 man heroic
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 6814 ) or oq.has_completed( 7966 ) ) ; -- Protectors of the Endless kills
  flags = oq.bset( flags, 0x02, oq.has_completed( 6816 ) or oq.has_completed( 7968 ) ) ; -- Tsulong
  flags = oq.bset( flags, 0x04, oq.has_completed( 6818 ) or oq.has_completed( 7970 ) ) ; -- Lei Shi
  flags = oq.bset( flags, 0x08, oq.has_completed( 6820 ) or oq.has_completed( 7972 ) ) ; -- Sha of Fear
  toes = toes .."".. oq.encode_mime64_1digit( flags ) ;
  
  -- heart of fear
  local hof = "" ;
  -- 10 and 25 man normal
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 6801 ) or oq.has_completed( 7951 ) ) ; -- Imperial Vizier Zor'lok
  flags = oq.bset( flags, 0x02, oq.has_completed( 6803 ) or oq.has_completed( 7954 ) ) ; -- Blade Lord Ta'yak
  flags = oq.bset( flags, 0x04, oq.has_completed( 6805 ) or oq.has_completed( 7956 ) ) ; -- Garalon
  flags = oq.bset( flags, 0x08, oq.has_completed( 6807 ) or oq.has_completed( 7958 ) ) ; -- Wind Lord Mel'jarak
  flags = oq.bset( flags, 0x10, oq.has_completed( 6809 ) or oq.has_completed( 7961 ) ) ; -- Amber-Shaper Un'sok
  flags = oq.bset( flags, 0x20, oq.has_completed( 6811 ) or oq.has_completed( 7963 ) ) ; -- Grand Empress Shek'zeer
  hof = hof .."".. oq.encode_mime64_1digit( flags ) ;
  
  -- 10 and 25 man heroic
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 6802 ) or oq.has_completed( 7953 ) ) ; -- Imperial Vizier Zor'lok
  flags = oq.bset( flags, 0x02, oq.has_completed( 6804 ) or oq.has_completed( 7955 ) ) ; -- Blade Lord Ta'yak
  flags = oq.bset( flags, 0x04, oq.has_completed( 6806 ) or oq.has_completed( 7957 ) ) ; -- Garalon
  flags = oq.bset( flags, 0x08, oq.has_completed( 6808 ) or oq.has_completed( 7960 ) ) ; -- Wind Lord Mel'jarak
  flags = oq.bset( flags, 0x10, oq.has_completed( 6810 ) or oq.has_completed( 7962 ) ) ; -- Amber-Shaper Un'sok
  flags = oq.bset( flags, 0x20, oq.has_completed( 6812 ) or oq.has_completed( 7964 ) ) ; -- Grand Empress Shek'zeer
  hof = hof .."".. oq.encode_mime64_1digit( flags ) ;
  
  -- mogu'shan vaults
  local mv = "" ;
  -- 10 and 25 man normal
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 6789 ) or oq.has_completed( 7914 ) ) ; -- Stone Guard
  flags = oq.bset( flags, 0x02, oq.has_completed( 6791 ) or oq.has_completed( 7917 ) ) ; -- Feng the Accursed
  flags = oq.bset( flags, 0x04, oq.has_completed( 6793 ) or oq.has_completed( 7919 ) ) ; -- Gara'jal the Spiritbinder
  flags = oq.bset( flags, 0x08, oq.has_completed( 6795 ) or oq.has_completed( 7921 ) ) ; -- Four Kings
  flags = oq.bset( flags, 0x10, oq.has_completed( 6797 ) or oq.has_completed( 7923 ) ) ; -- Elegon
  flags = oq.bset( flags, 0x20, oq.has_completed( 6799 ) or oq.has_completed( 7926 ) ) ; -- Qin-xi
  mv = mv .."".. oq.encode_mime64_1digit( flags ) ;

  -- 10 and 25 man heroic
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 6790 ) or oq.has_completed( 7915 ) ) ; -- Stone Guard
  flags = oq.bset( flags, 0x02, oq.has_completed( 6792 ) or oq.has_completed( 7918 ) ) ; -- Feng the Accursed
  flags = oq.bset( flags, 0x04, oq.has_completed( 6794 ) or oq.has_completed( 7920 ) ) ; -- Gara'jal the Spiritbinder
  flags = oq.bset( flags, 0x08, oq.has_completed( 6796 ) or oq.has_completed( 7922 ) ) ; -- Four Kings
  flags = oq.bset( flags, 0x10, oq.has_completed( 6798 ) or oq.has_completed( 7924 ) ) ; -- Elegon
  flags = oq.bset( flags, 0x20, oq.has_completed( 6800 ) or oq.has_completed( 7927 ) ) ; -- Qin-xi
  mv = mv .."".. oq.encode_mime64_1digit( flags ) ;
  
  -- throne of thunder
  local tot = "" ;
  -- 10 and 25 man normal
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8142 ) or oq.has_completed( 8143 ) ) ; -- Jin'rokh the Breaker
  flags = oq.bset( flags, 0x02, oq.has_completed( 8149 ) or oq.has_completed( 8150 ) ) ; -- Horridon 
  flags = oq.bset( flags, 0x04, oq.has_completed( 8154 ) or oq.has_completed( 8155 ) ) ; -- Council of Elders
  flags = oq.bset( flags, 0x08, oq.has_completed( 8159 ) or oq.has_completed( 8160 ) ) ; -- Tortos
  flags = oq.bset( flags, 0x10, oq.has_completed( 8164 ) or oq.has_completed( 8165 ) ) ; -- Megaera
  flags = oq.bset( flags, 0x20, oq.has_completed( 8169 ) or oq.has_completed( 8170 ) ) ; -- Ji-Kun
  tot = tot .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8174 ) or oq.has_completed( 8175 ) ) ; -- Durumu the Forgotten
  flags = oq.bset( flags, 0x02, oq.has_completed( 8179 ) or oq.has_completed( 8182 ) ) ; -- Primordius
  flags = oq.bset( flags, 0x04, oq.has_completed( 8184 ) or oq.has_completed( 8185 ) ) ; -- Dark Animus
  flags = oq.bset( flags, 0x08, oq.has_completed( 8189 ) or oq.has_completed( 8190 ) ) ; -- Iron Qon
  flags = oq.bset( flags, 0x10, oq.has_completed( 8194 ) or oq.has_completed( 8195 ) ) ; -- Twin Consorts
  flags = oq.bset( flags, 0x20, oq.has_completed( 8199 ) or oq.has_completed( 8200 ) ) ; -- Lei Shen
  tot = tot .."".. oq.encode_mime64_1digit( flags ) ;  
  
  -- 10 and 25 man heroic  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8144 ) or oq.has_completed( 8145 ) ) ; -- Jin'rokh the Breaker
  flags = oq.bset( flags, 0x02, oq.has_completed( 8151 ) or oq.has_completed( 8152 ) ) ; -- Horridon 
  flags = oq.bset( flags, 0x04, oq.has_completed( 8156 ) or oq.has_completed( 8157 ) ) ; -- Council of Elders
  flags = oq.bset( flags, 0x08, oq.has_completed( 8162 ) or oq.has_completed( 8161 ) ) ; -- Tortos
  flags = oq.bset( flags, 0x10, oq.has_completed( 8166 ) or oq.has_completed( 8167 ) ) ; -- Megaera
  flags = oq.bset( flags, 0x20, oq.has_completed( 8171 ) or oq.has_completed( 8172 ) ) ; -- Ji-Kun
  tot = tot .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8176 ) or oq.has_completed( 8177 ) ) ; -- Durumu the Forgotten
  flags = oq.bset( flags, 0x02, oq.has_completed( 8181 ) or oq.has_completed( 8180 ) ) ; -- Primordius
  flags = oq.bset( flags, 0x04, oq.has_completed( 8186 ) or oq.has_completed( 8187 ) ) ; -- Dark Animus
  flags = oq.bset( flags, 0x08, oq.has_completed( 8191 ) or oq.has_completed( 8192 ) ) ; -- Iron Qon
  flags = oq.bset( flags, 0x10, oq.has_completed( 8196 ) or oq.has_completed( 8197 ) ) ; -- Twin Consorts
  flags = oq.bset( flags, 0x20, oq.has_completed( 8202 ) or oq.has_completed( 8201 ) ) ; -- Lei Shen
  tot = tot .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8203 ) or oq.has_completed( 8256 ) ) ; -- Ra-den
  tot = tot .."".. oq.encode_mime64_1digit( flags ) ;  
  
  -- siege of orgrimmar
  local soo = "" ;
  -- 10 and 25 man normal
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8551 ) or oq.has_completed( 8552 ) ) ; -- Immerseus
  flags = oq.bset( flags, 0x02, oq.has_completed( 8557 ) or oq.has_completed( 8558 ) ) ; -- The Fallen Protectors
  flags = oq.bset( flags, 0x04, oq.has_completed( 8563 ) or oq.has_completed( 8564 ) ) ; -- Norushen
  flags = oq.bset( flags, 0x08, oq.has_completed( 8569 ) or oq.has_completed( 8570 ) ) ; -- Sha of Pride
  flags = oq.bset( flags, 0x10, oq.has_completed( 8576 ) or oq.has_completed( 8577 ) ) ; -- Galakras
  flags = oq.bset( flags, 0x20, oq.has_completed( 8582 ) or oq.has_completed( 8583 ) ) ; -- Iron Juggernaut
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8588 ) or oq.has_completed( 8589 ) ) ; -- Kor'kron Dark Shaman
  flags = oq.bset( flags, 0x02, oq.has_completed( 8595 ) or oq.has_completed( 8596 ) ) ; -- General Nazgrim
  flags = oq.bset( flags, 0x04, oq.has_completed( 8601 ) or oq.has_completed( 8602 ) ) ; -- Malkorok
  flags = oq.bset( flags, 0x08, oq.has_completed( 8608 ) or oq.has_completed( 8609 ) ) ; -- Spoils of Pandaria
  flags = oq.bset( flags, 0x10, oq.has_completed( 8616 ) or oq.has_completed( 8617 ) ) ; -- Thok the Bloodthirsty
  flags = oq.bset( flags, 0x20, oq.has_completed( 8622 ) or oq.has_completed( 8623 ) ) ; -- Siegecrafter Blackfuse
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8628 ) or oq.has_completed( 8629 ) ) ; -- Paragons of the Klaxxi
  flags = oq.bset( flags, 0x02, oq.has_completed( 8635 ) or oq.has_completed( 8636 ) ) ; -- Garrosh Hellscream
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  
  -- 10 and 25 man heroic  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8553 ) or oq.has_completed( 8554 ) ) ; -- Immerseus
  flags = oq.bset( flags, 0x02, oq.has_completed( 8559 ) or oq.has_completed( 8560 ) ) ; -- The Fallen Protectors
  flags = oq.bset( flags, 0x04, oq.has_completed( 8565 ) or oq.has_completed( 8566 ) ) ; -- Norushen
  flags = oq.bset( flags, 0x08, oq.has_completed( 8571 ) or oq.has_completed( 8573 ) ) ; -- Sha of Pride
  flags = oq.bset( flags, 0x10, oq.has_completed( 8578 ) or oq.has_completed( 8579 ) ) ; -- Galakras
  flags = oq.bset( flags, 0x20, oq.has_completed( 8584 ) or oq.has_completed( 8585 ) ) ; -- Iron Juggernaut
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8590 ) or oq.has_completed( 8591 ) ) ; -- Kor'kron Dark Shaman
  flags = oq.bset( flags, 0x02, oq.has_completed( 8597 ) or oq.has_completed( 8598 ) ) ; -- General Nazgrim
  flags = oq.bset( flags, 0x04, oq.has_completed( 8603 ) or oq.has_completed( 8604 ) ) ; -- Malkorok
  flags = oq.bset( flags, 0x08, oq.has_completed( 8610 ) or oq.has_completed( 8612 ) ) ; -- Spoils of Pandaria
  flags = oq.bset( flags, 0x10, oq.has_completed( 8618 ) or oq.has_completed( 8619 ) ) ; -- Thok the Bloodthirsty
  flags = oq.bset( flags, 0x20, oq.has_completed( 8624 ) or oq.has_completed( 8625 ) ) ; -- Siegecrafter Blackfuse
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8630 ) or oq.has_completed( 8631 ) ) ; -- Paragons of the Klaxxi
  flags = oq.bset( flags, 0x02, oq.has_completed( 8637 ) or oq.has_completed( 8638 ) ) ; -- Garrosh Hellscream
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  
  -- flex
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8550 ) ) ; -- Immerseus
  flags = oq.bset( flags, 0x02, oq.has_completed( 8556 ) ) ; -- The Fallen Protectors
  flags = oq.bset( flags, 0x04, oq.has_completed( 8562 ) ) ; -- Norushen
  flags = oq.bset( flags, 0x08, oq.has_completed( 8568 ) ) ; -- Sha of Pride
  flags = oq.bset( flags, 0x10, oq.has_completed( 8575 ) ) ; -- Galakras
  flags = oq.bset( flags, 0x20, oq.has_completed( 8581 ) ) ; -- Iron Juggernaut
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8587 ) ) ; -- Kor'kron Dark Shaman
  flags = oq.bset( flags, 0x02, oq.has_completed( 8594 ) ) ; -- General Nazgrim
  flags = oq.bset( flags, 0x04, oq.has_completed( 8600 ) ) ; -- Malkorok
  flags = oq.bset( flags, 0x08, oq.has_completed( 8606 ) ) ; -- Spoils of Pandaria
  flags = oq.bset( flags, 0x10, oq.has_completed( 8615 ) ) ; -- Thok the Bloodthirsty
  flags = oq.bset( flags, 0x20, oq.has_completed( 8621 ) ) ; -- Siegecrafter Blackfuse
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  flags = 0 ;
  flags = oq.bset( flags, 0x01, oq.has_completed( 8627 ) ) ; -- Paragons of the Klaxxi
  flags = oq.bset( flags, 0x02, oq.has_completed( 8634 ) ) ; -- Garrosh Hellscream
  soo = soo .."".. oq.encode_mime64_1digit( flags ) ;  
  
  -- bosses and wipes
  local nbosses, nwipes = oq.get_nboss_kills() ;
  local record = oq.encode_mime64_3digit( nbosses ) .."".. 
                 oq.encode_mime64_2digit( nwipes ) .."".. 
                 oq.encode_mime64_3digit( OQ_data.leader_dkp ) .."".. 
                 oq.encode_mime64_3digit( OQ_data._dkp ) ;
  
  -- put it all together
  -- AA BB CC DDDDD bbbWWdddmmm
  return toes .. hof .. mv .. tot .. record .. soo ;
end

function oq.get_pvp_experience()
  local str = "" ;
  -- get top rbg rank
  local rank = 0 ;
  local faction = 1 ;
  local flags = 0 ;
  if (strlower(select( 1, UnitFactionGroup("player"))) == "alliance") then
    faction = 15 ;
  end
  local i ;
  for i=faction,faction+13 do
    if (oq.has_achieved( OQ.rbg_rank[i].id )) then
      rank = i ;
    end
  end
  str = str .."".. oq.encode_mime64_1digit(rank) ;
  
  -- get various rbg achieves (hero of the horde)
  flags = 0 ;
  if (faction == 1) then 
    flags = oq.bset( flags, 0x01, oq.has_achieved( 6941 ) ) ; -- hero of the horde
    flags = oq.bset( flags, 0x02, oq.has_achieved( 5326 ) ) ; -- warbringer of the horde
  else
    flags = oq.bset( flags, 0x01, oq.has_achieved( 6942 ) ) ; -- hero of the alliance
    flags = oq.bset( flags, 0x02, oq.has_achieved( 5329 ) ) ; -- warbound veteran of the alliance
  end
  str = str .."".. oq.encode_mime64_1digit(flags) ;
  -- get various bg achieves (battlemaster, bloodthirsty, khan, conqueror)
  flags = 0 ;
  if (faction == 1) then
    -- horde
    flags = oq.bset( flags, 0x01, oq.has_achieved( 1175 ) ) ; -- battlemaster
    flags = oq.bset( flags, 0x02, oq.has_achieved(  714 ) ) ; -- conqueror
    flags = oq.bset( flags, 0x04, oq.has_achieved( 5363 ) ) ; -- bloodthirsty
    flags = oq.bset( flags, 0x20, oq.has_achieved( 8055 ) ) ; -- khan
  else
    -- alliance
    flags = oq.bset( flags, 0x01, oq.has_achieved(  230 ) ) ; -- battlemaster
    flags = oq.bset( flags, 0x02, oq.has_achieved(  907 ) ) ; -- justicar
    flags = oq.bset( flags, 0x04, oq.has_achieved( 5363 ) ) ; -- bloodthirsty
    flags = oq.bset( flags, 0x20, oq.has_achieved( 8052 ) ) ; -- khan
  end
  str = str .."".. oq.encode_mime64_1digit(flags) ;
  -- get top arena rank
  flags = 0 ;
  if (faction == 1) then
    -- horde
    flags = oq.bset( flags, 0x01, oq.has_achieved( 1174 ) ) ; -- arena master
    flags = oq.bset( flags, 0x02, oq.has_achieved( 2091 ) ) ; -- gladiator  0.0 -  0.5%
    flags = oq.bset( flags, 0x04, oq.has_achieved( 2092 ) ) ; -- duelist    0.5 -  3.0%
    flags = oq.bset( flags, 0x08, oq.has_achieved( 2093 ) ) ; -- rival      3.0 - 10.0%
  else
    -- alliance
    flags = oq.bset( flags, 0x01, oq.has_achieved( 1174 ) ) ; -- arena master
    flags = oq.bset( flags, 0x02, oq.has_achieved( 2091 ) ) ; -- gladiator
    flags = oq.bset( flags, 0x04, oq.has_achieved( 2092 ) ) ; -- duelist
    flags = oq.bset( flags, 0x08, oq.has_achieved( 2093 ) ) ; -- rival
  end
  str = str .."".. oq.encode_mime64_1digit(flags) ;
  return str ;
end

function oq.get_bg_experience( as_lead ) 
  local str = "" ;
  if (as_lead) then
    local s = OQ_data.leader["bg"] ;
    str = str .."".. oq.encode_mime64_3digit( s.nWins ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nLosses ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nGames ) ;
  else  
    local s = oq.toon.stats["bg"] ;
    str = str .."".. oq.encode_mime64_3digit( s.nWins ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nLosses ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nGames ) ;
  end
  return str .."".. oq.get_pvp_experience() ;
end

function oq.get_rbg_experience( as_lead ) 
  local str = "" ;
  if (as_lead) then
    local s = OQ_data.leader["rbg"] ;
    str = str .."".. oq.encode_mime64_3digit( s.nWins ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nLosses ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nGames ) ;
  else  
    local s = oq.toon.stats["rbg"] ;
    str = str .."".. oq.encode_mime64_3digit( s.nWins ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nLosses ) ;
    str = str .."".. oq.encode_mime64_3digit( s.nGames ) ;
  end
  return str .."".. oq.get_pvp_experience() ;
end

function oq.get_medal_count( id )
  local b = GetStatistic(id) ;
  if (b == "--") then
    b = 0 ;
  end
  return b ;
end

function oq.get_challenge_experience( as_lead )
  local str = "" ;
  str = str .."".. oq.encode_mime64_2digit( oq.get_medal_count(7400) ) ;
  str = str .."".. oq.encode_mime64_2digit( oq.get_medal_count(7401) ) ;
  str = str .."".. oq.encode_mime64_2digit( oq.get_medal_count(7402) ) ;
  
  -- AA BB CC bbbWWdddmmm
  -- bosses and wipes
  local nbosses, nwipes = oq.get_nboss_kills() ;
  return str .."".. oq.encode_mime64_3digit( nbosses            ) .."".. 
                    oq.encode_mime64_2digit( nwipes             ) .."".. 
                    oq.encode_mime64_3digit( OQ_data.leader_dkp ) ..""..
                    oq.encode_mime64_3digit( OQ_data._dkp       ) ;
end

function oq.get_scenario_experience( as_lead )
  -- bbbWWdddmmm
  -- bosses and wipes
  local nbosses, nwipes = oq.get_nboss_kills() ;
  return oq.encode_mime64_3digit( nbosses            ) .."".. 
         oq.encode_mime64_2digit( nwipes             ) .."".. 
         oq.encode_mime64_3digit( OQ_data.leader_dkp ) ..""..
         oq.encode_mime64_3digit( OQ_data._dkp )  ;
end

--  list of achieve ids
--  http://www.wowwiki.com/Complete_list_of_Achievement_ID%27s
--
function oq.get_arena_ratio( wins_id, total_id )
  local wins  = GetStatistic( wins_id  ) ;
  local total = GetStatistic( total_id ) ;
  if (wins  == "--") then wins  = 0 ; end 
  if (total == "--") then total = 0 ; end 
  return wins, total - wins ;
end

function oq.get_arena_experience( as_lead )
  -- rmmm5wwwlll3wwwlll2wwwlllC
  -- r        best rank  
  -- mmm      bets mmr of all 3
  -- 5wwwlll  best 5 rank, www wins, lll losses
  -- 3wwwlll  best 3 rank, www wins, lll losses
  -- 2wwwlll  best 2 rank, www wins, lll losses
  -- C        class & spec id
  --
  local best_mmr = oq.get_best_mmr( OQ.TYPE_ARENA ) ;
  local wins_2s, loss_2s = oq.get_arena_ratio( 366, 367 ) ;
  local wins_3s, loss_3s = oq.get_arena_ratio( 364, 365 ) ;
  local wins_5s, loss_5s = oq.get_arena_ratio( 362, 363 ) ;

  -- arena rank
  local rank = 0 ;
  rank = (select( 4, GetAchievementInfo( 2090 )) == true) and 1 or rank ;  -- challenger
  rank = (select( 4, GetAchievementInfo( 2093 )) == true) and 2 or rank ;  -- rival
  rank = (select( 4, GetAchievementInfo( 2092 )) == true) and 3 or rank ;  -- duelist
  rank = (select( 4, GetAchievementInfo( 2091 )) == true) and 4 or rank ;  -- gladiator
  
  local best_2s = 0 ;
  best_2s = (select( 4, GetAchievementInfo(  399 )) == true) and 1 or best_2s ;  -- 1550
  best_2s = (select( 4, GetAchievementInfo(  400 )) == true) and 2 or best_2s ;  -- 1750
  best_2s = (select( 4, GetAchievementInfo(  401 )) == true) and 3 or best_2s ;  -- 2000
  best_2s = (select( 4, GetAchievementInfo( 1159 )) == true) and 4 or best_2s ;  -- 2200
  
  local best_3s = 0 ;
  best_3s = (select( 4, GetAchievementInfo(  402 )) == true) and 1 or best_3s ;  -- 1550
  best_3s = (select( 4, GetAchievementInfo(  403 )) == true) and 2 or best_3s ;  -- 1750
  best_3s = (select( 4, GetAchievementInfo(  405 )) == true) and 3 or best_3s ;  -- 2000
  best_3s = (select( 4, GetAchievementInfo( 1160 )) == true) and 4 or best_3s ;  -- 2200
  
  local best_5s = 0 ;
  best_5s = (select( 4, GetAchievementInfo(  406 )) == true) and 1 or best_5s ;  -- 1550
  best_5s = (select( 4, GetAchievementInfo(  407 )) == true) and 2 or best_5s ;  -- 1750
  best_5s = (select( 4, GetAchievementInfo(  404 )) == true) and 3 or best_5s ;  -- 2000
  best_5s = (select( 4, GetAchievementInfo( 1161 )) == true) and 4 or best_5s ;  -- 2200
  
  local class, spec, spec_id = oq.get_spec() ;
  
  return oq.encode_mime64_1digit( rank )    ..
         oq.encode_mime64_3digit( best_mmr ) ..
         oq.encode_mime64_1digit( best_5s  ) ..
         oq.encode_mime64_3digit( wins_5s  ) ..
         oq.encode_mime64_3digit( loss_5s  ) ..
         oq.encode_mime64_1digit( best_3s  ) ..
         oq.encode_mime64_3digit( wins_3s  ) ..
         oq.encode_mime64_3digit( loss_3s  ) ..
         oq.encode_mime64_1digit( best_2s  ) ..
         oq.encode_mime64_3digit( wins_2s  ) ..
         oq.encode_mime64_3digit( loss_2s  ) ..
         oq.encode_mime64_1digit( OQ.CLASS_SPEC[spec_id].id ) ;
end

function oq.get_leader_experience()
  if (oq.raid.type == OQ.TYPE_DUNGEON) or (oq.raid.type == OQ.TYPE_RAID) then
    return oq.get_raid_progression() ;
  end
  if (oq.raid.type == OQ.TYPE_BG) then
    return oq.get_bg_experience( true ) ;
  end
  if (oq.raid.type == OQ.TYPE_RBG) then
    return oq.get_rbg_experience( true ) ;
  end
  if (oq.raid.type == OQ.TYPE_CHALLENGE) then
    return oq.get_challenge_experience( true ) ;
  end
  if (oq.raid.type == OQ.TYPE_SCENARIO) then
    return oq.get_scenario_experience( true ) ;
  end
  if (oq.raid.type == OQ.TYPE_ARENA) then
    return oq.get_arena_experience( true ) ;
  end
  
  return "A" ; -- ie: nothing
end

--
-- for member information
--
function oq.get_past_experience()
  if (oq.raid.type == OQ.TYPE_DUNGEON) or (oq.raid.type == OQ.TYPE_RAID) then
    return oq.get_raid_progression() ;
  end
  if (oq.raid.type == OQ.TYPE_BG) then
    return oq.get_bg_experience( nil ) ;
  end
  if (oq.raid.type == OQ.TYPE_RBG) then
    return oq.get_rbg_experience( nil ) ;
  end
  if (oq.raid.type == OQ.TYPE_CHALLENGE) then
    return oq.get_challenge_experience( nil ) ;
  end
  if (oq.raid.type == OQ.TYPE_SCENARIO) then
    return oq.get_scenario_experience( nil ) ;
  end
  
  return "A" ; -- ie: nothing
end

-- premade data 
-- this is data specific to the premade type
-- 
function oq.get_pdata( raid_type, sub_type )
  local pdata = "-----" ;
  raid_type = raid_type or oq.raid.type ;
  if (raid_type == OQ.TYPE_DUNGEON) then
    local n = 0 ;
    local i ;
    for i=1,5 do
      local m = oq.raid.group[1].member[i] ;
      if (m.name ~= nil) and (m.name ~= "-") then 
        if (OQ.ROLES[ m.role ] == "TANK") then
          pdata = oq.strrep( pdata, "T", 1 ) ;
        elseif (OQ.ROLES[ m.role ] == "HEALER") then
          pdata = oq.strrep( pdata, "H", 2 ) ;
        else
          pdata = oq.strrep( pdata, "D", 3 + n ) ;
          n = n + 1 ;
        end
      end
    end
  elseif (raid_type == OQ.TYPE_CHALLENGE) or (raid_type == OQ.TYPE_QUESTS) then
    local i ;
    for i=1,5 do
      local m = oq.raid.group[1].member[i] ;
      if (m.name ~= nil) and (m.name ~= "-") then 
        if (OQ.ROLES[ m.role ] == "TANK") then
          pdata = oq.strrep( pdata, "T", i ) ;
        elseif (OQ.ROLES[ m.role ] == "HEALER") then
          pdata = oq.strrep( pdata, "H", i ) ;
        else
          pdata = oq.strrep( pdata, "D", i ) ;
        end
      end
    end
  elseif (raid_type == OQ.TYPE_SCENARIO) then
    local n = 0 ;
    local i ;
    pdata = "---" ;
    for i=1,3 do
      local m = oq.raid.group[1].member[i] ;
      if (m.name ~= nil) and (m.name ~= "-") then 
        if (OQ.ROLES[ m.role ] == "TANK") then
          pdata = oq.strrep( pdata, "T", i ) ;
        elseif (OQ.ROLES[ m.role ] == "HEALER") then
          pdata = oq.strrep( pdata, "H", i ) ;
        else
          pdata = oq.strrep( pdata, "D", i ) ;
          n = n + 1 ;
        end
      end
    end
  else
    local ntanks, nheals, ndps = oq.get_n_roles() ;
    pdata = oq.encode_mime64_1digit(ntanks) .. oq.encode_mime64_1digit(nheals) .. oq.encode_mime64_1digit(ndps) ;
    pdata = pdata .. oq.get_current_raid_status( sub_type ) ;
  end
  return pdata ;
end

function oq.get_raid_bosses_killed(name)
  if (name == nil) then
    return 0, 0 ;
  end 
  
  local n = GetNumSavedInstances() ;
  local index ;
  for index=1,n do
    local iName, iID, iReset, iDiff, locked, extended, iIDMostSig, isRaid, maxPlayers, diffName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index) ;
    if (iName == name) then
      if (iReset == 0) then
        return 0, maxBosses ; -- expired, no bosses done this week
      else
        return defeatedBosses, maxBosses ;
      end
    end
  end
  local raid_id = oq.get_raid_id( name ) ;
  if (raid_id > 0) then
    return 0, OQ.max_raid_bosses[ raid_id ] ;
  end
  return 0, 0 ;
end

function oq.get_raid_id( raid_name )
  local i,v ;
  for i,v in pairs(OQ.raid_ids) do
    if (i == raid_name) then
      return v ;
    end
  end
  return 0 ;
end

function oq.get_raid_name( raid_id )
  local i, v ;
  for i,v in pairs(OQ.raid_ids) do
    if (v == raid_id) then
      return i ;
    end
  end
  return nil ;
end

function oq.get_raid_index( raid_id )
  if (raid_id == 0) then
    return 0 ;
  end
  local n = GetNumSavedInstances() ;
  local index ;
  local name = oq.get_raid_name( raid_id ) ;
  for index=1,n do
    local iName, iID, iReset, iDiff, locked, extended, iIDMostSig, isRaid, maxPlayers, diffName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index) ;
    if (iName == name) then
      return index ;
    end
  end
  return 0 ;
end

function oq.get_boss_name( raid_id, boss_id )
  if (OQ.raid_bosses[raid_id] == nil) or (OQ.raid_bosses[raid_id][boss_id] == nil) then
    return string.format( "unk-%d.%d", raid_id, boss_id ) ;
  end
  return OQ.boss_nicknames[ OQ.raid_bosses[raid_id][boss_id] ] or OQ.raid_bosses[raid_id][boss_id] ;
end

function oq.get_boss_id( raid_id, boss_name )
  if (OQ.raid_bosses[raid_id] == nil) then
    return 0 ;
  end
  local i, v ;
  for i,v in pairs(OQ.raid_bosses[raid_id]) do
    if (v == boss_name) then
      return i ;
    end
  end
  return 0 ;
end

function oq.get_boss_bits( raid_id, maxBosses )
  local boss_bits = 0 ;
  local raid_ndx = oq.get_raid_index( raid_id ) ;
  if (raid_ndx == 0) then
    return 0 ;
  end
  
  local instanceReset = select( 3, GetSavedInstanceInfo( raid_ndx ) ) ;
  if (instanceReset == 0) then
    -- expired; all bosses available
    return 0 ;
  end
  
  local index ;
  for index=1,maxBosses do
    local name, _, dead = GetSavedInstanceEncounterInfo( raid_ndx, index ) ;
    if (dead) then
      local boss_id = oq.get_boss_id( raid_id, name ) ;
      if (boss_id > 0) then
        boss_bits = boss_bits + 2 ^ boss_id ;
      end
    end
  end
  return boss_bits ;
end

function oq.get_boss_locks( raid_name, raid_ndx, maxBosses )
  local raid_id = oq.get_raid_id( raid_name ) ;
  if (raid_id == 0) then
    return 0 ;
  end
  return oq.get_boss_bits( raid_id, maxBosses ) ;
end

function oq.is_boss_conflict( raid_id, maxBosses, boss_bits ) 
  local my_boss_bits = oq.get_boss_bits( raid_id, maxBosses ) ;
  local i ;
  for i=1,maxBosses do
    if oq.is_set( my_boss_bits, 2^i ) and not oq.is_set( boss_bits, 2^i ) then
      return true ;
    end
  end
  return nil ;
end

function oq.lockout_conflict( pdata )
  if (pdata == nil) or (#pdata < 8) then
    return nil ;
  end
  local D = oq.decode_mime64_digits( pdata:sub(4,4) ) ; -- difficulty
  local R = oq.decode_mime64_digits( pdata:sub(5,5) ) ; -- raid id
  local b = oq.decode_mime64_digits( pdata:sub(6,6) ) ; -- # killed
  local B = oq.decode_mime64_digits( pdata:sub(7,7) ) ; -- max bosses
  local i = oq.decode_mime64_digits( pdata:sub(8,8) ) ;
  local h = oq.decode_mime64_digits( pdata:sub(9,9) ) ;
  
  local boss_bits = oq.decode_mime64_digits( pdata:sub(10,12) ) ;
  if (D >=3 ) and (D <= 6) then
    -- lockout only matters for 10/25 normal or heroic
    return oq.is_boss_conflict( R, B, boss_bits ) ;
  end
  return nil ;
end

function oq.pdata_raid_conflict( pdata )
  if (pdata == nil) or (#pdata < 8) or (oq.raid.type ~= OQ.TYPE_RAID) then
    return nil ;
  end

  -- my raid
  local raid_id   = oq.raid.subtype ;
  if (raid_id == 0) or (raid_id == 63) then 
    -- general or world, no conflict
    return nil ;
  end
  local D = oq.decode_mime64_digits( oq.raid.pdata:sub(4,4) ) ; -- difficulty

  -- their bits  
  if (D >= 3) and (D <= 6) then
    local maxBosses = OQ.max_raid_bosses[raid_id] or 0 ;
    local boss_bits = oq.decode_mime64_digits( pdata:sub(10,12) ) ;
    -- lockout only matters for 10/25 normal or heroic
    local my_boss_bits = oq.get_boss_bits( raid_id, maxBosses ) ;
    local i ;
    for i=1,maxBosses do
      if oq.is_set( boss_bits, 2^i ) and not oq.is_set( my_boss_bits, 2^i ) then
        return true ;
      end
    end
  end
  return nil ;
end

function oq.oceanic_conflict( p )
  oq.__conflict = L[": none"] ;
  if (string.sub(GetCVar("realmList"),1,2) == "eu") then
    return nil ; -- no oceanic style conflict for the EU
  end
  if (p.type ~= OQ.TYPE_RAID) or (#p.pdata < 8) then
    return nil ;
  end
  -- no conflict unless world boss
  local R = oq.decode_mime64_digits( p.pdata:sub(5,5) ) ; -- raid id
  if (R ~= 63) then  -- raid-id 63 == world boss raid
    return nil ; 
  end
  oq._player_realm = oq._player_realm or oq.GetRealmName() ;
  
  if (OQ.OCEANIC[ p.leader_realm ]) then
    if (OQ.OCEANIC[ oq._player_realm ]) then
      return nil ;
    end
    oq.__conflict = L[": oceanic"] ;
    return true ;
  elseif (OQ.BRALIZIAN[ p.leader_realm ]) then
    if (OQ.BRALIZIAN[ oq._player_realm ]) then
      return nil ;
    end
    oq.__conflict = L[": brazilian"] ;
    return true ;
  end
  
  if (OQ.OCEANIC[ oq._player_realm ]) or (OQ.BRALIZIAN[ oq._player_realm ]) then
    oq.__conflict = L[": US"] ;
    return true ;
  end
  return nil ;
end

function oq.get_raid_boss_progression( name )
  if (name == nil) then
    return "AAA" ;
  end
  local n = GetNumSavedInstances() ;
  local index ;
  for index=1,n do
    local iName, iID, iReset, iDiff, locked, extended, iIDMostSig, isRaid, maxPlayers, diffName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index) ;
    if (iName == name) then
      return oq.encode_mime64_3digit( oq.get_boss_locks( name, index, maxBosses ) ) ;
    end
  end
  return "AAA" ;
end

function oq.scan_for_unit(name)
  if (name == nil) then
    return nil ;
  end
  if (name == L["Icecrown Gunship Battle"]) then
    if (player_faction == "A") then
      name = L["Orgrim's Hammer"] ;
    else
      name = L["The Skybreaker"] ;
    end
  end
  if (UnitName'target' == name) then
    return 'target' ;
  elseif (UnitName'focus' == name) then
    return 'focus' ;
  elseif (UnitName'pettarget' == name) then
    return 'pettarget' ;
  else
    local i ;
    for i = 1, GetNumGroupMembers() do
      local unit = ('raid%dtarget'):format(i) ;
      if (UnitName(unit) == name) then 
        return unit ;
      end
    end
  end
end

function oq.is_raid_boss( raid_id, name )
  if (raid_id == 0) or (OQ.raid_bosses[raid_id] == nil) then
    return nil ;
  end
  local i,v ;
  for i,v in pairs(OQ.raid_bosses[raid_id]) do
    if (v == name) then
      return true, i, v ;
    end
  end
  if (OQ.lieutenants[name]) then
    return true, oq.get_boss_id(raid_id, OQ.lieutenants[name]), OQ.lieutenants[name] ;
  end
end

function oq.scan_for_boss( raid_id )
  if (raid_id == nil) or (raid_id == 0) then
    return nil ;
  end
  if oq.is_raid_boss( raid_id, UnitName('target'   ) ) then return 'target' ; end ;
  if oq.is_raid_boss( raid_id, UnitName('focus'    ) ) then return 'focus' ; end ;
  if oq.is_raid_boss( raid_id, UnitName('pettarget') ) then return 'pettarget' ; end ;
  local i ;
  for i = 1, GetNumGroupMembers() do
    local unit = ('raid%dtarget'):format(i) ;
    if (oq.is_raid_boss( raid_id, UnitName(unit))) then 
      return unit ;
    end
  end
end

function oq.get_boss_id_from_unit( raid_id, unit ) 
  local flag, id, name = oq.is_raid_boss( raid_id, UnitName(unit) ) ;
  if (flag) then
    return id, name ;
  end
  return 0 ;
end

function oq.get_current_raid_status( sub_type )
  --
  -- DRbBihPPP
  --
  -- D  difficulty; 10n, 10h, 25n, 25h, lfr, flex
  -- R  raid id (icc, firelands, tot, ulduuar, etc)
  -- b  # bosses killed
  -- B  max # bosses
  -- i  boss-id
  -- h  boss hp percent (1..50)
  -- PPP boss progression bits
  --
  local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID = GetInstanceInfo() ;
  local rid = oq.get_raid_id(name) ;
  if (rid == 0) then
    rid  = sub_type ;
    name = oq.get_raid_name( rid ) ;
    difficultyIndex = OQ_data._premade_diff or 3 ;
  end
  local nkilled, maxBosses = oq.get_raid_bosses_killed(name) ;
  local boss_id = nkilled + 1 ;
  local hp = 100 ;
--  local unit = oq.scan_for_unit(OQ.raid_bosses[rid][boss_id]) ;
  local unit = oq.scan_for_boss( rid ) ;
  if (unit) then
    hp = floor( 100 * UnitHealth(unit) / UnitHealthMax(unit) ) ;
    boss_id = oq.get_boss_id_from_unit( rid, unit ) 
  else
    boss_id = 0 ;
    hp = 0 ;
  end
  return oq.encode_mime64_1digit( difficultyIndex ) ..
         oq.encode_mime64_1digit( rid         ) ..
         oq.encode_mime64_1digit( nkilled     ) ..
         oq.encode_mime64_1digit( maxBosses   ) ..
         oq.encode_mime64_1digit( boss_id     ) ..
         oq.encode_mime64_1digit( floor(hp/2) ) ..
         oq.get_raid_boss_progression( name ) ; 
         
--  return "FODMEK"; -- 10H ICC (3/12)  Deathbringer Saurfang (20%)
--  return "AAAAAA" ;
end

--
-- returns: desc, raid_id, last_boss, max_boss 
--
function oq.render_raid_status( pdata )
  if (pdata == nil) or (#pdata < 8) or (pdata:find("-")) then
    return nil, nil, nil, nil ;
  end

  local ntanks = oq.decode_mime64_digits( pdata:sub(1,1) ) ;
  local nheals = oq.decode_mime64_digits( pdata:sub(2,2) ) ;
  local ndps   = oq.decode_mime64_digits( pdata:sub(3,3) ) ;
  local n = ntanks + nheals + ndps ;
  
  local D = oq.decode_mime64_digits( pdata:sub(4,4) ) ;
  local R = oq.decode_mime64_digits( pdata:sub(5,5) ) ;
  local b = oq.decode_mime64_digits( pdata:sub(6,6) ) ;
  local B = oq.decode_mime64_digits( pdata:sub(7,7) ) ;
  local i = oq.decode_mime64_digits( pdata:sub(8,8) ) ;
  local h = oq.decode_mime64_digits( pdata:sub(9,9) ) ;
  
  local s = "" ;

  -- raid & difficulty
  if (R == 0) or (OQ.raid_abbrevation[R] == nil) then
    -- general raid
    s = "" ;
  elseif (R == 63) then
    -- world boss
    s = s .. "|cffF25804" .. (OQ.raid_abbrevation[R] or "") .."|r " ;
  else
    s = s .. "|cff".. (OQ.difficulty_color[D] or "0000ff") .. (OQ.raid_abbrevation[R] or "") .. string.format( OQ.difficulty_abbr[D] or "", n ) .."|r " ;
    -- progress
    if (D >= 3) and (D <= 6) and (OQ.raid_abbrevation[R]) then
      s = s .. string.format( "|cff808080[|r|cff90ffff%d|r|cff808080/|r|cff90ffff%d|r|cff808080]|r ", b, B ) ;  
    end
  end
  
  -- boss
  if (i > 0) then
    s = s .. string.format( "%s|cff909090(|r|cffc0c000%2d%%|r|cff909090)|r", oq.get_boss_name( R, i ), h*2 ) ;
  end
  return s, R, b, B, i ;
end

function oq.get_dragon_rank( type, nwins, leader_xp ) 
  if (nwins == nil) and (leader_xp ~= nil) then
    if (type == OQ.TYPE_RBG) or (type == OQ.TYPE_BG) then
      nwins, _ = oq.get_winloss_record( leader_xp ) ;
    elseif (type == OQ.TYPE_RAID) or (type == OQ.TYPE_DUNGEON) then
      _, _, nwins = oq.get_pve_winloss_record( leader_xp ) ;
    elseif (type == OQ.TYPE_CHALLENGE) then
      _, _, nwins = oq.get_challenge_winloss_record( leader_xp ) ;
    elseif (type == OQ.TYPE_SCENARIO) then
      _, _, nwins = oq.get_scenario_winloss_record( leader_xp ) ;
    else
      nwins    = 0 ;
    end
  elseif (nwins == nil) then
    nwins = 0 ;
  end

  local t = "pve" ;  
  if (type == OQ.TYPE_RBG) or (type == OQ.TYPE_ARENA) then
    t = "rated" ;
  elseif (type == OQ.TYPE_BG) then
    t = "pvp" ;
  end
  
  local title = "" ;
  local rank  = 0 ;
  local i = 0 ;
  if (t) and (OQ.rank_breaks[t]) then
    local i ;
    for i=4,1,-1 do
      if (OQ.rank_breaks[t][i]) and (nwins >= OQ.rank_breaks[t][i].line) then
        rank  = OQ.rank_breaks[t][i].rank ;
        title = OQ.rank_breaks[t][i].r ;
        return OQ.dragon_rank[ rank ].tag, OQ.dragon_rank[ rank ].y, OQ.dragon_rank[ rank ].cx, OQ.dragon_rank[ rank ].cy, title, rank ;
      end
    end
  end
  return nil, 0, 0, 0, "", 0 ;
end

function oq.get_winloss_record( leader_xp )
  if (leader_xp == nil) then
    return 0,0 ;
  end
  local nwins   = oq.decode_mime64_digits(leader_xp:sub(1,3)) ;
  local nlosses = oq.decode_mime64_digits(leader_xp:sub(4,6)) ;
  return nwins, nlosses ;
end

function oq.get_challenge_winloss_record( leader_xp )
  if (leader_xp == nil) then
    return 0,0,0 ;
  end
  -- AA BB CC bbbWWddd
  local nwins   = oq.decode_mime64_digits(leader_xp:sub( 7, 9)) ;
  local nlosses = oq.decode_mime64_digits(leader_xp:sub(10,11)) ;
  local dkp     = oq.decode_mime64_digits(leader_xp:sub(12,14)) ;
  return nwins, nlosses, dkp ;
end

function oq.get_scenario_winloss_record( leader_xp )
  if (leader_xp == nil) then
    return 0,0,0 ;
  end
  -- bbbWWddd
  local nwins   = oq.decode_mime64_digits(leader_xp:sub( 1, 3)) ;
  local nlosses = oq.decode_mime64_digits(leader_xp:sub( 4, 5)) ;
  local dkp     = oq.decode_mime64_digits(leader_xp:sub( 6, 8)) ;
  return nwins, nlosses, dkp ;
end

function oq.get_pve_winloss_record( leader_xp )
  if (leader_xp == nil) then
    return 0,0,0 ;
  end
  -- AA BB CC DDDDD bbbWWddd
  local nwins   = oq.decode_mime64_digits(leader_xp:sub(12,14)) ;
  local nlosses = oq.decode_mime64_digits(leader_xp:sub(15,16)) ;
  local dkp     = oq.decode_mime64_digits(leader_xp:sub(17,19)) ;
  return nwins, nlosses, dkp ;
end



