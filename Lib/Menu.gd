extends CanvasLayer


var MENUS: Dictionary = {}
var current: String


func _reset():
	for child in get_children():
		child.erase()


func register(menu, path):
	MENUS[menu] = path


func open(menu):
	_reset()
	var instance: Node = load(MENUS[menu]).instance()
	add_child(instance)


func close():
	_reset()
