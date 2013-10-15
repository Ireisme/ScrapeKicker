class Scraper

  def initialize email, password
    Kickscraper.configure do |config|
      config.email = email
      config.password = password
    end

    @client = Kickscraper.client
  end

  def by_category category
    assemble_projects(@client.category(category).projects) { |project| yield project }
  end

  def by_search search
    assemble_projects(@client.search_projects(search)) { |project| yield project }
  end

  def assemble_projects projects
    begin
      projects.each do |project|
        new_project = Project.new(project.id, project.name, project.location.name)
        new_project.goal = project.goal
        new_project.pledged = project.pledged
        new_project.created = Time.at(project.created_at)
        new_project.deadline = Time.at(project.deadline)

        UserParser.get_users(project.urls.web.project) do |user|
          new_project.backers.push(user)
        end

        yield new_project
      end

      projects = @client.more_projects_available? ? @client.load_more_projects : nil
    end while projects
  end
end