extends ColorRect
onready var GameManager = preload("res://Scenes/test.tscn")
var GameInstance

func _ready():
	#hide()
	pass


func _on_NewGameBut_pressed():
	get_tree().change_scene("res://Scenes/test.tscn")
	#if(GameInstance == null):
		#GameInstance = GameManager.instance()
		#PlayerInstance.set_position(Vector2(map.map_to_world(startPos).x + mapOfset * cellSize + cellSize /2 ,map.map_to_world(startPos).y + mapOfset* cellSize + cellSize/2))
		#self.add_child(GameInstance)
		#hide()
	#else:
		#PlayerInstance.set_position(Vector2(map.map_to_world(startPos).x + mapOfset * cellSize + cellSize /2 ,map.map_to_world(startPos).y + mapOfset* cellSize + cellSize/2))


func _on_SettingsBut_pressed():
	get_tree().change_scene("res://Scenes/Settings.tscn")


func _on_ExitBut_pressed():
	get_tree().quit()
