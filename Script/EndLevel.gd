extends ColorRect
onready var Global = get_tree().get_root().find_node("Global", true, false)

func _ready():
	hide()

func _on_RestartBut_pressed():
	Global.startLevel(Global.getLevel(),Global.getLevelStartPos(),true)
	GlobalVars.set_block_move(false)
	hide()


func _on_NextBut_pressed():
	Global.loadNextLevel()
	GlobalVars.set_block_move(false)
	hide()
	


func _on_ExitToMainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
