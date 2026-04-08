require 'kredki'

button! "Next" do
  # Run blur animation on click.
  on_click.play 700 do |it|
    scene.clear_effects
    scene.gaussian_blur it.progress ** 2 * 50
  end.after do
    # Change button text.
    set "Exit"
  # Run reverse blur animation.
  end.play 700 do |it|
    scene.clear_effects
    scene.gaussian_blur (1 - it.progress ** 2) * 50
  end.after do
    scene.clear_effects
    # Set window closing event resolver.
    on_click{ window.close }
  end
end