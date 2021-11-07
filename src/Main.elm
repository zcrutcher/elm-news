module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, form, h1, h3, h5, img, input, label, span, text)
import Html.Attributes exposing (class, href, id, name, placeholder, src, target, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode
import WebpackAsset exposing (assetUrl)



---- MODEL ----


getArticles : String -> Cmd Msg
getArticles searchTerm =
    let
        requestHeader : List Header
        requestHeader =
            [ Http.header "x-api-key" "4sO4JEcX3HwMRR7yRvxAQAE67xRBVj__psUpcKmioNc" ]
    in
    Http.request
        { method = "GET"
        , headers = requestHeader
        , url = String.concat [ "https://api.newscatcherapi.com/v2/search?q=", searchTerm, "&lang=en" ]
        , body = Http.emptyBody
        , expect = Http.expectJson GetArticles responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


articleDecoder : Decoder Article
articleDecoder =
    succeed Article
        |> required "title" string
        |> required "published_date" string
        |> required "link" string
        |> required "clean_url" string
        |> required "excerpt" string
        |> required "summary" string
        |> optional "rights" string "unknown"
        |> required "authors" (list string)
        |> optional "media" string "noimage"


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
    , published_date : String
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
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


type Msg
    = GetArticles (Result Http.Error Response)
    | SearchTerm String
    | Fetch


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTerm searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        GetArticles (Ok res) ->
            ( { model | response = { status = res.status, total_hits = res.total_hits, total_pages = res.total_pages, page = res.page, page_size = res.page_size, articles = res.articles } }, Cmd.none )

        GetArticles (Err _) ->
            ( model, Cmd.none )

        Fetch ->
            ( { model | response = model.response }, getArticles model.searchTerm )



---- VIEW ----


searchForm : Html Msg
searchForm =
    div [ class "search-wrapper" ]
        [ form [ onSubmit Fetch, class "search-form" ]
            [ input [ type_ "text", name "search", id "search", onInput SearchTerm, placeholder "Search for topics and news", class "search" ] []
            , input [ id "search-icon", type_ "image", src (assetUrl "/assets/search-icon.png"), class "search-btn" ]
                [ input [ type_ "submit" ] []
                ]
            ]
        ]


displayArticle : Article -> Html Msg
displayArticle article =
    a [ href article.link, target "_blank", class "article-link" ]
        [ div [ class "article", class "showhim" ]
            [ span [ class "article-title" ] [ text article.title ]
            , span [ class "article-published-date" ] [ text article.published_date ]
            , img [ class "article-img", src article.media ] []
            , span [ class "article-excerpt", class "showme" ] [ text article.excerpt ]
            ]
        ]


viewArticles : List Article -> Html Msg
viewArticles articles =
    div [ class "article-wrapper" ]
        (List.map displayArticle articles)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm News Search" ]
        , searchForm

        -- , input [ type_ "text", onInput SearchTerm ] []
        -- , button [ onClick Fetch ] [ text "Search" ]
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
