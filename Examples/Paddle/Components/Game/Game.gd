extends Node


onready var Main = get_node('/root/Main')
onready var PlayerOneLabel = $HUD/PlayerOneLabel
onready var PlayerOneScore = $HUD/PlayerOneScore
onready var PlayerOneGoal = $PlayerOneGoal
onready var PlayerTwoLabel = $HUD/PlayerTwoLabel
onready var PlayerTwoScore = $HUD/PlayerTwoScore
onready var PlayerTwoGoal = $PlayerTwoGoal
onready var BoundaryTop = $BoundaryTop
onready var BoundaryBottom = $BoundaryBottom

var PLAYERS: Array = []


func _ready():
	_connect()


func _connect():
	Client.connect('connection_closed', self, '_connection_closed')
	Server.connect('event', self, '_server_event')


func _exit_tree():
	Client.disconnect('connection_closed', self, '_connection_closed')
	Server.disconnect('event', self, '_server_event')


func _process(_delta):
	if Input.is_action_pressed('ui_cancel'):
		Menu.open('Pause')


func _connection_closed():
	Main.mount_title()
