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
  Botnet Control
  .Op:{ massmode botnetop $chan $$1- }
  .Deop:{ massmode botnetdeop $chan $$1- }
  .Voice:{ massmode botnetvoice $chan $$1- }
  .Devoice:{ massmode botnetdevoice $chan $$1- }
  .say:{ nx.botnet.control say $$?="Channel?" $$1- }
  .join:{ nx.botnet.control join $$?="Channel?" $$1- }
  .part:{ nx.botnet.control part $$?="Channel?" $$1- }
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
