extends Sprite

var loc_ind
var dest_ind
var progress = 0.0
var offset = Vector2(0, 0)
var marked_for_death = false

func _process(delta):
	if( progress < 1.0 ):
		progress += delta
	else:
		progress = 0
		loc_ind = dest_ind
		while (not choose_dest()): pass
		if(randf() < 0.4): marked_for_death = true
	set_pos( (1-progress)*get_parent().index_to_pix( loc_ind ) + progress*get_parent().index_to_pix( dest_ind ) )
	if(marked_for_death): self.free()

func choose_dest():
	var dir = randf()
	var temp_dest
	if  ( dir < 0.166 ): temp_dest = get_parent().get_ind_N(loc_ind)
	elif( dir < 0.333 ): temp_dest = get_parent().get_ind_NW(loc_ind)
	elif( dir < 0.5 ):   temp_dest = get_parent().get_ind_NE(loc_ind)
	elif( dir < 0.666 ): temp_dest = get_parent().get_ind_SW(loc_ind)
	elif( dir < 0.833 ): temp_dest = get_parent().get_ind_SE(loc_ind)
	else:                temp_dest = get_parent().get_ind_S(loc_ind)
	
	if ( get_parent().check_bounds( temp_dest ) ):
		dest_ind = temp_dest
		return true
	else: return false

func initialize(loc):
	loc_ind = loc
	while (not choose_dest()): pass
	set_pos( get_parent().index_to_pix( loc_ind ) + Vector2(16, 16) )
	show()

func _ready():
	set_process(true)


