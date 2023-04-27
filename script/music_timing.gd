class_name MusicTiming
extends Resource


enum TimingType {
	PICKUP
}


class Timing:
	var type: TimingType
	var value: float
	var position: float
	
	func _init(_type: TimingType, _value: float, _position: float) -> void:
		self.type = _type
		self.value = _value
		self.position = _position


const NAME_TO_TIMING_TYPE = {
	"PICKUP": TimingType.PICKUP
}

@export var music: AudioStream
@export_file("*.json") var left_timings_file_path: String
@export_file("*.json") var right_timings_file_path: String


func get_left_timings() -> Array[Timing]:
	return _get_timings(left_timings_file_path)


func get_right_timings() -> Array[Timing]:
	return _get_timings(right_timings_file_path)


func _get_timings(timings_file_path: String) -> Array[Timing]:
	if not FileAccess.file_exists(timings_file_path):
		return []
	
	var file: FileAccess = FileAccess.open(timings_file_path, FileAccess.READ)
	var data: Array = JSON.parse_string(file.get_as_text())
	file.close()
	
	var result: Array[Timing] = []
	for element in data:
		result.push_back(Timing.new(
			NAME_TO_TIMING_TYPE[element['type']], 
			element['value'],
			element['position']
		))
	
	result.sort_custom(func(e1, e2): return e1.value < e2.value)
	return result
