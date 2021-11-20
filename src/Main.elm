module Main exposing (..)

import Browser
import Date exposing (Date, Month, day, fromCalendarDate, fromIsoString, fromPosix, month, today)
import DateFormat
import Html exposing (Html, a, button, div, form, h1, h2, h3, h5, img, input, label, p, span, text)
import Html.Attributes exposing (alt, class, datetime, href, id, name, placeholder, src, target, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Extra as Html exposing (nothing, viewIf)
import Http exposing (..)
import Iso8601 exposing (toTime)
import Json.Decode as Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import Time exposing (Month(..), Posix, millisToPosix, toMonth, toYear, utc)
import WebpackAsset exposing (assetUrl)



---- MODEL ----


getArticles : String -> Cmd Msg
getArticles searchTerm =
    Http.get
        { url = String.concat [ "/get-articles/", searchTerm ]
        , expect = Http.expectJson GetArticles responseDecoder
        }


articleDecoder : Decoder Article
articleDecoder =
    succeed Article
        |> required "title" string
        |> required "published_date" decodePublishedDate
        |> required "link" string
        |> required "clean_url" string
        |> required "excerpt" string
        |> required "summary" string
        |> optional "rights" string "unknown"
        |> required "authors" (list string)
        |> optional "media" string "noimage"


decodePublishedDate : Decoder Posix
decodePublishedDate =
    Decode.string
        |> Decode.andThen
            (\stringDate ->
                case Iso8601.toTime (String.replace " 00:00:00" "" stringDate) of
                    Ok date ->
                        Decode.succeed date

                    Err _ ->
                        Decode.fail "Decode failure"
            )


type alias PublishedDatePrecision =
    { date : String
    }


responseDecoder : Decoder Response
responseDecoder =
    succeed Response
        |> required "status" string
        |> required "total_hits" int
        |> required "page" int
        |> required "total_pages" int
        |> required "page_size" int
        |> required "articles" (list articleDecoder)


type alias Article =
    { title : String
    , published_date : Posix
    , link : String
    , clean_url : String
    , excerpt : String
    , summary : String
    , rights : String
    , authors : List String
    , media : String
    }


type alias Response =
    { status : String
    , total_hits : Int
    , page : Int
    , total_pages : Int
    , page_size : Int
    , articles : List Article
    }


type alias Model =
    { searchTerm : String
    , response : Response
    , errorMessage : String
    }


initialModel : Model
initialModel =
    { searchTerm = ""
    , response =
        { status = ""
        , total_hits = 0
        , page = 0
        , total_pages = 0
        , page_size = 0
        , articles = []
        }
    , errorMessage = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


type Msg
    = GetArticles (Result Http.Error Response)
    | SearchTerm String
    | Fetch


generateErrorMessage : Http.Error -> String
generateErrorMessage error =
    case error of
        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadUrl _ ->
            "Request failed due to bad endpoint address"

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody _ ->
            "Request returned no search results, or the response was malformed."


type alias ErrorStatus =
    { errorStatus : String }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTerm searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        GetArticles (Ok res) ->
            ( { model | response = { status = res.status, total_hits = res.total_hits, total_pages = res.total_pages, page = res.page, page_size = res.page_size, articles = res.articles } }, Cmd.none )

        GetArticles (Err err) ->
            ( { model | errorMessage = generateErrorMessage err, response = initialModel.response }, Cmd.none )

        Fetch ->
            ( { model | errorMessage = "", response = model.response }, getArticles model.searchTerm )



---- VIEW ----


toStrMonth : Time.Month -> String
toStrMonth month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"


viewDatePublished : Posix -> Html Msg
viewDatePublished date =
    let
        strMonth : Posix -> String
        strMonth d =
            Time.toMonth utc d |> toStrMonth

        strYear : Posix -> Int
        strYear d =
            Time.toYear utc d

        strDay : Posix -> Int
        strDay d =
            Time.toDay utc d
    in
    div [ class "date-display" ] [ String.concat [ strMonth date, " ", strDay date |> String.fromInt, " ", strYear date |> String.fromInt ] |> text ]


searchForm : Html Msg
searchForm =
    div [ class "search-wrapper" ]
        [ form [ onSubmit Fetch, class "search-form" ]
            [ input [ type_ "text", name "search", id "search", onInput SearchTerm, placeholder "Search for topics and news", class "search" ] []
            , input [ id "search-icon", type_ "image", src "/assets/search-icon.png", class "search-btn" ]
                [ input [ type_ "submit" ] []
                ]
            ]
        ]


displayArticle : Article -> Html Msg
displayArticle article =
    a [ href article.link, target "_blank", class "article-link" ]
        [ div [ class "card" ]
            [ div [ class "article-info" ]
                [ viewDatePublished article.published_date
                , h3 [] [ text article.title ]
                , p [] [ text article.excerpt ]
                ]
            , div [ class "card-img" ]
                [ img [ src article.media, alt article.title ] []
                ]
            ]
        ]


viewArticles : List Article -> Html Msg
viewArticles articles =
    div [ class "article-results" ]
        (List.map displayArticle articles)


displayError : String -> Html Msg
displayError message =
    h2 [ class "error-msg" ] [ text message ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm News Search" ]
        , searchForm
        , viewIf (String.length model.errorMessage > 0) (displayError model.errorMessage)
        , viewArticles model.response.articles
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
