viaja(dodain,pehuenia).
viaja(dodain,sanMartin).
viaja(dodain,esquel).
viaja(dodain,sarmiento).
viaja(dodain,camarones).
viaja(dodain,playasDoradas).

viaja(alf,sanMartin).
viaja(alf,bariloche).
viaja(alf,bolson).

viaja(nico,mardel).

viaja(vale,calafate).
viaja(vale,bolson).

viaja(martu,Lugar):- viaja(alf,Lugar).
viaja(martu,Lugar):- viaja(nico,Lugar).

%Quienes no viajan no estan por universo cerrado.

%2
atraccion(esquel, parqueNacional(alerces)).
atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(trevelin)).

atraccion(pehuenia, cerro(bateaMahuida,2000)).
atraccion(pehuenia, agua(moqueue, true, 14)).
atraccion(pehuenia, agua(alumine, true, 19)).

vacacionesCopadas(Persona):-
    viaja(Persona,_),
    forall(viaja(Persona,Lugar), tieneCopada(Lugar)).

tieneCopada(Lugar):-
    atraccion(Lugar,Atraccion),
    esCopada(Atraccion).

esCopada(cerro(_,Metros)):-
    Metros > 2000.

esCopada(agua(_,true,Temperatura)):-
    Temperatura > 20.

esCopada(playa(Diferencia)):-
    Diferencia < 5.

esCopada(excursion(Nombre)):-
    atom_chars(Nombre, Chars), % Convertimos el nombre en una lista de caracteres
    length(Chars, Cantidad),   % Calculamos la longitud
    Cantidad > 7.

esCopada(parqueNacional(_)).
    
%3
noSeCruzan(Persona,Otra):-
    viaja(Persona,_),
    viaja(Otra,_),
    not((viaja(Persona,Lugar), viaja(Otra,Lugar))).
    
%4
costo(sarmiento, 100).
costo(esquel, 150).
costo(pehuenia, 180).
costo(sanMartin, 150).
costo(camarones, 135).
costo(playasDoradas, 170).
costo(bariloche, 140).
costo(calafate, 240).
costo(bolson, 145).
costo(mardel, 140).

vacacionesGasoleras(Persona):-
    viaja(Persona,_),
    forall(viaja(Persona,Lugar), esGasolero(Lugar)).

esGasolero(Lugar):-
    costo(Lugar,Costo),
    Costo < 160.

%5
destinos(Persona, Itinerario):-
    findall(Lugar, viaja(Persona,Lugar), Lugares),
    permutaciones(Lugares, Itinerario).

permutaciones([], []).
permutaciones(Lugares, [Destino|Resto]):-
    select(Destino, Lugares, LugaresRestantes), 
    %elimina el destino ya elegido de la lista
    permutaciones(LugaresRestantes, Resto).
