required <- c("tidyverse", "magrittr", "jsonlite", "qdapRegex", "httr",
              "lubridate", "rvest", "janitor", "glue", "naniar", "UpSetR", "ggthemes")
lapply(required, require, character.only = TRUE)

## RUN SPARQL queries first!! query.wikidata.org

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

Films.Basic <-
  read_csv("input/WQS-exports/Film-Basics.csv") %>%
  mutate(QID = basename(item)) %>%
  distinct(QID, .keep_all = TRUE)

Films.Distributor <-
  read_csv("input/WQS-exports/Film-Distributor.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    distIDs = str_c(basename(distid), collapse = ","),
    distributors = str_c(str_c('"', distributor, '"'), collapse = ","))

Films.Genres <-
  read_csv("input/WQS-exports/Film-Genres.csv") %>%
  filter(!is.na(genre_id)) %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    genreIDs = str_c(basename(genre_id), collapse = ","),
    genres = str_c(str_c('"', genre, '"'), collapse = ","))

Films.IA <-
  read_csv("input/WQS-exports/Film-IA.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    ia = str_c(str_c('"', ia, '"'), collapse = ","))

Films.Language <-
  read_csv("input/WQS-exports/Film-Language.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    langIDs = str_c(basename(langid), collapse = ","),
    languages = str_c(str_c('"', language, '"'), collapse = ","))

Films.MediaType <-
  read_csv("input/WQS-exports/Film-MediaType.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    mediaIDs = str_c(basename(mediaid), collapse = ","),
    mediatypes = str_c(str_c('"', mediatype, '"'), collapse = ","))

Films.Origin <-
  read_csv("input/WQS-exports/Film-Origin.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    originIDs = str_c(basename(originid), collapse = ","),
    origins = str_c(str_c('"', origin, '"'), collapse = ","))

Films.Production <-
  read_csv("input/WQS-exports/Film-Production.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    prodIDs = str_c(basename(prodid), collapse = ","),
    production = str_c(str_c('"', production, '"'), collapse = ","))

S6.Output <-
  read_csv("output/draft.combined.csv") %>%
  left_join(., Films.Basic, by=c("Const" = "imdb"), relationship = "many-to-many") %>%
  left_join(., Films.Distributor, by="QID") %>%
  left_join(., Films.Genres, by="QID") %>%
  left_join(., Films.IA, by="QID") %>%
  left_join(., Films.Language, by="QID") %>%
  left_join(., Films.MediaType, by="QID") %>%
  left_join(., Films.Origin, by="QID") %>%
  left_join(., Films.Production, by="QID") %>%
  select(QID, Const, everything()) %T>%
  write.csv(., file = "output/combined.csv", row.names = FALSE)

S6.Summary <-
  S6.Output %>%
  mutate(mediatypes = gsub(",.*$", "", mediatypes)) %>%
  group_by(mediatypes) %>%
  reframe(
    imdb.na = sum(is.na(Const)),
    label.na = sum(is.na(itemLabel)),
    desc.na = sum(is.na(itemDescription)),
    article.na = sum(is.na(article)),
    dist.na = sum(is.na(distributors)),
    genre.na = sum(is.na(genres)),
    lang.na = sum(is.na(languages)),
    mt.na = sum(is.na(mediatypes)),
    origin.na = sum(is.na(origins)),
    prod.na = sum(is.na(production))
  )

missing.QID <- S6.Output %>% filter(is.na(QID))

duplicate.QID <- S6.Output %>% count(QID) %>% filter(n > 1)
duplicate.imdb <- S6.Output %>% count(Const) %>% filter(n > 1)

gg_miss_fct(x = S6.Output %>% select(c(Const, Year, QID, genres, languages, mediatypes, origins, production, distributors)),
            fct = Year) +
  labs(title = "NA in Wikidata of Major Film History") +
  theme_fivethirtyeight()
ggsave("Wiki-Missing International Submissions.png", width=12, height=8)

missingWD <- S6.Output %>%
  filter(list_AMPAS.Awards == 1) %>%
  filter(is.na(languages)) %>%
  select(QID, Const, Title, production, distributors, languages, origins)

rm(list=ls(pattern="^Films."))
rm(required)
