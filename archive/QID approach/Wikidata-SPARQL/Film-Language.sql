SELECT ?item ?langid ?language
WHERE
{
  ?item wdt:P364 ?langid .
  ?langid rdfs:label ?language .
  FILTER(LANG(?language) = "en") .
  VALUES ?item {
    %s
  }
}
