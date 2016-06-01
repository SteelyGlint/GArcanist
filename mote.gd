extends Sprite
# mote class, child of the hexgrid

const c = preload("constants.gd")
var m_loc_ind
var m_dest_ind
var m_dir = c.DIR_NONE
var m_offset = Vector2(0, 0)
var marked_for_death = false

func _process(delta):
	var progress = get_parent().get_parent().tick_progress / 60.0
	#if(randf() < 0.1):
	#m_offset = (m_offset + Vector2( randf()-0.5, randf()-0.5 )) * 0.99
	#if(randf() < 0.4): marked_for_death = true

	set_pos( m_offset + (1-progress)*get_parent().get_parent().index_to_pix( m_loc_ind ) + progress*get_parent().get_parent().index_to_pix( m_dest_ind ) )
	
	#if(marked_for_death): self.free()

func tick():
	m_loc_ind = m_dest_ind
	m_offset = (m_offset + Vector2( randf()-0.5, randf()-0.5 )) * 0.98
	while (not choose_dest()): pass

func choose_dest():
	var hex_loc = get_parent().get_parent().hexes[m_loc_ind]
	if( hex_loc.m_type == c.HEX_MOVE ):
		m_dir = hex_loc.m_dir
		m_dest_ind = get_parent().get_parent().get_ind_dir( m_loc_ind, hex_loc.m_dir )
		return true
	else:
		var momentum_ind = get_parent().get_parent().get_ind_dir(m_loc_ind, m_dir)
		if( get_parent().get_parent().check_bounds( momentum_ind ) and randf()>0.02 ):
			m_dest_ind = momentum_ind
			return true
		else:
			var tmp_dir = 1 + randi()%6
			var tmp_dest = get_parent().get_parent().get_ind_dir(m_loc_ind, tmp_dir)
			if ( get_parent().get_parent().check_bounds( tmp_dest ) ):
				m_dest_ind = tmp_dest
				m_dir = tmp_dir
				return true
			else: return false

func initialize(loc):
	m_loc_ind = loc
	while (not choose_dest()): pass
	set_pos( get_parent().get_parent().index_to_pix( m_loc_ind ) + Vector2(16, 16) )
	get_parent().get_parent().mote_added()
	show()

func _ready():
	set_process(true)


