required <- c("tidyverse", "magrittr", "naniar", "UpSetR", "ggthemes", "readr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

Film.Basics <-
  read_csv("output/SPARQL/Film.Basics.csv") %>%
  mutate(QID = basename(item)) %>%
  distinct(QID, .keep_all = TRUE)

Film.Distributor <-
  read_csv("output/SPARQL/Film.Distributor.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    distIDs = str_c(basename(distid), collapse = ","),
    distributors = str_c(str_c('"', distributor, '"'), collapse = ","))

Film.Genres <-
  read_csv("output/SPARQL/Film.Genres.csv") %>%
  filter(!is.na(genre_id)) %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    genreIDs = str_c(basename(genre_id), collapse = ","),
    genres = str_c(str_c('"', genre, '"'), collapse = ","))

Film.IA <-
  read_csv("output/SPARQL/Film.IA.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    ia = str_c(str_c('"', ia, '"'), collapse = ","))

Film.Language <-
  read_csv("output/SPARQL/Film.Language.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    langIDs = str_c(basename(langid), collapse = ","),
    languages = str_c(str_c('"', language, '"'), collapse = ","))

Film.MediaType <-
  read_csv("output/SPARQL/Film.MediaType.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    mediaIDs = str_c(basename(mediaid), collapse = ","),
    mediatypes = str_c(str_c('"', mediatype, '"'), collapse = ","))

Film.Origin <-
  read_csv("output/SPARQL/Film.Origin.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    originIDs = str_c(basename(originid), collapse = ","),
    origins = str_c(str_c('"', origin, '"'), collapse = ","))

Film.Production <-
  read_csv("output/SPARQL/Film.Production.csv") %>%
  mutate(QID = basename(item)) %>%
  group_by(QID) %>%
  reframe(
    prodIDs = str_c(basename(prodid), collapse = ","),
    production = str_c(str_c('"', production, '"'), collapse = ","))

watchlist.dataset <-
  read_csv("../Nitrate-Actions/ratings/formatted.csv") %>%
  left_join(., Film.Basics, by=c("Const" = "imdb"), relationship = "many-to-many") %>%
  left_join(., Film.Distributor, by="QID") %>%
  left_join(., Film.Genres, by="QID") %>%
  left_join(., Film.IA, by="QID") %>%
  left_join(., Film.Language, by="QID") %>%
  left_join(., Film.MediaType, by="QID") %>%
  left_join(., Film.Origin, by="QID") %>%
  left_join(., Film.Production, by="QID") %>%
  select(QID, Const, everything()) %T>%
  write.csv(., file = "output/dataset.csv", row.names = FALSE)

missing.QID <- watchlist.dataset %>% filter(is.na(QID))
duplicate.QID <- watchlist.dataset %>% count(QID) %>% filter(n > 1)
duplicate.imdb <- watchlist.dataset %>% count(Const) %>% filter(n > 1)

gg_miss_fct(x = watchlist.dataset %>% select(c(Const, Year, QID, genres, languages, mediatypes, origins, production, distributors)),
            fct = Year) +
  labs(title = "NA in Wikidata of Major Film History") +
  theme_fivethirtyeight()
ggsave("output/Missing.Wikidata.png", width=12, height=5)

# missingWD <- S6.Output %>%
#   filter(list_AMPAS.Awards == 1) %>%
#   filter(is.na(languages)) %>%
#   select(QID, Const, Title, production, distributors, languages, origins)

rm(required)
rm(list=ls(pattern="^Film."))
