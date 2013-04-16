defmodule Elli.HTTPMiddlewareHandler do
  
  defmacro __using__(_opts) do
    
    quote do
      @before_compile Elli.HTTPMiddlewareHandler
      use Elli.HTTPHandler
    end
  end
  
  defmacro __before_compile__(_env) do
    quote do
      def handle(_, _, req), do: elli_ignore
      def handle_event(_, _, _), do: :ok
    end
  end
  
end
