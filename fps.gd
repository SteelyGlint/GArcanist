extends Label

var whitepix = load("res://whitepix.png")
var running_avg = 60.0
var last_frame = 0
var last_delta = 0.01
var time = 0.0

func _ready():
	for num in range(60):
		var newpix = Sprite.new()
		newpix.set_texture( whitepix )
		newpix.set_pos( Vector2(num+30, 0) )
		newpix.set_name( "pix" + str(num) )
		add_child(newpix)
	
	set_process(true)

func _process(delta):
	var d_inv = (1/delta)
	running_avg = running_avg*0.9 + d_inv*0.1
	set_text( str(floor(running_avg)) )
	
	time += delta
	if(time >= 1): time -= 1
	var curr_frame = int(floor(time*60))
	var tmp_ind = (last_frame + 1)%60
	
	get_node( "pix" + str( last_frame ) ).set_modulate( Color( 1, 1-(60.0-(1/last_delta))/60, 1-(60.0-(1/last_delta))/60 ) )
	
	while(tmp_ind != curr_frame and last_frame != curr_frame):
		var skipped = get_node( "pix" + str( tmp_ind ) )
		skipped.set_pos( Vector2(tmp_ind+30, 15 ) )
		skipped.set_modulate( Color( 0.5, 0, 0 ) )
		tmp_ind = (tmp_ind + 1)%60
	last_frame = curr_frame
	last_delta = delta
	
	var frame_pix = get_node( "pix" + str( curr_frame ) )
	frame_pix.set_pos( Vector2(curr_frame+30, 15-(0.25*d_inv) ) )
	frame_pix.set_modulate( Color( 1, 0.1, 0.1 ) )

