extends Node2D

var Enemigo = preload("res://Enemigo.tscn") 
var Torreta = preload("res://Torreta.tscn") 

var num_torretas = 3
var list_pos = [] 
var control = ['S','A','D','G','F','H','K','J','L'] #teclas con las que se juega
var PlaneName = "Enemigo" #nombre de la instancia enemigo
var scr = 0 

#Función para contar los aviones y aumentar el nivel
func count_planes():
	var count = 0
	for p in get_children():
		if PlaneName in p.name:
			count += 1
	if count == 0:
		$Level.text = "Level: 1"
	elif count == 6:
		$Level.text = "Level: 5"
	else:
		$Level.text = "Level: " + String(count)
	return count

#función para aumentar el score o disminuir según si el avión choca 
#con una torre o con un misil
func score(name):
	if name.begins_with("Torre"):
		scr-=50
	else:
		scr+=5
	$Score.text = "Score: " + String(scr)

#Función para crear nuevos enemigos
func new_enemy():
	if count_planes() > 5:
		return
	var en = Enemigo.instance()
	#randomize()
	var x = rand_range(0,1280)
	var y = rand_range(0,150)
	var vel = rand_range(-200,200)
	var grav = rand_range(0, 10)
	var tor
	#var ang = rand_range(-PI, PI)
	if vel < 0: #para que no haga giros extraños
		tor = rand_range(0, 100)
	else:
		tor = rand_range(-100, 0)
	
	#en.position = Vector2(x,y)
	en.set_deferred("position", Vector2(x,y))
	en.set_deferred("applied_force",Vector2(grav,0))
	en.set_deferred("applied_torque", tor)
	#en.set_deferred("angular_velocity", ang)
	en.set_deferred("linear_velocity", Vector2(vel, grav))
	en.connect("plane_quit",self,"new_enemy")
	en.connect("plane_crash",self,"score") #para modificar el score
	call_deferred("add_child",en)

#Función para terminar el juego si ya no quedan torretas
func out():
	num_torretas -= 1
	if num_torretas == 0: 
		get_tree().paused = true
		$Level.hide()
		$GO.show()

#Función para crear nuevas torretas (sin empalmarse de inicio)
func new_gun(i):
	#var pos_x = []
	#randomize()
	var x = rand_range(0,1280)
	var y = 650#rand_range(0,100)
	list_pos.append(x)
	
	for j in i:#se comprueba si la torreta creada se empalma con las anteriores
		if list_pos[j] - 47 <= x + 47 and list_pos[j] + 47 >= x - 47:
			list_pos.pop_back()
			new_gun(i)
			return
	var torr = Torreta.instance()
#var pX = new_x(pos_x)
	torr.name = "Torre-" + String(i)
	#torr.set_deferred("position", Vector2(x,y))
	torr.position = Vector2(x,y)
	var cont = control[i*3] + control[(i*3)+1] + control[(i*3)+2]
	torr.get_node("base/gun/Label").text = cont #para utilizar los controles
	torr.get_node("base/gun/Label2").text = String(i) #para mostrar el numero de torreta
	#torr.connect("quit_gun",self,"new_gun")
	#call_deferred("add_child",torr)
	add_child(torr)
	
	#se emite una señal para saber cuantas torretas quedan
	torr.connect("quit_gun", self, "out") 

#Función inicial
func _ready():
	$ambient.play() #reproduce música de ambiente
	randomize()
	for i in num_torretas:
		new_gun(i)
		#print(pos_ant)
	#connect("plane_quit", self, "new_enemy")
	#for i in range(10):
	new_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
