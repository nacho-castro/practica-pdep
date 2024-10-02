//Parte2
class Estacion {
    const property dispositivos = []

    method quitarDispositivo(dispositivo){
        dispositivos.remove(dispositivo)
    }

    method agregarDispositivo(dispositivo){
        dispositivos.add(dispositivo)
    }

    method consumoTotal() = 1.1*dispositivos
        .sum({dispositivo => dispositivo.consumo()})

    method puedeAtenderse(animal) = 
        dispositivos.any({dispositivo => dispositivo.esUtil(animal)})
    
    method dispositivosUtiles(animal) = 
        dispositivos.filter({dispositivo => dispositivo.esUtil(animal)})

    method atencionBasica(animal) {
      self.validarAtencion(animal)

      self.dispositivosUtiles(animal)
        .min({dispositivo => dispositivo.consumo()}).atender(animal)
    }

    method atencionCompleta(animal) {
      self.validarAtencion(animal)

      self.dispositivosUtiles(animal)
        .forEach({dispositivo => dispositivo.atender(animal)})
    }

    method validarAtencion(animal){
        if(not self.puedeAtenderse(animal))
            self.error("No puede atenderse")
    }

}