on *:start:{
  ; connectall is just a bunch of /server -m
  if ( %nx.autoconnect = yes ) { connectall }
}
on 1:connect:{
  ; Part of custom IAL
  if ( $readini($+(ial\,$network,_,$cid,.ini),status,connected) ) { .remove $+(ial\,$network,_,$cid,.ini) | writeini $+(ial\,$network,_,$cid,.ini) status connected 1 }
  else { writeini $+(ial\,$network,_,$cid,.ini) status connected 1 }
}
on 1:disconnect:{ 
  ; Part of custom IAL
  if ( $readini($+(ial\,$network,_,$cid,.ini),status,connected) ) { writeini $+(ial\,$network,_,$cid,.ini) status connected 0 }
  else { writeini $+(ial\,$network,_,$cid,.ini) status connected 0 }
}
