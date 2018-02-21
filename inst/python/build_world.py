# -*- coding: utf-8 -*-
"""
Created on Mon Nov 06 15:59:11 2017

@author: gawn
"""

# generate overall world
import os
import sys
import time
import numpy
import random
from shutil import rmtree
from pymclevel import mclevel, box, Entity, nbt
from pymclevel.materials import alphaMaterials as m

# let's try without this at the moment
#from tree import Tree, treeObjs

# Where does the world file go?
worlddir = sys.argv[1]
map_type = 'game'
game_mode = 1 # Creative
out_filename = sys.argv[2]
dtm_filename = sys.argv[3]
lcm_filename = sys.argv[4]
tf = sys.argv[5]
tt1 = sys.argv[6]
tt2 = sys.argv[7]

# remove existing map (else it just modifies)
rmtree(worlddir, True)

with open(tf, "a") as myfile:
    myfile.write("appended text\n")
    myfile.close()

# R-values from the texture TIFF are converted to blocks of the given
# blockID, blockData, depth.
block_id_lookup = {
    5 : (m.Sand.ID, m.Sand.blockData, 1), # Coastal
    9 : (3, 2, 0), # Bog
    4 : (m.WaterActive.ID, m.WaterActive.blockData, 1), # Water
    7 : (m.Stone.ID, m.Stone.blockData, 2), # Sea cliffs
    3 : (3, 1, 1), # Salt flats/marsh
    6 : (13, 0, 1), # vegitated shingle
    8 : (8, 0, 1), # non woodland river
    1 : (m.Dirt.ID, 2, 2), # non woodland bare area
    10 : (3, 2, 0), # Upland fens and swamp
    2 : (4, 0, 1), # littoral rock
    11 : (48, 0, 1), # Marsh fens and swamp
    12 : (m.Grass.ID, m.Grass.blockData, 2), # Calcareous grassland
    13 : (m.Grass.ID, m.Grass.blockData, 2), # Meadows and improved grassland
    14 : (m.Grass.ID, m.Grass.blockData, 2), # Heather grassland
    15 : (m.Grass.ID, m.Grass.blockData, 2), # Upland calcareous grassland
    16 : (m.Grass.ID, m.Grass.blockData, 2), # Non woodland-Grassland
    17 : (m.Dirt.ID, m.Dirt.blockData, 1), # upland heathland
    18 : (m.Dirt.ID, m.Dirt.blockData, 1), # Heather/moorland
    19 : (m.Grass.ID, m.Grass.blockData, 2), # broadleaf decidious woodland
    20 : (m.Grass.ID, m.Grass.blockData, 2), # Coniferous woodland
    21 : (m.Grass.ID, m.Grass.blockData, 2), # mixed woodland
    22 : (m.Grass.ID, m.Grass.blockData, 2), # lowdensity woodland/shrubs/coppice
    23 : (m.Cobblestone.ID, m.Cobblestone.blockData, 3), # inland limestone rock 
    24 : (m.Farmland.ID, 7, 0), # arable/agricultral land
    25 : (1, 6, 2), # Urban 
    251 : (1, 5, 2), # Suburban
    26 : (1, 2, 2), # windfarm
    27 : (56, 0, 2), # Quarry
    29 : (m.Farmland.ID, 7, 0), # beetroot
    30 : (m.Farmland.ID, 7, 0), # field bean
    31 : (m.Farmland.ID, 7, 0), # maize
    32 : (m.Farmland.ID, 7, 0), # oil seed rape
    33 : (m.Farmland.ID, 7, 0), # other
    34 : (m.Farmland.ID, 7, 0), # potatoes
    35 : (m.Farmland.ID, 7, 0), # spring barley
    36 : (m.Farmland.ID, 7, 0), # spring wheat
    37 : (m.Farmland.ID, 7, 0), # winter barley
    38 : (m.Farmland.ID, 7, 0), # winter wheat
    78 : (m.Stone.ID, m.Stone.blockData, 2), # Snow
    131 : (m.Grass.ID, m.Grass.blockData, 2), # Neutral grassland
    132 : (m.Grass.ID, m.Grass.blockData, 2), # gr (Improved grassland)
    133 : (m.Grass.ID, m.Grass.blockData, 2), # Lowland meadows
    999 : (25, 0, 2), # unknown
}


#block_id_lookup = {
#    0 : (m.Grass.ID, None, 2),
#    10 : (m.Dirt.ID, 1, 1), # blockData 1 == grass can't spread
#    20 : (m.Grass.ID, None, 2),
#    30 : (m.Cobblestone.ID, None, 1),
#    40 : (m.StoneBricks.ID, None, 3),
#    200 : (m.Water.ID, 0, 2), # blockData 0 == normal state of water
#    210 : (m.WaterActive.ID, 0, 1),
#    220 : (m.Water.ID, 0, 1),
#}

plant_chance = {
    m.Watermelon.ID : 0.00001,
    m.Pumpkin.ID : 0.00001,
    m.SugarCane.ID : 0.01,
    "tree" : 0.001,
    m.TallGrass.ID : 0.003,
    "flower" : 0.0035,
}

def random_material():
    """Materials to be hidden underground to help survival play."""

    stone_chance = 0.90
    very_common = [m.Sand, m.Cobblestone, m.CoalOre, m.IronOre]
    common = [m.Clay, m.Obsidian, m.Gravel, m.MossStone, m.Dirt]
    uncommon = [m.RedstoneOre, m.LapisLazuliOre, m.GoldOre, 129]
    rare = [ m.Glowstone, m.DiamondOre, m.BlockofIron, m.TNT,
             m.BlockofGold, m.LapisLazuliBlock]
    very_rare = [ m.BlockofDiamond ]

    x = random.random()
    choice = None
    l = None
    if x < stone_chance:
        choice = m.Stone
    elif x < 0.96:
        l = very_common
    elif x < 0.985:
        l = common
    elif x < 0.998:
        l = uncommon
    elif x < 0.9995:
        l = rare
    else:
        l = very_rare
    if l is not None:
        choice = random.choice(l)
    if not isinstance(choice, int):
        choice = choice.ID
    return choice

with open(tf, "a") as myfile:
  myfile.write("Loading csvs for %s\n" % out_filename)
  myfile.close()
data = dict(elevation=[], features=[])

if not os.path.exists(dtm_filename):
    with open(tf, "a") as myfile:
      myfile.write("Could not load csv file %s!\n" % dtm_filename)
      myfile.close()
    sys.exit()

data['elevation'] = numpy.genfromtxt(dtm_filename, delimiter=',').astype(int)
    

if not os.path.exists(lcm_filename):
    with open(tf, "a") as myfile:
      myfile.write("Could not load csv file %s!\n" % lcm_filename)
      myfile.close()
    sys.exit()

data['features'] = numpy.genfromtxt(lcm_filename, delimiter=',').astype(int)

elevation= data['elevation']
material = data['features']

with open(tf, "a") as myfile:
  myfile.write("CSV is %s high, %s wide\n" % (len(elevation), len(elevation[0])))
  myfile.close()

# load in the tree data
TTop1 = []
TTop1 = numpy.genfromtxt(tt1, delimiter=',').astype(int)
TTop2 = []
TTop2 = numpy.genfromtxt(tt2, delimiter=',').astype(int)

def buildTree(TType, world, y, z, x):
    
    global TTop1
    global TTop2
    
    index_x = x-3
    index_z = z-3
    
    if TType == 'conf':
        tree_pick = 1
    elif TType == 'broad':
        tree_pick = random.choice([0,0,0,2])
    elif TType == 'mixed':
        tree_pick = random.choice([0,0,1,2])
        
    if tree_pick == 1:
        
        # trunk
        trunk_size = random.choice([7,8,9])
        for l in range(1, (trunk_size + 1)):
            world.setBlockAt(x, y + l, z, 17)
            world.setBlockDataAt(x, y + l, z, tree_pick)
            
        # leaves
        for num, row in enumerate(TTop2):
          choice = random.random()
          if choice > 0.05:
            world.setBlockAt(index_x + row[1], y + row[0] + (trunk_size-5), index_z + row[2], 18)
            world.setBlockDataAt(index_x + row[1], y + row[0] + (trunk_size-5), index_z + row[2], tree_pick)
        
    if (tree_pick == 0) or (tree_pick == 2):
        
        # trunk
        trunk_size = random.choice([4,5,6])
        for l in range(1, (trunk_size + 1)):
            world.setBlockAt(x, y + l, z, 17)
            world.setBlockDataAt(x, y + l, z, tree_pick)
            
        # leaves
        for num, row in enumerate(TTop1):
          choice = random.random()
          if choice > 0.05:
            world.setBlockAt(index_x + row[1], y + row[0] + (trunk_size-1), index_z + row[2], 18)
            world.setBlockDataAt(index_x + row[1], y + row[0] + (trunk_size-1), index_z + row[2], tree_pick)
    
    return world

def setspawnandsave(world, point, tf):
    """Sets the spawn point and player point in the world and saves the world.

    Taken from TopoMC and tweaked to set biome.
    """
    with open(tf, "a") as myfile:
      myfile.write("Saving chunks\n")
      myfile.close()
      
    world.GameType = game_mode
    spawn = point
    spawn[1] += 2
    world.setPlayerPosition(tuple(point))
    world.setPlayerSpawnPosition(tuple(spawn))

    # In game mode, set the biome to Plains (1) so passive
    #  mobs will spawn.
    # In map mode, set the biome to Ocean (0) so they won't.
    if map_type == 'game':
        biome = 1
    else:
        biome = 0
    numchunks = 0
    biomes = TAG_Byte_Array([biome] * 256, "Biomes")
    for i, cPos in enumerate(world.allChunks, 1):
        ch = world.getChunk(*cPos)
        if ch.root_tag:
            ch.root_tag['Level'].add(biomes)
        numchunks += 1

    world.saveInPlace()
    with open(tf, "a") as myfile:
      myfile.write("Saved %d chunks.\n" % numchunks)
      myfile.close()

with open(tf, "a") as myfile:
  myfile.write("Creating world %s\n" % worlddir)
  myfile.close()

world = mclevel.MCInfdevOldLevel(worlddir, create=True)
from pymclevel.nbt import TAG_Int, TAG_String, TAG_Byte_Array
# Set Data tags #
tags = [TAG_Int(0, "MapFeatures"),
        TAG_String("flat", "generatorName"),
        TAG_String("0", "generatorOptions"),
        nbt.TAG_Long(name = 'DayTime', value = 4000)]
for tag in tags:
    world.root_tag['Data'].add(tag)

# Set Game rules #
rule = nbt.TAG_Compound(name = 'GameRules',
                        value = [TAG_String("false", "doDaylightCycle"),
                                 TAG_String("false", "doMobSpawning")])
world.root_tag['Data'].add(rule)

# The code tracks the peak [x,y,z]
# this is a placeholder
peak = [10, 255, 10]

x_extent = len(elevation)
x_min = 0
x_max = len(elevation)

z_min = 0
z_extent = len(elevation[0])
z_max = z_extent

#I think this leaves space for the glass walls?
extra_space = 1

# Sent minimum depth of earth
y_min = 10

bedrock_bottom_left = [-extra_space, 0,-extra_space]
bedrock_upper_right = [x_extent + extra_space + 1, y_min-1, z_extent + extra_space + 1]

glass_bottom_left = list(bedrock_bottom_left)
#glass_bottom_left[1] += 1
glass_upper_right = [x_extent + extra_space+1, 255, z_extent + extra_space+1]

air_bottom_left = [0,y_min,0]
air_upper_right = [x_extent, 255, z_extent]

# Glass walls
wall_material = m.Air
with open(tf, "a") as myfile:
  myfile.write("Putting up walls: %r %r\n" % (glass_bottom_left, glass_upper_right))
  myfile.close()
  
tilebox = box.BoundingBox(glass_bottom_left, glass_upper_right)

with open(tf, "a") as myfile:
  myfile.write("Creating chunks.\n")
  myfile.close()
chunks = world.createChunksInBox(tilebox)
world.fillBlocks(tilebox, wall_material)
# 
# # Air in the middle.
# bottom_left = (0, 1, 0)
# upper_right = (len(elevation), 255, len(elevation[0]))
# with open(tf, "a") as myfile:
#   myfile.write("Carving out air layer. %r %r\n" % (bottom_left, upper_right))
#   myfile.close()
# tilebox = box.BoundingBox(bottom_left, upper_right)
# world.fillBlocks(tilebox, m.Air, [wall_material])

with open(tf, "a") as myfile:
  myfile.write("Populating chunks.\n")
  myfile.close()
  
def buildWorld(x, z):
  
  global world
  global peak
  global y_min
  global map_type
  global myfile
  global x_extent
  global material
  global elevation
  
  if z == 1:
    with open(tf, "a") as myfile:
      myfile.write("x = %r out of %r\n" % (x, x_extent))
      myfile.close()
  
  y = elevation[x][z]
  my_id = material[x][z]

  block_id, block_data, depth = block_id_lookup[my_id]
  actual_y = y + y_min
  if actual_y > peak[1] or (peak[1] == 255 and y != 0):
      peak = [x + 1, actual_y + 15, z]

  # Don't fill up the whole map from bedrock, just draw a shell.
  # this means there is a big cavern under everything... i think
  start_at = max(1, actual_y - depth - y_min)

  # If we were going to optimize this code, this is where the
  # optimization would go. Lay down the stone in big slabs and
  # then sprinkle goodies into it.
  stop_at = actual_y-depth
  for elev in range(start_at, stop_at):
      if map_type == 'map' or elev == stop_at - 1:
          block = m.Stone.ID
      else:
          block = random_material()
      world.setBlockAt(x,elev,z, block)

  # now place the materials
  start_at = actual_y - depth
  stop_at = actual_y + 1
  
#        if random.random() < 0.25:
#            Chicken = Entity.Create('Chicken')
#            Entity.setpos(Chicken, (x, actual_y + 3, z))
#            world.addEntity(Chicken)
      
  # Add in if statements as you like for various special cases for placing materials
  if block_id == m.WaterActive.ID:
      # Carve a little channel for active water so it doesn't overflow.
      start_at -= 1
#            stop_at -= 1
      
      if random.random() < 0.002:
          Squid = Entity.Create('Squid')
          Entity.setpos(Squid, (x, actual_y - 1, z))
          world.addEntity(Squid)
  
  for elev in range(start_at, stop_at):
      world.setBlockAt(x, elev, z, block_id)
      if block_data:
          world.setBlockDataAt(x, elev, z, block_data)

  if my_id == 10: # Upland fens and swamp
      world.setBlockAt(x, elev + 1, z , 31)
      world.setBlockDataAt(x, elev + 1, z, 2)
  
  #elif my_id == 11: # Marsh fens and swamp
  #    world.setBlockAt(x, elev + 1, z , 83)
  #    world.setBlockDataAt(x, elev + 1, z, 2)
  
  #if my_id == 13: # Improved grassland
  #    world.setBlockAt(x, elev + 1, z , 31)
  #    world.setBlockDataAt(x, elev + 1, z, 1)
  
  elif my_id == 14: # Heather grassland
      choice = random.random()
      if choice < 0.5:
        if choice < 0.25:
          world.setBlockAt(x, elev + 1, z , 38)
          world.setBlockDataAt(x, elev + 1, z, 7)
        else:
          world.setBlockAt(x, elev + 1, z , 38)
          world.setBlockDataAt(x, elev + 1, z, 2)
      else:
        world.setBlockAt(x, elev + 1, z , 31)
        world.setBlockDataAt(x, elev + 1, z, 1)
  
  elif my_id == 17: # Upland heather
      choice = random.random()
      if choice < 0.5:
        if choice < 0.25:
          world.setBlockAt(x, elev + 1, z , 38)
          world.setBlockDataAt(x, elev + 1, z, 7)
        else:
          world.setBlockAt(x, elev + 1, z , 38)
          world.setBlockDataAt(x, elev + 1, z, 2)
  
  elif my_id == 18: # Heather/moorland
      choice = random.random()
      if choice < 0.5:
        world.setBlockAt(x, elev + 1, z , 175)
        world.setBlockDataAt(x, elev + 1, z, 5)
  
  elif my_id == 19: # Broadleaf decidious woodland
      choice = random.random()
      if choice < 0.05:
        world = buildTree('broad', world, elev, z, x)
      else:
        world.setBlockAt(x, elev + 1, z , 31)
        world.setBlockDataAt(x, elev + 1, z, 1)
  
  elif my_id == 20: # Coniferous woodland
      choice = random.random()
      if choice < 0.05:
        world = buildTree('conf', world, elev, z, x)
      else:
        world.setBlockAt(x, elev + 1, z , 31)
        world.setBlockDataAt(x, elev + 1, z, 1)
        
  elif my_id == 21: # mixed woodland
      choice = random.random()
      if choice < 0.05:
        world = buildTree('mixed', world, elev, z, x)
      else:
        world.setBlockAt(x, elev + 1, z , 31)
        world.setBlockDataAt(x, elev + 1, z, 1)
      
  elif my_id == 22: # low density woodland
      choice = random.random()
      if choice < 0.025:
        world = buildTree('mixed', world, elev, z, x)
      else:
        world.setBlockAt(x, elev + 1, z , 31)
        world.setBlockDataAt(x, elev + 1, z, 1)
                  
  elif my_id == 24: # inland limestone rock
      world.setBlockAt(x, elev + 1, z , m.Crops.ID)
      world.setBlockDataAt(x, elev + 1, z, 6)
              
  elif my_id == 29: # Beetroot
      world.setBlockAt(x, elev + 1, z , 141)
      world.setBlockDataAt(x, elev + 1, z, 7)
  
  elif my_id == 30: # field bean
      world.setBlockAt(x, elev + 1, z , 104)
      world.setBlockDataAt(x, elev + 1, z, 7)
  
  elif my_id == 31: # maize
      world.setBlockAt(x, elev + 1, z , m.Crops.ID)
      world.setBlockDataAt(x, elev + 1, z, 6)
  
  elif my_id == 32: # oilseed rape
      world.setBlockAt(x, elev + 1, z , 37)
      world.setBlockDataAt(x, elev + 1, z, 0)
  
  elif my_id == 33: # farmland other
      world.setBlockAt(x, elev + 1, z , 38)
      world.setBlockDataAt(x, elev + 1, z, 8)
  
  elif my_id == 34: # potatoes
      world.setBlockAt(x, elev + 1, z , 142)
      world.setBlockDataAt(x, elev + 1, z, 7)
  
  elif my_id == 35: # Farm - spring barley
      world.setBlockAt(x, elev + 1, z , m.Crops.ID)
      world.setBlockDataAt(x, elev + 1, z, 1)
  
  elif my_id == 36: # Farm - spring wheat
      world.setBlockAt(x, elev + 1, z , m.Crops.ID)
      world.setBlockDataAt(x, elev + 1, z, 5)
  
  elif my_id == 37: # Farm - winter barley
      world.setBlockAt(x, elev + 1, z , m.Crops.ID)
      world.setBlockDataAt(x, elev + 1, z, 3)
  
  elif my_id == 38: # Farm - winter wheat
      world.setBlockAt(x, elev + 1, z , m.Crops.ID)
      world.setBlockDataAt(x, elev + 1, z, 6)
  
  elif my_id == 25: # Urban
      
      # set height width and depth randomly
      pH = random.random()
      if pH < 0.2:
          H = 12
      elif pH < 0.6:
          H = 10
      else:
          H = 8
          
      pW = random.random()
      if pW < 0.2:
          W = 4
      elif pW < 0.6:
          W = 3
      else:
          W = 2
          
      pD = random.random()
      if pD < 0.2:
          D = 4
      elif pD < 0.6:
          D = 3
      else:
          D = 2                    
              
      if numpy.all(material[x-W:x+W, z-D:z+D] == 25): # Block of urban
                 
          #MatPres = [] # empty array to get materials present
          
          empty = 0
          
          for nY in range(actual_y + 1, actual_y + H + 2): # Loop through and see what is there
              for nX in range(x - W - 1, x + W + 1): # extend x and y to allow 'streets'
                  for nZ in range(z - D - 1, z + D + 1):
                       if world.blockAt(nX,nY,nZ) != 0:
                         empty = 1
                         break
                  if empty == 1:
                    break
              if empty == 1:
                break
                       
          # if all(item == 0 for item in MatPres): # If we have space to build the house
          if empty == 0:

              wallMat = random.choice([(125,2), (98,0), (45,0)])

              for nY in range(actual_y - 1, actual_y + H + 1): # Loop through and build the house

                  # set block type for level
                  if nY == max(range(actual_y + 1, actual_y + H + 1)): # Roof
                      blockType = random.choice([(44,0), (44,1), (44,5)])
                  elif nY - actual_y == 2 or nY - actual_y == 4 or nY - actual_y == 6 or nY - actual_y == 8 or nY - actual_y == 10: # Windows level
                      blockType = (m.Glass.ID, 0)
                  else: # Wall
                      blockType = wallMat

                  for nX in range(x - W, x + W):

                      # make pillars and place block
                      for nZ in range(z - D, z + D):

                          bT = blockType # save to reset

                          # Make pillars
                          xEdge = nX == min(range(x - W, x + W)) or nX == max(range(x - W, x + W))
                          zEdge = nZ == min(range(z - D, z + D)) or nZ == max(range(z - D, z + D))
                          if xEdge and zEdge:
                                  if nY != max(range(actual_y + 1, actual_y + H + 1)):
                                      blockType = wallMat

                          if nY - actual_y < 1:
                              blockType = (1, 6)

                          world.setBlockAt(nX, nY, nZ, blockType[0])
                          world.setBlockDataAt(nX, nY, nZ, blockType[1])

                          blockType = bT
              
          else: # urban but we can't put a house
              if random.random() < 0.005: # Add a cat
                  Cat = Entity.Create('Ocelot')
                  Entity.setpos(Cat, (x, actual_y + 2, z)) # Where to put it
                  Cat['CatType'] = nbt.TAG_Int(random.choice([1,2,3])) # What kind of cat
                  world.addEntity(Cat) # Add it
              if random.random() < 0.015: # Add a person
                  Villager = Entity.Create('Villager')
                  Entity.setpos(Villager, (x, actual_y + 2, z)) # Where to put it
                  Villager['Profession'] = nbt.TAG_Int(random.choice([0,1,2,3,4,5])) # What kind of cat
                  world.addEntity(Villager) # Add it
                  
                  
  elif my_id == 251: # Suburban
      
      # set height width and depth randomly
      pH = random.random()
      if pH < 0.2:
          H = 3
      elif pH < 0.6:
          H = 4
      else:
          H = 4
          
      pW = random.random()
      if pW < 0.2:
          W = 4
      elif pW < 0.6:
          W = 3
      else:
          W = 2
          
      pD = random.random()
      if pD < 0.2:
          D = 4
      elif pD < 0.6:
          D = 3
      else:
          D = 2                    
              
      if numpy.all(material[x-W:x+W, z-D:z+D] == 251): # Block of urban
                 
          #MatPres = [] # empty array to get materials present
          
          empty = 0
          
          for nY in range(actual_y + 1, actual_y + H + 2): # Loop through and see what is there
              for nX in range(x - W - 2, x + W + 2): # extend x and y to allow 'streets'
                  for nZ in range(z - D - 1, z + D + 1):
                       if world.blockAt(nX,nY,nZ) != 0:
                         empty = 1
                         break
                  if empty == 1:
                    break
              if empty == 1:
                break
                       
          # if all(item == 0 for item in MatPres): # If we have space to build the house
          if empty == 0:
            
              wallMat = random.choice([(43,2), (5,0), (5,2)])
              
              for nY in range(actual_y - 1, actual_y + H + 1): # Loop through and build the house
                  
                  # set block type for level
                  if nY == max(range(actual_y + 1, actual_y + H + 1)): # Roof
                      blockType = random.choice([(126,1), (126,5), (126,4)])
                  elif nY - actual_y  == 2 or nY - actual_y == 4 or nY - actual_y == 6: # Windows level
                      blockType = (m.Glass.ID, 0)
                  else: # Wall
                      blockType = wallMat
                      
                  for nX in range(x - W, x + W):
                      
                      # make pillars and place block
                      for nZ in range(z - D, z + D):
                          
                          bT = blockType # save to reset
                          
                          # Make pillars
                          xEdge = nX == min(range(x - W, x + W)) or nX == max(range(x - W, x + W))
                          zEdge = nZ == min(range(z - D, z + D)) or nZ == max(range(z - D, z + D))
                          if xEdge and zEdge:
                                  if nY != max(range(actual_y + 1, actual_y + H + 1)):
                                      blockType = wallMat                       
                          
                          if nY - actual_y < 1:
                              blockType = (1, 6)
                          
                          world.setBlockAt(nX, nY, nZ, blockType[0])
                          world.setBlockDataAt(nX, nY, nZ, blockType[1])
                          
                          blockType = bT
          else: # urban but we can't put a house
              if random.random() < 0.001: # Add a cat
                  Cat = Entity.Create('Ocelot')
                  Entity.setpos(Cat, (x, actual_y + 2, z)) # Where to put it
                  Cat['CatType'] = nbt.TAG_Int(random.choice([1,2,3])) # What kind of cat
                  world.addEntity(Cat) # Add it
              if random.random() < 0.0075: # Add a person
                  Villager = Entity.Create('Villager')
                  Entity.setpos(Villager, (x, actual_y + 2, z)) # Where to put it
                  Villager['Profession'] = nbt.TAG_Int(random.choice([0,1,2,3,4,5])) # What kind of cat
                  world.addEntity(Villager) # Add it                
  
  elif my_id == 12: # Grassland
      choice = random.random()
      if choice < 0.5:
          if choice < 0.25:
              world.setBlockAt(x, elev + 1, z , 38)
              world.setBlockDataAt(x, elev + 1, z, 0)
          else:
              world.setBlockAt(x, elev + 1, z , 37)
              world.setBlockDataAt(x, elev + 1, z, 0)

  elif my_id == 131: # neutral grassland
      choice = random.random()
      if choice < 0.2:
          if choice < 0.1:
              world.setBlockAt(x, elev + 1, z , 38)
              world.setBlockDataAt(x, elev + 1, z, 1)
          else:
              world.setBlockAt(x, elev + 1, z , 38)
              world.setBlockDataAt(x, elev + 1, z, 3)
      if random.random() < 0.001: # add Sheep
          Sheep = Entity.Create('Sheep')
          Entity.setpos(Sheep, (x, actual_y + 3, z))
          Sheep['Variant'] = nbt.TAG_Int(random.choice([0]))
          world.addEntity(Sheep)
  
  elif my_id == 13: # improved grassland #1
      if random.random() < 0.001: # add Pig
          Pig = Entity.Create('Pig')
          Entity.setpos(Pig, (x, actual_y + 3, z))
          Pig['Variant'] = nbt.TAG_Int(random.choice([0]))
          world.addEntity(Pig)        

  elif my_id == 132: # improved grassland #2
      if random.random() < 0.001: # add Cow
          Cow = Entity.Create('Cow')
          Entity.setpos(Cow, (x, actual_y + 3, z))
          Cow['Variant'] = nbt.TAG_Int(random.choice([0]))
          world.addEntity(Cow) 

  elif my_id == 133: # lowland meadows
      choice = random.random()
      if choice < 0.002:
          if choice < 0.1: # add horse
              Horse = Entity.Create('Horse')
              Entity.setpos(Horse, (x, actual_y + 3, z))
              Horse['Variant'] = nbt.TAG_Int(random.choice([0]))
              world.addEntity(Horse)
          else:
              # add rabbit
              Rabbit = Entity.Create('Rabbit')
              Entity.setpos(Rabbit, (x, actual_y + 3, z))
              Rabbit['Variant'] = nbt.TAG_Int(random.choice([0]))
              world.addEntity(Rabbit)
  # add snow
  elif my_id == 78:
    world.setBlockAt(x, elev + 1, z, m.SnowLayer.ID)
    
xall = range(len(elevation))
zall = range(len(elevation[0]))

[buildWorld(x,z) for x in xall for z in zall]
 
setspawnandsave(world, peak, tf)
