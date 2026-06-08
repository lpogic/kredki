require 'kredki'

window.size = [800, 648, limit: [0, 648..648]]
set layout: :xss

service! :simulation do
  def sketch
    @formulas = {}
    @results = {}
    job.loop(100){ update }
  end

  def formulas
    @formulas
  end

  def method_missing name, ...
    s = name.to_s
    @results[[s[0].ord - "a".ord, s[1].ord - "0".ord]]
  end

  def update
    pane.each(:cell) do |pad|
      yx = pad.subject
      value = begin
        eval(@formulas[yx])
      rescue Exception
        "error"
      end
      @results[yx] = value
      pad[:text!].set_subject value
    end
  end
end

cell = {
  size_y: 24,
  size_x: 1r,
  stroke: [1, :dark_gray],
  margin: 1
}

yss! size_x: 40 do
  pad! **cell, fill: Kredki.color(:gray).darken(10)
  (0...26).each do |y|
    pad! **cell, fill: Kredki.color(:gray).darken(10) do
      text! "#{("a".ord + y).chr}", mousy: false
    end
  end
end
(0...10).each do |x|
  yss! do
    pad! **cell, fill: Kredki.color(:gray).darken(10) do
      text! "#{x}", mousy: false
    end
    (0...26).each do |y|
      pad! :cell, **cell, fill: :gray do
        text! ".", mousy: false
        yx = [y, x]
        pane[:simulation].formulas[yx] = '"."'
        set_subject yx
      end
    end
  end
end

def commit_cell pad
  new_source = self.text
  text.set layoutic: true, scenic: true
  detach
  pad.margin = 1
  if new_source != source
    simulation.formulas[yx] = new_source
    simulation.update
  end
end

def edit_cell pad
  text = pad[:text!]
  yx = pad.subject
  simulation = pane[:simulation]
  source = simulation.formulas[yx]
  pad.margin = 0
  pad.note!(source, size_x: 1r, verse_font: :martian_mono) do |note|
    Event.each on_focus_leave, on_key_press(:enter) do
      new_source = note.text
      text.set layoutic: true, scenic: true
      note.detach
      pad.margin = 1
      if new_source != source
        simulation.formulas[yx] = new_source
      end
    end

    keyboard_request
    verse.select
  end
  text.set layoutic: false, scenic: false
end

on_mouse_click :primary do
  if it.target.is :cell
    if Kredki.keyboard.ctrl?
      y, x = it.target.subject
      name = "#{("a".ord + y).chr}#{("0".ord + x).chr}"
      layer.keyboard_pad.verse.paste name
    else
      edit_cell it.target
    end
    it.close
  end
end

on_mouse_click :secondary do
  if it.target.is :cell
    y, x = it.target.subject
    name = "#{("a".ord + y).chr}#{("0".ord + x).chr}"
    layer.keyboard_pad.verse.paste name
  end
end