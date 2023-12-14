SELECT ?item ?imdb ?genre_id ?genre
WHERE
{
  ?item wdt:P345 ?imdb.
  ?item wdt:P136 ?genre_id .
  ?genre_id rdfs:label ?genre .
  FILTER (LANG(?genre) = "en") .
  VALUES ?imdb {
    %s
  }
}
