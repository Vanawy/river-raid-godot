extends Label
class_name PlusScore

const symbol_delay_sec: float = 0.07
const show_delay_sec: float = 0.3

var score_queue: Array[int] = []

var current_score: int = 0
var is_showing: bool = true
var time_since_last_change: float = 0
var current_text: String = ""
var target_text: String = ""

func _ready() -> void:
	text = "";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_score == 0 and !score_queue.is_empty():
		current_score = score_queue.pop_back()	
		time_since_last_change = 0
		target_text = "+" + str(current_score)
		is_showing = true
		
	if current_score != 0:
		if time_since_last_change > symbol_delay_sec:
			time_since_last_change -= symbol_delay_sec
			if is_showing:
				current_text += target_text[current_text.length()]
				if current_text == target_text:
					is_showing = false
					time_since_last_change -= show_delay_sec
			else:
				current_text = current_text.erase(current_text.length() - 1)
				if current_text.length() == 0:
					current_score = 0
			text = current_text
	
	time_since_last_change += delta
	
	
func display_score(score: int) -> void:
	score_queue.append(score)
