; Makemech script to generate mech config files and server ipaddr.sh files

alias makemech {
  unset %mech.*
  var %servers 4
  while ( %servers ) {
    remove $+(mech\server,-,s,%servers,.sh)
    var %chans 16
    while ( %chans ) {
      remove $+(mech\mech,-,s,%servers,c,%chans,.conf)
      makemech3 $1 $+($chr(35),s,%servers,c,%chans)
      dec %chans
    }
    dec %servers
  }
}
alias makemech3 {
  if ( $1 >= 1 ) {
    window -De @mech
    window -De @mechdebug

    set %mech.interface enp0s31f6
    set %mech.chan $iif($2,$2,#spambots)
    set %mech.randomip no
    ; set %mech.randomchan false
    set %mech.randomchan true
    set %mech.randomnick true
    ; set %usenamesfile girlboy\names123
    set %mech.usenamesfile names123
    if ( %mech.randomip = no ) {
      set %mech.startip 172.19.
      set %mech.ns 0
      set %mech.endip 0
      set %mech.prefix /15

      var %s 1 ,%ms 4
      ; %ms is max servers
      while (%s <= %ms) {
        ; %mc is max channels
        var %inc 4, %c 1, %mc 16
        while (%c <= %mc) {
          if ( %mech.chan = $+($chr(35),s,%s,c,%c) ) {
            echo 3 -t @mech Server %s Channel %c Subnet %mech.ns Chan %mech.chan
            set %mech.nextsubnet %mech.ns
            haltdef
          }
          inc %mech.ns %inc
          inc %c
        }
        inc %s
      }
    }

    ; var %mech.db $+(mech,-,$remove($2,$chr(35)),.ini)
    var %mech.db mech-spambots.ini
    set %mech.pause 2000
    ;var %mech.servers 172.18.0.41,172.18.0.42,172.18.0.43
    ;var %mech.ports 6660,6661,6662,6663,6664,6665,6666,6667,6668,6669,7000
    var %mech.servers 172.18.0.41,172.18.0.42,172.18.0.43,172.18.0.11,172.18.0.9
    var %mech.ports 6661,6662,6663,6664,6665,6666,6667,6668,6669
    var %mech.network CreepNet
    var %mechconfig $+(mech\mech,-,$remove(%mech.chan,$chr(35)),.conf)
    var %serverconf $+(mech\server,-,$left($remove(%mech.chan,$chr(35)),2),.sh)

    write %mechconfig set ctimeout 60
    write %mechconfig servergroup %mech.network
    set %mech.ctime.start $ctime
    set %mech.numbots $1
    var %i 1
    var %p $numtok(%mech.ports,44) 
    set %mech.ctime $ctime
    echo 13 -t @mech Makemech Writing $calc($numtok(%mech.servers,44)+ $numtok(%mech.ports,44)) server lines and %mech.numbots bots with subnet %mech.nextsubnet
    while (%p) { 
      var %s $numtok(%mech.servers,44)
      while (%s) { write %mechconfig SERVER $gettok(%mech.servers,%s,44) $gettok(%mech.ports,%p,44) | dec %s } 
      dec %p
    }
    write %mechconfig $crlf
    write %mechconfig $crlf
    while ( %i <= %mech.numbots ) {
      if ( $mechpick = false ) { echo 4 -t @mech FAILED, was not able to pick a nick or ip | unset %mech.* | halt }
      ; Little hack since 172.19.255.255 is broadcast use .18. instead (within the same subnet)
      if ( %mech.ip = 172.19.255.255 ) { set %mech.ip 172.18.255.255 }
      ; echo 3 @mechdebug ID: %i NICK: %mech.nick IP: %mech.ip
      ; pause for 1 second every xx bots (to avoid ping time out)
      if ( %p > 50 ) { echo -t @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks | pause %mech.pause | set %p 1 | set %mech.ctime $ctime | unset %mech.sum.nicks }
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
      write %mechconfig join $iif(%mech.randomchan = false,%mech.chan,$+(%mech.chan,-,$random(1,N)))
      write %mechconfig set pub 1
      write %mechconfig set aop 1
      write %mechconfig set avoice 1
      write %mechconfig set prot 4
      write %mechconfig set virtual %mech.ip
      write %mechconfig $crlf

      inc %i
      write %serverconf ip addr add dev %mech.interface $+(%mech.ip,%mech.prefix)
      ; writeini %mech.db usedips %mech.ip true
      ; writeini %mech.db usednicks %mech.nick true

      unset %mech.nick
    }
    else { echo 3 -at Syntax /makemech 128 }
  }
  ;write %serverconf cd /home/naka
  ;write %serverconf mv $remove(%mechconfig,mech\) mech/
  ;write %serverconf cd mech
  ;write %serverconf rm *.pid *.session *.conf
  ;write %serverconf echo ./energymech -f $remove(%mechconfig,mech\)
  echo @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks
  echo 13 @mech Makemech DONE with %i \ %mech.numbots bots in $duration($calc($ctime - %mech.ctime.start))
  unset %mechconfig %mechm.* %mech.chan %mech.interface %mech.numbots %mech.gnamesfile %mech.bnamesfile %mech.usenamesfile %mech.randomip %mech.randomchan %mech.startip %mech.nextsubnet %mech.endip %mech.prefix %mech.db %mech.pause %mech.servers %mech.ports %mech.network %mech.ctime.start %mech.ctime %mech.sum.nicks %mech.nick %mech.ip %mechconfig %mech.mechpick
}
alias mechpick {
  var %mn 100, %mi 100
  if ( %mech.randomnick = true ) { set %mech.nick $+($remove(%mech.chan,$chr(35)),-,$random(12,R,R)) | set %mech.snick true }
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
  else { echo 4 @mech FAILED, was not able to pick a nick SIP: %mech.sip NICK: %mech.snick  | return false } 
}
alias makemech2 {
  ; Making only ipaddr.sh file for the servers with no random ips
  set %mech.startip 172.19.
  var %mech.ns 0
  var %mech.endip 0
  var %mech.prefix /15
  var %mech.numbots 1024
  var %s 1 ,%ms 4, %t $ctime
  ; %ms is max servers
  while (%s <= %ms) {
    ; %mc is max channels
    var %inc 4, %c 1, %mc 16 ,%st $ctime
    while (%c <= %mc) {
      var %b %mech.numbots ,%ct $ctime
      while (%b) { 
        var %mech.ip $+(%mech.startip,%mech.ns,.,%mech.endip)
        if ( %mech.endip = 255 ) { set %mech.endip 0 | inc %mech.ns }
        else { inc %mech.endip }
        write $+(mech\ipaddr,$remove($+($chr(35),s,%s),$chr(35)),.sh) ip addr add dev enp0s31f6 %mech.ip
        dec %b
      }
      echo 3 -t @mech Server %s Channel %c Bots: %mech.numbots in $duration($calc($ctime - %ct)) \ $duration($calc($ctime - %st)) Total $duration($calc($ctime - %t)) 
      pause 2000
      inc %c 
    }
    inc %s
  }
  unset %mech.*
}
on *:INPUT:*:{
  if ( $1 = -say ) { set -u10 %mechfloodprotect 1 }
  if ( $1 = -join ) || ( $1 = -part ) || ( $1 = -cycle ) { set -u10 %mechfloodprotect 1 }
}
alias mech {
  if ( $1 = amsg ) { set -u5 %mechfloodprotect 1 | .amsg $2- | halt }
  if ( $1 = msg ) { set -u5 %mechfloodprotect 1 | .msg $2 $3- | halt }
  if ( $1 = say ) { set -u5 %mechfloodprotect 1 | .say $2 $3- | halt }
  var %idlerpass SpamPass
  var %n $nick($chan,0,r)
  var %botnick $2
  while (%n) {
    if ( 172.18. isin $address($nick($chan,%n),2) ) || ( 172.19. isin $address($nick($chan,%n),2) ) { 
      if ( $1 = login ) && ( $nick($chan,%n) isreg $chan ) { set -u5 %nx.anex.tmpdisabled true | set -u5 %mechfloodprotect true | .nx.msg $nick($chan,%n) auth p455w0rd }
      if ( $nick($chan,%n) isreg $chan ) {
        if ( $1 = idlerpgregister ) { .nx.msg $nick($chan,%n) -msg %botnick register $nick($chan,%n) %idlerpass $nick($chan,%n) }
        if ( $1 = idlerpglogin ) { .nx.msg $nick($chan,%n) -msg %botnick login $nick($chan,%n) %idlerpass }
      }
    }
    else { echo FALSE Nr $nick($chan,%n) - $address($nick($chan,%n),2) }
    dec %n
  }
}

