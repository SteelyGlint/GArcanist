extends Sprite
# mote class, grandchild of the hexgrid

const c = preload("constants.gd")

var m_loc_ind							# index of current mote location on the hex grid
var m_dest_ind							# destination hex this mote is moving towards
var m_dir = c.DIR_NONE					# direction of travel
var marked_for_death = false			# used to destroy the mote
var m_offset = Vector2(0, 0)			# purely graphical offset so motes don't all stack together

var ref_hexgrid							# reference to the hexgrid
var ref_hex_dict						# reference to the dictionary containing all hex objects

func _process(delta):
	var progress = ref_hexgrid.tick_progress / 60.0
	set_pos( m_offset + (1-progress)*ref_hexgrid.index_to_pix( m_loc_ind ) + progress*ref_hexgrid.index_to_pix( m_dest_ind ) )
	if(marked_for_death):
		ref_hexgrid.removed_mote()
		self.free()

func tick():
	if( ref_hex_dict[m_dest_ind].m_type != c.HEX_TERMINUS ):
		m_loc_ind = m_dest_ind
		m_offset = (m_offset + Vector2( randf()-0.5, randf()-0.5 )) * 0.98
		while (not choose_dest()): pass
	else:
		marked_for_death = true

func choose_dest():
	var hex_loc = ref_hex_dict[m_loc_ind]
	if( hex_loc.m_type == c.HEX_MOVE ):
		m_dir = hex_loc.m_dir
		m_dest_ind = ref_hexgrid.get_ind_dir( m_loc_ind, hex_loc.m_dir )
		return true
	else:
		var momentum_ind = ref_hexgrid.get_ind_dir(m_loc_ind, m_dir)
		if( ref_hexgrid.check_bounds( momentum_ind ) and randf()>0.01 ):
			m_dest_ind = momentum_ind
			return true
		else:
			var tmp_dir = 1 + randi()%6
			var tmp_dest = ref_hexgrid.get_ind_dir(m_loc_ind, tmp_dir)
			if ( ref_hexgrid.check_bounds( tmp_dest ) ):
				m_dest_ind = tmp_dest
				m_dir = tmp_dir
				return true
			else: return false

func initialize(loc):
	m_loc_ind = loc
	ref_hexgrid = get_parent().get_parent()
	ref_hex_dict = ref_hexgrid.hexes
	while (not choose_dest()): pass
	set_pos( ref_hexgrid.index_to_pix( m_loc_ind ) )
	show()

func _ready():
	set_process(true)


