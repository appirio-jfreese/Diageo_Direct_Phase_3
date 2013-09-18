public class WTB_GoogleCoordinatesResponseWrapper{
	public String status;	//OK
	public cls_results[] results;
	public class cls_results {
		public String[] types;
		public String formatted_address;	//Toledo, España
		public cls_address_components[] address_components;
		public cls_geometry geometry;
	}

	public class cls_address_components {
		public String long_name;	//Toledo
		public String short_name;	//Toledo
		public String[] types;
	}
	public class cls_geometry {
		public cls_location location;
		public String location_type;	//APPROXIMATE
		public cls_viewport viewport;
		public cls_bounds bounds;
	}
	public class cls_location {
		public Double lat;	//39.8567775
		public Double lng;	//-4.0244759
	}
	public class cls_viewport {
		public cls_southwest southwest;
		public cls_northeast northeast;
	}
	public class cls_southwest {
		public Double lat;	//39.810555
		public Double lng;	//-4.1796354
	}
	public class cls_northeast {
		public Double lat;	//39.925092
		public Double lng;	//-3.8147915
	}
	public class cls_bounds {
		public cls_southwest southwest;
		public cls_northeast northeast;
	}
	public static WTB_GoogleCoordinatesResponseWrapper parse(String json){
		return (WTB_GoogleCoordinatesResponseWrapper) System.JSON.deserialize(json, WTB_GoogleCoordinatesResponseWrapper.class);
	}

	static testMethod void testParse() {
		String json=		'{'+
		'  "status": "OK",'+
		'  "results": [ {'+
		'    "types": [ "locality", "political" ],'+
		'    "formatted_address": "Toledo, España",'+
		'    "address_components": [ {'+
		'      "long_name": "Toledo",'+
		'      "short_name": "Toledo",'+
		'      "types": [ "locality", "political" ]'+
		'    }, {'+
		'      "long_name": "Toledo",'+
		'      "short_name": "TO",'+
		'      "types": [ "administrative_area_level_2", "political" ]'+
		'    }, {'+
		'      "long_name": "Castilla-La Mancha",'+
		'      "short_name": "CM",'+
		'      "types": [ "administrative_area_level_1", "political" ]'+
		'    }, {'+
		'      "long_name": "España",'+
		'      "short_name": "ES",'+
		'      "types": [ "country", "political" ]'+
		'    } ],'+
		'    "geometry": {'+
		'      "location": {'+
		'        "lat": 39.8567775,'+
		'        "lng": -4.0244759'+
		'      },'+
		'      "location_type": "APPROXIMATE",'+
		'      "viewport": {'+
		'        "southwest": {'+
		'          "lat": 39.7882200,'+
		'          "lng": -4.1525353'+
		'        },'+
		'        "northeast": {'+
		'          "lat": 39.9252666,'+
		'          "lng": -3.8964165'+
		'        }'+
		'      },'+
		'      "bounds": {'+
		'        "southwest": {'+
		'          "lat": 39.8105550,'+
		'          "lng": -4.1796354'+
		'        },'+
		'        "northeast": {'+
		'          "lat": 39.9250920,'+
		'          "lng": -3.8147915'+
		'        }'+
		'      }'+
		'    }'+
		'  } ]'+
		'}';
		WTB_GoogleCoordinatesResponseWrapper obj = parse(json);
		System.debug('obj:'+obj);
		System.assert(obj != null);
	}
}