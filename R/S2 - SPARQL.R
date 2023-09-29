library(tidyverse)
library(magrittr)
library(glue)

options(readr.show_col_types = FALSE)

s <- list.crossover$Const %>% paste(collapse = "' '") %>% paste0("'", ., "'")

cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Basics.sparql'), s), file="output/SPARQL-queries/Film-Basics.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Genres.sparql'), s), file="output/SPARQL-queries/Film-Genres.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-MediaType.sparql'), s), file="output/SPARQL-queries/Film-MediaType.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Distributor.sparql'), s), file="output/SPARQL-queries/Film-Distributor.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Language.sparql'), s), file="output/SPARQL-queries/Film-Language.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Origin.sparql'), s), file="output/SPARQL-queries/Film-Origin.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-Production.sparql'), s), file="output/SPARQL-queries/Film-Production.rq")
cat(sprintf(read_file('R/Wikidata-SPARQL/Film-IA.sparql'), s), file="output/SPARQL-queries/Film-IA.rq")

rm(s)
