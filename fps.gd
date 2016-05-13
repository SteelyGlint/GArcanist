extends Label

var running_avg = 60.0
func _ready(): set_process(true)
func _process(delta):
	running_avg = running_avg*0.8 + (1/delta)*0.2
	set_text( str(floor(running_avg)) )
