extends Node


onready var Main = get_node('/root/Main')
onready var GameServer = preload('GameServer.gd').new()

onready var PlayerOneLabel = $HUD/PlayerOneLabel
onready var PlayerOneScore = $HUD/PlayerOneScore
onready var PlayerOneGoal = $PlayerOneGoal
onready var PlayerOne = $Field/PlayerOne

onready var PlayerTwoLabel = $HUD/PlayerTwoLabel
onready var PlayerTwoScore = $HUD/PlayerTwoScore
onready var PlayerTwoGoal = $PlayerTwoGoal
onready var PlayerTwo = $Field/PlayerTwo

onready var Ball = $Field/Ball
onready var BoundaryTop = $BoundaryTop
onready var BoundaryBottom = $BoundaryBottom

var PLAYERS: Dictionary


func _ready():
	Client.connect('connection_closed', self, '_connection_closed')
	Client.connect('event', self, '_event')
	GameServer.start()


func _exit_tree():
	Client.disconnect('connection_closed', self, '_connection_closed')
	Client.disconnect('event', self, '_event')
	GameServer.stop()


func _process(_delta):
	if Input.is_action_pressed('ui_cancel'):
		Menu.open('Pause')


func _connection_closed():
	Main.mount_title()


func _event(event: String, payload):
	match event:
		'players_updated':
			_update_players(payload)
			
		'positions_updated':
			_update_positions(payload)


func _update_players(players: Dictionary) -> void:
	PLAYERS = players
	PlayerOne.set_controlled(false)
	PlayerTwo.set_controlled(false)
	
	for id in PLAYERS:
		var player: Dictionary = PLAYERS[id]
		if player.paddle != null:
			var num: String = 'One' if player.paddle == 0 else 'Two'
			get('Player%sLabel' % num).text = player.name
			get('Player%sScore' % num).text = str(player.score)
			get('Player%s' % num).set_controlled(Client.peer_id == id)


func _update_positions(positions: Dictionary, force: int = false):
	Ball.position = positions.ball
	
	if !PlayerOne.is_controlled || force:
		PlayerOne.position.y = positions.paddles[0]

	if !PlayerTwo.is_controlled || force:
		PlayerTwo.position.y = positions.paddles[1]
