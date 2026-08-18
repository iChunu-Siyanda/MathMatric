# Download pipeline:

                 Firebase
                    │
          ┌─────────┴─────────┐
          │                   │
      Firestore           Storage
          │                   │
    Curriculum data       WebP pages
          │
          ▼
 BundleRemoteDataSource
          │
          ▼
   CurriculumBundle
          │
          ▼
 CurriculumBundleRepository
          │
          ▼
 CurriculumBundleLocalDataSource
          │
          ▼
    Drift transaction
     ├─ Subjects
     ├─ Topics
     ├─ Levels
     ├─ Questions
     └─ Exam Papers
          │
          ▼
   DownloadedBundle

# Overall Architecture:
                    Firebase
                       │
          ┌────────────┴────────────┐
          │                         │
      Firestore                  Storage
          │                         │
    Curriculum metadata         Exam pages
          │                         │
          ▼                         ▼
    Remote Datasources        Remote Storage
          │                         │
          └────────────┬────────────┘
                       │
                  Repositories
                       │
                       ▼
                     Drift
                       │
             ┌─────────┴─────────┐
             │                   │
       Curriculum data      Downloaded papers               

       