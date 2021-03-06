-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree. An additional grant
-- of patent rights can be found in the PATENTS file in the same directory.

{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Duckling.AmountOfMoney.EN.ZA.Rules
  ( rules
  ) where

import Data.String
import Prelude

import Duckling.AmountOfMoney.Helpers
import Duckling.AmountOfMoney.Types (Currency(..))
import Duckling.Numeral.Helpers (isPositive)
import Duckling.Types

import qualified Duckling.Numeral.Types as TNumeral


ruleAGrand :: Rule
ruleAGrand = Rule
  { name = "a grand"
  , pattern =
    [ regex "a grand"
    ]
  , prod = \_ -> Just . Token AmountOfMoney . withValue 1000
                 $ currencyOnly Dollar
  }

ruleGrand :: Rule
ruleGrand = Rule
  { name = "<amount> grand"
  , pattern =
    [ Predicate isPositive
    , regex "grand"
    ]
  , prod = \case
      (Token Numeral TNumeral.NumeralData{TNumeral.value = v}:_)
        -> Just . Token AmountOfMoney . withValue (1000 * v)
           $ currencyOnly Dollar
      _ -> Nothing
  }

rules :: [Rule]
rules =
  [ ruleAGrand
  , ruleGrand
  ]
