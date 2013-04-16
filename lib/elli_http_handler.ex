defmodule ElliHTTPHandler do
  
  defmacro __using__(_opts) do
    
    quote do
      @behaviour :elli_handler
      @before_compile ElliHTTPHandler
      
      def handle(elli_req,_args) do
        req = ElliHTTPRequest.new elli_req
        handle(req.method, req.path, req)
      end

      import ElliHTTPHandler
    end
  end
  
  defp split_path(path) do
    Enum.filter String.split(path, "/"), &1 != ""
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
  
  defp compile_params(nil), do: nil
  defp compile_params({:with_params, _, params}), do:Enum.map params, compile_param(&1)
  
  defp compile_param({param,_,_}) do
    param_binary = atom_to_binary(param)
    quote hygiene: [vars: false] do
      var!(unquote(param)) = req.get_arg(unquote(param_binary)) 
      if var!(unquote(param)) == :undefined do 
        halt! bad_request
      end
    end
  end
    
  defmacro get(path, params // nil, do: code) do
    quote do
      match :GET, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro post(path, params // nil, do: code) do
    quote do
      match :POST, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro put(path, params // nil, do: code) do
    quote do
      match :PUT, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro delete(path, params // nil, do: code) do
    quote do
      match :DELETE, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro match(method, path, params // nil, do: code) do
    params = compile_params(params)
    quote hygiene: [vars: false] do
      def handle(unquote(method), unquote(compile_path path), req) do
        req # don't complain about unused variable
        unquote(params)
        unquote(code)
      end
    end
  end

  def http_ok(body // "Ok"),                                        do: {:ok, [], body}
  def http_not_found(body // "Not Found"),                          do: {404, [], body}
  def http_permission_denied(body // "Permission denied"),          do: {403, [], body}
  def http_internal_server_error(body // "Internal Server Error"),  do: {500, [], body}
  def bad_request(body // "Bad Request"),                           do: {400, [], body}
  
  def halt!(res), do: throw(res)
  
  defmacro __before_compile__(_env) do
    quote do
      def handle(_, _, req), do: http_not_found
      def handle_event(_, _, _), do: :ok
    end
  end
  
end
