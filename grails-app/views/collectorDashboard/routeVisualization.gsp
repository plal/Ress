<%--
  Created by IntelliJ IDEA.
  User: Pedro
  Date: 18/10/2016
  Time: 15:19
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="mapsLayout">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../css/table-data.css">

    <style>
    #map_canvas {
        width: 100%;
        height: 100%;
    }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBOVREbzXvmpDVjFX7w5GXciMCWuBbnueM&callback=initMap"
        async defer></script>
    <script type="text/javascript">
        var map;
        var directionsService;
        var directionsDisplay;
        var service;
        var waypts = [];
        waypts.push({
                            location:{lat: -8.05060572, lng: -34.95280063},
                            stopover: false
        });
        waypts.push( {
                            location:{lat: -8.05638996, lng: -34.95334244},
                            stopover: false
        });
        function initMap() {
            var ufpe = {lat: -8.051442, lng:-34.950867};
    		directionsService = new google.maps.DirectionsService;
			directionsDisplay = new google.maps.DirectionsRenderer;
            var mapOptions = {
                center: ufpe,
                zoom: 16,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
            directionsDisplay.setMap(map)
            <g:each in="${enderecos}" status="i" var="endereco">
                var address = '${endereco.street?.encodeAsJavaScript()} ${endereco.city?.encodeAsJavaScript()} ${endereco.cep?.encodeAsJavaScript()}';
                    var nome  = '${endereco.user.name?.encodeAsJavaScript()}';
                    service = new google.maps.places.PlacesService(map);
                    service.textSearch({
                    location: ufpe,
                    radius: 1000,
                    query:  nome + " " + address
                    }, function (results, status) {
                        if (status === google.maps.places.PlacesServiceStatus.OK) {
                            waypts.push( {
                                location: {lat: results[0].latitude, lng: results[0].longitude},
                                stopover: false
                            });

                        }else {
                            geocoder.geocode({'address': address  }, function (results, status) {
                                alert('${endereco.user.name?.encodeAsJavaScript()}')
                                if (status == google.maps.GeocoderStatus.OK) {
                                    waypts.push( {
                                        location: {lat: results[0].latitude, lng: results[0].longitude},
                                        stopover: false
                                    });
                                }
                            });
                        }
                    });
            </g:each>
            route();
        }
        function route() {
            var request = {
                origin: {lat: -8.04902288, lng:-34.94483447},
                destination: {lat: -8.04902288, lng:-34.94483447},
                waypoints: waypts
                /*[
                        {
                            location:{lat: -8.05060572, lng: -34.95280063},
                            stopover: false
                        },

                        {
                            location:{lat: -8.05638996, lng: -34.95334244},
                            stopover: false
                        }
                ]*/,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };
            directionsService.route(request, function(result, status) {
                if(status == google.maps.DirectionsStatus.OK) {
                    directionsDisplay.setDirections(result);
                }
            });
        }
        google.maps.event.addDomListener(window, 'load', initMap());
    </script>


</head>
<body>
<div id="map_canvas"></div>
<div id="panel"></div>
</body>
</body>
</html>