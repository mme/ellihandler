ExUnit.start


defmodule Test.Handler do
  use Elli.Handler
  
  get "/hello/world" do
    http_ok "Hello world"
  end
  
  get "/hello/:planet" do
    http_ok "Hello #{planet}"
  end
  
  get "/" do
    http_ok "root"
  end
  
  post "/hello/world" do
    http_ok "Hello world post"
  end
  
  post "/hello/post/variable" do
    http_ok req.post_arg("var")
  end
  
  get "/halt" do
    halt! http_not_found
    http_ok "ok"
  end
  
  get "/params", with_params a, b do
    http_ok("Got a=#{a} and b=#{b}")
  end
  
  
end

defmodule Test.MiddlewareHandler do
  use Elli.Handler
  
  get "/" do
    elli_ignore
  end
  
  get "/hello" do
    http_ok("hello from middleware")
  end
  
end
# 
# defmodule Test.HTTPMiddlewareHandler do
#   use Elli.HTTPRequestHandler
#   
#   # get "/" do
#   #   elli_ignore
#   # end
#   
#   get "/middleware/hello" do
#     IO.puts("HERE!")
#     http_ok("hello from middleware")
#   end
# end