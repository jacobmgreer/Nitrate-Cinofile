required <- c("tidyverse", "magrittr", "WikidataQueryServiceR")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

formatted2 <-
  read_csv("../Nitrate-Actions/ratings/formatted.csv") %>%
  distinct(Const) %>%
  mutate(query_grouping = as.integer(gl(n(), 300, n())))

Film.Basics <- Film.Genres <- Film.MediaType <- Film.Distributor <- NULL
Film.Language <- Film.Origin <- Film.Production <- Film.IA <- NULL

for (i in unique(formatted2$query_grouping)) {
  subset <- formatted2 %>% filter(query_grouping == i)
  subset <- subset$Const%>% paste(collapse = "' '") %>% paste0("'", ., "'")

  Film.Basics <-
    bind_rows(Film.Basics,
              query_wikidata(sprintf(read_file('SPARQL/Film-Basics.sparql'), subset)))
  Film.Genres <-
    bind_rows(Film.Genres,
              query_wikidata(sprintf(read_file('SPARQL/Film-Genres.sparql'), subset)))
  Film.MediaType <-
    bind_rows(Film.MediaType,
              query_wikidata(sprintf(read_file('SPARQL/Film-MediaType.sparql'), subset)))
  Film.Distributor <-
    bind_rows(Film.Distributor,
              query_wikidata(sprintf(read_file('SPARQL/Film-Distributor.sparql'), subset)))
  Film.Language <-
    bind_rows(Film.Language,
              query_wikidata(sprintf(read_file('SPARQL/Film-Language.sparql'), subset)))
  Film.Origin <-
    bind_rows(Film.Origin,
              query_wikidata(sprintf(read_file('SPARQL/Film-Origin.sparql'), subset)))
  Film.Production <-
    bind_rows(Film.Production,
              query_wikidata(sprintf(read_file('SPARQL/Film-Production.sparql'), subset)))
  Film.IA <-
    bind_rows(Film.IA,
              query_wikidata(sprintf(read_file('SPARQL/Film-IA.sparql'), subset)))

  message(paste("Grouping", i, "of", length(unique(formatted2$query_grouping))))}

write.csv(Film.Basics, file = "output/SPARQL/Film.Basics.csv", row.names = FALSE)
write.csv(Film.Distributor, file = "output/SPARQL/Film.Distributor.csv", row.names = FALSE)
write.csv(Film.Genres, file = "output/SPARQL/Film.Genres.csv", row.names = FALSE)
write.csv(Film.IA, file = "output/SPARQL/Film.IA.csv", row.names = FALSE)
write.csv(Film.Language, file = "output/SPARQL/Film.Language.csv", row.names = FALSE)
write.csv(Film.MediaType, file = "output/SPARQL/Film.MediaType.csv", row.names = FALSE)
write.csv(Film.Origin, file = "output/SPARQL/Film.Origin.csv", row.names = FALSE)
write.csv(Film.Production, file = "output/SPARQL/Film.Production.csv", row.names = FALSE)

rm(required, i, subset, formatted2)
rm(list=ls(pattern="^Film."))
