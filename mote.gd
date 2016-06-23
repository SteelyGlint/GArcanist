extends Sprite
# mote class, grandchild of the hexgrid

const c = preload("constants.gd")

var m_dest_ind							# destination hex this mote is moving towards
var m_curr_ind							# index of current mote location on the hex grid
var m_from_ind							# index of hex this mote is coming from

var m_dir = c.DIR_NONE					# direction of travel
var el_array = [c.EL_NONE, c.EL_NONE, c.EL_NONE]

var marked_for_death = false			# used to destroy the mote
var m_offset = Vector2(0, 0)			# purely graphical offset so motes don't all stack together

var ref_hexgrid							# reference to the hexgrid
var ref_hex_dict						# reference to the dictionary containing all hex objects

var pix_from = Vector2(0, 0)
var pix_curr = Vector2(0, 0)
var pix_dest = Vector2(0, 0)

func _process(delta):
	var progress = ref_hexgrid.tick_progress / 60.0
	
	# old linear movement, index_to_pix() function is slow
	#set_pos( m_offset + (1-progress)*ref_hexgrid.index_to_pix( m_curr_ind ) + progress*ref_hexgrid.index_to_pix( m_dest_ind ) )

	# quadratic Bezier movement
	set_pos( m_offset + ((1-progress)*(1-progress)*(pix_from+pix_curr))\
		+ (4*(1-progress)*progress*pix_curr) + (progress*progress*(pix_dest+pix_curr)) )
	
	if(marked_for_death):
		ref_hexgrid.removed_mote()
		self.free()

func tick():
	if( ref_hex_dict[m_dest_ind].m_type != c.HEX_TERMINUS ):
		m_from_ind = m_curr_ind
		m_curr_ind = m_dest_ind
		m_offset = (m_offset + Vector2( randf()-0.5, randf()-0.5 )) * 0.98
		while (not choose_dest()): pass
		
		ref_hex_dict[m_curr_ind].arr_motes.push_back(self)
		
		set_pixel_cache()
	else:
		marked_for_death = true

func set_pixel_cache():
	# pixel locations for position interpolation
	pix_from = 0.5 * ref_hexgrid.index_to_pix(m_from_ind)
	pix_curr = 0.5 * ref_hexgrid.index_to_pix(m_curr_ind)
	pix_dest = 0.5 * ref_hexgrid.index_to_pix(m_dest_ind)

func el_to_str(elem):
	if(c.EL_NONE == elem): return "None"
	if(c.EL_VENOM == elem): return "Venom"
	if(c.EL_BOLT == elem): return "Bolt"
	return "Unknown"

func get_el_string():
	return el_to_str(el_array[0]) + " " + el_to_str(el_array[1]) + " " + el_to_str(el_array[2])

func choose_dest():
	var hex_loc = ref_hex_dict[m_curr_ind]
	if( hex_loc.m_type == c.HEX_MOVE ):
		m_dir = hex_loc.m_dir
		m_dest_ind = ref_hexgrid.get_ind_dir( m_curr_ind, hex_loc.m_dir )
		return true
	else:
		var momentum_ind = ref_hexgrid.get_ind_dir(m_curr_ind, m_dir)
		if( ref_hexgrid.check_bounds( momentum_ind ) and randf()>0.01 ):
			m_dest_ind = momentum_ind
			return true
		else:
			var tmp_dir = 1 + randi()%6
			var tmp_dest = ref_hexgrid.get_ind_dir(m_curr_ind, tmp_dir)
			if ( ref_hexgrid.check_bounds( tmp_dest ) ):
				m_dest_ind = tmp_dest
				m_dir = tmp_dir
				return true
			else: return false

func initialize(loc):
	m_curr_ind = loc
	m_from_ind = loc
	ref_hexgrid = get_parent().get_parent()
	ref_hex_dict = ref_hexgrid.hexes
	while (not choose_dest()): pass
	set_pos( ref_hexgrid.index_to_pix( m_curr_ind ) )
	for el in range(3):
		if( randi()%2 == 1 ): el_array[el] = c.EL_VENOM
		else: el_array[el] = c.EL_BOLT
	set_pixel_cache()
	show()

func _ready():
	set_process(true)


