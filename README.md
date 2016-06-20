# The Memory Game

The game will work by taking a collection of images and randomly applying them to the game tiles. At the start of the game, all tiles display images of question marks.

A user plays the game by subsequently tapping tiles. When a user taps a tile its image is revealed. When the user taps a second tile its image is also revealed, but this time for 1 second only. After 1 second has elapsed one of two things can happen 
1. If it’s a match, both tiles vanish, or 
2. If it’s a mismatch, both tiles return to displaying images of question marks.

The game will include a scoring mechanism. A match adds 200 points to the score. A mismatch reduces the score by 100 points.

The user continues to attempt to match tiles until there are no tiles left, at which point the game ends and the score is presented to the user in an alert view.
