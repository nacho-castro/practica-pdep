import example.*
class Pirata {
  const property objetos = []
  var property nivelEbriedad
  var property monedas

  method esUtil(mision) = mision.esUtil(self) //punto1
  method tieneItem(item) = objetos.contains(item)

  method pasadoDeGrog() = nivelEbriedad > 90 
    && self.tieneItem("botellaGrog")

  method seAnimaASaquear(victima) = victima.puedeSerSaqueadoPor(self)
  
  //5
  method puedePagar(precio) = monedas >= precio

  method aumentarEbriedad(cant) {
    nivelEbriedad += cant
  }

  method gastarMonedas(cant) {
    if(not self.puedePagar(cant)){
      self.error("Dinero insuficiente")
    }
    monedas -= cant
  }
  
}
class BarcoPirata {
  var property mision
  const property capacidad
  var property tripulantes = []

  method cantTripulantes() = tripulantes.size()

  method puedeRealizarMision() = mision.puedeRealizar(self)

  method puedeSerSaqueadoPor(pirata) = pirata.pasadoDeGrog()
  
  method esVulnerable(barcoAtacante) = 
    (barcoAtacante.cantTripulantes() / 2) >= self.cantTripulantes()

  method tripulacionPasadaDeGrog() = tripulantes.all({tripulante => tripulante.pasadoDeGrog()})

  //2a
  method puedeEntrar(pirata) = pirata.esUtil(mision) 
    && capacidad > self.cantTripulantes() 

  //2b
  method incorporar(pirata){
    if(not self.puedeEntrar(pirata)){
      self.error("No se puede incorporar")
    }
    tripulantes.add(pirata)
  }

  //2c
  method mision(misionNueva){
    mision = misionNueva
    tripulantes = tripulantes
      .filter({tripulante => tripulante.esUtil(misionNueva)})
  }

  //3
  method esTemible() = self.puedeRealizarMision() 
    && tripulantes.count({tripulante => tripulante.esUtil(mision)}) > 5

  //5
  method tripulanteMasEbrio() = tripulantes.max({trip => trip.nivelEbriedad()})
  
  method anclarEn(ciudadCostera) {
    tripulantes
    .filter({trip => trip.puedePagar(ciudadCostera.costoBebida())})
    .forEach({trip => trip.aumentarEbriedad(5)})
    .forEach({trip => trip.gastarMonedas(ciudadCostera.costoBebida())})
    
    const elMasEbrio = self.tripulanteMasEbrio()
 		tripulantes.remove(elMasEbrio)
 		ciudadCostera.sumarHabitante(elMasEbrio)
  }
}
class CiudadCostera {
  var property habitantes = 0
  const property costoBebida

  method esVulnerable(barco) = 
  barco.cantTripulantes() >= self.habitantes()*0.4 
    || barco.tripulacionPasadaDeGrog()

  method puedeSerSaqueadoPor(pirata) = pirata.nivelEbriedad() >= 50

  method sumarHabitante(pirata){
    habitantes += 1
  }
}
class Mision {
  method esUtil(pirata)
  method puedeRealizar(barco) = barco.tripulantes().size() / barco.capacidad() >= 0.9
}

class BusquedaTesoro inherits Mision{
  override method esUtil(pirata)
 		= self.tieneAlgunItemUtil(pirata) && pirata.monedas() <= 5
 	method tieneAlgunItemUtil(pirata) =
 		#{"brujula", "mapa", "botellaGrog"}.any({item => pirata.tieneItem(item)})

  override method puedeRealizar(barco) = super(barco) 
    && barco.tripulantes().any({tripulante => tripulante.tieneItem("llaveCofre")})
}

class ConvertirseLeyenda inherits Mision{
  const objObligatorio

  override method esUtil(pirata) = 
    (pirata.objetos().size() >= 10) 
      && pirata.objetos().contains(objObligatorio)
}
class Saqueo inherits Mision{
  const victima
  var property maximoMonedas 

  override method esUtil(pirata) = pirata.monedas() < maximoMonedas 
    && victima.puedeSerSaqueadoPor(pirata)

  override method puedeRealizar(barco) = super(barco) && victima.esVulnerable(barco)
}
