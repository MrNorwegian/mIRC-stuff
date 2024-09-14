; connectall is just a bunch of /server -m
on *:start:{ if ( %nx.autoconnect = yes ) { connectall } }

on 1:connect:{ 
  set %nx.flood.query. $+ $cid 0
  return 
}

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
  ; Ignore emech when excecuted a command
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

; Just some placeholders
on 1:mode:#:{ return }
on 1:nick:{ return }

on ^*:join:#:{
  if ( $nick == $me ) { nx.echo.joinpart join $chan $me | set -u5 %nx.joined. $+ $cid $+ $chan 1 }
  else {
    if ( $me !isvoice $chan ) && ( $chan = #IdleRPG ) {
      ; TODO, make a list of all IdleRPG bots in settings.ini file, and check if idlerpg is oped, (has to be another check)
      ; Maby make a tmp variable and do the .msg in on mode ? 
      if ( $address($nick,5) == IdleBot!idlerpg@idlebot.users.deepnet.chat ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
      if ( $address($nick,5) == idlerpg!multirpg@idlerpg.users.undernet.org ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
      if ( $address($nick,5) == idlerpg!*IdleRPG@idle.rpgsystems.org ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
      if ( $address($nick,5) == IdleRPG!idlerpg@2a03:b0c0:1:d0::aea:b001 ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.adminpass }
    }
    ; Auto perform on znc when service bots becomes online if we are not authed
    ; Idea: make use of /notify ?? this needs to se the bot join a channel, with notify i dont need to join any channels to get the notice
    if ( $nick == X ) && ( $network == UnderNet ) && ( .users.undernet.org !isin $address($me,2) ) && ( %nx.autoperform.xjoined. [ $+ [ $network ] ] != 1 ) { set -u5 %nx.autoperform.xjoined. $+ $network 1 | .msg *perform Execute }
    if ( $nick == Q ) && ( $network == QuakeNet ) && ( .users.quakenet.org !isin $address($me,2) ) && ( %nx.autoperform.qjoined. [ $+ [ $network ] ] != 1 ) { set -u5 %nx.autoperform.qjoined. $+ $network 1 | .msg *perform Execute }

    ; Bug: number 4 is showing same subnet but that's mostly false-positive, need to only check this if hostname is an IP, or if it's a dns use userip, if *.users. ignore it.
    ; Clonescan, 1 3 4 = $address($nick,X)
    var %nx.jck 1 3 4, %c 1
    while ( $gettok(%nx.jck,%c,32) ) { 
      ; Is it more than 1 clone?
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
    ; auto gline on baitchannel 
    if ( $nx.db(read,settings,opernet,$network) ) && ( $chan == #bait-channel.do.not.join.you.will.be.glined ) {
      ; Check if nick is not me and not in first operchan in settings
      if ( $nick != $me ) && ( $nick !ison $gettok($nx.db(read,settings,operchans,$network),1,32) ) {
        ; Check if ~ isin ident and user is not authed and ident is not nick
        var %nx.ag.ident $gettok($gettok($address($nick,5),1,64),2,33)
        var %nx.ag.host $gettok($address($nick,5),2,64)
        if ( ~ isin %nx.ag.ident ) && ( .users. !isin %nx.ag.host) && ( $nick !isin %nx.ag.ident ) {
          ; Check if host is ip, else do userip and msg uworld in raws.mrc
          if ( $iptype(%nx.ag.host) == ipv4 ) { echo -st <Auto Gline> $address($nick,5) - User joined bait-channel | .msg uworld forcegline $+(*@,%nx.ag.host) 8d Auto glined, bye bye! }
          else { set -u10 %nx.ag. $+ $nick 1 | userip $nick }
        }
      }
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
  else {
    ; echo -st $nick($chan,$nick).pnick $nick
    ; TODO test if  pnick is a good replacement for the while loop, jsut need a unrealircd server to test +q+a+h
    ; This setup is not checking % (helpop)
    ; IDEA, make a join\part flood protection
    var %nx.onpart.modes ~,&,@,+
    var %nx.onpart.i $numtok(%nx.onpart.modes,44)
    while (%nx.onpart.i) { 
      if ( $nick($chan,$nick,$gettok(%nx.onpart.modes,%nx.onpart.i,44)) ) { var %nx.onpart.m $addtok(%nx.onpart.m,$gettok(%nx.onpart.modes,%nx.onpart.i,44),32) }
      dec %nx.onpart.i
    }
    ; echo -at aftr while %nx.onpart.m
    nx.echo.joinpart part $chan $nick $iif(%nx.onpart.m,$remove(%nx.onpart.m,$chr(32)),$null)
    halt
  }
}

; TODO, loop channels and show mode the user had (like we do on part), this is not needed if we do not edit quit event message
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
  ; IDEA, echo time and date on open
  ; TODO, check if pr server $cid is working right

  ; check for own botnet or znc
  if ( $istok(%nx.botnet_ [ $+ [ $network ] ],$nick,32)) || ($left($nick,1) = $chr(42) ) { return }
  else {
    var %nx.flood.query.ugh 3
    var %nx.flood.query.max 5
    var %nx.flood.query.godhelpme 10
    var %nx.flood.query.time 10

    inc -u10 %nx.flood.query. $+ $cid 1

    if (%nx.flood.query. [ $+ [ $cid ] ] >= %nx.flood.query.godhelpme) {
      echo 4 -st Anti Query flood has blocked %nx.flood.query. $+ $cid query's, this time $nick, now ignoring *!~*@* for 10 seconds
      ignore -u10 *!~*@*
      .timer_nx.flood.query. $+ $cid 1 %nx.flood.query.time dec %nx.flood.query. $+ $cid
      close -m $nick
    }
    elseif (%nx.flood.query. [ $+ [ $cid ] ] >= %nx.flood.query.max) {
      echo 4 -st Anti Query flood has blocked %nx.flood.query. $+ $cid query's, this time $nick
      ignore -u60 $address($nick,2)
      .timer_nx.flood.query. $+ $cid 1 %nx.flood.query.time dec %nx.flood.query. $+ $cid
      close -m $nick
      ; Check for an usermode and see if i can set mode $me +something to prevent unauthed users to query me, it has to be pr server, ircu does not support this
    }
    elseif (%nx.flood.query. [ $+ [ $cid ] ]  >= %nx.flood.query.ugh) {
      echo 4 -st Anti Query flood has blocked %nx.flood.query query's, this time $nick
      ignore -u60 $address($nick,2)
      .timer_nx.flood.query. $+ $cid 1 %nx.flood.query.time dec %nx.flood.query. $+ $cid
      close -m $nick
    }
    else {
      set -u2 %nx.echoactive.whois true
      whois $nick $nick
      .timer_nx.flood.query. $+ $cid 1 %nx.flood.query.time dec %nx.flood.query. $+ $cid
    }
  }
}

;ctcp 1:time:?:/ctcpreply $nick TIME $date(ddd ddoo mmm yyyy hh:mmt) ;| halt
;ctcp 1:ping:?:/ctcpreply $nick PING Ouch!
