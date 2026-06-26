extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var gravity = 900
var  SPEED = 300.0
var JUMP_VELOCITY = -490.0
var walkingspeed = 135


var fallkill  = 500 
var jumpcut:float = .5
var wasonfloor : bool = false
var spawnposition :Vector2
enum states{
	idle,
	walk,
	run,
	jump,
	fall
}

var state:states = states.idle

@onready var jumpbuffer: Timer = $jumpbuffer

@onready var hurtbox: Area2D = $hurtbox

@onready var timer: Timer = $Timer



func  _ready() -> void:
	spawnposition = global_position
	hurtbox.area_entered.connect(_on_hurtbox_entered)
	




func _physics_process(delta: float) -> void:
	checkfall()
	Gravity(delta)
	dojump()
	movement()
	updatestates()
	animation()
	wasonfloor = is_on_floor()
	move_and_slide()
	if wasonfloor and not is_on_floor() and velocity.y >= 0:
		timer.start(0.12)	
	
	
	
	
	
# adding gravity

func Gravity(delta:float) -> void:
	if is_on_floor():
		return
	if velocity.y < 0 and not Input.is_action_just_pressed("jump"):
		velocity.y += gravity* delta * jumpcut
	else :
		velocity.y += gravity *delta
	
	
	
# jump

func dojump() -> void:
	if Input.is_action_just_pressed("jump"):
		jumpbuffer.start(
		)
	var canjump : = is_on_floor() or not timer.is_stopped()
	if not jumpbuffer.is_stopped() and canjump:
		velocity.y = JUMP_VELOCITY
		timer.stop()
		jumpbuffer.stop()
		
		
	
	
	
	# movemennt
	
	
func movement() -> void :
	var dir : = Input.get_axis("left","right")
	var isrunning =  Input.is_action_pressed("running")
	if dir != 0:
		var speed =  SPEED if isrunning else walkingspeed
		velocity.x = dir*speed
		animated_sprite_2d.flip_h = dir < 0
	else :
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 0.2)
		
		
		
		#state mechine
		
		
		
func updatestates() -> void :
	if not is_on_floor() :
		state = states.jump if velocity.y < 0 else states.fall
	elif abs(velocity.x)>5 :
		state = states.run  if Input.is_action_pressed("running") else states.walk
	else :
		state = states.idle
		
		
		
		
	#animation manager
	
func animation() -> void :
	match state:
		states.idle: animated_sprite_2d.play("idle")
		states.run : animated_sprite_2d.play("run")
		states.walk:animated_sprite_2d.play("walk")
		states.jump ,states.fall : animated_sprite_2d.play("jump")
		
		
		
		
	# position reseter
	
func reset()-> void :
	global_position = spawnposition
	velocity = Vector2.ZERO
	get_tree().reload_current_scene()
	
	
	
func checkfall() -> void:
	if global_position.y > fallkill :
		reset()
	
	


func _on_hurtbox_entered(area:Area2D) -> void:
	if area.is_in_group("spikes"):
		reset()
	
