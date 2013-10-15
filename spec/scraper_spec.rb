require_relative 'spec_helper'

describe Scraper do

  before do
    Kickscraper = double('Kickscraper')
    Kickscraper.stub(:configure).and_return(true)
    Client = double('client')
    Kickscraper.stub(:client).and_return(Client)
    Client.stub(:more_projects_available?).and_return(false)
    @scraper = Scraper.new("fake@fake.com", '12345pass')
  end

  describe "#new" do
    it "takes email and password and returns a Scraper" do
      @scraper.should be_an_instance_of Scraper
    end
  end

  describe "#assemble_projects" do
    before do
      UserParser.stub(:get_users).and_return([])
      Location = Struct.new(:name)
      KickProject = Struct.new(:id, :name, :location, :goal, :pledged, :created_at, :deadline)
      first_project = KickProject.new(12345, 'A project', Location.new('Somewhere'), 1567, 1892, 1381723200, 1381809600)
      first_project.stub_chain('urls.web.project').and_return('')
      second_project = KickProject.new(6789, 'A second project', Location.new('Somewhere Else'), 50000, 25000, 1381636800, 1381896000)
      second_project.stub_chain('urls.web.project').and_return('')
      @projects = [first_project, second_project]
    end

    it "returns Projects with correct values" do
      i = 0
      @scraper.assemble_projects(@projects) do |project|
        project.id.should eq(@projects[i].id)
        project.name.should eq(@projects[i].name)
        project.location.should eq(@projects[i].location.name)
        project.goal.should eq(@projects[i].goal)
        project.pledged.should eq(@projects[i].pledged)
        project.created.should eq(Time.at(@projects[i].created_at))
        project.deadline.should eq(Time.at(@projects[i].deadline))
        i = i +1
       end
    end
  end
end