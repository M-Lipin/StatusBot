{-# LANGUAGE RecordWildCards #-}
-- | Inner module. Defines Status Handle and data types for
-- making http calls to given adress.
module Status.Handle
    ( Handle(..)
    , ServerAdress(..)
    , ServerStatus(..)
    ) where

import Data.ByteString (ByteString)
import Data.Text (Text)

import qualified Data.Text.Encoding as T

import PrettyPrint
import Utils ((.<))

import qualified Logger

-- | Handle to inject imlementation into logic.
data Handle m = Handle
   { hLogger :: Logger.Handle m
   -- ^ Injected logger handle.
   , hGetStatus :: ServerAdress -> m ServerStatus
   -- ^ Provides status of given adress.
   }

-- | Input data for status calls.
data ServerAdress = ServerAdress
   { _host :: ByteString
   -- ^ IP/site.
   , _port :: Int
   -- ^ Could be any port.
   } deriving (Show)

instance PrettyPrint ServerAdress where
   prettyPrint ServerAdress{..} = (T.decodeUtf8 _host)

-- | Output data for status calls.
data ServerStatus
   = Online
   | NotAvaible Text
   -- ^ Status code/or error message
   deriving (Show, Eq)

instance PrettyPrint ServerStatus where
   prettyPrint (Online) = "online"
   prettyPrint (NotAvaible status_code) = "not avaible " .< status_code