extends Node


onready var Game = get_node('/root/Main/Game')

var is_controlled: bool = false


func _ready():
	print('[Player] Sup ', name)


func _exit_tree():
	print('[Player] Bye ', name)
