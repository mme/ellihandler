Code.require_file "../test_helper.exs", __FILE__

defmodule Elli.Handler.Test do
  use ExUnit.Case
  
  setup do
    :inets.start()
    
    config = [mods: [{Test.MiddlewareHandler, [prefix: "/middleware/"]}, {Test.Handler, []}]]
    { :ok, pid } = :elli.start_link [callback: :elli_middleware, callback_args: config, port: 3000]
    { :ok, pid: pid }
  end
  
  test "simple get" do
    {:ok, {{_,200,_},_,response}} = :httpc.request('http://localhost:3000/hello/world')
    assert response == 'Hello world'
  end
  
  test "get /" do
    {:ok, {{_,200,_},_,response}} = :httpc.request('http://localhost:3000/')
    assert response == 'root'
  end
  
  test "get with var" do
    {:ok, {{_,200,_},_,response}} = :httpc.request('http://localhost:3000/hello/moon')
    assert response == 'Hello moon'
  end
  
  test "post" do
    {:ok, {{_,200,_},_,response}} = :httpc.request(:post, {'http://localhost:3000/hello/world', [], '', ''},  [], [])
    assert response == 'Hello world post'
  end
  
  test "post body" do
    {:ok, {{_,200,_},_,response}} = :httpc.request(:post, {'http://localhost:3000/hello/post/variable', [], 'application/x-www-form-urlencoded', 'var=hello%20hello'  },  [], [])
    assert response == 'hello hello'
  end
  
  test "halt" do
    {:ok, {{_,status,_},_,_}} = :httpc.request('http://localhost:3000/halt')
    assert status == 404
  end
  
  test "no such route" do
    {:ok, {{_,status,_},_,_}} = :httpc.request('http://localhost:3000/no/such/route')
    assert status == 404
  end
  
  test "param missing" do
    {:ok, {{_,status,_},_,_}} = :httpc.request('http://localhost:3000/params')
    assert status == 400
  end
  
  test "params" do
    {:ok, {{_,_,_},_,response}} = :httpc.request('http://localhost:3000/params?a=1&b=2')
    assert response == 'Got a=1 and b=2'
  end
  
  test "middleware" do
    {:ok, {{_,200,_},_,response}} = :httpc.request('http://localhost:3000/middleware/hello')
    assert response == 'hello from middleware'
  end
  
  teardown meta do
    :elli.stop(meta[:pid])
  end
  
end
