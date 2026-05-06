"use client";

import { useEffect } from "react";
import { getFCMToken } from "@/lib/notifications";
import { saveFcmToken } from "@/lib/serverActions/saveFcmToken";

export default function AppInit() {
    useEffect(() => {
        async function init() {
            if ("serviceWorker" in navigator) {
                const registration = await navigator.serviceWorker.register(
                    "/firebase-messaging-sw.js"
                );

                console.log(registration);

                await navigator.serviceWorker.ready;

                const token = await getFCMToken(registration);

                if (token) {
                    const savedToken = localStorage.getItem("fcm_token");

                    if (savedToken !== token) {
                        await saveFcmToken(token);
                        localStorage.setItem("fcm_token", token);
                    }
                }
            }
        }

        init();
    }, []);
    return null;
}