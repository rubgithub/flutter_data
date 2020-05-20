// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// DataGenerator
// **************************************************************************

// ignore_for_file: unused_local_variable
// ignore_for_file: always_declare_return_types
mixin _$HouseModelAdapter on Repository<House> {
  @override
  Map<String, Map<String, Object>> relationshipsFor(House model) => {
        'families': {'inverse': 'house', 'instance': model?.families}
      };

  @override
  Map<String, Repository> get relatedRepositories =>
      {'families': manager.locator<Repository<Family>>()};

  @override
  localDeserialize(map, {metadata}) {
    for (var key in relationshipsFor(null).keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key), manager]
      };
    }
    return _$HouseFromJson(map);
  }

  @override
  localSerialize(model) {
    final map = _$HouseToJson(model);
    for (var e in relationshipsFor(model).entries) {
      map[e.key] = (e.value['instance'] as Relationship)?.toJson();
    }
    return map;
  }
}

class $HouseRepository = Repository<House>
    with _$HouseModelAdapter, RemoteAdapter<House>, WatchAdapter<House>;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

House _$HouseFromJson(Map<String, dynamic> json) {
  return House(
    id: json['id'] as String,
    address: json['address'] as String,
    families: json['families'] == null
        ? null
        : HasMany.fromJson(json['families'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HouseToJson(House instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'families': instance.families,
    };
