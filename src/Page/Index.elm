module Page.Index exposing (Data, Model, Msg, page)

import Browser.Navigation
import DataSource exposing (DataSource)
import Debug exposing (toString)
import Head
import Head.Seo as Seo
import Html exposing (Html, button, div, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Shared
import Url
import View exposing (View)


type alias Model =
    { counter : Int }


type Msg
    = NoOp
    | Inc
    | Dec
    | NavigateTo String


type alias RouteParams =
    {}


page : Page.PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { view = view
            , init = \_ _ _ -> ( { counter = 0 }, Cmd.none )
            , update =
                \_ maybeNavigationKey _ _ msg model ->
                    case msg of
                        Inc ->
                            ( { model | counter = model.counter + 1 }, Cmd.none )

                        Dec ->
                            ( { model | counter = model.counter - 1 }, Cmd.none )

                        NavigateTo url ->
                            ( model
                            , maybeNavigationKey
                                |> Maybe.map
                                    (\navKey ->
                                        Browser.Navigation.pushUrl navKey url
                                    )
                                |> Maybe.withDefault Cmd.none
                            )

                        NoOp ->
                            ( model, Cmd.none )
            , subscriptions = \_ _ _ _ -> Sub.none
            }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    -- View.placeholder "Index"
    { title = "fe demo"
    , body =
        [ button [ class "m-2", onClick Inc ] [ text "inc" ]
        , div [ class "m-2" ] [ Html.text (toString model.counter) ]
        , button [ class "m-2", onClick Dec ] [ text "dec" ]
        ]
    }
