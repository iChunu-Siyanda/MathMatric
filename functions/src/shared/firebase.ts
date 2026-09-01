import {getApps, initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
//This gives our backend access to Firestore using the Admin SDK.
//Unlike the Flutter app, this code runs in the trusted backend environment.

if (getApps().length === 0) {
  initializeApp();
}

export const db = getFirestore();
