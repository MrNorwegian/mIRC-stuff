; Idea
; Menu server
; Dialog: server type (cache from first login ??)
; Dialog: oper(+uworld\operserv),services,botnet(nicks)
menu Query {
  Info:/uwho $$1
  Whois:/whois $1 $1
  Query:/query $$1
  -
  Ignore:/ignore $$1 1 | /closemsg $$1
  -
  CTCP
  .Ping:/ctcp $$1 ping
  .Time:/ctcp $$1 time
  .Version:/ctcp $$1 version
  DCC
  .Send:/dcc send $$1
  .Chat:/dcc chat $$1
  -
  Close:/closemsg $$1
}
Menu Channel {
  Channel Modes:/channel
  -
  Mass
  .voice:{ massv2 $chan voice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0)) }
  .devoice:{ massv2 $chan devoice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0)) }
  -
  Update:{
    set -u2 %nx.ial.update true
    remini $+(ial\,$network,.ini) $chan
    names $chan
  }
  -
  Rejoin:/hop $1
  Part:/part $chan
}
menu Status {
  Lusers:/lusers
  Uptime:/stats u
  Stats
  .Operline:{ stats o }
  .Connectline:{ stats c }
  .Features:{ stats f }
  -
  Connect:/server $serverip
  Disconnect:/disconnect
  Reconnect:/server $serverip
  - 
  ; Oper:/oper $$1 $$?="Password"
  - 
  ; Services:/services
  ; Botnet:/botnet
  - 
  Quit:/quit $$?="Reason"
  -
  Debug:{ debug <@window> | window -e $+(@,$network,_,$cid,_,raw) | debug $+(@,$network,_,$cid,_,raw) }
  DebugOff:{ debug off }

}
menu Nicklist {
  Info:/uwho $1
  Whois:{ set %nx.echoactive.whois true | .timer_echoactive.whois 1 $numtok($1-,32) unset %nx.echoactive.whois | var %i $numtok($$1-,32) | while (%i) { nx.whois $gettok($$1-,%i,32) $gettok($$1-,%i,32) | dec %i } }
  Query:{ var %i $numtok($$1-,32) | while (%i) { query $gettok($$1-,%i,32) | dec %i } }
  -
  Control
  .Ignore:/ignore $$1 1
  .Unignore:/ignore -r $$1 1
  .-
  .$iif(q isin $nickmode,Owner):{ nx.massmode owner $chan $$1- }
  .$iif(q isin $nickmode,DeOwner):{ nx.massmode deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ nx.massmode admin $chan $$1- }
  .$iif(a isin $nickmode,DeAdmin):{ nx.massmode deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ nx.massmode op $chan $$1- }
  .$iif(o isin $nickmode,DeOp):{ nx.massmode deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ nx.massmode halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ nx.massmode dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ nx.massmode voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ nx.massmode devoice $chan $$1- }
  .-
  ; TODO Kick + ban
  .Kick:{ set %nx.masskick.reason $?"Reason or emtpy for default" | nx.masskick kick $chan $$1- }
  .Ban:{ nx.massban ban $chan $$1- }
  .Unban:{ nx.massban unban $chan $$1- }
  .KickBan:{ set %nx.masskick.reason $?"Reason or emtpy for default" | nx.massban ban $chan $$1- | nx.masskick kick $chan $$1- }
   $iif(o isin $usermode,IrcOP Control)
  .$iif(q isin $nickmode,Owner):{ nx.massmode oper_owner $chan $$1- }
  .$iif(q isin $nickmode,DeOwner):{ nx.massmode oper_deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ nx.massmode oper_admin $chan $$1- }
  .$iif(a isin $nickmode,DeAdmin):{ nx.massmode oper_deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ nx.massmode oper_op $chan $$1- }
  .$iif(o isin $nickmode,DeOp):{ nx.massmode oper_deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ nx.massmode oper_halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ nx.massmode oper_dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ nx.massmode oper_voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ nx.massmode oper_devoice $chan $$1- }
  ; TODO Kill + Gline
   $iif(%nx.botnet_ [ $+ [ $network ] ] ,Botnet Control)
  .$iif(q isin $nickmode,Owner):{ nx.massmode botnet_owner $chan $$1- }
  .$iif(q isin $nickmode,DeOwner):{ nx.massmode botnet_deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ nx.massmode botnet_admin $chan $$1- }
  .$iif(a isin $nickmode,DeAdmin):{ nx.massmode botnet_deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ nx.massmode botnet_op $chan $$1- }
  .$iif(o isin $nickmode,DeOp):{ nx.massmode botnet_deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ nx.massmode botnet_halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ nx.massmode botnet_dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ nx.massmode botnet_voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ nx.massmode botnet_devoice $chan $$1- }
  .-
  .Kick:{ set %nx.masskick.reason $?"Reason or emtpy for default" | nx.masskick botnet_kick $chan $$1- }
  .-
  .Chattr:{ nx.botnet.control chattr $chan $$1- }
  .-
  .Say:{ nx.botnet.control say $$?="Channel?" $$1- }
  .Join:{ nx.botnet.control join $$?="Channel?" $$1- }
  .Part:{ nx.botnet.control part $$?="Channel?" $$1- }
  ; TODO Kick + ban
  CTCP
  .Ping:{ var %i $numtok($$1-,32) | while (%i) { nx.ctcp $gettok($$1-,%i,32) ping | dec %i } }
  .Time:{ var %i $numtok($$1-,32) | while (%i) { nx.ctcp $gettok($$1-,%i,32) time | dec %i } }
  .Version:{ var %i $numtok($$1-,32) | while (%i) { nx.ctcp $gettok($$1-,%i,32) version | dec %i } }
  .Chat:{ var %i $numtok($$1-,32) | while (%i) { nx.ctcp $gettok($$1-,%i,32) chat | dec %i } }
  DCC
  .Send:/dcc send $$1
  .Chat:/dcc chat $$1
  -
  .Slap:{ var %i $numtok($$1-,32) | while (%i) { nx.me slaps $gettok($$1-,%i,32) around a bit with a large trout | dec %i } }
}
