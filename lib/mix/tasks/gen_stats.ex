defmodule Mix.Tasks.Gen.Stats do
  use Mix.Task

  @shortdoc ""
  @moduledoc """

  """

  def run(args) do
    Application.get_env(:code_gen, :data)[:services]
    |> Enum.map(&gen_service/1)
  end

  def gen_service({service}), do: gen_service({service,true})
  def gen_service({service,name_first}) do
    gen_stats(Atom.to_string(service),name_first)
  end

  # same code from template example...
  def gen_stats(service,name_first,module_dir \\ "lib/generated") do
    :ok = File.mkdir_p!(module_dir)
    code = EEx.eval_file("lib/templates/stats_template.eex", [assigns: [service_name: service, name_first: name_first]])
    filename = Path.join([module_dir, String.downcase(service) <> ".ex"])
    :ok = File.write!(filename, code)
    IO.puts "Generated: #{filename}"
  end

  def flag(str) do
    case String.downcase(str) do
      "true" -> true
      "t" -> true
      "yes" -> true
      "y" -> true
      _ -> false
    end
  end

end
