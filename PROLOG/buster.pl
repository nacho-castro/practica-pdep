herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

%1
tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(winston,varitaNeutrones).

%2
satisface(Persona,Herramienta):-
    tiene(Persona, Herramienta).

satisface(Persona,aspiradora(NivelRequerido)):-
    tiene(Persona,aspiradora(Nivel)),
    between(0, Nivel, NivelRequerido).

%6
satisface(Persona,ListaOpciones):-
    member(Herramienta,ListaOpciones),
    satisface(Persona,Herramienta). %al menos una cumple

%3
puedeRealizar(Persona,Tarea):-
    herramientasRequeridas(Tarea,_),
    tiene(Persona,varitaNeutrones).

puedeRealizar(Persona,Tarea):-
    tiene(Persona,_),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(HerramientaRequerida, Herramientas), 
        satisface(Persona, Herramienta)).

%4
%tareaPedida(Cliente,Tarea,Metros).
tareaPedida(juan,limpiarBanio,10).

%precio(Tarea,Valor).
precio(limpiarBanio,5).

montoACobrar(Cliente,MontoTotal):-
    tareaPedida(Cliente,_,_),
    findall(Costo, costoTarea(Cliente,_,Costo), ListaCostos),
    sum_list(ListaCostos, MontoTotal).

costoTarea(Cliente,Tarea,Costo):-
    tareaPedida(Cliente,Tarea,Metros),
    precio(Tarea,PrecioMetro),
    Costo is PrecioMetro * Metros.

%5
tareaCompleja(limpiarTecho).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.

aceptarianPedido(Integrante,Cliente):-
    puedeHacerPedido(Integrante,Cliente),
    dispuesto(Integrante,Cliente).

puedeHacerPedido(Trabajador,Cliente):-
    tareaPedida(Cliente,_,_),
    tiene(Trabajador,_),
    forall(tareaPedida(Cliente,Tarea,_), puedeRealizar(Trabajador,Tarea)).

dispuesto(peter,_).

dispuesto(ray,Cliente):-
    not(tareaPedida(Cliente,limpiarTecho,_)).

dispuesto(winston,Cliente):-
    montoACobrar(Cliente,Monto),
    Monto >= 500.

dispuesto(egon,Cliente):-
    not((tareaPedida(Cliente,Tarea,_), 
        tareaCompleja(Tarea))).

%6


    


    