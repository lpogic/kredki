require 'kredki'

table! size_x: 360 do
  column! 120
  column! 120
  column! 120
  
  row! do
    text! "Red"
    text! "Green"
    text! "Blue"
  end

  row! do
    text! "Czerwony"
    text! "Zielony"
    text! "Niebieski"
  end

  row! do
    text! "Rojo"
    text! "Verde"
    text! "Azul"
  end
end