package org.example
import org.example.Persona
import org.example.Polinomio
import org.example.Cuadratica
fun main() {
    val polinomio=Polinomio()
    var cuadratica=Cuadratica()
    var cuadraticav2=CuadraticaV2()
    println (polinomio)
    println (cuadratica)
    println (cuadraticav2)
    println(Persona("pepe", "honguito", Fecha(5, 6, 2026)))
    var objeto:Polinomio
    objeto=Cuadratica()
    println (objeto)
    objeto=CuadraticaV2()
    println (objeto)
    var lista=ArrayList<Polinomio>()
    lista.add(Cuadratica())
    lista.add(Polinomio())
    lista.add(CuadraticaV2())
    for (var pe: lista){ 
        println(p)
        }
}