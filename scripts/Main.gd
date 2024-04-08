extends Control

var watcher: FsWatcher
var thread: Thread
var target: ShaderMaterial

@onready var colorRect : ColorRect = $ColorRect
@onready var rectMat   : Material  = colorRect.material

func _ready():
	target = rectMat

func _input(event):
	if event is InputEventMouseMotion:
		# send mouse movement to the shader - even if the shader doesn't have the param
		target.set_shader_parameter('mouse_position', get_local_mouse_position())

func show_panel():
	if watcher:
		watcher.stop()
	$Panel.show()
	$Panel.set_process(true)
	$Panel/VBox/LineEdit.grab_focus()

func setup_watcher(path: String):
	var arr: Array[String] = [path]
	watcher = FsWatcher.from_paths(arr)
	watcher.changed.connect(handle_signal)
	
	thread = Thread.new()
	thread.start(run)
	read_shader_file(path)

func run():
	watcher.start()
	call_deferred("cleanup")

func handle_signal(event: Dictionary):
	read_shader_file(event["paths"][0])

func cleanup():
	thread.wait_to_finish()
	watcher.free()

func read_shader_file(path: String):
	var dir = DirAccess.open(path)
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		if file.get_open_error():
			print("ERROR opening file")
		target.shader.set_code(file.get_as_text())

