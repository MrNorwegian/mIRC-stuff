raw *:*:{
  ; ack
  if ($event = ack) { return }
  elseif ($event = cap) { return }

  ; batch +eJ2YePPoPApi8e95KGaJfU chathistory #opers ; batch -eJ2YePPoPApi8e95KGaJfU
  elseif ($event = batch) { return }

  ; chghost naka hostname.info
  elseif ($event = chghost) { return }

  elseif ($event = account) { return }

  ; Welcome
  elseif ($event = 001) { set %nx.ial.update true | return }

  ; your host
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
      ; add bircd,inspircd,and others
      else { return }
    }
  }

  ; Server created - Server info - modes supported
  elseif ($event = 003) { return }
  elseif ($event = 004) { return }
  elseif ($event = 005) { 
    ; ircu
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
  elseif ($event = 006) { nx.echo.snotice $2- | halt }
  elseif ($event = 018) { nx.echo.snotice $2- | halt } 
  elseif ($event = 007) { nx.echo.snotice $2- | halt } 

  ; /map return (ircu)
  ; End of /map (ircu)
  elseif ($event = 015) { nx.echo.snotice $2- | halt } 
  elseif ($event = 017) { nx.echo.snotice $2- | halt } 

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

  ; auto away
  elseif ($event = 301) { return }

  ; marked as away - no longer marked as away
  elseif ($event = 306) { return }
  elseif ($event = 305) { return }

  ; Channel mode is
  elseif ($event = 324) { return }

  ; Channel mode set timestap ????
  elseif ($event = 329) { return }

  ; WHOIS
  ; nick ident host * realname
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
  ; nick is an IRC opetator
  elseif ($event = 313) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; nick is using Secure Connection
  elseif ($event = 671) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; logged in as
  elseif ($event = 330) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 is logged in as $3 | halt } | else { return } }
  ; nick "landcode" is connecting from "land"
  elseif ($event = 344) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 $4- | halt } | else { return } }
  ; nick is using ip with a reputation 
  elseif ($event = 320) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; nick has client certificate
  elseif ($event = 276) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | halt } | else { return } }
  ; using host
  elseif ($event = 338) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 is actually $3 $+($chr(91),$4,$chr(93)) | halt } | else { return } }
  ; idle time
  elseif ($event = 317) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2 has been idle for $duration($3) and signed on $duration($calc($ctime - $4)) ago ( $date($4,HH:mm:ss dd-mmm yyyy) ) | halt } }
  ; End of whois
  elseif ($event = 318) { if ( %nx.echoactive.whois = true ) { echo %nx.echo.color -at $2- | echo %nx.echo.color -at $chr(45) | halt } | else { return } }

  ; end of /who
  elseif ($event = 315) { return }

  ; /list - end of /list
  elseif ($event = 322) { return }
  elseif ($event = 323) { 
    ; TODO merge this into custom $ial
    if ( %checkforircop ) { echo 3 -at %checkforircop Finished scanning for Ircops. | unset %checkforircop }
    return
  }

  ; no topic set 
  elseif ($event = 331) { return }

  ; topic and topic created
  elseif ($event = 332) { return }
  elseif ($event = 333) { return }

  ; server info (OS etc)
  ; RAW 351 naka UnrealIRCd-6.1.4. Champingvogna.da9.no Fhn6OoErmM [Linux IrcStuff 6.1.0-17-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.69-1 (2023-12-30) x86_64=6100]
  elseif ($event = 351) { return }
  ; This is gonna be a part of my custom $ial 
  ; RAW 352 naka #valhalla UWorld H*@diw UWorld@UWorld.deepnet.chat :3 UWorld
  ; RAW 352 naka^ #oslo.no iron 172.16.164.2 *.undernet.org MrIron H*@ 3 MrIron
  ; /who list
  elseif ($event = 352) {
    ; TODO merge this into custom $ial
    if ( %checkforircop ) && ( $iif($chr(42) isin $7,true,false) = true ) { echo 3 -at %checkforircop Ircop found: nick ( $6 ) | return }
    else { return }
  }

  ; RAW 353 MYNICK = #CHANNEL nick1!ident@host +nick2!ident@host @nick3!ident@host ~@nick3!ident@host @+nick3!ident@host 
  ; /NAMES list
  ; &nakauser!nakauser@10.13.37.31
  ; +Biggs!Biggs@172.19.211.133
  ; @%+Cade!Cade@172.19.215.245
  ; ~@%Cohbert!Cohbert@172.19.100.185/
  elseif ($event = 353) { 
    if ( %nx.ial.update. [ $+ [ $cid ] ] ) { 
      var %nx.ial.n 4
      while ($gettok($1-,%nx.ial.n,32)) {
        ; $remove is used to remove the [ from the nick because of bug
        var %nx.ial.tmpnick $remove($gettok($gettok($1-,%nx.ial.n,32),1,33),$chr(91)), %nx.ial.mi 1
        if ( $readini($+(ial\,$network,_,$cid,.ini),$3,%nx.ial.tmpnick) ) { remini -n $+(ial\,$network,_,$cid,.ini) $3 %nx.ial.tmpnick }
        while (%nx.ial.mi) {
          if ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = ~) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,q,46) | goto nx.ial.nextmode }
          elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = &) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,a,46) | goto nx.ial.nextmode }
          elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = @) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,o,46) | goto nx.ial.nextmode }
          elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = %) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,h,46) | goto nx.ial.nextmode }
          elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = +) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,v,46) | goto nx.ial.nextmode }
          elseif ( %nx.ial.tmpmode ) { writeini -n $+(ial\,$network,_,$cid,.ini) $3 $mid(%nx.ial.tmpnick,%nx.ial.mi,$len(%nx.ial.tmpnick)) %nx.ial.tmpmode | unset %nx.ial.tmpmode | goto nx.ial.nextnick }
          else { writeini -n $+(ial\,$network,_,$cid,.ini) $3 %nx.ial.tmpnick r | goto nx.ial.nextnick }
          :nx.ial.nextmode
          inc %nx.ial.mi
        }
        :nx.ial.nextnick
        inc %nx.ial.n
      }
      set %nx.ial.sumnicks $calc($numtok($4-,32) + %nx.ial.sumnicks)
      halt
    }
    else { return }
  }

  ; End of /NAMES list
  elseif ($event = 366) { 
    if ( %nx.ial.update. [ $+ [ $cid ] ] ) {
      echo -st Saved userlist in $2 with %nx.ial.sumnicks nicks
      .timer_ial_update 1 5 unset %nx.ial.update. [ $+ [ $cid ] ]
      unset %nx.ial.sumnicks %nx.ial.update. [ $+ [ $3 ] ]
      halt 
    }
    else { return }
  }

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
  elseif ($event = 364) { return }
  ; end of /links list
  elseif ($event = 365) { return }

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
  elseif ($event = 401) { return }

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
  elseif ($event = 433) { 
    if ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) {
      echo a $gettok($nx.db(read,settings,nickserv,$network),1,32) and $1
      if ( $gettok($nx.db(read,settings,nickserv,$network),1,32) = $2 ) {
        .msg nickserv ghost $2 $gettok($nx.db(read,settings,nickserv,$network),2,32)
      }
    }
  }
  ; Nick\Channel is temporarily unavailable
  elseif ($event = 437) { return }

  ; You're not on that channel
  elseif ($event = 442) { return }

  ; nick is already on channel
  elseif ($event = 443) { return }

  ; Not enough parameters
  elseif ($event = 461) { return }

  ; unkonwn mode ( nick N is unknown mode char to me )
  elseif ($event = 472) { return }

  ; :Cannot join channel (+i) ( $2 = channel )
  elseif ( $event = 473 ) { if ( $istok($nx.db(read,settings,operchans,$network),$2,32)) { .msg uworld invite $2 $me } | return }

  ; invalid password
  elseif ($event = 464) { return }

  ; Only servers can change that mode
  elseif ($event = 468) { return }

  ; You need a registered nick to join that channel.
  elseif ($event = 477) { return }

  ; You're not an channel operator
  elseif ($event = 482) { echo -at * $+($1,:) You're not channel operator | halt }

  ; You're not a channel owner
  elseif ($event = 499) { echo -at * $+($1,:) You're not channel owner | halt }

  ; Cannot join channel
  elseif ($event = 520) { return }

  ; You have 0 and are on 0 WATCH entries
  elseif ($event = 603) { return }

  ; nefarious ssl
  ; $me $me has client certificate fingerprint E95DC2020C6463088AAB47B38961B6E868F9C7C6B8D42201F1913A45BC1CA458
  elseif ($event = 616) { return }

  ; You are now logged in as $2
  elseif ($event = 900) { return }

  ; K +i must be set (When setting +K)
  elseif ($event = 974) { return }

  else { decho RAW $event $1- }
}
