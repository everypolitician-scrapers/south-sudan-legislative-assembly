#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'
require 'pry'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def scrape_list(url)
  warn "Getting #{url}"
  noko = noko_for(url)
  noko.css('div#content_top table').first.css('tr').drop(1).each do |row|
    tds = row.css('td')
    data = { 
      id: tds[0].text.strip,
      name: tds[1].text.strip.sub(/^Hon.\s*/,''),
      executive: tds[2].text.strip,
      party: tds[3].text.strip,
      constituency: tds[4].text.strip,
      source: url,
      term: 1,
    }
    next if data[:name].empty?
    ScraperWiki.save_sqlite([:id, :term], data)
  end
end

scrape_list('http://www.goss.org/index.php/legislative-assembly/honourable-members')

