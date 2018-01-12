extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var file_name = 'user://save.txt'
var last_line = 0

func _ready():

	var file = File.new()
	
	#if file does not exist, create.
	if !file.file_exists(file_name):
		file.open(file_name, File.WRITE)

	#read out file contents into array. count number of lines
	file.open(file_name, File.READ_WRITE)
	var array = []
	while(!file.eof_reached()):
		var line = file.get_line()
		#if last line does not contain anythign do not copy
		if file.eof_reached() && line == '':
			var x = 0 #how do you add an empty line of code ????
		else:
			array.push_back(line)
			last_line += 1

	#Write array data back into file
	file.open(file_name, File.WRITE)
	array.append(str('TEST ', last_line))
	for i in range(array.size()):
		file.store_line(array[i])
	file.close()

	#print contents of file from array
	for i in range(array.size()):
		print(array[i])
