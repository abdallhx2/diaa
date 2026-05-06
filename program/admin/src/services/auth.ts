import { initializeApp, getApps } from 'firebase/app';
import {
  getAuth,
  signInWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged as firebaseOnAuthStateChanged,
  User,
} from 'firebase/auth';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
};

const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];
const auth = getAuth(app);

export async function signIn(email: string, password: string): Promise<User> {
  const userCredential = await signInWithEmailAndPassword(auth, email, password);
  return userCredential.user;
}

export async function signOut(): Promise<void> {
  await firebaseSignOut(auth);
}

export function getCurrentUser(): User | null {
  return auth.currentUser;
}

export async function getIdToken(): Promise<string | null> {
  const user = auth.currentUser;
  if (!user) return null;
  return await user.getIdToken();
}

export function onAuthStateChanged(callback: (user: User | null) => void): () => void {
  return firebaseOnAuthStateChanged(auth, callback);
}
