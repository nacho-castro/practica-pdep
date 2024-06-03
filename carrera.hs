
data Auto = Auto{
    color::String,
    velocidad::Int,
    distancia::Int
}deriving(Show,Eq)

type Carrera = [Auto]

--1a
estaCerca::Auto->Auto->Bool
estaCerca auto1 auto2 = abs (distancia auto1 - distancia auto2) < 10 && color auto1 /= color auto2

menorSegunCriterio :: Ord a => (t -> a) -> t -> t -> Bool
menorSegunCriterio criterio auto1 auto2  = criterio auto1 < criterio auto2

mayorSegunCriterio :: Ord a => (t -> a) -> t -> t -> Bool
mayorSegunCriterio criterio auto1 auto2  = criterio auto1 > criterio auto2

--1b
mayorDistancia :: Carrera -> Int
mayorDistancia = maximum . map distancia

cercaDeNadie::Auto->Carrera->Bool
cercaDeNadie auto = not . any (estaCerca auto)

vaTranquilo::Auto->Carrera->Bool
vaTranquilo auto carrera = cercaDeNadie auto carrera && (distancia auto == mayorDistancia carrera)

--1c
puestoCarrera :: Auto ->Carrera ->Int
puestoCarrera auto carrera = 1 + cuantosLeVanGanando auto carrera

--Autos que le van ganando
cuantosLeVanGanando :: Auto -> Carrera -> Int
cuantosLeVanGanando auto = length . filter (menorSegunCriterio distancia auto)

--2a
type Tiempo = Int

correr :: Tiempo -> Auto -> Auto
correr tiempo auto = auto {distancia = distancia auto + (tiempo * velocidad auto)}

--2b
modificador::Int->Auto->Auto
modificador v1 auto = auto {velocidad = velocidad auto + v1}

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad cant auto = auto {velocidad = max (velocidad auto - cant) 0}

--3a
type PowerUp = Auto -> Carrera ->Carrera

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

terremoto :: PowerUp
terremoto auto = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50)

--3b
miguelitos :: Int -> PowerUp
miguelitos cant auto = afectarALosQueCumplen (mayorSegunCriterio distancia auto) (bajarVelocidad cant)

--3c
jetpack :: Tiempo -> PowerUp
jetpack tiempo auto = afectarALosQueCumplen (auto ==) (bajarVelocidad (velocidad auto `div` 2) . correr tiempo . modificador (velocidad auto))

--4a
type Color = String

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = zip [1..] (map color $ foldl (flip ($)) carrera eventos)

--4b I
correnTodos::Tiempo -> Carrera->Carrera
correnTodos tiempo = map (correr tiempo)

--4b II
encontrarAutoColor :: String -> Carrera -> Auto
encontrarAutoColor colorAuto = head . filter (\auto -> color auto == colorAuto)

usaPowerUp :: PowerUp -> Color -> Carrera -> Carrera
usaPowerUp power colorAuto carrera = flip power carrera . encontrarAutoColor colorAuto $ carrera

--4c
mario :: Auto
mario = Auto "rojo" 120 0
kart :: Auto
kart = Auto "blanco" 120 0
verstappen :: Auto
verstappen = Auto "azul" 120 0
fangio :: Auto
fangio = Auto "negro" 120 0
formula1 :: Carrera
formula1 = [mario,kart,fangio,verstappen]

listaEventos :: [Carrera -> Carrera]
listaEventos = [correnTodos 30, 
 usaPowerUp (jetpack 3) "azul" , 
 usaPowerUp terremoto "blanco", 
 correnTodos 40, 
 usaPowerUp (miguelitos 20) "blanco", 
 usaPowerUp (jetpack 6) "negro", 
 correnTodos 10]

--Es posible gracias a la funcionalidad de buscar auto por color. La abstraccion de afectarALosQueCumplen lo permite
misil :: Color -> Carrera -> Carrera
misil colorAuto carrera = afectarALosQueCumplen (== encontrarAutoColor colorAuto carrera) (bajarVelocidad 10) carrera

--