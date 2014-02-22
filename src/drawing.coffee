window.drawing = window.drawing || {}

class window.drawing.Graphics
    constructor: (@ctx) ->

    line: (from, to) ->
        @ctx.beginPath()
        @ctx.moveTo from.x, from.y
        @ctx.lineTo to.x, to.y
        @ctx.stroke()

    circle: (position, d, color) ->
        [x, y] = [position.x, position.y]

        @ctx.beginPath()
        @ctx.arc x, y, d, 0, (2 * Math.PI), false
        @ctx.closePath()
        @ctx.fillStyle = color
        @ctx.fill()

    rectangle: (pos, width, height, color = "#ff0000") ->
        @ctx.fillStyle = color
        @ctx.fillRect pos.x, pos.y, width, height

    transparentRectangle: (opacity, width, height) ->
        @ctx.fillStyle = "rgba(255, 255, 255, #{ opacity })";
        @ctx.fillRect 0, 0, width, height

    text: (pos, message, size="90px", align="right") ->
        @ctx.font = "#{ size } Arial"
        @ctx.textAlign = align
        @ctx.textBaseline = "middle"
        @ctx.fillStyle = "#000"
        @ctx.fillText message, pos.x, pos.y
