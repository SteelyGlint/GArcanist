extends Control

# constants loaded from another script
const c = preload("constants.gd")

var hexNode = preload("res://static_hex.scn")
var moteNode = preload("res://mote.scn")
var hexes = {}	# { index Vec2 : pointer }

var ind_select = Vector2( -1, -1 )
var ind_hover = Vector2( -1, -1 )

# variables during wand operation
var TICK_INC = 3
var tick_progress = 0		# next tick when this reaches 60

var mote_count = 0

func _ready():
	set_size( Vector2( 1400, 816 ) )
	for col in range(c.COLX):
		for row in range(c.ROWY):
			var newhex = hexNode.instance()
			var hex_index = Vector2(col, row)
			newhex.initialize( hex_index )
			newhex.set_pos( index_to_pix( hex_index ) )
			add_child(newhex)
			hexes[hex_index] = newhex
	get_node("motes").raise()
	set_process(true)

func get_ind_N(ind): return( ind + Vector2( 0, -1) )
func get_ind_NE(ind): return( ind + Vector2( 1, -(int(ind.x)%2) ) )
func get_ind_NW(ind): return( ind + Vector2(-1, -(int(ind.x)%2) ) )
func get_ind_SW(ind): return( ind + Vector2(-1, 1-(int(ind.x)%2) ) )
func get_ind_SE(ind): return( ind + Vector2( 1, 1-(int(ind.x)%2) ) )
func get_ind_S(ind): return( ind + Vector2( 0, 1) )

func get_ind_dir(ind, dir):
	if(dir == c.DIR_N):  return( ind + Vector2( 0, -1) )
	if(dir == c.DIR_NE): return( ind + Vector2( 1, -(int(ind.x)%2) ) )
	if(dir == c.DIR_NW): return( ind + Vector2(-1, -(int(ind.x)%2) ) )
	if(dir == c.DIR_SW): return( ind + Vector2(-1, 1-(int(ind.x)%2) ) )
	if(dir == c.DIR_SE): return( ind + Vector2( 1, 1-(int(ind.x)%2) ) )
	if(dir == c.DIR_S):  return( ind + Vector2( 0, 1) )
	return Vector2( -1, -1 )

func check_bounds(ind):
	if( ind.x < 0 or ind.x >= c.COLX or ind.y < 0 or ind.y >= c.ROWY ): return false
	else: return true

func index_to_pix(ind): return Vector2( 16 + ind.x*28, 32 + ind.y*32 - ((int(ind.x)%2) * 16) )
func pix_to_index(pos):
	var ind_x = floor( (pos.x - 2) / 28 )
	var tmp_y = pos.y + (16*(int(ind_x)%2)) - 16
	var ind_y = floor( tmp_y / 32 )
	return Vector2( ind_x, ind_y )

# prototype garbage: remove at some point
func trigger_func(index):
	var tmp = get_ind_N(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(true)
	var tmp = get_ind_NE(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(true)
	var tmp = get_ind_NW(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(true)
	var tmp = get_ind_SW(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(true)
	var tmp = get_ind_SE(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(true)
	var tmp = get_ind_S(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(true)

# prototype garbage: remove at some point
func trigger_func2(index):
	var tmp = get_ind_N(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(false)
	var tmp = get_ind_NE(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(false)
	var tmp = get_ind_NW(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(false)
	var tmp = get_ind_SW(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(false)
	var tmp = get_ind_SE(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(false)
	var tmp = get_ind_S(index)
	if( check_bounds(tmp) ): hexes[tmp].hex_activate(false)

func _input_event(ev):
	if(ev.type == InputEvent.MOUSE_BUTTON and ev.pressed):
		var mouse_index = pix_to_index( ev.pos )
		if( ev.button_index == BUTTON_LEFT and check_bounds(mouse_index) ):
			ind_select = mouse_index
			get_node( "select" ).show()
			get_node( "select" ).set_pos( index_to_pix ( mouse_index ) )
			#if(ev.button_index == BUTTON_LEFT):
			#	hexes[mouse_index].hex_activate(true)
			#if(ev.button_index == BUTTON_RIGHT):
			#	hexes[mouse_index].hex_activate(false)
		if( ev.button_index == BUTTON_RIGHT and check_bounds(mouse_index) ):
			for ii in range(10):
				var newmote = moteNode.instance()
				get_node("motes").add_child(newmote)
				newmote.initialize(mouse_index)
	
	if(ev.type == InputEvent.MOUSE_BUTTON and not ev.pressed and not ev.button_index == BUTTON_RIGHT ):
		var mouse_index = pix_to_index( ev.pos )
		get_node( "select" ).hide()
		if( check_bounds(mouse_index) and check_bounds(ind_select) ):
			var found_adjacent = false
			for direction in [c.DIR_N, c.DIR_NE, c.DIR_NW, c.DIR_SE, c.DIR_SW, c.DIR_S]:
				if( get_ind_dir(ind_select, direction) == ind_hover ):
					hexes[ind_select].set_glyph(c.HEX_MOVE, direction)
					found_adjacent = true
			if(not found_adjacent): hexes[ind_select].set_glyph(c.HEX_BLANK, c.DIR_NONE)

func mote_added():
	mote_count += 1

func _process(delta):
	tick_progress += TICK_INC
	if( tick_progress >= 60):
		tick_progress = 0
		for mote in get_node("motes").get_children(): mote.tick()
	
	var mouse_index = pix_to_index( get_global_mouse_pos() - get_global_pos() )
	if( check_bounds ( mouse_index ) ):
		ind_hover = mouse_index
		get_node( "hover" ).show()
		get_node( "hover" ).set_pos( index_to_pix ( mouse_index ) )
	else:
		get_node( "hover" ).hide()
	
	get_node( "disp1" ).set_text( str( get_global_mouse_pos() - get_global_pos() ) )
	get_node( "disp2" ).set_text( str( mote_count ) )
	pass

