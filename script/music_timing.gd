class_name MusicTiming
extends Resource


enum TimingType {
	PICKUP,
	PICKUP_LINE
}


enum TimingSide {
	LEFT,
	RIGHT
}


class Timing:
	var type: TimingType
	var side: TimingSide
	var start_second: float
	var end_second: float
	var duration: float
	var position: float
	
	func _init(
		_type: TimingType, 
		_side: TimingSide, 
		_start_second: float, 
		_end_second: float, 
		_position: float
	) -> void:
		self.type = _type
		self.side = _side
		self.start_second = _start_second
		self.end_second = _end_second
		self.duration = self.end_second - self.start_second
		self.position = _position


const NAME_TO_TIMING_TYPE: Dictionary = {
	"PICKUP": TimingType.PICKUP,
	"PICKUP_LINE": TimingType.PICKUP_LINE
}

const NAME_TO_TIMING_SIDE: Dictionary = {
	"LEFT": TimingSide.LEFT,
	"RIGHT": TimingSide.RIGHT
}

@export var id: String
@export var music: AudioStream
@export_file("*.json") var timings_file_path: String


func get_left_timings() -> Array[Timing]:
	return _get_timings(TimingSide.LEFT)


func get_right_timings() -> Array[Timing]:
	return _get_timings(TimingSide.RIGHT)


func _get_timings(timings_side: TimingSide) -> Array[Timing]:
	if not FileAccess.file_exists(timings_file_path):
		return []
	
	var file: FileAccess = FileAccess.open(timings_file_path, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	var timings: Array = data['timings']
	file.close()
	
	var result: Array[Timing] = []
	for timing in timings:
		var side: TimingSide = NAME_TO_TIMING_SIDE[timing['side']]
		if timings_side == side:
			result.push_back(Timing.new(
				NAME_TO_TIMING_TYPE[timing['type']], 
				side,
				timing['startSecond'],
				timing['endSecond'],
				timing['position']
			))
	
	result.sort_custom(func(e1, e2): return e1.start_second < e2.start_second)
	return result
