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
      if ( $left($1,2) = de ) { var %m $iif($1 = deop,o,v), %mt take }
      else { var %m $iif($1 = op,o,v), %mt give }
    }
    var %n $numtok($3-,32)
    while (%n) { 
      if ( %mt = take ) {
        if ( $gettok($3-,%n,32) isop $chan ) && ( %m = o ) { .var %nicks $addtok(%nicks,$gettok($3-,%n,32),32) }
        elseif ( $gettok($3-,%n,32) isvoice $chan ) && ( %m = v ) { .var %nicks $addtok(%nicks,$gettok($3-,%n,32),32) }
      }
      if ( %mt = give ) {
        if ( $gettok($3-,%n,32) !isop $chan ) && ( %m = o ) { .var %nicks $addtok(%nicks,$gettok($3-,%n,32),32) }
        elseif ( $gettok($3-,%n,32) !isvoice $chan ) && ( %m = v ) { .var %nicks $addtok(%nicks,$gettok($3-,%n,32),32) }
      }
      if ( $numtok(%nicks,32) = $modespl ) { .mode $2 $+($iif(%mt = take,-,+),$str(%m,$modespl)) %nicks | unset %nicks }
      dec %n
    }
    if ( %nicks ) { .mode $2 $+($iif(%mt = take,-,+),$str(%m,$numtok(%nicks,32))) %nicks }
  }
}
