# global_vars.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node

var provinces_loaded = false

var zoom_level = 0.2

var mouse_over_province = false
var tooltip_text_province = ""
var selected_province = null
var selected_province_name = false
var selected_province_claimants = ""
var selected_country_name = ""

var player = "HNGK"
