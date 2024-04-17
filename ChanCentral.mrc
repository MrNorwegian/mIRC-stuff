dialog nx.dialog.cc {
  title "Channel central"
  size -1 -1 735 594
  option pixels
  tab "Channel modes", 100, 4 4 723 588
  box "General information", 105, 10 31 703 165, tab 100
  text "Active channel", 110, 20 50 82 14, tab 100
  edit "", 111, 150 50 264 22, tab 100 read autohs
  text "Active server/network", 112, 20 75 116 14, tab 100
  edit "", 113, 150 75 264 22, tab 100 read autohs
  text "Current modes", 117, 20 125 82 14, tab 100
  edit "", 118, 150 125 189 22, tab 100 read autohs
  text "Available modes", 121, 20 150 86 14, tab 100
  edit "", 122, 150 150 264 22, tab 100 read autohs
  box "Unrealircd modes", 170, 240 200 220 363, tab 100
  check "&Limit to +l", 142, 20 220 70 18, tab 100
  edit "", 143, 100 220 70 20, tab 100 autohs limit 5
  check "&Key +k", 144, 20 240 60 18, tab 100
  edit "", 145, 100 240 100 20, tab 100 pass autohs limit 30
  check "&Only ops set topic +t", 146, 20 260 140 18, tab 100
  check "&No external messages +n", 148, 20 280 150 18, tab 100
  check "&Invite only +i", 150, 20 300 140 18, tab 100
  check "&Moderated +m", 152, 20 320 140 18, tab 100
  check "&Private +p", 154, 20 340 140 18, tab 100
  check "&Secret +s", 156, 20 360 140 18, tab 100
  check "&No CTCP +c", 162, 20 420 140 18, tab 100
  check "&No Colors +c", 164, 20 440 140 18, tab 100
  check "&Oper only +O", 174, 250 240 140 18, tab 100
  check "&No knock +K", 185, 250 440 140 18, tab 100
  check "&SSL only +z", 147, 250 260 140 18, tab 100
  check "&Link to +L", 172, 250 220 70 18, disable tab 100
  edit "Link to", 173, 340 220 100 20, disable tab 100 limit 200
  box "Default channel modes", 140, 11 200 220 363, tab 100
  check "&Delayed join +D", 160, 20 400 140 18, tab 100
  check "&AuthModerated +M", 177, 250 320 140 18, tab 100
  check "&Permanent +P", 189, 250 500 140 18, tab 100
  check "&Reg only +r (ircu)", 158, 20 380 140 18, tab 100
  check "&No Notices +N", 179, 250 360 140 18, tab 100
  text "Topic", 114, 20 100 82 14, tab 100
  edit "", 115, 150 100 264 22, tab 100 autohs
  text "Change modes", 119, 417 125 82 14, tab 100
  edit "", 120, 510 125 189 22, tab 100 autohs
  check "&Strip Colors +S", 176, 250 300 140 18, tab 100
  check "&Reg only +R", 175, 250 280 140 18, tab 100
  check "&Filter +G", 178, 250 340 140 18, tab 100
  check "&Flood Protection +f", 182, 250 400 140 18, disable tab 100
  check "&Flood Profile +F", 180, 250 380 140 18, disable tab 100
  check "&No Nickchanges +N", 184, 250 420 140 18, tab 100
  check "&No Invite +V", 186, 250 460 140 18, tab 100
  check "&No Kicks +Q", 188, 250 480 140 18, tab 100
  check "&History +H", 190, 250 520 140 18, disable tab 100
  check "&Is Secure +Z", 192, 250 540 140 18, tab 100
  tab "Bans", 200
  list 220, 11 33 455 292, tab 200 size
  text "Current/maximum bans:", 230, 11 329 122 14, tab 200
  text "unknown", 240, 173 329 290 14, tab 200 right
  text "", 21, 16 155 444 44, hide tab 200 center
  tab "Invites", 300
  list 320, 11 33 455 292, tab 300 size
  text "Current invites:", 315, 11 329 84 14, tab 300
  text "unknown", 325, 173 329 290 14, tab 300 right
  text "", 20, 16 155 444 44, hide tab 300 center
  tab "Excepts", 400
  list 410, 11 33 455 292, tab 400 size
  text "Current excepts:", 415, 11 329 88 14, tab 400
  text "unknown", 420, 173 329 290 14, tab 400 right
  text "", 22, 16 155 444 44, hide tab 400 center
  tab "X", 500
  tab "Statistics", 600
  list 610, 11 33 455 214, disable tab 600 size
  list 620, 11 249 455 93, disable tab 600 size
  button "&Ok", 101, 540 550 80 24, ok
  button "&Cancel", 102, 630 550 80 24, cancel
}


on 1:dialog:nx.dialog.cc:*:*: {
  if ( $devent = init ) { 
    set %nx.cc.dname $dname
    did -a $dname 111 %nx.cc.chan 
    did -a $dname 113 $server - $network
    did -a $dname 118 $chan(%nx.cc.chan).mode
    did -a $dname 115 $chan(%nx.cc.chan).topic
    did -a $dname 122 $chanmodes
    cc.refmodes 
  }
  elseif ($devent == edit) {
    if ($did == 115) { 
      if ( $did($dname,115) ) { 
        set %nx.cc.set.topic $did($dname,115)
      }
    }
    dialogecho
  }
  elseif ($devent == sclick) {
    if ($did = 101) {
      if ( %nx.cc.set.topic ) { topic %nx.cc.chan %nx.cc.set.topic }
      if ( %nx.cc.setmode ) { mode %nx.cc.chan %nx.cc.setmode }
      unset %nx.cc.set.topic %nx.cc.setmode %nx.cc.chan %nx.cc.ismode
    }
    if ( $nx.cc.chk.id($did) ) { 
      var %nx.cc.chk.mode $v1
      var %nx.cc.chk.id $did
      if ( $istok(t n i m p s r d C c,%nx.cc.chk.mode,32) = $true ) { 
        ; mode is set and checked
        if ( $istok(%nx.cc.ismode,%nx.cc.chk.mode,32) = $true ) && ( $did(%nx.cc.chk.id).state = 1 ) { set %nx.cc.setmode $remtok(%nx.cc.setmode,$+($chr(45),%nx.cc.chk.mode),32) }
        ; mode is set and unchecked
        elseif ( $istok(%nx.cc.ismode,%nx.cc.chk.mode,32) = $true ) && ( $did(%nx.cc.chk.id).state = 0 ) { set %nx.cc.setmode $addtok(%nx.cc.setmode,$+($chr(45),%nx.cc.chk.mode),32) }
        ; mode is not set and checked
        if ( $istok(%nx.cc.ismode,%nx.cc.chk.mode,32) = $false ) && ( $did(%nx.cc.chk.id).state = 1 ) { set %nx.cc.setmode $addtok(%nx.cc.setmode,$+($chr(43),%nx.cc.chk.mode),32) }
        ; mode is not set and unchecked
        elseif ( $istok(%nx.cc.ismode,%nx.cc.chk.mode,32) = $false ) && ( $did(%nx.cc.chk.id).state = 0 ) { set %nx.cc.setmode $remtok(%nx.cc.setmode,$+($chr(43),%nx.cc.chk.mode),32) }
      }
      dialogecho
    }
    else { dialogecho }
  }
  elseif ( $devent = active ) { dialogecho }
  elseif ( $devent = close ) { dialogecho | unset %nx.cc.chan %nx.cc.dname %nx.cc.set.topic %nx.cc.setmode %nx.cc.ismode %nx.cc.ismode.* %nx.cc.currmode }
  elseif ( $devent = mouse ) { return }
  else { dialogecho }
}

; //echo -a $chan($chan).mode
; ircu "+stnlk 123 key"

; ircu b,k,l,imnpstrDdRcCM
; unreal beI,fkL,lFH,cdimnprstzCDGKMNOPQRSTVZ
; ratbox eIb,k,l,imnpstS
alias cc.refmodes { 
  if ( $dialog(nx.dialog.cc) ) && ( %nx.cc.chan ischan ) {
    ; Using gettok to get only modes ( +stnlk 123 key )
    ; In this case +b isnot tested on ircu and everything else in unreal
    set %nx.cc.currmode $gettok($mid($chan(%nx.cc.chan).mode,2,$len($chanmodes)),1,32)
    var %nx.cc.i $len(%nx.cc.currmode)
    while (%nx.cc.i) { 
      ; %nx.cc.nm is nextmode to check
      var %nx.cc.nm $mid(%nx.cc.currmode,%nx.cc.i,1)
      ; check if a mode is set and mark it, also save it for later
      if ( $nx.cc.chk.id(%nx.cc.nm) ) { set %nx.cc.ismode $addtok(%nx.cc.ismode,%nx.cc.nm,32) | did -c %nx.cc.dname $nx.cc.chk.id(%nx.cc.nm) }
      elseif (l isincs %nx.cc.nm) {
        set %nx.cc.ismode.l $chan(%nx.cc.chan).limit
        did -c %nx.cc.dname %nx.cc.nm 
        did -ae %nx.cc.dname $calc(%nx.cc.nm +1) $chan(%nx.cc.chan).limit
      }
      elseif (k isincs %x) {
        set %nx.cc.ismode.k $chan(%nx.cc.chan).limit $chan(%nx.cc.chan).key
        did -c %nx.cc.dname %nx.cc.nm
        did -ae %nx.cc.dname $calc(%nx.cc.nm +1) $chan(%nx.cc.chan).key
      }
      else { halt }
      dec %nx.cc.i
    }
  }
}

alias cc {
  set %nx.cc.chan $iif($1 ischan,$1,$active)
  if ($status == connected) {
    if (%nx.cc.chan ischan) {
      if ($me ison %nx.cc.chan) { noop $dialog(nx.dialog.cc,nx.dialog.cc) }
      else { echo -at You are currently not in $1 $+ . }
    }
    else { echo -at This feature is only available on channels. }
  }
  else { echo -at You are not connected to the server. }
}

alias dialogecho { 
  if ( 1 = 2 ) {
    if ( $devent = edit ) { echo -at DIALOG $dname devent: $devent did: $did didtext: $did($dname,$did).text OR $did($dname,$did) }
    elseif ( $devent = sclick ) { echo -at DIALOG $dname devent: $devent did: $did = $nx.cc.chk.id($did) }
    elseif ( $devent = mouse ) { return }
    elseif ( $devent = init ) { echo -at DIALOG $dname devent: $devent $did }
    elseif ( $devent = close ) { echo -at DIALOG $dname devent: $devent }
    else { echo -at DIALOG $dname devent: $devent  }
  }
}

alias nx.cc.chk.id {
  if ( $1 == 101 ) { return SAVE }
  if ( $1 == 101 ) { return Cancel }

  if ( $1 isincs l ) { return 142 }
  if ( $1 == 142 ) { return l }
  if ( $1 isincs k ) { return 144 }
  if ( $1 == 144 ) { return k }
  if ( $1 isincs t ) { return 146 }
  if ( $1 == 146 ) { return t }
  if ( $1 isincs n ) { return 148 }
  if ( $1 == 148 ) { return n }
  if ( $1 isincs i ) { return 150 }
  if ( $1 == 150 ) { return i }
  if ( $1 isincs m ) { return 152 }
  if ( $1 == 152 ) { return m }
  if ( $1 isincs p ) { return 154 }
  if ( $1 == 154 ) { return p }
  if ( $1 isincs s ) { return 156 }
  if ( $1 == 156 ) { return s }
  if ( $1 isincs r ) { return 158 }
  if ( $1 == 158 ) { return r }
  if ( $1 isincs D ) { return 160 }
  if ( $1 == 160 ) { return D }
  if ( $1 isincs c ) { return 162 }
  if ( $1 == 162 ) { return c }
  if ( $1 isincs C ) { return 164 }
  if ( $1 == 164 ) { return C }
  if ( $1 isincs O ) { return 174 }
  if ( $1 == 174 ) { return O }
  if ( $1 isincs K ) { return 185 }
  if ( $1 == 185 ) { return K }
  if ( $1 isincs z ) { return 147 }
  if ( $1 == 147 ) { return z }
  if ( $1 isincs L ) { return 172 }
  if ( $1 == 172 ) { return L }
  if ( $1 isincs M ) { return 177 }
  if ( $1 == 177 ) { return M }
  if ( $1 isincs P ) { return 189 }
  if ( $1 == 189 ) { return P }
  if ( $1 isincs N ) { return 179 }
  if ( $1 == 179 ) { return N }
  if ( $1 isincs S ) { return 176 }
  if ( $1 == 176 ) { return S }
  if ( $1 isincs R ) { return 175 }
  if ( $1 == 175 ) { return R }
  if ( $1 isincs G ) { return 178 }
  if ( $1 == 178 ) { return G }
  if ( $1 isincs f ) { return 182 }
  if ( $1 == 182 ) { return f }
  if ( $1 isincs F ) { return 180 }
  if ( $1 == 180 ) { return F }
  if ( $1 isincs N ) { return 184 }
  if ( $1 == 184 ) { return N }
  if ( $1 isincs V ) { return 186 }
  if ( $1 == 186 ) { return V }
  if ( $1 isincs Q ) { return 188 }
  if ( $1 == 188 ) { return Q }
  if ( $1 isincs H ) { return 190 }
  if ( $1 == 190 ) { return H }
  if ( $1 isincs Z ) { return 192 }
  if ( $1 == 192 ) { return Z }
}

