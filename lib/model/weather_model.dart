class Weather {
  Coord? _coord;
  List<WeatherModel>? _weather;
  Main? _main;
  Wind? _wind;
  Clouds? _clouds;
  Sys? _sys;
  String? _base;
  int? _visibility;
  int? _dt;
  int? _timezone;
  int? _id;
  String? _name;
  int? _cod;

  Weather({
    Coord? coord,
    List<WeatherModel>? weather,
    Main? main,
    Wind? wind,
    Clouds? clouds,
    Sys? sys,
    String? base,
    int? visibility,
    int? dt,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) {
    _coord = coord;
    _weather = weather;
    _main = main;
    _wind = wind;
    _clouds = clouds;
    _sys = sys;
    _base = base;
    _visibility = visibility;
    _dt = dt;
    _timezone = timezone;
    _id = id;
    _name = name;
    _cod = cod;
  }

  Coord? get coord => _coord;
  List<WeatherModel>? get weather => _weather;
  Main? get main => _main;
  Wind? get wind => _wind;
  Clouds? get clouds => _clouds;
  Sys? get sys => _sys;
  String? get base => _base;
  int? get visibility => _visibility;
  int? get dt => _dt;
  int? get timezone => _timezone;
  int? get id => _id;
  String? get name => _name;
  int? get cod => _cod;

  Weather.fromJson(Map<String, dynamic> json) {
    _coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;

    if (json['weather'] != null) {
      _weather = [];
      json['weather'].forEach((v) {
        _weather!.add(WeatherModel.fromJson(v)); // ✅ صح
      });
    }

    _base = json['base'];
    _main = json['main'] != null ? Main.fromJson(json['main']) : null;
    _visibility = json['visibility'];
    _wind = json['wind'] != null ? Wind.fromJson(json['wind']) : null;
    _clouds = json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null;
    _dt = json['dt'];
    _sys = json['sys'] != null ? Sys.fromJson(json['sys']) : null;
    _timezone = json['timezone'];
    _id = json['id'];
    _name = json['name'];
    _cod = json['cod'];
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = (json['lon'] as num?)?.toDouble();
    lat = (json['lat'] as num?)?.toDouble();
  }
}

class WeatherModel {
  int? id;
  String? main;
  String? description;
  String? icon;

  WeatherModel({this.id, this.main, this.description, this.icon});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }
}

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? humidity;
  int? seaLevel;
  int? grndLevel;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp = (json['temp'] as num?)?.toDouble();
    feelsLike = (json['feels_like'] as num?)?.toDouble();
    tempMin = (json['temp_min'] as num?)?.toDouble();
    tempMax = (json['temp_max'] as num?)?.toDouble();
    pressure = json['pressure'];
    humidity = json['humidity'];
    seaLevel = json['sea_level'];
    grndLevel = json['grnd_level'];
  }
}

class Wind {
  double? speed;
  int? deg;

  Wind({this.speed, this.deg});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = (json['speed'] as num?)?.toDouble();
    deg = json['deg'];
  }
}

class Clouds {
  int? all;

  Clouds({this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'];
  }
}

class Sys {
  int? type;
  int? id;
  String? country;
  int? sunrise;
  int? sunset;

  Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

  Sys.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }
}
