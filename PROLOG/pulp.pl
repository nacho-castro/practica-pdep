personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

%etc

%1
esPeligroso(Personaje):-
    actividadPeligrosa(Personaje).

esPeligroso(Personaje):-
    tieneEmpleadoPeligroso(Personaje).

tieneEmpleadoPeligroso(Personaje):-
    trabajaPara(Personaje,Empleado),
    esPeligroso(Empleado).

actividadPeligrosa(Personaje):-
    personaje(Personaje, ladron(Lugares)),
    member(licorerias, Lugares).

actividadPeligrosa(Personaje):-
    personaje(Personaje,mafioso(maton)).

%2
duoTemible(Uno,Otro):-
    esPeligroso(Uno),
    esPeligroso(Otro),
    relacion(Uno,Otro).

sonAmigos(Uno,Otro):-
    amigo(Uno,Otro);
    amigo(Otro,Uno).

sonPareja(Uno,Otro):-
    pareja(Otro,Uno);
    pareja(Uno,Otro).

relacion(Uno,Otro):-
    sonAmigos(Uno,Otro);
    sonPareja(Uno,Otro).

%3
estaEnProblemas(butch).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    encargo(Jefe,Personaje,cuidar(Pareja)),
    sonPareja(Jefe,Pareja).

estaEnProblemas(Personaje):-
    encargo(_,Personaje,buscar(Buscado,_)),
    personaje(Buscado,boxeador).

%4
tieneCerca(Persona,Otra):-
    sonAmigos(Persona,Otra).

tieneCerca(Persona,Otra):-
    trabajaPara(Persona,Otra).

sanCayetano(Persona):-
    tieneCerca(Persona,_),
    forall(tieneCerca(Persona,Otra), encargo(Persona,Otra,_)).

%5
masAtareado(Persona):-
    encargo(_,Persona,_),
    cantidadTareas(Persona,MayorCant),
    forall((encargo(_,Otro,_), Otro \= Persona), 
        (cantidadTareas(Otro,Cant), Cant =< MayorCant)).

cantidadTareas(Persona,Cantidad):-
    encargo(_,Persona,_),
    findall(Encargo,encargo(_,Persona,Encargo), Listado),
    length(Listado, Cantidad).

%6
personajesRespetables(Lista):-
    findall(Persona, esRespetable(Persona), Lista).

esRespetable(Personaje):-
    personaje(Personaje,Actividad),
    nivel(Actividad,Nivel),
    Nivel > 9.

nivel(actriz(Pelis), Nivel):-
    length(Pelis,Cant),
    Nivel is Cant // 10.

nivel(mafioso(resuelveProblemas), 10).
nivel(mafioso(maton), 1).
nivel(mafioso(capo), 20).

%7
hartoDe(Persona,Otro):-
    personaje(Persona,_),
    personaje(Otro,_),
    forall(encargo(_,Persona,Tarea), tareaRelacionada(Otro,Tarea)).

tareaRelacionada(Otro, cuidar(Otro)).
tareaRelacionada(Otro, ayudar(Otro)).
tareaRelacionada(Otro, buscar(Otro,_)).

tareaRelacionada(Otro,Tarea):-
    sonAmigos(Otro,Amigo),
    tareaRelacionada(Amigo,Tarea).