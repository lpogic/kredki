# This is config loaded by default. Contains all the necessary definitions used by the core and ui modules.
# You can overwrite and add your own values ​​dynamically:
#   require 'kredki'
#   module Kredki
#     color! :primary, 20, 50, 70, 255
#     keyboard! do
#       key! :escape, 58
#     end
#   end
#
# If you don't want to load the default configuration, you can set the path to your own in the global variable $kredki_config before require 'kredki':
#   $kredki_config = './cutom_config.rb'
#   require 'kredki'
# This way 'custom config.rb' will be loaded instead of the current file.

module Kredki
  color! nil, 211, 211, 211, 255
  color! false, 0, 0, 0, 0
  color! 0, 0, 0, 0, 0

  color! :outline_focus, 182, 142, 0, 255
  color! :text_selection, 70, 80, 122, 255
  color! :text_selection_inactive, 70, 80, 112, 155
  color! :text, 255, 255, 255, 255

  color! :white, 255, 255, 255, 255
  color! :black, 0, 0, 0, 255
  color! :red, 122, 0, 0, 255
  color! :green, 0, 122, 0, 255
  color! :blue, 0, 0, 122, 255
  color! :gray, 111, 111, 111, 255
  color! :light_gray, 211, 211, 211, 255
  color! :dark_gray, 88, 88, 88, 255
  color! :yellow, 150, 150, 0, 255
  color! :orange, "#f06000"
  color! :transparent, 0, 0, 0, 0

  font! :arial, stuff("font/Arial.ttf")
  font! :lato, stuff("font/Lato-Regular.ttf")
  font! :dejavu, stuff("font/DejaVuSans.ttf")

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
  
    button! :left, 1
    button! :center, 2
    button! :right, 3
  
    scrollbar_speed! 0.3
    scrollbar_alt_speed! 0.06
  end

  joystick! do
    button! :b1, 0
    button! :b2, 1
    button! :b3, 2
    button! :b4, 3
    button! :b5, 4
    button! :b6, 5
    button! :b7, 6
    button! :b8, 7
    button! :b9, 8
    
    axis! :x, 0
    axis! :y, 1
    axis! :z, 2
  end

  plugin! :terminate_on_esc do
    on_key_down! :escape do |event|
      action.window.terminate!
    end
  end

  plugin! :close_on_esc do
    on_key_down! :escape do |event|
      action.window.destroy!
    end
  end

end

K = Kredki
