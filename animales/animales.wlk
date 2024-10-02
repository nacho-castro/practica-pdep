class Vaca {
    var property peso
    var property tieneSed = false
    method tieneHambre() = peso < 200  

    var property vacunas = 0
    method puedeVacunarse() = vacunas == 0

    method comer(kilos){
        peso += kilos/3
        tieneSed = true
    } 

    method beber(){
        peso -= 0.5
        tieneSed = false
    }
}

class Cerdo {
    var property peso
    var cantComioSinBeber = 0
    var property tieneHambre = true

    var property vacunas = 0
    method puedeVacunarse() = true

    method tieneSed() = cantComioSinBeber > 3

    method comer(kilos){
        peso += (kilos - 0.2).max(0)
        if(kilos >= 1){
            tieneHambre = false
        }
        cantComioSinBeber += 1
    } 

    method beber(){
        tieneHambre = true
        cantComioSinBeber = 0
    } 
}

class Gallina {
    method peso() = 4
	method tieneHambre() = true
	method tieneSed() = false

    var property vacunas = 0
    method puedeVacunarse() = false
	
	method beber(){
		// Cuando bebe no se observa ningún cambio.
	}
	method comer(kilos){
		// Cuando come no se observa ningún cambio.
	}
}

class Bebedero {
    method consumo() = 10 
    method esUtil(animal) = animal.tieneSed()

    method atender(animal){
        animal.beber()
    }
}

class Comedero {
    const property cantidad 
    const pesoSoportado 
    method consumo() = 20*pesoSoportado 

    method esUtil(animal) = 
        animal.tieneHambre() && animal.peso() <= pesoSoportado

    method atender(animal){
    if(animal.peso() > pesoSoportado)
        self.error("Demasiado pesado")
    animal.comer(cantidad)
    }
}

class Vacunatorio {
    method consumo() = if(dosis > 0) 50 else 0
    var property dosis = 0 

    method recargarDosis(cantidad) {
      dosis += cantidad
    }

    method esUtil(animal) = animal.puedeVacunarse() && dosis > 0

    method atender(animal){
        animal.vacunas(animal.vacunas() + 1)
        dosis -= 1
    }
}

object colecciones{
    const todosLosAnimales = [
        new Cerdo(peso = 75),
        new Vaca(peso = 250),
        new Gallina()
    ]

    method todosTienenHambre() = 
        todosLosAnimales.all({animal => animal.tieneHambre()})
    
    method quienTieneSed() =
        todosLosAnimales.filter({animal => animal.tieneSed()})
    
    method sumaPesos() = 
        todosLosAnimales.map({animal => animal.peso()}).sum()

    method masPesado() = 
        todosLosAnimales.max({animal => animal.peso()})

    method algunoPesaMasDe(parametro) =
        todosLosAnimales.find({animal => animal.peso() > parametro})
    
    method todosComen(kilos) =
        todosLosAnimales.forEach({animal => animal.comer(0.3)})
    //obtener resultado por cada elemento => map
    //producir efecto por cada elemento => forEach
}