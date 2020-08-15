extends Node
var difficalty = 100 setget set_difficalty, get_difficalty
var block_move = false setget set_block_move, get_block_move

func _ready():
	pass

func set_difficalty(value):
	difficalty = value

func get_difficalty():
	return difficalty

func set_block_move(val):
	block_move = val

func get_block_move():
	return block_move