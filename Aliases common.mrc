alias nx.echo.error { echo 4 -at $1- }
alias nx.echo.raw { echo 7 -at DEBUG: $1- }
alias nx.echo.setting { echo 15 -at $+(-,Setting,-) $1- }
alias nx.echo.joinpart {
  if ( $1 = part ) { 
    if ( $3 == $me ) { 
      if ( $istok(%nx.znc.chans. [ $+ [ $cid ] ],$2,44) ) { echo 12 -t $2 * Disconnected }
      else { echo 3 -t $2 * You have left $2 }
    }
    ; Possible bug, p (or a) might be wrong, not tested
    ; Temoporarily replaced r with space, do i need to specify regular users ? :/
    else { echo 3 -t $2 * $replace($4,q,~,p,&,o,@,h,%,v,+,r,$chr(32)) $3 $+($chr(40),$ial($3,1).addr,$chr(41)) has left $2 } 
  }
  if ( $1 = join ) {
    if ( $3 == $me ) { echo 3 -t $2 * Now talking in $2 }
    else { echo 3 -t $2 * $3 $+($chr(40),$ial($3,1).addr,$chr(41)) has joined $2 $iif($4, $+(54,$chr(40),$4-,$chr(41)),$null) } 
  }
}
; This alias is kinda just placeholder for now, will be used to show custom quit events with the mode user had on every common channel
; usage /nx.echo.quit <chan> <nick> <address> <reason>
alias nx.echo.quit { echo 2 -t $2 $3 $4 has quit $5- }

; Flood limit this incase of flood attack, also consider echo to a own "notice window" or to a status window in addition to echo to active window
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
; Placeholder for custom perform stuff
alias nx.perform { return }

alias nx.db {
  ; $nx.db(read,settings,operchans,$network)
  ; /nx.db write settings operchans #chan1 #chan2 #chan3
  ; /nx.db rem\del settings operchans
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
  elseif ( $1 = rem ) || ( $1 = del ) {
    if ( $2 = settings ) { remini nx.settings.ini $iif($3,$3) $iif($4,$4) }
    if ( $2 = ial ) { remini -n $+(ial\,$network,_,$cid,.ini) $iif($3,$3) $iif($4,$4) }
  }
}
alias w { set -u2 %nx.echoactive.whois true | nx.whois $1- }
alias j { nx.join $1- }
alias p { nx.part $1- }
alias n { names #$$1 }
alias q { query $$1 }
alias k { kick # $$1 $2- }
alias s { server $$1- }
alias c { close -t $$1 }
alias chat { dcc chat $$1 }
alias ping { ctcp $$1 ping }

; Consider to use the same logic as in alias join, where "/hop channel" wil work
alias hop {
  if ( $chan ) {
    if ( $1 ) { set -u4 %nx.hop $1 | hop $1 }
    else { set -u4 %nx.hop $chan | hop $chan }
  }
  else { echo 4 -at Usage /hop <channel> or /hop while on an active channel | halt }
}
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
  else { echo -at Usage $chr(36) $+ random(99,CNR,ULR) }
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
