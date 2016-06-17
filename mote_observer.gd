extends Panel

const c = preload("constants.gd")			# global constants loaded from another script
var ref_hexgrid								# reference to the hexgrid
var ref_hex									# reference to the hex currently being observed
var m_index = Vector2(-1, -1)				# current hex being observed

func _ready():
	ref_hexgrid = get_parent().get_parent().get_node("hexgrid")

func display(index):
	if( index == Vector2(-1, -1) ):
		get_node( "hex_info" ).set_text( "-" )
		return
	
	m_index = index
	ref_hex = ref_hexgrid.hexes[m_index]
	
	if(ref_hex.m_type == c.HEX_BLANK): get_node( "hex_info" ).set_text( str(m_index) )
	if(ref_hex.m_type == c.HEX_MOVE): get_node( "hex_info" ).set_text( "move: " + str(m_index) )
	if(ref_hex.m_type == c.HEX_EXTRACT): get_node( "hex_info" ).set_text( "extract: " + str(m_index) )
	if(ref_hex.m_type == c.HEX_TERMINUS): get_node( "hex_info" ).set_text( "terminus: " + str(m_index) )
	
	get_node("mote_list").clear()
	for mote in ref_hex.arr_motes:
		get_node("mote_list").add_item( mote.get_el_string() )
	
	show()

