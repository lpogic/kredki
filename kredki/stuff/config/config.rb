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
  # base = "#{dir}/stuff/glyph"
  # Dir["*.svg", base: base].each do |file|
  #   glyph! file[..-17].tr("-", "_").to_sym, "#{base}/#{file}"
  #   # puts "glyph! :#{file[..-17].tr("-", "_")}, \"\#{dir}/stuff/glyph/#{file}\""
  # end

  glyph! :alert_circle, "#{dir}/stuff/glyph/alert-circle-svgrepo-com.svg"
  glyph! :alert_triangle, "#{dir}/stuff/glyph/alert-triangle-svgrepo-com.svg"
  glyph! :archivebox, "#{dir}/stuff/glyph/archivebox-svgrepo-com.svg"
  glyph! :arrow_2_ccw, "#{dir}/stuff/glyph/arrow-2-ccw-svgrepo-com.svg"
  glyph! :arrow_2_cw, "#{dir}/stuff/glyph/arrow-2-cw-svgrepo-com.svg"
  glyph! :arrow_2_rectangle_path, "#{dir}/stuff/glyph/arrow-2-rectangle-path-svgrepo-com.svg"
  glyph! :arrow_4_way, "#{dir}/stuff/glyph/arrow-4-way-svgrepo-com.svg"
  glyph! :arrow_ccw, "#{dir}/stuff/glyph/arrow-ccw-svgrepo-com.svg"
  glyph! :arrow_circle_down, "#{dir}/stuff/glyph/arrow-circle-down-svgrepo-com.svg"
  glyph! :arrow_circle_left, "#{dir}/stuff/glyph/arrow-circle-left-svgrepo-com.svg"
  glyph! :arrow_circle_right, "#{dir}/stuff/glyph/arrow-circle-right-svgrepo-com.svg"
  glyph! :arrow_circle_up, "#{dir}/stuff/glyph/arrow-circle-up-svgrepo-com.svg"
  glyph! :arrow_cw, "#{dir}/stuff/glyph/arrow-cw-svgrepo-com.svg"
  glyph! :arrow_down, "#{dir}/stuff/glyph/arrow-down-svgrepo-com.svg"
  glyph! :arrow_from_line_down, "#{dir}/stuff/glyph/arrow-from-line-down-svgrepo-com.svg"
  glyph! :arrow_from_line_left, "#{dir}/stuff/glyph/arrow-from-line-left-svgrepo-com.svg"
  glyph! :arrow_from_line_right, "#{dir}/stuff/glyph/arrow-from-line-right-svgrepo-com.svg"
  glyph! :arrow_from_line_up, "#{dir}/stuff/glyph/arrow-from-line-up-svgrepo-com.svg"
  glyph! :arrow_from_shape_right, "#{dir}/stuff/glyph/arrow-from-shape-right-svgrepo-com.svg"
  glyph! :arrow_from_shape_up, "#{dir}/stuff/glyph/arrow-from-shape-up-svgrepo-com.svg"
  glyph! :arrow_left, "#{dir}/stuff/glyph/arrow-left-svgrepo-com.svg"
  glyph! :arrow_right_arrow_left, "#{dir}/stuff/glyph/arrow-right-arrow-left-svgrepo-com.svg"
  glyph! :arrow_right, "#{dir}/stuff/glyph/arrow-right-svgrepo-com.svg"
  glyph! :arrow_shape_turn_left, "#{dir}/stuff/glyph/arrow-shape-turn-left-svgrepo-com.svg"
  glyph! :arrow_shape_turn_right, "#{dir}/stuff/glyph/arrow-shape-turn-right-svgrepo-com.svg"
  glyph! :arrow_small_down, "#{dir}/stuff/glyph/arrow-small-down-svgrepo-com.svg"
  glyph! :arrow_small_left, "#{dir}/stuff/glyph/arrow-small-left-svgrepo-com.svg"
  glyph! :arrow_small_right, "#{dir}/stuff/glyph/arrow-small-right-svgrepo-com.svg"
  glyph! :arrow_small_up, "#{dir}/stuff/glyph/arrow-small-up-svgrepo-com.svg"
  glyph! :arrow_thin_down, "#{dir}/stuff/glyph/arrow-thin-down-svgrepo-com.svg"
  glyph! :arrow_thin_left, "#{dir}/stuff/glyph/arrow-thin-left-svgrepo-com.svg"
  glyph! :arrow_thin_right, "#{dir}/stuff/glyph/arrow-thin-right-svgrepo-com.svg"
  glyph! :arrow_thin_up, "#{dir}/stuff/glyph/arrow-thin-up-svgrepo-com.svg"
  glyph! :arrow_to_line_down, "#{dir}/stuff/glyph/arrow-to-line-down-svgrepo-com.svg"
  glyph! :arrow_to_line_left, "#{dir}/stuff/glyph/arrow-to-line-left-svgrepo-com.svg"
  glyph! :arrow_to_line_right, "#{dir}/stuff/glyph/arrow-to-line-right-svgrepo-com.svg"
  glyph! :arrow_to_line_up, "#{dir}/stuff/glyph/arrow-to-line-up-svgrepo-com.svg"
  glyph! :arrow_to_shape_down, "#{dir}/stuff/glyph/arrow-to-shape-down-svgrepo-com.svg"
  glyph! :arrow_to_shape_right, "#{dir}/stuff/glyph/arrow-to-shape-right-svgrepo-com.svg"
  glyph! :arrow_trend_down, "#{dir}/stuff/glyph/arrow-trend-down-svgrepo-com.svg"
  glyph! :arrow_trend_up, "#{dir}/stuff/glyph/arrow-trend-up-svgrepo-com.svg"
  glyph! :arrow_turn_down_left, "#{dir}/stuff/glyph/arrow-turn-down-left-svgrepo-com.svg"
  glyph! :arrow_turn_down_right, "#{dir}/stuff/glyph/arrow-turn-down-right-svgrepo-com.svg"
  glyph! :arrow_turn_left_down, "#{dir}/stuff/glyph/arrow-turn-left-down-svgrepo-com.svg"
  glyph! :arrow_turn_left_up, "#{dir}/stuff/glyph/arrow-turn-left-up-svgrepo-com.svg"
  glyph! :arrow_turn_right_down, "#{dir}/stuff/glyph/arrow-turn-right-down-svgrepo-com.svg"
  glyph! :arrow_turn_right_up, "#{dir}/stuff/glyph/arrow-turn-right-up-svgrepo-com.svg"
  glyph! :arrow_turn_up_left, "#{dir}/stuff/glyph/arrow-turn-up-left-svgrepo-com.svg"
  glyph! :arrow_turn_up_right, "#{dir}/stuff/glyph/arrow-turn-up-right-svgrepo-com.svg"
  glyph! :arrow_up_arrow_down, "#{dir}/stuff/glyph/arrow-up-arrow-down-svgrepo-com.svg"
  glyph! :arrow_up, "#{dir}/stuff/glyph/arrow-up-svgrepo-com.svg"
  glyph! :at_sign, "#{dir}/stuff/glyph/at-sign-svgrepo-com.svg"
  glyph! :bag, "#{dir}/stuff/glyph/bag-svgrepo-com.svg"
  glyph! :bell_slash, "#{dir}/stuff/glyph/bell-slash-svgrepo-com.svg"
  glyph! :bell, "#{dir}/stuff/glyph/bell-svgrepo-com.svg"
  glyph! :book_open, "#{dir}/stuff/glyph/book-open-svgrepo-com.svg"
  glyph! :bookmark, "#{dir}/stuff/glyph/bookmark-svgrepo-com.svg"
  glyph! :box, "#{dir}/stuff/glyph/box-svgrepo-com.svg"
  glyph! :calendar, "#{dir}/stuff/glyph/calendar-svgrepo-com.svg"
  glyph! :camera, "#{dir}/stuff/glyph/camera-svgrepo-com.svg"
  glyph! :caret_down, "#{dir}/stuff/glyph/caret-down-svgrepo-com.svg"
  glyph! :caret_left, "#{dir}/stuff/glyph/caret-left-svgrepo-com.svg"
  glyph! :caret_right, "#{dir}/stuff/glyph/caret-right-svgrepo-com.svg"
  glyph! :caret_up, "#{dir}/stuff/glyph/caret-up-svgrepo-com.svg"
  glyph! :cart, "#{dir}/stuff/glyph/cart-svgrepo-com.svg"
  glyph! :chart_pie, "#{dir}/stuff/glyph/chart-pie-svgrepo-com.svg"
  glyph! :chartbar_2, "#{dir}/stuff/glyph/chartbar-2-svgrepo-com.svg"
  glyph! :chartbar, "#{dir}/stuff/glyph/chartbar-svgrepo-com.svg"
  glyph! :checkmark_circle, "#{dir}/stuff/glyph/checkmark-circle-svgrepo-com.svg"
  glyph! :checkmark_double, "#{dir}/stuff/glyph/checkmark-double-svgrepo-com.svg"
  glyph! :checkmark_square, "#{dir}/stuff/glyph/checkmark-square-svgrepo-com.svg"
  glyph! :checkmark, "#{dir}/stuff/glyph/checkmark-svgrepo-com.svg"
  glyph! :chevron_down, "#{dir}/stuff/glyph/chevron-down-svgrepo-com.svg"
  glyph! :chevron_left_chevron_right, "#{dir}/stuff/glyph/chevron-left-chevron-right-svgrepo-com.svg"
  glyph! :chevron_left, "#{dir}/stuff/glyph/chevron-left-svgrepo-com.svg"
  glyph! :chevron_right, "#{dir}/stuff/glyph/chevron-right-svgrepo-com.svg"
  glyph! :chevron_small_down, "#{dir}/stuff/glyph/chevron-small-down-svgrepo-com.svg"
  glyph! :chevron_small_left, "#{dir}/stuff/glyph/chevron-small-left-svgrepo-com.svg"
  glyph! :chevron_small_right, "#{dir}/stuff/glyph/chevron-small-right-svgrepo-com.svg"
  glyph! :chevron_small_up, "#{dir}/stuff/glyph/chevron-small-up-svgrepo-com.svg"
  glyph! :chevron_up_chevron_down, "#{dir}/stuff/glyph/chevron-up-chevron-down-svgrepo-com.svg"
  glyph! :chevron_up, "#{dir}/stuff/glyph/chevron-up-svgrepo-com.svg"
  glyph! :clock, "#{dir}/stuff/glyph/clock-svgrepo-com.svg"
  glyph! :cloud_arrow_up, "#{dir}/stuff/glyph/cloud-arrow-up-svgrepo-com.svg"
  glyph! :cloud_download, "#{dir}/stuff/glyph/cloud-download-svgrepo-com.svg"
  glyph! :cloud_slash, "#{dir}/stuff/glyph/cloud-slash-svgrepo-com.svg"
  glyph! :cloud, "#{dir}/stuff/glyph/cloud-svgrepo-com.svg"
  glyph! :columns, "#{dir}/stuff/glyph/columns-svgrepo-com.svg"
  glyph! :command, "#{dir}/stuff/glyph/command-svgrepo-com.svg"
  glyph! :compass, "#{dir}/stuff/glyph/compass-svgrepo-com.svg"
  glyph! :credit_card, "#{dir}/stuff/glyph/credit-card-svgrepo-com.svg"
  glyph! :crop, "#{dir}/stuff/glyph/crop-svgrepo-com.svg"
  glyph! :crown, "#{dir}/stuff/glyph/crown-svgrepo-com.svg"
  glyph! :delete_left, "#{dir}/stuff/glyph/delete-left-svgrepo-com.svg"
  glyph! :device_desktop, "#{dir}/stuff/glyph/device-desktop-svgrepo-com.svg"
  glyph! :device_mobile, "#{dir}/stuff/glyph/device-mobile-svgrepo-com.svg"
  glyph! :device_tablet, "#{dir}/stuff/glyph/device-tablet-svgrepo-com.svg"
  glyph! :doc, "#{dir}/stuff/glyph/doc-svgrepo-com.svg"
  glyph! :dot_small, "#{dir}/stuff/glyph/dot-small-svgrepo-com.svg"
  glyph! :dots_3_horizontal, "#{dir}/stuff/glyph/dots-3-horizontal-svgrepo-com.svg"
  glyph! :dots_3_vertical, "#{dir}/stuff/glyph/dots-3-vertical-svgrepo-com.svg"
  glyph! :dots_6_horizontal, "#{dir}/stuff/glyph/dots-6-horizontal-svgrepo-com.svg"
  glyph! :dots_6_vertical, "#{dir}/stuff/glyph/dots-6-vertical-svgrepo-com.svg"
  glyph! :dots_9, "#{dir}/stuff/glyph/dots-9-svgrepo-com.svg"
  glyph! :emoji_frown, "#{dir}/stuff/glyph/emoji-frown-svgrepo-com.svg"
  glyph! :emoji_meh, "#{dir}/stuff/glyph/emoji-meh-svgrepo-com.svg"
  glyph! :emoji_smile, "#{dir}/stuff/glyph/emoji-smile-svgrepo-com.svg"
  glyph! :envelope, "#{dir}/stuff/glyph/envelope-svgrepo-com.svg"
  glyph! :external_link, "#{dir}/stuff/glyph/external-link-svgrepo-com.svg"
  glyph! :eye_slash, "#{dir}/stuff/glyph/eye-slash-svgrepo-com.svg"
  glyph! :eye, "#{dir}/stuff/glyph/eye-svgrepo-com.svg"
  glyph! :filter, "#{dir}/stuff/glyph/filter-svgrepo-com.svg"
  glyph! :flame, "#{dir}/stuff/glyph/flame-svgrepo-com.svg"
  glyph! :floppy_disk, "#{dir}/stuff/glyph/floppy-disk-svgrepo-com.svg"
  glyph! :folder, "#{dir}/stuff/glyph/folder-svgrepo-com.svg"
  glyph! :fullscreen_alt, "#{dir}/stuff/glyph/fullscreen-alt-svgrepo-com.svg"
  glyph! :fullscreen_exit_alt, "#{dir}/stuff/glyph/fullscreen-exit-alt-svgrepo-com.svg"
  glyph! :fullscreen_exit, "#{dir}/stuff/glyph/fullscreen-exit-svgrepo-com.svg"
  glyph! :fullscreen, "#{dir}/stuff/glyph/fullscreen-svgrepo-com.svg"
  glyph! :gear, "#{dir}/stuff/glyph/gear-svgrepo-com.svg"
  glyph! :giftbox, "#{dir}/stuff/glyph/giftbox-svgrepo-com.svg"
  glyph! :half_star, "#{dir}/stuff/glyph/half-star-svgrepo-com.svg"
  glyph! :hashtag, "#{dir}/stuff/glyph/hashtag-svgrepo-com.svg"
  glyph! :headphones, "#{dir}/stuff/glyph/headphones-svgrepo-com.svg"
  glyph! :heart_half, "#{dir}/stuff/glyph/heart-half-svgrepo-com.svg"
  glyph! :heart, "#{dir}/stuff/glyph/heart-svgrepo-com.svg"
  glyph! :house, "#{dir}/stuff/glyph/house-svgrepo-com.svg"
  glyph! :image, "#{dir}/stuff/glyph/image-svgrepo-com.svg"
  glyph! :info_circle, "#{dir}/stuff/glyph/info-circle-svgrepo-com.svg"
  glyph! :key, "#{dir}/stuff/glyph/key-svgrepo-com.svg"
  glyph! :layers_3, "#{dir}/stuff/glyph/layers-3-svgrepo-com.svg"
  glyph! :layout, "#{dir}/stuff/glyph/layout-svgrepo-com.svg"
  glyph! :line_3, "#{dir}/stuff/glyph/line-3-svgrepo-com.svg"
  glyph! :link_alt, "#{dir}/stuff/glyph/link-alt-svgrepo-com.svg"
  glyph! :link, "#{dir}/stuff/glyph/link-svgrepo-com.svg"
  glyph! :list_bullet, "#{dir}/stuff/glyph/list-bullet-svgrepo-com.svg"
  glyph! :location, "#{dir}/stuff/glyph/location-svgrepo-com.svg"
  glyph! :lock_open, "#{dir}/stuff/glyph/lock-open-svgrepo-com.svg"
  glyph! :lock, "#{dir}/stuff/glyph/lock-svgrepo-com.svg"
  glyph! :map_pin, "#{dir}/stuff/glyph/map-pin-svgrepo-com.svg"
  glyph! :medal, "#{dir}/stuff/glyph/medal-svgrepo-com.svg"
  glyph! :media_backward_end, "#{dir}/stuff/glyph/media-backward-end-svgrepo-com.svg"
  glyph! :media_backward, "#{dir}/stuff/glyph/media-backward-svgrepo-com.svg"
  glyph! :media_forward_end, "#{dir}/stuff/glyph/media-forward-end-svgrepo-com.svg"
  glyph! :media_forward, "#{dir}/stuff/glyph/media-forward-svgrepo-com.svg"
  glyph! :media_pause_circle, "#{dir}/stuff/glyph/media-pause-circle-svgrepo-com.svg"
  glyph! :media_pause, "#{dir}/stuff/glyph/media-pause-svgrepo-com.svg"
  glyph! :media_play_circle, "#{dir}/stuff/glyph/media-play-circle-svgrepo-com.svg"
  glyph! :media_play, "#{dir}/stuff/glyph/media-play-svgrepo-com.svg"
  glyph! :media_stop_circle, "#{dir}/stuff/glyph/media-stop-circle-svgrepo-com.svg"
  glyph! :media_stop, "#{dir}/stuff/glyph/media-stop-svgrepo-com.svg"
  glyph! :message_bubble_2, "#{dir}/stuff/glyph/message-bubble-2-svgrepo-com.svg"
  glyph! :message_bubble, "#{dir}/stuff/glyph/message-bubble-svgrepo-com.svg"
  glyph! :mic_slash, "#{dir}/stuff/glyph/mic-slash-svgrepo-com.svg"
  glyph! :mic, "#{dir}/stuff/glyph/mic-svgrepo-com.svg"
  glyph! :minus_circle, "#{dir}/stuff/glyph/minus-circle-svgrepo-com.svg"
  glyph! :minus_square, "#{dir}/stuff/glyph/minus-square-svgrepo-com.svg"
  glyph! :minus, "#{dir}/stuff/glyph/minus-svgrepo-com.svg"
  glyph! :moon, "#{dir}/stuff/glyph/moon-svgrepo-com.svg"
  glyph! :music_note, "#{dir}/stuff/glyph/music-note-svgrepo-com.svg"
  glyph! :nosign, "#{dir}/stuff/glyph/nosign-svgrepo-com.svg"
  glyph! :paper_clip, "#{dir}/stuff/glyph/paper-clip-svgrepo-com.svg"
  glyph! :paper_plane, "#{dir}/stuff/glyph/paper-plane-svgrepo-com.svg"
  glyph! :pen_tool, "#{dir}/stuff/glyph/pen-tool-svgrepo-com.svg"
  glyph! :pencil, "#{dir}/stuff/glyph/pencil-svgrepo-com.svg"
  glyph! :percent, "#{dir}/stuff/glyph/percent-svgrepo-com.svg"
  glyph! :phone_incoming, "#{dir}/stuff/glyph/phone-incoming-svgrepo-com.svg"
  glyph! :phone_missed, "#{dir}/stuff/glyph/phone-missed-svgrepo-com.svg"
  glyph! :phone_outgoing, "#{dir}/stuff/glyph/phone-outgoing-svgrepo-com.svg"
  glyph! :phone_slash, "#{dir}/stuff/glyph/phone-slash-svgrepo-com.svg"
  glyph! :phone, "#{dir}/stuff/glyph/phone-svgrepo-com.svg"
  glyph! :plus_circle, "#{dir}/stuff/glyph/plus-circle-svgrepo-com.svg"
  glyph! :plus_square, "#{dir}/stuff/glyph/plus-square-svgrepo-com.svg"
  glyph! :plus, "#{dir}/stuff/glyph/plus-svgrepo-com.svg"
  glyph! :power, "#{dir}/stuff/glyph/power-svgrepo-com.svg"
  glyph! :printer, "#{dir}/stuff/glyph/printer-svgrepo-com.svg"
  glyph! :question_circle, "#{dir}/stuff/glyph/question-circle-svgrepo-com.svg"
  glyph! :scissors, "#{dir}/stuff/glyph/scissors-svgrepo-com.svg"
  glyph! :search, "#{dir}/stuff/glyph/search-svgrepo-com.svg"
  glyph! :server, "#{dir}/stuff/glyph/server-svgrepo-com.svg"
  glyph! :shape_circle, "#{dir}/stuff/glyph/shape-circle-svgrepo-com.svg"
  glyph! :shape_rhombus, "#{dir}/stuff/glyph/shape-rhombus-svgrepo-com.svg"
  glyph! :shape_square, "#{dir}/stuff/glyph/shape-square-svgrepo-com.svg"
  glyph! :shape_triangle, "#{dir}/stuff/glyph/shape-triangle-svgrepo-com.svg"
  glyph! :share, "#{dir}/stuff/glyph/share-svgrepo-com.svg"
  glyph! :shield_slash, "#{dir}/stuff/glyph/shield-slash-svgrepo-com.svg"
  glyph! :shield, "#{dir}/stuff/glyph/shield-svgrepo-com.svg"
  glyph! :shippingbox, "#{dir}/stuff/glyph/shippingbox-svgrepo-com.svg"
  glyph! :slider_3_horizontal, "#{dir}/stuff/glyph/slider-3-horizontal-svgrepo-com.svg"
  glyph! :slider_3_vertical, "#{dir}/stuff/glyph/slider-3-vertical-svgrepo-com.svg"
  glyph! :speaker, "#{dir}/stuff/glyph/speaker-svgrepo-com.svg"
  glyph! :speaker_wave_1, "#{dir}/stuff/glyph/speaker-wave-1-svgrepo-com.svg"
  glyph! :speaker_wave_2, "#{dir}/stuff/glyph/speaker-wave-2-svgrepo-com.svg"
  glyph! :speaker_xmark, "#{dir}/stuff/glyph/speaker-xmark-svgrepo-com.svg"
  glyph! :square_4_grid, "#{dir}/stuff/glyph/square-4-grid-svgrepo-com.svg"
  glyph! :square_on_square, "#{dir}/stuff/glyph/square-on-square-svgrepo-com.svg"
  glyph! :star, "#{dir}/stuff/glyph/star-svgrepo-com.svg"
  glyph! :sun, "#{dir}/stuff/glyph/sun-svgrepo-com.svg"
  glyph! :tag, "#{dir}/stuff/glyph/tag-svgrepo-com.svg"
  glyph! :text_align_center, "#{dir}/stuff/glyph/text-align-center-svgrepo-com.svg"
  glyph! :text_align_justify, "#{dir}/stuff/glyph/text-align-justify-svgrepo-com.svg"
  glyph! :text_align_left, "#{dir}/stuff/glyph/text-align-left-svgrepo-com.svg"
  glyph! :text_align_right, "#{dir}/stuff/glyph/text-align-right-svgrepo-com.svg"
  glyph! :text_bold, "#{dir}/stuff/glyph/text-bold-svgrepo-com.svg"
  glyph! :text_heading, "#{dir}/stuff/glyph/text-heading-svgrepo-com.svg"
  glyph! :text_italic, "#{dir}/stuff/glyph/text-italic-svgrepo-com.svg"
  glyph! :text, "#{dir}/stuff/glyph/text-svgrepo-com.svg"
  glyph! :text_underline, "#{dir}/stuff/glyph/text-underline-svgrepo-com.svg"
  glyph! :thumbs_down, "#{dir}/stuff/glyph/thumbs-down-svgrepo-com.svg"
  glyph! :thumbs_up, "#{dir}/stuff/glyph/thumbs-up-svgrepo-com.svg"
  glyph! :trash, "#{dir}/stuff/glyph/trash-svgrepo-com.svg"
  glyph! :tray, "#{dir}/stuff/glyph/tray-svgrepo-com.svg"
  glyph! :umbrela, "#{dir}/stuff/glyph/umbrela-svgrepo-com.svg"
  glyph! :user, "#{dir}/stuff/glyph/user-svgrepo-com.svg"
  glyph! :users, "#{dir}/stuff/glyph/users-svgrepo-com.svg"
  glyph! :video, "#{dir}/stuff/glyph/video-svgrepo-com.svg"
  glyph! :waveform_ecg, "#{dir}/stuff/glyph/waveform-ecg-svgrepo-com.svg"
  glyph! :wi_fi, "#{dir}/stuff/glyph/wi-fi-svgrepo-com.svg"
  glyph! :xmark_circle, "#{dir}/stuff/glyph/xmark-circle-svgrepo-com.svg"
  glyph! :xmark_small, "#{dir}/stuff/glyph/xmark-small-svgrepo-com.svg"
  glyph! :xmark, "#{dir}/stuff/glyph/xmark-svgrepo-com.svg"
  glyph! :zap, "#{dir}/stuff/glyph/zap-svgrepo-com.svg"
  glyph! :zoom_in, "#{dir}/stuff/glyph/zoom-in-svgrepo-com.svg"
  glyph! :zoom_out, "#{dir}/stuff/glyph/zoom-out-svgrepo-com.svg"
end
