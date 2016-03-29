OfferMap = L.map('OfferMap')

`
L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: '',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1IjoidmlsbGV0b3UiLCJhIjoiY2ltZGRlaDVrMDAxNnZ6a2tkdWZ4eWxrMyJ9.cc5hlxxy92hT8NwyXMIJdA'
}).addTo(OfferMap);
`

$(document).foundation()
$(document).ready ->

  getLocation((pos)=>
    # Set map location to position
    lat = pos.coords.latitude
    lng = pos.coords.longitude

    OfferMap.setView([lat, lng], 18)

    getVenues(pos).then(
      (venues)->

        `
        venues.forEach(function(venue) {
          L.marker([venue.location.lat, venue.location.lng])
            .bindPopup('<p class="map-popup__title">' + venue.name + '</p>' + '<p>Pizza ja olut 8 euroa!</p><a href="#">Siirry tarjoukseen!</a>')
            .addTo(OfferMap);
        });
        `
        $('body').removeClass('loading')
        $('#LocationCount').text(venues.length)

        console.log venues
    )

  )



# Constants
FS_BASE_URL = 'https://api.foursquare.com/v2/venues/search'
CLIENT = {
  ID: 'ALACXFWGU1XEMQICBNALEBIIUIADEBNX1SJI4NDKLTA3Y5YA',
  SECRET: '2ILT1RCBIKENEDYFBCKP5ZFX1E5Q3NJBJTS4L5SBJEV2TJ5Q'
}
VERSION = '20160329'

# Fetch venues
getLocation = (cb)->
  if (navigator.geolocation)
    navigator.geolocation.getCurrentPosition(cb)
  else
    alert('Location not supported. Daymn...')


getVenues = (pos)->
  headers = new Headers({})
  url = FS_BASE_URL + "?ll=#{pos.coords.latitude},#{pos.coords.longitude}&client_id=#{CLIENT.ID}&client_secret=#{CLIENT.SECRET}&v=#{VERSION}"

  return fetch(url, headers)
    .then((resp)-> resp.json() )
    .then(
      (data)->
        data.response.venues
    )
    .catch((error)->
        console.log 'error', error
  )
