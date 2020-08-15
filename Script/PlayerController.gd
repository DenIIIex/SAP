extends KinematicBody2D
export (int) var speed = 1500

export (float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3
var velocity = Vector2()
var countMove = 0
var is_moving = false
var allCell
var swipe_start_position = Vector2()
onready var tileMap = get_tree().get_root().find_node("Map", true, false)
onready var Global = get_tree().get_root().find_node("Global", true, false)
onready var timer = $Timer


func _ready():
	var tile_pos = tileMap.world_to_map(position)
	tileMap.set_cellv(tile_pos, 3)
	allCell = Global.getAllCell()


func _input(event):
	if !is_moving and !GlobalVars.get_block_move():
		if event is InputEventScreenTouch:
			if event.pressed:
				_start_detection(event.position)
			elif not timer.is_stopped():
				_end_detection(event.position)
		if Input.is_action_just_pressed('ui_right') and !$rayR.is_colliding():
			moveX(1)
		if Input.is_action_just_pressed('ui_left') and !$rayL.is_colliding():
			moveX(-1)
		if Input.is_action_just_pressed('ui_down') and !$rayD.is_colliding():
			moveY(1)
		if Input.is_action_just_pressed('ui_up') and !$rayU.is_colliding():
			moveY(-1)

	if Input.is_action_just_pressed("reload"):
		Global.loadNextLevel()
	if Input.is_action_just_pressed("SaveLevel"):
		var file = File.new()
		file.open("user://{str}.txt".format({"str": OS.get_datetime()}), file.WRITE)
		file.store_string(Global.getLevelData())


func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	if is_moving:
		colorMap()
	is_moving = velocity.x != 0 or velocity.y != 0

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


func getMoveCount():
	return countMove


func moveX(dir):
	is_moving = true
	$BlockStream.play()
	countMove += 1
	velocity.x = dir
	velocity = velocity.normalized() * speed


func moveY(dir):
	is_moving = true
	$BlockStream.play()
	countMove += 1
	velocity.y = dir
	velocity = velocity.normalized() * speed


func colorMap():
	var tile_pos = tileMap.world_to_map(position)
	var tile_id = tileMap.get_cellv(tile_pos)
	if tile_id == 2:
		tileMap.set_cellv(tile_pos, 3)
		allCell -= 1
		if allCell == 0:
			GlobalVars.set_block_move(true)
			Global.showEndLevelPopup()


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
