"use client";

import { onMessage } from "firebase/messaging";
import { messaging } from "./firebase";
import { toast } from "sonner";

export function listenToMessages() {
    if (!messaging) return;

    onMessage(messaging, (payload) => {
        console.log("Message received: ", payload);

        const title = payload.notification?.title || "Notification";
        const body = payload.notification?.body || "";
        const icon = payload.notification?.icon || "/favicon.ico";
        const url = payload.data?.url || "/emergencies";

        if (Notification.permission === "granted") {
            const notification = new Notification(title || "Notification", {
                body,
                icon
            });

            notification.onclick = () => {
                window.location.href = url;
            };
        }
        toast(title, {
            description: body,
        });
    });
}