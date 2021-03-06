require 'puppet_community_data/pull_request'

require 'chronic'

module PuppetCommunityData
  class Repository
    attr_reader :owner, :name

    def initialize(repository)
      @owner, @name = repository.split('/')
      @users = {}
    end

    ##
    # full_name returns the "full name" of the repository which is in the
    # format of "owner/name"
    #
    # @ return [String] the full name of the repository in the correct
    # format
    def full_name
      [@owner, @name].join('/')
    end

    ##
    # Given a Octokit object, closed_pull_requests will generate a collection
    # of pull request objects for all closed pull requests in a given
    # repository
    #
    # @param [Octokit::Client] github_api is the instance of the GitHub API
    # needed to read from the repository
    #
    # @ return [Array] of hashes containting data that  represents the pull requests
    # for the given repository
    def closed_pull_requests(github_api)
      closed_pull_requests = github_api.pull_requests(full_name, state: 'closed')
      closed_pull_requests.collect do |pr|

        was_merged = !!(pr['merged_at'])
        closed = (pr['state'] == 'closed')
        open_time = Chronic.parse(pr['created_at'].to_s).to_time
        close_time = Chronic.parse(pr['closed_at'].to_s).to_time

        user = pr['user']
        # Ensure that the user exists before trying to continue
        next unless user
        login = user['login']
        from_community = !(github_api.organization_member?('puppetlabs', login))

        Hash["pr_number" => pr['number'],
             "repo_name" => name,
             "repo_owner" => owner,
             "merge_status" => was_merged,
             "time_closed" => close_time,
             "time_opened" => open_time,
             "from_community" => from_community,
             "closed_v_open" => closed]
      end
    end
  end
end
