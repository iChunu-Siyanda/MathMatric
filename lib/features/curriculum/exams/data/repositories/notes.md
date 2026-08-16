# Firebase storage:
exam-papers/
└── mathematics/
    └── grade-12/
        └── 2025/
            └── november/
                └── national/
                    └── paper-1/
                        ├── p-01.webp
                        ├── p-02.webp
                        └── ...
ExamPaper folder example path: exam-papers/mathematics/grade-12/2025/november/national/paper-1                        

# Application Support:
Then download into:
Application Support/
└── exam_papers/
    └── {paperId}/
        ├── p-01.webp
        └── ...    

# Exam paper architecture:
                 FIREBASE
                    │
          ┌─────────┴─────────┐
          │                   │
      Firestore          Firebase Storage
          │                   │
   paper metadata         WebP pages
          │                   │
          ↓                   ↓
 ExamPaperRemote       RemoteStorage
 DataSource              DataSource
          │                   │
          ↓                   ↓
       Drift             Local Storage
    metadata              WebP files
          │                   │
          └─────────┬─────────┘
                    ↓
          ExamPaperStorageRepository

Initial curriculum bundle does not download the WebPs. It downloads(Metadata):
ExamPaperModel
├── id
├── subjectId
├── year
├── session
├── paperType
├── pageCount
├── storagePath
└── downloaded = false
