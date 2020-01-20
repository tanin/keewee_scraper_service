INSTALL:

clone
cd open_graph_scraper
brew install mongodb
bundle

ruby server.rb

curl -d "url=https://ogp.me/" -X POST http://localhost:4567/stories
{"id":"5e2515ce626daf43c25c679a","url":"http://ogp.me/"}


curl http://localhost:4567/stories/5e2515ce626daf43c25c679a
{"id":"5e2515ce626daf43c25c679a","url":"http://ogp.me/","type":null,"title":null,"images":null,"updated_time":"2020-01-20T04:56:35.439+02:00","scrape_status":"Pending"}
