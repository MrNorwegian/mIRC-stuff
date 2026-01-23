; Starting with theme stuff, this is going to be moved to own file later
alias p { return $+($chr(40),$1-,$chr(41)) }
; alias for -
alias dash { return $+($chr(45),$1-,$chr(45)) }
alias p1 { return $+($chr(60),$1-,$chr(62)) }

; Common aliases for echoing stuff
alias nx.echo.info { echo 5 -at $1- }
alias nx.echo.error { echo 4 -at $1- }
alias nx.echo.raw { echo 7 -st DEBUG: $1- }
alias nx.echo.setting { echo 15 -at $+(-,Setting,-) $1- }
alias nx.echo.joinpart {
  if ( $1 = part ) { 
    if ( $3 == $me ) { 
      if ( $istok(%nx.znc.chans. [ $+ [ $cid ] ],$2,44) ) { echo 12 -t $2 * Disconnected }
      else { echo 3 -t $2 * You have left $2 | echo 3 -st You parted: $2 }
    }
    else { echo 3 -t $2 * $3 $p($ial($remove($3,~,&,@,%,+),1).addr) has left $2 } 
  }
  elseif ( $1 = join ) {
    if ( $3 == $me ) { echo 3 -t $2 * Now talking in $2 | echo 3 -st You joined: $2 }
    else { echo 3 -t $2 * $3 $p($ial($3,1).addr) has joined $2 $iif($4,$+(54,$p($4-)),$null) } 
  }
  ; ZNC *buffextras messages
  elseif ( $1 == bejoin ) { echo 3 -t $+ $5 $2 * $3 $p($4) has joined $3 }
  elseif ( $1 == bepart ) { echo 3 -t $+ $5 $2 * $3 $p($4) has parted $3 }

  else { echo 4 -st Syntax error in nx.echo.joinpart, DEBUG Network: $network Server: $server Text: $1- | halt }
}

; This is not finshed yet, need to figure out how to color ircops and op\voice + add unrealircd modes
; TODO make new name for this alias later
alias dev.chkmodes {
  if ( ~ isin %pnick ) { var %modecolor $cnick(~).color }
  elseif ( & isin %pnick ) { var %modecolor $cnick(&).color }
  elseif ( @ isin %pnick ) { var %modecolor $cnick(@).color }
  elseif ( + isin %pnick ) { var %modecolor $cnick(+).color }
  else { var %modecolor $null }
  return %modecolor
}
; ctime chan nick message
alias nx.echo.chanmsg {
  var %pnick $iif($3 == $server, $server, $nick($2,$3).pnick)
  var %modecolor $dev.chkmodes($2,$3)
  if ( %nx.highlight.active ) { var %c 4 | unset %nx.highlight.active | window -g2 $2 }
  else { window -g1 $2 }
  echo %c -t $+ $1 $2 $+(<,,%modecolor,,$cnick(%pnick).color,%pnick,,>) $4-
  
}
alias nx.echo.chanaction {
  var %pnick $iif($3 == $server, $server, $nick($2,$3).pnick)
  var %modecolor $dev.chkmodes($2,$3)
  if ( %nx.highlight.active ) { var %c 4 | unset %nx.highlight.active | window -g2 $2 }
  else { var %c 6 | window -g1 $2 }
  echo %c -t $+ $1 $2 * %pnick $4- 
}

alias nx.echo.channotice {
  var %pnick $iif($3 == $server, $server, $nick($2,$3).pnick)
  var %modecolor $dev.chkmodes($2,$3)
  if ( %nx.highlight.active ) { var %c 4 | unset %nx.highlight.active | window -g2 $2 }
  else { var %c %nx.thm.nc | window -g1 $2 }
  echo %c -t $+ $1 $2 $dash(Chan notice %pnick) $4-
}
; ZNC *buffextras stuff
alias nx.echo.mode { echo 3 -t $+ $1 $2 * $3 sets mode: $4- }
alias nx.echo.nick { echo 3 -t $+ $1 $2 * $3 is now known as $4 }
alias nx.echo.kick { echo 12 -t $+ $1 $2 * $3 was kicked by $4 $p($5-) }
alias nx.echo.topic { echo 3 -t $+ $1 $2 * $3 changes topic to $p($4-) }

; usage /nx.echo.quit <chan> <nick> <ident@host> <reason>
; ZNC *buffextras /nx.echo.quit timestamp chan nick reason
alias nx.echo.quit { 
  if ( $left($1,1) == $chr(35) ) { echo 12 -t $1 * $2 $p($3) has quit $p($4-) }
  else { echo 12 -t $+ $1 $2 * $3 $p($4) has quit $p($5-)  }
}

; Flood limit this incase of flood attack, also consider echo to a own "notice window" or to a status window in addition to echo to active window
alias nx.echo.notice { 
  if ( %nx.notice.status ) { echo %nx.thm.nc -st $p(Priv Notice) - $nick $+ : $1- | unset %nx.notice.status }
  elseif ( %nx.notice.active ) { echo %nx.thm.nc -at $p(Priv Notice) - $nick $+ : $1- | unset %nx.notice.active }
  elseif ( $active = Status Window ) { echo %nx.thm.nc -st $p(Priv Notice) - $nick $+ : $1- }
  ; TODO, need to check if notice is not in active network or something, now if echo is on same network it goes to else
  else { echo %nx.thm.nc -at $p(Priv Notice) - $nick @ $network $+ : $1- | echo %nx.thm.nc -st $p(Priv Notice) - $nick $+ : $1- }
}

alias nx.echo.snotice {
  if ( $active = Status Window ) { 
    if ( $strip($1) = connect.LOCAL_CLIENT_CONNECT ) {  echo 10 -t $+(@,$network,_,$cid,_,status) $1- }
    elseif ( $strip($1) = connect.LOCAL_CLIENT_DISCONNECT ) { echo 10 -t $+(@,$network,_,$cid,_,status) $1- }
    elseif ( $strip($1) = nick.NICK_COLLISION ) { echo 10 -t $+(@,$network,_,$cid,_,status) $1- }
    elseif ( $strip($1) = flood.FLOOD_BLOCKED ) { echo 10 -t $+(@,$network,_,$cid,_,status) $1- }

    if ( $window($+(@,$network,_,$cid,_,status)) ) { echo 10 -st $1- | echo 10 -t $+(@,$network,_,$cid,_,status) $1- }
    else { echo 10 -st $1- }
  }
  elseif ( $window($+(@,$network,_,$cid,_,status)) ) { echo 10 -t $+(@,$network,_,$cid,_,status) $1- }
  else { echo 10 -st $1- }
}
alias nx.echo.wallops {
  if ( $active = Status Window ) { 
    if ( $window($+(@,$network,_,$cid,_,status)) ) { echo 10 -st WALLOPS: $1- | echo 10 -t $+(@,$network,_,$cid,_,status) WALLOPS: $1- }
    else { echo 10 -st WALLOPS: $1- }
  }
  elseif ( $window($+(@,$network,_,$cid,_,status)) ) { echo 10 -t $+(@,$network,_,$cid,_,status) WALLOPS: $1- }
  else { echo 10 -st WALLOPS: $1- }
}

; $1 = chan, $2 = nick, $3- = message
alias nx.handle.highlight {
  if ($istok(%nx.highlight.ignore_chans,$1,32)) { return }
  var %n $numtok(%nx.highlight.nicks,32)
  while (%n) {
    var %tn $gettok(%nx.highlight.nicks,%n,32)
    if ( $istok($remove($3-,:),%tn,32) ) {
      if ( $1 != $active ) { 
        window -g2 $1
        echo 4 -at *** Highlight from $p($address($2,5) @ $network) in $1 $+ : $3-
      }
      set -u1 %nx.highlight.active true
    }
    dec %n
  }
}


alias nx.specialday {
  var %d = $asctime(ddmm)
  if (%d == 0101) { return Happy new year! }
  elseif (%d == 1402) { return Happy valentines day <3 }
  elseif (%d == 1703) { return It's St. Patrick's day, time to get some booze! }
  elseif (%d == $gettok(%birthday,1,1)) { return Happy $ord($calc($asctime(yyyy) $+(-,$gettok(%birthday,1,2)))) $gettok(%birthday,1,3) }
  elseif (%d == 3110) { return Trick or treat? }
  elseif (%d == 2412) || (%d == 2512) || (%d == 2612) { return We wish you a merry christmas... *sings* }
}

alias nx.announce.newday { 
  var %nx.announce.newday.chans $chan(0)
  while ( %nx.announce.newday.chans ) { 
    ; Idea, echo statistics for this channel today (total joined\parted\quit\kicked\mode changes\topic changes etc)
    echo 3 -tn $chan(%nx.announce.newday.chans) * It's a new day, $fulldate $+ . $nx.specialday
    dec %nx.announce.newday.chans
  }
  .timer_nx_restart_newday 1 300 .timer_nx.announce.newday 00:00 1 0 scid -a nx.announce.newday
}

alias antiflood_check_nickrepeat {
  ; antiflood_check_nickrepeat $chan $nick $1-
  ; Check repeated messages from same nick in same chan on same network
  ; usage: antiflood_check_nickrepeat <chan> <nick> <text>
  var %txt $+($network,.,$1,.,$2,.,$md5($lower($strip($3-))))
  if ( $hget(af_chk_nr,%txt) == $null ) { hadd -mu5 af_chk_nr %txt 1 }
  else {
    hinc -u5 af_chk_nr %txt 1
    var %cnt $hget(af_chk_nr,%txt)
    if ( %cnt > 2 ) {
      spamkickban $1 $2 You repeated %cnt times.
      echo -st Detected repeat num %cnt from $2 in $1 @ $network $+ : $3-
    }
  }

  ; Check repeated message from multiple nicks in same chan on same network
  var %txt2 $+($network,.,$1,.,$md5($lower($strip($3-))))
  if (!$hget(af_chk_nr2,%txt2)) {
    ; save last nick that sent this message and count number of times message was sent
    hadd -mu5 af_chk_nr2 %txt2 $2
    hadd -mu5 af_chk_nr2_count %txt2 1
  }
  elseif ( $hget(af_chk_nr2_count,%txt2) ) {
    ; inc number of times this message was sent
    hinc -u5 af_chk_nr2_count %txt2 1
    ; add nick to list of nicks that sent this message
    hadd -mu5 af_chk_nr2 %txt2 $addtok($hget(af_chk_nr2,%txt2),$2,44)
    var %cnt2 $hget(af_chk_nr2_count,%txt2)
    if ( %cnt2 > 4 ) {
      ; Check if there is more than x nicks repeating the same message, if so, mode +rm
      if ( %nickscount > 6 ) {
        ; no nx.mode here, bypassing delay
        if ( $me isop $1 ) && (!$istok(%nx.spammode.rm,$1,44)) {
          set -u30 %nx.spammode.rm $addtok(%nx.spammode.rm,$1,44) 
          !mode $1 +rm
          .timer_unmode_rm_ $+ $1 1 $calc(60*15) nx.mode $1 -rm
        }
        elseif ( X ison $1 ) && (!$istok(%nx.spammode.rm,$1,44)) && ( $istok(%nx.X.chans. [ $+ [ $network ] ],$chan,32) ) {
          set -u30 %nx.spammode.rm $addtok(%nx.spammode.rm,$1,44)
          .!msg X mode $1 +rm
          .timer_unmode_rm_ $+ $1 1 $calc(60*15) .nx.msg X mode $1 -rm
        }
        else {
          return
          ; Not going to echo this yet.
          echo 4 -t $chan Unable to enable +rm in $1, insufficient rights.
          echo 4 -t $chan Multi-repeat flood num %cnt2 from nicks $hget(af_chk_nr2,%txt2) : $3-
        }
      }
      ; This is redudant for /spamkickban alias, but this allows the script to kickban multiple users in one command thru X
      if ( x ison $chan ) && ( $istok(%nx.X.chans. [ $+ [ $network ] ],$chan,32) ) {
        var %nickscount $calc(%nickscount + $numtok($hget(af_chk_nr2,%txt2),44) )
        var %nickslist $gettok($hget(af_chk_nr2,%txt2),1-12,44)
        .nx.msg x ban $chan %nickslist No repeating in this channel ( $+ %cnt2 $+ ).
        hdel af_chk_nr2 %txt2
      }
      ; Time to ban the repeaters, since the last if didnt go thru its mostlikely a channel i dont have access to ban thru X
      else {
        var %nickslist = $hget(af_chk_nr2,%txt2)
        var %i 1
        while ( %i <= $numtok(%nickslist,44) ) {
          spamkickban $1 $gettok(%nickslist,%i,44) No repeating in this channel ( $+ %cnt2 $+ ).
          inc %i
        }
      }
      echo -st Detected multi-repeat num %cnt2 from nicks $hget(af_chk_nr2,%txt2) in $1 @ $network $+ : $3-
    }
  }
}

alias spamkickban { 
  ; spamkickban <chan> <nick> <reason>
  if ( $2 !isop $1 ) && ( $2 !isvoice $1 ) {
    if ( $2 ison $1 ) {
      if ( $me isop $1 ) {
        ; Later, need to fix nx.ban to deal with anti excess flood
        ; ban -uk3600 $1 $address($2,2) Spam
        nx.kick $1 $2 $3-
        nx.mode $1 +b $address($2,2)
        ; unban after 3 hours
        .timer_unban_ $+ $1 $+ _ $+ $2 1 $calc(60*60*3) nx.mode $1 -b $address($2,2)
      }
      elseif ( X ison $1 ) && ( $istok(%nx.X.chans. [ $+ [ $network ] ],$chan,32) ) { .nx.msg X ban $1 $address($2,2) $calc(60*60*3) $3- }
      ; Here elseif botnet is in the channel and dcc chat is active with botnet, send ban thru botnet
      else { echo 4 -t $chan Unable to ban/kick $2 in $1, insufficient rights. }
      echo 4 -st Detected spam num %i from $2 in $1 $+ : $3-
      echo 4 -at Detected spam num %i from $2 in $1 @ $+ $network $+ : $3-
    }
    else { echo 4 -t $chan Unable to kick $2 from $1, user not present. }
  }
  else { echo 4 -t $chan Unable to ban/kick $2 in $1, user has op/voice status. }
}

; Placeholder for custom perform stuff
alias nx.perform { return }

; Loop channels i am on and .ialfill them /nx.ialupdate <cid> [time]
alias nx.ialupdate {
  if ($1 == $cid) { var %cid $cid }
  else { echo 4 -ast Usage: /nx.ialupdate <cid> [time] | halt }

  var %c $chan(0), %i 1, %t 2
  while ( $chan(%i) ) {
    set -u60 %nx.ialupdate. $+ %cid $+ $chan(%i) 1
    .timer_ial_update_ $+ %cid $+ $chan(%i) 1 $iiF($2,$2,%t) .nx.who $chan(%i) 
    inc %i
    if (!$2) { inc %t 2 }
  }
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
alias nx.db {
  ; $nx.db(read,settings,operchans,$network)
  ; /nx.db write settings operchans $network #chan1 #chan2 #chan3
  ; /nx.db rem\del settings operchans
  ; /nx.db rem\del settings operchans $network
  ; later i wil use hashtables as db and readini as "long storage" 
  if ( $1 = read ) {
    if ( $4 ) {
      if ( $2 = settings ) { return $readini(nx.settings.ini,$3,$4) }
      if ( $2 = ial ) { return $readini($+(ial\,$network,_,$cid,.ini),$3,$4) }
      else { return $readini($+($2,.ini),$3,$4) }
    }
  }
  ; nx.db write operchans\opernet\ircd $network stuff
  elseif ( $1 = write ) {
    if ( $5 ) {
      if ( $2 = settings ) { writeini nx.settings.ini $3 $4 $5- }
      if ( $2 = ial ) {  writeini -n $+(ial\,$network,_,$cid,.ini) $3 $4 $5- }
      else { writeini $+($2,.ini) $3 $4 $5- }
    }
  }
  ; nx.db rem settings <opt> <opt2>
  elseif ( $1 = rem ) || ( $1 = del ) {
    if ( $2 = settings ) { remini nx.settings.ini $iif($3,$3) $iif($4,$4) }
    if ( $2 = ial ) { remini -n $+(ial\,$network,_,$cid,.ini) $iif($3,$3) $iif($4,$4) }
    else { remini $+($2,.ini) $iif($3,$3) $iif($4,$4) }
  }
}

alias chat { dcc chat $$1 }
alias ping { ctcp $$1 ping }

; TODO, test uting /raw hop or /quote hop ? also replace other !cmd if it works
alias htop_DISABLED_UNTIL_I_MAKE_nx.hop_WORK { nx.hop $1- }

; Consider to use the same logic as in alias join, where "/hop channel" wil work
; todo, add anex check (anti excess flood)
; bug, /nx.hop $chan doesnt hop the channel if the channel is not $active 
alias nx.hop {
  if ( $me ison $1 ) { set -u4 %nx.hop $1 | !hop $1 }
  elseif ( $chan == $active ) { set -u4 %nx.hop $chan | !hop $chan }
  else { echo 4 -at Usage /hop <channel> or /hop while on an active channel | halt }
}

alias join {
  ; /join #chan1,chan2,#chan3 key,chan4 key
  ; Todo, check for &localchan, for now it's vanilla /join &localchan
  ; todo, add anex check (anti excess flood)
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
alias nx.random {
  ; $random(12,N) for random 1-9
  ; $random(12,R,R) for random 1-9,a-z,A-Z
  ; $random(12,R,U) for random 1-9,A-Z 
  ; $random(12,R,L) for random 1-9,a-z
  ; $random(12,C,R) for random a-z,A-Z
  ; $random(12,R,R) for random 1-9,a-z,A-Z
  ; 12 is length of random string
  if ( $1 isnum ) && ($istok(C N R,$2,32)) { 
    if (!$istok(U L R,$3,32)) && ($istok($2,R,C)) { echo -at Usage $chr(36) $+ random(99,CNR,ULR) | halt }
    var %r $1
    while (%r) {
      var %v $iif($2 = R,$rand(1,2),$iif($2 = C,2,1))
      if ( %v = 1 ) { var %nx.random.tmp $+(%nx.random.tmp,$rand(1,9)) }
      if ( %v = 2 ) { 
        if ( $3 == U ) { var %nx.random.tmp $+(%nx.random.tmp,$rand(A,Z)) }
        elseif ( $3 == L ) { var %nx.random.tmp $+(%nx.random.tmp,$rand(a,z)) }
        elseif ( $3 == R ) { var %nx.random.tmp $+(%nx.random.tmp,$iif($r(1,2) = 1,$rand(a,z),$rand(A,Z))) }
      }
      dec %r
    }
    return %nx.random.tmp
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

; I got boored, //say $pride(Hello world!) //prideread wil read everything in pride.txt
alias prideread {
  set -u10 %prideread 1
  var %i 1 
  while ($read(pride.txt,%i)) { 
    ; quote privmsg $active $pridesay($read(pride.txt,%i))
    nx.say $pride($read(pride.txt,%i))
    inc %i
  }
  unset %prideread %pridecolors.i.read
}

alias pride {
  if (!$1) { echo -at Usage: //say $pride(<sentence>) | halt }
  else {
    var %pridecolors.r 3 4 5 6 7 8 9 10 11 12 13
    if (%pridecolors.i.read) { var %pridecolors.i $v1 }
    else { var %pridecolors.i 1 }
    var %pridecolors.sentence $1-
    var %pridecolors.words $numtok(%pridecolors.sentence,32)
    var %pridecolors.wordi 1
    while (%pridecolors.wordi <= %pridecolors.words) {
      var %pridecolors.word $gettok(%pridecolors.sentence,%pridecolors.wordi,32)
      var %pridecolors.letters $len(%pridecolors.word)
      var %pridecolors.letteri 1
      while (%pridecolors.letteri <= %pridecolors.letters) {
        var %pridecolors.letter $mid(%pridecolors.word,%pridecolors.letteri,1)
        var %pridecolors.color $gettok(%pridecolors.r,%pridecolors.i,32)
        var %pridecolors.newword $+(%pridecolors.newword,,%pridecolors.color,%pridecolors.letter)
        inc %pridecolors.i
        if (%pridecolors.i > $numtok(%pridecolors.r,32)) { var %pridecolors.i 1 }
        inc %pridecolors.letteri
      }
      var %pridecolors.NewSetence $addtok(%pridecolors.NewSetence,%pridecolors.newword,32)
      unset %pridecolors.newword
      inc %pridecolors.wordi
    }
    if ( %prideread ) { set -u10 %pridecolors.i.read %pridecolors.i }
    return %pridecolors.NewSetence
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
