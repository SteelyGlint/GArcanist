extends TextureButton

var index = Vector2(-1, -1)
var cooldown = 0.0
var flag = false

var mote_refs = []

var move_up = load("res://move_up.png")
var move_ur = load("res://move_ur.png")
var move_ul = load("res://move_ul.png")

func initialize(ind):
	index = ind

func _input_event(ev):
	if(ev.type == InputEvent.MOUSE_BUTTON and ev.pressed):
		pass
		#get_parent().trigger_func(index)
	
	if(ev.type==InputEvent.MOUSE_MOTION):
		if( randf() > 0.5 ):
			self.set_pressed_texture( move_ur )
		else:
			self.set_pressed_texture( move_ul )

func hex_activate():
	if( cooldown == 0.0 ):
		cooldown += 0.5 + 0.1*randf()
		set_process(true)

func _ready():
	pass

func _process(delta):
	cooldown -= delta
	if(cooldown < 0.5 and flag == false):
		get_parent().trigger_func(index)
		flag = true
	if(cooldown < 0):
		set_process(false)
		cooldown = 0
		flag = false
	set_modulate( Color( 1+cooldown, 1-cooldown, 1 ) )
