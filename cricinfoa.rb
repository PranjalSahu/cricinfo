
require 'open-uri'

start_num = 980901

base_url = 'http://www.espncricinfo.com'
base_str = 'http://www.espncricinfo.com/indian-premier-league-2016/engine/match/'
end_stra = '.html?view=wickets'
end_strb = '.html'
num = 40

num.times {
  begin
    
    a = open(base_str+start_num.to_s+end_stra)
    b = open(base_str+start_num.to_s+end_strb)

    File.open("/Users/pranjalsahu/cricketdata/#{start_num.to_s}", "w") { |file| file.write a.read}
    File.open("/Users/pranjalsahu/cricketdata/#{start_num.to_s}_home", "w") { |file| file.write b.read}
    
    start_num = start_num+2
    puts "File downloaded #{start_num}"
  rescue
  end
}


#SAVE FILE FOR EACH MATCH

Dir.glob("/Users/pranjalsahu/cricketdata/98*") do |my_text_file|
  matchid  = my_text_file.split("/")[-1]

  file = File.open(my_text_file, "rb")
  contents = file.read

  events = Nokogiri::HTML.parse contents

  batsman_and_bowler_urls = events.xpath('//li/span').map{|t| t["data-url"]}.compact.select{|t| t.include?("batsman") or t.include?("bowler")}

  batsman_and_bowler_urls.each do |url|
    fetch_url = base_url+url

    if url.include?("batsman")
      id = url[/batsman=(.*?);/m, 1]
      type = "batsman"
    elsif url.include?("bowler")
      id = url[/bowler=(.*?);/m, 1]
      type = "bowler"
    end

    begin
      a = open(fetch_url)
      File.open("/Users/pranjalsahu/cricketdata/#{matchid}_#{type}_#{id}", "w") { |file| file.write a.read}
      puts "File downloaded #{matchid}_#{type}_#{id}"
    rescue
    end
  
  end
end



# PROCESS EACH FILE TO GENERATE EACH ROW FOR EACH MATCH

all_events = []
overs_text = {}
player_names = {}

def get_events(filename)
  file = File.open(filename, "rb")
  contents = file.read
  events = Nokogiri::HTML.parse contents
end

Dir.glob("/Users/pranjalsahu/cricketdata/98*") do |my_text_file|

  if my_text_file.include?("_home")

    # GETTING PLAYER NAMES
    events = get_events(my_text_file)
    events.css('td.batsman-name').css('a').map{|t| player_names[t.text.strip] = t["href"]}
    events.css('td.bowler-name').css('a').map{|t| player_names[t.text.strip] = t["href"]}

  elsif (my_text_file.include?("batsman") or my_text_file.include?("bowler"))
    filename    = my_text_file.split("/")[-1]
    arr         = filename.split("_")
    matchid     = arr[0]
    player_type = arr[1]
    id          = arr[2]

    events = get_events(my_text_file)
    commentary_events = events.css('div.commentary-section').css('div.commentary-event')

    commentary_events.each do |event|
      over = event.css('div.commentary-overs')

      if over.present?
        text = event.css('div.commentary-text').text
        imp  = event.css('span.commsImportant')
        ts   = text.split(",").map{|t| t.strip}

        bowler_and_batsman = ts[0]
        run = ts[1]
        comments = ts[2..-1].join(" ")
        bowler  = bowler_and_batsman.split("to")[0].strip
        batsman = bowler_and_batsman.split("to")[1].strip

        overs_text[matchid] ||= {}

        if overs_text[matchid][over.text].present? 
          temp_arr = overs_text[matchid][over.text]
        else
          temp_arr = [bowler, batsman, run, comments, imp.try(:text), over.text, matchid]
          overs_text[matchid][over.text] = temp_arr
        end

        if player_type == "batsman"
          overs_text[matchid][over.text][1] = id
        elsif player_type == "bowler"
          overs_text[matchid][over.text][0] = id
        end
      end

    end
  end
end


all_events = []
overs_text.values.each do |t|
  all_events << t.values
end

all_events = all_events.flatten(1)

# DOWNLOAD ALL PLAYERS PROFILES
player_names.each do |key, value|
  begin
    a = open(base_url+value)
    player_id = value.split("/")[-1][/\d+/]
    File.open("/Users/pranjalsahu/cricketdata/player_#{player_id.to_s}", "w") { |file| file.write a.read}
    puts "File downloaded #{player_id.to_s}"
  rescue
  end
end






























