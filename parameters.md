# @title Params and Flags

# Params and Flags

Params is Kredki DSL for accessing object attributes. Like the standard attr_accessor, it defines a getter and a setter. 
Additionally, it defines a setter with the suffix '!':

```
  circle = Circle.new # assume that Circle has radius param
  circle.radius = 10 # set radius to 10
  circle.radius # => 10
  circle.radius! 15 # set radius to 15
  circle.radius # => 15
```

The '!' suffix method may seem redundant, but it actually has some useful advantages over the '...=' method:
- it can accept any number of arguments, named arguments and blocks ('...=' always single argument)
- it can return any value ('...=' always return the receiver)
- it can be called with an automatic receiver ('...=' must be called in the form `receiver.param = ...`)

On the other hand, the method with the '=' suffix offers a unique feature of operators with assigment (+=, -= etc.).

Setters with the '!' suffix are mostly designed according to the following rules:
- if it is called with a block, the block will be called with the current value as an argument before the update, and its result will be the new value
```
  obj.x = 1
  obj.x # => 1
  obj.x!{ it + 2 } # take the x value, add 2 to it and sets result as a new value
  obj.x # => 3
```
- if the new value is the same as current, no update is executed and `nil` is returned 
```
  obj.x = 1
  obj.x! 1 # => nil
```
- if value was changed, `true` is returned
```
  obj.x = 1
  obj.x! 2 # => true
```


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