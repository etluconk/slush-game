extends CharacterBody2D

var SPEED = 150.0
var ACC = 15
var jump_velocity = -200.0
var MAX_FALL_VEL = 300.0

# Set the gravity.
var gravity = 600

# Coyote time.
var COYOTE_TIME_CUTOFF = 0.1
var time_off_ground = 0

# Jump buffer.
var JUMP_BUFFER_CUTOFF = 0.3
var time_since_jump_pressed = 1

# Stick to walls for a little bit so wall jumps feel more natural.
var WALL_RELEASE_CUTOFF = 0.1
var time_on_wall = 0
var ground_jump_input = false

var running_volume_db = -19.0
var running_cycle = 0
var was_running = false

var direction = 0

func _ready():
	pass

func _physics_process(delta):
	global_rotation = 0

	# Get the input direction for handling the movement/deceleration.
	direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))

	if !global.p_alive:
		$AnimatedSprite2D.play("esplode")
	elif !global.p_slurping:
		$AnimatedSprite2D.show()

		if $SpawnTimer.is_stopped():
			apply_gravity(delta)
			handle_jump()
			handle_wall_jump()
			handle_y_vel_limits(delta)
			handle_h_movement(delta)
			handle_goo()

			move_and_slide()

			# Advance coyote time.
			time_off_ground += delta

			# Jump buffer.
			time_since_jump_pressed += delta
			if Input.is_action_just_pressed("jump"):
				time_since_jump_pressed = 0

			ground_jump_input = time_since_jump_pressed < JUMP_BUFFER_CUTOFF

			was_running = direction != 0

			# Falling / jumping animation
			if is_on_wall():
				$AnimatedSprite2D.play("idle")
			elif !is_on_floor():
				if velocity.y < 0:
					$AnimatedSprite2D.play("jump")
				else:
					$AnimatedSprite2D.play("fall")

			if is_on_wall_only():
				if get_wall_normal().x > 0:
					$AnimatedSprite2D.rotation_degrees = 90
				else:
					$AnimatedSprite2D.rotation_degrees = -90
			else:
				$AnimatedSprite2D.rotation_degrees = 0
		else:
			$AnimatedSprite2D.play("idle")
	else:
		slurp()

	global.p_pos = position

func apply_gravity(delta):
	gravity = 400 + int(velocity.y > 0) * 300

	if is_on_floor():
		time_off_ground = 0
	else:
		velocity.y += gravity * delta

func handle_jump():
	if ground_jump_input and (is_on_floor() or (time_off_ground < COYOTE_TIME_CUTOFF and velocity.y > 0)):

		if Input.is_action_pressed("jump"):
			velocity.y = jump_velocity
		else:
			velocity.y = jump_velocity / 2
		time_since_jump_pressed = JUMP_BUFFER_CUTOFF
		time_off_ground = COYOTE_TIME_CUTOFF
		#spawn_jump_particles()

		$SoundFX/Jump.pitch_scale = randf_range(1.1, 1.4)
		$SoundFX/Jump.play()

func handle_wall_jump():
	if is_on_wall_only():
		#$AnimatedSprite2D.play("wall")
		if ground_jump_input:
			var wall_norm = get_wall_normal()
			velocity.x = wall_norm.x * SPEED
			velocity.y = jump_velocity
			time_since_jump_pressed = JUMP_BUFFER_CUTOFF

			#spawn_wall_jump_particles()

			$SoundFX/Jump.pitch_scale = randf_range(1.1, 1.4)
			$SoundFX/Jump.play()

func handle_y_vel_limits(delta):
	# Jump height control.
	if Input.is_action_just_released("jump") and velocity.y < jump_velocity / 4:
		velocity.y = jump_velocity / 2

	# Limit falling velocity.
	if velocity.y > MAX_FALL_VEL: velocity.y = MAX_FALL_VEL

	if is_on_wall_only():
		var wall_norm = -get_wall_normal()
		if direction == wall_norm.x or direction == 0:
			direction = wall_norm.x
			time_on_wall = WALL_RELEASE_CUTOFF
		if direction != wall_norm.x:
			if time_on_wall > 0: direction = wall_norm.x
			time_on_wall -= delta

func handle_h_movement(delta):
	#$SoundFX/Run.volume_db = -80

	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * SPEED, ACC)
			#$SoundFX/Run.volume_db = running_volume_db
			if !was_running:
				#$SoundFX/Run.stop()
				#$SoundFX/Run.play()
				pass
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACC / 2)
		if is_on_floor(): $AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ACC)
		else:
			velocity.x = move_toward(velocity.x, 0, ACC / 2)
		if is_on_floor(): $AnimatedSprite2D.play("idle")

	if direction and is_on_floor_only():
		running_cycle -= delta

		if running_cycle < 0:
			running_cycle = 0.25
			#spawn_run_particles()
	else:
		running_cycle = 0

# Particle Spawners

#func spawn_jump_particles():
	#var Jump_particles = preload("res://scene/particles/jump_particles.tscn")
	#var jump_particles = Jump_particles.instantiate()
	#jump_particles.position = position
	#jump_particles.position.y += 2
	#get_parent().add_child(jump_particles)

#func spawn_wall_jump_particles():
	#var Jump_particles = preload("res://scene/particles/jump_particles.tscn")
	#var jump_particles = Jump_particles.instantiate()
	#jump_particles.position = position
	#if get_wall_normal().x > 0:
		#jump_particles.rotation_degrees = 90
		#jump_particles.position.x += 5
	#else:
		#jump_particles.rotation_degrees = -90
		#jump_particles.position.x -= 5
	#get_parent().add_child(jump_particles)

#func spawn_run_particles():
	#var Run_particles = preload("res://scene/particles/run_particles.tscn")
	#var run_particles = Run_particles.instantiate()
	#run_particles.position = position
	#run_particles.position.y += 2
	#get_parent().add_child(run_particles)

func handle_goo():
	if $GooDetector.has_overlapping_bodies():
		if is_on_floor():
			velocity.y = jump_velocity
			time_off_ground = COYOTE_TIME_CUTOFF
			ground_jump_input = false

			$SoundFX/Bonk.pitch_scale = randf_range(1.1, 1.4)
			$SoundFX/Bonk.play()
		if $HeadBonk.is_colliding():
			velocity.y = -jump_velocity

			$SoundFX/Bonk.pitch_scale = randf_range(1.1, 1.4)
			$SoundFX/Bonk.play()
		if is_on_wall():
			velocity.x = get_wall_normal().x * SPEED
			velocity.y = jump_velocity

			$SoundFX/Bonk.pitch_scale = randf_range(1.1, 1.4)
			$SoundFX/Bonk.play()

func slurp():
	if !$SoundFX/Slurp.is_playing():
		$SoundFX/Slurp.pitch_scale = randf_range(0.9, 1.1)
		$SoundFX/Slurp.play()
	$AnimatedSprite2D.play("yay")

func _on_slushy_detector_area_entered(area):
	global.p_slurping = true
	$SlurpTimer.start()

func show_slushy_scene():
	global.p_has_flippity = true
	global.monochrome_animation.emit()

func _on_slurp_timer_timeout():
	global.lev += 1
	global.reset_lev.emit()

func _on_ruh_roh_detector_body_entered(body):
	global.p_alive = false
	$DedTimer.start()
	$SoundFX/Ded.play()

func _on_ded_timer_timeout():
	global.reset_lev.emit()
