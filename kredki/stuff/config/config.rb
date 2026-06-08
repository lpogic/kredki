# This is config loaded by default. You can overwrite or add your own definitions by reopening Kredki module.
#
#   require 'kredki'
#
#   module Kredki
#     color! :primary, 20, 50, 70, 255
#     keyboard! do
#       key! :escape, 58
#     end
#   end
#
# If you don't want to load the default configuration, you can set the path to your own:
#
#   require 'kredki/setup'
#   Kredki.config = './cutom_config.rb'
#
#   require 'kredki'
#
# This way 'custom_config.rb' will be loaded instead of the current file.

module Kredki

  color! nil, 211, 211, 211, 255
  color! false, 0, 0, 0, 0
  color! 0, 0, 0, 0, 0
  color! :transparent, 0, 0, 0, 0

  color! :white, 255, 255, 255, 255
  color! :black, 0, 0, 0, 255
  color! :red, 122, 0, 0, 255
  color! :green, 0, 122, 0, 255
  color! :blue, 0, 0, 122, 255
  color! :gray, 111, 111, 111, 255
  color! :light_gray, 211, 211, 211, 255
  color! :dark_gray, 88, 88, 88, 255
  color! :yellow, 170, 170, 0, 255
  color! :orange, "#f06000"
  color! :pink, 200, 50, 100, 255

  font! :maven_pro, "#{dir}/stuff/font/MavenPro-Medium.ttf"
  font! :martian_mono, "#{dir}/stuff/font/MartianMono-StdRg.ttf"

  clipboard!
  keyboard! do
    key! :escape, 27
    key! :f1, 1073741882
    key! :f2, 1073741883
    key! :f3, 1073741884
    key! :f4, 1073741885
    key! :f5, 1073741886
    key! :f6, 1073741887
    key! :f7, 1073741888
    key! :f8, 1073741889
    key! :f9, 1073741890
    key! :f10, 1073741891
    key! :f11, 1073741892
    key! :f12, 1073741893
    key! :backspace, 8
    key! :space, 32
    key! :enter, 13
    key! :left, 1073741904
    key! :right, 1073741903
    key! :up, 1073741906
    key! :down, 1073741905
    key! :one, 49
    key! :two, 50
    key! :three, 51
    key! :four, 52
    key! :five, 53
    key! :six, 54
    key! :seven, 55
    key! :eight, 56
    key! :nine, 57
    key! :zero, 48
    key! :minus, 45
    key! :equals, 61
    key! :backquote, 96
    key! :tab, 9
    key! :caps_lock, 1073741881
    key! :left_shift, 1073742049
    key! :left_ctrl, 1073742048
    key! :left_alt, 1073742048
    key! :right_alt, 1073742054
    key! :right_ctrl, 1073742052
    key! :right_shift, 1073742053
    key! :insert, 1073741897
    key! :home, 1073741898
    key! :page_up, 1073741899
    key! :delete, 127
    key! :end, 1073741901
    key! :page_down, 1073741902
    key! :print_screen, 1073741894
    key! :pause, 1073741895
    key! :scroll_lock, 1073741896
    key! :num_lock, 1073741907
    key! :keypad_slash, 1073741908
    key! :keypad_star, 1073741909
    key! :keypad_minus, 1073741910
    key! :keypad_plus, 1073741911
    key! :keypad_enter, 1073741912
    key! :keypad_delete, 1073741923
    key! :keypad_insert, 1073741922
    key! :keypad_one, 1073741913
    key! :keypad_two, 1073741914
    key! :keypad_three, 1073741915
    key! :keypad_four, 1073741916
    key! :keypad_five, 1073741917
    key! :keypad_six, 1073741918
    key! :keypad_seven, 1073741919
    key! :keypad_eight, 1073741920
    key! :keypad_nine, 1073741921
    key! :q, 113
    key! :w, 119
    key! :e, 101
    key! :r, 114
    key! :t, 116
    key! :y, 121
    key! :u, 117
    key! :i, 105
    key! :o, 111
    key! :p, 112
    key! :a, 97
    key! :s, 115
    key! :d, 100
    key! :f, 102
    key! :g, 103
    key! :h, 104
    key! :j, 106
    key! :k, 107
    key! :l, 108
    key! :z, 122
    key! :x, 120
    key! :c, 99
    key! :v, 118
    key! :b, 98
    key! :n, 110
    key! :m, 109
    key! :open_bracket, 91
    key! :close_bracket, 93
    key! :semicolon, 59
    key! :quote, 39
    key! :backslash, 92
    key! :comma, 44
    key! :dot, 46
    key! :slash, 47
    key! :windows, 1073742051
    key! :context, 1073741925
    key! :play, 1073742085
    key! :mute, 1073741951
    key! :volume_down, 1073741953
    key! :volume_up, 1073741952
    key! :house, 1073742093
    key! :mail, 1073742089
    key! :calculator, 1073742108
  end

  mouse! do
    button! :primary, 1
    button! :secondary, 3
    button! :scroll, 2
  
    set_scroll_speed 1.0
    set_scroll_speed_alt 0.5
  end

  joystick! do
    button! :a, 0
    button! :b, 1
    button! :x, 2
    button! :y, 3
    button! :l, 4
    button! :r, 5
    button! :f1, 6
    button! :f2, 7
    button! :f3, 8
    button! :f4, 9
    
    axis! :lx, 0
    axis! :ly, 1
    axis! :lz, 2
    axis! :rx, 3
    axis! :ry, 4
    axis! :rz, 5

    hat! :hat, 0 do
      state! :c, 0
      state! :t, 1
      state! :r, 2
      state! :tr, 3
      state! :b, 4
      state! :br, 6
      state! :l, 8
      state! :bl, 12
      state! :tl, 9
    end
  end

  # Thewolfkit glyphs

  # Alternative dynamic loading:
  # base = "#{dir}/stuff/glyph/thewolfkit"
  # Dir["*.svg", base: base].each do |file|
  #   glyph! file[..-17].tr("-", "_").to_sym, "#{base}/#{file}"
  #   # puts "glyph! :twk_#{file[..-17].tr("-", "_")}, \"\#{dir}/stuff/glyph/thewolfkit/#{file}\""
  # end

  glyph! :twk_alert_circle, "#{dir}/stuff/glyph/thewolfkit/alert-circle-svgrepo-com.svg"
  glyph! :twk_alert_triangle, "#{dir}/stuff/glyph/thewolfkit/alert-triangle-svgrepo-com.svg"
  glyph! :twk_archivebox, "#{dir}/stuff/glyph/thewolfkit/archivebox-svgrepo-com.svg"
  glyph! :twk_arrow_2_ccw, "#{dir}/stuff/glyph/thewolfkit/arrow-2-ccw-svgrepo-com.svg"
  glyph! :twk_arrow_2_cw, "#{dir}/stuff/glyph/thewolfkit/arrow-2-cw-svgrepo-com.svg"
  glyph! :twk_arrow_2_rectangle_path, "#{dir}/stuff/glyph/thewolfkit/arrow-2-rectangle-path-svgrepo-com.svg"
  glyph! :twk_arrow_4_way, "#{dir}/stuff/glyph/thewolfkit/arrow-4-way-svgrepo-com.svg"
  glyph! :twk_arrow_ccw, "#{dir}/stuff/glyph/thewolfkit/arrow-ccw-svgrepo-com.svg"
  glyph! :twk_arrow_circle_down, "#{dir}/stuff/glyph/thewolfkit/arrow-circle-down-svgrepo-com.svg"
  glyph! :twk_arrow_circle_left, "#{dir}/stuff/glyph/thewolfkit/arrow-circle-left-svgrepo-com.svg"
  glyph! :twk_arrow_circle_right, "#{dir}/stuff/glyph/thewolfkit/arrow-circle-right-svgrepo-com.svg"
  glyph! :twk_arrow_circle_up, "#{dir}/stuff/glyph/thewolfkit/arrow-circle-up-svgrepo-com.svg"
  glyph! :twk_arrow_cw, "#{dir}/stuff/glyph/thewolfkit/arrow-cw-svgrepo-com.svg"
  glyph! :twk_arrow_down, "#{dir}/stuff/glyph/thewolfkit/arrow-down-svgrepo-com.svg"
  glyph! :twk_arrow_from_line_down, "#{dir}/stuff/glyph/thewolfkit/arrow-from-line-down-svgrepo-com.svg"
  glyph! :twk_arrow_from_line_left, "#{dir}/stuff/glyph/thewolfkit/arrow-from-line-left-svgrepo-com.svg"
  glyph! :twk_arrow_from_line_right, "#{dir}/stuff/glyph/thewolfkit/arrow-from-line-right-svgrepo-com.svg"
  glyph! :twk_arrow_from_line_up, "#{dir}/stuff/glyph/thewolfkit/arrow-from-line-up-svgrepo-com.svg"
  glyph! :twk_arrow_from_shape_right, "#{dir}/stuff/glyph/thewolfkit/arrow-from-shape-right-svgrepo-com.svg"
  glyph! :twk_arrow_from_shape_up, "#{dir}/stuff/glyph/thewolfkit/arrow-from-shape-up-svgrepo-com.svg"
  glyph! :twk_arrow_left, "#{dir}/stuff/glyph/thewolfkit/arrow-left-svgrepo-com.svg"
  glyph! :twk_arrow_right_arrow_left, "#{dir}/stuff/glyph/thewolfkit/arrow-right-arrow-left-svgrepo-com.svg"
  glyph! :twk_arrow_right, "#{dir}/stuff/glyph/thewolfkit/arrow-right-svgrepo-com.svg"
  glyph! :twk_arrow_shape_turn_left, "#{dir}/stuff/glyph/thewolfkit/arrow-shape-turn-left-svgrepo-com.svg"
  glyph! :twk_arrow_shape_turn_right, "#{dir}/stuff/glyph/thewolfkit/arrow-shape-turn-right-svgrepo-com.svg"
  glyph! :twk_arrow_small_down, "#{dir}/stuff/glyph/thewolfkit/arrow-small-down-svgrepo-com.svg"
  glyph! :twk_arrow_small_left, "#{dir}/stuff/glyph/thewolfkit/arrow-small-left-svgrepo-com.svg"
  glyph! :twk_arrow_small_right, "#{dir}/stuff/glyph/thewolfkit/arrow-small-right-svgrepo-com.svg"
  glyph! :twk_arrow_small_up, "#{dir}/stuff/glyph/thewolfkit/arrow-small-up-svgrepo-com.svg"
  glyph! :twk_arrow_thin_down, "#{dir}/stuff/glyph/thewolfkit/arrow-thin-down-svgrepo-com.svg"
  glyph! :twk_arrow_thin_left, "#{dir}/stuff/glyph/thewolfkit/arrow-thin-left-svgrepo-com.svg"
  glyph! :twk_arrow_thin_right, "#{dir}/stuff/glyph/thewolfkit/arrow-thin-right-svgrepo-com.svg"
  glyph! :twk_arrow_thin_up, "#{dir}/stuff/glyph/thewolfkit/arrow-thin-up-svgrepo-com.svg"
  glyph! :twk_arrow_to_line_down, "#{dir}/stuff/glyph/thewolfkit/arrow-to-line-down-svgrepo-com.svg"
  glyph! :twk_arrow_to_line_left, "#{dir}/stuff/glyph/thewolfkit/arrow-to-line-left-svgrepo-com.svg"
  glyph! :twk_arrow_to_line_right, "#{dir}/stuff/glyph/thewolfkit/arrow-to-line-right-svgrepo-com.svg"
  glyph! :twk_arrow_to_line_up, "#{dir}/stuff/glyph/thewolfkit/arrow-to-line-up-svgrepo-com.svg"
  glyph! :twk_arrow_to_shape_down, "#{dir}/stuff/glyph/thewolfkit/arrow-to-shape-down-svgrepo-com.svg"
  glyph! :twk_arrow_to_shape_right, "#{dir}/stuff/glyph/thewolfkit/arrow-to-shape-right-svgrepo-com.svg"
  glyph! :twk_arrow_trend_down, "#{dir}/stuff/glyph/thewolfkit/arrow-trend-down-svgrepo-com.svg"
  glyph! :twk_arrow_trend_up, "#{dir}/stuff/glyph/thewolfkit/arrow-trend-up-svgrepo-com.svg"
  glyph! :twk_arrow_turn_down_left, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-down-left-svgrepo-com.svg"
  glyph! :twk_arrow_turn_down_right, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-down-right-svgrepo-com.svg"
  glyph! :twk_arrow_turn_left_down, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-left-down-svgrepo-com.svg"
  glyph! :twk_arrow_turn_left_up, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-left-up-svgrepo-com.svg"
  glyph! :twk_arrow_turn_right_down, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-right-down-svgrepo-com.svg"
  glyph! :twk_arrow_turn_right_up, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-right-up-svgrepo-com.svg"
  glyph! :twk_arrow_turn_up_left, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-up-left-svgrepo-com.svg"
  glyph! :twk_arrow_turn_up_right, "#{dir}/stuff/glyph/thewolfkit/arrow-turn-up-right-svgrepo-com.svg"
  glyph! :twk_arrow_up_arrow_down, "#{dir}/stuff/glyph/thewolfkit/arrow-up-arrow-down-svgrepo-com.svg"
  glyph! :twk_arrow_up, "#{dir}/stuff/glyph/thewolfkit/arrow-up-svgrepo-com.svg"
  glyph! :twk_at_sign, "#{dir}/stuff/glyph/thewolfkit/at-sign-svgrepo-com.svg"
  glyph! :twk_bag, "#{dir}/stuff/glyph/thewolfkit/bag-svgrepo-com.svg"
  glyph! :twk_bell_slash, "#{dir}/stuff/glyph/thewolfkit/bell-slash-svgrepo-com.svg"
  glyph! :twk_bell, "#{dir}/stuff/glyph/thewolfkit/bell-svgrepo-com.svg"
  glyph! :twk_book_open, "#{dir}/stuff/glyph/thewolfkit/book-open-svgrepo-com.svg"
  glyph! :twk_bookmark, "#{dir}/stuff/glyph/thewolfkit/bookmark-svgrepo-com.svg"
  glyph! :twk_box, "#{dir}/stuff/glyph/thewolfkit/box-svgrepo-com.svg"
  glyph! :twk_calendar, "#{dir}/stuff/glyph/thewolfkit/calendar-svgrepo-com.svg"
  glyph! :twk_camera, "#{dir}/stuff/glyph/thewolfkit/camera-svgrepo-com.svg"
  glyph! :twk_caret_down, "#{dir}/stuff/glyph/thewolfkit/caret-down-svgrepo-com.svg"
  glyph! :twk_caret_left, "#{dir}/stuff/glyph/thewolfkit/caret-left-svgrepo-com.svg"
  glyph! :twk_caret_right, "#{dir}/stuff/glyph/thewolfkit/caret-right-svgrepo-com.svg"
  glyph! :twk_caret_up, "#{dir}/stuff/glyph/thewolfkit/caret-up-svgrepo-com.svg"
  glyph! :twk_cart, "#{dir}/stuff/glyph/thewolfkit/cart-svgrepo-com.svg"
  glyph! :twk_chart_pie, "#{dir}/stuff/glyph/thewolfkit/chart-pie-svgrepo-com.svg"
  glyph! :twk_chartbar_2, "#{dir}/stuff/glyph/thewolfkit/chartbar-2-svgrepo-com.svg"
  glyph! :twk_chartbar, "#{dir}/stuff/glyph/thewolfkit/chartbar-svgrepo-com.svg"
  glyph! :twk_checkmark_circle, "#{dir}/stuff/glyph/thewolfkit/checkmark-circle-svgrepo-com.svg"
  glyph! :twk_checkmark_double, "#{dir}/stuff/glyph/thewolfkit/checkmark-double-svgrepo-com.svg"
  glyph! :twk_checkmark_square, "#{dir}/stuff/glyph/thewolfkit/checkmark-square-svgrepo-com.svg"
  glyph! :twk_checkmark, "#{dir}/stuff/glyph/thewolfkit/checkmark-svgrepo-com.svg"
  glyph! :twk_chevron_down, "#{dir}/stuff/glyph/thewolfkit/chevron-down-svgrepo-com.svg"
  glyph! :twk_chevron_left_chevron_right, "#{dir}/stuff/glyph/thewolfkit/chevron-left-chevron-right-svgrepo-com.svg"
  glyph! :twk_chevron_left, "#{dir}/stuff/glyph/thewolfkit/chevron-left-svgrepo-com.svg"
  glyph! :twk_chevron_right, "#{dir}/stuff/glyph/thewolfkit/chevron-right-svgrepo-com.svg"
  glyph! :twk_chevron_small_down, "#{dir}/stuff/glyph/thewolfkit/chevron-small-down-svgrepo-com.svg"
  glyph! :twk_chevron_small_left, "#{dir}/stuff/glyph/thewolfkit/chevron-small-left-svgrepo-com.svg"
  glyph! :twk_chevron_small_right, "#{dir}/stuff/glyph/thewolfkit/chevron-small-right-svgrepo-com.svg"
  glyph! :twk_chevron_small_up, "#{dir}/stuff/glyph/thewolfkit/chevron-small-up-svgrepo-com.svg"
  glyph! :twk_chevron_up_chevron_down, "#{dir}/stuff/glyph/thewolfkit/chevron-up-chevron-down-svgrepo-com.svg"
  glyph! :twk_chevron_up, "#{dir}/stuff/glyph/thewolfkit/chevron-up-svgrepo-com.svg"
  glyph! :twk_clock, "#{dir}/stuff/glyph/thewolfkit/clock-svgrepo-com.svg"
  glyph! :twk_cloud_arrow_up, "#{dir}/stuff/glyph/thewolfkit/cloud-arrow-up-svgrepo-com.svg"
  glyph! :twk_cloud_download, "#{dir}/stuff/glyph/thewolfkit/cloud-download-svgrepo-com.svg"
  glyph! :twk_cloud_slash, "#{dir}/stuff/glyph/thewolfkit/cloud-slash-svgrepo-com.svg"
  glyph! :twk_cloud, "#{dir}/stuff/glyph/thewolfkit/cloud-svgrepo-com.svg"
  glyph! :twk_columns, "#{dir}/stuff/glyph/thewolfkit/columns-svgrepo-com.svg"
  glyph! :twk_command, "#{dir}/stuff/glyph/thewolfkit/command-svgrepo-com.svg"
  glyph! :twk_compass, "#{dir}/stuff/glyph/thewolfkit/compass-svgrepo-com.svg"
  glyph! :twk_credit_card, "#{dir}/stuff/glyph/thewolfkit/credit-card-svgrepo-com.svg"
  glyph! :twk_crop, "#{dir}/stuff/glyph/thewolfkit/crop-svgrepo-com.svg"
  glyph! :twk_crown, "#{dir}/stuff/glyph/thewolfkit/crown-svgrepo-com.svg"
  glyph! :twk_delete_left, "#{dir}/stuff/glyph/thewolfkit/delete-left-svgrepo-com.svg"
  glyph! :twk_device_desktop, "#{dir}/stuff/glyph/thewolfkit/device-desktop-svgrepo-com.svg"
  glyph! :twk_device_mobile, "#{dir}/stuff/glyph/thewolfkit/device-mobile-svgrepo-com.svg"
  glyph! :twk_device_tablet, "#{dir}/stuff/glyph/thewolfkit/device-tablet-svgrepo-com.svg"
  glyph! :twk_doc, "#{dir}/stuff/glyph/thewolfkit/doc-svgrepo-com.svg"
  glyph! :twk_dot_small, "#{dir}/stuff/glyph/thewolfkit/dot-small-svgrepo-com.svg"
  glyph! :twk_dots_3_horizontal, "#{dir}/stuff/glyph/thewolfkit/dots-3-horizontal-svgrepo-com.svg"
  glyph! :twk_dots_3_vertical, "#{dir}/stuff/glyph/thewolfkit/dots-3-vertical-svgrepo-com.svg"
  glyph! :twk_dots_6_horizontal, "#{dir}/stuff/glyph/thewolfkit/dots-6-horizontal-svgrepo-com.svg"
  glyph! :twk_dots_6_vertical, "#{dir}/stuff/glyph/thewolfkit/dots-6-vertical-svgrepo-com.svg"
  glyph! :twk_dots_9, "#{dir}/stuff/glyph/thewolfkit/dots-9-svgrepo-com.svg"
  glyph! :twk_emoji_frown, "#{dir}/stuff/glyph/thewolfkit/emoji-frown-svgrepo-com.svg"
  glyph! :twk_emoji_meh, "#{dir}/stuff/glyph/thewolfkit/emoji-meh-svgrepo-com.svg"
  glyph! :twk_emoji_smile, "#{dir}/stuff/glyph/thewolfkit/emoji-smile-svgrepo-com.svg"
  glyph! :twk_envelope, "#{dir}/stuff/glyph/thewolfkit/envelope-svgrepo-com.svg"
  glyph! :twk_external_link, "#{dir}/stuff/glyph/thewolfkit/external-link-svgrepo-com.svg"
  glyph! :twk_eye_slash, "#{dir}/stuff/glyph/thewolfkit/eye-slash-svgrepo-com.svg"
  glyph! :twk_eye, "#{dir}/stuff/glyph/thewolfkit/eye-svgrepo-com.svg"
  glyph! :twk_filter, "#{dir}/stuff/glyph/thewolfkit/filter-svgrepo-com.svg"
  glyph! :twk_flame, "#{dir}/stuff/glyph/thewolfkit/flame-svgrepo-com.svg"
  glyph! :twk_floppy_disk, "#{dir}/stuff/glyph/thewolfkit/floppy-disk-svgrepo-com.svg"
  glyph! :twk_folder, "#{dir}/stuff/glyph/thewolfkit/folder-svgrepo-com.svg"
  glyph! :twk_fullscreen_alt, "#{dir}/stuff/glyph/thewolfkit/fullscreen-alt-svgrepo-com.svg"
  glyph! :twk_fullscreen_exit_alt, "#{dir}/stuff/glyph/thewolfkit/fullscreen-exit-alt-svgrepo-com.svg"
  glyph! :twk_fullscreen_exit, "#{dir}/stuff/glyph/thewolfkit/fullscreen-exit-svgrepo-com.svg"
  glyph! :twk_fullscreen, "#{dir}/stuff/glyph/thewolfkit/fullscreen-svgrepo-com.svg"
  glyph! :twk_gear, "#{dir}/stuff/glyph/thewolfkit/gear-svgrepo-com.svg"
  glyph! :twk_giftbox, "#{dir}/stuff/glyph/thewolfkit/giftbox-svgrepo-com.svg"
  glyph! :twk_half_star, "#{dir}/stuff/glyph/thewolfkit/half-star-svgrepo-com.svg"
  glyph! :twk_hashtag, "#{dir}/stuff/glyph/thewolfkit/hashtag-svgrepo-com.svg"
  glyph! :twk_headphones, "#{dir}/stuff/glyph/thewolfkit/headphones-svgrepo-com.svg"
  glyph! :twk_heart_half, "#{dir}/stuff/glyph/thewolfkit/heart-half-svgrepo-com.svg"
  glyph! :twk_heart, "#{dir}/stuff/glyph/thewolfkit/heart-svgrepo-com.svg"
  glyph! :twk_house, "#{dir}/stuff/glyph/thewolfkit/house-svgrepo-com.svg"
  glyph! :twk_image, "#{dir}/stuff/glyph/thewolfkit/image-svgrepo-com.svg"
  glyph! :twk_info_circle, "#{dir}/stuff/glyph/thewolfkit/info-circle-svgrepo-com.svg"
  glyph! :twk_key, "#{dir}/stuff/glyph/thewolfkit/key-svgrepo-com.svg"
  glyph! :twk_layers_3, "#{dir}/stuff/glyph/thewolfkit/layers-3-svgrepo-com.svg"
  glyph! :twk_layout, "#{dir}/stuff/glyph/thewolfkit/layout-svgrepo-com.svg"
  glyph! :twk_line_3, "#{dir}/stuff/glyph/thewolfkit/line-3-svgrepo-com.svg"
  glyph! :twk_link_alt, "#{dir}/stuff/glyph/thewolfkit/link-alt-svgrepo-com.svg"
  glyph! :twk_link, "#{dir}/stuff/glyph/thewolfkit/link-svgrepo-com.svg"
  glyph! :twk_list_bullet, "#{dir}/stuff/glyph/thewolfkit/list-bullet-svgrepo-com.svg"
  glyph! :twk_location, "#{dir}/stuff/glyph/thewolfkit/location-svgrepo-com.svg"
  glyph! :twk_lock_open, "#{dir}/stuff/glyph/thewolfkit/lock-open-svgrepo-com.svg"
  glyph! :twk_lock, "#{dir}/stuff/glyph/thewolfkit/lock-svgrepo-com.svg"
  glyph! :twk_map_pin, "#{dir}/stuff/glyph/thewolfkit/map-pin-svgrepo-com.svg"
  glyph! :twk_medal, "#{dir}/stuff/glyph/thewolfkit/medal-svgrepo-com.svg"
  glyph! :twk_media_backward_end, "#{dir}/stuff/glyph/thewolfkit/media-backward-end-svgrepo-com.svg"
  glyph! :twk_media_backward, "#{dir}/stuff/glyph/thewolfkit/media-backward-svgrepo-com.svg"
  glyph! :twk_media_forward_end, "#{dir}/stuff/glyph/thewolfkit/media-forward-end-svgrepo-com.svg"
  glyph! :twk_media_forward, "#{dir}/stuff/glyph/thewolfkit/media-forward-svgrepo-com.svg"
  glyph! :twk_media_pause_circle, "#{dir}/stuff/glyph/thewolfkit/media-pause-circle-svgrepo-com.svg"
  glyph! :twk_media_pause, "#{dir}/stuff/glyph/thewolfkit/media-pause-svgrepo-com.svg"
  glyph! :twk_media_play_circle, "#{dir}/stuff/glyph/thewolfkit/media-play-circle-svgrepo-com.svg"
  glyph! :twk_media_play, "#{dir}/stuff/glyph/thewolfkit/media-play-svgrepo-com.svg"
  glyph! :twk_media_stop_circle, "#{dir}/stuff/glyph/thewolfkit/media-stop-circle-svgrepo-com.svg"
  glyph! :twk_media_stop, "#{dir}/stuff/glyph/thewolfkit/media-stop-svgrepo-com.svg"
  glyph! :twk_message_bubble_2, "#{dir}/stuff/glyph/thewolfkit/message-bubble-2-svgrepo-com.svg"
  glyph! :twk_message_bubble, "#{dir}/stuff/glyph/thewolfkit/message-bubble-svgrepo-com.svg"
  glyph! :twk_mic_slash, "#{dir}/stuff/glyph/thewolfkit/mic-slash-svgrepo-com.svg"
  glyph! :twk_mic, "#{dir}/stuff/glyph/thewolfkit/mic-svgrepo-com.svg"
  glyph! :twk_minus_circle, "#{dir}/stuff/glyph/thewolfkit/minus-circle-svgrepo-com.svg"
  glyph! :twk_minus_square, "#{dir}/stuff/glyph/thewolfkit/minus-square-svgrepo-com.svg"
  glyph! :twk_minus, "#{dir}/stuff/glyph/thewolfkit/minus-svgrepo-com.svg"
  glyph! :twk_moon, "#{dir}/stuff/glyph/thewolfkit/moon-svgrepo-com.svg"
  glyph! :twk_music_note, "#{dir}/stuff/glyph/thewolfkit/music-note-svgrepo-com.svg"
  glyph! :twk_nosign, "#{dir}/stuff/glyph/thewolfkit/nosign-svgrepo-com.svg"
  glyph! :twk_paper_clip, "#{dir}/stuff/glyph/thewolfkit/paper-clip-svgrepo-com.svg"
  glyph! :twk_paper_plane, "#{dir}/stuff/glyph/thewolfkit/paper-plane-svgrepo-com.svg"
  glyph! :twk_pen_tool, "#{dir}/stuff/glyph/thewolfkit/pen-tool-svgrepo-com.svg"
  glyph! :twk_pencil, "#{dir}/stuff/glyph/thewolfkit/pencil-svgrepo-com.svg"
  glyph! :twk_percent, "#{dir}/stuff/glyph/thewolfkit/percent-svgrepo-com.svg"
  glyph! :twk_phone_incoming, "#{dir}/stuff/glyph/thewolfkit/phone-incoming-svgrepo-com.svg"
  glyph! :twk_phone_missed, "#{dir}/stuff/glyph/thewolfkit/phone-missed-svgrepo-com.svg"
  glyph! :twk_phone_outgoing, "#{dir}/stuff/glyph/thewolfkit/phone-outgoing-svgrepo-com.svg"
  glyph! :twk_phone_slash, "#{dir}/stuff/glyph/thewolfkit/phone-slash-svgrepo-com.svg"
  glyph! :twk_phone, "#{dir}/stuff/glyph/thewolfkit/phone-svgrepo-com.svg"
  glyph! :twk_plus_circle, "#{dir}/stuff/glyph/thewolfkit/plus-circle-svgrepo-com.svg"
  glyph! :twk_plus_square, "#{dir}/stuff/glyph/thewolfkit/plus-square-svgrepo-com.svg"
  glyph! :twk_plus, "#{dir}/stuff/glyph/thewolfkit/plus-svgrepo-com.svg"
  glyph! :twk_power, "#{dir}/stuff/glyph/thewolfkit/power-svgrepo-com.svg"
  glyph! :twk_printer, "#{dir}/stuff/glyph/thewolfkit/printer-svgrepo-com.svg"
  glyph! :twk_question_circle, "#{dir}/stuff/glyph/thewolfkit/question-circle-svgrepo-com.svg"
  glyph! :twk_scissors, "#{dir}/stuff/glyph/thewolfkit/scissors-svgrepo-com.svg"
  glyph! :twk_search, "#{dir}/stuff/glyph/thewolfkit/search-svgrepo-com.svg"
  glyph! :twk_server, "#{dir}/stuff/glyph/thewolfkit/server-svgrepo-com.svg"
  glyph! :twk_shape_circle, "#{dir}/stuff/glyph/thewolfkit/shape-circle-svgrepo-com.svg"
  glyph! :twk_shape_rhombus, "#{dir}/stuff/glyph/thewolfkit/shape-rhombus-svgrepo-com.svg"
  glyph! :twk_shape_square, "#{dir}/stuff/glyph/thewolfkit/shape-square-svgrepo-com.svg"
  glyph! :twk_shape_triangle, "#{dir}/stuff/glyph/thewolfkit/shape-triangle-svgrepo-com.svg"
  glyph! :twk_share, "#{dir}/stuff/glyph/thewolfkit/share-svgrepo-com.svg"
  glyph! :twk_shield_slash, "#{dir}/stuff/glyph/thewolfkit/shield-slash-svgrepo-com.svg"
  glyph! :twk_shield, "#{dir}/stuff/glyph/thewolfkit/shield-svgrepo-com.svg"
  glyph! :twk_shippingbox, "#{dir}/stuff/glyph/thewolfkit/shippingbox-svgrepo-com.svg"
  glyph! :twk_slider_3_horizontal, "#{dir}/stuff/glyph/thewolfkit/slider-3-horizontal-svgrepo-com.svg"
  glyph! :twk_slider_3_vertical, "#{dir}/stuff/glyph/thewolfkit/slider-3-vertical-svgrepo-com.svg"
  glyph! :twk_speaker, "#{dir}/stuff/glyph/thewolfkit/speaker-svgrepo-com.svg"
  glyph! :twk_speaker_wave_1, "#{dir}/stuff/glyph/thewolfkit/speaker-wave-1-svgrepo-com.svg"
  glyph! :twk_speaker_wave_2, "#{dir}/stuff/glyph/thewolfkit/speaker-wave-2-svgrepo-com.svg"
  glyph! :twk_speaker_xmark, "#{dir}/stuff/glyph/thewolfkit/speaker-xmark-svgrepo-com.svg"
  glyph! :twk_square_4_grid, "#{dir}/stuff/glyph/thewolfkit/square-4-grid-svgrepo-com.svg"
  glyph! :twk_square_on_square, "#{dir}/stuff/glyph/thewolfkit/square-on-square-svgrepo-com.svg"
  glyph! :twk_star, "#{dir}/stuff/glyph/thewolfkit/star-svgrepo-com.svg"
  glyph! :twk_sun, "#{dir}/stuff/glyph/thewolfkit/sun-svgrepo-com.svg"
  glyph! :twk_tag, "#{dir}/stuff/glyph/thewolfkit/tag-svgrepo-com.svg"
  glyph! :twk_text_align_center, "#{dir}/stuff/glyph/thewolfkit/text-align-center-svgrepo-com.svg"
  glyph! :twk_text_align_justify, "#{dir}/stuff/glyph/thewolfkit/text-align-justify-svgrepo-com.svg"
  glyph! :twk_text_align_left, "#{dir}/stuff/glyph/thewolfkit/text-align-left-svgrepo-com.svg"
  glyph! :twk_text_align_right, "#{dir}/stuff/glyph/thewolfkit/text-align-right-svgrepo-com.svg"
  glyph! :twk_text_bold, "#{dir}/stuff/glyph/thewolfkit/text-bold-svgrepo-com.svg"
  glyph! :twk_text_heading, "#{dir}/stuff/glyph/thewolfkit/text-heading-svgrepo-com.svg"
  glyph! :twk_text_italic, "#{dir}/stuff/glyph/thewolfkit/text-italic-svgrepo-com.svg"
  glyph! :twk_text, "#{dir}/stuff/glyph/thewolfkit/text-svgrepo-com.svg"
  glyph! :twk_text_underline, "#{dir}/stuff/glyph/thewolfkit/text-underline-svgrepo-com.svg"
  glyph! :twk_thumbs_down, "#{dir}/stuff/glyph/thewolfkit/thumbs-down-svgrepo-com.svg"
  glyph! :twk_thumbs_up, "#{dir}/stuff/glyph/thewolfkit/thumbs-up-svgrepo-com.svg"
  glyph! :twk_trash, "#{dir}/stuff/glyph/thewolfkit/trash-svgrepo-com.svg"
  glyph! :twk_tray, "#{dir}/stuff/glyph/thewolfkit/tray-svgrepo-com.svg"
  glyph! :twk_umbrela, "#{dir}/stuff/glyph/thewolfkit/umbrela-svgrepo-com.svg"
  glyph! :twk_user, "#{dir}/stuff/glyph/thewolfkit/user-svgrepo-com.svg"
  glyph! :twk_users, "#{dir}/stuff/glyph/thewolfkit/users-svgrepo-com.svg"
  glyph! :twk_video, "#{dir}/stuff/glyph/thewolfkit/video-svgrepo-com.svg"
  glyph! :twk_waveform_ecg, "#{dir}/stuff/glyph/thewolfkit/waveform-ecg-svgrepo-com.svg"
  glyph! :twk_wi_fi, "#{dir}/stuff/glyph/thewolfkit/wi-fi-svgrepo-com.svg"
  glyph! :twk_xmark_circle, "#{dir}/stuff/glyph/thewolfkit/xmark-circle-svgrepo-com.svg"
  glyph! :twk_xmark_small, "#{dir}/stuff/glyph/thewolfkit/xmark-small-svgrepo-com.svg"
  glyph! :twk_xmark, "#{dir}/stuff/glyph/thewolfkit/xmark-svgrepo-com.svg"
  glyph! :twk_zap, "#{dir}/stuff/glyph/thewolfkit/zap-svgrepo-com.svg"
  glyph! :twk_zoom_in, "#{dir}/stuff/glyph/thewolfkit/zoom-in-svgrepo-com.svg"
  glyph! :twk_zoom_out, "#{dir}/stuff/glyph/thewolfkit/zoom-out-svgrepo-com.svg"
end
