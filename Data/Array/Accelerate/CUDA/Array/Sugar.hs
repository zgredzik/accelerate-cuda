-- |
-- Module      : Data.Array.Accelerate.CUDA.Array.Sugar
-- Copyright   : [2008..2014] Manuel M T Chakravarty, Gabriele Keller
--               [2009..2014] Trevor L. McDonell
-- License     : BSD3
--
-- Maintainer  : Trevor L. McDonell <tmcdonell@cse.unsw.edu.au>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--

module Data.Array.Accelerate.CUDA.Array.Sugar (

  module Data.Array.Accelerate.Array.Sugar,
  newArray, allocateArray, useArray, useArrayAsync,

) where

import Control.Monad.Trans

import Data.Array.Accelerate.CUDA.State
import Data.Array.Accelerate.CUDA.Array.Data
import Data.Array.Accelerate.Array.Sugar                hiding (newArray, allocateArray)
import qualified Data.Array.Accelerate.Array.Sugar      as Sugar


-- Create an array from its representation function, uploading the result to the
-- device
--
newArray :: (Shape sh, Elt e) => sh -> (sh -> e) -> CIO (Array sh e)
newArray sh f =
  let arr = Sugar.newArray sh f
  in do
      useArray arr
      return arr


-- Allocate a new, uninitialised Accelerate array on host and device
--
allocateArray :: (Shape dim, Elt e) => dim -> CIO (Array dim e)
allocateArray sh = do
  arr <- liftIO $ Sugar.allocateArray sh
  mallocArray arr
  return arr

