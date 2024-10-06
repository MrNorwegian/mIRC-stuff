; Lots of placeholders for custom anti excess flood stuff and custom /commands

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
alias nx.mode { nx.anti.excess mode $1- }
alias nx.kick { nx.anti.excess kick $1- }
alias nx.whois { nx.anti.excess whois $1- }
alias nx.who { nx.anti.excess who $1- }
alias nx.msg { nx.anti.excess msg $1- }
alias .nx.msg { nx.anti.excess .msg $1- }
alias nx.say { nx.anti.excess say $1- }
alias nx.me { nx.anti.excess me $1- }
alias nx.ctcp { nx.anti.excess ctcp $1- }

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
