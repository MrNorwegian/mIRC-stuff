on *:start:{
  ; connectall is just a bunch of /server -m
  if ( %nx.autoconnect = yes ) { connectall }
}

on 1:connect:{
  ; Part of custom IAL
  if ( $readini($+(ial\,$network,_,$cid,.ini),status,connected) ) { .remove $+(ial\,$network,_,$cid,.ini) | writeini $+(ial\,$network,_,$cid,.ini) status connected 1 }
  else { writeini $+(ial\,$network,_,$cid,.ini) status connected 1 }
}

on 1:disconnect:{ 
  ; Part of custom IAL
  if ( $readini($+(ial\,$network,_,$cid,.ini),status,connected) ) { writeini $+(ial\,$network,_,$cid,.ini) status connected 0 }
  else { writeini $+(ial\,$network,_,$cid,.ini) status connected 0 }
}

on ^1:notice:*:?:{
  if ($istok(%nx.services.bots,$nick,32)) {
    ; TODO Check if it's really nickserv (hostname)
    if ($nick = NickServ) {
      if (This nickname is registered. isin $1-4) && ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) {
        if ( $gettok($nx.db(read,settings,nickserv,$network),1,32) = $me ) {
          .msg nickserv identify $me $gettok($nx.db(read,settings,nickserv,$network),2,32)
        }
      }
      if ( has been ghosted. isin $2-4 ) && ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) { 
        nick $strip($1)
      }
      else { nx.echo.notice $nick $1- | halt }
    }
    elseif (( $nick = UWorld ) || ($nick == Bworld)) && ( $nx.db(read,opernet,$network) ) {
      nx.echo.notice $nick $1-
      if ( $5 = authenticated ) { halt }
      ; Bworld says nick. and uworld says nick! 
      elseif ( $1- = Authentication successful as ) {
        ; TODO add %nx.loggedon to confirm in raw (invite) before doing msg bworld invite
        var %nx.check.onoperchan $nx.db(read,settings,operchans,$network)
        while ( %nx.check.onoperchan >= 0 ) {
          if ( $me !ison $gettok($nx.db(read,settings,operchans,$network),%nx.check.onoperchan,32) ) { .msg $nick invite $gettok($nx.db(read,settings,operchans,$network),%nx.check.onoperchan,32) }
          dec %nx.check.onoperchan
        }
      }
    }
    else { nx.echo.notice $nick $1- }
    halt
  }
  ; Ignore spambots when excecuted a command
  elseif ( 172.1 isin $address($nick,2) ) && ( %mechfloodprotect ) {
    if ( $5 = immortal ) { halt }
    elseif ( $3 = already ) { halt }
    elseif ( $1 = already ) { halt }
    elseif ( $1 = Message ) { halt }
    elseif ( $1 = Attempting ) { halt }
    elseif ( $1 = Parting) { halt }
    elseif ( $1 = Cycling) { halt }
    elseif ( $2 = open) { halt }
    else { nx.echo.notice $nick $1- | halt }
  } 
  elseif ( $1-9 = As master you really need to set a password: ) { 
    .timer_autosetpass 1 2 msg $nick pass p455w0rd 
    nx.echo.notice $nick $1-
    halt
  }
  else { nx.echo.notice $nick $1- | halt }
}

on 1:usermode:{
  ; When on znc i need this to make sure snotice windows is up 
  if ( o isincs $1 ) && ( $left($1,1) == $chr(43) ) { window -De $+(@,$network,_,$cid,_,status) | echo 3 -st You are now an IRC Operator on $network }
}

on 1:mode:#:{
  ; TODO update userlist based on mode +qaohv 
  ; burst update but stop after x mods to prevent flood of .ini writes
  ; if flooded run /names instead after some secs, then allow update of modes ?
}

on 1:nick:{
  ; Update "custom ial", this needs to be hashtable in the future
  ; $remove is a ugly hack to remove [ from nick because of bug
  var %nx.onnick.chans $chan(0), %nx.onnick.nick $remove($nick,$chr(91)), %nx.onnick.newnick $remove($newnick,$chr(91))
  while (%nx.onnick.chans >= 0) {
    if ( $readini($+(ial\,$network,_,$cid,.ini),$chan(%nx.onnick.chans),%nx.onnick.nick) ) {
      remini $+(ial\,$network,_,$cid,.ini) $chan(%nx.onnick.chans) %nx.onnick.nick
      writeini $+(ial\,$network,_,$cid,.ini) $chan(%nx.onnick.chans) %nx.onnick.newnick $v1
    }
    dec %nx.onnick.chans
  }
}

on *:join:*:{
  if ( $me !isvoice $chan ) && ( $chan = #IdleRPG ) && ( $nick != $me ) {
    ; TODO make a check on timer to check if bot is gettig OP
    if ( $address($nick,5) = IdleBot!idlerpg@idlebot.users.deepnet.chat ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
    if ( $address($nick,5) = idlerpg!multirpg@idlerpg.users.undernet.org ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
    if ( $address($nick,5) = idlerpg!*IdleRPG@idle.rpgsystems.org ) { .timer_idlebot_ $+ $cid 1 2 .msg $nick login %nx.idlerpg.user %nx.idlerpg.pass }
  }
  elseif ( $nick = $me ) { set %nx.ial.update. [ $+ [ $cid ] ] true | set %nx.ial.update. [ $+ [ $chan ] ] true }
}

on *:part:*:{
  if ( $nick = $me ) { echo -st Removed userlist for $chan | remini $+($cid,.ini) $chan }
}

on *:quit:{
  ; TODO loop thru all channels and remove userlist ? This is a bit redudant since it gets removed on join (return on raw /names)
  return
}

on ^1:SNOTICE:*:{ nx.echo.snotice $1- | halt }

on *:invite:*:{ if ( $istok($nx.db(read,settings,operchans,$network),$chan,32) ) { join $chan } }

on 1:text:*:?:{
  ; znc is reconnected 
  if ($left($nick,1) = $chr(42)) && ( $1 = Connected! ) { set %nx.ial.update. [ $+ [ $cid ] ] true }
}

on *:open:?:{
  ; check for own botnet or znc
  if ( $istok(%nx.botnet_ [ $+ [ $network ] ],$nick,32)) || ($left($nick,1) = $chr(42) ) { return }
  else {
    var %nx.flood.query.ugh 4
    var %nx.flood.query.max 10
    var %nx.flood.query.time 10

    inc -u10 %nx.flood.query 1
    if (%nx.flood.query >= %nx.flood.query.max) {
      echo 4 -at Anti Query flood har blokkert %nx.flood.query query'er
      ignore -u60 $address($nick,2)
      .timer_nx.flood.query 1 %nx.flood.query.time dec %nx.flood.query
      close -m $nick
    }
    elseif (%nx.flood.query >= %nx.flood.query.ugh) {
      echo 4 -at Anti Query flood har blokkert %nx.flood.query query'er
      ignore -u60 $address($nick,2)
      .timer_nx.flood.query 1 %nx.flood.query.time dec %nx.flood.query
      close -m $nick
    }
    else {
      whois $nick $nick
      .timer_nx.flood.query 1 %nx.flood.query.time dec %nx.flood.query
    }
  }
}

;ctcp 1:time:?:/ctcpreply $nick TIME $date(ddd ddoo mmm yyyy hh:mmt) ;| halt
;ctcp 1:ping:?:/ctcpreply $nick PING Ouch!

