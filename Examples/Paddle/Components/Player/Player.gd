extends KinematicBody2D


onready var Game = get_node('/root/Main/Game')

var is_controlled: bool
var move_speed: int = 256


func _ready():
	set_controlled(false)


func _physics_process(_delta):
	var velocity := Vector2.ZERO
	
	if Input.is_action_pressed('paddle_up'):
		velocity.y -= move_speed
	
	if Input.is_action_pressed('paddle_down'):
		velocity.y += move_speed
	
	move_and_slide(velocity)
	
	Client.send_event('player_position_updated', self.position.y, true)


func set_controlled(is_controlled: bool) -> void:
	self.is_controlled = is_controlled
	set_process(is_controlled)
	set_physics_process(is_controlled)
