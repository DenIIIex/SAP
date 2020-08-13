extends CanvasLayer
onready var endLevel = $PopupCtrl
onready var timeLabel = $PopupCtrl/VBoxContainer/Time
onready var countLabel = $PopupCtrl/VBoxContainer/Count
onready var countGuiLabel = $GameGui/VBoxContainer/HBoxContainer/CountLabel
onready var timeGuiLabel = $GameGui/VBoxContainer/HBoxContainer/TimeLabel
onready var Global = get_tree().get_root().find_node("Global", true, false)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PopupCtrl.set_size(Vector2(OS.window_size.x,OS.window_size.y))
func showEndLevelPopup(time : String, moveCount : int):
	$GameGui.hide()
	timeLabel.text = "TIME " + time
	countLabel.text = "STEPS " + moveCount as String
	endLevel.set_visible(true)
	Global.setCanMove(false)
	
func _process(delta):
	timeGuiLabel.text = "TIME :" + Global.getTime()
	countGuiLabel.text = "STEPS :" + Global.getMoveCount() as String

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass


func _on_MenuBut_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
