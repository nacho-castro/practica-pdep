//PERSONAJES
class Personaje{
  const property fuerza
  const property inteligencia
  var property rol

  method potencialOfensivo() = fuerza*10 + rol.extra()  

  method esGroso() = self.esInteligente() || rol.esGroso(self)

  method esInteligente()
}

class Orco inherits Personaje{
  override method potencialOfensivo() = super()*1.1

  override method esInteligente() = false 
}

class Humano inherits Personaje{
  override method esInteligente() = inteligencia > 50 
}

//ROLES
class Guerrero {
  method extra() = 100

  method esGroso(personaje) = personaje.fuerza() > 50
}

class Brujo {
  method extra() = 0

  method esGroso(personaje) = true
}
class Cazador {
  var property mascota

  method extra() = mascota.potencialOfensivo()

  method esGroso(personaje) = mascota.esLongeva()
}
class Mascota {
  var property fuerza
  var property edad
  var property tieneGarras

  method potencialOfensivo() = if(tieneGarras) fuerza*2 else fuerza

  method esLongeva() = edad > 10
}

//ZONAS
class Ejercito{
  var property miembros = []
  method potencialOfensivo() = miembros.sum({miembro => miembro.potencialOfensivo()})

  method invadir(zona){
    if(self.potencialOfensivo() > zona.potencialDefensivo()){
      zona.serOcupada(self)
    }
  }

  method diezMejores() = miembros
    .sortedBy({m1,m2 => m1.potencialOfensivo() > m2.potencialOfensivo()}) 
    .take(10)
}

class Zona {
  var property habitantes = []

  method potencialDefensivo() = habitantes.sum({hab => hab.potencialOfensivo()})

  method serOcupada(ejercito) {
    habitantes = ejercito.miembros()
  }
}
class Ciudad inherits Zona{
  override method potencialDefensivo() = super()+300
}
class Aldea inherits Zona{
  const maxHabitantes

  override method serOcupada(ejercito) {
    if(ejercito.miembros().size() > maxHabitantes){
        const nuevosHabitantes = ejercito.diezMejores()
        super(new Ejercito(miembros = nuevosHabitantes))
        ejercito.miembros().removeAll(nuevosHabitantes)
    } else super(ejercito)
  }
}
