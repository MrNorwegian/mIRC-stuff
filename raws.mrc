raw *:*:{
  if ($eval(% $+ debug_raw_ $+ $cid,2)) { echo -t $+(@,$network,_,$cid,_,raw) Event: $event Text: $1- }
  if ($event = ack) { return }
  elseif ($event = cap) { return }

  ; batch +eJ2YePPoPApi8e95KGaJfU chathistory #opers ; batch -eJ2YePPoPApi8e95KGaJfU
  elseif ($event = batch) { return }

  elseif ($event = chghost) { return }
  elseif ($event = account) { return }
  elseif ($event = tagmsg) { return }
  elseif ($event = away) { return }

  ; Welcome to the SERVER DESC, NICK
  elseif ($event = 001) { return }

  ; Your host is SERVERNAME, running version SERVERVERSION
  elseif ($event = 002) { 
    if ( $6-7 = running version ) { 
      if ( UnrealIRCd isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,unreal),$network,32) ) && ( $istok($nx.db(read,settings,ircd,samode),$network,32) ) { return }
        else { nx.db write settings ircd unreal $addtok($nx.db(read,settings,ircd,unreal),$network,32) | nx.db write settings ircd samode $addtok($nx.db(read,settings,ircd,samode),$network,32) | return }
      }
      elseif ( bahamut-2 isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,bahamut),$network,32) ) && ( $istok($nx.db(read,settings,ircd,samode),$network,32) ) { return }
        else { nx.db write settings ircd bahamut $addtok($nx.db(read,settings,ircd,bahamut),$network,32) | nx.db write settings ircd samode $addtok($nx.db(read,settings,ircd,samode),$network,32) | return }
      }
      elseif ( u2.10.12 isin $8 ) && ( Nefarious isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,nefarious),$network,32) ) && ( $istok($nx.db(read,settings,ircd,opmode),$network,32) ) { return }
        else { nx.db write settings ircd nefarious $addtok($nx.db(read,settings,ircd,nefarious),$network,32) | nx.db write settings ircd opmode $addtok($nx.db(read,settings,ircd,opmode),$network,32) | return }
      }
      elseif ( u2.10.12 isin $8 ) && ( snircd isin $8 )  { 
        if ( $istok($nx.db(read,settings,ircd,snircd),$network,32) ) && ( $istok($nx.db(read,settings,ircd,opmode),$network,32) ) { return }
        else { nx.db write settings ircd snircd $addtok($nx.db(read,settings,ircd,snircd),$network,32) | nx.db write settings ircd opmode $addtok($nx.db(read,settings,ircd,opmode),$network,32) | return }
      }
      elseif ( u2.10.12 isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,ircu2),$network,32) ) && ( $istok($nx.db(read,settings,ircd,opmode),$network,32) ) { return }
        else { nx.db write settings ircd ircu2 $addtok($nx.db(read,settings,ircd,ircu2),$network,32) | nx.db write settings ircd opmode $addtok($nx.db(read,settings,ircd,opmode),$network,32) | return }
      }
      elseif ( ircd-ratbox-3 isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,ratbox),$network,32) ) { return }
        else { nx.db write settings ircd ratbox $addtok($nx.db(read,settings,ircd,ratbox),$network,32) | return }
      }
      elseif ( solanum-1.0-dev isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,solanum),$network,32) ) { return }
        else { nx.db write settings ircd solanum $addtok($nx.db(read,settings,ircd,solanum),$network,32) | return }
      }
      else { return }
      ; TODO add bircd,InspIRCd-3,and others
      ; solanum (libera)
      else { return }
    }
  }

  ; Server created - Server info - modes supported
  elseif ($event = 003) { return }
  elseif ($event = 004) { return }
  elseif ($event = 005) { 
    ; ircu2:
    ; MAXNICKLEN=15 TOPICLEN=160 AWAYLEN=160 KICKLEN=160 CHANNELLEN=200 MAXCHANNELLEN=200 CHANTYPES=#& PREFIX=(ov)@+ STATUSMSG=@+ CHANMODES=b,k,l,imnpstrDdRcCPM CASEMAPPING=rfc1459 NETWORK=MyNetwork are supported by this server
    if ($gettok($wildtok($1-,TOPICLEN=?*,1,32),2,61)) { set %nx.topiclen. $+ $cid $v1 }
    if ($gettok($wildtok($1-,SILENCE=?*,1,32),2,61)) { set %nx.silencenum. $+ $cid $v1 }
    if ($gettok($wildtok($1-,MAXBANS=?*,1,32),2,61)) { set %nx.maxbans. $+ $cid $v1 }
    ; Unreal = MAXLIST=b:60,e:60,I:60
    elseif ($gettok($gettok($gettok($wildtok($1-,MAXLIST=?*,1,32),2,61),1,44),2,58)) { set %nx.maxbans. $+ $cid $v1 }
    return
  }

  ; /map return (unrealircd)
  ; /map sumary (last line in /map) (unrealircd)
  ; End of /map (unrealircd)
  elseif ($event = 006) { halt }
  elseif ($event = 018) { halt } 
  elseif ($event = 007) { halt } 

  ; /map return (ircu)
  ; End of /map (ircu)
  elseif ($event = 015) { nx.echo.snotice $2- | halt } 
  elseif ($event = 017) { nx.echo.snotice $2- | halt } 

  ; nick IDnumber your unique ID
  elseif ($event = 042) { return }

  ; /trace return, "user Other nick[ident@host] ?Num?", end of trace
  elseif ($event = 200) { nx.echo.snotice $2- | halt }
  elseif ($event = 204) { nx.echo.snotice $2- | halt }
  elseif ($event = 205) { nx.echo.snotice $2- | halt }
  elseif ($event = 206) { nx.echo.snotice $2- | halt }
  elseif ($event = 209) { nx.echo.snotice $2- | halt }
  elseif ($event = 262) { nx.echo.snotice $2- | halt }

  ; /stats return
  elseif ($event = 210) { nx.echo.snotice $2- | halt }

  ; stats l
  elseif ($event = 211) { nx.echo.snotice $2- | halt }

  ; stats m
  elseif ($event = 212) { nx.echo.snotice $2- | halt }

  ; Stats c (ircu)
  elseif ($event = 213) { nx.echo.snotice $2- | halt }

  ; stats i
  elseif ($event = 215) { nx.echo.snotice $2- | halt }

  ; stats p
  elseif ($event = 217) { nx.echo.snotice $2- | halt }

  ; stats y
  elseif ($event = 218) { nx.echo.snotice $2- | halt }

  ; End of /stats
  elseif ($event = 219) { nx.echo.snotice $2- | halt }

  ; $2 sets mode +i ( Not when connected to znc )
  elseif ($event = 221) { return }

  ; stats v
  elseif ($event = 236) { nx.echo.snotice $2- | halt }

  ; Stats f
  elseif ($event = 238) { nx.echo.snotice $2- | halt }

  ; Server up
  elseif ($event = 242) { nx.echo.snotice $2- | halt }

  ; stats o
  elseif ($event = 243) { nx.echo.snotice $2- | halt }

  ; Stats h
  elseif ($event = 244) { nx.echo.snotice $2- | halt }

  ; stats t
  elseif ($event = 249) { nx.echo.snotice $2- | halt }

  ; Permission denied
  elseif ($event = 481) { return }

  ; Higest connection count
  elseif ($event = 250) { return }

  ; serverinfo ( ircu)
  ; There are 1 users and 69 invisible on 3 servers
  ; 5 operator(s) online
  ; 2 unknown connection(s)
  ; 62 channels formed
  ; I have 65 clients and 2 servers
  elseif ($event = 251) { return }
  elseif ($event = 252) { return }
  elseif ($event = 253) { return }
  elseif ($event = 254) { return }
  elseif ($event = 255) { return }
  ; Current local  users: 65  Max: 93
  ; Current global users: 70  Max: 1540
  elseif ($event = 265) { return }
  elseif ($event = 266) { return }

  ; Server load is temporarily too heavy
  elseif ($event = 263) { return }

  ; Gline list
  elseif ($event = 280) { return }
  ; End of /gline list
  elseif ($event = 281) { return }

  ; auto away
  elseif ($event = 301) { return }

  ; external host
  elseif ($event = 302) { return }

  ; marked as away - no longer marked as away
  elseif ($event = 306) { return }
  elseif ($event = 305) { return }

  ; Channel mode is
  elseif ($event = 324) { return }

  ; Channel URL is 
  elseif ($event = 328) { return }

  ; Channel mode set timestap ????
  elseif ($event = 329) { return }

  ; WHOIS
  ; nick ident host * realname
  ; TODO, use %nx.echoquery.whois. $+ $cid $+ . $+ $nick
  ; replace -at with $window or something ? or a whole new echo line with elseif 
  elseif ($event = 311) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $chr(45) | echo %nx.echo.color -at $2 is $+($3,@,$4-) | halt } | else { return } }
  ; is identified for this nick
  elseif ($event = 307) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 on $3- | halt } | else { return } }
  ; nick is using modes
  elseif ($event = 379) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; nick is connecting from
  elseif ($event = 378) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; whois nick is on channel
  elseif ($event = 319) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 on $3- | halt } | else { return } }
  ; whois nick using server
  elseif ($event = 312) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 using $3- | halt } | else { return } }
  ; Is connected via the webircgateway
  elseif ($event = 350) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $1 $5- | halt } | else { return } }
  ; nick is an IRC opetator
  elseif ($event = 313) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; nick is using Secure Connection
  elseif ($event = 671) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; logged in as
  elseif ($event = 330) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 is logged in as $3 | halt } | else { return } }
  ; is a bot on "network"
  elseif ($event = 335) { return }
  ; is aviaible for help
  elseif ($event = 310) { return }
  ; nick "landcode" is connecting from "land"
  elseif ($event = 344) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 $4- | halt } | else { return } }
  ; nick is using ip with a reputation 
  elseif ($event = 320) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; nick is using a secure connection
  elseif ($event = 275) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; nick has client certificate
  elseif ($event = 276) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; using host
  elseif ($event = 338) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 is actually $3 $+($chr(91),$4,$chr(93)) | halt } | else { return } }
  ; idle time
  elseif ($event = 317) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 has been idle for $duration($3) and signed on $duration($calc($ctime - $4)) ago ( $date($4,HH:mm:ss dd-mmm yyyy) ) | halt } }
  ; End of whois
  elseif ($event = 318) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | echo %nx.echo.color -at $chr(45) | halt } | else { return } }

  ; topline of /list "Channel Users Name"
  elseif ($event = 321) { return }

  ; /list - end of /list
  elseif ($event = 322) { return }
  elseif ($event = 323) { 
    if ( %checkforircop ) { echo 3 -at %checkforircop Finished scanning for Ircops. | unset %checkforircop }
    return
  }

  ; whowas + end of whowas
  elseif ($event = 314) { return }
  elseif ($event = 369) { return }

  ; no topic set 
  elseif ($event = 331) { return }

  ; topic and topic created
  elseif ($event = 332) { return }
  elseif ($event = 333) { return }

  ; /userip result
  elseif ($event = 340) { 
    ; Check if i'm supposed to gline user, else return userip as normal
    if ( %nx.ag. [ $+ [ $gettok($2,1,61) ] ] == 1 ) { echo -st <Auto Gline> $2, user joined bait-channel | .msg uworld forcegline $+(*@,$gettok($2,2,64)) 8d Auto glined, bye | halt }
    else { echo -at UserIP: $2- | halt }
  }

  ; invited to channel ( 341 $me invited-nick #channel )
  elseif ($event = 341) { echo -at $2 has been invited to $3 | halt }

  ; server info (OS etc)
  ; RAW 351 <nick> <Server version 1.2.3>. <Servername> Fhn6OoErmM [uname -a ??]
  elseif ($event = 351) { return }

  ; /who $chan
  elseif ($event = 352) {
    if ( %checkforircop ) && ( $iif($chr(42) isin $7,true,false) = true ) { echo 3 -at %checkforircop Ircop found: nick ( $6 ) | return }
    elseif ( %nx.joined. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) || ( %nx.ialupdate. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) { 
      inc -u10 %nx.ialchanusers. $+ $cid $+ $2
      ; Check if nick is ircop and color it (for nicklist)
      if (* isin $7) {
        var %t = $comchan($6,0), %c = 1
        while (%c <= %t) {
          ; Here, echo "Nick just opered ???"
          cline -m 13 $comchan($6,%c) $6
          inc %c    
        }
      }
      halt
    }
    else { return }
  }

  ; End of /who
  elseif ($event = 315) { 
    if ( %nx.ialupdate. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) { 
      unset %nx.ialupdate. $+ $cid $+ $2
      halt
    } 
    elseif ( %nx.joined. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) {
      echo 12 -st Updated IAL for $2 with %nx.ialchanusers. [ $+ [ $cid ] ] [ $+ [ $2 ] ] users.
      unset %nx.joined. $+ $cid $+ $2 | unset %nx.ialchanusers. $+ $cid $+ $2 
      halt
    }
    ; Manual /who request, do nothing for now
    else { return }
    return
  }

  ; /names list
  elseif ($event = 353) { return }

  ; end of /names
  elseif ($event = 354) { return }

  ; #chan End of /NAMES list
  elseif ($event = 366) { return }

  ; Ban list
  elseif ($event = 367) {
    if ($dialog(%nx.cc.dname)) && (%nx.cc.getbans == $2) {
      if (Refreshing bans ... iswm $did(%nx.cc.dname,$nx.cc.chk.id(Banlist),1)) { did -d %nx.cc.dname $nx.cc.chk.id(Banlist) 1 }
      did -a %nx.cc.dname $nx.cc.chk.id(Banlist) 0 + 0 0 0 $3 $+ 	+ 0 0 0 $4 $+ 	+ 0 0 0 $asctime($5,dd/mm/yyyy HH:nn)
      ; did -a %nx.cc.dname $nx.cc.chk.id(Banlist) $3 
      ; did -a %nx.cc.dname $nx.cc.chk.id(BanSetBy) $4
      ; did -a %nx.cc.dname $nx.cc.chk.id(BanSetDate) $asctime($5,dd/mm/yyyy HH:nn)
      return

    }
    return
  }
  ; End of banlist
  elseif ($event = 368) {
    if ($dialog(%nx.cc.dname)) && (%nx.cc.getbans == $2) {
      if ($did(%nx.cc.dname,$nx.cc.chk.id(Banlist)).lines == 1) && (Refreshing bans ... iswm $did(%nx.cc.dname,$nx.cc.chk.id(Banlist),1)) {
        did -ra %nx.cc.dname $nx.cc.chk.id(Banlist) No bans set.
        did -ra %nx.cc.dname $nx.cc.chk.id(numbans) 0/ $+ $iif(%nx.maxbans. [ $+ [ $cid ] ],$v1,unknown)
      }
      else { did -ra %nx.cc.dname $nx.cc.chk.id(numbans) $calc($did(%nx.cc.dname,$nx.cc.chk.id(Banlist)).lines -1) $+ / $+ $iif(%nx.maxbans. [ $+ [ $cid ] ],$v1,unknown) }
      unset %nx.cc.getbans
    }
    halt
  }

  ; /links list
  elseif ($event = 364) { 
    write links $+ $network $+ .db $2 $3
    
    return 
  }
  ; end of /links list
  elseif ($event = 365) { return }

  ; /info
  elseif ($event = 371) { return }
  elseif ($event = 374) { return }

  ; MOTD start - motd - end of motd
  elseif ($event = 375) { return }
  elseif ($event = 372) { return }
  elseif ($event = 376) { return }

  ; You are now an IRC operator
  elseif ($event = 381) { window -De $+(@,$network,_,$cid,_,status) | halt }

  ; ircd.conf Rehashing
  elseif ($event = 382) { nx.echo.snotice $1- | halt }

  ; naka^ +bcdfkoqsBOS Server notice mask
  elseif ($event = 8) { nx.echo.snotice $1- | halt }

  ; is now your displayed host
  elseif ($event = 396) { return }

  ; no souch nick ( $2 )
  elseif ($event = 401) { 
    if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt }
    else { return }
  }

  ; No such channel
  elseif ($event = 403) { return }

  ; Cannot send to channel
  elseif ($event = 404) { return }

  ; Unknown command
  elseif ($event = 421) { return }

  ; MOTD file missing
  elseif ($event = 422) { return }

  ; nickname is unavailable: illegal characters
  elseif ($event = 432) { return }

  ; Nickname is already in use
  ; TODO add a check if you are on dalnet with Guest* nick,  /msg NickServ@services.dal.net RELEASE $me password

  elseif ($event = 433) { 
    if ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) {
      echo a $gettok($nx.db(read,settings,nickserv,$network),1,32) and $1
      if ( $gettok($nx.db(read,settings,nickserv,$network),1,32) = $2 ) {
        .msg nickserv ghost $2 $gettok($nx.db(read,settings,nickserv,$network),2,32)
      }
    }
  }
  ; 437 YourNICK #channel :Cannot change nickname while banned on channel or channel is moderated
  ; 437 #channel Nick/channel is temporarily unavailable ( From EFNet ) 
  elseif ($event = 437) { 
    if ( $3-6 == Nick/channel is temporarily unavailable ) { return }
    elseif ( $1 = $me ) && ( $1 != $nx.db(read,settings,mainnick,$network) ) && ( $left($1,1) = $chr(38) ) {

      ; TODO, count number of tries and delay part\rejoin if it fails too many times
      if ( $timer(_chnick) ) { .part $2 | .timer_rejoin_ $+ $2 1 10 .join $2 }
      else { .part $2 | .timer_chnick 1 1 .nick $nx.db(read,settings,mainnick,$network) | .timer_rejoin_ $+ $2 1 10 .join $2 }
    }
  }

  ; Target change too fast.
  elseif ($event = 439) { return }

  ; Nick #channel They aren't on that channel
  elseif ($event = 441) { return }
 
  ; You're not on that channel
  elseif ($event = 442) { return }

  ; nick is already on channel
  elseif ($event = 443) { return }

  ; Cannot join channel (+b)
  elseif ($event = 474) { return }

  ; nick register first
  elseif ($event = 451) { return }

  ; /admin return
  elseif ($event = 256) { return }
  elseif ($event = 257) { return }
  elseif ($event = 258) { return }
  elseif ($event = 259) { return }

  ; Not enough parameters
  elseif ($event = 461) { return }

  ; Glined
  elseif ($event = 465) { return }

  ; Channel key already set
  elseif ($event = 467) { return }

  ; unkonwn mode ( nick N is unknown mode char to me )
  elseif ($event = 472) { return }

  ; :Cannot join channel (+i) ( $2 = channel )
  ; TODO use %nx.loggedon or something before .msg 
  ; Todo, use settings to get the botname (uworld) because it can change
  elseif ( $event = 473 ) { if ( $istok($nx.db(read,settings,operchans,$network),$2,32)) { .timer_ai_ $+ $2 1 10 .msg euworld invite $2 $me } | return }

  ; invalid password
  elseif ($event = 464) { return }

  ; Only servers can change that mode
  elseif ($event = 468) { return }

  ; Cannot join channel transfering 
  elseif ($event = 470) { return }

  ; Cannot join channel ( +l )
  elseif ($event = 471) { return }

  ; Cannot join channel (+k)
  elseif ($event = 475) { 
    if ( $network == $gettok(%nx.secret.channel,1,32) ) && ( $1 == $gettok(%nx.secret.channel,2,32) ) { msg $gettok(%nx.secret.channel,3,32) invite $1 }
    return
  }

  ; You need a registered nick to join that channel.
  elseif ($event = 477) { return }

  ; You're not an channel operator
  elseif ($event = 482) { echo -at * $+($1,:) You're not channel operator | halt }

  ; No Operator block for your host
  elseif ($event = 491) { echo -at * $+($1,:) No Operator block for your host | halt }

  ; You're not a channel owner
  elseif ($event = 499) { echo -at * $+($1,:) You're not channel owner | halt }

  ; Unknown user MODE flag
  elseif ($event == 501) { return }
  ; Cannot join channel
  elseif ($event = 520) { return }

  ; You have 0 and are on 0 WATCH entries
  elseif ($event = 603) { return }

  ; nefarious ssl
  ; $me $me has client certificate fingerprint E95DC2020C6463088AAB47B38961B6E868F9C7C6B8D42201F1913A45BC1CA458
  elseif ($event = 616) { return }

  ; MODE cannot be set due to channel having a active MLOCK restriction (thru chanserv)
  elseif ($event = 742) { return }

  ; You are now logged in as $2
  elseif ($event = 900) { return }

  ; K +i must be set (When setting +K)
  elseif ($event = 974) { return }

  else { nx.echo.raw $event $1- }
}
