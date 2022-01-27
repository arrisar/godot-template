extends Control


func _ready():
	connect('pressed', self, '_on_click')
	connect('mouse_entered', self, '_on_hover')
	$ClickSound.bus = 'Effects'
	$HoverSound.bus = 'Effects'


func _on_click():
	$ClickSound.seek(0)
	$ClickSound.play()



func _on_hover():
	$HoverSound.seek(0)
	$HoverSound.play()
