// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$seedServiceHash() => r'16efe66128b29b2f5b554342a2212afe0bcfc991';

/// See also [seedService].
@ProviderFor(seedService)
final seedServiceProvider = Provider<SeedService>.internal(
  seedService,
  name: r'seedServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$seedServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SeedServiceRef = ProviderRef<SeedService>;
String _$seedNotifierHash() => r'38353f5aa0e25886e9d97e5fcc343be184d7b20e';

/// See also [SeedNotifier].
@ProviderFor(SeedNotifier)
final seedNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SeedNotifier, SeedState>.internal(
  SeedNotifier.new,
  name: r'seedNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$seedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SeedNotifier = AutoDisposeAsyncNotifier<SeedState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
