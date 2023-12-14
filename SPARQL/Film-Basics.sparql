SELECT ?item ?imdb ?itemLabel ?itemDescription ?article
WHERE
{
  ?item wdt:P345 ?imdb .
  OPTIONAL {
    ?article schema:about ?item ;
             schema:isPartOf <https://en.wikipedia.org/> .
  }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en" . }
  VALUES ?imdb {
    %s
  }
}
