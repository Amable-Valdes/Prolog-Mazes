#!/usr/bin/env python
# coding: utf-8

# # Mazes Manipulation Script
# 
# Authors: https://github.com/Amable-Valdes/Prolog-Mazes
# copyright 2019 Amable José Valdés Cuervo and Sergio Florez

"""
Imports

We use openCV for the manipulation 
of images and numpy to treat 
the matrices.
"""
import numpy as np
import cv2

"""
Constants

They represent the diferent 
elements we can find in a maze.
"""
END = 3
START = 2
WALL = 0
EMPTY = 1


""" 

Prolog rules creation 

"""

def translate(vectorRGB):
    """
    RGB translator.

    This function translate a numpy array of 3 positions 
    (Red, Greens and Blues) and decide if the vector is 
    a wall, an empty space, the start or the end of a maze.

    Parameters
    ----------
    vectorRGB : numpyArray of int[3]
        An array with 3 positions (Red, Greens and Blues) 
        with the color coded as a value between 0 and 255 
        on the RGB scale

    Returns
    -------
    int
        The simbol we are using to identify a element of 
        the maze; a wall, an empty space, the start or the end.
    """
    
    if(vectorRGB[0] > 150 and vectorRGB[1] > 150 and vectorRGB[2] > 150):
        # If white, empty
        return EMPTY
    if(vectorRGB[0] < 150 and vectorRGB[1] > 150 and vectorRGB[2] < 150):
        # If green, end
        return END
    if(vectorRGB[0] < 150 and vectorRGB[1] < 150 and vectorRGB[2] > 150):
        # If blue, start
        return START
    if(vectorRGB[0] == 0 and vectorRGB[1] == 0 and vectorRGB[2] == 0):
        # If black, wall
        return WALL
    # If is different from above (an strange value), wall
    return WALL

def initial_state(maze):
    """
    Initial position rule

    This function search in a conceptual maze the position 
    where we will start our steps to solve the maze and 
    returns a string with the fact that it would 
    indicate the initial position written in prolog.

    Parameters
    ----------
    maze : numpyArray of int[][]
        The conceptual maze where we are looking 
        the start point.

    Returns
    -------
    str
        The fact that it would indicate the 
        initial position written in prolog.
    """
    for i,row in enumerate(maze):
        for j,value in enumerate(row):
            if(value == START):
                return ("initial_state(  maze, p(%i,%i)  )."%(i,j) )
            
def final_state(maze):
    """
    End position rule

    This function search in a conceptual maze the position 
    where we will stop to solve the maze and 
    returns a string with the fact that it would 
    indicate the final position written in prolog.

    Parameters
    ----------
    maze : numpyArray of int[][]
        The conceptual maze where we are looking 
        the end point.

    Returns
    -------
    str
        The fact that it would indicate the 
        final position written in prolog.
    """
    for i,row in enumerate(maze):
        for j,value in enumerate(row):
            if(value == END):
                return ("final_state(  maze, p(%d,%d)  )."%(i,j) )

def translate_image_to_maze(img):
    """
    Image to matrix translator

    This function takes a cv2 image and translate it
    to a int matrix .

    Parameters
    ----------
    img : numpyArray[][] of numpyArray[3]
        The image with the RGB vectors that we are reading
        and we will translate to a conceptual maze.

    Returns
    -------
    numpyArray of int[][]
        The conceptual maze where we are looking 
        the start point.
    """
    # Maze size == Image size
    width, height = img.shape[:2]
    # At the begining, our maze is a matrix of all ones
    maze = np.ones([width,height])

    # We iterate in the rows and columns
    for i,row in enumerate(img):
        for j,pixel in enumerate(row):
            # We translate the RGB vector of a pixel to
            # a simbolic element (wall, empty space...)
            # of our maze
            label = translate(pixel)
            maze[i][j] = float(label)
    return maze

def translate_image_into_rules(img_path, rules=False):
    """
    Image to rule translator

    This function takes an image path and generate a cv2 
    image. After that we create a conceptual maze and with
    that maze we generate the rules or facts written in prolog.
    
    This function write a .pl file with all the 
    facts or rules for the prolog program saved in 
    the same repositore where this program has been download:
    https://github.com/Amable-Valdes/Prolog-Mazes
    
    We also print all the rules or facts written in 
    the file on the console.

    Parameters
    ----------
    img_path : str
        The str path where the maze image is. This 
        image must have one (or more) red pixel (start), 
        black pixels (walls), white pixels (empty spaces)
        and one (or more) green pixel (end).
    """
    
    print("New rules for maze " + img_path)
    
    #We read the image
    img = cv2.imread(img_path)
    # We translate the image to a conceptual maze
    maze = translate_image_to_maze(img)
    # We create the .pl file where the rules or 
    # facts will be written
    file = open(img_path.split('.')[0] + ".pl","w") 

    # We write the initial state rule (start)
    line = initial_state(maze)
    file.write(line) 
    file.write("\n")
    print(line)
    print()
    
    # We write the final state rule (end)
    line = final_state(maze)
    file.write(line)
    file.write("\n")
    print(line)
    print()
    
    if rules:
        line = ("c(X, Y, wall) :-\n" )
        file.write(line)
        print(line)
        
    # We iterate in every matrix[i][j] 
    # (the maze) value and if it's a 
    # wall we write a fact or rule with the 
    # wall position.
    for i,row in enumerate(maze):
        for j,value in enumerate(row):
            if(value == WALL):
                if rules:
                    line = ("\tX = %d, Y = %d\n\t;\n"%(i,j) )
                    file.write(line)
                else:
                    line = ("c(%d,%d,wall).\n"%(i,j) )
                    file.write(line)
                print(line)

    if rules:
        width, height = img.shape[:2]
        line = ("\tX > %d; Y > %d."%(width, height) )
        file.write(line)
        print(line)
                
    file.close()
    
    print("New rules for maze in file " + img_path.split('.')[0] + ".pl")
    
    
""" 
    Image with steps creation 
"""

def translate_step(step):
    """
    Translate the order to a conceptual step

    This function takes the order pased as parameter 
    and translates it to an array with dimension 2 
    that is the conceptual step. This conceptual step
    will be added to the actual position in the 
    conceptual maze, simulating a movement.

    Parameters
    ----------
    step : str
        The str that represent the step. This can 
        be "UP", "DOWN", "LEFT" or "RIGHT".

    Returns
    -------
    array[2]
        An array with dimension 2 that represent the
        movement in coordenades in a conceptual maze.
    """
    if(step == "UP"):
        return [-1,0]
    if(step == "DOWN"):
        return [1,0]
    if(step == "LEFT"):
        return [0,-1]
    if(step == "RIGHT"):
        return [0,+1]
    
def start_point(maze):
    """
    Look for the start point

    This function look in the conceptual maze 
    for the start point.

    Parameters
    ----------
    maze : numpyArray of int[][]
        The conceptual maze where we are looking 
        the start point.

    Returns
    -------
    int[2]
        An array with dimension 2 that represent 
        the coordenade where the start point is.
    """
    for i,row in enumerate(maze):
        for j,value in enumerate(row):
            if(value == START):
                return [i,j]
    
def draw_path_on_maze(original_image_path,steps):
    """
    Drawer of steps in a maze

    This function takes the image of a maze and 
    an array of steps to solve the maze. After 
    the translation of this information it 
    draws in a new image the path in 
    purple to solve the maze.
    
    The new image is saved in the same path 
    of the image passed as parameter with 
    the original image name plus "-steps.png".

    Parameters
    ----------
    original_image_path : str
        The string path where the maze image is. This 
        image must have one (or more) red pixel (start), 
        black pixels (walls), white pixels (empty spaces)
        and one (or more) green pixel (end).
        
    steps : array of str
        An array of strings that represent the 
        correct path to solve the maze.
    """
    
    # Read the original image.
    img = cv2.imread(original_image_path)
    # Translate the image to a conceptual maze.
    maze = translate_image_to_maze(img)
    # We look the start point.
    actual_point = start_point(maze)
    
    # For all the steps we have passed as parameter 
    # (except the last, that is the final position) ...
    for step in steps[:-1]:
        # ... we change our position adding the value of 
        # the conceptual step to the actual position ...
        movement = translate_step(step)
        actual_point[0] = actual_point[0] + movement[0]
        actual_point[1] = actual_point[1] + movement[1]
        
        # ... and we change the color of that position 
        # in the image to purple.
        img[actual_point[0]][actual_point[1]][0] = 197
        img[actual_point[0]][actual_point[1]][1] = 75
        img[actual_point[0]][actual_point[1]][2] = 140

    # We draw the new image and we saved it.
    cv2.imwrite(original_image_path.split('.')[0] + '-steps.png', img)
    print("New image " + original_image_path.split('.')[0] + "-steps.png created!")

