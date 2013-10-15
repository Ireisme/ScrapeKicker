class UserParser

  def self.get_html url
    begin
      return Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError
      sleep(5)
      begin
        return Nokogiri::HTML(open(url))
      rescue
        return Nokogiri::HTML('')
      end
    end
  end


  def self.get_users project_url

    backers_url = project_url.gsub('https', 'http') + '/backers'

    backers_html = get_html(backers_url)

    backers = backers_html.css('.NS_backers__backing_row')

    begin
      lastId = 0
      backers.each do |userHtml|
        user = User.new
        user.id = userHtml['data-cursor']
        user.name = userHtml.css('.meta a').first.content
        location = userHtml.css('.meta .location').first
        user.location = location ? location.content.gsub("\n", '').lstrip.rstrip : ''

        lastId = user.id

        yield user
      end

      if lastId != 0
        backers_html = get_html(backers_url + '?cursor=' + lastId)
      end
      backers = backers_html.css('.NS_backers__backing_row')
    end while !backers.empty?
  end
end