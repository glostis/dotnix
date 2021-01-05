#!/bin/sh
# Adpated from: https://github.com/polybar/polybar-scripts/blob/master/polybar-scripts/openweathermap-fullfeatured/openweathermap-fullfeatured.sh

get_icon() {
    case $1 in
        # See icon definitions: https://openweathermap.org/weather-conditions
        # Icons for Font Awesome
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09*) icon="";;
        10*) icon="";;
        11*) icon="";;
        13*) icon="";;
        50*) icon="";;
        *) icon="";
    esac

    echo $(change_font $icon)
}

change_font() {
    echo %{T3}$1%{T-}
}

KEY="${OPENWEATHER_API_KEY:?API Key unset}"
UNITS="metric"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    forecast=$(curl -sf "$API/forecast?appid=$KEY&$CITY_PARAM&units=$UNITS&cnt=2")
else
    if [ -n "$LATLON" ]; then
        location_lat="$(echo $LATLON | cut -d, -f1)"
        location_lon="$(echo $LATLON | cut -d, -f2)"
    else
        location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"
    fi

    current=$(curl -sf "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
    forecast=$(curl -sf "$API/forecast?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS&cnt=2")
fi

if [ -n "$current" ] && [ -n "$forecast" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")

    forecast_temp=$(echo "$forecast" | jq ".list[1].main.temp" | cut -d "." -f 1)
    forecast_icon=$(echo "$forecast" | jq -r ".list[1].weather[0].icon")

    if [ "$current_temp" -gt "$forecast_temp" ]; then
        trend=""
    elif [ "$forecast_temp" -gt "$current_temp" ]; then
        trend=""
    else
        trend=""
    fi

    echo "$(get_icon "$current_icon") $current_temp$SYMBOL $trend $(get_icon "$forecast_icon") $forecast_temp$SYMBOL"
fi
