#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/wikidata_query'

query = <<SPARQL
  SELECT (STRAFTER(STR(?member), STR(wd:)) AS ?item) ?name
  WHERE {
    ?member p:P39 ?ps .
    ?ps ps:P39 wd:Q21328626 ; pq:P2937 wd:Q56229998 .
    FILTER NOT EXISTS { ?ps pq:P582 ?end }

    OPTIONAL { ?ps prov:wasDerivedFrom/pr:P1810 ?sourceName }
    OPTIONAL { ?member rdfs:label ?enLabel FILTER(LANG(?enLabel) = "en") }
    BIND(COALESCE(?sourceName, ?enLabel) AS ?name)
  }
  ORDER BY ?name
SPARQL

puts EveryPoliticianScraper::WikidataQuery.new(query, 'every-politican-scrapers/monaco-conseil-national-official').csv
