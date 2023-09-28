SELECT ?item ?genre_id ?genre
WHERE
{
  ?item wdt:P136 ?genre_id .
  ?genre_id rdfs:label ?genre .
  FILTER (LANG(?genre) = "en") .
  VALUES ?item {
    %s
  }
}
