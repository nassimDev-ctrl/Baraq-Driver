import { getToken } from "firebase/messaging";
import { messaging } from "./firebase";

export async function getFCMToken(registration?: ServiceWorkerRegistration) {
    if (!messaging) {
        console.log("Messaging not initialized");
        return null;
    }

    try {
        const permission = await Notification.requestPermission();
        if (permission !== "granted") {
            console.log("Permission denied");
            return null;
        }

        const token = await getToken(messaging, {
            vapidKey: process.env.NEXT_PUBLIC_FIREBASE_VAPID_KEY,
            serviceWorkerRegistration: registration,
        });

        console.log("FCM Token:", token);
        return token;
    } catch (error) {
        console.error("Error getting token:", error);
    }
}