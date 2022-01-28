extends CanvasLayer


var MENUS: Dictionary


func register(menu: String, path: String) -> void:
	MENUS[menu] = path


func deregister(menu: String) -> void:
	MENUS.erase(menu)
	close(menu)


func open(menu: String) -> void:
	close(menu)
	var instance: Node = load(MENUS[menu]).instance()
	instance.name = menu
	add_child(instance)


func close(menu: String) -> void:
	for child in get_children():
		if child.name == menu: child.queue_free()


func close_all() -> void:
	for child in get_children():
		child.queue_free()
