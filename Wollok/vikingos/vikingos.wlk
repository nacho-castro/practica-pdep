class Vikingo {
  var property profesion
  var property casta
  var property oro = 0 
  var property armas
  var property vidasCobradas
  var property cantHijos
  var property cantHectareas

  method puedeSubir(expedicion) = 
    profesion.productivo(self) && casta.puedeIr(self)
  
  method tieneArmas() = armas > 0

  method cobrarVida(){vidasCobradas += 1}

  method ascender(){casta.ascender(self)}

  method ganar(monedas){
		oro += monedas
	}

  method sumarHectareas(cant){cantHectareas += cant}
  method sumarHijos(cant){cantHijos += cant}
  method sumarArmas(cant){armas += cant}
}

class Jarl{
  method puedeIr(vikingo) = !vikingo.tieneArmas()
  method ascender(vikingo){
    vikingo.casta(new Karl())
    vikingo.profesion().bonificar()
  }
}

class Karl {
  method puedeIr(vikingo) = true
  method ascender(vikingo){
    vikingo.casta(new Thrall())
  }
}

class Thrall{
  method puedeIr(vikingo) = true
  method ascender(vikingo){}
}

class Granjero {
  method productivo(vikingo) = 
    vikingo.cantHectareas() / vikingo.cantHijos() >= 2
  
  method bonificar(vikingo){
    vikingo.sumarHijos(2)
    vikingo.sumarHectareas(2)
  }  
}

class Soldado {
  method productivo(vikingo) = 
    vikingo.vidasCobradas() > 20 && vikingo.tieneArmas()
  
  method bonificar(vikingo){
    vikingo.sumarArmas(10)
  }  
}

class Expedicion {
  var property integrantes = []
  var objetivos 

  method subir(vikingo){ 
    if(vikingo.puedeSubir(self)){
      integrantes.add(vikingo)
    } else {
      self.error("El vikingo no puede subir")
    }
  }

  method valeLaPena() = 
    objetivos.all{objetivo => objetivo.loVale(integrantes)}

  method invadir(){
    objetivos.forEach{objetivo => objetivo.serInvadido(integrantes)}
  }
}

class Capital{
  var property defensores
  var property factorRiqueza 

  method botin(atacantes) = self.defensoresDerrotados(atacantes) * factorRiqueza
  method loVale(atacantes) = self.botin(atacantes) / atacantes.size() >= 3
  
  method serInvadido(atacantes){
    atacantes.forEach({vikingo => vikingo.cobrarVida()})
  }    

  method defensoresDerrotados(atacantes) = defensores.min(atacantes.size())
}

class Aldea {
  var property cantCrucifijos 
  method botin(atacantes) = cantCrucifijos
  method loVale(atacantes) = self.botin(atacantes) >= 15
  method serInvadido(atacantes){
  }    
}
class AldeaAmurallada inherits Aldea {
	var minimosVikingos

	override method loVale(atacantes) = 
    atacantes.size() >= minimosVikingos && super(atacantes)
}

