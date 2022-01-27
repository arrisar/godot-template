extends Control


onready var ApplyButton = $Panel/ApplyButton
onready var BackButton = $Panel/BackButton

onready var MasterVolume = $Panel/MasterVolumeSlider
onready var MusicVolume = $Panel/MusicVolumeSlider
onready var EffectsVolume = $Panel/EffectsVolumeSlider


func _ready():
	MasterVolume.value = Config.get(Audio.get_bus_config_path('Master'), 1)
	MusicVolume.value = Config.get(Audio.get_bus_config_path('Music'), 1)
	EffectsVolume.value = Config.get(Audio.get_bus_config_path('Effects'), 1)
	
	ApplyButton.connect('pressed', self, '_on_click_apply')
	BackButton.connect('pressed', self, '_on_click_back')
	MasterVolume.connect('value_changed' , self, '_on_change_volume', ['Master'])
	MusicVolume.connect('value_changed' , self, '_on_change_volume', ['Music'])
	EffectsVolume.connect('value_changed' , self, '_on_change_volume', ['Effects'])


func _exit_tree():
	ApplyButton.disconnect('pressed', self, '_on_click_apply')
	BackButton.disconnect('pressed', self, '_on_click_back')
	MasterVolume.disconnect('value_changed' , self, '_on_change_volume')
	MusicVolume.disconnect('value_changed' , self, '_on_change_volume')
	EffectsVolume.disconnect('value_changed' , self, '_on_change_volume')


func _on_click_apply():
	Config.save()
	Menu.close('Settings')


func _on_click_back():
	Config.reload()
	Menu.close('Settings')


func _on_change_volume(value: float, bus: String):
	Config.set(Audio.get_bus_config_path(bus), value)
