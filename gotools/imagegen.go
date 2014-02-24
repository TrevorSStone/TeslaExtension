package main

import (
	"code.google.com/p/freetype-go/freetype"
	"code.google.com/p/freetype-go/freetype/truetype"
	"fmt"
	"image"
	"image/color"
	"image/png"
	"io/ioutil"
	"os"
)

var (
	fontfile     = "./fontdata/luxisr.ttf"
	size         = float64(24)
	spacing      = float64(1)
	colorstrings = []string{
		"black",
		"blue",
		"brown",
		"gray",
		"green",
		"newred",
		"pearlwhite",
		"red",
		"silver",
		"white",
	}
	colors = []color.Color{
		color.RGBA{uint8(28), uint8(28), uint8(28), 255},
		color.RGBA{uint8(20), uint8(24), uint8(37), 255},
		color.RGBA{uint8(69), uint8(64), uint8(57), 255},
		color.RGBA{uint8(90), uint8(90), uint8(93), 255},
		color.RGBA{uint8(35), uint8(46), uint8(43), 255},
		color.RGBA{uint8(121), uint8(0), uint8(7), 255},
		color.RGBA{uint8(218), uint8(218), uint8(218), 255},
		color.RGBA{uint8(78), uint8(19), uint8(18), 255},
		color.RGBA{uint8(188), uint8(188), uint8(188), 255},
		color.RGBA{uint8(237), uint8(237), uint8(237), 255},
	}
	bgcolor = []*image.Uniform{
		image.White,
		image.White,
		image.White,
		image.White,
		image.White,
		image.White,
		image.Black,
		image.White,
		image.White,
		image.Black,
	}
	font *truetype.Font
)

func drawImage(i int, name, realname string, h, w int, dpi float64) {
	f, err := os.Create(name)
	if err != nil {
		println(err)
		os.Exit(1)
	}
	m := image.NewRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < w; y++ {
		for x := 0; x < h; x++ {
			m.Set(y, x, colors[i])
		}
	}
	c := freetype.NewContext()
	fg := bgcolor[i]
	c.SetDPI(dpi)
	c.SetFont(font)
	c.SetFontSize(14)
	c.SetClip(m.Bounds())
	c.SetHinting(freetype.NoHinting)
	c.SetDst(m)
	c.SetSrc(fg)
	_, err = c.DrawString(realname, freetype.Pt(0, 20))
	c.SetFontSize(12)
	_, err = c.DrawString("Waiting for Tesla's persmisson to use real image", freetype.Pt(0, h-10))
	c.SetFontSize(25)
	size := fmt.Sprintf("%dx%d", w, h)
	_, err = c.DrawString(size, freetype.Pt(w/2, h/2))

	if err != nil {
		fmt.Println(err)
		return
	}
	if err = png.Encode(f, m); err != nil {
		println(err)
	}
}

func main() {
	err := os.MkdirAll("./images/car", 0777)
	if err != nil {
		fmt.Println(err)
		return
	}
	err = os.MkdirAll("./images/battery", 0777)
	if err != nil {
		fmt.Println(err)
		return
	}
	err = os.MkdirAll("./images/climate", 0777)
	if err != nil {
		fmt.Println(err)
		return
	}
	err = os.MkdirAll("./images/navicons", 0777)
	if err != nil {
		fmt.Println(err)
		return
	}
	fontBytes, err := ioutil.ReadFile(fontfile)
	if err != nil {
		fmt.Println(err)
		return
	}
	font, err = freetype.ParseFont(fontBytes)
	if err != nil {
		fmt.Println(err)
		return
	}
	dpi := float64(37)
	w := 142
	h := 79
	for i, v := range colorstrings {
		name := "./images/car/frunk_open_" + v + ".png"
		realname := "images/car/frunk_open_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 466
	h = 183
	dpi = 70
	for i, v := range colorstrings {
		name := "./images/car/body_" + v + ".png"
		realname := "images/car/body_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 127
	h = 135
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/frunk_closed_" + v + ".png"
		realname := "images/car/frunk_closed_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 125
	h = 108
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/left_front_closed_" + v + ".png"
		realname := "images/car/left_front_closed_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 89
	h = 181
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/left_front_open_" + v + ".png"
		realname := "images/car/left_front_open_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 114
	h = 109
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/left_rear_closed_" + v + ".png"
		realname := "images/car/left_rear_closed_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 94
	h = 179
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/left_rear_open_" + v + ".png"
		realname := "images/car/left_rear_open_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 57
	h = 116
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/right_front_open_" + v + ".png"
		realname := "images/car/right_front_open_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 45
	h = 98
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/right_rear_open_" + v + ".png"
		realname := "images/car/right_rear_open_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 161
	h = 55
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/roof_" + v + ".png"
		realname := "images/car/roof_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 118
	h = 105
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/trunk_closed_" + v + ".png"
		realname := "images/car/trunk_closed_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 145
	h = 106
	dpi = 37
	for i, v := range colorstrings {
		name := "./images/car/trunk_open_" + v + ".png"
		realname := "images/car/trunk_open_" + v + ".png"
		drawImage(i, name, realname, h, w, dpi)
	}
	w = 106
	h = 79
	dpi = 37
	name := "./images/car/right_front_closed.png"
	realname := "images/car/right_front_closed.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 95
	h = 76
	dpi = 37
	name = "./images/car/right_rear_closed.png"
	realname = "images/car/right_rear_closed.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 547
	h = 452
	dpi = 70
	name = "./images/car/bg_car.png"
	realname = "images/car/bg_car.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 304
	h = 103
	dpi = 37
	name = "./images/car/charge_cable_long.png"
	realname = "images/car/charge_cable_long.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 12
	h = 9
	dpi = 37
	name = "./images/car/charge_port_closed.png"
	realname = "images/car/charge_port_closed.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 10
	h = 10
	dpi = 37
	name = "./images/car/charge_port_on.png"
	realname = "images/car/charge_port_on.png"
	drawImage(4, name, realname, h, w, dpi)
	w = 10
	h = 9
	dpi = 37
	name = "./images/car/charge_port_open.png"
	realname = "images/car/charge_port_open.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 58
	h = 51
	dpi = 37
	name = "./images/car/rims_dark_front.png"
	realname = "images/car/rims_dark_front.png"
	drawImage(3, name, realname, h, w, dpi)
	w = 59
	h = 51
	dpi = 37
	name = "./images/car/rims_dark_rear.png"
	realname = "images/car/rims_dark_rear.png"
	drawImage(3, name, realname, h, w, dpi)
	w = 161
	h = 55
	dpi = 37
	name = "./images/car/sunroof_closed.png"
	realname = "images/car/sunroof_closed.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 161
	h = 55
	dpi = 37
	name = "./images/car/sunroof_open.png"
	realname = "images/car/sunroof_open.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 161
	h = 55
	dpi = 37
	name = "./images/car/sunroof_vent.png"
	realname = "images/car/sunroof_vent.png"
	drawImage(0, name, realname, h, w, dpi)

	w = 488
	h = 195
	dpi = 70
	name = "./images/battery/battery_empty.png"
	realname = "images/battery/battery_empty.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 427
	h = 60
	dpi = 50
	name = "./images/battery/battery_filled.png"
	realname = "images/battery/battery_filled.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 427
	h = 60
	dpi = 50
	name = "./images/battery/battery_highlight.png"
	realname = "images/battery/battery_highlight.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 427
	h = 60
	dpi = 50
	name = "./images/battery/battery_ticks_overlay.png"
	realname = "images/battery/battery_ticks_overlay.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 720
	h = 364
	dpi = 100
	name = "./images/climate/climate_car.png"
	realname = "images/climate/climate_car.png"
	drawImage(9, name, realname, h, w, dpi)
	w = 441
	h = 236
	dpi = 80
	name = "./images/climate/climate_car_cold.png"
	realname = "images/climate/climate_car_cold.png"
	drawImage(1, name, realname, h, w, dpi)
	w = 441
	h = 236
	dpi = 80
	name = "./images/climate/climate_car_hot.png"
	realname = "images/climate/climate_car_hot.png"
	drawImage(5, name, realname, h, w, dpi)
	w = 135
	h = 116
	dpi = 40
	name = "./images/climate/climate_car_front_cold.png"
	realname = "images/climate/climate_car_front_cold.png"
	drawImage(1, name, realname, h, w, dpi)
	w = 135
	h = 116
	dpi = 40
	name = "./images/climate/climate_car_front_hot.png"
	realname = "images/climate/climate_car_front_hot.png"
	drawImage(5, name, realname, h, w, dpi)
	w = 118
	h = 78
	dpi = 40
	name = "./images/climate/climate_car_rear_cold.png"
	realname = "images/climate/climate_car_rear_cold.png"
	drawImage(1, name, realname, h, w, dpi)
	w = 118
	h = 78
	dpi = 40
	name = "./images/climate/climate_car_rear_hot.png"
	realname = "images/climate/climate_car_rear_hot.png"
	drawImage(5, name, realname, h, w, dpi)
	w = 252
	h = 182
	dpi = 40
	name = "./images/climate/climate_temp_control_down.png"
	realname = "images/climate/climate_temp_control_down.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 252
	h = 182
	dpi = 40
	name = "./images/climate/climate_temp_control_down_hit.png"
	realname = "images/climate/climate_temp_control_down_hit.png"
	drawImage(8, name, realname, h, w, dpi)
	w = 322
	h = 182
	dpi = 40
	name = "./images/climate/climate_temp_control_down_c.png"
	realname = "images/climate/climate_temp_control_down_c.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 322
	h = 182
	dpi = 40
	name = "./images/climate/climate_temp_control_down_hit_c.png"
	realname = "images/climate/climate_temp_control_down_hit_c.png"
	drawImage(8, name, realname, h, w, dpi)

	w = 252
	h = 159
	dpi = 40
	name = "./images/climate/climate_temp_control_up.png"
	realname = "images/climate/climate_temp_control_up.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 252
	h = 159
	dpi = 40
	name = "./images/climate/climate_temp_control_up_hit.png"
	realname = "images/climate/climate_temp_control_up_hit.png"
	drawImage(8, name, realname, h, w, dpi)
	w = 322
	h = 159
	dpi = 40
	name = "./images/climate/climate_temp_control_up_c.png"
	realname = "images/climate/climate_temp_control_up_c.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 322
	h = 159
	dpi = 40
	name = "./images/climate/climate_temp_control_up_hit_c.png"
	realname = "images/climate/climate_temp_control_up_hit_c.png"
	drawImage(8, name, realname, h, w, dpi)

	w = 168
	h = 110
	dpi = 0
	name = "./images/climate/climate_temp_control_well.png"
	realname = "images/climate/climate_temp_control_well.png"
	drawImage(0, name, realname, h, w, dpi)
	w = 238
	h = 110
	dpi = 0
	name = "./images/climate/climate_temp_control_well_c.png"
	realname = "images/climate/climate_temp_control_well_c.png"
	drawImage(0, name, realname, h, w, dpi)

	w = 720
	h = 465
	dpi = 100
	name = "./images/climate/curve_metal.png"
	realname = "images/climate/curve_metal.png"
	drawImage(8, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_char_off.png"
	realname = "images/navicons/nav_char_off.png"
	drawImage(3, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_char_on.png"
	realname = "images/navicons/nav_char_on.png"
	drawImage(6, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_clim_off.png"
	realname = "images/navicons/nav_clim_off.png"
	drawImage(3, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_clim_on.png"
	realname = "images/navicons/nav_clim_on.png"
	drawImage(6, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_con_off.png"
	realname = "images/navicons/nav_con_off.png"
	drawImage(3, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_con_on.png"
	realname = "images/navicons/nav_con_on.png"
	drawImage(6, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_home_off.png"
	realname = "images/navicons/nav_home_off.png"
	drawImage(3, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_home_on.png"
	realname = "images/navicons/nav_home_on.png"
	drawImage(6, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_loc_off.png"
	realname = "images/navicons/nav_loc_off.png"
	drawImage(3, name, realname, h, w, dpi)

	w = 98
	h = 54
	dpi = 20
	name = "./images/navicons/nav_loc_on.png"
	realname = "images/navicons/nav_loc_on.png"
	drawImage(6, name, realname, h, w, dpi)

	w = 477
	h = 97
	dpi = 70
	name = "./images/bg_nav.png"
	realname = "images/bg_nav.png"
	drawImage(0, name, realname, h, w, dpi)

	w = 477
	h = 70
	dpi = 70
	name = "./images/bg_nav_curve.png"
	realname = "images/bg_nav_curve.png"
	drawImage(0, name, realname, h, w, dpi)
	//Icons

	w = 16
	h = 16
	dpi = 100
	name = "./images/icon16.png"
	drawIcon(name, h, w, dpi)

	w = 19
	h = 19
	dpi = 119
	name = "./images/icon19.png"
	drawIcon(name, h, w, dpi)

	w = 38
	h = 38
	dpi = 238
	name = "./images/icon38.png"
	drawIcon(name, h, w, dpi)

	w = 48
	h = 48
	dpi = 300
	name = "./images/icon48.png"
	drawIcon(name, h, w, dpi)

	w = 128
	h = 128
	dpi = 800
	name = "./images/icon128.png"
	drawIcon(name, h, w, dpi)

	w = 96
	h = 96
	dpi = 600
	name = "./images/icon96.png"
	drawIcon(name, h, w, dpi)
}

func drawIcon(name string, h, w int, dpi float64) {
	f, err := os.Create(name)
	if err != nil {
		println(err)
		os.Exit(1)
	}
	m := image.NewRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < w; y++ {
		for x := 0; x < h; x++ {
			m.Set(y, x, color.RGBA{uint8(229), uint8(24), uint8(55), 255})
		}
	}
	c := freetype.NewContext()
	fg := image.White
	c.SetDPI(dpi)
	c.SetFont(font)
	c.SetFontSize(16)
	c.SetClip(m.Bounds())
	c.SetHinting(freetype.NoHinting)
	c.SetDst(m)
	c.SetSrc(fg)
	_, err = c.DrawString("T", freetype.Pt(w/16, int(float64(h)*1.2)))
	c.SetFontSize(12)
	if err != nil {
		fmt.Println(err)
		return
	}
	if err = png.Encode(f, m); err != nil {
		println(err)
	}
}
