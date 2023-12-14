SELECT ?item ?imdb ?distid ?distributor
WHERE
{
  ?item wdt:P345 ?imdb.
  ?item wdt:P750 ?distid .
  ?distid rdfs:label ?distributor .
  FILTER(LANG(?distributor) = "en") .
  VALUES ?imdb {
    %s
  }
}
