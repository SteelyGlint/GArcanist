extends Sprite
# hex class, child of the hexgrid

const c = preload("constants.gd")

var m_index = Vector2(-1, -1)			# location on the hex grid
var m_type = c.HEX_BLANK				# glyph type in the hex
var m_dir = c.DIR_NONE					# direction this glyph is pointing

var ref_hexgrid							# reference to the hexgrid

var greydot = load("res://greydot.png")
var move_N =  load("res://move_N.png")
var move_NE = load("res://move_NE.png")
var move_NW = load("res://move_NW.png")
var move_S =  load("res://move_S.png")
var move_SE = load("res://move_SE.png")
var move_SW = load("res://move_SW.png")
var extract = load("res://extract.png")
var terminus = load("res://terminus.png")

func initialize(ind):
	m_index = ind
	add_to_group("hexes")

func set_glyph(gtype, dir):
	if( gtype == c.HEX_BLANK ):
		m_type = c.HEX_BLANK
		m_dir = c.DIR_NONE
		set_texture( greydot )
		set_modulate( Color( 1, 1, 1 ) )
		
	if( gtype == c.HEX_MOVE ):
		if( get_parent().check_bounds( get_parent().get_ind_dir(m_index, dir) ) ):
			m_type = gtype
			m_dir = dir
			if( dir == c.DIR_N ): set_texture( move_N )
			if( dir == c.DIR_NE ): set_texture( move_NE )
			if( dir == c.DIR_NW ): set_texture( move_NW )
			if( dir == c.DIR_S ): set_texture( move_S )
			if( dir == c.DIR_SE ): set_texture( move_SE )
			if( dir == c.DIR_SW ): set_texture( move_SW )
			set_modulate( Color( 0.5, 0.5, 0.5 ) )
		else: set_glyph(c.HEX_BLANK, c.DIR_NONE)
	
	if( gtype == c.HEX_EXTRACT ):
		m_type = c.HEX_EXTRACT
		m_dir = c.DIR_NONE
		set_texture( extract )
		set_modulate( Color( 0.6, 0.8, 1 ) )
	
	if( gtype == c.HEX_TERMINUS ):
		m_type = c.HEX_TERMINUS
		m_dir = c.DIR_NONE
		set_texture( terminus )
		set_modulate( Color( 1, 0.4, 0.4 ) )

func tick():
	if( m_type == c.HEX_EXTRACT ):
		ref_hexgrid.add_mote(m_index)

func _ready():
	ref_hexgrid = get_parent()

func _process(delta):
	pass
