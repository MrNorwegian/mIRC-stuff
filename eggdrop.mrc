; Makes eggdrops play the duckhunt game
; Requires you to have a open dcc chat with the bots
on 1:TEXT:*:*:{
  if ( $chan = #duckhunt ) {
    if ( $network = CreepNet ) && ( $me = naka ) {
      if ( $nick = DuckHunt ) && ( $1 != $me ) {
        ; echo 3 $chan ducks %nx_duck_ducks
        var %r $+(reload_,$cid,_,$1)
        var %r1 $+(rearm_,$cid,_,$1)
        var %a $+(retry_,%nx_duck_ducks,_,$cid,_,%nx.botnet.duck_bot)
        var %n $+(new_,%nx_duck_ducks,_,$cid,_,%nx.botnet.duck_bot)
        var %s $+(shop_,$cid,_,$1)
        var %text $strip($1-)

        var %t $r(5,15)
        var %rt $r(10,15)
        var %st $r(3,5)
        set %nx.botnet.duck_rn $r(1,$numtok(%nx.botnet_ [ $+ [ $network ] ],32))
        set %nx.botnet.duck_bot $gettok(%nx.botnet_ [ $+ [ $network ] ],%nx.botnet.duck_rn,32)

        if ( debug = debugDeactivated ) { echo 13 $chan 1 = $1 2 = $2 3 = $3 4 = $4 5 = $5 6 = $6 7 = $7 8 = $8 9 = $9 10 = $10 11 = $11 12 = $12 13 = $13 14 = $14 }

        if ( QUACK isin $3 ) { .timer_quack_ $+ %n 1 %t .msg $+(=,%nx.botnet.duck_bot) .tcl putserv "privmsg $chan :!bang" | inc %nx_duck_ducks | halt }

        elseif ( $3 = Missed. ) || ( survived isin $2- ) || ( accident isin $2- ) { .timer_quack_ $+ %a 1 %t .msg $+(=,%nx.botnet.duck_bot) .tcl putserv "privmsg $chan :!bang" | halt }

        elseif ( Your gun is jammed isin $4-7 ) || ( JAMMED GUN isin $2-) || ( Trigger locked. isin $3- ) {
          .timer_quack_ $+ %r 1 %rt .msg $+(=,$1) .tcl putserv "privmsg $chan :!reload" 
          .timer_quack_ $+ %a 1 %t .msg $+(=,%nx.botnet.duck_bot) .tcl putserv "privmsg $chan :!bang" 
          halt
        }
        elseif ( You reload isin $2- ) {
          if (Chargers isin $11) && ($gettok($strip($12),1,47) <= 1) { .timer_quack_s_ $+ %s 1 %st .msg $+(=,$1) .tcl putserv "privmsg $chan :!shop 2" }
          halt
        }
        elseif ( You unjam your gun isin $4-7 ) {
          if (Chargers isin $12) && ($gettok($strip($13),1,47) <= 1) { .timer_quack_s_ $+ %s 1 %st .msg $+(=,$1) .tcl putserv "privmsg $chan :!shop 2" }
          halt
        }
        elseif ( You unjam and reload your gun. isin $4-9 ) {
          if (Chargers isin $14) && ($gettok($strip($15),1,47) <= 1) { .timer_quack_s_ $+ %s 1 %st .msg $+(=,$1) .tcl putserv "privmsg $chan :!shop 2" }
          halt
        }
        elseif ( EMPTY MAGAZINE isin $4-5 ) || ( You have no ammo. isin $3-6 ) {
          if (Chargers isin $11) && ($gettok($strip($12),1,47) <= 1) { 
            .timer_quack_ $+ %s 1 %st .msg $+(=,$1) .tcl putserv "privmsg $chan :!shop 2"
          }
          .timer_quack_ $+ %r 1 %rt .msg $+(=,$1) .tcl putserv "privmsg $chan :!reload"
          .timer_quack_ $+ %a 1 %t .msg $+(=,%nx.botnet.duck_bot) .tcl putserv "privmsg $chan :!bang"
          halt
        }
        elseif ( You are not armed. isin $3- ) { 
          .timer_quack_ $+ %r1 1 %t msg $chan !rearm $1 
          .timer_quack_ $+ %a 1 %t .msg $+(=,%nx.botnet.duck_bot) .tcl putserv "privmsg $chan :!bang"
          halt
        }
        elseif ( escapes isin $2- ) || ( Frightened by so much noise isin $1-6 ) || ( You shot down a golden duck isin $4-9 ) || ( You shot down one of the ducks isin $4-10 ) { dec %nx_duck_ducks | halt }
        elseif ( You shot down the duck isin $2- ) || ( You shot down the golden duck isin $2- ) { set %nx_duck_ducks 0 | halt }

        elseif ( searching isin $2- ) || ( returns isin $2- ) || ( rich isin $2- ) || ( extra magazine isin $2- ) || ( ammunitions isin $2- ) { halt }
        elseif ( There is no duck in the area isin $2- ) || ( Your gun doesn't need isin $2- ) || ( is demoted to level isin $2- ) | ( The magazine of your isin $2- ) { halt }

        else { echo 5 $chan 1 = $1 2 = $2 3 = $3 4 = $4 5 = $5 6 = $6 7 = $7 8 = $8 9 = $9 10 = $10 11 = $11 12 = $12 13 = $13 14 = $14 }
      }
    }
  }
}
on 1:CHAT:*:{
  if ( $istok(%nx.botnet_ [ $+ [ $network ] ],$nick,32) ) || ( $nick = DuckHunt ) {
    if ( $1- = Please enter your handle. ) { .msg =$nick %nx.botnet_username }
    if ( $1- = Enter your password. ) { .msg =$nick %nx.botnet_password }
  }
}
alias botattr {
  if ( $1 ) { 
    .say .unlink $1
    .timer_botattr_ $+ $1 1 1 .say .botattr $1 $iif($2,$2,$null)
    .timer_link_ $+ $1 1 2 .say .link $1
  }
  else { echo 9 -a /botattr <nick> <a,b,c,d,e,g,h,i,j,l,n,p,r,s,u> }
}

alias egg { 
  var %nx.eggdropchan #spychan
  if ( $1 = addchan ) { 
    say .+chan %nx.eggdropchan
  }
  if ( $1 = addhubuser ) { 
    .say .+user $+($2,hub) 
    .say .+host $+($2,hub) $address($3,6)
    .say .chattr $+($2,hub) +afo
  }
  elseif ( $1 = leafbotattr ) { 
    if ( $2 ) {
      .say .unlink $2
      .timer_botattr_ $+ $2 1 1 .say .botattr $2 s
      .timer_link_ $+ $2 1 2 .say .link $2
    }
  }
  elseif ( $1 = add ) { 
    if ( $2 = leaf ) {
      if ( $3 ison %nx.eggdropchan ) {
        .say .+bot $3 $gettok($address($3,2),2,64) 3331
        .say .+host $3 $address($3,6)
        .timer_addleafb1_ $+ $3 1 1 .say .botattr $3 s|s %nx.eggdropchan
        ; .timer_addleafb2_ $+ $3 1 1 .say .botattr $3 +l
        .timer_addleafc_ $+ $3 1 1 .say .chattr $3 +afob
        .timer_addleaflink_ $+ $3 1 2 .say .link $3
      }
    }
    if ( $2 = hub ) {
      if ( $3 ison %nx.eggdropchan ) {
        .say .+bot $3 $gettok($address($3,2),2,64) 3331
        .say .+host $3 $address($3,6)
        .timer_addhubb_ $+ $3 1 1 .say .botattr $3 +hp
        .timer_addhubc_ $+ $3 1 1 .say .chattr $3 +afob
        .timer_addhublink_ $+ $3 1 2 .say .link $3
      }
    }
    else { echo 9 -a /egg add <leaf\hub> <nick> - Bot must be in %nx.eggdropchan }
  }
  elseif ( $1 = botattrleafs ) { 
    if ( $nick = Tassen ) { botattr donald $2 | botattr KalleAnka $2 | botattr AndersAnd $2 }
    if ( $nick = Donald ) { botattr doffen $2 | botattr ole $2 | botattr dole $2 }
    if ( $nick = AndersAnd ) { botattr Rip $2 | botattr Rap $2 | botattr Rup $2 }
    if ( $nick = KalleAnka ) { botattr Knatte $2 | botattr Tjatte $2 | botattr Fnatte $2 }
  } 
  elseif ( $1 = botattrhubs ) { 
    if ( $istok(Donald AndersAnd KalleAnka,$nick,32) ) { botattr tassen $2 }

    if ( $istok(ole dole doffen,$nick,32) ) { botattr donald $2 }
    if ( $istok(Rip Rap Rup,$nick,32) ) { botattr AndersAnd  $2 }
    if ( $istok(Knatte Tjatte Fnatte,$nick,32) ) { botattr KalleAnka $2 }
  } 
  else { echo 9 -a /egg <leaf\hub> }
}
