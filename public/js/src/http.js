function get(url, callback) {
  var request = new XMLHttpRequest();

  request.open("GET", url, true);
  request.onload = function(e) {
    if (request.readyState === 4) {
      if (request.status >= 200 && request.status < 400) {
        var data = JSON.parse(request.responseText);
        if (typeof callback === "function") {
          callback(data);
        }
        else {

        }
      }
    }
    else {
      console.log(request.statusText);
    }
  };

  request.onerror = function() {};
  request.send(null);
}