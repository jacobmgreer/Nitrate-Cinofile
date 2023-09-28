SELECT ?item ?imdb ?originid ?origin
WHERE
{
  ?item wdt:P345 ?imdb.
  ?item wdt:P495 ?originid .
  ?originid rdfs:label ?origin .
  FILTER(LANG(?origin) = "en") .
  VALUES ?imdb {
    %s
  }
}
