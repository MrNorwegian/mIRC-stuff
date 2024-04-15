alias makemech3 {
  set %mech.gnamesfile girlnames.txt | set %mech.bnamesfile boynames.txt
  ; set %usenamesfile girlboy
  ; random NAMES1.txt NAMES2.txt NAMES3.txt
  set %mech.usenamesfile names123

  var %mech.network CreepNet
  var %mechconfig mech.conf
  ;var %servers 172.16.0.31,172.16.0.32,172.16.0.33
  ;var %ports 6660,6661,6662,6663,6664,6665,6666,6667,6668,6669,7000
  var %mech.servers spamircd.lan.da9.no,spamircd.lan.da9.no,spamircd.lan.da9.no
  var %mech.ports 6661,6662,6663,6664,6665,6666,6667,6668,6669

  if ( $1 >= 1 ) {
    echo 4 Makemech3 Start with %mech.numbots bots
    remove %mechconfig | remove server.sh
    write %mechconfig set ctimeout    60
    write %mechconfig servergroup %mech.network
    set %mech.numbots $1
    var %i 1
    var %p $numtok(%mech.ports,44) 
    echo 4 Makemech Writing $calc($numtok(%mech.servers,44)+ $numtok(%mech.ports,44)) server lines and %mech.numbots bots
    while (%p) { 
      var %s $numtok(%mech.servers,44)
      while (%s) { write %mechconfig SERVER $gettok(%mech.servers,%s,44) $gettok(%mech.ports,%p,44) | dec %s } 
      dec %p
    }
    write %mechconfig $crlf
    write %mechconfig $crlf
    while ( %i <= %mech.numbots ) {
      mechpick
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
      write %mechconfig join #idlechan
      write %mechconfig set pub 1
      write %mechconfig set aop 1
      write %mechconfig set avoice 1
      write %mechconfig set prot 4
      write %mechconfig set virtual %mech.ip
      write %mechconfig $crlf

      inc %i
      write server.sh ip addr add dev eth0 $+(%mech.ip,/15)
      writeini mech.ini usedips %mech.ip true
      writeini mech.ini usednicks %mech.nick true

    }
    else { echo Syntax /makemech 128 }
  }
  echo 4 Makemech DONE with %mech.i \ %mech.numbots bots
  unset %mechconfig %mech.nick %mech.ip %mech.snick %mech.sip %mech.bnamesfile %mech.gnamesfile %mech.usenamesfile
}
alias mechpick {
  var %mn 100, %mi 100
  while (%mn) {
    if (%mech.usenamesfile = girlboy) { set %mech.nick $gettok($read($iif($r(1,2) = 1,%mech.gnamesfile,%mech.bnamesfile),$r(1,999)),2,32) }
    if (%mech.usenamesfile = names123) { set %mech.nick $read($+(NAMES,$r(1,3),.txt)) }
    if ( æ isin %mech.nick ) { set %mech.nick $replace(%mech.nick,æ,E) }
    if ( ø isin %mech.nick ) { set %mech.nick $replace(%mech.nick,ø,O) }
    if ( å isin %mech.nick ) { set %mech.nick $replace(%mech.nick,å,A) }
    if ($readini(mech.ini,usednicks,%mech.nick) = true) { echo 12 Nick used %mech.nick | dec %mn }
    else { unset %mn | set %mech.snick true | haltdef }
  }
  while (%mi) {
    var %mech.i2 $r(18,19)
    set %mech.ip $+(172,.,%mech.i2,.,$iif(%mech.i2 = 18,$r(1,255),$r(0,255)),.,$r(1,254))
    if ($readini(mech.ini,usedips,%mech.ip) = true ) { echo 7 IP used %mech.ip | dec %mi }
    else { unset %mi | set %mech.sip true | haltdef }
  }
  if ( %mech.sip = true ) && ( %mech.snick = true ) { return true }
  else { echo 4 FAILED, was not able to pick a nick | return false } 
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
