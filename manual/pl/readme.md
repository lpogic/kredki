# Instrukcja obsługi _Kredki_

## Kontekst wywołania i metoda Object#alter

Zmiana kontekstu wywołania, czyli tego, co aktualnie kryje się pod `self`, jest sposobem na uzyskanie zwięzłego kodu nawet przy rozbudowanych strukturach. 

## Job - kiedy czas wykonywania ma znaczenie

_Job_ to wbudowany mechanizm do sterowania czasem wykonywania kodu. Dostępne typy:
- AfterJob - kod wykonywany jest z ustalonym opóźnieniem
- LoopJob - kod wykonywany jest w pętli czasowej o określonym okresie
- SideJob - fragment kodu wykonywany jest równolegle, w osobnym wątku

_Job_ możemy tworzyć jako osobny byt:
```
job.after(1000){ p "XD" } # po 1000 ms wyświetl napis "XD" w terminalu
```
lub jub jako reakcja na zdarzenie:
```
on_mouse_press.loop(1000){ p "XD" } # po przyciśnięciu myszą wyświetlaj napis "XD" co 1000 ms
```

_Job_'y można kolejkować:
```
job.after(500){ p "Ide spać.." }.side{ sleep 3 }.after{ p "Jestem już wyspany" }
```
albo tworzyć drzewa:
```
job.after(500){ p "Zagrajmy w pingponga" }.then{ it.loop(1000){ p "Ping" }; it.after(500).loop(1000){ p "Pong" } }

Istnieje też specjalna methoda do uruchamiania animacji: #animate.
W pierwszym argumencie może on przyjąć animowany obiekt:
```
a = animation! "exploding-star.json"
job.animate a
```
lub liczbę interpretowaną jako okres trwania animacji:
```
pad = pad!
job.animate 2000 do
  pad.x! it # it przyjmuje wartości od 0 do 2000 (z krokiem zależnym od częstotliwości odświeżania)
end
```
