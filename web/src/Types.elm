module Types exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)


type alias Model =
    { anchors : Dict Int Point
    , anchorOrder : List Int
    , route : Maybe Route
    , page : UrlRoute
    , host : String
    , menu : RatingsInterfaceState
    , user : Maybe User
    , token : Maybe String
    }


type UrlRoute
    = LoginPage
    | MainPage
    | AccountPage


type alias User =
    { id : String
    , firstName : String
    , lastName : String
    , email : String
    , birthdate : Maybe Date
    , sex : Maybe String
    , stravaToken : String
    , createdAt : Date
    , updatedAt : Date
    }


type alias RatingsInterfaceState =
    { drawingSegment : Bool
    , name : String
    , description : String
    , surfaceRating : Int
    , trafficRating : Int
    , surface : SurfaceType
    , pathType : PathType
    }


type alias Route =
    { distance : Float
    , polyline : String
    }


type alias Point =
    { lat : Float
    , lng : Float
    }


type SurfaceType
    = Gravel
    | Asphalt
    | Dirt


type PathType
    = Shared
    | DedicatedLane
    | BikePath


type alias Segment =
    { id : String
    , name : String
    , description : String
    , start : Point
    , end : Point
    , polyline : String
    , rating : Float
    }


type alias CreateSegmentForm =
    { name : String
    , description : String
    , polyline : String
    , surfaceRating : Int
    , trafficRating : Int
    , surface : SurfaceType
    , pathType : PathType
    }
