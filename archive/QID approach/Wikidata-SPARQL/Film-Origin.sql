SELECT ?item ?originid ?origin
WHERE
{
  ?item wdt:P495 ?originid .
  ?originid rdfs:label ?origin .
  FILTER(LANG(?origin) = "en") .
  VALUES ?item {
    %s
  }
}
