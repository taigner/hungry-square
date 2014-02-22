window.components = window.components || {}

Vec = math.Vector

blockSize = 20

class components.Player
    constructor: (@position, speed, direction, grav) ->
        @velocity = new Vec 0, 0
        @velocity.setLength speed
        @velocity.setAngle direction
        @gravity = new Vec 0, grav || 0

        @width = blockSize
        @height = blockSize
        @jumping = false

    accelerate: (acceleration) ->
        @velocity.addTo acceleration

    update: (commands, dt) ->
        @handleCommands commands, dt

        @velocity.addTo @gravity
        scaledVelocity = @velocity.multiply 10*dt
                                  .limit 10
        @position.addTo scaledVelocity

    draw: (drawing) ->
        drawing.rectangle @position, @width, @height, "#ff0000"

    collides: (displacement, other, dt) ->
        if other instanceof components.Food
            other.toBeRemoved = true
            return

        if displacement.y >= 0 and other.position.y > @position.y
            @jumping = false
            @velocity.y = @gravity.y

        @position.substractFrom displacement
        @velocity.x = 0

        if other instanceof components.Jumper
            if displacement.y > 0 and other.position.y > @position.y
                @accelerate new Vec(0, -150)
                @jumping = true

    handleCommands: (commands, dt) ->
        if commands.up and not @jumping
            @accelerate new Vec(0, -100)
            @jumping = true

        @position.substractFrom(new Vec(300*dt, 0).limit(10)) if commands.left
        @position.addTo(new Vec(300*dt, 0).limit(10)) if commands.right

    reset: (position) ->
        @position = position
        @velocity = new Vec 0, 0


class components.Block
    constructor: (@position, @width, @height, @color="#000") ->

    draw: (drawing) ->
        drawing.rectangle @position, @width, @height, @color

    reset: () ->
        @toBeRemoved = false


class components.Jumper extends components.Block
    constructor: (@position, @width, @height, @color="#00B233") ->
        super @position, @width, @height, @color


class components.Food extends components.Block
    constructor: (@position, @width, @height, @color="#E8890C") ->
        super @position, @width, @height, @color
