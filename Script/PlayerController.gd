extends KinematicBody2D
export (int) var speed = 1500
#export (TileMap) var tileMap = get_tree().get_root().get_node("TileMap")
onready var tileMap = get_tree().get_root().find_node("Map", true, false)
onready var Global = get_tree().get_root().find_node("Global", true, false)
onready var Utils = preload("res://Script/Utils.gd").new()
var velocity = Vector2()
var countMove = 0
var allCell

export (float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3
onready var timer = $Timer
var swipe_start_position = Vector2()


func getMoveCount():
	return countMove


func moveX(dir):
	Global.setCanMove(false)
	$BlockStream.play()
	countMove += 1
	velocity.x = dir
	velocity = velocity.normalized() * speed


func moveY(dir):
	Global.setCanMove(false)
	$BlockStream.play()
	countMove += 1
	velocity.y = dir
	velocity = velocity.normalized() * speed


func _input(event):
	if Global.getCanMove():
		if event is InputEventScreenTouch:
			if event.pressed:
				_start_detection(event.position)
			elif not timer.is_stopped():
				_end_detection(event.position)
		if Input.is_action_just_pressed('ui_right'):
			moveX(1)
		if Input.is_action_just_pressed('ui_left'):
			moveX(-1)
		if Input.is_action_just_pressed('ui_down'):
			moveY(1)
		if Input.is_action_just_pressed('ui_up'):
			moveY(-1)

	if Input.is_action_just_pressed("reload"):
		Global.loadNextLevel()
	if Input.is_action_just_pressed("SaveLevel"):
		var file = File.new()
		file.open("user://{str}.txt".format({"str": OS.get_datetime()}), file.WRITE)
		file.store_string(Global.getLevelData())
		file.close()


func _ready():
	allCell = Global.getAllCell()


func colorMap():
	var tile_pos = tileMap.world_to_map(position)
	var tile_id = tileMap.get_cellv(tile_pos)
	if tile_id == 2:
		tileMap.set_cellv(tile_pos, 3)
		allCell -= 1
		if allCell == 0:
			Global.setCanMove(false)
			Global.showEndLevelPopup()


func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if ! Global.getCanMove():
		colorMap()
	Global.setCanMove(velocity.x == 0 and velocity.y == 0)

	if position.y < Global.getMapOfset():
		$PortalStream.play()
		position.y = Global.getHeight() - Global.getMapOfset()
	if position.x < Global.getMapOfset():
		$PortalStream.play()
		position.x = Global.getWidth() - Global.getMapOfset()
	if position.x > Global.getWidth() - Global.getMapOfset():
		$PortalStream.play()
		position.x = Global.getMapOfset()
	if position.y > Global.getHeight() - Global.getMapOfset():
		$PortalStream.play()
		position.y = Global.getMapOfset()


func _start_detection(position):
	swipe_start_position = position
	timer.start()


func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	if abs(direction.x) > abs(direction.y):
		moveX(sign(direction.x) * 1)
	else:
		moveY(sign(direction.y) * 1)
