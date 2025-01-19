alias nx.opmode {
  if ($istok($nx.db(read,settings,ircd,opmode),$network,32)) { opmode $1- }
  elseif ($istok($nx.db(read,settings,ircd,samode),$network,32)) { samode $1- }
  else { echo -at Unsupported ircd, no opmode or samode | halt }
}

alias nx.samode {
  if ($istok($nx.db(read,settings,ircd,opmode),$network,32)) { opmode $1- }
  elseif ($istok($nx.db(read,settings,ircd,samode),$network,32)) { samode $1- }
  else { echo -at Unsupported ircd, no opmode or samode | halt }
}

alias say { nx.say $1- }
alias .say { .nx.say $1- }
alias me { nx.me $1- }
alias .me { .nx.me $1- }
alias msg { nx.msg $1- }
alias .msg { .nx.msg $1- }

alias mode { nx.mode $1- }

; Disabled, for some reason !opmode (in nx.opmode) doesnt use original opmode but loops back to this alias
alias opmode_disabled { nx.opmode $1- }
alias samoded_disabled { nx.samode $1- }
alias kick { nx.kick $1- }

alias ctcp { nx.ctcp $1- }
alias topic { nx.topic $1- }
alias whois { nx.whois $1- }
alias who { nx.who $1- }
alias stats { nx.stats $1- }

alias nx.say { nx.anti.excess !say $1- }
alias .nx.say { nx.anti.excess .!say $1- }
alias nx.me { nx.anti.excess !me $1- }
alias .nx.me { nx.anti.excess .!me $1- }
alias nx.msg { nx.anti.excess !msg $1- }
alias .nx.msg { nx.anti.excess .!msg $1- }

alias nx.mode { nx.anti.excess !mode $1- }
alias nx.opmode { nx.anti.excess !opmode $1- }
alias nx.samode { nx.anti.excess !samode $1- }
alias nx.kick { nx.anti.excess !kick $1- }

alias nx.ctcp { nx.anti.excess !ctcp $1- }
alias nx.topic { nx.anti.excess !topic $1- }
alias nx.whois { nx.anti.excess !whois $1- }
alias nx.who { nx.anti.excess !who $1- }
alias nx.stats { nx.anti.excess !stats $1- }

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
    if ( $nx.anex.cmd2(get,$cid) ) {
    var %nx.anex.v1 $v1
    var %nx.anex.timer $+($cid,_,$v1,_,$nx.random(2,R,R),_,$ctime)
    ; Failsafe if timers fail
    if ( %nx.anex.v1 < 0 ) { echo 3 -at Anex below 0 = %nx.anex.v1, setting it to 1 | nx.anex.cmd2 set $cid 1 }
    nx.anex.cmd2 inc $cid
    .timer_nx_anex_dec_ $+ %nx.anex.timer 1 %nx.anex.v1 nx.anex.cmd2 dec $cid
    return %nx.anex.v1
  }
  ; First message
  else { 
    var %nx.anex.timer $+($cid,_,1,_,$nx.random(2,R,R),_,$ctime)
    nx.db write settings anex $cid 1
    .timer_nx_anex_dec_ $+ %nx.anex.timer 1 1 nx.anex.cmd2 dec $cid
    return 1
    }
}
alias nx.anex.cmd2 {
  if ( $1 == dec ) { 
    if ( $nx.db(read,settings,anex,$2) <= 1) { nx.db rem settings anex $2 }
    else { nx.db write settings anex $2 $calc($nx.db(read,settings,anex,$2) - 1) }
  }
  elseif ( $1 == inc ) { nx.db write settings anex $2 $calc($nx.db(read,settings,anex,$2) + 1) }

  elseif ( $1 == get ) { return $nx.db(read,settings,anex,$2) }
  elseif ( $1 == set ) { nx.db write settings anex $2 $3 }
  elseif ( $1 == del ) { nx.db rem settings anex $2 }
  elseif ( $1 == reset ) { nx.db write settings anex $2 1 }
}