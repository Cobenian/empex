defmodule CodeGen do

  def generate_service(service) when is_atom(service) do
    service
    |> Atom.to_string
    |> String.downcase
    |> generate_service
  end

  def generate_service(service) do
    service
    |> data_for
    |> code_for
    |> compile
    |> Enum.map(&write_to/1)
  end

  def data_for(service) do
    data = ["lib","data",service <> ".csv"]
      |> Path.join
      |> File.read!
    {service,data}
  end

  def code_for({service,data}) do

    module_name = String.to_atom("Elixir."<> String.capitalize(name))

    code = quote do
              defmodule unquote(module_name) do
                 
              end
           end
    {service,code}
  end

  def compile({service,quoted_code}) do
    Code.compile_quoted(quoted_code)
  end

  def write_to({name,compiled}) do
    File.write!(Atom.to_string(name) <> ".beam", compiled)
  end

end
