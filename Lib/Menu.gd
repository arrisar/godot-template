extends CanvasLayer


var MENUS: Dictionary = {}


func register(menu, path):
	MENUS[menu] = path


func deregister(menu):
	MENUS.erase(menu)
	close(menu)


func open(menu):
	close(menu)
	var instance: Node = load(MENUS[menu]).instance()
	instance.name = menu
	add_child(instance)


func close(menu):
	for child in get_children():
		if child.name == menu: child.queue_free()


func close_all():
	for child in get_children():
		child.queue_free()
