menu Nicklist {
  Info:/uwho $1
  Whois:/whois $$1 $1
  Query:/query $$1
  -
  Control
  .Ignore:/ignore $$1 1
  .Unignore:/ignore -r $$1 1
  .Op:{ massmode op $chan $$1- }
  .Deop:{ massmode deop $chan $$1- }
  .Voice:{ massmode voice $chan $$1- }
  .Devoice:{ massmode devoice $chan $$1- }
  IrcOP-Controll
  .Op:{ massmode oper_op $chan $$1- }
  .Deop:{ massmode oper_deop $chan $$1- }
  .Voice:{ massmode oper_voice $chan $$1- }
  .Devoice:{ massmode oper_devoice $chan $$1- }
  Botnet Control
  .Chattr:{ nx.botnet.control chattr $chan $$1- }
  .-
  .Op:{ massmode botnet_op $chan $$1- }
  .Deop:{ massmode botnet_deop $chan $$1- }
  .Voice:{ massmode botnet_voice $chan $$1- }
  .Devoice:{ massmode botnet_devoice $chan $$1- }
  .-
  .Say:{ nx.botnet.control say $$?="Channel?" $$1- }
  .Join:{ nx.botnet.control join $$?="Channel?" $$1- }
  .Part:{ nx.botnet.control part $$?="Channel?" $$1- }
  CTCP
  .Ping:/ctcp $$1 ping
  .Time:/ctcp $$1 time
  .Version:/ctcp $$1 version
  .Chat:{
    var %i $numtok($$1-,32)
    while (%i) { ctcp $gettok($$1-,%i,32) chat | dec %i }
  }
  DCC
  .Send:/dcc send $$1
  .Chat:/dcc chat $$1
  -
  Slap!:/me slaps $$1 around a bit with a large trout
}
