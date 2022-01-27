extends Node


signal updated(path)


var DebounceSaveTimer: Timer
var Files := {
	system = { path = 'user://system.cfg' },
	user = { path = 'user://user.cfg' },
}


func _ready() -> void:
	print('[Config] Starting')
	_init_debounce()
	_init_files()
	_load()


func _init_debounce() -> void:
	print('[Config] Initializing debounce')
	var timer = Timer.new()
	timer.name = 'DebounceSaveTimer'
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.connect('timeout', self, '_on_save')
	DebounceSaveTimer = timer
	add_child(timer)


func _init_files():
	for name in Files:
		var path = Files[name].path
		var file = File.new()
		
		if !file.file_exists(path):
			file.open(path, File.WRITE)
			file.close()


func _load() -> void:
	print('[Config] Loading')
	for name in Files:
		var path = Files[name].path
		Files[name].config = ConfigFile.new()
		Files[name].config.load(path)


func _get_parts(path: String) -> Dictionary:
	var split = path.to_lower().split('/', true, 2)
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
	print('[Config] Setting %s to %s' % [path.to_lower(), value])
	var parts = _get_parts(path)
	Files[parts.file].config.set_value(parts.section, parts.key, value)
	emit_signal('updated', path.to_lower())


func save() -> void:
	print('[Config] Saving')
	DebounceSaveTimer.start()


func reload() -> void:
	_load()


func _on_save() -> void:
	for key in Files:
		var file: Dictionary = Files[key]
		file.config.save(file.path)
	print('[Config] Saved')
