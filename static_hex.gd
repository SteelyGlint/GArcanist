extends Sprite

var c = preload("constants.gd")
var index = Vector2(-1, -1)

# mostly prototype garbage: delete at some point
var cooldown = 0.0
var heatdown = 0.0
var cool = false
var heat = false
var cool_flag = false
var heat_flag = false

var mote_refs = []

var move_N =  load("res://move_N.png")
var move_NE = load("res://move_NE.png")
var move_NW = load("res://move_NW.png")
var move_S =  load("res://move_S.png")
var move_SE = load("res://move_SE.png")
var move_SW = load("res://move_SW.png")

func initialize(ind):
	index = ind

func set_glyph(gtype, dir):
	pass

#func _input_event(ev):
	#if(ev.type == InputEvent.MOUSE_BUTTON and ev.pressed):
	#	#get_parent().trigger_func(index)
	#if(ev.type==InputEvent.MOUSE_MOTION):
	#	if( randf() > 0.5 ):
	#		self.set_pressed_texture( move_ur )
	#	else:
	#		self.set_pressed_texture( move_ul )

func hex_activate(type):
	if( type == true and cooldown == 0.0 ):
		cooldown += 1.8 + 0.3*randf()
		cool = true
		set_process(true)
	if( type == false and heatdown == 0.0 ):
		heatdown += 0.55 + 0.4*randf()
		heat = true
		set_process(true)

func _ready():
	pass

func _process(delta):
	if( cooldown > 0.0 ): cooldown -= delta
	if( heatdown > 0.0 ): heatdown -= delta
	if( cool and heat ):
		cooldown += 1.5+randf()*0.4
		cool_flag = true
		heatdown = 0.0
		heat = false
		heat_flag = false
	if(cool and cooldown < 1.3 and not cool_flag):
		get_parent().trigger_func(index)
		cool_flag = true
	if(heat and heatdown < 0.5 and not heat_flag):
		get_parent().trigger_func2(index)
		heat_flag = true
	if(cooldown < 0.0):
		cooldown = 0.0
		cool = false
		cool_flag = false
	if(heatdown < 0.0):
		heatdown = 0.0
		heat = false
		heat_flag = false
	if( not cool and not heat ):
		#flag = false
		set_process(false)
	set_modulate( Color( 1-cooldown+0.5*heatdown, 1-heatdown+0.3*cooldown, 1-heatdown+0.3*cooldown ) )

