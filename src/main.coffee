c = document.getElementById('draw')
ctx = c.getContext('2d')

delta = 0
now = 0
before = Date.now()


# c.width = window.innerWidth
# c.height = window.innerHeight

c.width = 800
c.height = 600

keysDown = {}


window.addEventListener("keydown", (e) ->
    keysDown[e.keyCode] = true
, false)

window.addEventListener("keyup", (e) ->
    delete keysDown[e.keyCode]
, false)

setDelta = ->
    now = Date.now()
    delta = (now - before) / 1000
    before = now

enemies = []

toEnemy = 2
toToEnemy = 3

ogre = false

clamp = (v, min, max) ->
    if v < min then min else if v > max then max else v

collides = (a, b, as, bs) ->
    a.x + as > b.x and a.x < b.x + bs and a.y + as > b.y and a.y < b.y + bs

enemyInside = (e, i) ->
    e.x >= players[i].minX and e.x <= players[i].maxX and e.y >= players[i].minY and e.y <= players[i].maxY

spawn = ->
    type = Math.floor(Math.random() * 3)

    if type == 0
        y = 300
    if type == 1
        if Math.random() > 0.5
            y = 150
        else
            y = 420
    if type == 2
        if Math.random() > 0.5
            y = 50
        else
            y = 520

    y += Math.floor(Math.random() * 5) - 2

    x: -10
    y: y
    type: type

speedMod = 60
elapsed = 0

player = 0

hp = 10

update = ->
    setDelta()

    elapsed += delta

    if keysDown[65]
        player = 0
    if keysDown[68]
        player = 2
    if keysDown[83]
        player = 1

    speedMod += delta / 10

    for enemy, i in enemies
        enemy.x += speedMod * delta
        if enemy.x >= 380 and enemy.x <= 400 and enemy.type == player
            enemy.delete = true
        if enemy.x >= 690 and not enemy.delete
            enemy.delete = true
            hp -= 1
            if hp <= 0
                ogre = true

    for enemy, i in enemies
        if enemy.delete
            enemies.splice(i, 1)
            break

    toEnemy -= delta
    if toEnemy <= 0
        if toToEnemy >= 0.7
            toToEnemy -= 0.09
        toEnemy = toToEnemy

        r = Math.floor(Math.random() * 4)
        enemies.push spawn()

    draw(delta)

    if not ogre

        window.requestAnimationFrame(update)


draw = (delta) ->
    ctx.clearRect(0, 0, c.width, c.height)

    ctx.fillStyle = 'rgba(220, 20, 20, ' + (1 - 0.06 * (10 - hp)) + ')'
    ctx.fillRect(700, 50, 30, 500)

    if player == 0
        ctx.fillStyle = '#123456'
        ctx.fillRect(400, 220, 10, 160)
    if player == 1
        ctx.fillStyle = '#654321'
        ctx.fillRect(400, 100, 10, 100)
        ctx.fillRect(400, 400, 10, 100)
    if player == 2
        ctx.fillStyle = '#123321'
        ctx.fillRect(400, 0, 10, 100)
        ctx.fillRect(400, 500, 10, 100)

    for enemy, i in enemies
        ctx.fillStyle = '#444444'
        ctx.fillRect(enemy.x, enemy.y, 20, 16)

    ctx.fillStyle = if ogre then 'rgba(0, 0, 0, 0.5)' else'#000000'

    ctx.font = '24px Visitor'
    ctx.fillStyle = '#000000'
    ctx.fillText(elapsed.toFixed(2), 20, 20)
    ctx.fillText(hp.toFixed(0), 700, 20)

    if ogre
        ctx.font = '160px Visitor'
        ctx.textAlign = 'center'
        ctx.textBaseline = 'middle'
        ctx.fillStyle = '#000000'
        ctx.fillText('GAME OVER', 400, 300)


do ->
    w = window
    for vendor in ['ms', 'moz', 'webkit', 'o']
        break if w.requestAnimationFrame
        w.requestAnimationFrame = w["#{vendor}RequestAnimationFrame"]

    if not w.requestAnimationFrame
        targetTime = 0
        w.requestAnimationFrame = (callback) ->
            targetTime = Math.max targetTime + 16, currentTime = +new Date
            w.setTimeout (-> callback +new Date), targetTime - currentTime


update()
