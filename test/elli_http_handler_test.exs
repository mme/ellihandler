Code.require_file "../test_helper.exs", __FILE__

defmodule ExElliHTTPHandlerTest do
  use ExUnit.Case
  
  setup do
    :inets.start()
    { :ok, pid } = :elli.start_link [callback: TestHandler, port: 3000]
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
    # :httpc.request(:post, {'http://localhost:3000/hello/world', [], 'application/x-www-form-urlencoded', 'hl=en&q=erlang&btnG=Google+Search&meta='  },  [], [])
    {:ok, {{_,200,_},_,response}} = :httpc.request(:post, {'http://localhost:3000/hello/world', [], '', ''},  [], [])
    assert response == 'Hello world post'
  end
  
  test "post body" do
    {:ok, {{_,200,_},_,response}} = :httpc.request(:post, {'http://localhost:3000/hello/post/variable', [], 'application/x-www-form-urlencoded', 'var=hello_hello'  },  [], [])
    assert response == 'hello_hello'
  end
  
  test "halt" do
    {:ok, {{_,status,_},_,_}} = :httpc.request('http://localhost:3000/halt')
    assert status == 404
  end
  
  teardown meta do
    :elli.stop(meta[:pid])
  end
end
