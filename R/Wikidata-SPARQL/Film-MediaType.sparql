SELECT ?item ?imdb ?mediaid ?mediatype
WHERE
{
  ?item wdt:P345 ?imdb.
  ?item wdt:P31 ?mediaid .
  ?mediaid rdfs:label ?mediatype .
  FILTER (LANG(?mediatype) = 'en') .
  VALUES ?imdb {
    %s
  }
}
