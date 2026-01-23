; Work in progress
on 1:tabcomp:*:{
  var %cmds+args = $left($editbox($active),$editbox($active).selstart)
  var %numargs = $count(%cmds+args,$chr(32)) + 1
  var %lastarg = $gettok($editbox($active),%numargs,32)

  var %arg $+(/,$remove($1,/))

  if ( %arg == /nick ) { echo -at Syntax: %arg <newnick> - max $hget(settings_ [ $+ [ $cid ] ],nicklen) characters. }
  elseif ( %arg == /mode ) {
    if ( %lastarg == + ) { 
      if ( $2 == $me ) { echo -at Syntax: %arg <nick> <umodes> [params] - Available user modes $hget(settings_ [ $+ [ $cid ] ],usermodes) }
      elseif ( $2 ischan ) { echo -at Syntax: %arg <#channel> <modes> [params] - Available channel modes $hget(settings_ [ $+ [ $cid ] ],chanmodes) }
    }
  }

  ; whox 
  elseif ( %arg == /who ) { return }
}