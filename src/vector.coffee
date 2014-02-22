window.math = window.math || {}

class math.Vector
    constructor: (@x, @y) ->

    add: (v) ->
        new Vector @x+v.x, @y+v.y

    substract: (v) ->
        new Vector @x-v.x, @y-v.y

    multiply: (val) ->
        new Vector @x*val, @y*val

    devide: (val) ->
        new Vector @x/val, @y/val

    setAngle: (angle) ->
        length = @length()
        @x = Math.cos(angle) * length
        @y = Math.sin(angle) * length

    angle: () ->
        Math.atan2 @y, @x

    setLength: (length) ->
        angle = @angle()
        @x = Math.cos(angle) * length
        @y = Math.sin(angle) * length

    length: () ->
        Math.sqrt @x*@x + @y*@y

    lengthSquared: () ->
        @x*@x + @y*@y

    addTo: (v) ->
        @x += v.x
        @y += v.y

    substractFrom: (v) ->
        @x -= v.x
        @y -= v.y

    multiplyBy: (val) ->
        @x *= val
        @y *= val

    devideBy: (val) ->
        @x /= val
        @y /= val

    normalize: () ->
        length = @length()
        if length != 0 && length != 1
            @devideBy length

    limit: (max) ->
        if @lengthSquared() > max*max
            @normalize()
            @multiplyBy(max)
        this
