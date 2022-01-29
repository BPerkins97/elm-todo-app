module Main exposing (..)

import Browser
import Element exposing (table, text, layout, fill, el, column)
import Element.Input as Input
import Html exposing (Html)
import Element.Input as Input
import List exposing (..)
import Time

main = Browser.element { init = init, update = update, view = view, subscriptions = subscriptions}

type alias Model = {
        toDos: List ToDo,
        currentlyWrittenToDo: ToDo
    }
type alias ToDo = {
        name: String,
        dueDate: Maybe String
    }

type Msg = WritingToDo String | AddedToDo | WritingDate String

init : () -> (Model, Cmd Msg)
init _ = (
        {
            toDos = [],
            currentlyWrittenToDo = {
                name = "",
                dueDate = Nothing
            }
        },
        Cmd.none
    )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

update : Msg -> Model -> (Model, Cmd Msg) 
update msg model =
  case msg of
    WritingToDo str ->
      ({ model | currentlyWrittenToDo = {
          name = str,
          dueDate = model.currentlyWrittenToDo.dueDate
      } }, Cmd.none)
    AddedToDo ->
        let 
            newModel = { model | toDos = {name = model.currentlyWrittenToDo.name, dueDate = model.currentlyWrittenToDo.dueDate} :: model.toDos }
        in
            (
                { newModel | currentlyWrittenToDo = {name = "", dueDate = Nothing} },
                Cmd.none
            )
    WritingDate str ->
        ({ model | currentlyWrittenToDo = {
            name = model.currentlyWrittenToDo.name,
            dueDate = Just str
        } }, Cmd.none)
    

view : Model -> Html Msg
view model = 
  layout [] (
      column [] [
        el [] (
            table [] {
                data = model.toDos,
                columns = [
                    {
                        header = text "ToDo",
                        width = fill,
                        view = \toDo -> text toDo.name
                    },
                    {
                        header = text "Fällig um",
                        width = fill,
                        view = \toDo -> text (viewMaybeDate toDo.dueDate)
                    }
                ]
            }
        ),
        el [] (
            Input.text [] {
                onChange = WritingToDo,
                text = model.currentlyWrittenToDo.name,
                placeholder = Nothing,
                label = (
                    Input.labelLeft [] (
                        text "Neues ToDo"
                    )
                )
            }
        ),
        el [] (
            Input.text [] {
                onChange = WritingDate,
                text = (viewMaybeDate model.currentlyWrittenToDo.dueDate),
                placeholder = Nothing,
                label = (
                    Input.labelLeft [] (
                        text "Fällig am"
                    )
                )
            }
        ),
        Input.button [] {
            onPress = Just AddedToDo,
            label = (
                text "Hinzufügen"
            )
        }
      ]
    )

viewMaybeDate : Maybe String -> String
viewMaybeDate maybe = 
    case maybe of
        Just date ->
            date
        Nothing -> 
            ""