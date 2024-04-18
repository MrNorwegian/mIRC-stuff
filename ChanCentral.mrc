dialog nx.dialog.cc {
  title "Channel central"
  size -1 -1 702 609
  option pixels
  tab "Channel modes", 100, 4 4 693 603
  box "General information", 105, 10 31 679 165, tab 100
  text "Active channel", 110, 20 50 82 14, tab 100
  edit "", 111, 150 50 264 22, tab 100 read autohs
  text "Active server/network", 112, 20 75 116 14, tab 100
  edit "", 113, 150 75 264 22, tab 100 read autohs
  text "Current modes", 117, 20 125 82 14, tab 100
  edit "", 118, 150 125 189 22, tab 100 read autohs
  text "Available modes", 121, 20 150 86 14, tab 100
  edit "", 122, 150 150 264 22, tab 100 read autohs
  box "Other modes2", 180, 470 200 220 363, tab 100
  check "&Limit to +l", 142, 20 220 70 18, disable tab 100
  edit "", 143, 100 220 70 20, disable tab 100 autohs limit 5
  check "&Key +k", 144, 20 240 60 18, disable tab 100
  edit "", 145, 100 240 100 20, disable tab 100 pass autohs limit 30
  check "&Only ops set topic +t", 146, 20 260 140 18, disable tab 100
  check "&No external messages +n", 148, 20 280 150 18, disable tab 100
  check "&Invite only +i", 150, 20 300 140 18, disable tab 100
  check "&Moderated +m", 152, 20 320 140 18, disable tab 100
  check "&Private +p", 154, 20 340 140 18, disable tab 100
  check "&Secret +s", 156, 20 360 140 18, disable tab 100
  check "&No CTCP +C", 185, 480 300 140 18, disable tab 100
  check "&No Colors +c", 186, 480 320 140 18, disable tab 100
  check "&Oper only +O", 163, 250 240 140 18, disable tab 100
  check "&No knock +K", 176, 250 440 140 18, disable tab 100
  check "&SSL only +z", 164, 250 260 140 18, disable tab 100
  check "&Link to +L", 161, 250 220 70 18, disable tab 100
  edit "", 162, 345 220 100 20, disable tab 100 limit 200
  box "Default channel modes", 140, 10 200 220 363, tab 100
  check "&Delayed join +D", 184, 480 280 140 18, disable tab 100
  check "&AuthModerated +M", 188, 480 360 140 18, disable tab 100
  check "&Permanent +P", 179, 250 500 140 18, disable tab 100
  check "&Reg only +r (ircu)", 182, 480 240 140 18, disable tab 100
  check "&No Notices +N", 187, 480 340 140 18, disable tab 100
  text "Topic", 114, 20 100 82 14, tab 100
  edit "", 115, 150 100 264 22, tab 100 autohs
  text "Change modes", 119, 417 125 82 14, tab 100
  edit "", 120, 510 125 165 22, tab 100 autohs
  check "&Strip Colors +S", 166, 250 300 140 18, disable tab 100
  check "&Reg only +R", 165, 250 280 140 18, disable tab 100
  check "&Filter +G", 168, 250 340 140 18, disable tab 100
  check "&Flood Prot +f", 173, 250 400 90 18, disable tab 100
  check "&Flood Prof +F", 171, 250 380 90 18, disable tab 100
  check "&No Nickchanges +N", 175, 250 420 140 18, disable tab 100
  check "&No Invite +V", 177, 250 460 140 18, disable tab 100
  check "&No Kicks +Q", 178, 250 480 140 18, disable tab 100
  check "&History +H", 169, 250 360 90 18, disable tab 100
  check "&Is Secure +Z", 167, 250 320 140 18, disable tab 100
  check "&No Part msg +P ((ircu)", 181, 480 220 140 18, disable tab 100
  check "&ModeU +u (snircd)", 183, 480 260 140 18, disable tab 100
  box "Other modes", 160, 240 200 220 363, tab 100
  edit "", 170, 345 360 100 20, disable tab 100 limit 200
  button "Apply", 103, 420 570 80 24, tab 100
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
  button "&Ok", 101, 510 570 80 24, ok
  button "&Cancel", 102, 600 570 80 24, cancel
  edit "", 172, 345 379 100 20, disable limit 200
  edit "", 174, 345 398 100 20, disable limit 200
  check "&ModeT +T (snircd)", 189, 480 380 140 18, disable
}
on 1:dialog:nx.dialog.cc:*:*: {
  if ( $devent = init ) { 
    set %nx.cc.dname $dname
    did -a $dname 111 %nx.cc.chan 
    ; ascii for paranthesis
    did -a $dname 113 $server $+($chr(40),$serverip,$chr(41)) - $network
    did -a $dname 118 $chan(%nx.cc.chan).mode
    did -a $dname 115 $chan(%nx.cc.chan).topic
    did -a $dname 122 $chanmodes
    cc.refmodes 
  }
  elseif ($devent == edit) {
    if ($did == 115) && ( $did($dname,115) ) { set %nx.cc.editbox.settopic $did($dname,115) }
    if ($did == 120) { 
      if ( $did($dname,120) ) { set %nx.cc.editbox.setmode $did($dname,120) }
      else { set %nx.cc.editbox.setmode TopicNotSet } 
    }
    dialogecho
  }
  elseif ($devent == sclick) {
    if ($did = 101) || ($did = 103) { 
      if ( %nx.cc.editbox.settopic ) && ( %nx.cc.editbox.settopic != $chan(%nx.cc.chan).topic ) { topic %nx.cc.chan $iif(%nx.cc.editbox.settopic = TopicNotSet,A,%nx.cc.editbox.settopic) }
      if ( %nx.cc.setmode ) { mode %nx.cc.chan %nx.cc.setmode }
      if ( %nx.cc.editbox.setmode ) { mode %nx.cc.chan %nx.cc.editbox.setmode }
    }
    elseif ( $nx.cc.chk.id($did) ) { 
      set %nx.cc.chk.mode $v1
      var %nx.cc.chk.id $did
      if ( $istok(t n i m p s r D C c M N P u T Q V K G Z S O z,%nx.cc.chk.mode,32) = $true ) { 
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
  }
  elseif ( $devent = active ) { dialogecho }
  elseif ( $devent = close ) { dialogecho | unset %nx.cc.* }
  elseif ( $devent = mouse ) { return }
  else { dialogecho }
}

; //echo -a $chan($chan).mode
; ircu "+stnlk 123 key"

; ircu   b,k,l,imnpstrDdRcCMP
; snircd b,k,l,imnpstrDducCNMT
; unreal beI,fkL,lFH,cdimnprstzCDGKMNOPQRSTVZ
; ratbox eIb,k,l,imnpstS
alias cc.refmodes { 
  if ( $dialog(nx.dialog.cc) ) && ( %nx.cc.chan ischan ) {
    ; Using gettok to get only modes ( +stnlk 123 key )
    ; In this case +b isnot tested on ircu and everything else in unreal
    set %nx.cc.chanmodes $gettok($chanmodes,-1,44)
    set %nx.cc.currmode $gettok($mid($chan(%nx.cc.chan).mode,2,$len(%nx.cc.chanmodes)),1,32)

    ; TODO if gettok except be,k,l (I also ? invites)
    ; var %nx.cc.c1 beI (except be, bans and excepts are tested another alias)
    ; var %nx.cc.c2 fkL (except k, key are tested another alias)
    ; var %nx.cc.c3 lFH (except l, limit are tested another alias)

    var %nx.cc.cm tniklmps
    var %nx.cc.cmircu rDcCPM
    var %nx.cc.cmsnircd rDucCNMT
    var %nx.cc.cmunreal LOzRSGFfNKVQHZP
    var %nx.cc.cmratbox S

    ; Loop thru common chanmodes
    var %nx.cc.cmlen $len(%nx.cc.cm)
    while (%nx.cc.cmlen) {
      var %nx.cc.cmid $nx.cc.chk.id($mid(%nx.cc.cm,%nx.cc.cmlen,1))
      if ( $mid(%nx.cc.cm,%nx.cc.cmlen,1) isincs %nx.cc.chanmodes ) { 
        did -e %nx.cc.dname %nx.cc.cmid
        if ( $mid(%nx.cc.cm,%nx.cc.cmlen,1) isincs %nx.cc.currmode ) { set %nx.cc.ismode $addtok(%nx.cc.ismode,$mid(%nx.cc.cm,%nx.cc.cmlen,1),32) | did -c %nx.cc.dname %nx.cc.cmid }
      }
      dec %nx.cc.cmlen
    }
    ; Loop thru ircu2 chanmodes
    if ( $istok($nx.db(read,settings,ircd,ircu2),$network,32) ) { set %nx.cc.sv ircu2 | set %nx.cc.ircd %nx.cc.cmircu }
    if ( $istok($nx.db(read,settings,ircd,snircd),$network,32) ) { set %nx.cc.sv snircd | set %nx.cc.ircd %nx.cc.cmsnircd }
    if ( $istok($nx.db(read,settings,ircd,unreal),$network,32) ) { set %nx.cc.sv unreal | set %nx.cc.ircd %nx.cc.cmunreal }

    var %nx.cc.cmlen $len(%nx.cc.ircd)
    while (%nx.cc.cmlen) {
      if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) isincs %nx.cc.chanmodes ) { 
        var %nx.cc.cmid $nx.cc.chk.id($mid(%nx.cc.ircd,%nx.cc.cmlen,1))
        did -e %nx.cc.dname %nx.cc.cmid
        if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) isincs %nx.cc.currmode ) { set %nx.cc.ismode $addtok(%nx.cc.ismode,$mid(%nx.cc.ircd,%nx.cc.cmlen,1),32) | did -c %nx.cc.dname %nx.cc.cmid }
      }
      dec %nx.cc.cmlen
    }
  }
}

alias nx.cc {
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

; Move this to .ini file ?
alias nx.cc.chk.id {
  if ( $1 == 101 ) { return SAVE }
  if ( $1 == 102 ) { return Cancel }
  if ( $1 == 103 ) { return Apply }

  if ( $1 === l ) { return 142 }
  if ( $1 == 142 ) { return l }
  if ( $1 === k ) { return 144 }
  if ( $1 == 144 ) { return k }
  if ( $1 === t ) { return 146 }
  if ( $1 == 146 ) { return t }
  if ( $1 === n ) { return 148 }
  if ( $1 == 148 ) { return n }
  if ( $1 === i ) { return 150 }
  if ( $1 == 150 ) { return i }
  if ( $1 === m ) { return 152 }
  if ( $1 == 152 ) { return m }
  if ( $1 === p ) { return 154 }
  if ( $1 == 154 ) { return p }
  if ( $1 === s ) { return 156 }
  if ( $1 == 156 ) { return s }

  if ( $1 === L ) { return 161 }
  if ( $1 == 161 ) { return L }
  if ( $1 === O ) { return 163 }
  if ( $1 == 163 ) { return O }
  if ( $1 === z ) { return 164 }
  if ( $1 == 164 ) { return z }
  if ( $1 === R ) { return 165 }
  if ( $1 == 165 ) { return R }
  if ( $1 === S ) { return 166 }
  if ( $1 == 166 ) { return S }
  if ( $1 === Z ) { return 167 }
  if ( $1 == 167 ) { return Z }
  if ( $1 === G ) { return 168 }
  if ( $1 == 168 ) { return G }
  if ( $1 === H ) { return 169 }
  if ( $1 == 169 ) { return H }
  if ( $1 === F ) { return 171 }
  if ( $1 == 171 ) { return F }
  if ( $1 === f ) { return 173 }
  if ( $1 == 173 ) { return f }
  if ( $1 === N ) && ( %nx.cc.sv = unreal ) { return 175 }
  if ( $1 == 175 ) { return N }
  if ( $1 === K ) { return 176 }
  if ( $1 == 176 ) { return K }
  if ( $1 === V ) { return 177 }
  if ( $1 == 177 ) { return V }
  if ( $1 === Q ) { return 178 }
  if ( $1 == 178 ) { return Q }
  if ( $1 === P ) && ( %nx.cc.sv = unreal ) { return 179 }
  if ( $1 == 179 ) { return P }

  if ( $1 === P ) && ( %nx.cc.sv = ircu2 ) { return 181 }
  if ( $1 == 181 ) { return P }
  if ( $1 === r ) { return 182 }
  if ( $1 == 182 ) { return r }
  if ( $1 === u ) { return 183 }
  if ( $1 == 183 ) { return u }
  if ( $1 === D ) { return 184 }
  if ( $1 == 184 ) { return D }
  if ( $1 === C ) { return 185 }
  if ( $1 == 185 ) { return C }
  if ( $1 === c ) { return 186 }
  if ( $1 == 186 ) { return c }
  if ( $1 === N ) && ( %nx.cc.sv = snircd ) { return 187 }
  if ( $1 == 187 ) { return N }
  if ( $1 === M ) { return 188 }
  if ( $1 == 188 ) { return M }
  if ( $1 === T ) { return 189 }
  if ( $1 == 189 ) { return T }
}
