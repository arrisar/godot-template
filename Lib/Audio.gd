extends Node


var BUSES = {}


func _ready() -> void:
	print('[Audio] Starting')
	_set_volume_from_config()
	Config.connect('updated', self, '_on_config_updated')


func _get_bus_config_path(name: String = 'Master') -> String:
	return 'system/audio/%s_volume' % name.to_lower()


func _get_buses() -> Array:
	var buses = []
	
	for i in AudioServer.bus_count:
		buses.append(AudioServer.get_bus_name(i))
	
	return buses


func _get_index(name: String) -> int:
	return AudioServer.get_bus_index(name)


func _set_volume_from_config(name: String = 'Master') -> void:
	var energy: float = Config.get(_get_bus_config_path(name), 1.0)
	set_volume(energy, name)


func add_bus(name: String):
	print('[Audio] Adding bus with name ', name)
	var position: int = AudioServer.bus_count
	AudioServer.add_bus(position)
	AudioServer.set_bus_name(position, name)
	_set_volume_from_config(name)


func mute(name: String = 'Master') -> void:
	print('[Audio] Muting bus ', name)
	AudioServer.set_bus_mute(_get_index(name), true)


func unmute(name: String = 'Master') -> void:
	print('[Audio] Unmuting bus ', name)
	AudioServer.set_bus_mute(_get_index(name), false)


func get_volume(name: String = 'Master') -> float:
	return db2linear(AudioServer.get_bus_volume_db(_get_index(name)))


func set_volume(energy: float, name: String = 'Master') -> void:
	print('[Audio] Setting volume for bus %s to %s' % [name, energy])
	AudioServer.set_bus_volume_db(_get_index(name), linear2db(energy))


func _on_config_updated(path) -> void:
	for name in _get_buses():
		var bus_config_path: String = _get_bus_config_path(name)
		if path == bus_config_path:
			set_volume(Config.get(bus_config_path, 1.0), name)
