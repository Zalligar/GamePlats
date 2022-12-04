extends Sprite
signal shoot
var target = null
var can_shoot = true
var Bullet = preload("res://Bullet.tscn")
func flash():
	$fires.show()
	yield(get_tree().create_timer(0.09), "timeout")
	$fires.hide()
func shoot():
	if can_shoot:
		can_shoot = false
		yield(get_tree().create_timer(0.05), "timeout")
		emit_signal("shoot", $puntero.global_transform)
		emit_signal("shoot", $puntero2.global_transform)
		flash()
		var bullet = Bullet.instance()
		var posPun = $puntero.get("position")
		var posPun2 = $puntero2.get("position")
		bullet.set_deferred("position", posPun)
		bullet.set_deferred("velocity", posPun.y * bullet.speed)
		call_deferred("add_child", bullet)
		bullet.sound()
		can_shoot = true
func _ready():
	pass 
var tecla
func _process(delta):
	if Input.is_physical_key_pressed($Label.text.ord_at(0)):
		visible = 0
		shoot()
		visible = 1
	elif Input.is_physical_key_pressed($Label.text.ord_at(1)):
			if rotation_degrees > -90:
				rotation_degrees -= 6
	elif Input.is_physical_key_pressed($Label.text.ord_at(2)):
			if rotation_degrees < 90:
				rotation_degrees += 6
