extends CharacterBody3D # Si tu nodo raíz es Node3D o StaticBody3D, cambiá esta línea según corresponda

@export var vida: int = 1


func recibir_danio(cantidad: int = 1) -> void:
	vida -= cantidad
	if vida <= 0:
		morir()


func morir() -> void:
	print("💀 ¡El jefe ha sido derrotado!")
	queue_free() # Elimina al jefe de la escena al recibir el impacto
