SELECT ?item ?imdb ?langid ?language
WHERE
{
  ?item wdt:P345 ?imdb.
  ?item wdt:P364 ?langid .
  ?langid rdfs:label ?language .
  FILTER(LANG(?language) = "en") .
  VALUES ?imdb {
    %s
  }
}
