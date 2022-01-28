extends Node


onready var PlayerOneLabel = $HUD/PlayerOneLabel
onready var PlayerOneScore = $HUD/PlayerOneScore
onready var PlayerOneGoal = $PlayerOneGoal

onready var PlayerTwoLabel = $HUD/PlayerTwoLabel
onready var PlayerTwoScore = $HUD/PlayerTwoScore
onready var PlayerTwoGoal = $PlayerTwoGoal

onready var BoundaryTop = $BoundaryTop
onready var BoundaryBottom = $BoundaryBottom

var is_active = false


func _physics_process(delta):
	if is_active:
		print(delta)
