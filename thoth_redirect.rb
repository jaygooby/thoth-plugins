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
    
    module ::Ramaze; class Controller; class << self
      
      attr_accessor :last_path
      
      # method chain aliasing - don't blow away Ramaze::Controller.raise_no_action
      alias :original_raise_no_action :raise_no_action
                    
      def raise_no_action(controller, path)
        # just handle this the normal Ramaze way if this is an unknown action and we haven't got a redirect defined for it
        # we also trap any redirects that result in a circular set of redirects:
        # /foo redirects to /bar but there's no action associated with /bar so repeat the process again and again
        # Some browsers would show a "too many redirects" error, but its better just to trap this here instead and 404 (or whatever) it.
                
        if ! Ramaze::Route.trait[:routes].values.include?(path) or path == @last_path
          original_raise_no_action(controller, path) 
        else
          # otherwise it's actually one of our redirects and yes, we don't have an action associated with it or we wouldn't be
          # here, so try an actual redirect
          @last_path = path
          raw_redirect(path, :status => 301)                
        end
      end    
      
    end; end; end; #::Ramaze::Controller
  
  end;
  
end; end