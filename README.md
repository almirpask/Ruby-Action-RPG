# About

A Action RPG Game written in Ruby using [ruby2d](http://www.ruby2d.com/) framework.

![ruby2d_action_rpg](https://user-images.githubusercontent.com/18711527/103430788-6836ac80-4ba6-11eb-95ed-532621c8acb0.gif)

## Todo

- [ ] Add walls
- [ ] Add a game over scence
- [ ] Add level to enemies and to the player
- [ ] Add enemy wander state

## Done

- Player state machine (IDLE, MOVE, EVADE, ATACK)
- Add Enemy states (IDLE, CHASE)
- Add objects and its collisions
- Add sprite sort to objects

Feel free to submit your PRs!

# Install

Clone this project.

In the project folder run the command `bundle install`

# Play

Run the command: `ruby main.rb`

# Dev options

- If you want to see all the collisions and areas used on the game make sure to set the option `SHOW_COLLISIONS=1` in the file `main.rb`

<img width="1278" alt="SHOW_COLLISIONS" src="https://user-images.githubusercontent.com/18711527/103430840-00cd2c80-4ba7-11eb-8d65-9f39762e45ee.png">

Player control:

- Move: Arrows(Up, down, left, righ)
- Atack: z
- Roll/Evade: x
