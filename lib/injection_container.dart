import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'app/theme/theme_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/explore/data/datasources/nominatim_places_remote_data_source.dart';
import 'features/explore/data/datasources/places_remote_data_source.dart';
import 'features/explore/data/repositories/places_repository_impl.dart';
import 'features/explore/domain/repositories/places_repository.dart';
import 'features/explore/domain/usecases/get_place_details.dart';
import 'features/explore/domain/usecases/search_places.dart';
import 'features/explore/presentation/bloc/explore_bloc.dart';
import 'features/itinerary/data/datasources/itinerary_remote_data_source.dart';
import 'features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'features/itinerary/domain/repositories/itinerary_repository.dart';
import 'features/itinerary/domain/usecases/add_itinerary_item.dart';
import 'features/itinerary/domain/usecases/delete_itinerary_item.dart';
import 'features/itinerary/domain/usecases/get_itinerary_items.dart';
import 'features/itinerary/domain/usecases/update_itinerary_item.dart';
import 'features/itinerary/presentation/bloc/itinerary_bloc.dart';
import 'features/trips/data/datasources/trips_remote_data_source.dart';
import 'features/trips/data/repositories/trips_repository_impl.dart';
import 'features/trips/domain/repositories/trips_repository.dart';
import 'features/trips/domain/usecases/create_trip.dart';
import 'features/trips/domain/usecases/delete_trip.dart';
import 'features/trips/domain/usecases/get_trip.dart';
import 'features/trips/domain/usecases/get_trip_by_id.dart';
import 'features/trips/domain/usecases/update_trip.dart';
import 'features/trips/presentation/bloc/trips_bloc.dart';

final sl = GetIt.instance;
// GetIt.instance gives us the application's GetIt container.
void initializeDependencies() {
  // Firebase/ External service
  //sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<TripsRemoteDataSource>(
    () => TripsRemoteDataSource(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<TripsRepository>(
    () => TripsRepositoryImpl(remoteDataSource: sl<TripsRemoteDataSource>()),
  );

  // trip usecases
  sl.registerLazySingleton<CreateTrip>(() => CreateTrip(sl<TripsRepository>()));

  sl.registerLazySingleton<GetTrips>(() => GetTrips(sl<TripsRepository>()));

  sl.registerLazySingleton<GetTripById>(
    () => GetTripById(sl<TripsRepository>()),
  );

  sl.registerLazySingleton<UpdateTrip>(() => UpdateTrip(sl<TripsRepository>()));

  sl.registerLazySingleton<DeleteTrip>(() => DeleteTrip(sl<TripsRepository>()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(firebaseAuth: sl<FirebaseAuth>()),
  );

  // Use cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl<AuthRepository>()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LogoutUser>(() => LogoutUser(sl<AuthRepository>()));

  sl.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(sl<AuthRepository>()),
  );

  // Auth Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUser: sl<LoginUser>(),
      registerUser: sl<RegisterUser>(),
      logoutUser: sl<LogoutUser>(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );

  // Trip Bloc
  sl.registerFactory<TripsBloc>(
    () => TripsBloc(
      createTrip: sl<CreateTrip>(),
      getTrips: sl<GetTrips>(),
      getTripById: sl<GetTripById>(),
      updateTrip: sl<UpdateTrip>(),
      deleteTrip: sl<DeleteTrip>(),
    ),
  );

  // ====================
  // Explore
  // ====================

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<PlacesRemoteDataSource>(
    () => NominatimPlacesRemoteDataSource(client: sl<http.Client>()),
  );

  sl.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(remoteDataSource: sl<PlacesRemoteDataSource>()),
  );

  sl.registerLazySingleton<SearchPlaces>(
    () => SearchPlaces(sl<PlacesRepository>()),
  );

  sl.registerLazySingleton<GetPlaceDetails>(
    () => GetPlaceDetails(sl<PlacesRepository>()),
  );

  // Explore Bloc
  sl.registerFactory<ExploreBloc>(
    () => ExploreBloc(
      searchPlaces: sl<SearchPlaces>(),
      getPlaceDetails: sl<GetPlaceDetails>(),
    ),
  );

  // ====================
  // Itinerary
  // ====================

  sl.registerFactory<ItineraryBloc>(
    () => ItineraryBloc(
      getItineraryItems: sl(),
      addItineraryItem: sl(),
      updateItineraryItem: sl(),
      deleteItineraryItem: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetItineraryItems(sl()));

  sl.registerLazySingleton(() => AddItineraryItem(sl()));

  sl.registerLazySingleton(() => UpdateItineraryItem(sl()));

  sl.registerLazySingleton(() => DeleteItineraryItem(sl()));

  sl.registerLazySingleton<ItineraryRepository>(
    () => ItineraryRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ItineraryRemoteDataSource>(
    () => ItineraryRemoteDataSourceImpl(firestore: sl()),
  );

  // Theme
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
