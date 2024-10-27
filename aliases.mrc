alias nx.masmode.deall {
  if ( q isin $nickmode ) { nx.massmode $iif($1 == user,deowner,$iif($1 == oper, oper_deowner, botnet_deowner)) $2 $$3- }
  if ( a isin $nickmode ) { nx.massmode $iif($1 == user,deadmin,$iif($1 == oper, oper_deadmin, botnet_deadmin)) $2 $$3- }
  if ( o isin $nickmode ) { nx.massmode $iif($1 == user,deop,$iif($1 == oper, oper_deop, botnet_deop)) $2 $$2- }
  if ( h isin $nickmode ) { nx.massmode $iif($1 == user,dehalfop,$iif($1 == oper, oper_dehalfop, botnet_dehalfop)) $2 $$3- }
  if ( v isin $nickmode ) { nx.massmode $iif($1 == user,devoice,$iif($1 == oper, oper_devoice, botnet_devoice)) $2 $$3- }
}


alias nx.massmode {
  ; /nx.massmode op\deop\voice\devoice #chan nick nick1 nick2
  ; /nx.massmode botnet_op\botnet_deop\oper_op\oper_deop #chan nick nick1 nick2
  ; - botnet_ checks for %nx.botnet_NetWork botnick1 botnick2 and required active dcc chat with bot.
  ; TODO: Check if user is +k then skip it ( Use cached info from /who channel ? )
  ; TODO: Idea, use X, Q, ChanServ ?
  ; TODO: Idea, when ircop use uworld or opmode\samode ? - Check if $me has +go usermode
  if ( $3 ) {
    if ( $2 ) {
      var %nx.mass.tmpmode $remove($1,botnet_,oper_)
      if ( $istok(owner deowner admin deadmin op deop halfop dehalfop voice devoice,%nx.mass.tmpmode,32) ) {
        if ( $left($1,7) = botnet_ ) { var %nx.mass.usebotnet 1 }
        if ( $left($1,5) = oper_ ) { var %nx.mass.useopermode 1 }
        var %nx.mass.action $iif($left(%nx.mass.tmpmode,2) = de,take,give)
        if (%nx.mass.tmpmode = deowner) || (%nx.mass.tmpmode = owner) { var %nx.mass.mode q }
        elseif (%nx.mass.tmpmode = deadmin) || (%nx.mass.tmpmode = admin) { var %nx.mass.mode a }
        elseif (%nx.mass.tmpmode = deop) || (%nx.mass.tmpmode = op) { var %nx.mass.mode o }
        elseif (%nx.mass.tmpmode = dehalfop) || (%nx.mass.tmpmode = halfop) { var %nx.mass.mode h }
        elseif (%nx.mass.tmpmode = devoice) || (%nx.mass.tmpmode = voice) { var %nx.mass.mode v }
        else { echo -at Invalid mode %nx.mass.tmpmode | return }
        if ( %nx.mass.mode !isin $nickmode ) { echo -at Unsupported mode: %nx.mass.tmpmode | return } 
      }
      var %nx.mass.num $numtok($3-,32)
      while (%nx.mass.num) { 
        ; Fallback test IF this is not working on all networks (modenum returns ~&@%+)
        ; alias modenum return 0 $+ $replace($left($nick($1,$2).pnick,1),+,1,%,2,@,3,&,4,!,4,~,5,.,5)
        if ( %nx.mass.action = take ) && ($nick($2,$gettok($3-,%nx.mass.num,32),$replace(%nx.mass.mode,a,&))) { var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
        if ( %nx.mass.action = give ) && (!$nick($2,$gettok($3-,%nx.mass.num,32),$replace(%nx.mass.mode,a,&))) { var %nx.mass.nicks $addtok(%nx.mass.nicks,$gettok($3-,%nx.mass.num,32),32) }
        ; Finished gather nicks for this round
        if ( $numtok(%nx.mass.nicks,32) = $modespl ) { 
          if ( %nx.mass.usebotnet = 1 ) { 
            var %nx.mass.bot $nx.mass.pickbot
            if ( %nx.mass.bot ) { msg %nx.mass.bot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks " | unset %nx.mass.nicks }
            else { echo -at No bots active or is channel operator }
          }
          elseif ( %nx.mass.useopermode = 1 ) { nx.opmode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
          elseif ( $me isop $chan ) { nx.mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
          else { echo -at $me - You're not channel operator }
        }
        dec %nx.mass.num
      }
      ; Finish off
      if ( %nx.mass.nicks ) {
        if ( %nx.mass.usebotnet = 1 ) {
          var %nx.mass.bot $nx.mass.pickbot
          if ( %nx.mass.bot ) { msg %nx.mass.bot .tcl putquick "mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks " | unset %nx.mass.nicks %nx.mass.usebotnet }
          else { echo -at No bots active or is channel operator }
        }
        elseif ( %nx.mass.useopermode = 1 ) { nx.opmode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
        elseif ( $me isop $chan ) { nx.mode $2 $+($iif(%nx.mass.action = take,-,+),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks | unset %nx.mass.nicks }
        else { echo -at $me - You're not channel operator }
      }
    }
    else { echo -at Usage /massmode op\deop\voice\devoice #chan nick nick1 nick2 }
  }
  else { echo -at Usage /massmode op\deop\voice\devoice #chan nick nick1 nick2 }
}

alias nx.mass.pickbot {
  ; Need to redo this alias, it's a mess
  ; Idea, not use botnick but botnick!ident@host ?
  var %nx.botnet.pickbot $numtok(%nx.botnet_ [ $+ [ $network ] ],32)
  while (%nx.botnet.pickbot) { 
    if ( %nx.botnet.nextbot >= %nx.botnet.pickbot ) { set %nx.botnet.nextbot 1 }
    else { inc %nx.botnet.nextbot }
    ; Find next bot
    var %nx.botnet.tmpbot $gettok(%nx.botnet_ [ $+ [ $network ] ],%nx.botnet.nextbot,32)
    if ( %nx.botnet.tmpbot isop $chan ) && ( $chat(%nx.botnet.tmpbot).status = active ) { return $+(=,%nx.botnet.tmpbot) }
    dec %nx.botnet.pickbot
  }
}

alias nx.botnet.control {
  ; Note to self, in the future make this compact
  ; /nx.botnet.control join\part #chan bot1 bot2 bot3
  ; POPUPS: .join:nx.botnet.control join $$?="Channel?" $$1-
  ; POPUPS: .say:nx.botnet.control say $$?="Channel?" $$1-
  if ( $istok(join part,$1,32) ) && ( $3 ) {
    var %nx.botnet_loop_i $numtok($2-,32)
    while (%nx.botnet_loop_i) { 
      if ( $chat($gettok($3-,%nx.botnet_loop_i,32)).status = active) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%nx.botnet_loop_i,32),32) ) {
        msg $+(=,$gettok($3-,%nx.botnet_loop_i,32)) $iif($1 = join,.+chan,.-chan) $2
      }
      elseif ( $gettok($3-,%nx.botnet_loop_i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%nx.botnet_loop_i,32) }
      dec %nx.botnet_loop_i
    }
  }
  elseif ( $istok(chattr,$1,32) ) && ( $3 ) {
    var %nx.botnet.chattr.nick $?="Type a nick" 
    var %nx.botnet.chattr.flags $?="+- flags"
    var %nx.botnet.chattr.where $?="where GLOBAL for global"
    if ( %nx.botnet.chattr.nick ) && ( %nx.botnet.chattr.flags ) { 
      var %i $numtok($3-,32)
      while (%i) { 
        if ( $chat($gettok($3-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
          msg $+(=,$gettok($3-,%i,32)) .chattr %nx.botnet.chattr.nick %nx.botnet.chattr.flags $iif(%nx.botnet.chattr.where = GLOBAL,$NULL,%nx.botnet.chattr.where)
        }
        elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
        dec %i
      }
    }
  }
  elseif ( $istok(chanset,$1,32) ) && ( $3 ) {
    echo -a $1-
    var %i $numtok($5-,32)
    while (%i) { 
      if ( $chat($gettok($5-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($5-,%i,32),32) ) {
        msg $+(=,$gettok($5-,%i,32)) .chanset $2-3 
      }
      elseif ( $gettok($5-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($5-,%i,32) }
      dec %i
    }
  }
  elseif ( $istok(say,$1,32) ) && ( $3 ) {
    var %nx.botnet.say $?="What to say" 
    if ( %nx.botnet.say ) { 
      var %i $numtok($3-,32)
      while (%i) { 
        if ( $chat($gettok($3-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
          msg $+(=,$gettok($3-,%i,32)) .tcl putquick "privmsg $2 $+(:,%nx.botnet.say,")
        }
        elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
        dec %i
      }
    }
  }
  elseif ( $istok(registerns,$1,32) ) && ( $3 ) {
    var %i $numtok($3-,32)
    while (%i) { 
      if ( $chat($gettok($3-,%i,32)).status = active ) && ( $istok(%nx.botnet_ [ $+ [ $network ] ],$gettok($3-,%i,32),32) ) {
        msg $+(=,$gettok($3-,%i,32)) .tcl putquick "privmsg nickserv register $2 $gettok($3-,%i,32) $+ @lan.da9.no"
      }
      elseif ( $gettok($3-,%i,32) != $null ) { echo 4 -at During Botnet Controll ( $1 ) No dcc chat active with $gettok($3-,%i,32) }
      dec %i
    }
  }
  elseif ( $istok(jump rehash restart die,$1,32) ) { 
    var %i $numtok($2-,32)
    while (%i) { msg $+(=,$gettok($2-,%i,32)) $+(.,$1) | dec %i }
  }
  elseif ( $istok(hello,$1,32) ) { 
    var %i $numtok($2-,32)
    while (%i) { msg $gettok($2-,%i,32) hello | dec %i }
  }
}
alias nx.masskick {
  if ($3) { 
    var %nx.kick.num $numtok($3-,32)
    while (%nx.kick.num) {
      if ( $left($1,7) = botnet_ ) {
        var %nx.kick.bot $nx.mass.pickbot
        if ( %nx.kick.bot ) { msg %nx.kick.bot .tcl putquick "kick $2 $gettok($3-,%nx.kick.num,32) $iif(%nx.masskick.reason,%nx.masskick.reason,$null) " }
        else { echo -at No bots active or is channel operator }
      }
      elseif ( $me isop $2 ) { nx.kick $2 $gettok($3-,%nx.kick.num,32) $iif(%nx.masskick.reason,%nx.masskick.reason,$null) }
      else { echo -at $me - You're not channel operator }
      dec %nx.kick.num
    }
    unset %nx.masskick.reason
  }
  else { echo -at Usage /nx.masskick kick\botnet_kick #chan nick nick1 nick2 }
}

; Idea: is it possible to merge this to massmode ?
alias nx.massban {
  if ($3) && ( $istok(ban unban botnet_ban botnet_unban,$1,32) ) { 
    if ( $left($1,7) = botnet_ ) { var %nx.ban.usebotnet 1 }
    var %nx.ban.num $numtok($3-,32)
    while (%nx.ban.num) { 
      var %nx.ban.tmpaddr $address($gettok($3-,%nx.ban.num,32),5)
      if ( $istok(ban botnet_ban ,$1,32) ) { 
        if ( %nx.ban.nextrund isop $2 ) { 
          var %nx.ban.addrNick $addtok(%nx.ban.addrNick,$address(%nx.ban.addrNick,5),32) 
          var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,-o),-o) 
          unset %nx.ban.nextrund
        }
        var %nx.ban.addrNick $addtok(%nx.ban.addrNick,%nx.ban.tmpaddr,32)
        var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,+b),+b)
        ; Here, check if nick is +qao
        if ( $gettok($3-,%nx.ban.num,32) isop $2 ) {
          if ($numtok(%nx.ban.addrNick,32) != $modespl) { 
            var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,-o),-o)
            var %nx.ban.addrNick $addtok(%nx.ban.addrNick,$gettok($3-,%nx.ban.num,32),32) 
          }
          else { set %nx.ban.nextrund $gettok($3-,%nx.ban.num,32) }
        }
      }
      ; Need to check if user is banned
      if ( $istok(unban botnet_unban ,$1,32) ) { 
        var %nx.ban.addrNick $addtok(%nx.ban.addrNick,%nx.ban.tmpaddr,32) 
        var %nx.ban.mode $iif(%nx.ban.mode,$+(%nx.ban.mode,-b),-b)
      }
      ; Finished gather address for this round
      if ($numtok(%nx.ban.addrNick,32) = $modespl) { 
        if ( %nx.ban.usebotnet = 1 ) { msg $nx.mass.pickbot .tcl putquick "mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
        elseif ( $me isop $2 ) { nx.mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
        else { echo -at $me - You're not channel operator }
      }
      dec %nx.ban.num
    }
    ; Finish off
    if ( %nx.ban.addrNick ) { 
      if ( %nx.ban.usebotnet = 1 ) { msg $nx.mass.pickbot .tcl putquick "mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
      elseif ( $me isop $2 ) { nx.mode $2 %nx.ban.mode %nx.ban.addrNick | unset %nx.ban.mode %nx.ban.addrNick }
      else { echo -at $me - You're not channel operator }
    }
    unset %nx.masskick.reason
  }
  else { echo -at Usage /massban ban\unban #chan nick nick1 nick2 }
}

alias massv2 {
  ; Popups
  ; Mass
  ; .voice:massv2 $chan voice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0))
  ; .devoice:massv2 $chan devoice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0))
  ; /massv2 #chan voice\devoice 10 (voice\devoice 10 of the channel users
  ; /massv2 #chan voice\devoice 2 d (voice\devoice 1\2 of the channel users
  ; /massv2 #chan voice\devoice 4 d (voice\devoice 1\4 of the channel users, etc
  if (($2 = voice) || ($2 == devoice)) {
    if ( $isnum($3) ) { 
      var %nx.mass.num $3
      if ( $4 = d ) { 
        var %nx.mass.num = $iif($2 = voice,$nick($1,0,r),$nick($1,0,v)) 
        var %nx.mass.tc $calc(%nx.mass.num / $3) 
        var %nx.mass.num $iif($chr(46) isin %nx.mass.tc,$gettok(%nx.mass.tc,1,46),%nx.mass.tc) 
      }
    }
    else { var %nx.mass.num = $iif($2 = voice,$nick($1,0,r),$nick($1,0,v)) }
    var %nx.mass.mode v 
    while (%nx.mass.num) { 
      var %nx.mass.nicks = %nx.mass.nicks $iif($2 = voice,$nick($1,%nx.mass.num,r),$nick($1,%nx.mass.num,v))
      if ($numtok(%nx.mass.nicks,32) = $modespl) { mode $1 $+($iif($2 = voice,$chr(43),$chr(45)),$str(%nx.mass.mode,$modespl)) %nx.mass.nicks | unset %nx.mass.nicks } 
      dec %nx.mass.num
    }
    if (%nx.mass.nicks) { mode $1 $+($iif($2 = voice,$chr(43),$chr(45)),$str(%nx.mass.mode,$numtok(%nx.mass.nicks,32))) %nx.mass.nicks | unset %nx.mass.nicks }
  }
}
