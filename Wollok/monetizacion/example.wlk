//CONTENIDO
class Contenido{
  const property titulo
  var property vistas = 0
  var property ofensivo = false
  var property monetizacion

  method monetizacion(nuevaMonetizacion) {
    if(!nuevaMonetizacion.puedeAplicarse(self))
      throw new DomainException(message="Contenido no soportado")

    monetizacion = nuevaMonetizacion
  }

  method initialize(){
    if(!monetizacion.puedeAplicarse(self))
      throw new DomainException(message="Contenido no soportado")
  }

  method recaudacion() = monetizacion.recaudacion(self)
  method esPopular()
  method puedeVenderse() = self.esPopular()
  method recaudacionMaxima()
}

class Video inherits Contenido{
  override method recaudacionMaxima() = 10000
  override method esPopular() = self.vistas() > 10000
}

const tagsPopulares = ['pdep','love']
class Imagen inherits Contenido{
  const property tags = []

  override method recaudacionMaxima() = 4000

  override method esPopular() = 
    tagsPopulares.all{tag => tags.contains(tag)}
}

//MONETIZACION
object publicidad { //es un objeto

  method recaudacion(contenido) = 
  (contenido.vistas() * 0.5 + 
  if(contenido.esPopular()) 2000 else 0).min(contenido.recaudacionMaxima())
    
  method puedeAplicarse(contenido) = !contenido.ofensivo()
}
class Donacion { //es una clase porque debo manipular estado interno
  var property donaciones = 0
  method recaudacion(contenido) = donaciones

  method puedeAplicarse(contenido) = true
}

class Descarga {
  const property precio

  method initialize(){
    if(precio < 5) throw new DomainException(message="El minimo es 5!")
  }

  method recaudacion(contenido) = contenido.vistas() * precio

  method puedeAplicarse(contenido) = contenido.puedeVenderse()
}

class Alquiler inherits Descarga {
  const property tiempo
  override method precio() = 1.max(super())
  method puedeAplicarse(contenido) = super(contenido) && contenido.puedeAplicarse()
}

//USUARIO
class Usuario {
  var nombre
  var email
  var verificado = false
  const contenidos = []

  method saldoTotal() = contenidos.sum{contenido => contenido.recaudacion()}

  method verificar() {
    verificado = true
  }

  method esSuper() = contenidos
    .count{contenido => contenido.esPopular()} >= 10

  method publicatr(contenido) {
    contenidos.add(contenido)
  }
}

object usuarios {
  const todosUsuarios = []

  method emailsUsuariosRicos() = todosUsuarios
    .filter{usuario => usuario.verificado()}
    .sortedBy{uno, otro => uno.saldoTotal() > otro.saldoTotal()}
    .take(100)
    .map{usuario => usuario.email()}

  method cantSuperUsuarios() = todosUsuarios
    .count{usuario => usuario.esSuper()}
}