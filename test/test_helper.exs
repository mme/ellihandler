ExUnit.start


defmodule TestHandler do
  use ExElliHTTPHandler
  
  get "/hello/world" do
    http_ok "Hello world"
  end
  
  get "/hello/:planet" do
    http_ok "Hello #{planet}"
  end
  
end