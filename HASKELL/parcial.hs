{-
Nombre: Castro Planas, Ignacio
Legajo: 213.579-6
-}

module Library where
import PdePreludat

----------------------------------------------
-- Código base provisto en el enunciado
----------------------------------------------

-- Función dada en el punto 4

f :: Ord a => (b -> a) -> c -> [ c -> b ] -> (c -> b)
f _ _ [x] = x
f g p (x:y:xs) | (g.x) p < (g.y) p = f g p (x : xs)
               | otherwise         = f g p (y : xs)

----------------------------------------------
-- Definí tus tipos de datos y funciones aquí
-- abajo, indicando a qué punto pertenecen
----------------------------------------------

--Modelar Peleadores
data Peleador = Peleador { 
    nombre :: String, 
    puntosVida::Number,
    resistencia :: Number, 
    ataques::[Ataque]
}deriving(Show,Eq)

type Ataque = Peleador -> Peleador

--1a
estaMuerto::Peleador->Bool
estaMuerto peleador = puntosVida peleador == 0

--1b
esHabil::Peleador->Bool
esHabil peleador = length (ataques peleador) > 10 && resistencia peleador > 15

--1c
perderVida:: Number -> Peleador -> Peleador
perderVida cant peleador = peleador {
    puntosVida = max 0 ((puntosVida peleador) - cant)
}

cambiarVida :: (Number -> Number) -> Peleador -> Peleador
cambiarVida modificador peleador = peleador{
    puntosVida = max 0 (modificador (puntosVida peleador))
}

--2a
golpe :: Number -> Ataque
golpe intensidad oponente = perderVida (intensidad `div` (resistencia oponente)) oponente

--2b
toqueMuerte :: Ataque
toqueMuerte oponente = perderVida (puntosVida oponente) oponente

--2c Patada
patada :: (Peleador -> Peleador) -> Ataque
patada parteCuerpo = perderResistencia 1 . parteCuerpo

perderResistencia:: Number -> Peleador -> Peleador
perderResistencia cant peleador = peleador {
    resistencia = max 0 ((resistencia peleador) - cant)
}

--2c Pecho
pecho oponente
 | estaMuerto oponente = cambiarVida (+1) oponente
 | otherwise = perderVida (10) oponente

--2c Carita
carita oponente = perderVida (puntosVida oponente `div` 2) oponente

--2c Nuca
nuca oponente = oponente {
    ataques = tail (ataques oponente)
}

--2d
triplicar :: Ataque -> [Ataque]
triplicar ataque = replicate 3 ataque

tripleAtaque :: Ataque -> Peleador -> Peleador
tripleAtaque ataque oponente = foldl (flip ($)) oponente (triplicar ataque)

--3
bruce = Peleador "Bruce Lee" 200 25 [toqueMuerte,golpe 500,patada nuca,tripleAtaque (patada carita), (voltereta 5)]

--La voltereta da vuelta los ataques del oponente y le quita resistencia
voltear::Ataque
voltear oponente = oponente {
    ataques = reverse (ataques oponente)
}

voltereta :: Number -> Ataque
voltereta cant =  (perderResistencia cant) . voltear

--4
--Se ingresa un criterio, un elemento y una lista de funciones que aplican sobre ese elemento.
--Devuelve la MENOR de las funciones de la lista, comparadas en base al criterio.

menorSegun :: Ord a => (b -> a) -> c -> [ c -> b ] -> (c -> b)
menorSegun _ _ [funcion] = funcion --Si hay solo una, nos devuelve esa
menorSegun criterio elemento (func1:func2:colafunciones) 
 | (criterio. func1) elemento  < (criterio. func2) elemento = menorSegun criterio elemento (func1 : colafunciones)
 | otherwise         = menorSegun criterio elemento (func2 : colafunciones)

--4b
--Devuelve el ataque que deja con menor puntos de vida
mejorAtaque:: Peleador -> Peleador -> Ataque
mejorAtaque peleador oponente = menorSegun puntosVida oponente (ataques peleador)

--5a I
cualesAtaquesTerribles::[Peleador]-> Peleador ->[Ataque]
cualesAtaquesTerribles enemigos = filter (\ataq -> esTerrible enemigos ataq) . ataques

--Ataque Terrible mata a mas de la mitad de enemigos
esTerrible enemigos ataque = ((length enemigos) `div` 2) < cuantosMata ataque enemigos

cuantosMata :: Ataque -> [Peleador] -> Number
cuantosMata ataque = length . filter (estaMuerto) . atacarTodos ataque 

atacarTodos :: Ataque-> [Peleador] -> [Peleador]
atacarTodos ataque = map ataque

--5a II
--Si es mortal, el ataque mata al enemigo
esMortal :: Peleador -> Ataque -> Bool
esMortal enemigo ataque = estaMuerto (ataque enemigo)

--Todos los ataques son mortales sobre un Enemigo
sonTodosMortales :: Peleador -> [Ataque] -> Bool
sonTodosMortales enemigo = all (esMortal enemigo)

--En un grupo de enemigos, alguno cumple sonTodosMortales
algunoTodosMortales :: [Ataque] -> [Peleador] -> Bool
algunoTodosMortales ataques = any (flip sonTodosMortales ataques) 

--El peleador es habil y sus ataques son todos mortales para algun enemigo
esPeligroso peleador enemigos = esHabil peleador && algunoTodosMortales (ataques peleador) enemigos

--5a III
--Primeros 10 enemigos habiles
primerosHabiles :: Number -> [Peleador] -> [Peleador]
primerosHabiles n = take n . filter (esHabil) 

--Lista de los mejores ataque de cada enemigo
mejoresAtaquesContra :: Peleador -> [Peleador] -> [Ataque]
mejoresAtaquesContra peleador = map (flip mejorAtaque peleador)

--El peleador es atacado por los mejores ataques de los 10 primeros habiles
serAtacado :: Peleador -> [Peleador] -> Peleador
serAtacado peleador = foldl (flip ($)) peleador . (mejoresAtaquesContra peleador) . primerosHabiles 10 

esInvencible :: Peleador -> [Peleador] -> Bool
esInvencible peleador = (puntosVida peleador ==) . puntosVida . serAtacado peleador 

--5b
--Haskell evalua de forma perezosa, esto quiere decir que deja hasta el final las funciones, evaluando de afuera hacia adentro.
--Ej: head [1..]  Toma el primer elemento sin calcular la lista infinita!

--En el 5a I: cualesAtaquesTerribles [enemigo..] peleador
--No podra terminar. Haskell ira posponiendo funciones hasta llegar a "atacarTodos" y tendra que MAPEAR la lista infinita. 

--En el 5b II: esPeligroso 
--SI podra terminar apenas encuentre un enemigo que cumpla con la condicion sonTodosMortales.
--Si ningun enemigo cumple, quedara corriendo infinitamente

--En el 5b III: esInvencible 
--SI podra terminar ya que solo toma los primeros 10 enemigos de la lista infinita. Luego evalua normalmente con esos 10.
--Si ningun enemigo es habil, quedara corriendo infinitamente