#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'

# TODO: fetch data from the individual member pages
class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :id do
      url.split('/').last
    end

    field :name do
      noko.css('a').text
    end

    field :party do
      noko.xpath('preceding::h6').last.text
    end

    private

    def url
      noko.css('a/@href').text
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    decorator Scraped::Response::Decorator::CleanUrls

    field :members do
      noko.css('#post-13068 li').map { |mp| fragment(mp => Member).to_h }
    end
  end
end

url = 'https://www.conseil-national.mc/vos-elus/disposition-des-elus-dans-lhemicycle/'
puts EveryPoliticianScraper::ScraperData.new(url).csv
