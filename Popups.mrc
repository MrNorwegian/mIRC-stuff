; Idea
; Menu server
; Dialog: server type (cache from first login ??)
; Dialog: oper(+uworld\operserv),services,botnet(nicks)
menu Query {
  Info:/uwho $$1
  Whois:/nx.whois $1 $1
  Query:/query $$1
  -
  Ignore:/ignore $$1 1 | /closemsg $$1
  -
  CTCP
  .Ping:/nx.ctcp $$1 ping
  .Time:/nx.ctcp $$1 time
  .Version:/nx.ctcp $$1 version
  DCC
  .Send:/dcc send $$1
  .Chat:/dcc chat $$1
  -
  Close:/closemsg $$1
}

Menu Channel {
  Channel Modes:/channel
  NX Channel Central:/nx.cc $chan
  -
  Mass
  .voice:{ massv2 $chan voice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0)) }
  .devoice:{ massv2 $chan devoice $iif($?"Enter a number nothing for all" > 0,$v1,$nick($chan,0)) }
  -
  ; TODO clearmode (with botnet or ircop + uworld\operserv?)
  -
  Rejoin:/hop $1
  Part:/part $chan
  DuckHunt
  .1 Extra bullet(7xp):{ say !shop 1 }
  .2 Extra clip (20 xp):{ say !shop 2 }
  .3 AP ammo (15 xp):{ say !shop 3 }
  .4 Explosive ammo (25 xp):{ say !shop 4 }
  .5 Repurchase confiscated gun (40 xp) :{ say !shop 5 }
  .6 Grease (8 xp) :{ say !shop 6 }
  .7 Sight (6 xp) :{ say !shop 7 }
  .8 Infrared detector (15 xp):{ say !shop 8 }
  .9 Silencer (5 xp):{ say !shop 9 }
  .10 Four-leaf clover (13 xp) :{ say !shop 10 }
  .11 Sunglasses (5 xp):{ say !shop 11 }
  .12 Spare clothes (7 xp):{ say !shop 12 }
  .13 Brush for gun (7 xp) :{ say !shop 13 }
  .14 Mirror (7 xp):{ say !shop 14 }
  .15 Handful of sand (7 xp):{ say !shop 15 }
  .16 Water bucket (10 xp):{ say !shop 16 }
  .17 Sabotage (14 xp):{ say !shop 17 }
  .18 Life insurance (10 xp):{ say !shop 18 }
  .19 Liability insurance (5 xp):{ say !shop 19 }
  .20 Decoy (8 xp):{ say !shop 20 }
  .21 Piece of bread (2 xp) :{ say !shop 21 }
  .22 Ducks detector (5 xp):{ say !shop 22 }
  .23 Mechanical duck (50 xp):{ say !shop 23 }
  .ShowDucks:{ echo -a Ducks: %nx_duck_ducks }

  ZNC
  .EnableChan $chan :/msg *status EnableChan $chan
  .DisableChan $chan :/msg *status DisableChan $chan
  .Topics - Show topics in all your channels:{ set -u1 %nx.znc.popupcmd true | msg *status Topics }
  .Buffer
  ..ClearAllQueryBuffers      - Clear the query buffers:/msg *status ClearAllQueryBuffers 
  ..ClearAllChannelBuffers    - Clear the channel buffers :/msg *status ClearAllChannelBuffers 
  ..-
  ..ClearBuffer <#chan|query> - Clear the specified buffer:/msg *status ClearBuffer $$?="<#chan|query>"
  ..ClearBuffer $active       - Clear the specified buffer of $active:/msg *status ClearBuffer $active
  ..-
  ..PlayBuffer <#chan|query>  - Play back the specified buffer :/msg *status PlayBuffer $$?="<#chan|query>"
  ..PlayBuffer $active        - Play back the specified buffer of $active :/msg *status PlayBuffer $active
  ..-
  ..SetBuffer <#chan|query> [linecount] - Set the buffer count :/msg *status SetBuffer $$?="<#chan|query> [linecount]"
  ..SetBuffer $active [linecount] - Set the buffer count of $active:/msg *status SetBuffer $active $$?="[linecount]"
}
menu Status {
  Lusers:/lusers
  Stats
  .Operline:{ stats o }
  .Connectline:{ stats c }
  .Features:{ stats f }
  .Uptime:{ stats u }
  .Vservers:{ /stats v }
  - 
  Connect:/server $$?="Server IP\Host"
  New Server:/server -m $$?="Server IP\Host"
  Reconnect:/server $serverip
  Disconnect:/disconnect
  Quit:/quit $$?="Reason"
  -
  Oper
  .Oper:{ oper $$?="Username" $$?="Password" }
  .Add Opernet:{ nx.db write settings opernet $network Yes | nx.echo.setting Added $network as opernet }
  .Del Opernet:{ nx.db rem settings opernet $network | nx.echo.setting Removed $network as opernet }
  -
  Custom Windows
  .Debug:{ debug -nptN $+(@,$network,_,$cid,_,debug) }
  .DebugOff:{ debug -c off }
  .-
  .Raw:{ set %debug_raw_ $+ $cid 1 | window -e $+(@,$network,_,$cid,_,raw) }
  .RawOff:{ unset %debug_raw_ $+ $cid 1 | close -@ $+(@,$network,_,$cid,_,raw) }
  .-
  .Snotice:{ window -e $+(@,$network,_,$cid,_,status) }
  -
  Settings
  .Set nick:{ var %n $$?="Nick" | nx.db write settings mainnick $network %n | nx.echo.setting Nick set to %n }
  -
  ; IDEA, can this ZNC be cloned to menu query? and if used in Status make *status $active ?
  ZNC
  .Server\Network
  ..AddServer <host> [[+]port] [pass]:msg *status AddServer $$?="<host> [[+]port] [pass]"
  ..DelServer <host> [port] [pass]:msg *status DelServer $$?="<host> [port] [pass]"
  ..Connect:msg *status Connect
  ..Disconnect:msg *status Disconnect
  ..Jump:msg *status Jump
  ..-
  ..ListServers:{ set -u1 %nx.znc.popupcmd true | msg *status ListServers }
  ..-
  ..AddNetwork <name>:msg *status AddNetwork $$?="Name of new network?"
  ..DelNetwork <name>:msg *status DelNetwork $$?="Name of remove network?"
  ..JumpNetwork <network>:msg *status JumpNetwork $$?="Jump to another network (Alternatively, you can connect to ZNC several times, using `user/network` as username)"
  ..-
  ..ListNetworks:{ set -u1 %nx.znc.popupcmd true | msg *status ListNetworks }
  .-
  .Mods - (Admin)
  .Mods - (User)
  .ListAllUserNetworks - (Admin):{ set -u1 %nx.znc.popupcmd true | msg *status ListAllUserNetworks }
  .Traffic:{ set -u1 %nx.znc.popupcmd true | msg *status Traffic }
  .Uptime:{ set -u1 %nx.znc.popupcmd true | msg *status Uptime }
  .SaveConfig - (Admin):{ set -u1 %nx.znc.popupcmd true | msg *status SaveConfig }
  .Rehash - (Admin) Reloads znc.conf:{ set -u1 %nx.znc.popupcmd true | msg *status Rehash }
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
  .Remove all modes: { nx.masmode.deall user $chan $$1- }
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
  .-
  .Remove all modes: { nx.masmode.deall oper $chan $$1- }
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
  .Remove all modes: { nx.masmode.deall botnet $chan $$1- }

  .Kick:{ set %nx.masskick.reason $?"Reason or emtpy for default" | nx.masskick botnet_kick $chan $$1- }
  .-
  .Chattr:{ nx.botnet.control chattr $chan $$1- }
  .RegisterNickServ:{ nx.botnet.control registerns $$?="password?" $$1- }
  .Chanset:{ nx.botnet.control chanset $$?="#Chan\*" $$?="OPT" $$1- }
  .-
  .Say:{ nx.botnet.control say $$?="Channel?" $$1- }
  .Join:{ nx.botnet.control join $$?="Channel?" $$1- }
  .Part:{ nx.botnet.control part $$?="Channel?" $$1- }
  ; TODO Kick + ban
  .-
  .Hello:{ nx.botnet.control hello $$1- }
  .Rehash:{ nx.botnet.control rehash $$1- }
  .Jump:{ nx.botnet.control jump $$1- }
  .Restart\die
  ..Restart:{ nx.botnet.control restart $$1- }
  ..Die:{ nx.botnet.control die $$1- }
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
