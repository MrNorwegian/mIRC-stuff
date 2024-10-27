; some random time stuff on norwegian

alias tg {
  var %first Jun 07 2008 10:30:00 ,%next Jun 07 2008 14:00:00 ,%loop 2
  while (%loop) {
    var %var $iif(%loop == 1 ,%first ,%next)
    var %tmp $duration($calc($ctime(%var) - $ctime))
    var %i $numtok(%tmp,32)
    while (%i) {
      if ($regex($left($gettok(%tmp,%i,32),2),/^[0-9]{2}$/) == 1) { var %tmp $replace(%tmp,$left($gettok(%tmp,%i,32),2),$tell($left($gettok(%tmp,%i,32),2))) }
      if ($regex($left($gettok(%tmp,%i,32),1),/^[0-9]{1}$/) == 1) { var %tmp $replace(%tmp,$left($gettok(%tmp,%i,32),1),$tell($left($gettok(%tmp,%i,32),1))) }
      dec %i 
    }
    var %tmp $replace(%tmp,wks,$+($chr(32),uker,$chr(44)),days,$+($chr(32),dager,$chr(44)),day,$+($chr(32),dag,$chr(44)),hrs,$+($chr(32),timer,$chr(44)),hr,$+($chr(32),time,$chr(44)),mins,$+($chr(32),minutter,$chr(32),og),min,$+($chr(32),minutt,$chr(32),og),secs,$+($chr(32),sekund(er),$chr(44)))
    if (%loop = 1 ) { var %tstart Da er det %tmp igjen til jeg begynner 8.2 mil sykkelritt i 30++ grader }
    if (%loop = 2 ) { var %tslutt Og det er ca %tmp igjen til jeg er i mål svett og sliten }
    dec %loop
  }
  say %tstart
  say %tslutt
  unset %loop %tstart %tslutt %tmp %i
}

; Thanks ZnarreZ @ UnderNet
alias tid { return Klokken min er $tid1 }
alias tid1 { return $Kl }
alias fulltid { return Klokken min er $kl $lower($dag) den $lower($dato) $lower($Måned) $Aar $+ . }

alias DAG {
  var %dag $iif($1,$1,$day),%i 7
  if (%dag == Friday) { return Fredag }
  if %dag == Thursday { return Torsdag }
  if %dag == Wednesday { return Onsdag }
  if %dag == Tuesday { return Tirsdag }
  if %dag == Monday { return Mandag }
  if %dag == Sunday { return Søndag }
  if %dag == Saturday { return Lørdag }
  else { return Script-error for $day }
}

alias dato {
  var %dato $iif($1,$1,$date(d)),%i 31
  var %tmpdatoer Første,Andre,Tredje,Fjerde,Femte,Sjette,Sjuende,Åttende,Niende,Tiende,Ellevte,Tolvte,Trettende,Fjortende,Femtende,Sekstende,Syttende,Attende,Nittende
  var %datoer %tmpdatoer $+ , $+ Tjuende,Tjueførste,Tjueandre,Tjuetrede,Tjuefjerde,Tjuefemte,Tjuesjette,Tjuesjuende,Tjueåttende,Tjueniende,Trettiende,Trettiførste
  while (%i) { if (%dato == %i) { return $gettok(%datoer,%i,44) } | dec %i }
}

alias Måned {
  var %dato $iif($1,$1,$date(m)),%i 12
  var %mnds Januar,Februar,Mars,April,Mai,Juni,Juli,August,September,Oktober,November,Desember 
  while (%i) { if (%dato == %i) { return $gettok(%mnds,%i,44) } | dec %i }
}

alias Kl {
  var %klokke $iif($1,$1,$time)
  var %mmover minutter over,%mmpA minutter på,%hr $gettok(%klokke,1,58),%mm $gettok(%klokke,2,58),%time,%minutt
  var %sekunder og $tell($time(ss)) sekunder 
  if (%mm isnum 20-59) { inc %hr }

  if (%mm isnum 00) { %minutt = $null }
  elseif ($istok(01 29 31 59,%mm,32)) { %minutt = ett }
  elseif ($istok(02 28 32 58,%mm,32)) { %minutt = to }
  elseif ($istok(03 27 33 57,%mm,32)) { %minutt = tre }
  elseif ($istok(04 26 34 56,%mm,32)) { %minutt = fire }
  elseif ($istok(05 25 35 55,%mm,32)) { %minutt = fem }
  elseif ($istok(06 24 36 54,%mm,32)) { %minutt = seks }
  elseif ($istok(07 23 37 53,%mm,32)) { %minutt = sju }
  elseif ($istok(08 22 38 52,%mm,32)) { %minutt = åtte }
  elseif ($istok(09 21 39 51,%mm,32)) { %minutt = ni }
  elseif ($istok(10 20 40 50,%mm,32)) { %minutt = ti }
  elseif ($istok(11 49,%mm,32)) { %minutt = elleve }
  elseif ($istok(12 48,%mm,32)) { %minutt = tolv }
  elseif ($istok(13 47,%mm,32)) { %minutt = tretten }
  elseif ($istok(14 46,%mm,32)) { %minutt = fjorten }
  elseif ($istok(15 45,%mm,32)) { %minutt = kvart }
  elseif ($istok(30,%mm,32)) { %minutt = halv }
  elseif ($istok(16 44,%mm,32)) { %minutt = seksten }
  elseif ($istok(17 43,%mm,32)) { %minutt = sytten }
  elseif ($istok(18 44,%mm,32)) { %minutt = atten }
  elseif ($istok(19 41,%mm,32)) { %minutt = nitten }

  if ($istok(01 31,%mm,32)) { %minutt = %minutt minutt %sekunder over }
  elseif ($istok(29 59,%mm,32)) { %minutt = %minutt minutt %sekunder på }
  elseif (%mm isnum 2-14) { %minutt = %minutt minutter %sekunder over }
  elseif (%mm isnum 15) { %minutt = %minutt %sekunder over }
  elseif (%mm isnum 16-19) { %minutt = %minutt minutter %sekunder over }
  elseif (%mm isnum 32-40) { %minutt = %minutt minutter %sekunder over }
  elseif (%mm isnum 20-28) { %minutt = %minutt minutter %sekunder på }
  elseif (%mm isnum 41-44) { %minutt = %minutt minutter %sekunder på }
  elseif (%mm isnum 45) { %minutt = %minutt %sekunder på }
  elseif (%mm isnum 46-58) { %minutt = %minutt minutter %sekunder på }


  if (%mm isnum 31-40) { %minutt = %minutt halv }
  elseif (%mm isnum 20-29) { %minutt = %minutt halv }

  if $istok(1 01 13 25,%hr,32) { %time = ett }
  elseif $istok(2 02 14,%hr,32) { %time = to }
  elseif $istok(3 03 15,%hr,32) { %time = tre }
  elseif $istok(4 04 16,%hr,32) { %time = fire }
  elseif $istok(5 05 17,%hr,32) { %time = fem }
  elseif $istok(6 06 18,%hr,32) { %time = seks }
  elseif $istok(7 07 19,%hr,32) { %time = sju }
  elseif $istok(8 08 20,%hr,32) { %time = åtte }
  elseif $istok(9 09 21,%hr,32) { %time = ni }
  elseif $istok(10 22,%hr,32) { %time = ti }
  elseif $istok(11 23,%hr,32) { %time = elleve }
  elseif $istok(12 24 00,%hr,32) { %time = tolv }

  if %hr isnum 01-05 { %time = %time (om natta) }
  elseif %hr isnum 06-10 { %time = %time (om morningen) }
  elseif %hr isnum 11-15 { %time = %time (om formiddagen) }
  elseif %hr isnum 16-19 { %time = %time (om ettermiddagen) }
  elseif %hr isnum 20-23 { %time = %time (om kvelden) }
  elseif $istok(24 00,%hr,32) { %time = %time (om natta) }

  return %minutt %time
}

alias Aar {
  var %Aar $iif($1 == $null,$date(yyyy),$iif($regex($1,^\d\d$),20 $+ $1,$1)),%Aar2
  if %Aar > 10000 { return året er litt for høyt til scriptet }
  if $regex(%Aar,/^(?:([1-9])([1-9])\d\d)$/) { %Aar2 = $Tell($regml(1) $+ $regml(2)) }
  elseif $regex(%Aar,/^(?:([1-9])000)$/) { %Aar2 = $Tell($regml(1)) tusen }
  elseif $regex(%Aar,/^(?:([1-9])0\d\d)$/) { %Aar2 = $Tell($regml(1)) tusen og }
  elseif $regex(%Aar,/^(?:0?([1-9])00)$/) { %Aar2 = $Tell($regml(1)) hundre }
  elseif $regex(%Aar,/^(?:0?([1-9])\d\d)$/) { %Aar2 = $Tell($regml(1)) hundre og }
  set %Aar2 $reptok(%Aar2,en,ett,1,32)
  if $regex(%Aar,/^(?:\d?\d?([1-9]\d))$/) { %Aar2 = %Aar2 $Tell($regml(1)) }
  elseif $regex(%Aar,/^(?:[1-9][1-9]\d?(\d))$/) { %Aar2 = %Aar2 null $Tell($regml(1)) }
  elseif $regex(%Aar,/^(?:\d?\d?\d?(\d))$/) { %Aar2 = %Aar2 $Tell($regml(1)) }
  return år %Aar2
}


alias Tell {
  var %tall ,%i 19
  var %tmp-tall en,to,tre,fire,fem,seks,sju,åtte,ni,ti,elleve,tolv,tretten,fjorten,femten,seksten,sytten,atten,nitten
  while (%i) { if ($1 == %i) { %tall = %tall $gettok(%tmp-tall,%i,44) } | dec %i }

  if $1 isnum 20-29 { %tall = %tall tjue }
  elseif $1 isnum 30-39 { %tall = %tall tretti }
  elseif $1 isnum 40-49 { %tall = %tall førti }
  elseif $1 isnum 50-59 { %tall = %tall femti }
  elseif $1 isnum 60-69 { %tall = %tall seksti }
  elseif $1 isnum 70-79 { %tall = %tall sytti }
  elseif $1 isnum 80-89 { %tall = %tall åtti }
  elseif $1 isnum 90-99 { %tall = %tall nitti }
  if $regex(TELL,$1,/^(?:[2-9]([1-9]))$/) {
    if $regml(TELL,1) == 1 { %tall = %tall $+ en }
    elseif $regml(TELL,1) == 2 { %tall = %tall $+ to }
    elseif $regml(TELL,1) == 3 { %tall = %tall $+ tre }
    elseif $regml(TELL,1) == 4 { %tall = %tall $+ fire }
    elseif $regml(TELL,1) == 5 { %tall = %tall $+ fem }
    elseif $regml(TELL,1) == 6 { %tall = %tall $+ seks }
    elseif $regml(TELL,1) == 7 { %tall = %tall $+ sju }
    elseif $regml(TELL,1) == 8 { %tall = %tall $+ åtte }
    elseif $regml(TELL,1) == 9 { %tall = %tall $+ ni }
  }
  return %tall
}
