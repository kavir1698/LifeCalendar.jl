# LifeCalendar.jl

Create a plot from the weeks of your life and its important periods.

## Installation:
```julia
]add https://github.com/kavir1698/LifeCalendar.jl.git
```

## Usage

Example:

```julia
using LifeCalendar
using Dates

my_birth_date = Date(1990, 5, 16)
expected_years = 80
special_dates = Dict(
	"School" => [Date(1996, 9, 16), Date(2007, 6, 16)],
	"BSc" => [Date(2007, 9, 16), Date(2011, 3, 16)],
	"MSc" => [Date(2011, 9, 1), Date(2013, 9, 1)],
	"Marriage" => [Date(2016, 3, 3), Date(2016, 3, 3)],
	)

life_calendar(my_birth_date, expected_years, special_dates)
```

This will save the calendar as a PDF.

![An example of the resulting image](https://github.com/kavir1698/LifeCalendar.jl/blob/master/life_calendar.png?raw=true)