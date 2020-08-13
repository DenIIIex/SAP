extends ColorRect
onready var Global = get_tree().get_root().find_node("Global", true, false)

func _ready():
	hide()

func _on_RestartBut_pressed():
	Global.startLevel(Global.getLevel(),Global.getLevelStartPos(),true)
	Global.setCanMove(true)
	hide()


func _on_NextBut_pressed():
	Global.loadNextLevel()
	hide()
	


func _on_ExitToMainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
