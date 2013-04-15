defrecord ExElliHTTPRequest, Record.extract(:req, from: "deps/elli/include/elli.hrl")

defmodule ExElliHTTPHandler do
  
  defmacro __using__(_opts) do
    
    quote do
      @behaviour :elli_handler
      
      def handle(elli_req,_args) do
        req = ExElliHTTPRequest.new elli_req
        handle(req.method, :elli_request.path(elli_req), req)
      end
      
      def handle_event(_event, _data, _args) do
        :ok
      end
      
      import ExElliHTTPHandler
      
    end
  end
  
  defp split_path(path) do
    case path do
      "/"                     ->  []
      <<"/", rest :: binary>> ->  String.split(rest, "/")
      _                       ->  String.split(path, "/")
    end
  end
  
  defp compile_path(path) do
    Enum.map split_path(path), compile_pattern(&1)
  end
  
  defp compile_pattern(pat) do
    len = (String.length pat)
    if len >= 2 and (String.at pat, 0) == ":" do
      atom = binary_to_atom(String.slice pat,1,len-1)
      quote do var!(unquote(atom)) end
    else
      pat
    end
  end
  
  defmacro get(path, do: code) do
    quote do
      match :GET, unquote(path) do
        unquote(code)
      end
    end
  end
  
  defmacro post(path, do: code) do
    quote do
      match :POST, unquote(path) do
        unquote(code)
      end
    end
  end
  
  defmacro put(path, do: code) do
    quote do
      match :PUT, unquote(path) do
        unquote(code)
      end
    end
  end
  
  defmacro delete(path, do: code) do
    quote do
      match :DELETE, unquote(path) do
        unquote(code)
      end
    end
  end
  
  defmacro match(method, path, do: code) do
    quote hygiene: [vars: false] do
      def handle(unquote(method), unquote(compile_path path), req) do
        req # don't complain about unused variable
        unquote(code)
      end
    end
  end
  
  def http_ok(response // ""), do: {:ok, [], response}
  
end
