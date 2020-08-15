extends ColorRect


func _ready():
	$Margin/VBoxContainer/MenuItemsLay/CenterContainer/VBoxContainer/VBoxContainer2/HSlider.value = GlobalVars.get_difficalty()


func _on_Button_pressed():
	var _res = get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_HSlider_value_changed(value):
	GlobalVars.set_difficalty(value)
