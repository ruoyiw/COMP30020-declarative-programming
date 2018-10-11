#! /bin/bash
ghc -O2 --make MusicMindTest
./runMusicMindTest.sh | grep "You got it" > result.txt
ruby calAvg.rb