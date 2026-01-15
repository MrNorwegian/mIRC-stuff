; connectall is just a bunch of /server -m
on *:start:{
  if ( %nx.autoconnect = yes ) { connectall } 
  .timer_nx.announce.newday 00:00:00 1 1 scid -a nx.announce.newday

  nx.ht.load znc znc.ini znc
}

on 1:connect:{
  set %nx.flood.query. $+ $cid 0
  .timer_ialupdate_ $+ $cid 0 $calc($calc(60*15) + $r(1,30)) nx.ialupdate $cid 
}

on 1:disconnect:{
  unset %anexid_ [ $+ [ $cid ] ]
  unset %nx.flood.query. [ $+ [ $cid ] ]
}

on 1:exit:{
  unset %anexid_* %mi %nx.joined.* %mech.* %nx.ialupdate.* %nx.ialchanusers.* %nx.znc.* %nx.flood.query.*

  nx.ht.save znc znc.ini znc
}
; save hashtable to .ini file 
alias nx.ht.save {
  if ($1) && ($2) {
    if ($hget($1)) {
      hsave -i $1 $2 $1 
    }
  }
  else { echo 4 -a nx.ht.save: Missing parameters. - Usage: nx.ht.save <hashtable> <filename> }
}
alias nx.ht.load {
  if ($1) && ($2) {
    if ($isfile($2)) {
      if ($hget($1)) { hfree $1 }
      hload -m100i $1 $2 $1
    }
    else { echo 4 -a nx.ht.load: File $2 does not exist. }
  }
  else { echo 4 -a nx.ht.load: Missing parameters. - Usage: nx.ht.load <hashtable> <filename> }
}

on 1:tabcomp:*:{
  if ( $1 == /nick ) { echo -a Syntax: /nick <newnick> }
  elseif ( $1 == /mode ) {
    echo -a Syntax: /mode <#channel|nick> <modes> [params]
    ; Get modes from ISUPPORT i have to make later in raw.mrc
    ; echo -a Modes:
  }
  ; Provide syntax help for /who command, flags is from ircv3
  if ( $1 == /who ) {
    echo -a Syntax: /who <#channel|mask> <%flags>
    echo -a Flags: nuhsrdlqcxogvt
  }
}
on ^1:notice:*:?:{
  var %nx.notice.cid $cid
  if ($istok(%nx.services.bots,$nick,32)) {
    ; TODO Check if it's really nickserv (hostname)
    if ($nick = NickServ) {
      if (This nickname is registered. isin $1-4) && ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) {
        if ( $gettok($nx.db(read,settings,nickserv,$network),1,32) = $me ) {
          .msg nickserv identify $me $gettok($nx.db(read,settings,nickserv,$network),2,32)
          nx.echo.notice $1-
          halt
        }
      }
      if ( has been ghosted. isin $2-4 ) && ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) { nick $strip($1) | nx.echo.notice $1- | halt }
      else { nx.echo.notice $1- | halt }
    }
    elseif ( $istok(uworld bworld euworld,$nick,32) ) && ( $nx.db(read,opernet,$network) ) {
      nx.echo.notice $1-
      if ( $5 = authenticated ) { halt }
      ; Bworld says nick. and uworld says nick! 
      elseif ( $1-3 = Authentication successful as ) {
        ; TODO add %nx.loggedon to confirm in raw (invite) before doing msg bworld invite
        var %nx.check.onoperchan $nx.db(read,settings,operchans,$network)
        var %o $numtok(%nx.check.onoperchan,32)
        while ( %o ) {
          if ( $me !ison $gettok(%nx.check.onoperchan,%o,32) ) { .msg $nick invite $gettok(%nx.check.onoperchan,%o,32) }
          dec %o
        }
        halt
      }
    }
    elseif ( $nick == X ) { 

      ; Saving channels we have access to, this is used to check if we can msg x instead of mode in chans
      if ( $1 = Channels: ) {
        unset %nx.X.chans. [ $+ [ $network ] ]
        var %i 1
        while ( $gettok($strip($1-),%i,32) ) {
          if ( $left($gettok($strip($1-),%i,32),1) == $chr(35) ) { 
            set %nx.X.chans. [ $+ [ $network ] ] $addtok(%nx.X.chans. [ $+ [ $network ] ],$remove($gettok($strip($1-),%i,32),$chr(44)),32)
          }
          inc %i
        }
      }
      nx.echo.notice $1- | halt
    }
    else { nx.echo.notice $1- | halt }
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
    else { nx.echo.notice $1- | halt }
  } 
  ; Set a temporary password to new eggdrops
  elseif ( $1-9 = As master you really need to set a password: ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$nick,32) ) { 
    .timer_autosetpass_ $+ $nick 1 2 msg $nick pass %nx.botnet_password 
    nx.echo.notice $1-
    halt
  }
  ; ignore znc attached from notices
  ; [12:56:32] *** naka detached from 1.2.3.4
  elseif ( $nick == *status ) && (( $3 == attached ) || ( $3 == detached )) { 
    if ( $3 == attached ) && ($network == UnderNet) {
      ; Ensure hash exists
      if (!$hget(znc)) { hmake znc 900 }
      var %ip $5
      var %user $2

      ; If there is no entry for this IP, store and just echo the original notice
      if ( $hget(znc,%ip) == $null ) {
        hadd znc %ip %user
        echo 8 -st New account attached from this ip: %ip -> %user
      }
      else {
        var %users $hget(znc,%ip)
        ; Check for multiple accounts
        if ( $istok(%users,%user,32) ) {
          if ( $numtok(%users,32) > 1 ) {
            echo 4 -st There is multiple accounts connected to %ip -> %users
          }
        }
        else {
          ; Add the new user to the IP entry
          hadd znc %ip $addtok(%users,%user,32)
          var %users $hget(znc,%ip)
          echo 8 -st New account attached from this ip: %ip -> %users
          ; Notify that a new user has attached to this IP (now multiple accounts)
          if ( $numtok(%users,32) > 1 ) {
            echo 4 -st There is multiple accounts connected to %ip -> %users
          }
        }
      }
      echo 3 -st $nick $1-
    }
    elseif ( $3 == detached ) && ($network == UnderNet) { echo 3 -st $nick $1- }
    halt
  }
  ; Check if nick is eg idlerpg and echo only to status window 
  elseif ( $istok(%nx.echo.status.nicks,$nick,32) ) { set -u1 %nx.notice.status true | nx.echo.notice $1- | halt }
  else { nx.echo.notice $1- | halt }
}

; Script from genthic, might modify this later
on *:NOTICE:*:#:{
  if ( $istok(%nx.genethic.channels,$chan,32) ) {
    if ( $me $+ ?requested?DCC??code?is iswm $2-6 ) {
      .timerDCC1 4 1 .echo = $+ $nick mIRC Script: Please wait, your password will be sent to the session in a few seconds
      .timerDCC2 1 5 .msg = $+ $nick $7
    }
  }
  if ( $istok(#Toronto,$chan,32) ) && ( $nick !isop $chan ) { 
    if (!$istok(%nx.spammode.rm,$chan,44)) {
      if ( $me isop $chan ) { mode $chan +rm }
      else { .!msg x mode $chan +rm }
      set -u30 %nx.spammode.rm $addtok(%nx.spammode.rm,$chan,44)
    }
    spamkickban $chan $nick Spam
    .timer.tor.unmode 1 $calc(60*30) msg x mode $chan -rm
  }
}
on ^1:SNOTICE:*:{ nx.echo.snotice $1- | halt }
on ^1:WALLOPS:*:{ nx.echo.wallops $1- | halt }

; When on znc i need this to make sure snotice windows is up 
on 1:usermode:{
  if ( o isincs $1 ) && ( $left($1,1) == $chr(43) ) { 
    if (!$window($window($+(@,$network,_,$cid,_,status)))) {
      window -De $+(@,$network,_,$cid,_,status)
    }
    echo 3 -st You are now an IRC Operator on $network 
  }
  if ( w isincs $1 ) && ( $left($1,1) == $chr(43) ) { 
    if (!$window($window($+(@,$network,_,$cid,_,status)))) {
      window -De $+(@,$network,_,$cid,_,status)
    }
    echo 3 -st You are now reading Wallops on $network 
  }
}

; Just some placeholders
on 1:nick:{ return }

on ^*:join:#:{
  if ( $nick == $me ) { 
    nx.echo.joinpart join $chan $me
    set %nx.joined. $+ $cid $+ $chan 1
    .timer_nx_ialfill_ $+ $cid $+ _ $+ $chan 1 $r(120,240) nx.who $chan 
  }
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
    if ( $nick == X ) && ( $network == UnderNet ) && ( .users.undernet.org !isin $address($me,2) ) && ( %nx.autoperform.xjoined. [ $+ [ $network ] ] != 1 ) { set -u15 %nx.autoperform.xjoined. $+ $network 1 | .msg *perform Execute }
    if ( $nick == Q ) && ( $network == QuakeNet ) && ( .users.quakenet.org !isin $address($me,2) ) && ( %nx.autoperform.qjoined. [ $+ [ $network ] ] != 1 ) { set -u15 %nx.autoperform.qjoined. $+ $network 1 | .msg *perform Execute }

    ; Clonescan, 1 3 4 = $address($nick,X)
    var %nx.jck 2 3 4, %c 1
    while ( $gettok(%nx.jck,%c,32) ) { 
      ; Is it more than 1 clone?
      var %nx.clonecheck.num $ialchan($address($nick,$gettok(%nx.jck,%c,32)),$chan,N)

      if (%nx.clonecheck.num > 1) && (!%nx.jc) { 
        ; getting number of matching clients and reset %i
        var %nx.jc %nx.clonecheck.num

        ; This %nx.clonereport is the beginning of the message "<num> Clones: nick1 nick2"
        var %nx.clonereport %nx.clonecheck.num

        ; Checking *!*@host\ip
        if ($gettok(%nx.jck,%c,32) == 2) { var %nx.clonereport $addtok(%nx.clonereport,Clones:,32) }

        ; Checking *!*ident@*.host or *!*ident@ip.*
        elseif ($gettok(%nx.jck,%c,32) == 3) { var %nx.clonereport $addtok(%nx.clonereport,Possible clones:,32) }

        ; Checking *!*@*.host or *!*@ip.*
        elseif ($gettok(%nx.jck,%c,32) == 4) {
          ; TODO later pick out .users.net.org with gettok or something. but this ignores *!*@<*Username*>.users.NETWORK.org for "Same subnet"
          if ( $+(users,.,$lower($network)) isin $address($nick,4) ) { unset %nx.clonereport }

          ; If .users is not in the address, check if *!*@ip.* is in the address
          var %nx.ipregex4 ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.\*$
          elseif ( $regex($gettok($address($nick,4),2,64),%nx.ipregex4) ) { var %nx.clonereport $addtok(%nx.clonereport,Same subnet:,32) }

          ; This is just to see if things works, this is not needed
          else { var %nx.clonereport $addtok(%nx.clonereport,Same domain: ,32) }
        }

        ; Gather all nicks in the channel that have matched %nx.jc above 
        ; This only reports the first 6 clones, if you want more, change the number in the if statement ($numtok(%nx.clonereport,32) =< 6)
        ; variable %nx.clonereport is used later ( ns.echo.joinpart join $chan $nick %nx.clonereport )

        ; %nx.clonereport is unset if .users.network isin address($nick,4)
        if (%nx.clonereport !isnum) && (%nx.clonereport != $null) {
          var %i 1
          while (%i <= %nx.jc) {
            var %nx.tmpnick $ialchan($address($nick,$gettok(%nx.jck,%c,32)),$chan,%i).nick
            if ( %nx.tmpnick != $nick ) && ($numtok(%nx.clonereport,32) <= 6) { var %nx.clonereport $addtok(%nx.clonereport,%nx.tmpnick,32) }
            inc %i
          }
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
    ; This is part of antispam (bot joining and spamming about a girl with a phone number and stuff)
    ; First a anoying dude....
    if ( ariciu isin $nick ) || ( ariciu isin $gettok($gettok($address($nick,5),1,64),2,33) ) {
      if ( $me isop $chan ) { mode $chan +b $address($nick,3) | .kick $chan $nick You need to work on your social skills. }
      else { .msg X ban $chan $nick You need to work on your social skills. }
    }

    ; This catches spambots with _ in nick and ident and spamming personal info
    if ( .users. !isin $gettok($address($nick,5),2,64) ) && ( ~ isin $gettok($gettok($address($nick,5),1,64),2,33) ) && ( $remove($gettok($gettok($address($nick,5),1,64),2,33),~) isin $nick ) {
      set -u900 %nx.mcz $addtok(%nx.mcz,$nick,32) 
    }
    nx.echo.joinpart join $chan $nick %nx.clonereport
  }
  halt
}

on ^*:part:#:{ 
  if ( $nick == $me ) { 
    nx.echo.joinpart part $chan $me
    unset %nx.joined. $+ $cid $+ $chan
  }
  else {
    ; echo -st $nick($chan,$nick).pnick $nick
    ; TODO test if  pnick is a good replacement for the while loop, just need a unrealircd server to test +q+a+h
    ; This setup is not checking % (helpop)
    ; IDEA, make a join\part flood protection
    ; Not showing partmessage
    var %nx.onpart.modes ~,&,@,+
    var %nx.onpart.i $numtok(%nx.onpart.modes,44)
    while (%nx.onpart.i) { 
      if ( $nick($chan,$nick,$gettok(%nx.onpart.modes,%nx.onpart.i,44)) ) { var %nx.onpart.m $addtok(%nx.onpart.m,$gettok(%nx.onpart.modes,%nx.onpart.i,44),32) }
      dec %nx.onpart.i
    }
    nx.echo.joinpart part $chan $nick($chan,$nick).pnick $1-
  }
  ; Reop if i'm thelast one without op in the channel
  if ( $me !isop $chan ) && ( $nick($chan,0) <= 2 ) {
    !hop $chan
  }
  halt
}

on ^*:kick:#:{
  if ( $knick == $me ) { 
    nx.echo.kick $ctime $chan $knick $nick $1-
    unset %nx.joined. $+ $cid $+ $chan
  }
  else {
    nx.echo.kick $ctime $chan $knick $nick $1-
  }
  halt
}
on ^*:rawmode:#:{
  nx.echo.mode $ctime $chan $nick $1-
  halt
}

; TODO, loop channels and show mode the user had (like we do on part), this is not needed if we do not edit quit event message
on ^*:quit:{
  ; Some bug with znc i think, timestamp is wrong to doing echo in all comchans
  var %c = $comchan($nick,0)
  while (%c) {
    echo 12 -t $comchan($nick,%c) * $nick ( $+ $address $+ ) Quit $iif($1,$+($chr(40),$1-,$chr(41)),$null)
    if ($nick($comchan($nick,%c),0) <= 2) && (!$comchan($nick,%c).op) { !hop $comchan($nick,%c) }
    dec %c
  }
  halt
}

on *:invite:*:{ if ( $istok($nx.db(read,settings,operchans,$network),$chan,32) ) { join $chan } }

on ^1:text:*:?:{ 
  if ( $nick === *status ) { 
    ;Disconnected from IRC. Reconnecting...
    ; second IF $3 has no . but first has, restof second $4- (No route to host). Reconnecting...
    if ( $1-3 == Disconnected from IRC. ) || ( $1-3 == Disconnected from IRC ) { 
      var %c $chan(0) 
      while (%c) { 
        ; if channel key is set, save it!
        echo 12 -t $chan(%c) ZNC Disconnected from IRC
        ;set %nx.znc.chans. $+ $cid $addtok(%nx.znc.chans. [ $+ [ $cid ] ],$chan(%c),44)
        hadd -m znc.chans $cid $addtok($hget(znc.chans,$cid),$chan(%c),44)
        ; !.msg *status detach $chan(%c)
        dec %c
      }
      set %nx.znc.connected $remtok(%nx.znc.connected,$cid,32)
      echo 12 -st * ZNC Disconnected from IRC.
    }
    elseif ( $1 = Connected! ) {
      set %nx.znc.connected $addtok(%nx.znc.connected,$cid,32)
      set %nx.znc.rejoining $addtok(%nx.znc.rejoining,$cid,32)
      .timer_ $+ $cid 1 10 !.msg *status listchans
    }
    elseif ( $istok(%nx.znc.rejoining,$cid,32) ) { 
      if ( $6 == Detached ) { !.msg *status attach $remove($4,@,+,$chr(32)) }
      if ( $4 == Detached ) { !.msg *status attach $remove($2,@,+,$chr(32)) }
      ; try to rejoin channels that were detached after reconnect, keep trying every 10 seconds until rejoined
      ; TODO maby make a max retry count
      elseif ( *Total*Joined*Detached*Disabled* iswm $1- ) {
        if ( $remove($6,$chr(44)) > 0 ) { .timer_rejoin $+ $cid 1 10 !.msg *status listchans }
        else { set %nx.znc.rejoining $remtok(%nx.znc.rejoining,$cid,32) }
      }
    }
    ; echo text from *status in active window, %nx.znc.popupcmd is a variable set when using znc commands from Popups.mrc
    elseif ( %nx.znc.popupcmd = true ) { echo 11 -at $1- }
  }

  ; TODO move this echo to echo alias? for theme
  echo -t $nick < $+ $nick $+ > $1-
  halt
}

on ^*:TEXT:*:#: {
  ; TODO rebuild this 
  var %nx.highlight.ignore_chans #idlerpg #multirpg
  var %t $1-
  var %h $numtok(%t,32)
  while (%h) {
    if ($findtok(%nx.highlight.nicks,$remove($gettok($1-,%h,32),$chr(44)),1,32)) && (!$findtok(%nx.highlight.ignore_chans,$chan,1,32)) { 
      echo 4 -t $chan $+(<,$nick($chan,$nick).pnick,>) $1-
      window -g2 $chan
      halt
    }
    dec %h
  }

  ; Stolen from https://wiki.znc.in/Buffextras/mIRC
  ; Modified to work with my script
  if ($nick == *buffextras) {
    var %nx.bex.nick = $gettok($1,1,$asc(!))
    var %nx.bex.address = $gettok($1,2,$asc(!))
    var %nx.bex.timestamp $msgstamp

    if ($3 == MODE:) { nx.echo.mode $msgstamp $chan %nx.bex.nick $4- }
    elseif ($2 == QUIT:) { nx.echo.quit $msgstamp $chan %nx.bex.nick %nx.bex.address $3- }
    elseif ($2 == JOINED) { nx.echo.joinpart bejoin $chan %nx.bex.nick %nx.bex.address %nx.bex.timestamp }
    elseif ($2 == PARTED:) { nx.echo.joinpart bepart $chan %nx.bex.nick %nx.bex.address %nx.bex.timestamp }
    elseif (($2 == IS) && ($3 == NOW)) { nx.echo.nick $msgstamp $chan %nx.bex.nick $6 }
    ; nx.echo.kick $ctime $chan $knick $nick $1-
    elseif ($2 == KICKED) { nx.echo.kick $msgstamp $chan $3 %nx.bex.nick $6- }
    elseif ($2 == CHANGED) { nx.echo.topic $msgstamp $chan %nx.bex.nick $6- }
    else { echo 4 -t $+ $msgstamp $chan *** UNHANDLED LINE < $+ $1- $+ > }
    halt
  }

  ; Some spam stuff
  elseif ( irc.supernets.org isin $1- ) && ( $istok(%nx.njspam,$nick,32) ) {
    spamkickban $chan $nick Spam
  }
  ; This is a spam bot that joins and spams 
  elseif ( $istok(%nx.mcz,$nick,32) ) { 
    if ( Hi Guys! It's Madeleine Czura! Just thought I'd leave my number here in case you're lonely isin $1- ) { 
      spamkickban $chan $nick Spam
    }
  }
  ; New antispam 
  var %i = 1
  while ( %nx.spamtext. [ $+ [ %i ] ] ) {
    if ( %nx.spamtext. [ $+ [ %i ] ] iswm $1- ) {
      spamkickban $chan $nick Spam
    }
    inc %i
  }

  ; This takes nicks repeating and also botnet repeating same message
  if ( $istok(#naka #mibotech #toronto,$chan,32) ) { antiflood_check_nickrepeat $chan $nick $1- }

  ; TODO fix nick coloring of @+modes
  nx.echo.chanmsg $ctime $chan $nick $1-
  halt
}

; TODO: add this to anex check (anti excess)
on 1:input:#:{
  ; empty for now
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
      set -u2 %nx.echoquery.whois. $+ $cid $+ . $+ $nick true
      whois $nick $nick
      .timer_nx.flood.query. $+ $cid 1 %nx.flood.query.time dec %nx.flood.query. $+ $cid
    }
  }
}

;ctcp 1:time:?:/ctcpreply $nick TIME $date(ddd ddoo mmm yyyy hh:mmt) ;| halt
;ctcp 1:ping:?:/ctcpreply $nick PING Ouch!
