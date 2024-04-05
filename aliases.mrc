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

alias massmode {
  ; /massmode op\deop\voice\devoice #chan nick nick1 nick2
  ; POPUPS: .Op:{ massmode op $chan $$1- }
  ; POPUPS: .Op:{ massmode botnet_op $chan $$1- }
  ; POPUPS: .Op:{ massmode oper_op $chan $$1- }
  ; TODO: Check if user is +k then skip it ( Use cached info from /who channel ? )
  ; TODO: Idea, use X, Q, ChanServ ?
  ; TODO: Idea, when ircop use uworld\opmode\samode ?
  ; - Check if $me has +go usermode, p10 use opmode, unrealircd samode, etc
  if ( $3 ) {
    if ( $1 ) {
      if ( $left($1,7) = botnet_ ) { var %nx.mass.usebotnet 1 }
      if ( $left($1,5) = oper_ ) { var %nx.mass.useopermode 1 }
      if ( $left($remove($1,botnet_,oper_),2) = de ) { var %nx.mass.mode $iif($remove($1,botnet_,oper_) = deop,o,v), %nx.mass.action take }
      else { var %nx.mass.mode $iif($remove($1,botnet_,oper_) = op,o,v), %nx.mass.action give }
    }
    var %nx.mass.num $numtok($3-,32)
    while (%nx.mass.num) { 
      if ( %nx.mass.action = take ) {
        if ( $gettok($3-,%nx.mass.num,32) isop $chan ) && ( %nx.mass.mode = o ) { .var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
        elseif ( $gettok($3-,%nx.mass.num,32) isvoice $chan ) && ( %nx.mass.mode = v ) { .var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
      }
      if ( %nx.mass.action = give ) {
        if ( $gettok($3-,%nx.mass.num,32) !isop $chan ) && ( %nx.mass.mode = o ) { .var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
        elseif ( $gettok($3-,%nx.mass.num,32) !isvoice $chan ) && ( %nx.mass.mode = v ) { .var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
      }
      ; Finished gather nicks for this round
      if ( $numtok(%nx.mass.nicks,32) = $modespl ) { 
        if ( %nx.mass.usebotnet = 1 ) { 
          var %nx.mass.bot $nx.mass.pickbot
          if ( %nx.mass.bot ) { msg %nx.mass.bot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks " | unset %nx.mass.nicks }
          else { echo 4 -at No bots active or oped in chan }
        }
        elseif ( %nx.mass.useopermode = 1 ) { .opmode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
        elseif ( $me isop $chan ) { .mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
        else { echo -at $me - You're not channel operator }
      }
      dec %nx.mass.num
    }
    ; Finish off
    if ( %nx.mass.nicks ) {
      if ( %nx.mass.usebotnet = 1 ) {
        var %nx.mass.bot $nx.mass.pickbot
        if ( %nx.mass.bot ) { msg %nx.mass.bot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks " | unset %nx.mass.nicks %nx.mass.usebotnet }
        else { echo 4 -at No bots active or oped in chan }
      }
      elseif ( %nx.mass.useopermode = 1 ) { .opmode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
      elseif ( $me isop $chan ) { .mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks | unset %nx.mass.nicks }
      else { echo -at $me - You're not channel operator }
    }
  }
}

alias nx.mass.pickbot {
  ; Need to redo this alias, check if dcc chat is open
  ; Note to self: $chat(botnick).status, check if nz.botnet_$network is set
  ; Bug, if no bots is OP the loop doesnt stop (ctrl + break)
  var %nx.botnet.pickbot $numtok(%nx.botnet_ [ $+ [ $network ] ],32)
  ;;;;
  ; Idea, while doesnt get used, skip it and just do the gogo loop with while ?
  while (%nx.botnet.pickbot) { 
    :nx.botnet.pickbot
    if ( %nx.botnet.nextbot >= %nx.botnet.pickbot ) { set %nx.botnet.nextbot 1 }
    else { inc %nx.botnet.nextbot }
    ; Find next bot
    var %nx.botnet.tmpbot $gettok(%nx.botnet_ [ $+ [ $network ] ],%nx.botnet.nextbot,32)
    if ( %nx.botnet.tmpbot isop $chan ) && ( $chat(%nx.botnet.tmpbot).status = active ) { return $+(=,%nx.botnet.tmpbot) }
    else { goto nx.botnet.pickbot }
    dec %nx.botnet.pickbot
  }
}

alias nx.botnet.control {
  ; Note to self, in the future make this compact
  ; /nx.botnet.control join\part #chan bot1 bot2 bot3
  ; POPUPS: .join:{ nx.botnet.control join $$?="Channel?" $$1- }
  ; POPUPS: .say:{ nx.botnet.control say $$?="Channel?" $$1- }
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
          msg $+(=,$gettok($3-,%i,32)) .chattr %nx.botnet.chattr.nick %nx.botnet.chattr.flags $iif(%nx.botnet.chattr.where = GLOBAL,$NULL,$chan)
        }
        elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
        dec %i
      }
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
}

alias massv2 {
  ; Popups
  ; Mass
  ; .voice:{ massv2 $chan voice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0)) }
  ; .devoice:{ massv2 $chan devoice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0)) }
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
