extends ItemList

const c = preload("constants.gd")			# global constants loaded from another script
var ref_hexgrid								# reference to the hexgrid

func _ready():
	add_item("[0] Blank Hex", null, true)
	add_item("[1] Transport", null, true)
	add_item("[2] Extract", null, true)
	add_item("[3] Terminus", null, true)
	ref_hexgrid = get_parent().get_parent().get_node("hexgrid")
	set_process(true)

func _process(delta):
	if(ref_hexgrid.m_mode == c.MODE_BUILD):
		if(is_selected(0)): ref_hexgrid.glyph_type = c.HEX_BLANK
		if(is_selected(1)): ref_hexgrid.glyph_type = c.HEX_MOVE
		if(is_selected(2)): ref_hexgrid.glyph_type = c.HEX_EXTRACT
		if(is_selected(3)): ref_hexgrid.glyph_type = c.HEX_TERMINUS
		
		if( Input.is_action_pressed("hex_blank")):		select(0)
		if( Input.is_action_pressed("hex_move")):		select(1)
		if( Input.is_action_pressed("hex_extract")):	select(2)
		if( Input.is_action_pressed("hex_terminus")): 	select(3)



