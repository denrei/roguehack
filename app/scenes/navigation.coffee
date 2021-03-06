module.exports =

  key: 'navigation'

  init: (data) ->
    console.log 'init', data, this

  preload: ->
    @load.image 'tile', 'street_X_YTiling.png'
    @load.spritesheet('playerAnim', 'character/jen-spritesheet.png', { frameWidth: 12, frameHeight: 25, endFrame: 18 });

    @load.image window.roguehack.Constant.ID_NPC_CHIEF, 'character/megaman.png'
    @load.image window.roguehack.Constant.ID_NPC_DABYL, 'character/Dabyl-placeholder.png'
    @load.image window.roguehack.Constant.ID_NPC_IVIKA, 'character/Ivika-placeholder.png'
    @load.image window.roguehack.Constant.ID_NPC_SIVAN, 'character/Sivan-placeholder.png'
    @load.image window.roguehack.Constant.ID_NPC_TON, 'character/Ton-placeholder.png'
    @load.image window.roguehack.Constant.ID_NPC_VERA, 'character/Vera-placeholder.png'

    @load.audio 'bg_music', 'audio/icetrek.mp3'
    @load.image 'bg_clouds', 'bg_clouds.png'
    @load.image 'tilex', 'street_xTiling.png'
    @load.image 'tiley', 'street_yTiling.png'
    @load.image 'wall1', 'exteriorWall_southFacing_fullCollision_variant01.png'
    @load.image 'wall', 'exteriorWall_southFacing_fullCollision.png'
    @load.tilemapTiledJSON 'map', 'rl_tilemap.json'
    @load.image 'tiles', 'rl_tiles.png'

  create: ->
    # Create background
    @sound.audioPlayDelay = 0.1;
    @sound.loopEndOffset = 0.05;
    bgMusic  = @sound.add('bg_music')
    bgMusic.play()
    bgClouds = @add.tileSprite 0, -20, 5000, 320, 'bg_clouds'
    bgClouds.setScale 1.1
    # Create tile map
    map = @make.tilemap(key: 'map')
    tileset = map.addTilesetImage('rl_tileset', 'tiles', 32, 32) # First Argument is the name of Tileset referenced in Tilemap JSON

    #Create layer(s) w/ collision tiles
    layer = map.createStaticLayer(0, tileset, 0, 32)
    layer2 = map.createStaticLayer(1, tileset, 0, 32)
    layer.setCollisionByProperty({ collides: true });
    layer2.setCollisionByProperty({ collides: true });
    @matter.world.convertTilemapLayer(layer);
    @matter.world.convertTilemapLayer(layer2);

    @matter.world.setBounds map.widthInPixels, map.heightInPixels
    # @matter.world.createDebugGraphic()
    # @matter.world.drawDebug = true

    @cameras.main.setBounds 0, 0, map.widthInPixels, map.heightInPixels
    @cameras.main.setScroll 95, 100

    #Player must be created AFTER world physics are established...
    playerSprite = @matter.add.sprite 100, 200, 'playerAnim'
    input = new window.roguehack.Input(@input)
    @player = new window.roguehack.Player(playerSprite, input, @anims)
    @cam = new window.roguehack.Camera(@cameras.main, @player)
    npc = new window.roguehack.Npc(@, @player, map)

    # Create Top Level TileMap Layer (for objects that overlap NPCs)
    layer3 = map.createStaticLayer(2, tileset, 0, 32)
    layer3.setCollisionByProperty({ collides: true })
    @matter.world.convertTilemapLayer(layer3)

  update: (timestep, dt) ->
    @player.update(dt)
    @cam.update(dt)

  extend:
    MoveSpeed: 0.001

    quit: ->
      @scene.start 'menu', score: @score
