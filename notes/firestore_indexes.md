# In firestore.indexes.json:

{
  "indexes": [
    {
      "collectionGroup": "tutorPayouts",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "providerPayoutId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "updatedAt",
          "order": "ASCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": []
}

# This matches:
.where("status", "==", PayoutStatus.processing)
.where("providerPayoutId", "==", null)
.where("updatedAt", "<=", cutoff)

# To Deploy:
firebase deploy --only firestore:indexes