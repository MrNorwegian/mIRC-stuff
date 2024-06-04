; Usage /wm.make your-config.conf

alias wm.make { 
  if (!$1) { echo Usage /wm.make your-config.conf | halt }

  ; sw01 posx posy width height,
  set -u10 %nx.wm.nodes sw01 900 200 100 300,sw02 1600 200 100 300,sw03 600 900 100 180,sw04 800 650 100 180,sw05 400 650 100 180,ngsw01 1200 800 100 500,ngsw02 1600 800 100 500
  ; sw01 v\r\b num
  ; v for left, r for right, b for both (where childnodes are placed), b is skipping 10 and -10 for uplink exept if childnodes is 16
  set -u10 %nx.wm.child.nodes sw01 b 24,sw02 b 24,sw03 b 16,sw04 v 8,sw05 v 8,ngsw01 v 24,ngsw02 r 24
  ; sw01-sw02 num,
  ; NOTE links for child.nodes is made in the alias wm.make.child.nodes
  set -u10 %nx.wm.links sw01-sw02 1 r-v,sw01-ngsw01 1 u-d,sw02-ngsw02 1 u-d,ngsw01-ngsw02 4 r-v

  ; General offset ( Not used yet )
  set -u10 %nx.wm.childnode.offset 20
  ; Horizontal offset
  set -u10 %nx.wm.childnode.offsetx 20
  set -u10 %nx.wm.childnode.space 300

  ; Vertical offset ( Not used yet )
  set -u10 %nx.wm.childnode.offsety 20

  set -u10 %nx.wm.conf $1
  remove %nx.wm.conf
  wm.make.defaults
  wm.make.nodes
  wm.make.nodelinks
  wm.make.child.nodes

  echo 3 -at Done making weathermap for %nx.wm.conf
  unset %nx.wm.*
}
alias wm.make.defaults {
  write %nx.wm.conf WIDTH 1980
  write %nx.wm.conf HEIGHT 1080
  write %nx.wm.conf HTMLSTYLE overlib
  write %nx.wm.conf HTMLOUTPUTconf $replace(%nx.wm.conf,.conf,.html)
  write %nx.wm.conf IMAGEOUTPUTconf $replace(%nx.wm.conf,.conf,.png)

  write %nx.wm.conf KEYPOS DEFAULT -1 -1 Traffic Load
  write %nx.wm.conf KEYTEXTCOLOR 0 0 0
  write %nx.wm.conf KEYOUTLINECOLOR 0 0 0
  write %nx.wm.conf KEYBGCOLOR 255 255 255
  write %nx.wm.conf BGCOLOR 255 255 255
  write %nx.wm.conf TITLECOLOR 0 0 0
  write %nx.wm.conf TIMECOLOR 0 0 0

  write %nx.wm.conf SCALE DEFAULT 0    0    192 192 192  
  write %nx.wm.conf SCALE DEFAULT 0    1    255 255 255  
  write %nx.wm.conf SCALE DEFAULT 1    10   140   0 255  
  write %nx.wm.conf SCALE DEFAULT 10   25    32  32 255  
  write %nx.wm.conf SCALE DEFAULT 25   40     0 192 255  
  write %nx.wm.conf SCALE DEFAULT 40   55     0 240   0  
  write %nx.wm.conf SCALE DEFAULT 55   70   240 240   0  
  write %nx.wm.conf SCALE DEFAULT 70   85   255 192   0  
  write %nx.wm.conf SCALE DEFAULT 85   100  255   0   0
  write %nx.wm.conf SCALE fping 0    0      0 255   0  
  write %nx.wm.conf SCALE fping 0    10     0 255   0   200 255  75    
  write %nx.wm.conf SCALE fping 10   30   200 255  75   255 255   0    
  write %nx.wm.conf SCALE fping 30   60   255 255   0   255 150   0    
  write %nx.wm.conf SCALE fping 60   80   255 150   0   255  75   0    
  write %nx.wm.conf SCALE fping 80   100  255  75   0   255   0   0    

  write %nx.wm.conf SET key_hidezero_DEFAULT 1

  write %nx.wm.conf NODE DEFAULT
  write %nx.wm.conf $+($wm.space,MAXVALUE) 100

  write %nx.wm.conf LINK DEFAULT
  write %nx.wm.conf $+($wm.space,WIDTH) 4
  write %nx.wm.conf $+($wm.space,ARROWSTYLE) compact
  write %nx.wm.conf $+($wm.space,BWLABEL) bits
  write %nx.wm.conf $+($wm.space,BANDWIDTH) 1000M
  ; put ascii for hashtag in $chr()
  write %nx.wm.conf $chr(35)
  echo 3 -at Done setting defaults
}
alias wm.make.nodes {
  var %n $numtok(%nx.wm.nodes,44)
  while ( %n ) { 
    echo 10 -at Making num %n node $gettok($gettok(%nx.wm.nodes,%n,44),1,32) with icon $gettok($gettok(%nx.wm.nodes,%n,44),4-5,32) at position $gettok($gettok(%nx.wm.nodes,%n,44),2-3,32)
    write %nx.wm.conf NODE $gettok($gettok(%nx.wm.nodes,%n,44),1,32)
    write %nx.wm.conf LABEL $gettok($gettok(%nx.wm.nodes,%n,44),1,32)
    write %nx.wm.conf ZORDER 1
    write %nx.wm.conf LABELOFFSET C
    write %nx.wm.conf AICONOUTLINECOLOR 255 255 255
    write %nx.wm.conf LABELOUTLINECOLOR none
    write %nx.wm.conf ICON $gettok($gettok(%nx.wm.nodes,%n,44),4-5,32) rbox
    set -u10 %nx.wm.parentnode. $+ $gettok($gettok(%nx.wm.nodes,%n,44),1,32) $gettok($gettok(%nx.wm.nodes,%n,44),4-5,32)
    ; TODO make another TARGET for node
    write %nx.wm.conf TARGET gauge:./mainsw01.lan.da9.no/ping-perf.rrd:ping:-
    write %nx.wm.conf USESCALE fping in percent
    write %nx.wm.conf POSITION $gettok($gettok(%nx.wm.nodes,%n,44),2-3,32)
    write %nx.wm.conf $chr(35)
    dec %n 
  }
}

alias wm.make.nodelinks { 
  ; sw01-sw02 1 r-v,sw01-ngsw01 1 u-d,sw02-ngsw02 1 u-d,ngsw01-ngsw02 4 r-v
  var %l $numtok(%nx.wm.links,44)
  while ( %l ) { 
    var %i $gettok($gettok(%nx.wm.links,%l,44),2,32)
    var %n $gettok($gettok(%nx.wm.links,%n,44),1,32)
    if ( %i = 1 ) { 
      write %nx.wm.conf LINK %n
      write %nx.wm.conf NODES $+($gettok(%n,1,45),:0:0) $+($gettok(%n,1,45):0:0)
    }
    else { 
      while ( %i ) { 
        ; TODO use u-d,r-v etc to calculate where links should be placed (Now it's 0:0)
        write %nx.wm.conf LINK $gettok($gettok(%nx.wm.links,%i,44),1,32)
        write %nx.wm.conf NODES $+($gettok(%n,1,45),:,%child-node-posx,:0) $+($gettok(%n,1,45):0:0)
        ; TODO find out how to automate getting right links and RRD
        ; write %nx.wm.conf INFOURL http://librenms.example.com/graphs/type=port_bits/id=29/
        ; write %nx.wm.conf OVERLIBGRAPH http://librenms.example.com/graph.php?height=100&width=512&id=29&type=port_bits&legend=no
        ; write %nx.wm.conf TARGET ./10.10.10.10/port-id22.rrd:INOCTETS:OUTOCTETS
        dec %i
      }
    }
    dec %l
  }
}
alias wm.make.child.nodes {
  ; ngsw02 r 24,ngsw01 r 24,sw02 b 24,sw01 b 24
  var %n $numtok(%nx.wm.child.nodes,44)
  while ( %n ) { 
    var %c $gettok($gettok(%nx.wm.child.nodes,%n,44),3,32), %i 1
    var %pd $calc($gettok(%nx.wm.parentnode. [ $+ [ $gettok($gettok(%nx.wm.child.nodes,%n,44),1,32) ] ],2,32) /2)
    var %pd $calc(%pd - %pd - %pd)
    echo 9 -at Making %c child-nodes for parentnode $gettok($gettok(%nx.wm.child.nodes,%n,44),1,32) height %pd
    while ( %i <= %c ) { 
      var %p $+(p,%i)
      var %child-node-posx $calc($gettok(%nx.wm.parentnode. [ $+ [ $gettok($gettok(%nx.wm.child.nodes,%n,44),1,32) ] ],1,32) /2)
      write %nx.wm.conf NODE $+($gettok($gettok(%nx.wm.child.nodes,%n,44),1,32),%p)
      write %nx.wm.conf LABEL %p
      ;write %nx.wm.conf LABELOFFSET C
      ;write %nx.wm.conf AICONOUTLINECOLOR 255 255 255
      ;write %nx.wm.conf LABELOUTLINECOLOR none
      ;write %nx.wm.conf ICON $gettok($gettok(%nx.wm.child.nodes,4-5,32),%i,44) rbox
      ;write %nx.wm.conf USESCALE fping in percent
      if ( $gettok($gettok(%nx.wm.child.nodes,%n,44),2,32) == r ) { var %pdv %nx.wm.childnode.space | inc %pd %nx.wm.childnode.offsetx }
      elseif ( $gettok($gettok(%nx.wm.child.nodes,%n,44),2,32) == v ) { var %child-node-posx $+(-,%child-node-posx) | var %pdv $+(-,%nx.wm.childnode.space) | inc %pd %nx.wm.childnode.offsetx }
      elseif ( $gettok($gettok(%nx.wm.child.nodes,%n,44),2,32) == b ) { 
        if ( $numtok($calc(%i / 2),46) == 2 ) {
          var %pdv $+(-,%nx.wm.childnode.space)
          var %child-node-posx $+(-,%child-node-posx)
          if ( $calc(%pd + %nx.wm.childnode.offsetx + %nx.wm.childnode.offsetx) = 10 ) && ($gettok($gettok(%nx.wm.child.nodes,%n,44),3,32) != 16) { inc %pd %nx.wm.childnode.offsetx | inc %pd %nx.wm.childnode.offsetx | inc %pd %nx.wm.childnode.offsetx }
          else { inc %pd %nx.wm.childnode.offsetx }
        }
        elseif ( $numtok($calc(%i / 2),46) == 1 ) { var %pdv %nx.wm.childnode.space }
      }
      echo 9 -at Making child node %i at position %nx.wm.childnode.space %pd 
      write %nx.wm.conf POSITION $gettok($gettok(%nx.wm.child.nodes,%n,44),1,32) %pdv %pd
      inc %i
      write %nx.wm.conf $chr(35)
      ; Write links
      write %nx.wm.conf LINK $+($gettok($gettok(%nx.wm.child.nodes,%n,44),1,32),-,$+($gettok($gettok(%nx.wm.child.nodes,%n,44),1,32),%p))
      write %nx.wm.conf NODES $+($gettok($gettok(%nx.wm.child.nodes,%n,44),1,32),:,%child-node-posx,:,%pd) $+($gettok($gettok(%nx.wm.child.nodes,%n,44),1,32),%p)
      unset %pdv
    }
    dec %n
  }
}

alias wm.space { return $+($chr(32),$chr(32),$chr(32),$chr(32)) }
