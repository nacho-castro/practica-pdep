modelo(Modelo):-
    palabra(_,Modelo,_).

%palabra(Palabra,Modelo,Valor).
palabra(perro,pgt,2112).
palabra(perro,piscis,2510).
palabra(perro,pongAi,2112).

palabra(gato,pgt,2215).
palabra(gato,piscis,2215).
palabra(gato,pongAi,2215).

palabra(perro,pgt,2112).
palabra(perro,piscis,2510).
palabra(perro,pongAi,2112).

palabra(morfi,pgt,2452).

% Morfi no existe en PongAI y por el principio del Universo Cerrado todo lo que no este
% en la base de conocimientos se considera como falso. Por lo tanto, no agrego esta
% informacion a mi base de conocimientos. 

%2
noLaSabeNadie(Palabra):-
    not((modelo(Modelo), palabra(Palabra,Modelo,_))).
    % no existen modelos IA que sepan esa palabra

%3
palabraDificil(Palabra):-
    palabra(Palabra,_,_),
    not((
        palabra(Palabra,Modelo1,_),
        palabra(Palabra,Modelo2,_),
        Modelo1 \= Modelo2
        )).

%4
diferenciaModelo(Palabra1,Palabra2,Modelo,Diferencia):-
    palabra(Palabra1,Modelo,Valor1),
    palabra(Palabra2,Modelo,Valor2),
    Diferencia is abs(Valor2 - Valor1).

cercania(Palabra1,Palabra2,Modelo,Valor):-
    diferenciaModelo(Palabra1,Palabra2,Modelo,Diferencia),
    Diferencia < Valor.

%4
cercanas(Palabra1,Palabra2,Modelo):-
    cercania(Palabra1,Palabra2,Modelo,200).

%5
sinonimo(Palabra1,Palabra2,Modelo):-
    cercania(Palabra1,Palabra2,Modelo,20).

sinonimo(cosito,Palabra,Modelo):-
    palabra(Palabra,Modelo,Valor),
    between(1800, 2100, Valor).

% Paradigmas no tiene sinonimo, y al no agregarla a mi base de conocimientos, siempre 
% que se consulte sobre esta palabra dara falso, por el principio del Universo Cerrado.

%6
menosBot(Palabra1,Palabra2,Modelo):-
    diferenciaModelo(Palabra1,Palabra2,Modelo,MenorDiferencia),
    forall((
        diferenciaModelo(Palabra1,Palabra2,OtroModelo,Diferencia),
        OtroModelo \= Modelo
        ),
        Diferencia > MenorDiferencia).

%7
comodin(Palabra,Modelo):-
    palabra(Palabra,Modelo,_),
    cantidadSinonimos(Palabra,Modelo,MayorCant),
    forall((cantidadSinonimos(OtraPalabra,Modelo,Cant), 
            Palabra \= OtraPalabra),
            Cant =< MayorCant).
    
cantidadSinonimos(Palabra,Modelo,Cantidad):-
    palabra(Palabra,Modelo,_),
    findall(Sinonimo, sinonimo(Palabra,Sinonimo,Modelo), Sinonimos),
    length(Sinonimos, Cantidad).

%8
perfil(pedro, programador(ruby, 5)).
perfil(maria, estudiante(programacion)).
perfil(sofia, estudiante(psicologia)).
perfil(juan, hijoDePapi).

palabrasRelevantes(Palabra,Modelo,Persona):-
    perfil(Persona,Perfil),
    palabra(Palabra,Modelo,_),
    esRelevante(Palabra,Modelo,Perfil).

esRelevante(Palabra,Modelo,programador(Lenguaje,Exp)):-
    Cercania is 50*Exp,
    cercania(Palabra,Lenguaje, Modelo, Cercania).

esRelevante(Palabra,Modelo,estudiante(programacion)):-
    esRelevante(Palabra,Modelo,programador(wollok,1)).

esRelevante(Palabra,Modelo,estudiante(Carrera)):-
    cercania(Palabra, Carrera, Modelo, 200).

esRelevante(Palabra,Modelo,hijoDePapi):-
    sinonimo(Palabra,guita,Modelo).

%9
gusta(juan, plata).
gusta(maria, joda).
gusta(maria, tarjeta).
gusta(inia, estudiar).
gusta(bauti, utn).
gusta(martin, comer).

relacionado(plata, gastar).
relacionado(gastar, tarjeta).
relacionado(tarjeta, viajar).
relacionado(estudiar, utn).
relacionado(utn, titulo).
relacionado(tarjeta, finanzas).

hayRelacion(Palabra,Otra):-
    relacionado(Palabra,Otra).

hayRelacion(Palabra,Otra):-
    relacionado(Palabra,Tercera),
    hayRelacion(Tercera,Otra).

interesa(Persona,Palabra):-
    gusta(Persona,Palabra).

interesa(Persona,Palabra):-
    gusta(Persona,OtraPalabra),
    hayRelacion(OtraPalabra,Palabra).

