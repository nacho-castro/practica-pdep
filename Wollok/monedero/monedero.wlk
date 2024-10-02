class UserException inherits wollok.lang.Exception {}
class Monedero{
  var property saldo

  method depositar(cantidad) {
    self.validarMonto(cantidad)
    saldo += cantidad
  } 

  method retirar(cantidad){
	self.validarMonto(cantidad)
    if(cantidad > saldo){
      throw new UserException(message = "Debe sacar menos de " + saldo)
    }
    saldo -= cantidad
  }
  
  method validarMonto(cantidad) {
	if (cantidad < 0) {
		throw new UserException(message = "La cantidad debe ser positiva")
	}
	}
}