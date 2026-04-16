; Makemech script to generate mech config files and server ipaddr.sh files

alias makemech {
  if ( $1 >= 1 ) {
    window -De @mechdebug
    window -De @mech
    unset %mech.*
    if ( $hget(mechips) ) { hfree mechips }
    if ( $hget(mechnicks) ) { hfree mechnicks }
    hmake mechips 10000
    hmake mechnicks 10000
    ; Number of servers we wil run mech on
    set %mech.servers 3
    var %s 1
    while ( %s <= %mech.servers ) {
      remove $+(mech\server,-,s,%s,.sh)
      var %chans 1
      while ( %chans ) {
        remove $+(mech\mech,-,s,%s,c,%chans,.conf)
        makemech3 $1 $+($chr(35),s,%s,c,%chans)
        dec %chans
      }
      inc %s
    }
  }
  else { echo 3 -at Syntax /makemech 128 }
}
alias makemech3 {

  set %mech.interface ens18
  set %mech.chan $iif($2,$2,#spambots)

  ; if true using %mech.startip then random ip generation
  ; if false using systematic ip generation
  set %mech.randomip false

  ; if true chan will be random #chan-N where N is a number  
  set %mech.randomchan false

  ; if true = s1c1-abc, if false = random nicks (see usernamesfile variable)
  set %mech.randomnick false

  ; %usenamesfile options: girlboy , names123
  set %mech.usenamesfile names123

  set %mech.pause 2000

  ; Servers to connect to, comma separated for multiple servers
  var %mech.ircservers 172.18.0.99,172.16.100.23,172.18.0.101,172.18.0.102,172.18.0.103

  ; More ports more server lines in config (more servers+ports = faster loading)
  var %mech.ports 6660,6661,6662,6663,6664,6665,6666,6667,6668,6669

  var %mech.network TundraIRC

  if ( %mech.randomip = false ) {
    set %mech.startip 172.19.
    ; mech.ns is next subnet, so 172.18.ns.endip
    if ( %mech.subnet ) { inc %mech.subnet }
    else { set %mech.subnet 11 }
    ; endip is checked in the script (starting at whats defined and stopping at 255, then inc mech.ns)
    set %mech.endip 0
    set %mech.prefix /15
  }

  var %mechconfig $+(mech\mech,-,$remove(%mech.chan,$chr(35)),.conf)
  var %serverconf $+(mech\server,-,$left($remove(%mech.chan,$chr(35)),2),.sh)

  ; Starting to write mech config file
  write %mechconfig ##### Mech Configuration File #####
  write %mechconfig set ctimeout 60
  write %mechconfig servergroup %mech.network
  set %mech.ctime.start $ctime
  var %p $numtok(%mech.ports,44) 
  set %mech.ctime $ctime

  ; Writing server lines
  echo 13 -t @mech Makemech Writing $calc($numtok(%mech.ircservers,44)+ $numtok(%mech.ports,44)) server lines
  while (%p) { 
    var %s $numtok(%mech.ircservers,44)
    while (%s) { write %mechconfig SERVER $gettok(%mech.ircservers,%s,44) $gettok(%mech.ports,%p,44) | dec %s } 
    dec %p
  }
  write %mechconfig $crlf
  write %mechconfig $crlf

  ; Now writing each bot configuration
  echo 13 -t @mech Makemech Writing %mech.numbots bot configurations

  var %i 1, %n 1
  set %mech.numbots $1
  while ( %i <= %mech.numbots ) {
    if ( $mechpick = false ) { echo 4 -t @mech FAILED, was not able to pick a nick or ip | unset %mech.* | halt }
    if ( %mech.ip = 172.19.255.255 ) { echo 4 -t @mech FAILED, ran out of ips to assign | unset %mech.* | halt }
    ; pause for 1 second every xx bots (to avoid ping time out)
    if ( %n > 50 ) { echo -t @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks | pause %mech.pause | set %n 1 | set %mech.ctime $ctime | unset %mech.sum.nicks }
    else { inc %n | set %mech.sum.nicks $addtok(%mech.sum.nicks,%mech.nick,32) }
    ;write mech.set ##### Bot %i Configuration #####
    write %mechconfig set servergroup %mech.network
    write %mechconfig nick %i %mech.nick
    write %mechconfig set altnick $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9)) $+(%mech.nick,-,$r(1,9))
    write %mechconfig set userfile mech.passwd
    write %mechconfig set ident %mech.nick
    write %mechconfig set ircname %mech.nick
    ;write %mechconfig set umodes +i
    write %mechconfig set cmdchar -
    write %mechconfig set modes 8
    write %mechconfig set cc 1
    write %mechconfig join $iif(%mech.randomchan = false,%mech.chan,$+(%mech.chan,-,$nx.random(1,N)))
    write %mechconfig set pub 1
    ;write %mechconfig set aop 1
    ;write %mechconfig set avoice 1
    ;write %mechconfig set prot 4
    write %mechconfig set virtual %mech.ip
    write %mechconfig $crlf

    inc %i
    write %serverconf ip addr add dev %mech.interface $+(%mech.ip,%mech.prefix)
    hadd mechips %mech.ip %mech.nick
    hadd mechnicks %mech.nick %mech.ip

    unset %mech.nick
  }
  else { echo 3 -at Syntax /makemech 128 }
  ;^ user was written on , no worries ? :/ 
  ;write %serverconf cd /home/naka
  ;write %serverconf mv $remove(%mechconfig,mech\) mech/
  ;write %serverconf cd mech
  ;write %serverconf rm *.pid *.session *.conf
  ;write %serverconf echo ./energymech -f $remove(%mechconfig,mech\)
  echo @mech Time: 7 $duration($calc($ctime - %mech.ctime)) ( %i \ %mech.numbots bots ) - 14 %mech.sum.nicks
  echo 13 @mech Makemech DONE with %i \ %mech.numbots bots in $duration($calc($ctime - %mech.ctime.start))
  unset %mechconfig %mechm.* %mech.chan %mech.interface %mech.numbots %mech.gnamesfile %mech.bnamesfile %mech.usenamesfile %mech.randomip %mech.randomchan %mech.startip %mech.prefix %mech.db %mech.pause %mech.ircservers %mech.ports %mech.network %mech.ctime.start %mech.ctime %mech.sum.nicks %mech.nick %mech.ip %mechconfig %mech.mechpick
}
alias mechpick {
  var %mn 100, %mi 100
  if ( %mech.randomnick = true ) { set %mech.nick $+($remove(%mech.chan,$chr(35)),-,$nx.random(12,R,R)) | set %mech.snick true }
  else { 
    set %mech.gnamesfile mech/girlnames.txt | set %mech.bnamesfile mech/boynames.txt
    while (%mn) {
      if (%mech.usenamesfile = girlboy) { set %mech.nick $gettok($read($iif($r(1,2) = 1,%mech.gnamesfile,%mech.bnamesfile),$r(1,999)),2,32) }
      if (%mech.usenamesfile = names123) { set %mech.nick $read($+(mech/,NAMES,$r(1,3),.txt)) }
      if ( $hget(mechnicks,%mech.nick) ) { echo 4 @mechdebug Nick used %mech.nick | dec %mn }
      elseif ($regex(%mech.nick,/[^a-zA-Z0-9-]/) = 0) { unset %mn | set %mech.snick true | haltdef }
      else { echo 4 @mechdebug Nick invalid $+($remove(%mech.chan,$chr(35)),-,%mech.nick,$nx.random(2,N)) | dec %mn }
    }
  }
  if ( %mech.randomip = false ) { 
    set %mech.ip $+(%mech.startip,%mech.subnet,.,%mech.endip)
    if ( %mech.endip = 255 ) { set %mech.endip 0 | inc %mech.subnet }
    else { inc %mech.endip }
    unset %mi | set %mech.sip true | haltdef
  }
  if ( %mech.randomip = true ) { 
    while (%mi) {
      var %mech.i2 $r(18,19)
      set %mech.ip $+(172,.,%mech.i2,.,$iif(%mech.i2 = 18,$r(1,255),$r(0,255)),.,$r(1,254))
      if ( $hget(mechips,%mech.ip) ) { echo 4 @mechdebug IP used %mech.ip }
      else { unset %mi | set %mech.sip true | haltdef }
      dec %mi 
    }
  }
  if ( %mech.sip = true ) && ( %mech.snick = true ) { return true }
  else { echo 4 @mech FAILED, was not able to pick a nick SIP: %mech.sip NICK: %mech.snick  | return false } 
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
  if ( $1 == chnick ) { 
    set -u30 %mechfloodprotect 1 
    var %n $nick($chan,0)
    while (%n) { 
      if ( $gettok($nick($chan,%n),2,45) ) { !msg $chan $nick($chan,%n) nick $+($gettok($nick($chan,%n),1,45),$r(8,9),$r(1,9)) }
      dec %n
    }
  }
  if ( $1 = joinpart ) { 
    set -u30 %mechfloodprotect $chan
    .msg #s1c1 -join $2
    .msg #s2c1 -join $2
    .msg #s3c1 -join $2
    .timer_p1 1 2 .msg #s1c1 -part $2
    .timer_p2 1 2 .msg #s2c1 -part $2
    .timer_p3 1 2 .msg #s3c1 -part $2
    halt
  }
}
