extends Node2D

const MAX_BULLETS := 1000

class Bullet:
	var pos: Vector2
	var vel: Vector2
	var life: float
	var damage: int
	var active: bool = false
	var last_pos: Vector2
	var isplayer : bool #true if player fires the bullet
	var visual: Node2D
	
	func deactivate():
		self.active = false
		self.visual.active = false

var bullets: Array[Bullet] = []

var space_state: PhysicsDirectSpaceState2D

func _ready():
	space_state = get_world_2d().direct_space_state

	for i in MAX_BULLETS:
		bullets.append(Bullet.new())


func spawn_bullet(position: Vector2, direction: Vector2, speed: float, damage: int,isplayer:bool = true):
	for b in bullets:
		if !b.active:
			b.active = true
			b.pos = position
			b.last_pos = position
			b.vel = direction.normalized() * speed
			b.life = 3.0
			b.damage = damage
			b.isplayer = isplayer
			b.visual = preload("res://Scenes/Bullet/bullet.tscn").instantiate()
			get_tree().current_scene.add_child(b.visual)
			b.visual.global_position = position
			return


func _physics_process(delta):
	for b in bullets:
		if !b.active:
			continue

		b.life -= delta
		if b.life <= 0:
			b.active = false
			continue

		b.last_pos = b.pos
		b.pos += b.vel * delta
		
		if b.visual:
			b.visual.global_position = b.pos
		_check_collision(b)


func _check_collision(b: Bullet):
	var query = PhysicsRayQueryParameters2D.create(b.last_pos, b.pos)
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result["collider"]
		if collider.name != "Player":
			print(collider.name)
			var sm = get_tree().current_scene.get_node("EnemyStateMachine")

			var key = collider.get_instance_id()

			if sm.idindex.has(key):
				print(sm.idindex[key])
			else:
				print("Key not found")
				
			b.deactivate()
