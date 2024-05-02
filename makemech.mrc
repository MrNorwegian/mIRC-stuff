alias makemech3 {
  set %mech.interface enp0s31f6
  set %mech.chan $iif($2,$2,#spambots)
  set %mech.randomip no
  ; set %mech.randomchan false
  set %mech.randomchan true
  set %mech.randomnick true
  ; set %usenamesfile girlboy\names123
  set %mech.usenamesfile names123

  if ( %mech.randomip = no ) {
    set %mech.startip 172.18.
    set %mech.ns 48
    set %mech.tchans #b11,#b12,#b13,#b14,#b21,#b22,#b23,#b24,#b31,#b32,#b33,#b34,#b41,#b42,#b43,#b44
    set %tc $numtok(%mech.tchans,44)
    var %inc 8, %s 1
    while (%tc >= %s) {
      if ( %mech.chan = $gettok(%mech.tchans,%s,44) ) { echo Subnet %mech.ns | set %mech.nextsubnet %mech.ns | haltdef }
      inc %mech.ns %inc
      inc %s
    }
    ;set %mech.nextsubnet 1
  }
  set %mech.endip 1
  set %mech.subnet /15
  ; var %mech.db $+(mech,-,$remove($2,$chr(35)),.ini)
  var %mech.db mech-spambots.ini
  set %mech.pause 2000

  if ( $1 >= 1 ) {
    ;var %mech.servers 172.18.0.41,172.18.0.42,172.18.0.43
    ;var %mech.ports 6660,6661,6662,6663,6664,6665,6666,6667,6668,6669,7000
    var %mech.servers 172.18.0.41,172.18.0.42,172.18.0.43
    var %mech.ports 6661,6662,6663,6664,6665,6666,6667,6668,6669
    var %mech.network CreepNet
    var %mechconfig $+(mech\mech,$right(%mech.chan,2),.conf)
    var %serverconf $+(mech\server,$right(%mech.chan,2),.sh)
    window -De @mech
    window -De @mechdebug
    remove %mechconfig | remove %serverconf
    write %mechconfig set ctimeout 60
    write %mechconfig servergroup %mech.network
    set %mech.ctime.start $ctime
    set %mech.numbots $1
    var %i 1
    var %p $numtok(%mech.ports,44) 
    set %mech.ctime $ctime
    echo 13 @mech Makemech Writing $calc($numtok(%mech.servers,44)+ $numtok(%mech.ports,44)) server lines and %mech.numbots bots with subnet %mech.nextsubnet
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
      if ( %p > 64 ) { echo @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks | pause %mech.pause | set %p 1 | set %mech.ctime $ctime | unset %mech.sum.nicks }
      else { inc %p | set %mech.sum.nicks $addtok(%mech.sum.nicks,%mech.nick,32) }
      ;write mech.set ##### Bot %i Configuration #####
      write %mechconfig set servergroup %mech.network
      write %mechconfig nick %i %mech.nick
      write %mechconfig set altnick $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9))
      write %mechconfig set userfile mech.passwd
      write %mechconfig set ident %mech.nick
      write %mechconfig set ircname %mech.nick
      write %mechconfig set umodes +iw
      write %mechconfig set cmdchar -
      write %mechconfig set modes 6
      write %mechconfig set cc 1
      write %mechconfig join $iif(%mech.randomchan = false,%mech.chan,$+(%mech.chan,-,$random(2,N)))
      write %mechconfig set pub 1
      write %mechconfig set aop 1
      write %mechconfig set avoice 1
      write %mechconfig set prot 4
      write %mechconfig set virtual %mech.ip
      write %mechconfig $crlf

      inc %i
      write %serverconf ip addr add dev %mech.interface $+(%mech.ip,%mech.subnet)
      ; writeini %mech.db usedips %mech.ip true
      ; writeini %mech.db usednicks %mech.nick true
      
      unset %mech.nick
    }
    else { echo Syntax /makemech 128 }
  }
  ;write %serverconf cd /home/naka
  ;write %serverconf mv $remove(%mechconfig,mech\) mech/
  ;write %serverconf cd mech
  ;write %serverconf rm *.pid *.session *.conf
  ;write %serverconf echo ./energymech -f $remove(%mechconfig,mech\)
  echo @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks
  echo 13 @mech Makemech DONE with %i \ %mech.numbots bots in $duration($calc($ctime - %mech.ctime.start))
  unset %mechconfig %mechm.* %mech.chan %mech.interface %mech.numbots %mech.gnamesfile %mech.bnamesfile %mech.usenamesfile %mech.randomip %mech.randomchan %mech.startip %mech.nextsubnet %mech.endip %mech.subnet %mech.db %mech.pause %mech.servers %mech.ports %mech.network %mech.ctime.start %mech.ctime %mech.sum.nicks %mech.nick %mech.ip %mechconfig %mech.mechpick
}
alias mechpick {
  var %mn 100, %mi 100
  if ( %mech.randomnick = true ) { set %mech.nick $+($remove(%mech.chan,$chr(35)),-,$random(12,R,R)) }
  else { 
    var %mech.gnamesfile girlnames.txt | set %mech.bnamesfile boynames.txt
    while (%mn) {
      if (%mech.usenamesfile = girlboy) { set %mech.nick $gettok($read($iif($r(1,2) = 1,%mech.gnamesfile,%mech.bnamesfile),$r(1,999)),2,32) }
      if (%mech.usenamesfile = names123) { set %mech.nick $read($+(NAMES,$r(1,3),.txt)) }
      if ($readini(%mech.db,usednicks,%mech.nick) = true) { echo 4 @mechdebug Nick used %mech.nick | dec %mn }
      elseif ($regex(%mech.nick,/[^a-zA-Z0-9-]/) = 0) { unset %mn | set %mech.snick true | haltdef }
      else { echo 4 @mechdebug Nick invalid $+($remove(%mech.chan,$chr(35)),-,%mech.nick,$random(2,N)) | dec %mn }
    }
  }
  if ( %mech.randomip = no ) { 
    set %mech.ip $+(%mech.startip,%mech.nextsubnet,.,%mech.endip)
    if ( %mech.endip = 255 ) { set %mech.endip 0 | inc %mech.nextsubnet }
    else { inc %mech.endip }
    unset %mi | set %mech.sip true | haltdef
  }
  if ( %mech.randomip = yes ) { 
    while (%mi) {
      var %mech.i2 $r(18,19)
      set %mech.ip $+(172,.,%mech.i2,.,$iif(%mech.i2 = 18,$r(1,255),$r(0,255)),.,$r(1,254))
      if ($readini(%mech.db,usedips,%mech.ip) = true) { echo 4 @mechdebug IP used %mech.ip }
      else { unset %mi | set %mech.sip true | haltdef }
      dec %mi 
    }
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

; //var %testn #b11,#b12,#b13,#b14,#b21,#b22,#b23,#b24,#b31,#b32,#b33,#b34,#b41,#b42,#b43,#b44 | var %tmpi $numtok(%testn,44) | while (%tmpi) { makemech3 10 $gettok(%testn,%tmpi,44) | dec %tmpi }


alias changechan {
  var %chans #b11,#b12,#b13,#b14,#b21,#b22,#b23,#b24,#b31,#b32,#b33,#b34,#b41,#b42,#b43,#b44 
  var %tmpi $numtok(%chans,44) 
  while (%tmpi) { 
    ; samode $gettok(%chans,%tmpi,44) +lL 2200 $+(#overflow,$right($gettok(%chans,%tmpi,44),2))
    join $+(#overflow,$right($gettok(%chans,%tmpi,44),2))
    dec %tmpi
  }
}
