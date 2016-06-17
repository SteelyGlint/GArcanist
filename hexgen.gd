extends Control

const c = preload("constants.gd")				# global constants loaded from another script

var hexNode = preload("res://static_hex.scn")
var moteNode = preload("res://mote.scn")
var hexes = {}									# dictionary of hex objects, indexed by Vector2 hex coords

# variables for both build and run phases
var ind_hover = Vector2( -1, -1 )				# the hex that the mouse is currently hovering over
var ind_select = Vector2( -1, -1 )				# the hex that is currently selected
var m_mode										# current game mode: build, run, etc.

# variables during wand operation
var tick_progress = 0							# next tick when this reaches 60
var TICK_MULT = 120								# speed at which progress accumulates, per second
var mote_count = 0

# variables during wand creation
var glyph_type = c.HEX_BLANK					# type of glyph the player wishes to place
var m_assigning = false							# is the LMB held down to create a glyph?

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
	m_mode = c.MODE_BUILD
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

func mouse_select_dir():
	var center = get_global_pos() + hexes[ind_select].get_pos()
	var angle = 6 / 3.1416 * center.angle_to_point( get_global_mouse_pos() )
	if( angle <= 5 and angle > 3 ): return c.DIR_SW
	elif( angle <= 3 and angle > 1 ): return c.DIR_NW
	elif( angle <= 1 and angle > -1 ): return c.DIR_N
	elif( angle <= -1 and angle > -3 ): return c.DIR_NE
	elif( angle <= -3 and angle > -5 ): return c.DIR_SE
	else: return c.DIR_S

func assign_glyph():
	if( check_bounds(ind_select) ):
		if( glyph_type == c.HEX_BLANK ): hexes[ind_select].set_glyph(c.HEX_BLANK, c.DIR_NONE)
		if( glyph_type == c.HEX_MOVE ): hexes[ind_select].set_glyph(c.HEX_MOVE, mouse_select_dir())
		if( glyph_type == c.HEX_EXTRACT ): hexes[ind_select].set_glyph(c.HEX_EXTRACT, c.DIR_NONE)
		if( glyph_type == c.HEX_TERMINUS ): hexes[ind_select].set_glyph(c.HEX_TERMINUS, c.DIR_NONE)

func _input_event(ev):
	if(ev.type == InputEvent.MOUSE_BUTTON and ev.pressed):
		var mouse_index = pix_to_index( ev.pos )
		if( ev.button_index == BUTTON_LEFT and check_bounds(mouse_index) ):
			ind_select = mouse_index
			get_node( "select" ).show()
			get_node( "select" ).set_pos( index_to_pix ( mouse_index ) )
			if(m_mode == c.MODE_BUILD):
				m_assigning = true
			elif(m_mode == c.MODE_RUN):
				get_parent().get_node("gui_run").get_node("mote_observer").display(ind_select)
		
		if(m_mode == c.MODE_RUN):
			if( ev.button_index == BUTTON_RIGHT and check_bounds(mouse_index) ):
				for ii in range(50): add_mote(mouse_index)
	
	if(ev.type == InputEvent.MOUSE_BUTTON and not ev.pressed and ev.button_index == BUTTON_LEFT ):
		var mouse_index = pix_to_index( ev.pos )
		if(m_mode == c.MODE_BUILD):
			m_assigning = false
			get_node( "select" ).hide()
			ind_select = Vector2( -1, -1 ) # hack so observer panel is blank when switching
		elif(m_mode == c.MODE_RUN):
			pass

func removed_mote(): mote_count -= 1
func add_mote(index):
	var newmote = moteNode.instance()
	get_node("motes").add_child(newmote)
	newmote.initialize(index)
	mote_count += 1

func _process(delta):
	if(m_mode == c.MODE_RUN):
		tick_progress += (TICK_MULT * delta)
	if( tick_progress >= 60):
		tick_progress -= 60
		get_tree().call_group(0, "hexes", "tick")
		for mote in get_node("motes").get_children(): mote.tick()
		get_parent().get_node("gui_run").get_node("mote_observer").display(ind_select)
	
	var mouse_index = pix_to_index( get_global_mouse_pos() - get_global_pos() )
	if( check_bounds ( mouse_index ) ):
		ind_hover = mouse_index
		get_node( "hover" ).show()
		get_node( "hover" ).set_pos( index_to_pix ( mouse_index ) )
	else:
		get_node( "hover" ).hide()
	
	if( m_assigning ): assign_glyph()
	
	get_node( "disp1" ).set_text( str( m_assigning ) )
	get_node( "disp2" ).set_text( "motes: " + str( mote_count ) )
	get_node( "disp3" ).set_text( "glyph type: " + str( glyph_type ) )

