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
  elseif ($event = 006) { return }

  ; End of /map
  elseif ($event = 007) { return }

  ; /map sumary (last line in /map)
  elseif ($event = 018) { return }

  ; /map return (ircu)
  elseif ($event = 015) { return }

  ; End of /map
  elseif ($event = 017) { return }

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
  elseif ($event = 353) { return }
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
  elseif ($event = 381) { return }
  ; naka^ +bcdfkoqsBOS Server notice mask
  elseif ($event = 8) { return }

  ; is now your displayed host
  elseif ($event = 396) { return }

  ; no souch nick ( RAW 401 naka idlerpg No such nick )
  elseif ($event = 401) { return }

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
