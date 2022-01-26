module Main exposing (..)

import Browser
import Html exposing (Html, table, tr, td, tbody, thead, text, button, input, div, br, caption)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (..)

main = Browser.sandbox { init = init, update = update, view = view }

type alias Model = {
        toDos: List ToDo,
        toDoThatIsCurrentlyWritten: String
    }
type alias ToDo = {
        name: String
    }

type Msg = WritingToDo String | AddedToDo

init : Model
init = {
        toDos = [],
        toDoThatIsCurrentlyWritten = ""
    }

update : Msg -> Model -> Model 
update msg model =
  case msg of
    WritingToDo str ->
      { model | toDoThatIsCurrentlyWritten = str }
    AddedToDo ->
        let 
            newModel = { model | toDos = {name = model.toDoThatIsCurrentlyWritten} :: model.toDos }
        in
            { newModel | toDoThatIsCurrentlyWritten = "" }
    

view : Model -> Html Msg
view model =
  
  div [] [
      table [] [
        caption [] [
            text "ToDos"
        ],
        thead [] [
            td [] [
                text "ToDo"
            ]
        ],
        tbody [] (List.map viewToDoAsRow model.toDos)
    ],
    div [] [
        input [type_ "text", onInput WritingToDo, value model.toDoThatIsCurrentlyWritten] [],
        br [] [],
        button [onClick AddedToDo] [
            text "Hinzufügen"
        ] 
    ]
  ]

viewToDoAsRow : ToDo -> Html Msg
viewToDoAsRow toDo = 
    tr [] [
        td [] [
            text toDo.name
        ]
    ]