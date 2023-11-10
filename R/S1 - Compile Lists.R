required <- c("tidyverse", "magrittr", "readr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

formatted <- read_csv("~/Github/Nitrate-Actions/ratings/formatted.csv")

## load all lists
lists <-
  list.files(path = "~/Github/Nitrate-Actions/raw-lists", pattern = '.csv$', full.names = T) %>%
  setNames(., make.names(sub("\\.csv$", "", basename(.)))) %>%
  map(read_csv)

list.crossover <- Map(cbind, lists, list = names(lists))

for (list in names(lists)) {
  lists[[list]] <-
    rename_with(
      lists[[list]], ~
        case_when(
          . == "FilmID" ~ "Const",
          TRUE ~ .))

  list.crossover[[list]] <-
    rename_with(
      list.crossover[[list]], ~
        case_when(
          . == "FilmID" ~ "Const",
          . == "imdb" ~ "Const",
          TRUE ~ .)) %>%
    select(Const, list)
}

list.crossover <-
  bind_rows(list.crossover) %>%
  filter(!is.na(Const)) %>%
  distinct(Const, list) %>%
  mutate(n=1) %>%
  pivot_wider(names_from = list, values_from = n, values_fill = 0) %>%
  mutate(sum = rowSums(across(where(is.numeric)))) %>%
  select(sum, everything()) %>%
  arrange(desc(sum))

## seperate all lists into dataframes (only meant for review)
#list2env(lists,envir=.GlobalEnv)

not.listed <-
  anti_join(formatted, list.crossover, by="Const") %>%
  #filter(is.na(Your.Rating)) %>%
  select(Const, Year, Title, Title.Type, IMDb.Rating, everything()) %>%
  arrange(Year) %T>%
  write.csv(., "output/not.listed.csv", row.names = FALSE)

## FOR IMDB
for.imdb.list <-
  list.crossover %>%
  anti_join(., formatted, by="Const") %T>%
  write.csv(., "output/add.to.imdb.csv", row.names = FALSE)

rm(required, list)
