extends Node

static func mm_to_pix_h(n):
	var dpi = OS.get_screen_dpi()
	var height = OS.get_screen_size().y
	var height_in_mm = 25.4 * height / dpi
	return n / height_in_mm * height

static func mm_to_pix_w(n):
	var dpi = OS.get_screen_dpi()
	var width = OS.get_screen_size().x
	var width_in_mm = 25.4 * width / dpi
	return n / width_in_mm * width
