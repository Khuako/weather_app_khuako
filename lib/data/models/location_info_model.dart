import 'package:xml/xml.dart';

class LocationInfoModel {
  final String? timestamp;
  final String? attribution;
  final String? queryString;
  final Result? result;
  final AddressParts? addressParts;

  LocationInfoModel({
    this.timestamp,
    this.attribution,
    this.queryString,
    this.result,
    this.addressParts,
  });

  // Метод для создания объекта из XML
  factory LocationInfoModel.fromXml(XmlElement xml) {
    return LocationInfoModel(
      timestamp: xml.getAttribute('timestamp'),
      attribution: xml.getAttribute('attribution'),
      queryString: xml.getAttribute('querystring'),
      result: xml.getElement('result') != null
          ? Result.fromXml(xml.getElement('result')!)
          : null,
      addressParts: xml.getElement('addressparts') != null
          ? AddressParts.fromXml(xml.getElement('addressparts')!)
          : null,
    );
  }

  // Преобразование объекта обратно в XML
  String toXml() {
    final builder = XmlBuilder();
    builder.element('reversegeocode', nest: () {
      builder.attribute('timestamp', timestamp ?? '');
      builder.attribute('attribution', attribution ?? '');
      builder.attribute('querystring', queryString ?? '');
      if (result != null) {
        builder.element('result', nest: () => result!.toXml(builder));
      }
      if (addressParts != null) {
        builder.element('addressparts', nest: () => addressParts!.toXml(builder));
      }
    });
    return builder.buildDocument().toXmlString(pretty: true);
  }
}

class Result {
  final String? placeId;
  final String? osmType;
  final String? osmId;
  final String? lat;
  final String? lon;
  final String? boundingBox;
  final String? placeRank;
  final String? addressRank;
  final String? displayName;

  Result({
    this.placeId,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.boundingBox,
    this.placeRank,
    this.addressRank,
    this.displayName,
  });

  // Создание объекта из XML
  factory Result.fromXml(XmlElement xml) {
    return Result(
      placeId: xml.getAttribute('place_id'),
      osmType: xml.getAttribute('osm_type'),
      osmId: xml.getAttribute('osm_id'),
      lat: xml.getAttribute('lat'),
      lon: xml.getAttribute('lon'),
      boundingBox: xml.getAttribute('boundingbox'),
      placeRank: xml.getAttribute('place_rank'),
      addressRank: xml.getAttribute('address_rank'),
      displayName: xml.text,
    );
  }

  // Преобразование объекта в XML
  void toXml(XmlBuilder builder) {
    builder
      ..attribute('place_id', placeId ?? '')
      ..attribute('osm_type', osmType ?? '')
      ..attribute('osm_id', osmId ?? '')
      ..attribute('lat', lat ?? '')
      ..attribute('lon', lon ?? '')
      ..attribute('boundingbox', boundingBox ?? '')
      ..attribute('place_rank', placeRank ?? '')
      ..attribute('address_rank', addressRank ?? '');
    builder.text(displayName ?? '');
  }
}

class AddressParts {
  final String? road;
  final String? hamlet;
  final String? town;
  final String? city;
  final String? iso3166Lvl8;
  final String? stateDistrict;
  final String? state;
  final String? iso3166Lvl4;
  final String? postcode;
  final String? country;
  final String? countryCode;

  AddressParts({
    this.road,
    this.hamlet,
    this.town,
    this.city,
    this.iso3166Lvl8,
    this.stateDistrict,
    this.state,
    this.iso3166Lvl4,
    this.postcode,
    this.country,
    this.countryCode,
  });

  // Создание объекта из XML
  factory AddressParts.fromXml(XmlElement xml) {
    return AddressParts(
      road: xml.getElement('road')?.text,
      hamlet: xml.getElement('hamlet')?.text,
      town: xml.getElement('town')?.text,
      city: xml.getElement('city')?.text,
      iso3166Lvl8: xml.getElement('ISO3166-2-lvl8')?.text,
      stateDistrict: xml.getElement('state_district')?.text,
      state: xml.getElement('state')?.text,
      iso3166Lvl4: xml.getElement('ISO3166-2-lvl4')?.text,
      postcode: xml.getElement('postcode')?.text,
      country: xml.getElement('country')?.text,
      countryCode: xml.getElement('country_code')?.text,
    );
  }

  // Преобразование объекта в XML
  void toXml(XmlBuilder builder) {
    builder.element('road', nest: road ?? '');
    builder.element('hamlet', nest: hamlet ?? '');
    builder.element('town', nest: town ?? '');
    builder.element('city', nest: city ?? '');
    builder.element('ISO3166-2-lvl8', nest: iso3166Lvl8 ?? '');
    builder.element('state_district', nest: stateDistrict ?? '');
    builder.element('state', nest: state ?? '');
    builder.element('ISO3166-2-lvl4', nest: iso3166Lvl4 ?? '');
    builder.element('postcode', nest: postcode ?? '');
    builder.element('country', nest: country ?? '');
    builder.element('country_code', nest: countryCode ?? '');
  }
}
