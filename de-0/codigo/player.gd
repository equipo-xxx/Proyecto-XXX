class_name Jugador
extends CharacterBody3D

##CAMINAR VARIABLES##
var velocidad:int = 200
var direccion:Vector3

##MOVER CAMARA VARIABLES##
var sensibilidad:float = 0.001
@onready var camara:Camera3D = $Camera3D


func _physics_process(delta):
	caminar(delta)
	move_and_slide()


func _input(event):
	mover_camara(event)


func _process(delta):
	ocultar_raton()


func caminar(delta):
	direccion = transform.basis * Vector3(Input.get_axis("izquierda","derecha"),0,Input.get_axis("adelante","atras")).normalized()
	
	velocity.x = direccion.x * velocidad * delta
	velocity.z = direccion.z * velocidad * delta


func mover_camara(event):
	if event is InputEventMouseMotion:
		#rotar al jugador cuando movemos el raton en el eje x
		rotate_y(-event.relative.x * sensibilidad)
		
		#rotar la camara en el eje x cuando movemos el raton en el eje y
		camara.rotate_x(-event.relative.y * sensibilidad)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func ocultar_raton():
	if Input.is_action_just_pressed("ocultar_raton"):
		#si el raton esta oculto lo hace visible
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#si el raton no esta oculto pues lo oculta
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
