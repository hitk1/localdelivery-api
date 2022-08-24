alias Deliveryapi.Repo
alias Cities.Repo.City

cities_file_name = "assets/csv/cities.csv"

cities_file_name
|> File.stream!()
|> Stream.map(fn line ->
  [city_name, ibge_code, state, state_short_name] = String.split(line, ",")

  formated_city_name =
    city_name
    |> String.trim()
    |> String.replace("\\n", "")

  formated_ibge_code =
    ibge_code
    |> String.trim()
    |> String.replace("\\n", "")

  formated_state =
    state
    |> String.trim()
    |> String.replace("\\n", "")

  formated_state_short_name =
    state_short_name
    |> String.trim()
    |> String.replace("\\n", "")

  Repo.insert!(%City{
    name: formated_city_name,
    ibge_code: formated_ibge_code,
    state: formated_state,
    state_short_name: formated_state_short_name
  })
end)
|> Stream.run()
