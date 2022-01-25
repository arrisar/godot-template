extends Node


signal updated(path)


var DebounceTimer : Timer
var Files := {
	system = { path = 'user://config/system.ini' },
	user = { path = 'user://config/user.ini' },
}


func _ready() -> void:
	print('[Config] Starting')
	_init_debounce()
	_load()


func _init_debounce() -> void:
	print('[Config] Initializing debounce')
	var timer = Timer.new()
	timer.name = 'DebounceSaveTimer'
	timer.wait_time = 1
	timer.connect('timeout', self, 'save')
	DebounceTimer = add_child(timer)


func _load() -> void:
	print('[Config] Loading')
	for file in Files:
		var path = Files[file].path
		Files[file].config = ConfigFile.new()
		Files[file].config.load(path)


func _get_parts(path: String) -> Dictionary:
	var split = path.split('/', true, 2)
	return {
		file = split[0],
		section = split[1],
		key = split[2],
	}


func get(path: String, default = null):
	var parts = _get_parts(path)

	if default == null:
		var setting: String = "defaults/%s/%s" % [parts.section, parts.key]
		default = ProjectSettings.get_setting(setting)
	
	return Files[parts.file].config.get_value(parts.section, parts.key, default)


func set(path: String, value) -> void:
	var parts = _get_parts(path)
	Files[parts.file].config.set_value(parts.section, parts.key, value)
	emit_signal('updated', path)
	DebounceTimer.start()


func save() -> void:
	print('[Config] Saving')
	for key in Files:
		var file: Dictionary = Files[key]
		file.config.save(file.path)


func reload() -> void:
	_load()
