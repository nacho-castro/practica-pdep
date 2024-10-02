object tom {
  var property energia = 80
  method velocidad() = 5 + (energia/10)

  method comer(raton){
    energia += self.energiaQueGanaria(raton)
  }

  method correr(segundos){
    energia -= self.energiaQuePerderia(self.cantidadMetros(segundos))
  }

  method cantidadMetros(segundos) = segundos * self.velocidad()

  method leConvieneComer(raton, metros) 
    = self.velocidad() > raton.velocidad() && 
      self.energiaQueGanaria(raton) > self.energiaQuePerderia(metros)
  
  method energiaQueGanaria(raton) = 12 + raton.peso()
  method energiaQuePerderia(metros) = 0.5 * metros

}
object jerry {
  var property velocidad = 1
  const property peso = 5

  method acelerar() {
    velocidad = velocidad * 1.5
  }
}

