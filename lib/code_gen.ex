defmodule CodeGen do

  def generate_service(service) do
    generate_service(service, [])
  end

  def generate_service(service, opts) when is_atom(service) do
    service
    |> Atom.to_string
    |> String.downcase
    |> generate_service(opts)
  end

  def generate_service(service, opts) do
    service
    |> code_for(opts[:name_first])
    |> compile
    |> Enum.map(&(write_to(&1,opts[:to_file])))
  end

  def code_for(service, name_first \\ true) do

    module_name = String.to_atom("Elixir."<> String.capitalize(service))
    service_name = String.downcase(service)

    code = quote do
              defmodule unquote(module_name) do

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
    {service,code}
  end

  def compile({service,quoted_code}) do
    Code.compile_quoted(quoted_code)
  end

  def write_to({name,compiled},true) do
    File.write!(Atom.to_string(name) <> ".beam", compiled)
  end
  def write_to(_,_) do
    :ok
  end

end
