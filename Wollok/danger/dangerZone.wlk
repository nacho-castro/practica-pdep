class Empleado {
  var salud
  const property habilidades = []
  var property puesto 

  method incapacitado() = salud < puesto.saludCritica()
  method puedeUsar(habilidad) = 
    habilidades.contains(habilidad) && !self.incapacitado()
  
  method recibirDanio(cant){
    salud -= cant
  }

  method finalizarMision(mision){
    if(salud > 0){
      puesto.completarMision(mision,self)
    }
  }
  
}
class Jefe inherits Empleado{
  var property subordinados
	override method puedeUsar(habilidad) 
		= super(habilidad) || self.algunSubordinadoPuedeUsar(habilidad)
	
	method algunSubordinadoPuedeUsar(habilidad)
		= subordinados.any {subordinado => subordinado.puedeUsar(habilidad)	}
}
object espia {
  method saludCritica() = 15

  method completarMision(mision, empleado) {
    const habilidadesNuevas = mision
      .habilidadesRequeridas()
      .filter({habNueva => !empleado.habilidades().contains(habNueva)})

    empleado.habilidades().add(habilidadesNuevas)
    }
}
class Oficinista {
  var property cantEstrellas
  method saludCritica() = 40 - 5*cantEstrellas

  method completarMision(mision,empleado) {
    cantEstrellas += 1
    if (cantEstrellas == 3) {
			empleado.puesto(espia)
		}
  }
}
class Equipo {
  const integrantes = []

  method puedeUsar(habilidad) = integrantes
    .any({integrante => integrante.puedeUsar(habilidad)})
  
  method recibirDanio(cant){
    integrantes
    .forEach({integrante => integrante.recibirDanio(cant/3)})
  }

  method finalizarMision(mision){
    integrantes
    .forEach({integrante => integrante.finalizarMision(mision)})
  }
}
class Mision {
  const property habilidadesRequeridas = []
  const property peligrosidad 

  method cumplirMision(asignado){
    if(self.puedeHacerMision(asignado)){
      asignado.recibirDanio(peligrosidad)
      asignado.finalizarMision(self)
    } else {
      self.error("La misión no se puede cumplir")
    }
  }

  method puedeHacerMision(asignado) =
    habilidadesRequeridas.all({habilidad => asignado.puedeUsar(habilidad)})
}