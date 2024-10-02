class Vaca {
    var property peso
    var property tieneSed
    method tieneHambre() = peso < 200  

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
    var cantComioSinBeber
    var property tieneHambre = true

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
	
	method beber(){
		// Cuando bebe no se observa ningún cambio.
	}
	method comer(kilos){
		// Cuando come no se observa ningún cambio.
	}
}

class Bebedero {
    method esUtil(animal) = animal.tieneSed()

    method darBeber(animal) = animal.beber()
}

class Comedero {
    const property cantidad 
    const pesoSoportado 

    method esUtil(animal) = 
        animal.tieneHambre() && animal.peso() <= pesoSoportado

    method darComer(animal){
    if(animal.peso() > pesoSoportado)
        self.error("Demasiado pesado")
    animal.comer(cantidad)
    }
}

object Colecciones{
    var todosLosAnimales = []

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