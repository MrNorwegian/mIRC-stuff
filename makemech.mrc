alias makemech3 {
  set %mech.gnamesfile girlnames.txt | set %mech.bnamesfile boynames.txt
  ; set %usenamesfile girlboy\names123
  ; random NAMES1.txt NAMES2.txt NAMES3.txt
  set %mech.usenamesfile names123
  set %mech.interface enp0s31f6
  var %mech.chan #bots4
  set %mech.randomip no
  if ( %mech.randomip = no ) {
    ; lets us use 172.19.110.0 to 172.19.119.255
    if ( %mech.chan = #bots1 ) { set %mech.startip 172.19.12 }
    if ( %mech.chan = #bots2 ) { set %mech.startip 172.19.14 }
    if ( %mech.chan = #bots3 ) { set %mech.startip 172.19.16 }
    if ( %mech.chan = #bots4 ) { set %mech.startip 172.19.18 }
    set %mech.nextsubnet 1
    set %mech.endip 1
  }
  set %mech.subnet /15

  var %mech.db mech-spambots.ini 
  set %mech.pause 2
  if ( $1 >= 1 ) {
    ;var %mech.servers 172.18.0.41,172.18.0.42,172.18.0.43
    ;var %mech.ports 6660,6661,6662,6663,6664,6665,6666,6667,6668,6669,7000
    var %mech.servers 172.18.0.41,172.18.0.42,172.18.0.43
    var %mech.ports 6661,6662,6663,6664,6665,6666,6667,6668,6669
    var %mech.network CreepNet
    var %mechconfig mech.conf
    window -De @mech
    window -De @mechdebug
    remove %mechconfig | remove server.sh
    write %mechconfig set ctimeout 60
    write %mechconfig servergroup %mech.network
    set %mech.ctime.start $ctime
    set %mech.numbots $1
    var %i 1
    var %p $numtok(%mech.ports,44) 
    echo 13 @mech Makemech Writing $calc($numtok(%mech.servers,44)+ $numtok(%mech.ports,44)) server lines and %mech.numbots bots
    while (%p) { 
      var %s $numtok(%mech.servers,44)
      while (%s) { write %mechconfig SERVER $gettok(%mech.servers,%s,44) $gettok(%mech.ports,%p,44) | dec %s } 
      dec %p
    }
    write %mechconfig $crlf
    write %mechconfig $crlf
    while ( %i <= %mech.numbots ) {
      if ( $mechpick = false ) { echo 4 @mech FAILED, was not able to pick a nick or ip | halt }
         ; echo 3 @mechdebug ID: %i NICK: %mech.nick IP: %mech.ip
      ; pause for 1 second every xx bots (to avoid ping time out)
      if ( %mech.pause = 100 ) { echo @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks | pause %mech.pause | set %mech.pause 1 | set %mech.ctime $ctime | unset %mech.sum.nicks }
      else { inc %mech.pause | set %mech.sum.nicks $addtok(%mech.sum.nicks,%mech.nick,32) }
      ;write mech.set ##### Bot %i Configuration #####
      write %mechconfig set servergroup %mech.network
      write %mechconfig nick %i %mech.nick
      write %mechconfig set altnick $+(%mech.nick,$r(1,100)) $+(%mech.nick,$r(1,100)) $+(%mech.nick,$r(1,100))
      write %mechconfig set userfile mech.passwd
      write %mechconfig set ident %mech.nick
      write %mechconfig set ircname %mech.nick
      write %mechconfig set umodes +iw
      write %mechconfig set cmdchar -
      write %mechconfig set modes 6
      write %mechconfig set cc 1
      write %mechconfig join %mech.chan
      write %mechconfig set pub 1
      write %mechconfig set aop 1
      write %mechconfig set avoice 1
      write %mechconfig set prot 4
      write %mechconfig set virtual %mech.ip
      write %mechconfig $crlf

      inc %i
      write server.sh ip addr add dev %mech.interface $+(%mech.ip,%mech.subnet)
      writeini %mech.db usedips %mech.ip true
      writeini %mech.db usednicks %mech.nick true
    }
    else { echo Syntax /makemech 128 }
  }
  echo @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks
  echo 13 @mech Makemech DONE with %i \ %mech.numbots bots in $duration($calc($ctime - %mech.ctime.start))
  unset %mechconfig %mechm.*
}
alias mechpick {
  var %mn 100, %mi 100
  while (%mn) {
    if (%mech.usenamesfile = girlboy) { set %mech.nick $gettok($read($iif($r(1,2) = 1,%mech.gnamesfile,%mech.bnamesfile),$r(1,999)),2,32) }
    if (%mech.usenamesfile = names123) { set %mech.nick $read($+(NAMES,$r(1,3),.txt)) }
    if ($readini(%mech.db,usednicks,%mech.nick) = true) { echo 4 @mechdebug Nick used %mech.nick | dec %mn }
    elseif ($regex(%mech.nick,/[^a-zA-Z0-9-]/) = 0) { unset %mn | set %mech.snick true | haltdef }
    else { echo 4 @mechdebug Nick invalid %mech.nick | dec %mn }
  }
  while (%mi) {
    if ( %mech.randomip = yes ) { 
      var %mech.i2 $r(18,19)
      set %mech.ip $+(172,.,%mech.i2,.,$iif(%mech.i2 = 18,$r(1,255),$r(0,255)),.,$r(1,254))
    }
    if ( %mech.randomip = no ) { 
      set %mech.ip $+(%mech.startip,%mech.nextsubnet,.,%mech.endip)
      if ( %mech.endip = 255 ) { set %mech.endip 1 | inc %mech.nextsubnet }
      else { inc %mech.endip }
    }

    if ($readini(%mech.db,usedips,%mech.ip) = true) { echo 4 @mechdebug IP used %mech.ip | dec %mi }
    else { unset %mi | set %mech.sip true | haltdef }
  }
  if ( %mech.sip = true ) && ( %mech.snick = true ) { return true }
  else { echo 4 @mech FAILED, was not able to pick a nick | return false } 
}
on *:INPUT:*:{
  if ( $1 = -say ) { set -u10 %mechfloodprotect 1 }
  if ( $1 = -join ) || ( $1 = -part ) || ( $1 = -cycle ) { set -u10 %mechfloodprotect 1 }
}
alias mech {
  var %idlerpass SpamPass
  var %n $nick($chan,0)
  var %botnick $2
  .timer_mechlogin_unsetprot 1 $calc(%n +10) unset %mechfloodprotect 
  while (%n) {
    if ( 172.16.101 isin $address($nick($chan,%n),2) ) { 
      if ( $1 = login ) && ( $nick($chan,%n) isreg $chan ) { .timer_mechlogin_ $+ %n 1 %n .msg $nick($chan,%n) auth p455w0rd }
      if ( $nick($chan,%n) isreg $chan ) {
        if ( $1 = idlerpgregister ) { .timer_register_ [ $+ [ $nick($chan,%n) ] ] 1 %cinc .msg $nick($chan,%n) -msg %botnick register $nick($chan,%n) %idlerpass $nick($chan,%n) }
        if ( $1 = idlerpglogin ) { .timer_register_ [ $+ [ $nick($chan,%n) ] ] 1 %cinc .msg $nick($chan,%n) -msg %botnick login $nick($chan,%n) %idlerpass }
      }
    }
    else { echo FALSE Nr $nick($chan,%n) - $address($nick($chan,%n),2) }
    dec %n
  }
}
