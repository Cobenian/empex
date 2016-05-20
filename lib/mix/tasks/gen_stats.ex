defmodule Mix.Tasks.Gen.Stats do
  use Mix.Task

  @shortdoc ""
  @moduledoc """

  """

  def run(args) do
    Application.get_env(:code_gen, :data)[:services]
    Enum.map(&gen_service/1)
  end

  def gen_service({service}), do: gen_service({service,true})
  def gen_service({service,name_first}) do

  end

end
