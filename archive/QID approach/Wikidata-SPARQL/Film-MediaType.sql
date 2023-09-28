SELECT ?item ?mediaid ?mediatype
WHERE
{
  ?item wdt:P31 ?mediaid .
  ?mediaid rdfs:label ?mediatype .
  FILTER (LANG(?mediatype) = 'en') .
  VALUES ?item {
    %s
  }
}
