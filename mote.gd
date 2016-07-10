extends Sprite
# mote class, grandchild of the hexgrid

const c = preload("constants.gd")

var m_dest_ind							# destination hex this mote is moving towards
var m_curr_ind							# index of current mote location on the hex grid
var m_from_ind							# index of hex this mote is coming from

var m_dir = c.DIR_NONE					# direction of travel
const TURN_CONTINUE = 0
const TURN_RIGHT_SOFT = 1
const TURN_RIGHT_HARD = 2
const TURN_REVERSE = 3
const TURN_LEFT_HARD = 4
const TURN_LEFT_SOFT = 5
func dir_turn(dir, turn): return (dir+turn)%6

var el_array = [c.EL_NONE, c.EL_NONE, c.EL_NONE]

var marked_for_death = false			# used to destroy the mote
var m_offset = Vector2(0, 0)			# purely graphical offset so motes don't all stack together

var ref_hexgrid							# reference to the hexgrid
var ref_hex_dict						# reference to the dictionary containing all hex objects
var ref_curr_hex						# reference to the hex containing the mote

var pix_from = Vector2(0, 0)			# cached pixel values, speed up position interp
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
		free()

func tick():
	m_from_ind = m_curr_ind
	m_curr_ind = m_dest_ind
	ref_curr_hex = ref_hex_dict[m_curr_ind]
	
	if( ref_hex_dict[m_dest_ind].m_type != c.HEX_TERMINUS ):
		ref_curr_hex.arr_motes.push_back(self)
		
		if(m_dir != c.DIR_NONE):
			ref_hexgrid.hexes[m_dest_ind].m_dir_open[ dir_turn(m_dir, TURN_REVERSE) ] = false
		else:
			ref_curr_hex.m_incoming += 1
		
		m_offset = (m_offset + Vector2( randf()-0.5, randf()-0.5 )) * 0.98
	else:
		marked_for_death = true
		
func tick_part2():
	choose_dest()
	set_pixel_cache()
	pass

# ugly, copied directly from hexgen.gd for a speedup
func index_to_pix(ind): return Vector2( 16 + ind.x*28, 32 + ind.y*32 - ((int(ind.x)%2) * 16) )

func set_pixel_cache():
	# pixel locations for position interpolation
	pix_from = 0.5 * index_to_pix(m_from_ind)
	pix_curr = 0.5 * index_to_pix(m_curr_ind)
	pix_dest = 0.5 * index_to_pix(m_dest_ind)

func el_to_str(elem):
	if(c.EL_NONE == elem): return "None"
	if(c.EL_VENOM == elem): return "Venom"
	if(c.EL_BOLT == elem): return "Bolt"
	return "Unknown"

func get_el_string():
	return el_to_str(el_array[0]) + " " + el_to_str(el_array[1]) + " " + el_to_str(el_array[2])

# mote tries to go in the given direction, from the current hex
func try_dir(dir):
	if(!ref_curr_hex.m_dir_open[dir]):
		return false;
	var dest_ind = ref_hexgrid.get_ind_dir(m_curr_ind, dir)
	if(!ref_hexgrid.check_bounds( dest_ind ) ):
		return false;
	if(ref_hexgrid.hexes[dest_ind].m_incoming >= 2):
		return false;
	
	ref_curr_hex.m_dir_open[dir] = false
	m_dir = dir
	m_dest_ind = dest_ind
	ref_hexgrid.hexes[m_dest_ind].m_dir_open[ dir_turn(m_dir, TURN_REVERSE) ] = false
	ref_hexgrid.hexes[dest_ind].m_incoming += 1
	return true;

func choose_dest():
	if( ref_curr_hex.m_type == c.HEX_MOVE ):
		var dest_ind = ref_hexgrid.get_ind_dir(m_curr_ind, ref_curr_hex.m_dir)
		m_dir = ref_curr_hex.m_dir
		m_dest_ind = dest_ind
		ref_hexgrid.hexes[dest_ind].m_incoming += 1
		return true
	
	if( m_dir != c.DIR_NONE ):
		if(try_dir(m_dir)): return true;
			
		var left_preference = randi()%2
		if(left_preference and try_dir(dir_turn(m_dir, TURN_LEFT_SOFT))): return true;
		if(try_dir(dir_turn(m_dir, TURN_RIGHT_SOFT))): return true;
		if(try_dir(dir_turn(m_dir, TURN_LEFT_SOFT))): return true;
		
		if(left_preference and try_dir(dir_turn(m_dir, TURN_LEFT_HARD))): return true;
		if(try_dir(dir_turn(m_dir, TURN_RIGHT_HARD))): return true;
		if(try_dir(dir_turn(m_dir, TURN_LEFT_HARD))): return true;
		
		m_dir = c.DIR_NONE
		ref_curr_hex.m_incoming += 1
		return false;
	else:
		var seed_dir = 6+randi()%6
		var increment = 2*(randi()%2) - 1
		for num in range(6):
			var dest_dir = (seed_dir+(num*increment))%6
			if(try_dir(dest_dir)): return true;

func initialize(loc):
	m_curr_ind = loc
	m_from_ind = loc
	m_dest_ind = loc
	ref_hexgrid = get_parent().get_parent()
	ref_hex_dict = ref_hexgrid.hexes
	ref_curr_hex = ref_hex_dict[m_curr_ind]
	set_pos( ref_hexgrid.index_to_pix( m_curr_ind ) )
	for el in range(3):
		if( randi()%2 == 1 ): el_array[el] = c.EL_VENOM
		else: el_array[el] = c.EL_BOLT
	set_pixel_cache()
	show()

func _ready():
	set_process(true)


