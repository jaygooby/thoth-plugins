module Thoth; module Plugin
  
  # Plugin stub showing how to access the before and after actions on a controller
  # using the aspect helper. Working on the PostController in this case, but
  # could just as easily be class Controller to work everywhere
  # 
  # You'll need to tell Thoth to start the plugin when it starts, so make sure you have a 
  #
  #  plugins ['aspect_stub']
  #
  # directive in your thoth.conf  
  
  module AspectStub
        
    module ::Thoth; class PostController;
      
      helper :aspect
      
      # run before the controller action code
      # to run only on the :edit action use before(:edit)
      before {
        ::Ramaze::Log.debug ":before controller: #{self.inspect}"
        ::Ramaze::Log.debug ":before controller instance variables: #{self.instance_variables}"
      }
      
      # run after the controller action code
      # to run only on the edit and new actions use before(:new, :edit)
      after {
        ::Ramaze::Log.debug ":after controller: #{self.inspect}"
        ::Ramaze::Log.debug ":after controller instance variables: #{self.instance_variables.inspect}"
        ::Ramaze::Log.debug ":after controller @post: #{@post.inspect}"
      }                  
              
    end; end;
    
  end
  
end; end;