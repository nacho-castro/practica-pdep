jockey(valdivieso,155,52).
jockey(leguisamo,161,49).
jockey(lezcano,149,50).
jockey(baratucci,153,55).
jockey(falero,157,52).

caballo(botafogo).
caballo(oldman).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

stud(valdivieso, elTute).
stud(falero, elTute).
stud(lezcano, lasHormigas).
stud(baratucci, elCharabon).
stud(leguisamo, elCharabon).

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).

gano(oldman, granPremioRepublica).
gano(oldman, campeonatoPalermoOro).

gano(yatasto, granPremioCriadores).

preferencia(botafogo,Jockey):-
    jockey(Jockey,_,Peso),
    Peso < 52.
preferencia(botafogo, baratucci).

preferencia(oldman, Nombre):-
    jockey(Nombre,_,_),
    atom_length(Nombre, Largo),
    Largo > 7.

preferencia(energica, Jockey):-
    jockey(Jockey,_,_),
    not(preferencia(botafogo,Jockey)).

preferencia(matBoy,Jockey):-
    jockey(Jockey,Altura,_),
    Altura > 170.

%Por universo cerrado los casos negativos no se programan.
%2
prefiereMasUno(Caballo):-
    jockey(Jockey,_,_),
    jockey(Otro,_,_),
    Otro \= Jockey.
    preferencia(Caballo, Jockey),
    preferencia(Caballo, Otro).

%3
aborrece(Caballo,Stud):-
    caballo(Caballo),
    stud(_,Stud),
    not((stud(Jockey,Stud), preferencia(Caballo,Jockey))).

%4
ganoImportante(Caballo):-
    gano(Caballo,Premio),
    esImportante(Premio).

esImportante(granPremioNacional).
esImportante(granPremioRepublica).

esPiolin(Jockey):-
    jockey(Jockey,_,_),
    forall(ganoImportante(Caballo), preferencia(Caballo,Jockey)).
    
%5
%ganador(Caballo).
%segundo(Caballo).
%exacta(Caballo1, Caballo2).
%imperfecta(Caballo, OtroCaballo).

%apuestaGanadora(Apuesta,Primero,Segundo).
apuestaGanadora(ganador(Caballo), Caballo, _).

apuestaGanadora(segundo(Caballo), Caballo, _).
apuestaGanadora(segundo(Caballo), _, Caballo).

apuestaGanadora(exacta(Caballo1, Caballo2), Caballo1, Caballo2).

apuestaGanadora(imperfecta(Caballo, OtroCaballo), Caballo, OtroCaballo).
apuestaGanadora(imperfecta(Caballo, OtroCaballo), OtroCaballo, Caballo).

%6
color(botafogo,negro).
color(oldman,marron).
color(energica,gris).
color(energica,negro).
color(matBoy,marron).
color(matBoy,blanco).
color(yatasto,blanco).
color(yatasto,marron).

puedeComprar(Color,Caballos):-
    findall(Caballo, color(Caballo,Color), CaballosPosibles),
    permutar(CaballosPosibles, Caballos).

permutar([Caballo|Resto], [Caballo|Demas]):-
    permutar(Resto,Demas).

permutar([_|Resto], Caballos):-
    permutar(Resto,Caballos).

permutar([],[]).