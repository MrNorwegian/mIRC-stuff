; connectall is just a bunch of /server -m
on *:start:{ if ( %nx.autoconnect = yes ) { connectall } }

on 1:connect:{ return }

on 1:disconnect:{ 
  unset %nx.maxbans. [ $+ [ $cid ] ]
  unset %nx.silencenum. [ $+ [ $cid ] ]
  unset %nx.topiclen. [ $+ [ $cid ] ]
  unset %nx.anex_ [ $+ [ $cid ] ]
  unset %nx.anex_lastcmd_ [ $+ [ $cid ] ]
}

on 1:exit:{ unset %mi %mech.* %nx.maxbans.* %nx.silencenum.* %nx.topiclen.* %nx.anex_* %nx.anex_lastcmd_.* %nx.flood.query }

on ^1:notice:*:?:{
  if ($istok(%nx.services.bots,$nick,32)) {
    ; TODO Check if it's really nickserv (hostname)
    if ($nick = NickServ) {
      if (This nickname is registered. isin $1-4) && ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) {
        if ( $gettok($nx.db(read,settings,nickserv,$network),1,32) = $me ) {
          .msg nickserv identify $me $gettok($nx.db(read,settings,nickserv,$network),2,32)
        }
      }
      if ( has been ghosted. isin $2-4 ) && ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) { 
        nick $strip($1)
      }
      else { nx.echo.notice $nick $1- | halt }
    }
    elseif (( $nick = UWorld ) || ($nick == Bworld)) && ( $nx.db(read,opernet,$network) ) {
      nx.echo.notice $nick $1-
      if ( $5 = authenticated ) { halt }
      ; Bworld says nick. and uworld says nick! 
      elseif ( $1- = Authentication successful as ) {
        ; TODO add %nx.loggedon to confirm in raw (invite) before doing msg bworld invite
        var %nx.check.onoperchan $nx.db(read,settings,operchans,$network)
        while ( %nx.check.onoperchan >= 0 ) {
          if ( $me !ison $gettok($nx.db(read,settings,operchans,$network),%nx.check.onoperchan,32) ) { .msg $nick invite $gettok($nx.db(read,settings,operchans,$network),%nx.check.onoperchan,32) }
          dec %nx.check.onoperchan
        }
      }
    }
    else { nx.echo.notice $nick $1- }
    halt
  }
  ; Ignore spambots when excecuted a command
  elseif ( 172.1 isin $address($nick,2) ) && ( %mechfloodprotect ) {
    if ( $5 = immortal ) { halt }
    elseif ( $3 = already ) { halt }
    elseif ( $1 = already ) { halt }
    elseif ( $1 = Message ) { halt }
    elseif ( $1 = Attempting ) { halt }
    elseif ( $1 = Parting) { halt }
    elseif ( $1 = Cycling) { halt }
    elseif ( $2 = open) { halt }
    else { nx.echo.notice $nick $1- | halt }
  } 
  elseif ( $1-9 = As master you really need to set a password: ) { 
    .timer_autosetpass 1 2 msg $nick pass p455w0rd 
    nx.echo.notice $nick $1-
    halt
  }
  else { nx.echo.notice $nick $1- | halt }
}

; Script from genthic, might modify this later
on 1:NOTICE:*:#:{
  if ( $istok(%nx.genethic.channels,$chan,32) ) {
    if ( $me $+ ?requested?DCC??code?is iswm $2-6 ) {
      .timerDCC1 4 1 .echo = $+ $nick mIRC Script: Please wait, your password will be sent to the session in a few seconds
      .timerDCC2 1 5 .msg = $+ $nick $7
    }
  }
}
; When on znc i need this to make sure snotice windows is up 
on 1:usermode:{ if ( o isincs $1 ) && ( $left($1,1) == $chr(43) ) { window -De $+(@,$network,_,$cid,_,status) | echo 3 -st You are now an IRC Operator on $network } }

on 1:mode:#:{ return }

on 1:nick:{ return }

on *:join:*:{
  if ( $me !isvoice $chan ) && ( $chan = #IdleRPG ) && ( $nick != $me ) {
    ; TODO make a check on timer to check if bot is gettig OP
    if ( $address($nick,5) = IdleBot!idlerpg@idlebot.users.deepnet.chat ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
    if ( $address($nick,5) = idlerpg!multirpg@idlerpg.users.undernet.org ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
    if ( $address($nick,5) = idlerpg!*IdleRPG@idle.rpgsystems.org ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
  }
}

on ^*:join:#:{
  if ( $nick == $me ) { nx.echo.joinpart join $chan $me | set -u5 %nx.joined. $+ $cid $+ $chan 1 }
  else { 
    var %nx.jck 1 3 4, %c 1
    while ( $gettok(%nx.jck,%c,32) ) { 
      if ($ialchan($address($nick,$gettok(%nx.jck,%c,32)),$chan,N) > 1) && (!%nx.jc) { 
        var %nx.jc $ialchan($address($nick,$gettok(%nx.jck,%c,32)),$chan,N), %i 1
        var %nx.jcn %nx.jc
        if ($gettok(%nx.jck,%c,32) == 1) { var %nx.jcn $addtok(%nx.jcn,Clones:,32) }
        elseif ($gettok(%nx.jck,%c,32) == 3) { var %nx.jcn $addtok(%nx.jcn,Possible clones:,32) }
        elseif ($gettok(%nx.jck,%c,32) == 4) { var %nx.jcn $addtok(%nx.jcn,Same subnet:,32) }
        while (%i <= %nx.jc) {
          if ( $ialchan($address($nick,$gettok(%nx.jck,%c,32)),$chan,%i).nick != $nick ) && ($numtok(%nx.jcn,32) < 6) { var %nx.jcn $addtok(%nx.jcn,$ialchan($address($nick,$gettok(%nx.jck,%c,32)),$chan,%i).nick,32) }
          inc %i
        }
      }
      inc %c
    }
    nx.echo.joinpart join $chan $nick %nx.jcn
  }
  halt
}

on ^*:part:#:{ 
  if ( $nick == $me ) { 
    if ( %nx.hop = $chan ) { unset %nx.hop  }
    else { nx.echo.joinpart part $chan $me }
  }
  else { nx.echo.joinpart part $chan $nick }
  halt
}

on *:quit:{ return }

on ^1:SNOTICE:*:{ nx.echo.snotice $1- | halt }

on *:invite:*:{ if ( $istok($nx.db(read,settings,operchans,$network),$chan,32) ) { join $chan } }

on 1:text:*:?:{ 
  if ( $nick === *status ) { 
    ; second IF $3 has no . but first has, restof second $4- (No route to host). Reconnecting...
    ; BU, when disconnected and reconnect does not work this loops
    if ( $1-3 == Disconnected from IRC. ) || ( $1-3 == Disconnected from IRC ) { 
      var %c $chan(0) 
      while (%c) { 
        ; if channel key is set, save it!
        set %nx.znc.chans. $+ $cid $addtok(%nx.znc.chans. [ $+ [ $cid ] ],$chan(%c),44)
        .msg *status detach $chan(%c)
        dec %c
      } 
      echo 12 -st * ZNC Disconnected from IRC.
    }
    if ( $1 = Connected! ) {
      set -u5 %nx.connected. $+ $cid 1
      if (%nx.znc.chans. [ $+ [ $cid ] ]) { join %nx.znc.chans. [ $+ [ $cid ] ] | unset %nx.znc.chans. [ $+ [ $cid ] ] }
    }
    ; TODO, fix buffextra
    ; [23:45:54] <*buffextras> NICK!IDENT@HOST quit: Ping timeout
    ; [23:46:04] <*buffextras> NICK!IDENT@HOST joined
    ; [23:46:04] <*buffextras> NICK!IDENT@HOST joined
    ; [23:46:04] <*buffextras> *.NETWORK.org set mode: +ovov nick1 nick2 nick3 nick4

    ; TODO, make a "start znc playback" and "stop znc playback" command
  }
}

on *:open:?:{
  ; check for own botnet or znc
  if ( $istok(%nx.botnet_ [ $+ [ $network ] ],$nick,32)) || ($left($nick,1) = $chr(42) ) { return }
  else {
    var %nx.flood.query.ugh 4
    var %nx.flood.query.max 10
    var %nx.flood.query.time 10

    inc -u10 %nx.flood.query 1
    if (%nx.flood.query >= %nx.flood.query.max) {
      echo 4 -at Anti Query flood har blokkert %nx.flood.query query'er
      ignore -u60 $address($nick,2)
      .timer_nx.flood.query 1 %nx.flood.query.time dec %nx.flood.query
      close -m $nick
    }
    elseif (%nx.flood.query >= %nx.flood.query.ugh) {
      echo 4 -at Anti Query flood har blokkert %nx.flood.query query'er
      ignore -u60 $address($nick,2)
      .timer_nx.flood.query 1 %nx.flood.query.time dec %nx.flood.query
      close -m $nick
    }
    else {
      whois $nick $nick
      .timer_nx.flood.query 1 %nx.flood.query.time dec %nx.flood.query
    }
  }
}

;ctcp 1:time:?:/ctcpreply $nick TIME $date(ddd ddoo mmm yyyy hh:mmt) ;| halt
;ctcp 1:ping:?:/ctcpreply $nick PING Ouch!
