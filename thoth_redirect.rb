module Thoth; module Plugin

  # Redirect plugin for Thoth
  #
  # Create a redirect.yml file in the root of your Thoth blog
  # and put the redirects you want in there, e.g.
  #
  #  ---
  #    /foo: /bar
  #    /some/thing: /some/thing.pdf
  #    # can use ramaze regex too: http://wiki.ramaze.net/Walkthrough#routing
  #    ^/(\d+)\.te?xt$: /text/%d # maps e.g. /123.text or /56.text to /text/123 and /text/56 respectively
  #
  # You'll need to tell Thoth to start the plugin when it starts, so make sure you have a 
  #   plugins ['redirect']
  # directive in your thoth.conf
  
  module Redirect
    # get the hash of original and redirected locations and create routes for them
    File.open( 'redirects.yml' ) { |yf| YAML::load( yf ) }.each do |original_location, redirected_location|
      Ramaze::Log.debug "Added redirect: #{original_location} to #{redirected_location}"
      # using rewrite should then allow us to use regex in redirects.yml
      # as long as we convert everything to a Regexp first
      Ramaze::Route[ Regexp.new(original_location)] = redirected_location
    end
  end;
end; end