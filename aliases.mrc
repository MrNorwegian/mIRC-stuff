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
  ; POPUPS: .Op:{ massmode botnetop $chan $$1- }
  ; TODO på deop, sjekk om bruker er +k, skipp dem eller legg de til helt på slutten (så man ikke går glipp av antall deops i begynnelsen)
  if ( $3 ) {
    if ( $1 ) {
      if ( $left($1,6) = botnet ) { var %nx.mass.usebotnet 1 }
      if ( $left($remove($1,botnet),2) = de ) { var %nx.mass.mode $iif($remove($1,botnet) = deop,o,v), %nx.mass.action take }
      else { var %nx.mass.mode $iif($remove($1,botnet) = op,o,v), %nx.mass.action give }
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
      if ( $numtok(%nx.mass.nicks,32) = $modespl ) { 
        if ( %nx.mass.usebotnet = 1 ) { msg $nx.mass.pickbot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks " | unset %nx.mass.nicks }
        else { .mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks }
      }
      dec %nx.mass.num
    }
    if ( %nx.mass.nicks ) {
      if ( %nx.mass.usebotnet = 1 ) { msg $nx.mass.pickbot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks " | unset %nx.mass.nicks %nx.mass.usebotnet %nx.mass.bots }
      else { .mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks | unset %nx.mass.nicks }
    }
  }
}

alias nx.mass.pickbot {
  ; Need to redo this alias, check if dcc chat is open
  ; Note to self: $chat(botnick).status
  var %nx.mass.findbot $numtok(%nx.botnet_ [ $+ [ $network ] ],32)
  while (%nx.mass.findbot) { 
    :mx.mass.pickbot
    if ( %nx.mass.bots > 1 ) { dec %nx.mass.bots }
    else { set %nx.mass.bots $numtok(%nx.botnet_ [ $+ [ $network ] ],32) }
    if ( $gettok(%nx.botnet_ [ $+ [ $network ] ],%nx.mass.bots,32) isop $chan ) { return $+(=,$v1) }
    else { goto mx.mass.pickbot }
    dec %nx.mass.findbot
  }
}

alias nx.botnet.control {
  ; Note to self, in the future make this compact
  ; /nx.botnet.control join\part #chan bot1 bot2 bot3
  ; POPUPS: .join:{ nx.botnet.control join $$?="Channel?" $$1- }
  ; POPUPS: .say:{ nx.botnet.control say $$?="Channel?" $$1- }
  if ( $istok(join part,$1,32) ) && ( $3 ) {
    var %i $numtok($2-,32)
    while (%i) { 
      if ( $chat($gettok($3-,%i,32)).status = active) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
        msg $+(=,$gettok($3-,%i,32)) $iif($1 = join,.+chan,.-chan) $2
      }
      elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
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
