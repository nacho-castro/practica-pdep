import categoria.*
import bonos.*

object pepe {
  var property categoria = gerente
  var property bonoResultados = bonoPorcentaje
  var property bonoPresentismo = bonoNulo
  var property faltas = 0 

  method neto() = self.categoria().neto()
  method sueldo() = self.neto() + bonoResultados.monto(self) + bonoPresentismo.monto(self)
}

