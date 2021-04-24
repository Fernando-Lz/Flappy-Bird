# Flappy-Bird
Videogames-Lab project intended to recreate Flappy Bird with the Love2D game engine. 
Developed by Fernando López López (@LeStringent) and Alexander Díaz Ruiz (@CrunchyBytes).

Aside from audio and visual assets, the project consists of 6 Lua files, which are documented for legibility:
- **push:** Virtual resolution handling library, responsible for the game window displayed.
- **class:** Allows for the creation of OOP "classes".
- **bird:** Manages the player's sprite, dimensions, coordinates, and collisions.
- **Pipe:** "Class" that handles obstacle's graphics, dimensions, and coordinates.
- **PipePair:** "Class" that manages Pipe objects as top and bottom pairs, their distance between one another, and whether a pair of pipes has been passed, or left the screen.
- **main:** Central file that orchestrates the instantiation of a game window, its assets, objects, and logic regarding the gameplay. To do so in an organized manner, it behaves like a state machine, in which each state updates and displays its relevant information.

## State Machine
The game's state machine takes place in the following order:
1. **Start:** The Title Screen. Displays the background and player sprites, the name of the game, and the instructions to navigate through states.
2. **Play:** The gameplay state. Forces are applied to the player, such as gravity and flight (input by the player), pipes are spawned, the player's score is continuously updated as they advance, sound effects are played, and collisions are registered.
3. **Game Over:** The background stops scrolling, the player falls to the ground and stops processing user input, and the score is saved. The program checks if a new highscore was achieved.
4. **Leaderboard:** Displays the player's score, how it compares to their highscore, and if they reached the goal.

## How to play
Use the Enter or Return key to navigate through the sequence of states. Use the spacebar to fly, and try to avoid colliding with the pipes or the ground as you advance. The more you progress, the higher your score!

