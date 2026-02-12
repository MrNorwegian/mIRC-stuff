raw *:*:{
  if ($eval(% $+ debug_raw_ $+ $cid,2)) { echo -t $+(@,$network,_,$cid,_,raw) Event: $event Text: $1- }
  if ($event = ack) { return }
  elseif ($event = cap) { return }

  ; batch +eJ2YePPoPApi8e95KGaJfU chathistory #opers ; batch -eJ2YePPoPApi8e95KGaJfU
  elseif ($event = batch) { return }

  elseif ($event = chghost) { return }
  elseif ($event = account) { return }
  elseif ($event = tagmsg) { return }
  elseif ($event = away) { return }

  ; Welcome to the SERVER DESC, NICK
  elseif ($event = 001) { 
    if ( $hget(settings_,$+ $cid) = $null ) {
      hmake settings_ $+ $cid 100  
    }
    return
  }
  ; Your host is SERVERNAME, running version SERVERVERSION
  elseif ($event = 002) { 
    hadd -m settings_ $+ $cid serverversion $8
    if ( $6-7 = running version ) { 
      if ( UnrealIRCd isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,unreal),$network,32) ) && ( $istok($nx.db(read,settings,ircd,samode),$network,32) ) { return }
        else { nx.db write settings ircd unreal $addtok($nx.db(read,settings,ircd,unreal),$network,32) | nx.db write settings ircd samode $addtok($nx.db(read,settings,ircd,samode),$network,32) | return }
      }
      elseif ( bahamut-2 isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,bahamut),$network,32) ) && ( $istok($nx.db(read,settings,ircd,samode),$network,32) ) { return }
        else { nx.db write settings ircd bahamut $addtok($nx.db(read,settings,ircd,bahamut),$network,32) | nx.db write settings ircd samode $addtok($nx.db(read,settings,ircd,samode),$network,32) | return }
      }
      elseif ( u2.10.12 isin $8 ) && ( Nefarious isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,nefarious),$network,32) ) && ( $istok($nx.db(read,settings,ircd,opmode),$network,32) ) { return }
        else { nx.db write settings ircd nefarious $addtok($nx.db(read,settings,ircd,nefarious),$network,32) | nx.db write settings ircd opmode $addtok($nx.db(read,settings,ircd,opmode),$network,32) | return }
      }
      elseif ( u2.10.12.10 isin $8 ) && ( snircd isin $8 )  { 
        hadd settings_ $+ $cid ircd u2.10.12.10 snircd
        hadd settings_ $+ $cid opmode true
        if ( $istok($nx.db(read,settings,ircd,snircd),$network,32) ) && ( $istok($nx.db(read,settings,ircd,opmode),$network,32) ) { return }
        else { nx.db write settings ircd snircd $addtok($nx.db(read,settings,ircd,snircd),$network,32) | nx.db write settings ircd opmode $addtok($nx.db(read,settings,ircd,opmode),$network,32) | return }
      }
      elseif ( $8 == u2.10.12.19 ) { 
        hadd settings_ $+ $cid ircd u2.10.12.19
        hadd settings_ $+ $cid opmode true
      }
      elseif ( u2.10.12 isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,ircu2),$network,32) ) && ( $istok($nx.db(read,settings,ircd,opmode),$network,32) ) { return }
        else { nx.db write settings ircd ircu2 $addtok($nx.db(read,settings,ircd,ircu2),$network,32) | nx.db write settings ircd opmode $addtok($nx.db(read,settings,ircd,opmode),$network,32) | return }
      }
      elseif ( ircd-ratbox-3 isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,ratbox),$network,32) ) { return }
        else { nx.db write settings ircd ratbox $addtok($nx.db(read,settings,ircd,ratbox),$network,32) | return }
      }
      elseif ( solanum-1.0-dev isin $8 ) { 
        if ( $istok($nx.db(read,settings,ircd,solanum),$network,32) ) { return }
        else { nx.db write settings ircd solanum $addtok($nx.db(read,settings,ircd,solanum),$network,32) | return }
      }
      ; TODO add bircd,InspIRCd-3,and others
      ; solanum (libera)
    }
    return
  }

  ; Server created - Server info 
  elseif ($event = 003) { return }
  ; name, version, usermodes, chanmodes
  elseif ($event = 004) { 
    ;hadd settings_ $+ $cid servername $2
    hadd settings_ $+ $cid usermodes $4
    ;hadd settings_ $+ $cid chanmodes $5
    return
  }
  ; disabled this, need to save this in hashtabls instead of variables
  elseif ($event = 005) { 
    ; ircu2:
    ; WHOX WALLCHOPS WALLVOICES USERIP CPRIVMSG CNOTICE SILENCE=25 MODES=6 MAXCHANNELS=50 MAXBANS=100 NICKLEN=12 are supported by this server
    ; MAXNICKLEN=15 TOPICLEN=160 AWAYLEN=160 KICKLEN=160 CHANNELLEN=200 MAXCHANNELLEN=200 CHANTYPES=#& PREFIX=(ov)@+ STATUSMSG=@+ CHANMODES=b,k,l,imnpstrDdRcCPM CASEMAPPING=rfc1459 NETWORK=MyNetwork are supported by this server

    ; solanum
    ; ACCOUNTEXTBAN=a FNC MONITOR=100 KNOCK ETRACE SAFELIST ELIST=CMNTU CALLERID=g WHOX CHANTYPES=# EXCEPTS INVEX are supported by this server
    ; CHANMODES=eIbq,k,flj,ACFLOPQTcgimnprstz CHANLIMIT=#:30 PREFIX=(ov)@+ MAXLIST=bqeI:300 MODES=4 NETWORK=EvilNET STATUSMSG=@+ CASEMAPPING=rfc1459 NICKLEN=15 MAXNICKLEN=31 CHANNELLEN=50 TOPICLEN=390 are supported by this server

    ; unrealircd
    ;ACCOUNTEXTBAN=account,a AWAYLEN=307 BOT=B CASEMAPPING=ascii CHANLIMIT=#:100 CHANMODES=beI,fkL,lFH,cdimnprstzCDGKMNOPQRSTVZ CHANNELLEN=32 CHANTYPES=# CHATHISTORY=50 CLIENTTAGDENY=*,-draft/typing,-typing,-draft/channel-context,-draft/reply DEAF=d ELIST=MNUCT are supported by this server
    ;EXCEPTS EXTBAN=~,acfijmnpqrtACFGOST INVEX KICKLEN=307 KNOCK MAP MAXLIST=b:60,e:60,I:60 MAXNICKLEN=30 MINNICKLEN=0 MODES=12 MONITOR=128 MSGREFTYPES=msgid,timestamp are supported by this server
    ;NAMELEN=50 NAMESX NETWORK=TundraIRC NICKLEN=30 PREFIX=(qaohv)~&@%+ QUITLEN=307 SAFELIST SILENCE=15 STATUSMSG=~&@%+ TARGMAX=DCCALLOW:,ISON:,JOIN:,KICK:4,KILL:,LIST:,NAMES:1,NOTICE:1,PART:,PRIVMSG:4,SAJOIN:,SAPART:,TAGMSG:1,USERHOST:,USERIP:,WATCH:,WHOIS:1,WHOWAS:1 TOPICLEN=360 UHNAMES are supported by this server
    ;USERIP WALLCHOPS WATCH=128 WATCHOPTS=A WHOX are supported by this server

    if ($gettok($wildtok($1-,WHOX,1,32),2,61)) { hadd settings_ $+ $cid whox $gettok($wildtok($1-,WHOX,1,32),2,61) }
    if ($gettok($wildtok($1-,INVEX,1,32),2,61)) { hadd settings_ $+ $cid whox $gettok($wildtok($1-,INVEX,1,32),2,61) }

    if ($gettok($wildtok($1-,MAXNICKLEN=?*,1,32),2,61)) { hadd settings_ $+ $cid nicklen $gettok($wildtok($1-,MAXNICKLEN=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,TOPICLEN=?*,1,32),2,61)) { hadd settings_ $+ $cid topiclen $gettok($wildtok($1-,TOPICLEN=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,AWAYLEN=?*,1,32),2,61)) { hadd settings_ $+ $cid awaylen $gettok($wildtok($1-,AWAYLEN=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,KICKLEN=?*,1,32),2,61)) { hadd settings_ $+ $cid kicklen $gettok($wildtok($1-,KICKLEN=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,CHANNELLEN=?*,1,32),2,61)) { hadd settings_ $+ $cid channellen $gettok($wildtok($1-,CHANNELLEN=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,MAXCHANNELLEN=?*,1,32),2,61)) { hadd settings_ $+ $cid maxchannellen $gettok($wildtok($1-,MAXCHANNELLEN=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,CHANTYPES=?*,1,32),2,61)) { hadd settings_ $+ $cid chantypes $gettok($wildtok($1-,CHANTYPES=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,PREFIX=?*,1,32),2,61)) { hadd settings_ $+ $cid prefix $gettok($wildtok($1-,PREFIX=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,STATUSMSG=?*,1,32),2,61)) { hadd settings_ $+ $cid statusmsg $gettok($wildtok($1-,STATUSMSG=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,CHANMODES=?*,1,32),2,61)) { hadd settings_ $+ $cid chanmodes $gettok($wildtok($1-,CHANMODES=?*,1,32),2,61) }
    if ($gettok($wildtok($1-,SILENCE=?*,1,32),2,61)) { hadd settings_ $+ $cid silencelen $gettok($wildtok($1-,SILENCE=?*,1,32),2,61 ) }
    if ($gettok($wildtok($1-,MAXBANS=?*,1,32),2,61)) { hadd settings_ $+ $cid maxbans $gettok($wildtok($1-,MAXBANS=?*,1,32),2,61) }

    ; Unreal = MAXLIST=b:60,e:60,I:60
    ; Solanum =  MAXLIST=bqeI:300
    ;elseif ($gettok($gettok($gettok($wildtok($1-,MAXLIST=?*,1,32),2,61),1,44),2,58)) { set %nx.maxbans. $+ $cid $v1 ;}
    return
  }

  ; /map return (unrealircd)
  ; /map sumary (last line in /map) (unrealircd)
  ; End of /map (unrealircd)
  elseif ($event = 006) { nx.echo.snotice $2- | halt }
  elseif ($event = 018) { nx.echo.snotice $2- | halt }
  elseif ($event = 007) { nx.echo.snotice $2- | halt }

  ; mynick +bcdfkoqsBOS Server notice mask
  elseif ($event = 008) { nx.echo.snotice $1- | halt }

  ; /map return (ircu)
  ; End of /map (ircu)
  elseif ($event = 015) { nx.echo.snotice $2- | halt } 
  elseif ($event = 017) { nx.echo.snotice $2- | halt } 

  ; Please wait while we process your connection.
  elseif ($event = 020) { return }

  ; nick IDnumber your unique ID
  elseif ($event = 042) { return }

  ; /trace return, "user Other nick[ident@host] ?Num?", end of trace
  elseif ($event = 200) { nx.echo.snotice $2- | halt }
  elseif ($event = 204) { nx.echo.snotice $2- | halt }
  elseif ($event = 205) { nx.echo.snotice $2- | halt }
  elseif ($event = 206) { nx.echo.snotice $2- | halt }
  elseif ($event = 209) { nx.echo.snotice $2- | halt }
  elseif ($event = 262) { nx.echo.snotice $2- | halt }

  ; /stats return
  elseif ($event = 210) { nx.echo.snotice $2- | halt }

  ; stats l
  elseif ($event = 211) { nx.echo.snotice $2- | halt }

  ; stats m
  elseif ($event = 212) { nx.echo.snotice $2- | halt }

  ; Stats c (ircu)
  elseif ($event = 213) { nx.echo.snotice $2- | halt }

  ; stats c (ircnet) (Remember this returns C and N lines)
  elseif ($event = 214) { nx.echo.snotice $2- | halt }

  ; stats i
  elseif ($event = 215) { nx.echo.snotice $2- | halt }

  ; Stats K
  elseif ($event = 216) { nx.echo.snotice $2- | halt }

  ; stats p
  elseif ($event = 217) { nx.echo.snotice $2- | halt }

  ; stats y
  elseif ($event = 218) { 
    
    ; [21:01:27] Event: 218 Text: naka Y 6003064 120 0 1000 800000.0 0.3 0.3 15 3/64
    if ( $hget(settings_ $+ $cid,serverversion) iswm 2.11.2p3+0PNv1.06 ) {
      if ( $2 == Y ) {
        var %class $+(Class:,$3)
        var %pingfreq $+(Ping:,$4)
        var %connfreq $+(Conn:,$5)
        var %maxlinks $+(MaxLink:,$6)
        var %maxsendq $+(MaxSendQ:,$7)
        var %lglimits $+(Limits:,$8,/,$9)
        var %currcon $+(Clients:,$10)
        var %maxcidr $iif($11,$+(CIDR:,$11),No CIDR)
        nx.echo.snotice %class %pingfreq %connfreq %maxlinks %maxsendq %lglimits %currcon %maxcidr
      }
    }
    else { nx.echo.snotice $2- }
  
    halt
  }

  ; End of /stats
  elseif ($event = 219) { nx.echo.snotice $2- | halt }

  ; $2 sets mode +i ( Not when connected to znc )
  elseif ($event = 221) { return }

  ; stats v
  elseif ($event = 236) { 
    if ($2 != Servername) && ( $istok($nx.db(read,settings,ircd,ircu2),$network,32) ) { 
      ; Servername             Uplink              Flags Hops Numeric Lag RTT   Up Down ? Clients/Max Proto LinkTS      Info
      ; chainless.deepnet.chat hub.eu.deepnet.chat --H-6 3    AC      2   60000 0  0    0 1 1023      P10   1749640691  shells.chat IRC Services
      nx.echo.snotice ( $6 $4 ) Servername: $+($chr(40),$2 $12,\,$13,$chr(41)) -> ( $+ $5 hops $+ ) Uplink: $3
      ; nx.echo.snotice Lag: $7
      ; nx.echo.snotice RTT: $8
      ; nx.echo.snotice Up \ Down: $9 \ $10
      ; nx.echo.snotice Proto: $14
      ; nx.echo.snotice LinkTS: $15
      ; nx.echo.snotice Info: $16-
    }
    halt
  }
  ; Stats f
  elseif ($event = 238) { nx.echo.snotice $2- | halt }

  ; Server up
  elseif ($event = 242) { nx.echo.snotice $2- | halt }

  ; stats o
  elseif ($event = 243) { nx.echo.snotice $2- | halt }

  ; Stats h
  elseif ($event = 244) { nx.echo.snotice $2- | halt }

  ; stats p (ircnet)
  elseif ($event = 246) { nx.echo.snotice $2- | halt }

  ; stats t
  elseif ($event = 249) { nx.echo.snotice $2- | halt }

  ; Permission denied
  elseif ($event = 481) { return }

  ; Higest connection count
  elseif ($event = 250) { return }

  ; serverinfo ( ircu)
  ; There are 1 users and 69 invisible on 3 servers
  ; 5 operator(s) online
  ; 2 unknown connection(s)
  ; 62 channels formed
  ; I have 65 clients and 2 servers
  elseif ($event = 251) { return }
  elseif ($event = 252) { return }
  elseif ($event = 253) { return }
  elseif ($event = 254) { return }
  elseif ($event = 255) { return }
  ; Current local  users: 65  Max: 93
  ; Current global users: 70  Max: 1540
  elseif ($event = 265) { return }
  elseif ($event = 266) { return }

  ; Server load is temporarily too heavy
  elseif ($event = 263) { return }

  ; Gline list
  elseif ($event = 280) { return }
  ; End of /gline list
  elseif ($event = 281) { return }



  ; external host
  elseif ($event = 302) { return }

  ; marked as away - no longer marked as away
  elseif ($event = 306) { return }
  elseif ($event = 305) { return }

  ; Channel mode is
  elseif ($event = 324) { return }

  ; Channel URL is 
  elseif ($event = 328) { return }

  ; Channel mode set timestap ????
  elseif ($event = 329) { return }

  ; WHOIS
  ; nick ident host * realname
  ; TODO, use %nx.echoquery.whois. $+ $cid $+ . $+ $nick
  ; replace -at with $window or something ? or a whole new echo line with elseif 
  ; %nx.mcz
  if ( %nx.whois.active ) {

    ; Start of whois
    if ( $gettok(%nx.whois.active,1,32) == manual ) { set -u10 %whois.window -at }
    elseif ( $gettok(%nx.whois.active,1,32) == multiple ) { set -u10 %whois.window -at }
    elseif ( $gettok(%nx.whois.active,1,32) == query ) { set -u10 %whois.window -t $gettok(%nx.whois.active,2,32) }
    else { set -u10 %whois.window -st }

    ; nick ident host * realname
    if ($event = 311) { echo %nx.echo.color %whois.window $chr(45) | echo %nx.echo.color %whois.window $2 is $+($3,@,$4-) }
    ; is identified for this nick
    elseif ($event = 307) { echo %nx.echo.color %whois.window $2 on $3- }
    ; away
    elseif ($event = 301) { echo %nx.echo.color %whois.window $2 is away: $3- }
    ; nick is using modes
    elseif ($event = 379) { echo %nx.echo.color %whois.window $2- }
    ; nick is connecting from
    elseif ($event = 378) { echo %nx.echo.color %whois.window $2- }
    ; whois nick is on channel
    ; TODO coloriing channels from good to bad
    elseif ($event = 319) { echo %nx.echo.color %whois.window $2 on $3- }
    ; whois nick using server
    elseif ($event = 312) { echo %nx.echo.color %whois.window $2 using $3- }
    ; Is connected via the webircgateway
    elseif ($event = 350) { echo %nx.echo.color %whois.window $1 $5- }
    ; nick is an IRC opetator
    elseif ($event = 313) { echo %nx.echo.color %whois.window $2- }
    ; nick is using Secure Connection
    elseif ($event = 671) { echo %nx.echo.color %whois.window $2- }
    ; logged in as
    elseif ($event = 330) { echo %nx.echo.color %whois.window $2 is logged in as $3 }
    ; is a bot on "network"
    elseif ($event = 335) { echo %nx.echo.color %whois.window $2- }
    ; is aviaible for help
    elseif ($event = 310) { echo %nx.echo.color %whois.window $2- }
    ; nick "landcode" is connecting from "land"
    elseif ($event = 344) { echo %nx.echo.color %whois.window $2- }
    ; nick is using ip with a reputation 
    elseif ($event = 320) { echo %nx.echo.color %whois.window $2- }
    ; nick is using a secure connection
    elseif ($event = 275) {  echo %nx.echo.color %whois.window $2- }
    ; nick has client certificate
    elseif ($event = 276) { echo %nx.echo.color %whois.window $2- }
    ; using host
    elseif ($event = 338) { echo %nx.echo.color %whois.window $2 is actually $3 $+($chr(91),$4,$chr(93)) }
    ; idle time
    elseif ($event = 317) { echo %nx.echo.color %whois.window $2 has been idle for $duration($3) and signed on $duration($calc($ctime - $4)) ago ( $date($4,HH:mm:ss dd-mmm yyyy) ) }
    ; End of whois list
    elseif ($event = 318) {
      echo %nx.echo.color %whois.window $2-
      echo %nx.echo.color %whois.window $chr(45)
      ; %nx.whois.active manual 3 means its whoising 3 nicks and we'll dec the value 
      if ( $gettok(%nx.whois.active,1,32) == multiple ) {
        set -u120 %nx.whois.active $gettok(%nx.whois.active,1,32) $calc($gettok(%nx.whois.active,2,32) - 1)
        ; is it the last one ?
        if ($gettok(%nx.whois.active,2,32) <= 0) {
          unset %nx.whois.active %whois.window
        }
      }
    }
    halt
  }
  ;  away ; This is also innside whois above
  elseif ($event = 301) { return }

  ; topline of /list "Channel Users Name"
  elseif ($event = 321) { return }

  ; /list - end of /list
  elseif ($event = 322) { return }
  elseif ($event = 323) { 
    if ( %checkforircop ) { echo 3 -at %checkforircop Finished scanning for Ircops. | unset %checkforircop }
    return
  }

  ; whowas + end of whowas
  elseif ($event = 314) { return }
  elseif ($event = 369) { return }

  ; no topic set 
  elseif ($event = 331) { return }

  ; topic and topic created
  elseif ($event = 332) { return }
  elseif ($event = 333) { return }

  ; /userip result
  elseif ($event = 340) { 
    ; Check if i'm supposed to gline user, else return userip as normal
    if ( %nx.ag. [ $+ [ $gettok($2,1,61) ] ] == 1 ) { echo -st <Auto Gline> $2, user joined bait-channel | .msg uworld forcegline $+(*@,$gettok($2,2,64)) 8d Auto glined, bye | halt }
    else { echo -at UserIP: $2- | halt }
  }

  ; invited to channel ( 341 $me invited-nick #channel )
  elseif ($event = 341) { echo -at $2 has been invited to $3 | halt }

  ; End of channel reop list (part of +R mode on ircnet)
  elseif ($event = 345) { return }

  ; invex list
  elseif ($event = 346) { return }
  ; end of invex list
  elseif ($event = 347) { return }

  ; except list
  elseif ($event = 348) { return }
  ; end of except list
  elseif ($event = 349) { return }

  ; server info (OS etc)
  ; RAW 351 <nick> <Server version 1.2.3>. <Servername> Fhn6OoErmM [uname -a ??]
  elseif ($event = 351) { return }

  ; /who $chan
  elseif ($event = 352) {
    if ( %checkforircop ) && ( $iif($chr(42) isin $7,true,false) = true ) { 
      echo 3 -at %checkforircop Ircop found: nick ( $6 )
      halt
    }
    ; mynick #channel ~ident host.no *.undernet.org nick H< 3 Realname
    ; check for delayed joins 
    if ( %checkfordelayed == $2 ) || ( %checkforvoicedelayed == $2 ) {
      if ( $iif($chr(60) isin $7,true,false) = true ) {
        ; echo 8 -at Delayed clinets in $2: $7 $6 $+($3,@,$4) 
        set %nx.delayed. [ $+ [ $cid ] ] [ $+ [ $2 ] ] $addtok(%nx.delayed. [ $+ [ $cid ] ] [ $+ [ $2 ] ],$6,32)
        halt
      }
      else { halt }
    }

    ; grepwho functionality
    if ( %nx.grepwho ) {
      ; server\chan
      var %arg1 $gettok(%nx.grepwho,1,32)
      ; searchstring
      var %arg2 $gettok(%nx.grepwho,2,32)
      
      if (( %arg1 == $server ) && ( $2 == $chr(42) ) || ( %arg1 == $2 )) {
        if ( %arg2 isin $2- ) {
          set %nx.grep.count $calc(%nx.grep.count + 1)
          if ( %nx.grepsetting == vcount ) || ( %nx.grepsetting == normal ) {
            ; color the matched word
            var %l $numtok($1-,32), %i 1
            var %t
            while (%i <= %l) {
              var %w $gettok($1-,%i,32)
              if ( %arg2 isin %w ) {
                var %t $addtok(%t,$+(43,$chr(32),%w,),32)
              }
              else { var %t $addtok(%t,%w,32) }
              inc %i
            }
            echo 14 -at [GREPWHO] %t
          }
          ; Dont color or output ( client asked with -c )
        }
      }
      halt
    }

    ; ial update stuff to be finished later
    if ( %nx.joined. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) || ( %nx.ialupdate. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) { 
      inc -u10 %nx.ialchanusers. $+ $cid $+ $2
      ; Check if nick is ircop and color it (for nicklist)
      if (* isin $7) {
        if (!$istok($hget(settings_ $+ $cid,opers),$6,32)) {
          hadd settings_ $+ $cid opers $addtok($hget(settings_ $+ $cid,opers),$6,32)
        }

        ; Loop all channels and mark the client as ircop in nicklist
        var %t = $comchan($6,0), %c = 1
        while (%c <= %t) {
          ; Here, echo "Nick just opered ???"
          cline -m 13 $comchan($6,%c) $6
          ; cnick $6 13
          inc %c    
        }
      }
      ; mynick #chanenel ~ident host server nick modes hop realname
      ; Checking for onjoin spammers
      if ( $left($3,1) == ~ ) && ( $remove($3,~) == $nick ) && ( *.users.undernet.org !iswm $4 ) && ( $9 == ... ) {
        echo 4 -st Possible spamuser detected in $2 - nick: $6 is $+($3,@,$4) realname: $10-
      }
      halt
    }
    else { return }
  }

  ; End of /who
  elseif ($event = 315) {
    if ( %nx.delayed. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) {
      if ( %checkfordelayed == $2 ) { echo 8 -at Delayed clients: %nx.delayed. [ $+ [ $cid ] ] [ $+ [ $2 ] ] }
      if ( %checkforvoicedelayed == $2 ) { nx.massmode voice $2 %nx.delayed. [ $+ [ $cid ] ] [ $+ [ $2 ] ] }
      unset %nx.delayed. [ $+ [ $cid ] ] [ $+ [ $2 ] ]
      unset %checkfordelayed %checkforvoicedelayed
      halt
    }
    if ( %nx.ialupdate. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) { 
      unset %nx.ialupdate. $+ $cid $+ $2
      halt
    }
    if ( %nx.grepwho ) {
      if ( %nx.grep.count ) { echo 14 -at [GREPWHO] Found %nx.grep.count matching client(s) from $gettok(%nx.grepwho,2,32) on $gettok(%nx.grepwho,1,32) $+ . }
      else { echo 14 -at [GREPWHO] No matching clients found from $gettok(%nx.grepwho,2,32) on $gettok(%nx.grepwho,1,32) $+ . }
      unset %nx.grepwho %nx.grep.count %nx.grepsetting
      halt
    }
    elseif ( %nx.joined. [ $+ [ $cid ] ] [ $+ [ $2 ] ] ) {
      echo 12 -st Updated IAL for $2 with %nx.ialchanusers. [ $+ [ $cid ] ] [ $+ [ $2 ] ] users.
      unset %nx.joined. $+ $cid $+ $2 | unset %nx.ialchanusers. $+ $cid $+ $2 
      halt
    }
    ; Manual /who request, do nothing for now
    return
  }

  ; /names list
  elseif ($event = 353) { return }

  ; end of /names
  elseif ($event = 354) { return }

  ; /names -d list ( ircu )
  elseif ($event = 355) { return }

  ; #chan End of /NAMES list
  elseif ($event = 366) { return }

  ; Ban list
  elseif ($event = 367) {
    if ($dialog(%nx.cc.dname)) && (%nx.cc.getbans == $2) {
      if (Refreshing bans ... iswm $did(%nx.cc.dname,$nx.cc.chk.id(Banlist),1)) { did -d %nx.cc.dname $nx.cc.chk.id(Banlist) 1 }
      did -a %nx.cc.dname $nx.cc.chk.id(Banlist) 0 + 0 0 0 $3 $+ 	+ 0 0 0 $4 $+ 	+ 0 0 0 $asctime($5,dd/mm/yyyy HH:nn)
      ; did -a %nx.cc.dname $nx.cc.chk.id(Banlist) $3 
      ; did -a %nx.cc.dname $nx.cc.chk.id(BanSetBy) $4
      ; did -a %nx.cc.dname $nx.cc.chk.id(BanSetDate) $asctime($5,dd/mm/yyyy HH:nn)
      return

    }
    return
  }
  ; End of banlist
  elseif ($event = 368) {
    if ($dialog(%nx.cc.dname)) && (%nx.cc.getbans == $2) {
      if ($did(%nx.cc.dname,$nx.cc.chk.id(Banlist)).lines == 1) && (Refreshing bans ... iswm $did(%nx.cc.dname,$nx.cc.chk.id(Banlist),1)) {
        did -ra %nx.cc.dname $nx.cc.chk.id(Banlist) No bans set.
        ; not using %nx.maxbans anymore, never worked right
        did -ra %nx.cc.dname $nx.cc.chk.id(numbans) 0/ $+ $iif(%nx.maxbans. [ $+ [ $cid ] ],$v1,unknown)
      }
      else { did -ra %nx.cc.dname $nx.cc.chk.id(numbans) $calc($did(%nx.cc.dname,$nx.cc.chk.id(Banlist)).lines -1) $+ / $+ $iif(%nx.maxbans. [ $+ [ $cid ] ],$v1,unknown) }
      unset %nx.cc.getbans
    }
    halt
  }

  ; /links list
  elseif ($event = 364) { 
    write links $+ $network $+ .db $2 $3

    return 
  }
  ; end of /links list
  elseif ($event = 365) { return }

  ; /info
  elseif ($event = 371) { return }
  elseif ($event = 374) { return }

  ; MOTD start - motd - end of motd
  elseif ($event = 375) { return }
  elseif ($event = 372) { return }
  elseif ($event = 376) { return }

  ; You are now an IRC operator
  elseif ($event = 381) { window -De $+(@,$network,_,$cid,_,status) | halt }

  ; ircd.conf Rehashing
  elseif ($event = 382) { nx.echo.snotice $1- | halt }

  ; is now your displayed host
  elseif ($event = 396) { return }

  ; no such nick ( $2 )
  elseif ($event = 401) { return }

  ; No such channel
  elseif ($event = 403) { return }

  ; Cannot send to channel
  elseif ($event = 404) { return }

  ; Unknown command
  elseif ($event = 421) { return }

  ; MOTD file missing
  elseif ($event = 422) { return }

  ; nickname is unavailable: illegal characters
  elseif ($event = 432) { return }

  ; Nickname is already in use
  ; TODO add a check if you are on dalnet with Guest* nick,  /msg NickServ@services.dal.net RELEASE $me password

  elseif ($event = 433) { 
    if ( $istok($nx.db(read,settings,services,Atheme),$network,32) ) {
      echo a $gettok($nx.db(read,settings,nickserv,$network),1,32) and $1
      if ( $gettok($nx.db(read,settings,nickserv,$network),1,32) = $2 ) {
        .msg nickserv ghost $2 $gettok($nx.db(read,settings,nickserv,$network),2,32)
      }
    }
  }
  ; 437 YourNICK #channel :Cannot change nickname while banned on channel or channel is moderated
  ; 437 #channel Nick/channel is temporarily unavailable ( From EFNet ) 
  elseif ($event = 437) { 
    if ( $3-6 == Nick/channel is temporarily unavailable ) { return }
    elseif ( $1 = $me ) && ( $1 != $nx.db(read,settings,mainnick,$network) ) && ( $left($1,1) = $chr(38) ) {

      ; TODO, count number of tries and delay part\rejoin if it fails too many times
      if ( $timer(_chnick) ) { .part $2 | .timer_rejoin_ $+ $2 1 10 .join $2 }
      else { .part $2 | .timer_chnick 1 1 .nick $nx.db(read,settings,mainnick,$network) | .timer_rejoin_ $+ $2 1 10 .join $2 }
    }
  }

  ; Target change too fast.
  elseif ($event = 439) { return }

  ; Nick #channel They aren't on that channel
  elseif ($event = 441) { return }

  ; You're not on that channel
  elseif ($event = 442) { return }

  ; nick is already on channel
  elseif ($event = 443) { return }

  ; Cannot join channel (+b)
  elseif ($event = 474) { return }

  ; nick register first
  elseif ($event = 451) { return }

  ; /admin return
  elseif ($event = 256) { return }
  elseif ($event = 257) { return }
  elseif ($event = 258) { return }
  elseif ($event = 259) { return }

  ; Not enough parameters
  elseif ($event = 461) { return }

  ; Glined
  elseif ($event = 465) { return }

  ; Channel key already set
  elseif ($event = 467) { return }

  ; unkonwn mode ( nick N is unknown mode char to me )
  elseif ($event = 472) { return }

  ; :Cannot join channel (+i) ( $2 = channel )
  ; TODO use %nx.loggedon or something before .msg 
  ; Todo, use settings to get the botname (uworld) because it can change
  elseif ( $event = 473 ) { if ( $istok($nx.db(read,settings,operchans,$network),$2,32)) { .timer_ai_ $+ $2 1 10 .msg euworld invite $2 $me } | return }

  ; invalid password
  elseif ($event = 464) { return }

  ; Only servers can change that mode
  elseif ($event = 468) { return }

  ; Cannot join channel transfering 
  elseif ($event = 470) { return }

  ; Cannot join channel ( +l )
  elseif ($event = 471) { return }

  ; Cannot join channel (+k)
  elseif ($event = 475) { 
    if ( $network == $gettok(%nx.secret.channel,1,32) ) && ( $1 == $gettok(%nx.secret.channel,2,32) ) { msg $gettok(%nx.secret.channel,3,32) invite $1 }
    return
  }

  ; You need a registered nick to join that channel.
  elseif ($event = 477) { return }

  ; You're not an channel operator
  elseif ($event = 482) { echo -at * $+($1,:) You're not channel operator | halt }

  ; No Operator block for your host
  elseif ($event = 491) { echo -at * $+($1,:) No Operator block for your host | halt }

  ; You're not a channel owner
  elseif ($event = 499) { echo -at * $+($1,:) You're not channel owner | halt }

  ; Unknown user MODE flag
  elseif ($event == 501) { return }
  ; Cannot join channel
  elseif ($event = 520) { return }

  ; You have 0 and are on 0 WATCH entries
  elseif ($event = 603) { return }

  ; nefarious ssl
  ; $me $me has client certificate fingerprint E95DC2020C6463088AAB47B38961B6E868F9C7C6B8D42201F1913A45BC1CA458
  elseif ($event = 616) { return }

  ; masktrace return (solanum)
  elseif ($event = 709) { return }

  ; MODE cannot be set due to channel having a active MLOCK restriction (thru chanserv)
  elseif ($event = 742) { return }

  ; You are now logged in as $2
  elseif ($event = 900) { return }

  ; K +i must be set (When setting +K)
  elseif ($event = 974) { return }

  else { nx.echo.raw $event $1- }
}
