library(WikidataQueryServiceR)
library(tidyverse)
library(jsonlite)
library(magrittr)
library(glue)

options(readr.show_col_types = FALSE)

s <- combined$Const %>% paste(collapse = "' '") %>% paste0("'", ., "'")

cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Basics.sql'), s), file="output/SPARQL-queries/Film-Basics.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Genres.sql'), s), file="output/SPARQL-queries/Film-Genres.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-MediaType.sql'), s), file="output/SPARQL-queries/Film-MediaType.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Distributor.sql'), s), file="output/SPARQL-queries/Film-Distributor.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Language.sql'), s), file="output/SPARQL-queries/Film-Language.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Origin.sql'), s), file="output/SPARQL-queries/Film-Origin.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Production.sql'), s), file="output/SPARQL-queries/Film-Production.sql")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-IA.sql'), s), file="output/SPARQL-queries/Film-IA.sql")

rm(s, formatted)
