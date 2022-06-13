#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'

class MemberList
  class Member
    field :id do
      url.split('/').last
    end

    field :name do
      noko.css('a').text
    end

    field :party do
      noko.xpath('preceding::h6').last.text
    end

    field :position do
    end

    private

    def url
      noko.css('a/@href').text
    end
  end

  class Members
    decorator Scraped::Response::Decorator::CleanUrls

    def member_container
      noko.css('#post-13068 li')
    end
  end
end

url = 'https://www.conseil-national.mc/vos-elus/disposition-des-elus-dans-lhemicycle/'
puts EveryPoliticianScraper::ScraperData.new(url).csv
