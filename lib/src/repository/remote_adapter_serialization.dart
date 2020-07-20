part of flutter_data;

mixin _RemoteAdapterSerialization<T extends DataSupport<T>>
    on _RemoteAdapter<T> {
  @override
  Map<String, dynamic> serialize(T model) {
    final map = localAdapter.serialize(model);

    final relationships = <String, dynamic>{};

    for (final relEntry in localAdapter.relationshipsFor().entries) {
      final field = relEntry.key;
      final key = keyForField(field);
      if (map[field] != null) {
        if (relEntry.value['kind'] == 'HasMany') {
          final dataIdKeys = List<String>.from(map[field] as Iterable);
          relationships[key] = dataIdKeys.map(graph.getId).toList();
        } else if (relEntry.value['kind'] == 'BelongsTo') {
          final dataIdKey = map[field].toString();
          relationships[key] = graph.getId(dataIdKey);
        }
      }
      map.remove(field);
    }

    return map..addAll(relationships);
  }

  @override
  DeserializedData<T, DataSupport<dynamic>> deserialize(dynamic data,
      {String key, bool init}) {
    final result = DeserializedData<T, DataSupport<dynamic>>([], included: []);
    init ??= false;

    Object addIncluded(id, RemoteAdapter adapter) {
      if (id is Map) {
        final data =
            adapter.deserialize(id as Map<String, dynamic>, init: init);
        result.included
          ..add(data.model)
          ..addAll(data.included);
        return data.model.id;
      }
      return id;
    }

    if (data is Map) {
      data = [data];
    }

    for (final mapIn in (data as Iterable)) {
      final mapOut = <String, dynamic>{};

      final relationshipKeys = localAdapter.relationshipsFor().keys;

      for (final mapInKey in mapIn.keys) {
        final mapOutKey = fieldForKey(mapInKey.toString());

        if (relationshipKeys.contains(mapOutKey)) {
          final metadata = localAdapter.relationshipsFor()[mapOutKey];
          final _type = metadata['type'] as String;

          if (metadata['kind'] == 'BelongsTo') {
            final id = addIncluded(mapIn[mapInKey], adapters[_type]);
            // transform ids into keys
            mapOut[mapOutKey] = graph.getKeyForId(_type, id,
                keyIfAbsent: DataHelpers.generateKey(_type));
          }

          if (metadata['kind'] == 'HasMany') {
            mapOut[mapOutKey] = (mapIn[mapInKey] as Iterable)?.map((id) {
              id = addIncluded(id, adapters[_type]);
              return graph.getKeyForId(_type, id,
                  keyIfAbsent: DataHelpers.generateKey(_type));
            })?.toImmutableList();
          }
        } else {
          // regular field mapping
          mapOut[mapOutKey] = mapIn[mapInKey];
        }
      }

      final model = localAdapter.deserialize(mapOut);
      if (init) {
        model._initialize(adapters, key: key, save: true);
      }
      result.models.add(model);
    }

    return result;
  }

  @protected
  String get identifierSuffix => '_id';

  Map<String, Map<String, Object>> get _belongsTos =>
      Map.fromEntries(localAdapter
          .relationshipsFor()
          .entries
          .where((e) => e.value['kind'] == 'BelongsTo'));

  @protected
  @visibleForTesting
  String fieldForKey(String key) {
    if (key.endsWith(identifierSuffix)) {
      final keyWithoutId = key.substring(0, key.length - 3);
      if (_belongsTos.keys.contains(keyWithoutId)) {
        return keyWithoutId;
      }
    }
    return key;
  }

  @protected
  @visibleForTesting
  String keyForField(String field) {
    if (_belongsTos.keys.contains(field)) {
      return '$field$identifierSuffix';
    }
    return field;
  }
}