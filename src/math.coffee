window.math = window.math || {}
m = window.math

window.math.normalize = (value, min, max) ->
    (value-min) / (max-min)

window.math.lerp = (norm, min, max) ->
    (max-min) * norm + min

window.math.map = (value, sourceMin, sourceMax, destMin, destMax) ->
    m.lerp m.normalize(value, sourceMin, sourceMax), destMin, destMax

window.math.clamp = (value, min, max) ->
    Math.min Math.max(value, min), max

window.math.random = (min, max) ->
  Math.random() * (max - min) + min

window.math.rangeIntersect = (min0, max0, min1, max1) ->
    Math.max(min0, max0) > Math.min(min1, max1) and
    Math.min(min0, max0) < Math.max(min1, max1)

window.math.rectIntersect = (r0, r1) ->
    m.rangeIntersect(r0.position.x, r0.position.x + r0.width, r1.position.x, r1.position.x + r1.width) and
    m.rangeIntersect(r0.position.y, r0.position.y + r0.height, r1.position.y, r1.position.y + r1.height)

window.math.sign = (x) ->
    return 1 if x > 0
    return -1 if x < 0
    return 0

window.math.centerOfRectangle = (pos, w, h) ->
    new m.Vector pos.x + (w / 2), pos.y + (h / 2)

window.math.projectionVector = (first, second) ->
    firstCenter = m.centerOfRectangle first.position, first.width, first.height
    secondCenter = m.centerOfRectangle second.position, second.width, second.height

    xDist = firstCenter.x - secondCenter.x
    yDist = firstCenter.y - secondCenter.y

    firstMaxX = first.position.x + first.width
    secondMaxX = second.position.x + second.width
    firstMaxY = first.position.y + first.height
    secondMaxY = second.position.y + second.height

    xProject = Math.abs(xDist) - (firstMaxX - first.position.x + secondMaxX - second.position.x)/2.0
    yProject = Math.abs(yDist) - (firstMaxY - first.position.y + secondMaxY - second.position.y)/2.0

    if xProject > yProject
        return new m.Vector xProject * m.sign(xDist), 0
    
    new m.Vector 0, yProject * m.sign yDist
