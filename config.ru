require './app/controllers/application_controller'
require './app/controllers/user_controller'
require './app/controllers/group_controller'
require './app/controllers/message_controller'


#use Rack::Static, :urls => ['/public'], :root => 'public'

use Rack::MethodOverride
use MessageController
use UserController
use GroupController
run ApplicationController
