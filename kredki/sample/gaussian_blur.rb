require 'kredki'

button! "Next" do
  on_click.animate(700) do |ms, d|
    scene.clear_effects!
    scene.gaussian_blur! (1.0 * ms / d) ** 2 * 50
  end.after do
    self << "Exit"
  end.animate(700) do |ms, d|
    scene.clear_effects!
    scene.gaussian_blur! (1 - (1.0 * ms / d) ** 2) * 50
  end.after do
    scene.clear_effects!
    on_click{ window.close }
  end
end
