extends Node2D
onready var material_ = $Particles2D.get_process_material().duplicate()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print(body.name)
	if(body.name == 'PlayerNode'):
		var image = body.get_node("Sprite").get_texture().get_data()
		image.lock()
		var color = image.get_pixel(5,5).to_html(false)
		image.unlock()
		material_.set_color(color)
		print(color)
		$Particles2D.set_process_material(material_)
