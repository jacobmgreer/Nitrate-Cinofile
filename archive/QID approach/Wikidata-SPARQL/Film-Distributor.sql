SELECT ?item ?distid ?distributor
WHERE
{
  ?item wdt:P750 ?distid .
  ?distid rdfs:label ?distributor .
  FILTER(LANG(?distributor) = "en") .
  VALUES ?item {
    %s
  }
}
