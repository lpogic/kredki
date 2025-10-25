# @title Parameters and Flags

# Parameters and Flags

From API user point of view, kredki parameter is collection of methods with common root.
One is for reading some value and two, ending with '=' and '!', for updating.
For example if object of Circle class has `radius` parameter, 
it would has `#radius`, `#radius=` and `#radius!` defined:

    circle = Circle.new
    circle.radius! 10
    circle.radius       # => 10
    circle.radius += 5
    circle.radius       # => 15

These update methods are interchangeable. Both have unique features that suit different situations.
The case in the example above may look like a simple access to an object attribute, 
but there can be much more going on for a parameter. First of all, 
updating the parameter value can perform additional tasks, e.g. request an update of the canvas.
When a value is read, it can be retrieved from an external library that stores the actual state.

In _Kredki_ the parameters appear so often that a dedicated DSL was designed for them.
To define the simplest parameter, just create a method with the suffix '!' and 
add `param` before the keyword `def`, as in the example below:

    class Circle
      param def radius! r
        @radius = r  # store new radius in @radius attribute
      end
    end

Methods `#radius` and `#radius=` are auto-created by DSL. Multi-argument, named arguments 
and blocks are allowed for method with '!' suffix. This is one of its advantages over method with '='.
If the read method is automatically generated, it is essential that the value is stored in 
an attribute of the same name. DSL generates something like this by default: `def radius; @radius; end`.
When a read method should do something more, it should be defined after a comma, as in the example below:

    class Rectangle
      param def size! width, height = width
        @width = width
        @height = height
        true
      end, def size
        [@width, @height]
      end
    end

The name of the reading method should be updating method name without trailing '!'.

# Flags

Flags are just parameters with one extra generated method ending with '?'.
This method returns `false` if reader metod returns `false` or `nil`. Otherwise it returns `true`.

Example:

    class Weather
      flag def sunny! s = true
        c, n = sunny? s
        return if c == n
        @sunny = n
        true
      end
    end

    weather = Weather.new
    weather.sunny?          # => false
    weather.sunny!          # default is true
    weather.sunny?          # => true
    weather.sunny = false
    weather.sunny           # => false
    weather.sunny! :not       # ':not' is a special value for flag negation
    weather.sunny           # => true

Tak jak dla zwykłych parametrów, w drugim argumencie można podać metodę do odczytu.