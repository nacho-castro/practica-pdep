//Bonos Resultados
object bonoPorcentaje{
    method monto(empleado) = empleado.neto() * 0.1 
}

object bonoFijo{
    method monto(empleado) = 800
}

object bonoNulo{
    method monto(empleado) = 0
}

//Bonos Presentismo
object bonoAjuste{
    method monto(empleado) = if(empleado.faltas() == 0) 100 else 0
}

object bonoNormal{
    method monto(empleado){
        if(empleado.faltas() == 0){
            return 2000
        } else  if(empleado.faltas() == 1) {
            return 1000
        } else {
            return 0
        }
    }
}

object bonoDemagogico{
    method monto(empleado){
        if(empleado.neto() < 18000){
            return 500
        } else {
            return 300
        }
    }
}