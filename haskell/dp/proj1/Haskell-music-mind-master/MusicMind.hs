
--  @author  : Albert Wang
--  @ID      : 331793
--  @Project : COMP90048 Project 1 MusicMind 

module MusicMind 
(initialGuess
,nextGuess
,GameState
,allCombinations
) where

import Data.List
		
type GameState = [[String]]

-- |  Initial guess is chosen by the developer.	
--    A GameState object is used to store all the remaining possible targets that are consistent with the feedback.
--    Initially, the GameState object is a list of all 1330 possible targets.
initialGuess :: ([String],GameState)
initialGuess = (["A1","B2","C3"],targetsList)
         where targetsList = allCombinations ["A","B","C","D","E","F","G"] (1,2,3)


-- | Based on the feedback, return a new guess and an updated GameState object.
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
nextGuess record result = (newGuess, newGameState) 
         where newGuess = last newGameState  
               newGameState = updateGameState record result

-- |  Helper functions. Private. 

-- |  Get all the 1330 possible targets.
allCombinations:: [String] -> (Int,Int,Int) -> [[String]]
allCombinations strList intTuple = rmDuplicates combinations           
         where intList = (first intTuple):(second intTuple):(third intTuple):[]
               first (x,_,_) = x
               second(_,y,_) = y
               third (_,_,z) = z               
               tempList = [ (x ++ (show n))| x <- strList,n <- intList]
               combinations =  [a:b:c:[] | a<-tempList,b<-tempList,c<-tempList, a/=b,b/=c, a/=c ]

-- |  Remove duplicate targets. 
--    For example ["A1","B2","C3"],["C3","B2","A1"] and  ["A1","C3","B2"], only one of them will be kept in the list.
rmDuplicates :: [[String]] ->[[String]]
rmDuplicates [] = []
rmDuplicates originalList = if any ( `elem`  (permutations.head) originalList)  (tail originalList)   
                                  then (rmDuplicates.tail) originalList
                                  else  (head originalList):((rmDuplicates.tail) originalList)


-- |  Remove those targets that are inconsistent with the result from the targets list.
--    Input GameState and result, output a new GameState.
updateGameState:: ([String],GameState) -> (Int,Int,Int) -> GameState
updateGameState ([_,_,_],[]) (_,_,_) = []
updateGameState record result = if checkConsistency (fst record) ((head.snd) record) result  
                                   then ((head.snd) record):(updateGameState (fst record,(tail.snd) record) result)
 	                               else updateGameState (fst record,(tail.snd) record) result

	
-- |  If a given element in the targets list is consistent with the result,then return True.
--    @para 0 : last guess. @para 1 : an element in the remaing list. @para 2: result 
checkConsistency:: [String] -> [String] -> (Int,Int,Int) -> Bool
checkConsistency lastGuess element result = if (pitch,note,oct) == result then True else False
	     where pitch = 3 - (length  diffPitchList)
	           note  = (length  diffPitchList) - (length  ([head x | x<-diffPitchList]\\[head y| y<-notYetPitchList ]))
	           oct   = (length  diffPitchList) - (length  ([last x | x<-diffPitchList]\\[last y| y<-notYetPitchList ]))
	           diffPitchList  = element\\lastGuess
	           notYetPitchList = lastGuess\\element
                      