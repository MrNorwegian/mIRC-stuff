alias join {
  ; /join #chan1,chan2,#chan3 key,chan4 key
  ; Todo, check for & also. for now vanilla /join &localchan
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
  ; POPUPS: .Op:{ massmode op $chan $1- }
  ; TODO på deop, sjekk om bruker er +k, skipp dem eller legg de til helt på slutten (så man ikke går glipp av antall deops i begynnelsen)
  if ( $3 ) {
    if ( $1 ) {
      if ( $left($1,2) = de ) { var %nx.mass.mode $iif($1 = deop,o,v), %nx.mass.action take }
      else { var %nx.mass.mode $iif($1 = op,o,v), %nx.mass.action give }
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
      if ( $numtok(%nx.mass.nicks,32) = $modespl ) { .mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks }
      dec %nx.mass.num
    }
    if ( %nx.mass.nicks ) { .mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks }
  }
}
alias massv2 {
  ; /massv2 #chan voice\devoice 10 (voice\devoice 10 of the channel users
  ; /massv2 #chan voice\devoice 2 d (voice\devoice 1\2 of the channel users
  ; /massv2 #chan voice\devoice 4 d (voice\devoice 1\4 of the channel users, etc
  if ( $2 = voice ) || ( $2 == devoice ) {
    var %x = $iif($2 = voice,$nick($1,0,r),$nick($1,0,v)) }, %m v 
    if ( $4 = d ) { var %x $iif($chr(46) isin $calc(%x / $3),$gettok($calc(%x / $3),1,46),$calc(%x / $3)) }
    elseif ( $isnum($3) ) { var %x $3 }
    while (%x) { 
      var %n = %n $iif($2 = voice,$nick($1,%x,r),$nick($1,%x,v))
      if ($numtok(%n,32) = $modespl) { mode $1 $+($iif($2 = voice,$chr(43),$chr(45)),$str(%m,$modespl)) %n | unset %n } 
      dec %x
    }
    if (%n) { mode $1 $+($iif($2 = voice,$chr(43),$chr(45)),$str(%m,$modespl)) %n | unset %n }
  }
}
