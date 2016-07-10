# Hex directions
const DIR_N = 0
const DIR_NE = 1
const DIR_SE = 2
const DIR_S = 3
const DIR_SW = 4
const DIR_NW = 5
const DIR_NONE = 6

# Hex turns (temp moved into mote.gd)
#const TURN_CONTINUE = 0
#const TURN_RIGHT_SOFT = 1
#const TURN_RIGHT_HARD = 2
#const TURN_REVERSE = 3
#const TURN_LEFT_HARD = 4
#const TURN_LEFT_SOFT = 5
#func dir_turn(dir, turn): return (dir+turn)%6

# max size of the game board
const COLX = 50
const ROWY = 25

# gameplay modes
const MODE_BUILD		= 0
const MODE_RUN			= 1

# glyph types
const HEX_BLANK			= 0
const HEX_MOVE			= 1
const HEX_EXTRACT		= 2
const HEX_TERMINUS		= 3

# element placeholder for initialization
const EL_NONE			= -1

# mote elements: life
const EL_ACRID			= 0
const EL_VENOM			= 1
const EL_VITAL			= 2
const EL_MEND			= 3
const EL_SOOTHE			= 4
const EL_SPIRIT			= 5
const EL_DRAIN			= 6
const EL_SEDATE			= 7

# mote elements: spark
const EL_SHOCK			= 10
const EL_BOLT			= 11
const EL_SURGE			= 12
const EL_THUNDER		= 13
const EL_BRIGHT			= 14
const EL_FLARE			= 15
const EL_MIND			= 16
const EL_SHARP			= 17

# mote elements: flow
const EL_STREAM			= 20
const EL_WIND			= 21
const EL_WATER			= 22
const EL_DELUGE			= 23
const EL_GUIDE			= 24
const EL_VORTEX			= 25
const EL_IMPACT			= 26
const EL_BLOOD			= 27

# mote elements: fire
const EL_EMBER			= 30
const EL_FLAME			= 31
const EL_BLAZE 			= 32
const EL_SMOKE			= 33
const EL_FUEL			= 34
const EL_FORGE			= 35
const EL_BURST			= 36
const EL_DETONATE		= 37

# mote elements: void
const EL_CHILL			= 40
const EL_FROST			= 41
const EL_SHADOW			= 42
const EL_IRON			= 43
const EL_SEAL			= 44
const EL_NULL			= 45
const EL_DAMPEN			= 46
const EL_BONE			= 47

# mote elements: chaos
const EL_BLIGHT			= 50
const EL_WILD			= 51
const EL_OOZE			= 52
const EL_ASH			= 53
const EL_RUST			= 54

const EL_SHATTER		= 55
const EL_TWIST			= 56

















