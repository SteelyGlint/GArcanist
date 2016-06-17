extends Control

const c = preload("constants.gd")				# global constants loaded from another script

func _ready():
	# setup various gui layers
	get_node("gui_build").set_ignore_mouse(true)
	get_node("gui_run").set_ignore_mouse(true)

func _on_butt_run_pressed():
	get_node("hexgrid").m_mode = c.MODE_RUN
	get_node("gui_build").hide()
	get_node("gui_run").show()
	get_node("gui_run").get_node("mote_observer").display(Vector2(-1,-1))

func _on_butt_build_pressed():
	get_node("hexgrid").m_mode = c.MODE_BUILD
	get_node("gui_run").hide()
	get_node("gui_build").show()
