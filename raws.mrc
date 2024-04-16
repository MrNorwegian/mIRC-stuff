raw *:*:{
  ; ack
  if ($event = ack) { return }

  ; caps supported
  if ($event = cap) { return }

  ; batch +eJ2YePPoPApi8e95KGaJfU chathistory #opers
  ; batch -eJ2YePPoPApi8e95KGaJfU
  elseif ($event = batch) { return }

  ; chghost naka netadmin.ircworld.net
  elseif ($event = chghost) { return }

  ; Welcome
  elseif ($event = 001) { return }

  ; your host
  elseif ($event = 002) { 
    if ( $6-7 = running version ) { 
      if ( UnrealIRCd isin $8 ) { 
        if ( $istok(%nx.supnet.unreal,$network,32) ) { return }
        else { set %nx.supnet.unreal $addtok(%nx.supnet.unreal,$network,32) | set %nx.supnet.samode $addtok(%nx.supnet.samode,$network,32) | return }
      }
      elseif ( u2.10.12 isin $8 ) { 
        if ( $istok(%nx.supnet.ircu2,$network,32) ) { return }
        else { set %nx.supnet.ircu2 $addtok(%nx.supnet.ircu2,$network,32) | set %nx.supnet.opmode $addtok(%nx.supnet.opmode,$network,32) | return }
      }
      ; need to confirm samode is right for ratbox, also efnet runs ratbox and something else?
      elseif ( ircd-ratbox-3 isin $8 ) { 
        if ( $istok(%nx.supnet.ratbox,$network,32) ) { return }
        else { set %nx.supnet.ratbox $addtok(%nx.supnet.ratbox,$network,32) | set %nx.supnet.samode $addtok(%nx.supnet.samode,$network,32) | return }
      }
      ; add bircd,snircd,inspircd
    }
  }

  ; Server created
  elseif ($event = 003) { return }

  ; server info
  elseif ($event = 004) { return }

  ; modes supported
  elseif ($event = 005) { return }

  ; /map return (unrealircd)
  ; End of /map (unrealircd)
  ; /map sumary (last line in /map) (unrealircd)
  elseif ($event = 006) { echo -t $+(@,$network,_,status) -t $1- | return }
  elseif ($event = 007) { echo -t $+(@,$network,_,status) -t $1- | return }
  elseif ($event = 018) { echo -t $+(@,$network,_,status) $2- | return }

  ; /map return (ircu)
  ; End of /map (ircu)
  elseif ($event = 015) { echo -t $+(@,$network,_,status) $2- | return }
  elseif ($event = 017) { echo -t $+(@,$network,_,status) $2- | return }

  ; stats l
  elseif ($event = 211) { return }

  ; stats m
  elseif ($event = 212) { return }

  ; Stats c (ircu)
  elseif ($event = 213) { return }

  ; stats i
  elseif ($event = 215) { return }
  
  ; stats p
  elseif ($event = 217) { return }

  ; stats y
  elseif ($event = 218) { return }

  ; End of /stats
  elseif ($event = 219) { return }

  ; stats v
  elseif ($event = 236) { return }

  ; Stats f
  elseif ($event = 238) { return }
  ; Server up
  elseif ($event = 242) { return }

  ; stats o
  elseif ($event = 243) { return }

  ; Stats h
  elseif ($event = 244) { return }

  ; stats t
  elseif ($event = 249) { return }

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

  ; Channel mode is
  elseif ($event = 324) { return }

  ; Channel mode set timestap ????
  elseif ($event = 329) { return }

  ; WHOIS
  ; nick is ident@host * realname
  elseif ($event = 311) { return }
  ; is identified for this nick
  elseif ($event = 307) { return }
  ; nick is using modes
  elseif ($event = 379) { return }
  ; nick is connecting from
  elseif ($event = 378) { return }
  ; whois nick is on channel
  elseif ($event = 319) { return }
  ; whois nick using server
  elseif ($event = 312) { return }
  ; nick is an IRC opetator
  elseif ($event = 313) { return }
  ; nick is using Secure Connection
  elseif ($event = 671) { return }
  elseif ($event = 330) { return }
  ; nick is using ip with a reputation 
  elseif ($event = 320) { return }
  ; nick has client certificate
  elseif ($event = 276) { return }
  ; nick is logged in as
  elseif ($event = 330) { return }
  ; using host
  elseif ($event = 338) { return }
  ; idle time
  elseif ($event = 317) { return }
  ; End of whois
  elseif ($event = 318) { return }

  ; end of /who
  elseif ($event = 315) { return }
  ; /list
  elseif ($event = 322) { return }

  ; end of /list
  elseif ($event = 323) { 
    if ( %checkforircop ) { echo 3 -at %checkforircop FERDIG ! | unset %checkforircop }
  }

  ; topic
  elseif ($event = 332) { return }

  ; topic creator with timestamp ????
  elseif ($event = 333) { return }

  ; server info (OS etc)
  ; RAW 351 naka UnrealIRCd-6.1.4. Champingvogna.da9.no Fhn6OoErmM [Linux IrcStuff 6.1.0-17-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.69-1 (2023-12-30) x86_64=6100]
  elseif ($event = 351) { return }
  ; This is gonna be a part of my custom $ial 
  ; RAW 352 naka #valhalla UWorld H*@diw UWorld@UWorld.deepnet.chat :3 UWorld
  ; RAW 352 naka^ #oslo.no iron 172.16.164.2 *.undernet.org MrIron H*@ 3 MrIron
  ; /who list
  elseif ($event = 352) {
    if ( %checkforircop ) && ( $iif($chr(42) isin $7,true,false) = true ) { echo 3 -at %checkforircop Fant en ircop: nick ( $6 ) }
    else { return }
  }

  ; RAW 353 MYNICK = #CHANNEL nick1!ident@host +nick2!ident@host @nick3!ident@host ~@nick3!ident@host @+nick3!ident@host 
   ; /NAMES list
   ; &nakauser!nakauser@10.13.37.31
   ; +Biggs!Biggs@172.19.211.133
   ; @%+Cade!Cade@172.19.215.245
   ; ~@%Cohbert!Cohbert@172.19.100.185/
  elseif ($event = 353) { 
    var %nx.ial.n 4
    while ($gettok($1-,%nx.ial.n,32)) {
      ; $remove is used to remove the [ from the nick because of bug
      var %nx.ial.tmpnick $remove($gettok($gettok($1-,%nx.ial.n,32),1,33),$chr(91)), %nx.ial.mi 1
      if ( $readini($+(ial\,$network,.ini),$3,%nx.ial.tmpnick) ) { remini -n $+(ial\,$network,.ini) $3 %nx.ial.tmpnick }
      while (%nx.ial.mi) {
        if ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = ~) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,q,46) | goto nx.ial.nextmode }
        elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = &) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,a,46) | goto nx.ial.nextmode }
        elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = @) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,o,46) | goto nx.ial.nextmode }
        elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = %) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,h,46) | goto nx.ial.nextmode }
        elseif ($mid(%nx.ial.tmpnick,%nx.ial.mi,1) = +) { var %nx.ial.tmpmode $addtok(%nx.ial.tmpmode,v,46) | goto nx.ial.nextmode }
        elseif ( %nx.ial.tmpmode ) { writeini -n $+(ial\,$network,.ini) $3 $mid(%nx.ial.tmpnick,%nx.ial.mi,$len(%nx.ial.tmpnick)) %nx.ial.tmpmode | unset %nx.ial.tmpmode | goto nx.ial.nextnick }
        else { writeini -n $+(ial\,$network,.ini) $3 %nx.ial.tmpnick r | goto nx.ial.nextnick }
        :nx.ial.nextmode
        inc %nx.ial.mi
      }
      :nx.ial.nextnick
      inc %nx.ial.n
    }
    echo -st Saved userlist in $3 with $numtok($4-,32) users
    return
  }
  ;writeini -n $+(ial\,$network,.ini) $3 $remove(%nx.ial.tmpnick,~&@%+) v
  ; End of /NAMES list
  elseif ($event = 366) { return }

  ; /links list
  elseif ($event = 364) { return }
  ; end of /links list
  elseif ($event = 365) { return }

  ; MOTD start
  elseif ($event = 375) { return }

  ; MOTD
  elseif ($event = 372) { return }

  ; end of motd
  elseif ($event = 376) { return }

  ; You are now an IRC operator
  elseif ($event = 381) { window -De $+(@,$network,_,status) | return }
  ; naka^ +bcdfkoqsBOS Server notice mask
  elseif ($event = 8) { return }

  ; is now your displayed host
  elseif ($event = 396) { return }

  ; no souch nick ( RAW 401 naka idlerpg No such nick )
  elseif ($event = 401) { return }

  ; Unknown command
  elseif ($event = 421) { return }

  ; MOTD file missing
  elseif ($event = 422) { return }

  ; Nickname is already in use
  elseif ($event = 433) { return }

  ; Invite only channel
  if ( $event = 473 ) {
    if ( $istok(%nx.network_ $+ $network $+ _operchans,$2,32) ) { .msg uworld invite $2 $me }
  }

  ; invalid password (from znc)
  elseif ($event = 464) { return }
  ; Cannot join channel
  elseif ($event = 520) { return }

  else { decho RAW $event $1- }
}
