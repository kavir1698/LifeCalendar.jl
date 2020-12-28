export life_calendar

function week_from_birth(d, birthdate)
  ((year(d)-year(birthdate))*52) + (week(d) - week(birthdate))
end

function create_df(birthdate, life_expectancy, special_periods)
	byear = year(birthdate)
	tday = today()
	age_in_weeks = week_from_birth(tday, birthdate) + week(birthdate)
	all_weeks = (52 * (life_expectancy+1))
	df = DataFrame(Dict(
			:weeks => repeat(1:52, outer=life_expectancy+1),
			:age => repeat(0:life_expectancy, inner=52),
			:year => repeat(byear:byear+life_expectancy, inner=52),
			:col => vcat(fill("Lived", age_in_weeks), fill("Future", (all_weeks-age_in_weeks))),
			:opacity => vcat(fill(0.99, age_in_weeks), fill(0.0, (all_weeks-age_in_weeks)))
	))
	df = df[week(birthdate)+1:end, :]
	df = df[1:end-(52-week(birthdate)), :]
	for (event, d) in special_periods
		week_range = week_from_birth(d[1], birthdate):week_from_birth(d[2], birthdate)
		df[week_range, :col] = event
	end
	return df
end

"""
    life_calendar(birthdate::Date [, life_expectancy::Int=80, special_periods::Dict=Dict()])

* `birthdate`: your birth date.
* `life_expectancy`=80: how many years you expect to live.
* `special_periods`: A dictionary that marks important periods or dates in your life. A key is a `String` the describes the period, and the value is an `Array` of two `Date`s, start and end.
* `colorscheme`="category20". A color scheme name from https://vega.github.io/vega/docs/schemes/.
"""
function life_calendar(birthdate::Date, life_expectancy::Int=80, special_periods::Dict=Dict(); colorscheme="category20")
  df = create_df(birthdate, life_expectancy, special_periods)
  p = df |> @vlplot(
      resolve = {scale = {y = "independent"}},
      config = {
        axis = {
          grid = true,
          gridWidth=2,
          gridColor="white",
          tickBand = "extent",
          domain=false,
          ticks=false,
          titleFontSize=22,
          titleFontWeight = "normal",
          labelFontSize=18
        }
      }
    ) + 
    @vlplot(
      mark = {:line, color="white"},
      title = {text="LIFE CALENDAR", fontSize=50, fontWeight="normal"},
      y = {
        "age:o",
        axis = {
          title = "← Year of your life",
          orient = "left",
          titleY = 150
        },
      }
    ) + 
    @vlplot(mark = {:rect},
      x = {
        "weeks:o",
        axis = {
          title = "Week of the year →",
          orient = "top",
          labelAngle=0,
          labelOverlap = true,
          labelSeparation	= 4,
          titleX = 150
        },
      },
      y = {"year:n",
        axis = {
          orient=:right,
          title = false,
          grid = true,
          tickBand = "extent",
        }
      },
      fill = {
        field = "col:n",
        legend = {title=nothing, labelFontSize=22},
        scale = {scheme = colorscheme}
      },
      opacity = {
          field = "opacity:q",
          legend = nothing
        }
    
    )
  VegaLite.save("life_calendar.pdf", p)
end