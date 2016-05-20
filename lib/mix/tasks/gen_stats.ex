defmodule Mix.Tasks.Gen.Stats do
  use Mix.Task

  @shortdoc "Generate stats for the specified service."
  @moduledoc """

  Generate stats for the specified service.

  Valid services are:

  * GitHub
  * StackOverflow
  * TIOBE

  Each service may be passed a second flag (name_first?) that indicates if the
  name is before or after the numeric value. The value defaults to true.

  ```
  mix gen.stats tiobe
  mix gen.stats github yes
  mix gen.stats stackoverflow false
  ```

  """

  def run(args) do
    case args do
      [] -> usage()
      [service] -> gen_stats(service,true)
      [service,name_first] -> gen_stats(service,flag(name_first))
      _ -> usage()
    end
  end

  def usage() do
    IO.puts "You must provide a valid service name and optionally a flag indicating if the name is in the first column (defaults to true)"
  end

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
