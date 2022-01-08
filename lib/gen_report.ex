defmodule GenReport do
  alias GenReport.Parser

  @workers [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "danilo",
    "rafael",
    "vinicius"
  ]

  @month_names [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp sum_values(
         [worker, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         } = report
       ) do
    all_hours = Map.put(all_hours, worker, all_hours[worker] + hours)

    individual_hours_per_month =
      Map.put(hours_per_month[worker], month, hours_per_month[worker][month] + hours)

    hours_per_month = Map.put(hours_per_month, worker, individual_hours_per_month)

    individual_hours_per_year =
      Map.put(hours_per_year[worker], year, hours_per_year[worker][year] + hours)

    hours_per_year = Map.put(hours_per_year, worker, individual_hours_per_year)

    %{
      report
      | "all_hours" => all_hours,
        "hours_per_month" => hours_per_month,
        "hours_per_year" => hours_per_year
    }
  end

  defp report_acc do
    all_hours = Enum.into(@workers, %{}, &{&1, 0})
    months = Enum.into(@month_names, %{}, &{&1, 0})
    hours_per_month = Enum.into(@workers, %{}, &{&1, months})
    years = Enum.into(2016..2020, %{}, &{&1, 0})
    hours_per_year = Enum.into(@workers, %{}, &{&1, years})

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
