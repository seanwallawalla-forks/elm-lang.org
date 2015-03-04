import Color exposing (..)
import Dict
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (..)
import Markdown
import Touch
import Window


main : Varying Element
main =
  Varying.map2 scene
    Window.dimensions
    (Varying.map Dict.values (Signal.foldp addN Dict.empty Touch.touches))


addN : List Touch.Touch -> Dict.Dict Int (List (Int,Int)) -> Dict.Dict Int (List (Int,Int))
addN touches dict =
  foldl add1 dict touches


add1 : Touch.Touch -> Dict.Dict Int (List (Int,Int)) -> Dict.Dict Int (List (Int,Int))
add1 touch dict =
  let oldPoints = Maybe.withDefault [] (Dict.get touch.id dict)
      newPoint = (touch.x, touch.y)
  in
      Dict.insert touch.id (newPoint :: oldPoints) dict


scene : (Int,Int) -> List (List (Int,Int)) -> Element
scene (w,h) paths =
  let float (a,b) = (toFloat a, toFloat -b)
      pathForms = group (map (traced thickLine << path << map float) paths)
      picture = collage w h [ move (float (-w // 2, -h // 2)) pathForms ]
  in
      layers [ picture, message ]


thickLine : LineStyle
thickLine =
  { defaultLine |
      color <- rgba 123 123 123 0.3,
      width <- 8
  }


message : Element
message = Markdown.toElement """

<a href="/examples/Reactive/Draw.elm" target="_top">Try it fullscreen</a>
if you are on iOS or Android.

"""