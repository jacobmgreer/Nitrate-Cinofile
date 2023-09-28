required <- c("tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)
options(dplyr.summarise.inform = FALSE)

formatted <-
  read_csv("~/Github/Media-Consumption/ratings/formatted.csv") #%>% select(-c(Your.Rating, Date.Rated, IMDb.Rating, Num.Votes, AFI, Theater, Service))

## load all lists
lists <-
  list.files(path = "input/film-lists", pattern = '.csv$', full.names = T) %>%
  setNames(., make.names(sub("\\.csv$", "", basename(.)))) %>%
  map(read_csv)

list.crossover <- Map(cbind, lists, list = names(lists))

for (list in names(lists)) {
  lists[[list]] <-
    rename_with(
      lists[[list]], ~
        case_when(
          . == "FilmID" ~ "Const",
          TRUE ~ .)) %>%
    mutate(
      new_col_one=3,
      new_col_two=4)

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

# missing <-
#   anti_join(combined, formatted, by="Const") %T>%
#   write.csv(., "missing.csv", row.names = FALSE)
#
# not.listed <-
#   anti_join(formatted, combined, by="Const") %>%
#   filter(is.na(Your.Rating)) %>%
#   select(Const, Year, Title, Title.Type, IMDb.Rating, everything()) %>%
#   arrange(Year)

rm(required, list)
