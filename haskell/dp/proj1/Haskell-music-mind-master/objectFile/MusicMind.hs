
-- @author: Albert Wang
-- @ID    : 331793

module MusicMind 
(initialGuess
,nextGuess
,GameState
,testMethod
,allCombinations
) where

-- |Debugging packages
--import Debug.Trace
import Data.List
	
-- |fst GameState is a list of all previous guesses.snd GameState is the result of previous guess.	
-- type GameState = ( [[String]] , (Int,Int,Int)) 	
type GameState = [[String]]

-- |Initial guess is chosen by the developer.	

initialGuess :: ([String],GameState)
initialGuess = (["A1","B2","C3"],targetsList)
           where targetsList = allCombinations ["A","B","C","D","E","F","G"] (1,2,3)


-- |FIX ME: Change the newGuess object.
-- Result cannot be (3,0,0), since if successfully guessed the target, then this method will not be called.
nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)
--nextGuess record result | trace ("-- Debug: nextGuess' " ++ show record ++ " " ++ show result) False = undefined
nextGuess record result = (newGuess, newGameState) 
           where newGuess = last newGameState  --FIX ME: use a smart function instead of just using head function.
                 newGameState = updateGameState record result

-- |Helper functions. |Private
 
-- | Get all the 1330 possible targets.
allCombinations:: [String] -> (Int,Int,Int) -> [[String]]
--allCombinations strList intTuple | trace ("-- Debug: allCominations " ++ show strList ++ " " ++ show intTuple) False = undefined
allCombinations strList intTuple = removeDuplicates combinations           
         where intList = (first intTuple):(second intTuple):(third intTuple):[]
               first (x,_,_) = x
               second(_,y,_) = y
               third (_,_,z) = z               
               tempList = [ (x ++ (show n))| x <- strList,n <- intList]
               combinations =  [a:b:c:[] | a<-tempList,b<-tempList,c<-tempList, a/=b,b/=c, a/=c ]

-- | Remove duplicate targets.For example ["A1","B2","C3"] and  ["A1","C3","B2"] 
removeDuplicates :: [[String]] ->[[String]]
-- removeDuplicates originalList | trace ("--Debug: removeDuplicates: " ++ show originalList) False = undefined
removeDuplicates [] = []
removeDuplicates originalList = if any ( `elem`  (permutations.head) originalList)  (tail originalList)   
                                  then (removeDuplicates.tail) originalList
                                  else  (head originalList):((removeDuplicates.tail) originalList)



-- | Remove those targets that are inconsistent with the result from the targets list.
-- Input GameState and result, output a new GameState.
updateGameState:: ([String],GameState) -> (Int,Int,Int) -> GameState
--updateGameState record result | trace ("-- Debug: nextGuess' " ++ show record ++ " " ++ show result) False = undefined
updateGameState ([_,_,_],[]) (_,_,_) = []
updateGameState record result = if checkConsistency (fst record) ((head.snd) record) result  
                                   then ((head.snd) record):(updateGameState (fst record,(tail.snd) record) result)
 	                               else updateGameState (fst record,(tail.snd) record) result
	
-- | If a given element in the possible targets list is consistent with the result,then return True.
checkConsistency:: [String] -> [String] -> (Int,Int,Int) -> Bool
checkConsistency lastGuess element lastResult = if (pitch,note,oct) == lastResult then True else False
	           where pitch = 3 - (length  distinctElement)
	                 note  = (length  distinctElement) - (length  ([head x | x<-distinctElement]\\[head y| y<-distinctLastResult ] ))
	                 oct   = (length  distinctElement) - (length  ([last x | x<-distinctElement]\\[last y| y<-distinctLastResult ]))
	                 distinctElement    = element\\lastGuess
	                 distinctLastResult = lastGuess\\element
                      


 	
		
		



testMethod::IO ()
testMethod = putStrLn $ (fst initialGuess) !! 0 ++ (fst initialGuess) !! 1 ++ (fst initialGuess) !! 2 


--nextGuess :: ([String],GameState) -> (Int,Int,Int) -> ([String],GameState)	


