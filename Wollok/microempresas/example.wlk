//MICROS
class Micro {
  const property sentados
  const property parados   
  const property volumen 

  method puedeSubir(persona) = persona.subirse(self)
}

//PERSONAS
class Empleado {
  const property tipo
  const property jefe
  
  method subirse(micro) = tipo.quiereSubir(micro)
}

//TIPOS
object apurado{
  method quiereSubir(micro) = true
}
object claustrofobico {
  method quiereSubir(micro) = micro.volumen() > 120
}

object fiaca {
  method quiereSubir(micro) = micro.sentados() > 0
}

object obsecuente {
  method quiereSubir(micro) = jefe.quiereSubir(micro)
}