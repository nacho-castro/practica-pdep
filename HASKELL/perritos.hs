
--Parte A
data Perrito = Perrito{
    raza::String,
    juguetes::[String],
    tiempo::Int,
    energia::Int
}deriving(Show,Eq)

data Guarderia=Guarderia{
    nombre::String,
    rutina::[Actividad]
}

data Actividad = Actividad{
    ejercicio::Ejercicio,
    duracion::Int
}

type Ejercicio = Perrito -> Perrito

cambiarEnergia :: Int -> Ejercicio
cambiarEnergia energiaNueva perrito = perrito {
    energia = max 0 (energia perrito + energiaNueva)
}

jugar :: Ejercicio
jugar = cambiarEnergia (-10)

ladrar :: Int -> Ejercicio
ladrar ladridos = cambiarEnergia (ladridos `div` 2)

regalar :: String -> Ejercicio
regalar juguete perrito = perrito {
    juguetes = juguetes perrito ++ [juguete]
}

recargarEnergia :: Int -> Ejercicio
recargarEnergia cant perrito = perrito {
    energia = cant
}

esRazaExtravagante :: Perrito -> Bool
esRazaExtravagante perrito = raza perrito == "dalmata" || raza perrito == "pomeragia"

cumpleSpa :: Perrito -> Bool
cumpleSpa perrito = tiempo perrito >= 50 || esRazaExtravagante perrito

diaDeSpa :: Ejercicio
diaDeSpa perrito
 | cumpleSpa perrito = (regalar "peine" . recargarEnergia 100) perrito
 | otherwise = perrito

diaDeCampo :: Ejercicio
diaDeCampo perrito = perrito {
    juguetes = tail (juguetes perrito)
}

--Modelar
zara :: Perrito
zara = Perrito "dalmata" ["pelota","mantita"] 90 80

guarderia :: Guarderia
guarderia = Guarderia "PdePerritos" [
    Actividad jugar 30,
    Actividad (ladrar 18) 20,
    Actividad (regalar "pelota") 0,
    Actividad diaDeSpa 120,
    Actividad diaDeCampo 720]

--Parte B
tiempoRutina :: Guarderia -> Int
tiempoRutina = sum . map duracion . rutina

puedeEstarEnGuarderia :: Perrito -> Guarderia -> Bool
puedeEstarEnGuarderia perrito guarderia = tiempo perrito > tiempoRutina guarderia

superaJuguetes :: Int -> Perrito -> Bool
superaJuguetes n = (>n) . length . juguetes

perrosResponsables :: [Perrito] -> [Perrito]
perrosResponsables = filter (superaJuguetes 3) . map diaDeCampo

hacerActividad :: Guarderia -> Ejercicio
hacerActividad guarderia perro = foldl (flip ejercicio) perro (rutina guarderia)

realizarRutina :: Guarderia -> Ejercicio
realizarRutina guarderia perro
 | puedeEstarEnGuarderia perro guarderia = hacerActividad guarderia perro
 | otherwise = perro

energiaBaja :: Perrito -> Bool
energiaBaja perro = energia perro < 5

quedanCansados :: Guarderia -> [Perrito] -> [Perrito]
quedanCansados guarderia = filter energiaBaja . map (realizarRutina guarderia)

--Parte C
perropi = Perrito "labrador" sogasInfinitas 314 159

sogasInfinitas :: [String]
sogasInfinitas = ["soga " ++ show n | n <- [1..]]

--Si es posible
--esRazaExtravagante perropi --> False

--No podemos saberlo
--elem "hueso" (juguetes perropi) --> buscara eternamente

--No. La pelota se agrega al final de la lista infinita. 
buscarPelota :: Guarderia -> Perrito -> Bool
buscarPelota guarderia = elem "pelota" . juguetes . realizarRutina guarderia

--Si, elem solo busca lo necesario y corta. Funciona con "sogita n"
buscar :: String -> Perrito -> Bool
buscar item = elem item . juguetes

--Solo si se trata de rutinas que no manejen la lista infinita. Dia de campo lo impide porque toma el primer elemento 
--Si es posible realizar regalos. Los regalos se agregan al final de la lista de forma perezosa.

