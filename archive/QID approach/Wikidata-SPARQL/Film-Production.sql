SELECT ?item ?prodid ?production
WHERE
{
  ?item wdt:P272 ?prodid .
  ?prodid rdfs:label ?production .
  FILTER(LANG(?production) = "en") .
  VALUES ?item {
    %s
  }
}
