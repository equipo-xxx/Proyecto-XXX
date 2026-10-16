package org.example
import org.example.Fecha
class Persona ( private var nombre: String, private var apellido: String, private  var fecha: Fecha){
    override fun toString():String{
	return "nombre=${nombre}, apellido=${apellido}, fecha=${fecha}"}}