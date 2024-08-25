%visitante(nombre,edad,dinero,hambre,aburrimiento).
visitante(eusebio, 80,3000,50,0).
visitante(carmela,80,0,0,25).

visitante(pedro,10,2000,20,0).
visitante(lara,20,1500,10,10).

esChico(Persona):-
    visitante(Persona,Edad,_,_,_),
    Edad < 13.

%grupo(nombre,integrante)
grupo(viejitos,eusebio).
grupo(viejitos,carmela).

%comida
precio(hamburguesa,2000).
precio(panchito,1500).
precio(lomito,2500).
precio(caramelos,0).

%atracciones
tranquila(autitos,familiar).
tranquila(tobogan,chicos).
tranquila(calesita,chicos).

intensa(barcoPirata,14).
intensa(tazasChinas,6).
intensa(simulador3D,2).

montania(abismo,3,tiempo(2,14)).
montania(paseoBosque,0,tiempo(0,45)).

%2
sumaEstado(Visitante, Total):-
    visitante(Visitante,_,_,Hambre,Aburrimiento).
    Total is Hambre + Aburrimiento.

estadoVisitante(Visitante,felicidadPlena):-
    grupo(_,Visitante),
    sumaEstado(Visitante,0).

estadoVisitante(Visitante,podriaMejorar):-
    sumaEstado(Visitante,Total),
    between(1, 50, Total).

estadoVisitante(Visitante,necesitaEntretenerse):-
    sumaEstado(Visitante,Total),
    between(51, 99, Total).
    
estadoVisitante(Visitante,seQuiereIr):-
    sumaEstado(Visitante,Total),
    Total >= 100.

%3
satisfacerHambre(Grupo,Comida):-
    grupo(Grupo,_),
    precio(Comida,_),
    forall(grupo(Grupo,Persona), puedePagar(Persona,Comida)),
    forall(grupo(Grupo,Persona), satisface(Persona,Comida)).

puedePagar(Persona,Comida):-
    precio(Comida,Precio),
    visitante(Persona,_,Dinero,_,_), 
    Dinero >= Precio.

satisface(Persona,hamburguesa):- %Menos de 50 de hambre
    visitante(Persona,_,_,Hambre,_),
    Hambre < 50.

satisface(Persona,panchito):- %A los chicos les gusta
    esChico(Persona).

satisface(Persona,lomito). %A todos les gusta

satisface(Persona,caramelos):- %No puede comprar ninguna otra comida
    visitante(Persona,_,_,_,_),
    not((puedePagar(Persona,Comida), Comida \= caramelos)). 
    
%4
lluviaHamburguesas(Visitante,Atraccion):-
    puedePagar(Visitante,hamburguesa),
    atraccionFuerte(Visitante,Atraccion).

atraccionFuerte(Visitante, intensa(_,Coeficiente)):-
    Coeficiente > 10.

atraccionFuerte(Visitante, tranquila(tobogan,_)).

atraccionFuerte(Visitante, montania(Montania,_,_)):-
    esPeligrosa(Visitante, Montania).
    
esPeligrosa(Visitante, MontaniaRusa):-
    visitante(Visitante,_,_,_,_),
    not(esChico(Visitante)),
    not(estadoVisitante(Visitante,necesitaEntretenerse)).
    mayorGiros(MontaniaRusa).

esPeligrosa(Visitante,MontaniaRusa):-
    esChico(Visitante),
    montania(MontaniaRusa,_,tiempo(Min,_)),
    Min >= 1.

mayorGiros(MontaniaMasGiros):-
    montania(MontaniaMasGiros, MayorGiros, _),
    forall((montania(Montania,Giros,_), Montania \= MontaniaMasGiros), Giros =< MayorGiros).

%5
