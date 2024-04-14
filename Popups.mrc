; Idea
; Menu server
; Dialog: server type (cache from first login ??)
; Dialog: oper(+uworld\operserv),services,botnet(nicks)

menu Nicklist {
  Info:/uwho $1
  .Whois:{ var %i $numtok($$1-,32) | while (%i) { whois $gettok($$1-,%i,32) $gettok($$1-,%i,32) | dec %i } }
  .Query:{ var %i $numtok($$1-,32) | while (%i) { query $gettok($$1-,%i,32) | dec %i } }
  -
  Control
  .Ignore:/ignore $$1 1
  .Unignore:/ignore -r $$1 1
  .-
  .$iif(q isin $nickmode,Owner):{ massmode owner $chan $$1- }
  .$iif(q isin $nickmode,Owner):{ massmode deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ massmode admin $chan $$1- }
  .$iif(a isin $nickmode,Deadmin):{ massmode deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ massmode op $chan $$1- }
  .$iif(o isin $nickmode,Deop):{ massmode deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ massmode halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ massmode dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ massmode voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ massmode devoice $chan $$1- }
  .-
  ; TODO Kick + ban
  .Kick:{ massmode kick $chan $$1- }
  .Ban:{ massmode ban $chan $$1- }
  ; TODO Check if $me has +og usermode
  IrcOP-Control
  .$iif(q isin $nickmode,Owner):{ massmode oper_owner $chan $$1- }
  .$iif(q isin $nickmode,Owner):{ massmode oper_deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ massmode oper_admin $chan $$1- }
  .$iif(a isin $nickmode,Deadmin):{ massmode oper_deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ massmode oper_op $chan $$1- }
  .$iif(o isin $nickmode,Deop):{ massmode oper_deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ massmode oper_halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ massmode oper_dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ massmode oper_voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ massmode oper_devoice $chan $$1- }
  ; TODO Kill + Gline
  Botnet Control
  .Chattr:{ nx.botnet.control chattr $chan $$1- }
  .-
  .$iif(q isin $nickmode,Owner):{ massmode botnet_owner $chan $$1- }
  .$iif(q isin $nickmode,Owner):{ massmode botnet_deowner $chan $$1- }
  .$iif(a isin $nickmode,Admin):{ massmode botnet_admin $chan $$1- }
  .$iif(a isin $nickmode,Deadmin):{ massmode botnet_deadmin $chan $$1- }
  .$iif(o isin $nickmode,Op):{ massmode botnet_op $chan $$1- }
  .$iif(o isin $nickmode,Deop):{ massmode botnet_deop $chan $$1- }
  .$iif(h isin $nickmode,Halfop):{ massmode botnet_halfop $chan $$1- }
  .$iif(h isin $nickmode,Dehalfop):{ massmode botnet_dehalfop $chan $$1- }
  .$iif(v isin $nickmode,Voice):{ massmode botnet_voice $chan $$1- }
  .$iif(v isin $nickmode,Devoice):{ massmode botnet_devoice $chan $$1- }
    .-
  .Say:{ nx.botnet.control say $$?="Channel?" $$1- }
  .Join:{ nx.botnet.control join $$?="Channel?" $$1- }
  .Part:{ nx.botnet.control part $$?="Channel?" $$1- }
  ; TODO Kick + ban
  CTCP
  .Ping:{ var %i $numtok($$1-,32) | while (%i) { ctcp $gettok($$1-,%i,32) ping | dec %i } }
  .Time:{ var %i $numtok($$1-,32) | while (%i) { ctcp $gettok($$1-,%i,32) time | dec %i } }
  .Version:{ var %i $numtok($$1-,32) | while (%i) { ctcp $gettok($$1-,%i,32) version | dec %i } }
  .Chat:{ var %i $numtok($$1-,32) | while (%i) { ctcp $gettok($$1-,%i,32) chat | dec %i } }
  DCC
  .Send:/dcc send $$1
  .Chat:/dcc chat $$1
  -
  .Slap:{ var %i $numtok($$1-,32) | while (%i) { me slaps $gettok($$1-,%i,32) around a bit with a large trout | dec %i } }
}
