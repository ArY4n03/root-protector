extends Node2D

const MAX_BULLETS := 200

var bullet_pool: Array[Area2D]

class Bullet:
	var pos: Vector2
	var vel: Vector2
	var life: float
	var damage: int
	var active: bool = false
	var last_pos: Vector2
	var isplayer : bool #true if player fires the bullet
	var visual: Node2D
	var bulletIdx : int
	
	func deactivate():
		self.active = false
		self.visual.hide()
		
var bullets: Array[Bullet] = []

var space_state: PhysicsDirectSpaceState2D

func _ready():
	space_state = get_world_2d().direct_space_state

	for i in MAX_BULLETS:
		bullets.append(Bullet.new())
	
func create_bullet_pool():	
	for i in MAX_BULLETS:
		var b = preload("res://Scenes/Bullet/bullet.tscn").instantiate()
		get_tree().current_scene.get_node("BulletContainer").add_child(b)
		b.hide()
		#b.set_process(false)
		bullet_pool.append(b)

func spawn_bullet(position: Vector2, direction: Vector2, speed: float, damage: int, isplayer: bool = true):

	for i in MAX_BULLETS:
		if !bullets[i].active:

			var b = bullets[i]
			b.active = true
			b.pos = position
			b.last_pos = position
			b.vel = direction.normalized() * speed
			b.life = 3.0
			b.damage = damage
			b.isplayer = isplayer
			b.bulletIdx = i
			
			var v = bullet_pool[b.bulletIdx]
			b.visual = v
			b.visual.global_position = position
			b.visual.show()
			return


func _physics_process(delta):
	for b in bullets:
		if !b.active:
			continue

		b.life -= delta
		if b.life <= 0:
			bullet_pool[b.bulletIdx]
			b.deactivate()
			continue

		b.last_pos = b.pos
		b.pos += b.vel * delta
		
		if b.visual:
			b.visual.global_position = b.pos
		_check_collision(b)


func _check_collision(b: Bullet):
	var query = PhysicsRayQueryParameters2D.create(b.last_pos, b.pos)
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result["collider"]
		if collider.name != "Player":
			var sm = get_tree().current_scene.get_node("EnemyStateMachine")
			var key = collider.get_instance_id()
			
			sm.logoutCop(key)
			b.deactivate()
			
