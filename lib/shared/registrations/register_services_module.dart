import 'package:get_it/get_it.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/remote/bundle_remote_data_source.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/repositories/bundel_remote_data_source_impl.dart';
import 'package:math_matric/features/sync/domain/services/content_sync_service.dart';
import 'package:math_matric/features/sync/domain/services/content_sync_service_impl.dart';

final getIt = GetIt.instance;

void registerServiceModule() {

  getIt.registerLazySingleton<BundleRemoteDataSource>(
    () => BundleRemoteDataSourceImpl(
      firestore: getIt(),
      subjectRemote: getIt(),
      topicRemote: getIt(),
      levelRemote: getIt(),
      questionRemote: getIt(),
      examPaperRemote: getIt(),
    ),
  );

  getIt.registerLazySingleton<ContentSyncService>(
    () => ContentSyncServiceImpl(
      subjectLocal: getIt(),
      topicLocal: getIt(),
      levelLocal: getIt(),
      questionLocal: getIt(),
      examPaperLocal: getIt(),
      bundleLocal: getIt(), 

      subjectRemote: getIt(), 
      topicRemote: getIt(), 
      levelRemote: getIt(), 
      questionRemote: getIt(), 
      examPaperRemote: getIt(),
      bundleRemote: getIt(),
    ),
  );
}
