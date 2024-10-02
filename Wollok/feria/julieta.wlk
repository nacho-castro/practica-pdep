object julieta {
  var property tickets = 15
  var cansancio = 0
  
  //getter
  method cansancio() = cansancio

  method punteria() = 20

  method fuerza() = 80 - cansancio
  
  //setter
  method cansancio(valor) {
    cansancio = valor
  }

  method jugar(juego) {
    tickets = tickets + juego.ganarTickets(self)
    cansancio = cansancio + juego.cansancioProducido()
  }

}

object tiroAlBlanco {
  method ganarTickets(jugador) = (jugador.punteria() / 10).roundUp()
  method cansancioProducido() = 3
}

object pruebaFuerza {
  method ganarTickets(jugador) = if(jugador.fuerza() > 75) 20 else 0
  method cansancioProducido() = 8
}

object ruedaFortuna {
  var property aceitada = true

  method ganarTickets(jugador) = 0.randomUpTo(20).roundUp()
  method cansancioProducido() = if(aceitada) 0 else 1
}