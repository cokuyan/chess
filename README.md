Chess
---------

This is the game Chess programmed in Ruby 2.1.2, during my time at App Academy. The game implements all rules of chess other than stalemate due to repeated similar moves. If you find any bugs, do let me know. My contact info is at the bottom.

### How to Play
+ This game follows the standard rules of chess. You can check out the Wikipedia page [here][chess wiki].
+ Running the chess.rb file will automatically start a game with two human players if no saved game is loaded.
+ To select and move pieces, this game accepts algebraic notation (eg: g5) as input. Do not use shorthand algebraic notation since the parser does not understand it. I may implement this in the future.
+ To save a game, simply enter 'save' when prompted.
+ To quit a game, simply enter 'quit' when prompted.
+ Enjoy!

#### Known Bugs
+ While implementing a computer AI, the game would raise a NoMethodError after a good number of moves. This may occur with two human players as well, once they are far enough into the game. If this happens, please let me know since I am still unsure of why this bug is occurring.
+ There is also another potential bug with pawns being able to jump over a piece in front of it. This one may have been corrected already though.

#### Contact
Cihangir "John" Okuyan

email: chiryoku@gmail.com

[App Academy](http://www.appacademy.io/#p-home)




[chess wiki]: http://en.wikipedia.org/wiki/Chess
