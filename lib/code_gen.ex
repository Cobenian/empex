defmodule CodeGen do
  defmacro __using__(opts) do
    service_name = opts[:name] |> Atom.to_string |> String.downcase
    name_first =
      case opts[:name_first] do
        false -> false
        _ -> true
      end
    quote do
      def stats() do
        ["lib","data",unquote(service_name) <> ".csv"]
        |> Path.join
        |> File.read!
        |> String.strip
        |> String.split("\n")
        |> remove_header()
        |> Enum.map(&read_values/1)
        |> Enum.sort(&(popularity_comparison(&1,&2)))
      end

      defp remove_header([h|t]), do: t

      defp read_values(line) do
        values = line |> String.split(",")
        if unquote(name_first) do
          values
        else
          Enum.reverse(values)
        end
      end

      defp popularity_comparison([_lang_a,value_a] = a, [_lang_b,value_b] = b) do
        value_a > value_b
      end
    end
  end
end
