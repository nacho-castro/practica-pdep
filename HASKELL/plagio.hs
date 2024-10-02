import Data.Char (toLower)

data Obra = Obra{
    titulo::String,
    anio::Int
}

data Autor = Autor{
    nombre::String,
    obras::[Obra]
}

--1. Modelar Obras
a = Obra "Había una vez un pato." 1997
b = Obra "¡Habia una vez un pato!" 1996
c = Obra "Mirtha, Susana y Moria." 2010
d = Obra "La semántica funcional del amoblamiento vertebral es riboficiente" 2020
e = Obra "La semántica funcional de Mirtha, Susana y Moria." 2022
f = Obra "Había una vez un pato." 1999

-- Algunos autores con sus obras
autor1 = Autor "Borges" [f]
autor2 = Autor "Jorge" [a]
autor3 = Autor "Cortazar" [b]

--2. Version cruda de un texto
quitarAcento :: Char -> Char
quitarAcento 'á' = 'a'
quitarAcento 'é' = 'e'
quitarAcento 'í' = 'i'
quitarAcento 'ó' = 'o'
quitarAcento 'ú' = 'u'
quitarAcento l = l

esLetra :: Char -> Bool
esLetra letra = letra `elem` ['a'..'z'] || letra `elem` ['A'..'Z'] || letra == ' '

quitarSignos :: String -> String
quitarSignos = filter esLetra

crudo::String->String
crudo = quitarSignos . map quitarAcento

--3. Plagios

--Hay diferentes tecnicas para detectar plagios
type Tecnica = Obra->Obra->Bool

esPosterior :: Tecnica
esPosterior obra1 = (anio obra1 >) . anio

--Verifica si es posterior y luego aplica la tecnica elegida
esPlagio :: Tecnica -> Obra -> Obra -> Bool
esPlagio tecnica plagio original = esPosterior plagio original && tecnica plagio original

--3.a
copiaLiteral :: Tecnica
copiaLiteral plagio original = crudo (titulo plagio) == crudo (titulo original)

--3.b
empiezaIgual :: Int -> Tecnica
empiezaIgual n plagio original = primerosCaract n (titulo plagio) (titulo original) && longitudMenor plagio original

primerosCaract :: Int -> String -> String -> Bool
primerosCaract n plagio original = take n plagio == take n original

longitudMenor :: Tecnica
longitudMenor plagio original = length (titulo plagio) < length (titulo original)

--3c
leAgregaronIntro::Tecnica
leAgregaronIntro plagio original = primerosCaract (length (titulo original)) (reverse (titulo plagio))  (reverse (titulo original))

--4
data Bot = Bot{
    fabricante::String,
    tecnicas::[Tecnica]
}

bot1 = Bot "Nokia" [copiaLiteral, empiezaIgual 10, leAgregaronIntro]
bot2 = Bot "Samsung" [copiaLiteral, empiezaIgual 30, leAgregaronIntro]

--5
detectarPlagio :: Bot -> Tecnica
detectarPlagio bot plagio original = any (\tecnica -> esPlagio tecnica plagio original) (tecnicas bot)

--6
plagioAOtro :: Bot -> Autor -> Autor -> Bool
plagioAOtro bot autor1 autor2 = any (\obra1 -> any (detectarPlagio bot obra1) (obras autor2)) (obras autor1)

cadenaPlagiadores::Bot->[Autor] ->Bool
cadenaPlagiadores _ [] = True
cadenaPlagiadores _ [_] = True
cadenaPlagiadores bot (autor1:autor2:autores) =
    plagioAOtro bot autor1 autor2 && cadenaPlagiadores bot (autor2:autores)

autoresQueAprendieron :: Bot -> [Autor] -> [Autor]
autoresQueAprendieron _ [] = []
autoresQueAprendieron bot autores =
    filter (\autor -> obrasPlagiadas bot autor autores == 1) autores

obrasPlagiadas::Bot->Autor->[Autor]->Int
obrasPlagiadas _ _ [] = 0
obrasPlagiadas bot autor1 (autor2:autores)
    | plagioAOtro bot autor1 autor2 = 1 + obrasPlagiadas bot autor1 autores
    | otherwise = obrasPlagiadas bot autor1 autores

--7
infinita = Obra ['a'..] 1990
--Haskell evalua en forma perezosa. 
--Cuando requiera hacer filter,length,map no terminara jamas la lista de caracteres.