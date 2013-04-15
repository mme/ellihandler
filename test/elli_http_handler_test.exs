Code.require_file "../test_helper.exs", __FILE__

defmodule ExElliHTTPHandlerTest do
  use ExUnit.Case
  
  setup do
    :inets.start()
    { :ok, pid } = :elli.start_link [callback: TestHandler, port: 3000]
    { :ok, pid: pid }
  end
  
  test "simple get" do
    {:ok, {_,_,response}} = :httpc.request('http://localhost:3000/hello/world')
    assert response == 'Hello world'
  end
  
  test "get /" do
    {:ok, {_,_,response}} = :httpc.request('http://localhost:3000/')
    assert response == 'root'
  end
  
  
  test "get with var" do
    {:ok, {_,_,response}} = :httpc.request('http://localhost:3000/hello/moon')
    assert response == 'Hello moon'
  end
  
  teardown meta do
    :elli.stop(meta[:pid])
  end
end
