SELECT ?item ?imdb ?prodid ?production
WHERE
{
  ?item wdt:P345 ?imdb.
  ?item wdt:P272 ?prodid .
  ?prodid rdfs:label ?production .
  FILTER(LANG(?production) = "en") .
  VALUES ?imdb {
    %s
  }
}
