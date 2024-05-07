alias join {
  ; /join #chan1,chan2,#chan3 key,chan4 key
  ; Todo, check for &localchan, for now it's vanilla /join &localchan
  if ($1) {
    if ( $left($1,1) = $chr(38) ) { join $1- }
    else {
      var %nx.join.numchan 1 
      while ($gettok($1-,%nx.join.numchan,44)) {
        var %nx.join.tmpchan $gettok($1-,%nx.join.numchan,44)
        ; Check for key
        if ($chr(32) isin %nx.join.tmpchan) { 
          var %nx.join.key $gettok(%nx.join.tmpchan,2,32)
          var %nx.join.tmpchan $gettok(%nx.join.tmpchan,1,32)
          join $iif($mid(%nx.join.tmpchan,1,1) != $chr(35),$+($chr(35),%nx.join.tmpchan),%nx.join.tmpchan) %nx.join.key
        }
        ; No key, just join
        else { join $iif($mid(%nx.join.tmpchan,1,1) != $chr(35),$+($chr(35),%nx.join.tmpchan),%nx.join.tmpchan) }
        inc %nx.join.numchan
      }
    }
  }
  else { echo -at Usage /join #chan1,chan2,#chan3 key,chan4 key }
}

alias random {
  ; $random(12,N) for random 1-9
  ; $random(12,R,R) for random 1-9,a-z,A-Z
  ; $random(12,R,U) for random 1-9,A-Z 
  ; $random(12,R,L) for random 1-9,a-z
  ; $random(12,C,R) for random a-z,A-Z
  ; 12 is length of random string
  if ( $1 isnum ) && ($istok(C N R,$2,32)) { 
    if (!$istok(U L R,$3,32)) && ($istok($2,R,C)) { echo -at Usage $chr(36) $+ random(99,CN,ULR) | halt }
    var %r $1
    while (%r) { 
      var %v $iif($2 = R,$rand(1,2),$iif($2 = C,2,1))
      if ( %v = 1 ) { var %t $+(%t,$rand(1,9)) }
      if ( %v = 2 ) { 
        if ( $3 == U ) { var %t $+(%t,$rand(A,Z)) }
        elseif ( $3 == L ) { var %t $+(%t,$rand(a,z)) }
        elseif ( $3 == R ) { var %t $+(%t,$iif($r(1,2) = 1,$rand(a,z),$rand(A,Z))) }
      }
      dec %r
    }
    return %t
  }
  else { echo -at Usage $chr(36) $+ random(99,CN,ULR) }
}
alias nx.massmode {
  ; /massmode op\deop\voice\devoice #chan nick nick1 nick2
  ; /massmode botnet_op\botnet_deop\oper_op\oper_deop #chan nick nick1 nick2
  ; - botnet_ checks for %nx.botnet_NetWork botnick1 botnick2 and required active dcc chat with bot.
  ; TODO: Check if user is +k then skip it ( Use cached info from /who channel ? )
  ; TODO: Idea, use X, Q, ChanServ ?
  ; TODO: Idea, when ircop use uworld\opmode\samode ? - Check if $me has +go usermode, p10 use opmode, unrealircd samode, etc
  if ( $3 ) {
    if ( $2 ) {
      var %nx.mass.tmpmode $remove($1,botnet_,oper_)
      if ( $istok(owner deowner admin deadmin op deop halfop dehalfop voice devoice,%nx.mass.tmpmode,32) ) {
        if ( $left($1,7) = botnet_ ) { var %nx.mass.usebotnet 1 }
        if ( $left($1,5) = oper_ ) { var %nx.mass.useopermode 1 }

        var %nx.mass.action $iif($left(%nx.mass.tmpmode,2) = de,take,give)
        if (%nx.mass.tmpmode = deowner) || (%nx.mass.tmpmode = owner) { var %nx.mass.mode q }
        elseif (%nx.mass.tmpmode = deadmin) || (%nx.mass.tmpmode = admin) { var %nx.mass.mode a }
        elseif (%nx.mass.tmpmode = deop) || (%nx.mass.tmpmode = op) { var %nx.mass.mode o }
        elseif (%nx.mass.tmpmode = dehalfop) || (%nx.mass.tmpmode = halfop) { var %nx.mass.mode h }
        elseif (%nx.mass.tmpmode = devoice) || (%nx.mass.tmpmode = voice) { var %nx.mass.mode v }
        else { echo -at Invalid mode %nx.mass.tmpmode | return }
        if ( %nx.mass.mode !isin $nickmode ) { echo -at Unsupported mode: %nx.mass.tmpmode | return } 
      }
      var %nx.mass.num $numtok($3-,32)
      while (%nx.mass.num) { 
        if ( %nx.mass.action = take ) {
          if ( $nx.ismode(%nx.mass.mode,$2,$gettok($3-,%nx.mass.num,32)) = $true ) { var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
        }
        if ( %nx.mass.action = give ) {
          if ( $nx.ismode(%nx.mass.mode,$2,$gettok($3-,%nx.mass.num,32)) = $false ) { var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
        }
        ; Finished gather nicks for this round
        if ( $numtok(%nx.mass.nicks,32) = $modespl ) { 
          if ( %nx.mass.usebotnet = 1 ) { 
            var %nx.mass.bot $nx.mass.pickbot
            if ( %nx.mass.bot ) { msg %nx.mass.bot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks " | unset %nx.mass.nicks }
            else { echo -at No bots active or is channel operator }
          }
          elseif ( %nx.mass.useopermode = 1 ) { nx.opmode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
          elseif ( $me isop $chan ) { nx.mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
          else { echo -at $me - You're not channel operator }
        }
        dec %nx.mass.num
      }
      ; Finish off
      if ( %nx.mass.nicks ) {
        if ( %nx.mass.usebotnet = 1 ) {
          var %nx.mass.bot $nx.mass.pickbot
          if ( %nx.mass.bot ) { msg %nx.mass.bot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks " | unset %nx.mass.nicks %nx.mass.usebotnet }
          else { echo -at No bots active or is channel operator }
        }
        elseif ( %nx.mass.useopermode = 1 ) { nx.opmode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
        elseif ( $me isop $chan ) { nx.mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks | unset %nx.mass.nicks }
        else { echo -at $me - You're not channel operator }
      }
    }
    else { echo -at Usage /massmode op\deop\voice\devoice #chan nick nick1 nick2 }
  }
  else { echo -at Usage /massmode op\deop\voice\devoice #chan nick nick1 nick2 }
}

alias decho { echo 7 -a DEBUG: $1- }

alias nx.echo.notice { echo 40 -at $+(-,$1 @ $network,-) $2- }
alias nx.echo.snotice {
  if ( $active = Status Window ) { 
    if ( $strip($1) = connect.LOCAL_CLIENT_CONNECT ) {  echo 5 -t $+(@,$network,_,$cid,_,status) $1- | halt }
    elseif ( $strip($1) = connect.LOCAL_CLIENT_DISCONNECT ) { echo 5 -t $+(@,$network,_,$cid,_,status) $1- | halt }
    elseif ( $strip($1) = nick.NICK_COLLISION ) { echo 5 -t $+(@,$network,_,$cid,_,status) $1- | halt }
    elseif ( $strip($1) = flood.FLOOD_BLOCKED ) { echo 5 -t $+(@,$network,_,$cid,_,status) $1- | halt }

    else { echo 5 -st $1- | halt }
  }
  elseif ( $window($+(@,$network,_,$cid,_,status)) ) { echo 5 -t $+(@,$network,_,$cid,_,status) $1- | halt }
  else { echo 5 -st $1- | halt }    
}
alias nx.opmode {
  ; Placeholder for custom anti excess flood stuff
  if ($istok(%nx.supnet.opmode,$network,32)) { opmode $1- }
  elseif ($istok(%nx.supnet.samode,$network,32)) { samode $1- }
  else { echo -at Unsupported ircd, no opmode or samode | haltdef }
}
alias nx.mode {
  ; Placeholder for custom anti excess flood stuff
  mode $1-
}
alias nx.kick {
  ; Placeholder for custom anti excess flood stuff
  nx.anti.excess kick $1-
}
alias nx.whois {
  ; Placeholder for custom anti excess flood stuff
  nx.anti.excess whois $1-
}
alias nx.msg {
  ; Placeholder for custom anti excess flood stuff
  nx.anti.excess msg $1- 
}
alias .nx.msg { nx.anti.excess .msg $1- }
alias nx.say {
  ; Placeholder for custom anti excess flood stuff
  nx.anti.excess say $1-
}
alias nx.me {
  ; Placeholder for custom anti excess flood stuff
  nx.anti.excess me $1- 
}
alias nx.ctcp {
  ; Placeholder for custom anti excess flood stuff
  nx.anti.excess ctcp $1-
}

alias nx.anti.excess { 
  ; $1 = command
  ; $2 = arg1
  ; $3- = args3+++++++
  ; ircu2\snircd = 4
  ; unreal = 5
  set %nx.anex.freemessage 4
  set %nx.anex.excess 10
  set %nx.anex.delay 2
  set %nx.anex_lastcmd_ $+ $cid $ctime
  if ( %nx.anex.tmpdisabled != true ) {
    var %nx.anex.value $nx.anex.cmd
    ; echo 14 -a FloodDebug %nx.anex.value > %nx.anex.freemessage = $calc(%nx.anex.value - %nx.anex.delay)  cmd: $1 to: $2 message: $3-
    if ( %nx.anex.value > %nx.anex.excess ) { 
      .timer_nx_anex_cmd_ $+ $cid $+ _ $+ $1 $+ %nx.anex.value 1 $calc(%nx.anex.value - %nx.anex.delay) $1 $2 $3-
      if (!%nx.anex_warning_excess) { echo 4 -at <Flood protection> - Please slow down your commands. %nx.anex.value > %nx.anex.excess | set -u10 %nx.anex_warning_excess 1 }
    }
    elseif ( %nx.anex.value > %nx.anex.freemessage ) { 
      .timer_nx_anex_cmd_ $+ $cid $+ _ $+ $1 $+ %nx.anex.value 1 $calc(%nx.anex.value - %nx.anex.delay) $1 $2 $3-
      if (!%nx.anex_warning_first) { echo 7 -at <Flood protection> - Please slow down your commands. %nx.anex.value > %nx.anex.excess | set -u10 %nx.anex_warning_first 1 }
    }
    else { $1 $2 $3- }
  }
  ; Freemessage
  else { $1 $2 $3- }
}

alias nx.anex.cmd {
  if ( %nx.anex_ [ $+ [ $cid ] ] < 0 ) { echo 3 -at Anex below 0 = %nx.anex_ [ $+ [ $cid ] ] | set %nx.anex_ $+ $cid 0 }
  inc %nx.anex_ [ $+ [ $cid ] ] 
  .timer_nx_anex_dec_ $+ $cid $+ _ $+ %nx.anex_ [ $+ [ $cid ] ] $+ _ $+ $ctime 1 %nx.anex_ [ $+ [ $cid ] ] dec %nx.anex_ [ $+ [ $cid ] ]
  return %nx.anex_ [ $+ [ $cid ] ] 
}

alias nx.perform {
  ; Placeholder for custom perform stuff
}

alias nx.db {
  ; $nx.db(read,settings,operchans,$network)
  ; /nx.db write settings operchans #chan1 #chan2 #chan3
  ; /nx.db rem settings operchans
  ; later i wil use hashtables as db and readini as "long storage" 
  if ( $1 = read ) {
    if ( $4 ) {
      if ( $2 = settings ) { return $readini(nx.settings.ini,$3,$4) }
      if ( $2 = ial ) { return $readini($+(ial\,$network,_,$cid,.ini),$3,$4) }
    }
  }
  ; nx.db write operchans\opernet\ircd $network stuff
  elseif ( $1 = write ) {
    if ( $5 ) {
      if ( $2 = settings ) { writeini nx.settings.ini $3 $4 $5- }
      if ( $2 = ial ) {  writeini -n $+(ial\,$network,_,$cid,.ini) $3 $4 $5- }
    }
  }
  ; nx.db rem settings <opt> <opt2>
  elseif ( $1 = rem ) {
    if ( $2 = settings ) { remini nx.settings.ini $iif($3,$3) $iif($4,$4) }
    if ( $2 = ial ) { remini -n $+(ial\,$network,_,$cid,.ini) $iif($3,$3) $iif($4,$4) }
  }
}
; This alias is not finished, +a modes cannot be checked with $nick()
; I need to use a own hash table for this, or use $ialchan() and $ialchan().mode
alias nx.ismode {
  ; $nx.ismode(q,channel,nick) - Check if nick is +q in channel
  if ($istok(q a o h v r,$1,32)) && ($3) {
    var %nx.ismode.mode $nick($2,0,$1)
    while (%nx.ismode.mode) { 
      if ($nick($2,%nx.ismode.mode,$1) = $3) { return $true }
      dec %nx.ismode.mode
    }
    return $false
  }
}
alias nx.mass.pickbot {
  ; Need to redo this alias, it's a mess
  ; Idea, not use botnick but botnick!ident@host ?
  var %nx.botnet.pickbot $numtok(%nx.botnet_ [ $+ [ $network ] ],32)
  while (%nx.botnet.pickbot) { 
    if ( %nx.botnet.nextbot >= %nx.botnet.pickbot ) { set %nx.botnet.nextbot 1 }
    else { inc %nx.botnet.nextbot }
    ; Find next bot
    var %nx.botnet.tmpbot $gettok(%nx.botnet_ [ $+ [ $network ] ],%nx.botnet.nextbot,32)
    if ( %nx.botnet.tmpbot isop $chan ) && ( $chat(%nx.botnet.tmpbot).status = active ) { return $+(=,%nx.botnet.tmpbot) }
    dec %nx.botnet.pickbot
  }
}

alias nx.botnet.control {
  ; Note to self, in the future make this compact
  ; /nx.botnet.control join\part #chan bot1 bot2 bot3
  ; POPUPS: .join:nx.botnet.control join $$?="Channel?" $$1-
  ; POPUPS: .say:nx.botnet.control say $$?="Channel?" $$1-
  if ( $istok(join part,$1,32) ) && ( $3 ) {
    var %nx.botnet_loop_i $numtok($2-,32)
    while (%nx.botnet_loop_i) { 
      if ( $chat($gettok($3-,%nx.botnet_loop_i,32)).status = active) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%nx.botnet_loop_i,32),32) ) {
        msg $+(=,$gettok($3-,%nx.botnet_loop_i,32)) $iif($1 = join,.+chan,.-chan) $2
      }
      elseif ( $gettok($3-,%nx.botnet_loop_i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%nx.botnet_loop_i,32) }
      dec %nx.botnet_loop_i
    }
  }
  elseif ( $istok(chattr,$1,32) ) && ( $3 ) {
    var %nx.botnet.chattr.nick $?="Type a nick" 
    var %nx.botnet.chattr.flags $?="+- flags"
    var %nx.botnet.chattr.where $?="where GLOBAL for global"
    if ( %nx.botnet.chattr.nick ) && ( %nx.botnet.chattr.flags ) { 
      var %i $numtok($3-,32)
      while (%i) { 
        if ( $chat($gettok($3-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
          msg $+(=,$gettok($3-,%i,32)) .chattr %nx.botnet.chattr.nick %nx.botnet.chattr.flags $iif(%nx.botnet.chattr.where = GLOBAL,$NULL,%nx.botnet.chattr.where)
        }
        elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
        dec %i
      }
    }
  }
  elseif ( $istok(chanset,$1,32) ) && ( $3 ) {
    echo -a $1-
    var %i $numtok($5-,32)
    while (%i) { 
      if ( $chat($gettok($5-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($5-,%i,32),32) ) {
        msg $+(=,$gettok($5-,%i,32)) .chanset $2-3 
      }
      elseif ( $gettok($5-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($5-,%i,32) }
      dec %i
    }
  }
  elseif ( $istok(say,$1,32) ) && ( $3 ) {
    var %nx.botnet.say $?="What to say" 
    if ( %nx.botnet.say ) { 
      var %i $numtok($3-,32)
      while (%i) { 
        if ( $chat($gettok($3-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
          msg $+(=,$gettok($3-,%i,32)) .tcl putquick "privmsg $2 $+(:,%nx.botnet.say,")
        }
        elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
        dec %i
      }
    }
  }
  elseif ( $istok(registerns,$1,32) ) && ( $3 ) {
    var %i $numtok($3-,32)
    while (%i) { 
      if ( $chat($gettok($3-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
        msg $+(=,$gettok($3-,%i,32)) .tcl putquick "privmsg nickserv register $2 $gettok($3-,%i,32) $+ @lan.da9.no"
      }
      elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
      dec %i
    }
  }
}
alias nx.masskick {
  if ($3) { 
    var %nx.kick.num $numtok($3-,32)
    while (%nx.kick.num) {
      if ( $left($1,7) = botnet_ ) {
        var %nx.kick.bot $nx.mass.pickbot
        if ( %nx.kick.bot ) { msg %nx.kick.bot .tcl putquick "kick $2 $gettok($3-,%nx.kick.num,32) $iif(%nx.masskick.reason,%nx.masskick.reason,$null) " }
        else { echo -at No bots active or is channel operator }
      }
      elseif ( $me isop $2 ) { nx.kick $2 $gettok($3-,%nx.kick.num,32) $iif(%nx.masskick.reason,%nx.masskick.reason,$null) }
      else { echo -at $me - You're not channel operator }
      dec %nx.kick.num
    }
    unset %nx.masskick.reason
  }
  else { echo -at Usage /nx.masskick kick\botnet_kick #chan nick nick1 nick2 }
}

; Idea: is it possible to merge this to massmode ?
alias nx.massban {
  if ($3) && ( $istok(ban unban botnet_ban botnet_unban,$1,32) ) { 
    if ( $left($1,7) = botnet_ ) { var %nx.ban.usebotnet 1 }
    var %nx.ban.num $numtok($3-,32)
    while (%nx.ban.num) { 
      var %nx.ban.tmpaddr $address($gettok($3-,%nx.ban.num,32),5)
      if ( $istok(ban botnet_ban ,$1,32) ) { 
        if ( %nx.ban.nextrund isop $2 ) { 
          var %nx.ban.addrNick $addtok(%nx.ban.addrNick,$address(%nx.ban.addrNick,5),32) 
          var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,-o),-o) 
          unset %nx.ban.nextrund
        }
        var %nx.ban.addrNick $addtok(%nx.ban.addrNick,%nx.ban.tmpaddr,32)
        var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,+b),+b)
        ; Here, check if nick is +qao
        if ( $gettok($3-,%nx.ban.num,32) isop $2 ) {
          if ($numtok(%nx.ban.addrNick,32) != $modespl) { 
            var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,-o),-o)
            var %nx.ban.addrNick $addtok(%nx.ban.addrNick,$gettok($3-,%nx.ban.num,32),32) 
          }
          else { set %nx.ban.nextrund $gettok($3-,%nx.ban.num,32) }
        }
      }
      ; Take is not finished or tested, need to check if user is banned
      if ( $istok(unban botnet_unban ,$1,32) ) { 
        var %nx.ban.addrNick $addtok(%nx.ban.addrNick,%nx.ban.tmpaddr,32) 
        var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,-b),-b)
      }
      ; Finished gather address for this round
      if ($numtok(%nx.ban.addrNick,32) = $modespl) { 
        if ( %nx.ban.usebotnet = 1 ) { msg $nx.mass.pickbot .tcl putquick "mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
        elseif ( $me isop $2 ) { nx.mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
        else { echo -at $me - You're not channel operator }
      }
      dec %nx.ban.num
    }
    ; Finish off
    if ( %nx.ban.addrNick ) { 
      if ( %nx.ban.usebotnet = 1 ) { msg $nx.mass.pickbot .tcl putquick "mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
      elseif ( $me isop $2 ) { nx.mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
      else { echo -at $me - You're not channel operator }
    }
    unset %nx.masskick.reason
  }
  else { echo -at Usage /massban ban\unban #chan nick nick1 nick2 }
}

alias massv2 {
  ; Popups
  ; Mass
  ; .voice:massv2 $chan voice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0))
  ; .devoice:massv2 $chan devoice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0))
  ; /massv2 #chan voice\devoice 10 (voice\devoice 10 of the channel users
  ; /massv2 #chan voice\devoice 2 d (voice\devoice 1\2 of the channel users
  ; /massv2 #chan voice\devoice 4 d (voice\devoice 1\4 of the channel users, etc
  if (($2 = voice) || ($2 == devoice)) {
    if ( $isnum($3) ) { 
      var %nx.mass.num $3
      if ( $4 = d ) { 
        var %nx.mass.num = $iif($2 = voice,$nick($1,0,r),$nick($1,0,v)) 
        var %nx.mass.tc $calc(%nx.mass.num / $3) 
        var %nx.mass.num $iif($chr(46) isin %nx.mass.tc,$gettok(%nx.mass.tc,1,46),%nx.mass.tc) 
      }
    }
    else { var %nx.mass.num = $iif($2 = voice,$nick($1,0,r),$nick($1,0,v)) }
    var %nx.mass.mode v 
    while (%nx.mass.num) { 
      var %nx.mass.nicks = %nx.mass.nicks $iif($2 = voice,$nick($1,%nx.mass.num,r),$nick($1,%nx.mass.num,v))
      if ($numtok(%nx.mass.nicks,32) = $modespl) { mode $1 $+($iif($2 = voice,$chr(43),$chr(45)),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
      dec %nx.mass.num
    }
    if (%nx.mass.nicks) { mode $1 $+($iif($2 = voice,$chr(43),$chr(45)),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks | unset %nx.mass.nicks }
  }
}

; nx.*tok is a replacement for $addtok, $remtok, $istok that is case sensitive
; $nx.remtok(a b c,C,32) returns a b c C
alias nx.addtok {
  if ( $3 ) { 
    var %value $1, %token $2, %delim $3, %i 1
    return $+(%value,$chr(%delim),%token)
  }
}
; $nx.remtok(a b B c,b,32) returns a B c 
alias nx.remtok {
    if ($3) {
    var %value $1, %token $2, %delim $3, %i 1
    var %len $numtok(%value,%delim)
    while ( %i <= %len) {
      if ( %token !isincs $gettok(%value,%i,%delim) ) { var %newvalue $iif(%newvalue,$+(%newvalue,$chr(%delim),$gettok(%value,%i,%delim)),$gettok(%value,%i,%delim)) }
      inc %i
    }
    return %newvalue
  }
}
; $nx.istok(a B c,b,32) returns $false
; $nx.istok(a b c,b,32) returns $true  
alias nx.istok {
  if ($3) {
    var %value $1, %token $2, %delim $3, %i 1
    var %len $numtok(%value,%delim)
    while ( %i <= %len) {
      if ( %token isincs $gettok(%value,%i,%delim) ) { return $true }
      inc %i
    }
    return $false
  }
}

; Thanks wikichip (https://en.wikichip.org/wiki/mirc/thread)
alias pause {
  if ($1 !isnum 1-) return
  var %a = $ticks $+ .vbs
  write %a wscript.sleep $1
  .comopen %a wscript.shell
  if (!$comerr) .comclose %a $com(%a,Run,3,bstr,%a,uint,0,bool,true) 
  .remove %a
}

alias showhash {
  if ( $1 ) {
    if ( $hget($1,0) ) { 
      var %i = 1
      while ( %i <= $hget($1,0).item ) { 
        echo -a $hget($1,%i).item => $hget($1,%i).data
        inc %i
      }
    }
    else { echo -a Hash table $1 is empty }
  }
  else { echo -a Usage: /showhash <name> }
}

; Thanks nnscript (https://nnscript.com/)
alias wait {
  var %o = $calc($nnticks + $1)
  while ($nnticks < %o) { }
}

alias nnticks {
  if (%precisetiming) {
    if ($nndll(PerformanceCounter)) { return $v1 }
    else {
      unset %precisetiming
      thmerror -s Precise timing is not available on your PC. Option unset.
      return $calc($ticks /1000)
    }
  }
  else { return $calc($ticks /1000) }
}