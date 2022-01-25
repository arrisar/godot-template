extends Node


func _ready() -> void:
	print('[Audio] Starting')
	_set_volume_from_config()


func _set_volume_from_config(bus: String = 'Master') -> void:
	var energy: float = Config.get('system/audio/%s_volume' % bus.to_lower())
	set_volume(energy, bus)


func _get_index(bus: String) -> int:
	return AudioServer.get_bus_index(bus)


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
