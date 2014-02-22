window.requestAnimFrame = (() ->
    window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame)()

canvas = document.querySelector "#canvas"
ctx = canvas.getContext "2d"

width = canvas.width = 1400
height = canvas.height = 700

Vec = math.Vector
d = new drawing.Graphics ctx
m = math
c = components

player = new c.Player new Vec(100, height/2+50), 0, 0, 5
keys = {}

currentScore = 0
timer = null
timerTick = (ts) ->
    currentScore += 1

initialBlocks = [new c.Block(new Vec(-100, 520), 840, 20),
                 new c.Block(new Vec(660, 200), 200, 20),
                 new c.Block(new Vec(840, 180), 20, 20),
                 new c.Block(new Vec(1020, 520), 100, 20),
                 new c.Block(new Vec(1360, 420), 40, 20),
                 new c.Block(new Vec(0, 340), 200, 20),
                 new c.Block(new Vec(240, 220), 40, 20),
                 new c.Block(new Vec(0, 160), 80, 20),
                 new c.Block(new Vec(1300, 120), 80, 20),
                 new c.Block(new Vec(1100, 500), 20, 20),
                 new c.Block(new Vec(1160, 420), 60, 20),
                 new c.Block(new Vec(1160, 440), 20, 60),
                 new c.Block(new Vec(1080, 260), 100, 20),
                 new c.Block(new Vec(1040, 240), 60, 20),
                 new c.Block(new Vec(1000, 220), 60, 20),
                 new c.Block(new Vec(1000, 200), 20, 20),

                 new c.Food(new Vec(320, 500), 20, 20),
                 new c.Food(new Vec(120, 260), 20, 20),
                 new c.Food(new Vec(1060, 500), 20, 20),
                 new c.Food(new Vec(1280, 320), 20, 20),
                 new c.Food(new Vec(60, 60), 20, 20),
                 new c.Food(new Vec(840, 60), 20, 20),
                 new c.Food(new Vec(560, 60), 20, 20),
                 new c.Food(new Vec(1160, 240), 20, 20),
                 new c.Food(new Vec(500, 380), 20, 20),
                 new c.Food(new Vec(260, 80), 20, 20),

                 new c.Jumper(new Vec(700, 500), 40, 20)]

blocks = initialBlocks.slice(0)

startTimer = () ->
    currentScore = 0
    timer = setInterval timerTick, 500

reset = () ->
    player.reset new Vec(100, height/2+50)
    clearInterval timer
    startTimer()
    blocks = initialBlocks.slice(0)
    _.each blocks, (block) -> block.reset()

drawSkyAndSun = () ->
    ctx.save()
    gradient = ctx.createLinearGradient(0, 0, 0, height)
    gradient.addColorStop 0, "#afd8f7"
    gradient.addColorStop 1, "#f7fcff"

    ctx.fillStyle = gradient
    ctx.fillRect 0, 0, width, height
    ctx.restore()

    d.circle new Vec(width*0.8, height*0.15), 67, "#ffff7f"

mapKeys = () ->
    commands = {}
    if keys["38"] == true
        commands.up = true
    if keys["37"] == true
        commands.left = true
    if keys["39"] == true
        commands.right = true
    if keys["82"] == true
        commands.reload = true
    commands

lookForGameCommands = (commands) ->
    if commands.reload == true
        window.location.reload()

update = (dt) ->
    if not _.any(blocks, (block) -> block instanceof components.Food)
        clearInterval timer
        return false

    ctx.clearRect 0, 0, width, height

    commands = mapKeys(keys)
    lookForGameCommands commands

    player.update commands, dt

    for block in blocks when m.rectIntersect player, block
        displacement = m.projectionVector player, block
        player.collides displacement, block, dt

    blocks = _.filter blocks, (block) -> not block.toBeRemoved
    
    borders player

    true

render = () ->
    drawSkyAndSun()
    d.text new Vec(width-100, height-60), currentScore
    block.draw d for block in blocks
    player.draw d

lastTime = Date.now()

won = () ->
    d.transparentRectangle 0.6, width, height
    d.text new Vec(width/2, height/2), "Satt! #{ currentScore } Punkte", "120px", "center"

animate = () ->
    now = Date.now()
    dt = (now - lastTime) / 1000

    return won() if not update dt
    render()

    lastTime = now
    requestAnimFrame animate

borders = (element) ->
    element.position.x = -element.width if element.position.x > width + element.width
    element.position.x = width + element.width if element.position.x < -element.width

    reset() if element.position.y > height

document.body.addEventListener "keydown", (e) -> keys[e.keyCode] = true
document.body.addEventListener "keyup", (e) -> keys[e.keyCode] = false

window.onload = () ->
    animate()
    startTimer()
