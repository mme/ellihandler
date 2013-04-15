ExUnit.start


defmodule TestHandler do
  use ExElliHTTPHandler
  
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
  
end