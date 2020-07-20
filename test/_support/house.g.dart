// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

House _$HouseFromJson(Map<String, dynamic> json) {
  return House(
    id: json['id'] as String,
    address: json['address'] as String,
    owner: json['owner'] == null
        ? null
        : BelongsTo.fromJson(json['owner'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HouseToJson(House instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'owner': instance.owner,
    };

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: unused_local_variable, always_declare_return_types, non_constant_identifier_names, invalid_use_of_protected_member

mixin $HouseLocalAdapter on LocalAdapter<House> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([House model]) => {
        'owner': {
          'inverse': 'residence',
          'type': 'families',
          'kind': 'BelongsTo',
          'instance': model?.owner
        }
      };

  @override
  deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return _$HouseFromJson(map);
  }

  @override
  serialize(model) => _$HouseToJson(model);
}

// ignore: must_be_immutable
class $HouseHiveLocalAdapter = HiveLocalAdapter<House> with $HouseLocalAdapter;

class $HouseRemoteAdapter = RemoteAdapter<House> with NothingMixin;

//

final housesLocalAdapterProvider = Provider<LocalAdapter<House>>((ref) =>
    $HouseHiveLocalAdapter(
        ref.read(hiveLocalStorageProvider), ref.read(graphProvider)));

final housesRemoteAdapterProvider = Provider<RemoteAdapter<House>>(
    (ref) => $HouseRemoteAdapter(ref.read(housesLocalAdapterProvider)));

final housesRepositoryProvider =
    Provider<Repository<House>>((_) => Repository<House>());

extension HouseX on House {
  House init([owner]) {
    if (owner == null && debugGlobalServiceLocatorInstance != null) {
      return debugInit(
          debugGlobalServiceLocatorInstance.get<Repository<House>>());
    }
    return debugInit(owner.ref.read(housesRepositoryProvider));
  }
}

extension HouseRepositoryX on Repository<House> {}