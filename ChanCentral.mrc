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
  check "&No notice +T (unreal)", 167, 250 320 140 18, disable tab 100
  check "&No Part msg +P ((ircu)", 181, 480 220 140 18, disable tab 100
  check "&No part\quit +u (snircd)", 183, 480 260 140 18, disable tab 100
  box "Other modes", 160, 240 200 220 363, tab 100
  edit "", 170, 345 360 100 20, disable tab 100 limit 200
  button "Apply", 103, 420 570 80 24, tab 100
  check "&Common ch only +Q (nefarious)", 192, 250 520 180 18, disable tab 100
  check "&SSL only +Z (nefarious)", 191, 480 400 140 18, disable tab 100
  check "&No multi msg +T (snircd)", 189, 480 380 140 18, disable tab 100
  edit "", 172, 345 379 100 20, disable tab 100 limit 200
  edit "", 174, 345 398 100 20, disable tab 100 limit 200
  tab "Bans", 300
  list 310, 10 33 674 442, tab 300 size
  text "Current/maximum bans:", 313, 11 480 122 14, tab 300
  text "unknown", 314, 131 479 83 14, tab 300 right
  tab "Invites", 350
  list 355, 10 33 455 292, tab 350 size
  text "Current invites:", 356, 11 329 122 14, tab 350
  text "unknown", 357, 173 329 290 14, tab 350 right
  tab "Excepts", 380
  list 410, 10 33 455 292, tab 380 size
  text "Current excepts:", 415, 11 329 122 14, tab 380
  text "unknown", 420, 173 329 290 14, tab 380 right
  tab "X", 400
  tab "Statistics", 1000
  list 610, 10 33 455 214, disable tab 1000 size
  list 620, 11 249 455 93, disable tab 1000 size
  button "&Ok", 101, 510 570 80 24, ok
  button "&Cancel", 102, 600 570 80 24, cancel
}

on 1:dialog:nx.dialog.cc:*:*: {
  if ( $devent = init ) { 
    set %nx.cc.dname $dname
    mdx SetMircVersion $version
    mdx MarkDialog $dname $dialog($dname).hwnd
    ; mdx SetControlMDX $dname 6 ListView report showsel rowselect labeltip editlabels > $mdxfile(views)
    did -i $dname $nx.cc.chk.id(Banlist) 1 headerdims 220:1 80:2 110:3
    did -i $dname $nx.cc.chk.id(Banlist) 1 headertext + 0 Address	+ 0 Set by	+ 0 Date
    did -i $dname $nx.cc.chk.id(Banlist) 1 settxt bgcolor none

    did -a $dname 111 %nx.cc.chan 
    did -a $dname 113 $server $+($chr(40),$serverip,$chr(41)) - $network
    did -a $dname 118 $chan(%nx.cc.chan).mode
    did -a $dname 115 $chan(%nx.cc.chan).topic
    did -a $dname 122 $chanmodes

    if ( $chanmodes ) { nx.cc.refmodes }
    if (b isincs $gettok($chanmodes,1,44)) { nx.cc.getbans }
    if (I isincs $gettok($chanmodes,1,44)) { nx.cc.getinvites }
    if (e isincs $gettok($chanmodes,1,44)) { nx.cc.getexcepts }
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
      if ( %nx.cc.setmode ) || ( %nx.cc.remmode ) { 
        var %nx.cc.sm $remove(%nx.cc.setmode,$chr(32)), %nx.cc.rm $remove(%nx.cc.remmode,$chr(32))
        var %i $len(%nx.cc.sm), %r $len(%nx.cc.rm)
        while (%i) {
          var %m $mid(%nx.cc.sm,%i,1)
          if ( %m isincs l ) { mode %nx.cc.chan $+($chr(43),%m) $did(%nx.cc.dname,$calc($nx.cc.chk.id(l) +1)) }
          elseif ( %m isincs k ) { mode %nx.cc.chan $+($chr(43),%m) $did(%nx.cc.dname,$calc($nx.cc.chk.id(k) +1)) }
          elseif ( %m isincs L ) { mode %nx.cc.chan $+($chr(43),%m) $did(%nx.cc.dname,$calc($nx.cc.chk.id(L) +1)) }

          ; TODO add +ffH for unrealircd
          else { var %tm $+(%m,%tm) }
          if ( $len(%tm) = $modespl ) { mode %nx.cc.chan $+($chr(43),%tm) | unset %tm }
          dec %i
        }
        if ( %tm ) && ( $modespl > $len(%tm) ) { set %tm $+($chr(43),%tm) }
        elseif (%tm) { mode %nx.cc.chan $+($chr(43),%tm) | unset %tm }
        while (%r) {
          var %m $mid(%nx.cc.rm,%r,1)
          if ( %m isincs l ) { mode %nx.cc.chan $+($chr(45),%m) }
          elseif ( %m isincs k ) { mode %nx.cc.chan $+($chr(45),%m) $chan(%nx.cc.chan).key }
          ; TODO add +ffH for unrealircd
          elseif ( %m isincs L ) { echo 3 -a remove L cannot be set yet, my master has to make it }
          elseif ( %m isincs F ) { echo 3 -a remove F cannot be set yet, my master has to make it }
          elseif ( %m isincs f ) { echo 3 -a remove f cannot be set yet, my master has to make it }
          elseif ( %m isincs H ) { echo 3 -a remove H cannot be set yet, my master has to make it }
          else { var %tm $+(%m,%tm) }
          if ( $iif($chr(43 isin %len),$calc($len(%tm) -1),$len(%tm)) = $modespl ) { mode %nx.cc.chan $+($chr(45),%tm) | unset %tm }
          dec %r
        }
        if ( %tm ) { mode %nx.cc.chan $+($chr(45),%tm) | unset %tm }
      }
      if ( %nx.cc.editbox.setmode ) { mode %nx.cc.chan %nx.cc.editbox.setmode }
    }
    ; TODO fix mode +L (unreal + nefarious) and +HfF (unreal)
    elseif ( $nx.cc.chk.id($did) ) { 
      set %nx.cc.chk.mode $v1
      var %nx.cc.chk.id $did
      var %nx.cc.supported.modes lktnimpsrCcDGLMNOPQRSTuVKZzL
      if ( %nx.cc.chk.mode isincs %nx.cc.supported.modes ) {
        ; mode is set and checked
        if ( $istok(%nx.cc.ismode,%nx.cc.chk.id,32) ) && ( $did(%nx.cc.chk.id).state = 1 ) { set %nx.cc.remmode $nx.remtok(%nx.cc.remmode,%nx.cc.chk.mode,32) }
        ; mode is set and unchecked
        elseif ( $istok(%nx.cc.ismode,%nx.cc.chk.id,32) ) && ( $did(%nx.cc.chk.id).state = 0 ) { set %nx.cc.remmode $nx.addtok(%nx.cc.remmode,%nx.cc.chk.mode,32) }
        ; mode is not set and checked
        if (!$istok(%nx.cc.ismode,%nx.cc.chk.id,32)) && ( $did(%nx.cc.chk.id).state = 1 ) { set %nx.cc.setmode $nx.addtok(%nx.cc.setmode,%nx.cc.chk.mode,32) }
        ; mode is not set and unchecked
        elseif (!$istok(%nx.cc.ismode,%nx.cc.chk.id,32)) && ( $did(%nx.cc.chk.id).state = 0 ) { set %nx.cc.setmode $nx.remtok(%nx.cc.setmode,%nx.cc.chk.mode,32) }
        ; echo -a mode+: %nx.cc.setmode mode-: %nx.cc.remmode didstate: $did(%nx.cc.chk.id).state Sett from before %nx.cc.chk.mode istok %nx.cc.ismode and %nx.cc.supported.modes
      }
      dialogecho
    }
    if ($did == 310) {
      ; TODO Select bans to unban
    }
  }
  elseif ( $devent = active ) { dialogecho }
  elseif ( $devent = close ) { dialogecho | unset %nx.cc.* }
  elseif ( $devent = mouse ) { return }
  else { dialogecho }
}

; ircu   b,k,l,imnpstrDdRcCMP
; snircd b,k,l,imnpstrDducCNMT
; nefarious be,k,Ll,aCcDdiMmNnOpQRrSsTtZz
; unreal beI,fkL,lFH,cdimnprstzCDGKMNOPQRSTVZ
; bahamut beI,k,jl,ciPAmMnOprRsSt
; ratbox eIb,k,l,imnpstS
alias nx.cc.refmodes { 
  if ( $dialog(nx.dialog.cc) ) && ( %nx.cc.chan ischan ) {
    set %nx.cc.chanmodes $+($gettok($chanmodes,-1,44),$iif($gettok($chanmodes,3,44),$v1),$iif($gettok($chanmodes,2,44),$v1))
    set %nx.cc.currmode $gettok($mid($chan(%nx.cc.chan).mode,2,$len(%nx.cc.chanmodes)),1,32)
    set %nx.cc.currmode.opt $gettok($chan(%nx.cc.chan).mode,2-,32)

    var %nx.cc.cm klimnpst
    var %nx.cc.cmircu $+(%nx.cc.cm,rDcCMP)
    var %nx.cc.cmsnircd $+(%nx.cc.cm,rDucCNMT)
    var %nx.cc.cmunreal $+(%nx.cc.cm,zcCDGKMNOPQRSTVL)
    ; bahamut todo add +A +P +S(ssl only) in dialog and $nx.cc.chk.id
    var %nx.cc.cmbahamut $+(%nx.cc.cm,cMOrR)
    ; Nefarious todo add +a in dialog and $nx.cc.chk.id
    var %nx.cc.cmnefarious $+(%nx.cc.cm,CcDMNOQRSTZz)
    ; Ratbox todo add +S
    var %nx.cc.cmratbox $+(%nx.cc.cm,S)

    if ( $istok($nx.db(read,settings,ircd,ircu2),$network,32) ) { set %nx.cc.sv ircu2 | set %nx.cc.ircd %nx.cc.cmircu }
    elseif ( $istok($nx.db(read,settings,ircd,nefarious),$network,32) ) { set %nx.cc.sv nefarious | set %nx.cc.ircd %nx.cc.cmnefarious }
    elseif ( $istok($nx.db(read,settings,ircd,snircd),$network,32) ) { set %nx.cc.sv snircd | set %nx.cc.ircd %nx.cc.cmsnircd }
    elseif ( $istok($nx.db(read,settings,ircd,unreal),$network,32) ) { set %nx.cc.sv unreal | set %nx.cc.ircd %nx.cc.cmunreal }
    elseif ( $istok($nx.db(read,settings,ircd,bahamut),$network,32) ) { set %nx.cc.sv bahamut | set %nx.cc.ircd %nx.cc.cmbahamut }
    elseif ( $istok($nx.db(read,settings,ircd,ratbox),$network,32) ) { set %nx.cc.sv ratbox | set %nx.cc.ircd %nx.cc.cmratbox }
    else { set %nx.cc.sv unknown | set %nx.cc.ircd %nx.cc.cm }

    ;echo 14 -a Starting to check modes for %nx.cc.sv modes: %nx.cc.ircd currmode: %nx.cc.currmode chanmodes: %nx.cc.chanmodes opt: %nx.cc.currmode.opt 
    var %nx.cc.cmlen $len(%nx.cc.ircd)
    while (%nx.cc.cmlen) {
      if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) isincs %nx.cc.chanmodes ) { 
        ;echo 15 -a Len %nx.cc.cmlen Is currmode: $mid(%nx.cc.ircd,%nx.cc.cmlen,1) isincs %nx.cc.currmode

        var %nx.cc.cmid $nx.cc.chk.id($mid(%nx.cc.ircd,%nx.cc.cmlen,1))
        if ( $me isop %nx.cc.chan ) {
          if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) === l ) { did -e %nx.cc.dname $calc(%nx.cc.cmid +1) }
          if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) === k ) { did -e %nx.cc.dname $calc(%nx.cc.cmid +1) }
          if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) === L ) { did -e %nx.cc.dname $calc(%nx.cc.cmid +1) }
          ; TODO add +ffH for unrealircd
        }
        if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) isincs %nx.cc.currmode ) { 
          if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) === l ) { did -ae %nx.cc.dname $calc(%nx.cc.cmid +1) $chan(%nx.cc.chan).limit | dec %nx.cc.optlen }
          if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) === k ) { did -ae %nx.cc.dname $calc(%nx.cc.cmid +1) $chan(%nx.cc.chan).key | dec %nx.cc.optlen }
          if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) === L ) { did -ae %nx.cc.dname $calc(%nx.cc.cmid +1) }
          set %nx.cc.ismode $addtok(%nx.cc.ismode,%nx.cc.cmid,32)
          ;echo 11 -a Ismode: %nx.cc.ismode - Enable mode enable mode: $mid(%nx.cc.ircd,%nx.cc.cmlen,1) ID: %nx.cc.cmid 
          did -c %nx.cc.dname %nx.cc.cmid 
        }
        if ( $me isop %nx.cc.chan ) { did -e %nx.cc.dname %nx.cc.cmid }
        if ( $mid(%nx.cc.ircd,%nx.cc.cmlen,1) isincs %nx.cc.currmode ) { set %nx.cc.ismode $addtok(%nx.cc.ismode,%nx.cc.cmid,32) | did -c %nx.cc.dname %nx.cc.cmid }
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

alias nx.cc.getbans {
  ; echo -a Get bans 
  did -ra %nx.cc.dname $nx.cc.chk.id(Banlist) Refreshing bans ...
  did -ra %nx.cc.dname $nx.cc.chk.id(numbans) unknown/ $+ $iif(%nx.maxbans. [ $+ [ $cid ] ],$v1,unknown)
  set -u100 %nx.cc.getbans %nx.cc.chan
  mode %nx.cc.chan +b
}

; placeholder
alias nx.cc.getinvites {
 return
}

; placeholder
alias nx.cc.getexcepts {
 return
}

alias dialogecho { 
  if ( 1 = 2 ) {
    if ( $devent = edit ) { echo -at DIALOG $dname devent: $devent did: $did didtext: $did($dname,$did) }
    elseif ( $devent = sclick ) { echo -at DIALOG $dname devent: $devent did: $did = $nx.cc.chk.id($did) }
    elseif ( $devent = uclick ) { echo -at DIALOG $dname devent: $devent did: $did = $nx.cc.chk.id($did) }
    elseif ( $devent = mouse ) { return }
    elseif ( $devent = init ) { echo -at DIALOG $dname devent: $devent $did }
    elseif ( $devent = close ) { echo -at DIALOG $dname devent: $devent }
    else { echo -at DIALOG $dname devent: $devent did: $did }
  }
}

; Move this to .ini file ?
alias nx.cc.chk.id {
  if ( $1 == 101 ) { return SAVE }
  if ( $1 == 102 ) { return Cancel }
  if ( $1 == 103 ) { return Apply }

  if ( $1 === 310 ) { return Banlist }
  if ( $1 === Banlist ) { return 310 }
  if ( $1 === 311 ) { return BanSetBy }
  if ( $1 === BanSetBy ) { return 311 }
  if ( $1 === 312 ) { return BanSetDate }
  if ( $1 === BanSetDate ) { return 312 }
  if ( $1 == 314 ) { return numbans }
  if ( $1 === numbans ) { return 314 }

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
  if ( $1 === S ) && ( %nx.cc.sv = unreal ) { return 166 }
  if ( $1 === S ) && ( %nx.cc.sv = ratbox ) { return 166 }
  if ( $1 == 166 ) { return S }
  if ( $1 === T ) && ( %nx.cc.sv = unreal ) { return 167 }
  if ( $1 == 167 ) { return T }
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
  if ( $1 === Q ) && ( %nx.cc.sv = unreal ) { return 178 }
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
  if ( $1 === N ) && ( %nx.cc.sv = nefarious ) { return 187 }
  if ( $1 == 187 ) { return N }

  if ( $1 === M ) { return 188 }
  if ( $1 == 188 ) { return M }

  if ( $1 === T ) && ( %nx.cc.sv = snircd ) { return 189 }
  if ( $1 === T ) && ( %nx.cc.sv = nefarious ) { return 189 }
  if ( $1 == 189 ) { return T }

  if ( $1 === Z ) { return 191 }
  if ( $1 == 191 ) { return Z }
  if ( $1 === Q ) && ( %nx.cc.sv = nefarious ) { return 192 }
  if ( $1 == 192 ) { return Q }
}

; Stolen from noname script (http://nnscript.com), thanks to the author

alias wd { return $gettok($1,$2,32) }
alias nbr { if ($1- != $null) { return ( $+ $1- $+ ) } }

; This is just a test, not sure if it will work
alias mdx {
  var %m = $dll(scripts\dlls\mdx.dll,$1,$2-)
  if (ERROR * iswmcs %m) { echo 3 -st Warning in alias mdx: $nbr($wd(%m,3-)) | return }
  ;if (ERROR * iswmcs %m) { thmerror -a MDX warning $nbr($wd(%m,3-)) ;}
}
alias mdxfile { return $+($scriptdir,dlls\,$1,.mdx) }
alias mdxunsel {
  var %w1 = $+(@mdxunsel.,$1,.,$2,.1),%w2 = $+(@mdxunsel.,$1,.,$2,.2),%z
  window -h %w1
  window -h %w2
  filter -iwr 2- $+ $did($1,$2).lines $1 $2 %w1
  var %i = 1,%t = $line(%w1,0)
  while (%i <= %t) {
    noop $regsub($wd($line(%w1,%i),3-),/	\+[fs]+ (\d+) (\d+) (\d+)/g,	+ \1 \2 \3,%z)
    echo %w2 0 + %z
    inc %i
  }
  if ($3 != /s) {
    filter -cwo %w2 $1-2
    close -@ %w2
  }
  close -@ %w1
}
alias mkregex {
  if ($1 != $null) {
    if ($prop == re) { return $replacex($mid($1,5,-5),\^,^,\.,.,\|,|,|,$chr(44),\$,$,\\,\,\?,?,\+,+,\[,[,\],],.*,*,.,?,\ $+ $chr(123),$chr(123),\ $+ $chr(125),$chr(125),\ $+ $chr(40),$chr(40),\ $+ $chr(41),$chr(41)) }
    else { return /\b( $+ $replacex($1,\,\\,$,\$,^,\^,|,\|,$chr(44),|,+,\+,.,\.,[,\[,],\],*,.*,?,.,$chr(123),\ $+ $chr(123),$chr(125),\ $+ $chr(125),$chr(40),\ $+ $chr(40),$chr(41),\ $+ $chr(41)) $+ )\b/i }
  }
}