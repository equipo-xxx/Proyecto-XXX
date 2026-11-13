extends Label3D
class_name LabelFlotante

@export var frases: Array[String] = []
@export var duracion_aparicion: float = 3.0
@export var tiempo_espera: float = 2.0
@export var demora_inicial: float = 2.0
@export var velocidad_rgb: float = 2.0
@export var repetir: bool = false

var tono: float = 0.0
var texto_actual: String = ""
var indice_frase: int = 0
var tween_maquina: Tween


func _ready() -> void:
	text = ""
	if frases.size() > 0:
		if demora_inicial > 0.0:
			get_tree().create_timer(demora_inicial).timeout.connect(mostrar_siguiente_frase)
		else:
			mostrar_siguiente_frase()


func mostrar_siguiente_frase() -> void:
	if frases.is_empty():
		return

	if indice_frase >= frases.size():
		if repetir:
			indice_frase = 0
		else:
			return # Se detiene en la última frase sin volver a empezar

	texto_actual = frases[indice_frase]
	indice_frase += 1
	escribir_texto(texto_actual)


func escribir_texto(nuevo_texto: String) -> void:
	texto_actual = nuevo_texto
	text = ""

	if tween_maquina and tween_maquina.is_running():
		tween_maquina.kill()

	tween_maquina = create_tween()

	# Animación de tipeo
	tween_maquina.tween_method(
		mostrar_caracteres,
		0.0,
		float(texto_actual.length()),
		duracion_aparicion
	)

	# Si quedan más frases por mostrar (o si está activado 'repetir'), programa la siguiente
	if frases.size() > 1 and (indice_frase < frases.size() or repetir):
		tween_maquina.tween_interval(tiempo_espera)
		tween_maquina.tween_callback(mostrar_siguiente_frase)


func mostrar_caracteres(cantidad: float) -> void:
	text = texto_actual.substr(0, int(cantidad))


func _process(delta: float) -> void:
	tono = fmod(tono + delta * velocidad_rgb, 1.0)
	modulate = Color.from_hsv(tono, 1.0, 1.0)
