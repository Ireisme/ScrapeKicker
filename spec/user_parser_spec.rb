require_relative 'spec_helper'

describe UserParser do

  describe '#get_users' do
    context 'with correct html' do
      before do
      html = Nokogiri::HTML('<html>
              <body>
              <div class="NS_backers__backing_row" data-cursor="8675309">
              <a href="/profile/8675309"><img alt="Missing_small" class="avatar-small" height="80" src="some_image.png" width="80"></a>
              <div class="meta">
              <h5>
              <a href="/profile/8675309">Jenny</a>
              </h5>
              <p class="location">
              <span class="icon"></span>
              Her Number, The Wall
              </p>
              </div>
              </div>
              </body>
              </html>')
        UserParser.should_receive(:get_html).and_return(html, Nokogiri::HTML(''))
      end
      it 'returns correct users' do
        user = User.new
        user.id = '8675309'
        user.name = 'Jenny'
        user.location = 'Her Number, The Wall'
        UserParser.get_users('test') do |u|
          u.should eq(user)
        end
      end
    end

    context 'with empty html' do
      before do
        UserParser.should_receive(:get_html).and_return(Nokogiri::HTML(''))
      end
      it 'return no users' do
        UserParser.get_users('test').should be_nil
      end
    end
    context 'with incorrect html' do
      before do
        UserParser.should_receive(:open).and_return('<html><body><p>some html</p></body></html>')
      end
      it 'returns no users' do
        UserParser.get_users('test').should be_nil
      end
    end

  end

  describe '#get_html' do
    it 'waits and tries again when receiving a 429' do
      UserParser.stub(:open).and_raise(OpenURI::HTTPError.new('429', double('io')))
      UserParser.should_receive(:open).twice
      UserParser.get_html('test')
    end
  end
end