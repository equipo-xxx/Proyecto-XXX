extends Label3D
class_name LabelFlotante

@export var duracion_aparicion: float = 7.0
@export var velocidad_rgb: float = 2.0

var tono: float = 0.0
var texto_completo: String = ""


func _ready() -> void:
	texto_completo = text
	text = ""
	
	var tween: Tween = create_tween()
	tween.tween_method(mostrar_caracteres, 0, texto_completo.length(), duracion_aparicion)


func mostrar_caracteres(cantidad: int) -> void:
	text = texto_completo.substr(0, cantidad)


func _process(delta: float) -> void:
	tono = fmod(tono + delta * velocidad_rgb, 1.0)
	modulate = Color.from_hsv(tono, 1.0, 1.0)
