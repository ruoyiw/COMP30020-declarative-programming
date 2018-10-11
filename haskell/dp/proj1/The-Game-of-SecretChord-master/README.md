Check ynarwal_Results file to see my marks in this project , to read the comment you can click on the "Raw" on the right corner of the window that will download the file.

The objective of this project is to practice and assess your understanding of functional programming and Haskell. You will write code to implement the guessing part of a a logical guessing game.

#The Game of SecretChord

SecretChord is a two-player logical guessing game created for this project. You will not find any information about the game anywhere else, but it is a simple game and this specification will tell you all you need to know.

For a SecretChord game, one player will be the composer and the other is the performer. The composer begins by selecting a three-pitch musical chord, where each pitch comprises a musical note, one of A, B, C, D, E, F, or G, and an octave, one of 1, 2, or 3. This chord will be the target for the game. The order of pitches in the target is irrelevant, and no pitch may appear more than once. This game does not include sharps or flats, and no more or less than three notes may be included in the target.

Once the composer has selected the target chord, the performer repeatedly chooses a similarly defined chord as a guess and tells it to the composer, who responds by giving the performer the following feedback:

how many pitches in the guess are included in the target (correct pitches)
how many pitches have the right note but the wrong octave (correct notes)
how many pitches have the right octave but the wrong note (correct octaves)
In counting correct notes and octaves, multiple occurrences in the guess are only counted as correct if they also appear repeatedly in the target. Correct pitches are not also counted as correct notes and octaves. For example, with a target of A1, B2, A3, a guess of A1, A2, B1 would be counted as 1 correct pitch (A1), two correct notes (A2, B1) and one correct octave (A2). B1 would not be counted as a correct octave, even though it has the same octave as the target A1, because the target A1 was already used to count the guess A1 as a correct pitch. A few more examples:

#Target  Guess Answer
A1,B2,A3  A1,A2,B1  1,2,1
A1,B2,C3  A1,A2,A3  1,0,2
A1,B1,C1  A2,D1,E1  0,1,2
A3,B2,C1  C3,A2,B1  0,3,3
The game finishes once the performer guesses the correct chord (all three pitches in the guess are in the target). The object of the game for the performer is to find the target with the fewest possible guesses.

#The Program

You will write Haskell code to implement the performer part of the game. This will require you to write a function to return your initial guess, and another to use the feedback from the previous guess to determine the next guess. The latter function will be called repeatedly until it produces the correct guess. You will find it useful to keep information between guesses; since Haskell is a purely functional language, you cannot use a global or static variable to store this. Therefore, your initial guess function must return this game state information, and your next guess function must take the game state as input and return the updated game state as output. You may put any information you like in the game state, but you must define a type GameState to hold this information. If you do not need to maintain any game state, you may simply define type GameState = ().

You may use any representation you like for notes, octaves, pitches, and chords internally, and may use this representation inside your GameState type. However, to avoid prejudicing your choice of representations, we use a very simple representation for the inputs and outputs of your functions. A chord is represented as a list of two-character strings, where the first character is an upper case letter between ’A’ and ’G’ representing the note, and the second is a digit character between ’1’ and ’3’ representing the octave.

You must define following functions:

initialGuess :: ([String],GameState)

takes no input arguments, and returns a pair of an initial guess and a game state.
nextGuess :: ([String],GameState) → (Int,Int,Int) → ([String],GameState)

takes as input a pair of the previous guess and game state, and the feedback to this guess as a triple of correct pitches, notes, and octaves, and returns a pair of the next guess and game state.
You must call your (main) source file Proj1.hs (or Proj1.lhs if you use literate Haskell), and it must contain the module declaration:

    module Proj1 (initialGuess, nextGuess, GameState) where
You may divide your code into as many files as you like, as long as your main file (and the files it imports) imports all the others. But do not feel you need to divide your program into many files if it is reasonably small.

I will post a test driver program Proj1Test.hs, which will operate similarly to how I actually test your code. I will compile and link your code for testing using the command:

    ghc -O2 --make Proj1Test
or similar. To run Proj1Test, give it the target as three separate command line arguments, for example ./Proj1Test D1 B1 G2 would search for the target ["D1", "B1", "G2"]. It will then use your Proj1 module to guess the target; the output will look something like:

Your guess 1:  ["A1","B1","C2"]
My answer:  (1,0,2)
Your guess 2:  ["A1","D1","E2"]
My answer:  (1,0,2)
Your guess 3:  ["A1","F1","G2"]
My answer:  (1,0,2)
Your guess 4:  ["B1","D1","G2"]
My answer:  (3,0,0)
You got it in 4 guesses!
Assessment

Your project will be assessed on the following criteria:

70% Quality and correctness of your implementation;
30% Quality of your code and documentation
The correctness of your implementation will be assessed based on whether it succeeds in guessing the targets it is given in the available time. Quality will be assessed based on the number of guesses needed to find the given targets. Full marks will be given for an average of 4.3 guesses per target, with marks falling on a logarithmic scale as the number of guesses rises. Thus moving from taking 5 guesses to 4 will gain similar number of points as going from 7 to 5 guesses. Therefore as the number of guesses drops, further small decreases in the number of guesses are increasingly valuable.

Note that timeouts will be imposed on all tests. You will have at least 5 seconds to guess each target, regardless of how many guesses are needed. Executions taking longer than that may be unceremoniously terminated, leading to that test being assessed as failing. Your programs will be compiled with GHC -O2 before testing, so 5 seconds per test is a very reasonable limit.


