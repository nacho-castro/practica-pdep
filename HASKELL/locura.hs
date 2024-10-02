data Investigador = Investigador{
    nombre::String,
    cordura::Int,
    items::[Item],
    sucesosEvitados::[String]
}deriving(Show,Eq)

data Item = Item{
    nombreItem::String,
    valor::Int
}deriving(Show,Eq)

maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
 |f a > f b = a
 |otherwise = b

deltaSegun ponderacion transformacion valor =
    abs ((ponderacion . transformacion) valor - ponderacion valor)

--1a que investigador se enloquezca
enloquezca :: Int -> Investigador -> Investigador
enloquezca puntos investigador =
    investigador{
        cordura = max (cordura investigador - puntos) 0}

--1b que investigador halle item
hallarItem :: Item -> Investigador -> Investigador
hallarItem item = enloquezca (valor item) . agregarItem item

agregarItem :: Item -> Investigador -> Investigador
agregarItem item investigador = investigador {
    items = items investigador ++ [item]
}

--2 Buscar item por nombre
buscarItem :: String -> [Investigador] -> Bool
buscarItem nombreI = any (elem nombreI . map nombreItem . items)

--2' Buscar item
buscarItem' :: Item -> [Investigador] -> Bool
buscarItem' item = any (elem item . items)

--3
potencial :: Investigador -> Int
potencial investigador
    | cordura investigador == 0 = 0
    | otherwise = (cordura investigador * experiencia investigador) + valorMaximoItem (items investigador)

experiencia :: Investigador -> Int
experiencia  = (1+) . (3*) . cantSucesos

cantSucesos :: Investigador -> Int
cantSucesos = length . sucesosEvitados

--Valor maximo de los items que tiene
valorMaximoItem :: [Item] -> Int
valorMaximoItem [] = 0 --Si no hay items es cero
valorMaximoItem items = valor (maximoSegun valor items)

--Lider es quien tiene el potecial mas alto
determinarLider :: [Investigador] -> Investigador
determinarLider = maximoSegun potencial

--4 Deltas
corduraTotal ::[Investigador] -> Int
corduraTotal = sum . map cordura

deltaCordura :: Int -> Investigador -> Int
deltaCordura puntos = deltaSegun cordura (enloquezca puntos)

eliminarLocos :: [Investigador] -> Investigador
eliminarLocos = head . filter ((/= 0) . cordura)

--5 SUCESOS
type Consecuencia = [Investigador]->[Investigador]

data Suceso = Suceso{
    descripcion::String,
    consecuencias::[Consecuencia],
    evitarSuceso::[Investigador]->Bool
}

--5b. Modelar Consecuencias
enloquecerTodos::Int->Consecuencia
enloquecerTodos puntos = map (enloquezca puntos)

primeroHallarItem :: Item ->Consecuencia
primeroHallarItem item (investigador:resto) = hallarItem item investigador : resto

eliminarInvestigadores:: Int->Consecuencia
eliminarInvestigadores = drop

--Ejemplos:
despertarAntiguo = Suceso "despertar antiguo" [enloquecerTodos 10, eliminarInvestigadores 1] (buscarItem "necromicron")
daga = Item "daga maldita" 3
ritual = Suceso "ritual innsmouth" [primeroHallarItem daga, enloquecerTodos 2,enfrentarSuceso despertarAntiguo] ((100 <). potencial . determinarLider)

------
--6 
------

--Primero enloquecen todos en 1 punto, luego el suceso
enfrentarSuceso ::Suceso -> Consecuencia
enfrentarSuceso suceso = atravesarSuceso suceso . enloquecerTodos 1

--Sufren las consecuencias
atravesarSuceso :: Suceso -> Consecuencia
atravesarSuceso suceso investigadores
    | evitarSuceso suceso investigadores = agregarSuceso suceso investigadores
    | otherwise = sufrirConsecuencias suceso investigadores

sufrirConsecuencias :: Suceso -> Consecuencia
sufrirConsecuencias suceso investigadores = 
    foldl (flip ($)) investigadores (consecuencias suceso)

--Si lo evitan, lo agregan a su lista
agregarSuceso :: Suceso -> Consecuencia
agregarSuceso suceso = map (\inv -> inv { sucesosEvitados = descripcion suceso : sucesosEvitados inv })

--7