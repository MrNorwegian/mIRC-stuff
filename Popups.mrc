; Idea
; Menu server
; Dialog: server type (cache from first login ??)
; Dialog: oper(+uworld\operserv),services,botnet(nicks)

menu Nicklist {
  Info:/uwho $1
  Whois:{ var %i $numtok($$1-,32) | while (%i) { nx.whois $gettok($$1-,%i,32) $gettok($$1-,%i,32) | dec %i } }
  Query:{ var %i $numtok($$1-,32) | while (%i) { query $gettok($$1-,%i,32) | dec %i } }
  -
  Control
  .Ignore:/ignore $$1 1
  .Unignore:/ignore -r $$1 1
  .-
  .$iif(q isin $nickmode,Owner):{ nx.massmode owner $chan $$1- }
  .$iif(q isin $nickmode,Owner):{ nx.massmode deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ nx.massmode admin $chan $$1- }
  .$iif(a isin $nickmode,Deadmin):{ nx.massmode deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ nx.massmode op $chan $$1- }
  .$iif(o isin $nickmode,Deop):{ nx.massmode deop $chan $$1- }
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
  ; TODO Check if $me has +og usermode
  IrcOP Control
  .$iif(q isin $nickmode,Owner):{ nx.massmode oper_owner $chan $$1- }
  .$iif(q isin $nickmode,Owner):{ nx.massmode oper_deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ nx.massmode oper_admin $chan $$1- }
  .$iif(a isin $nickmode,Deadmin):{ nx.massmode oper_deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ nx.massmode oper_op $chan $$1- }
  .$iif(o isin $nickmode,Deop):{ nx.massmode oper_deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ nx.massmode oper_halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ nx.massmode oper_dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ nx.massmode oper_voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ nx.massmode oper_devoice $chan $$1- }
  ; TODO Kill + Gline
  Botnet Control
  .Chattr:{ nx.botnet.control chattr $chan $$1- }
  .-
  .$iif(q isin $nickmode,Owner):{ nx.massmode botnet_owner $chan $$1- }
  .$iif(q isin $nickmode,Owner):{ nx.massmode botnet_deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ nx.massmode botnet_admin $chan $$1- }
  .$iif(a isin $nickmode,Deadmin):{ nx.massmode botnet_deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ nx.massmode botnet_op $chan $$1- }
  .$iif(o isin $nickmode,Deop):{ nx.massmode botnet_deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ nx.massmode botnet_halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ nx.massmode botnet_dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ nx.massmode botnet_voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ nx.massmode botnet_devoice $chan $$1- }
  .-
  .Kick:{ set %nx.masskick.reason $?"Reason or emtpy for default" | nx.masskick botnet_kick $chan $$1- }
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
