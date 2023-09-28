SELECT ?item ?ia
WHERE
{
  ?item wdt:P724 ?ia .
  VALUES ?item {
    %s
  }
}
