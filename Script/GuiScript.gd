extends CanvasLayer
onready var endLevel = $PopupCtrl
onready var timeLabel = $PopupCtrl/VBoxContainer/Time
onready var countLabel = $PopupCtrl/VBoxContainer/Count
onready var countGuiLabel = $GameGui/VBoxContainer/HBoxContainer/CountLabel
onready var timeGuiLabel = $GameGui/VBoxContainer/HBoxContainer/TimeLabel
onready var Global = get_tree().get_root().find_node("Global", true, false)


func _ready():
	$PopupCtrl.set_size(Vector2(OS.window_size.x, OS.window_size.y))


func _process(_delta):
	timeGuiLabel.text = "TIME :" + Global.getTime()
	countGuiLabel.text = "STEPS :" + Global.getMoveCount() as String
	pass


func showEndLevelPopup(time: String, moveCount: int):
	$GameGui.hide()
	timeLabel.text = "TIME " + time
	countLabel.text = "STEPS " + moveCount as String
	endLevel.set_visible(true)
	GlobalVars.set_block_move(true)


func _on_MenuBut_pressed():
	var _res = get_tree().change_scene("res://Scenes/MainMenu.tscn")
