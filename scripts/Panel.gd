extends Panel

var config_dir = OS.get_environment("HOME").path_join(".config/shader_editor")
var config_path = config_dir.path_join("config.txt")

@onready var lineedit: LineEdit = $VBox/LineEdit

func _ready():
	DirAccess.open(config_dir)
	if DirAccess.get_open_error() != OK:
		DirAccess.make_dir_absolute(config_dir)
	var config: FileAccess = FileAccess.open(config_path, FileAccess.READ_WRITE)
	if not config:
		config = FileAccess.open(config_path, FileAccess.WRITE)
		config.store_string("Not set")
		lineedit.set_text("Not set")
		return
	lineedit.set_text(config.get_as_text())

func _process(_delta):
	if size.x < 370:
		hide()
		set_process(false)

func _input(event):
	if event.is_action("ui_cancel"):
		hide()
		return
	if event.is_action("ui_text_submit"):
		hide()	
		get_parent().setup_watcher(lineedit.text)
		store_config()


func store_config():
	var config = FileAccess.open(config_path, FileAccess.WRITE)
	config.store_string(lineedit.text)
	
