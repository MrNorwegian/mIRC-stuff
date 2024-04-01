alias join {
  ; /join #chan1,chan2,#chan3 key,chan4 key
  ; Todo, check for & also. for now vanilla /join &localchan
  if ($1) {
    if ( $left($1,1) = $chr(38) ) { join $1- }
    else {
      var %nx.join.numchan 1 
      while ($gettok($1-,%nx.join.numchan,44)) {
        var %nx.join.tmpchan $gettok($1-,%nx.join.numchan,44)
        ; Check for key
        if ($chr(32) isin %nx.join.tmpchan) { 
          var %nx.join.key $gettok(%nx.join.tmpchan,2,32)
          var %nx.join.tmpchan $gettok(%nx.join.tmpchan,1,32)
          join $iif($mid(%nx.join.tmpchan,1,1) != $chr(35),$+($chr(35),%nx.join.tmpchan),%nx.join.tmpchan) %nx.join.key
        }
        ; No key, just join
        else { join $iif($mid(%nx.join.tmpchan,1,1) != $chr(35),$+($chr(35),%nx.join.tmpchan),%nx.join.tmpchan) }
        inc %nx.join.numchan
      }
    }
  }
  else { echo -at Usage /join #chan1,chan2,#chan3 key,chan4 key }
}
