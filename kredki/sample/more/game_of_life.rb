require 'kredki'

# Conway's game of life.

SIZE = 800
GRID = 50

window.set(
  size: [SIZE / GRID * GRID + 1, SIZE / GRID * GRID + 1], 
  resizable: false,
  title: "Game of Life - PAUSED"
)

# Game model.
service! :game do

  NEIGHBOURHOOD = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
  ]

  # Service initialization.
  def sketch
    @grid = new_grid
    @update_job = job(false).loop 20 do
      update
    end
    @play = false

    @cells = {}
  end

  attr :grid

  # Create new empty grid.
  def new_grid
    Array.new GRID do
      Array.new GRID, 0
    end
  end

  feature :play

  # Set whether simulation is in play mode.
  def set_play value = true
    return if (c = play) == (value = value == Not ? !c : value)
    if value
      job << @update_job
    else
      @update_job.cancel
    end
    @play = value
    true
  end

  def play
    @play
  end

  # Update simulation.
  def update
    grid = new_grid
    GRID.times do |i|
      GRID.times do |j|
        sum = NEIGHBOURHOOD.sum do |n|
          ni = i + n[0]
          ni += GRID if ni < 0
          ni -= GRID if ni >= GRID
          nj = j + n[1]
          nj += GRID if nj < 0
          nj -= GRID if nj >= GRID
          @grid[ni][nj]
        end
        if @grid[i][j] > 0
          grid[i][j] = sum < 2 || sum > 3 ? 0 : 1
        else
          grid[i][j] = sum == 3 ? 1 : 0
        end
      end
    end
    @grid = grid

    @cells.each do |xy, cell|
      x, y = xy
      cell.set fill: @grid[x][y] > 0 ? :white : :black
    end
  end

  # Put cell of given coordinates.
  def put xy, cell
    @cells[xy] = cell
  end

  # Get cell of given coordinates.
  def get xy
    @cells[xy]
  end

  # Set cell state to active.
  def set_cell x, y, cell
    @grid[x][y] = 1
    cell.fill = :white
  end
  
  # Set cell state to inactive.
  def unset_cell x, y, cell
    @grid[x][y] = 0
    cell.fill = :black
  end

  # Toggle cell state.
  def toggle_cell x, y, cell
    if @grid[x][y] > 0
      unset_cell x, y, cell
    else
      set_cell x, y, cell
    end
  end
end

# Simulation elements.

set layout: [:xss, 1], margin: 1

GRID.times do |x|
  yss! 1 do
    GRID.times do |y|
      pad! :cell, size: SIZE / GRID - 1, fill: :black do
        pane[:game].put [x, y], self

        # Toggle cell between active/inactive on mouse press.
        on_mouse_press always: true do
          pane[:game].toggle_cell x, y, self
        end

        # Set cell active on mouse primary button drag or set inactive on mouse secondary button drag.
        on_mouse_enter do |e|
          if Kredki.mouse.pressed? :primary
            pane[:game].set_cell x, y, self
          elsif Kredki.mouse.pressed? :secondary
            pane[:game].unset_cell x, y, self
          end
        end
        
      end
    end
  end
end

# Early close press event to prevent drag pinning.
on_mouse_press early: true do |e|
  e.close
end

# Switch between play/pause mode on space press.
on_key_press :space do
  game = pane[:game]
  if game.play
    game.set_play false
    window.set_title "Game of Life - PAUSED"
  else
    game.set_play true
    window.set_title "Game of Life - RUNNING"
  end
end

# Welcome layer disposed on first space key press.
pane.layer! do
  text! <<~xx
    Game of Life
    Control: 
    Click on a cell to toggle between active/inactive mode.
    Press [SPACE] to run/pause simulation.
    Press [ESC] to exit.
  xx

  on_key_press :space do |event|
    layer.detach
  end
end
