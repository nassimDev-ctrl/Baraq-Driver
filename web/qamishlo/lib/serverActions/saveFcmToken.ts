"use server";

import { cookies } from "next/headers";

const API_DOMAIN = process.env.API_DOMAIN;

export async function saveFcmToken(token: string) {
    if (!token) return;

    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const auth_token = ((await cookies()).get("auth_token")?.value);
    const url = `${API_DOMAIN}/admins/update-fcm`;

    try {
        const res = await fetch(url, {
            method: "PUT",
            headers: {
                Authorization: `Bearer ${auth_token}`,
                "Accept-Language": lang ?? "ar",
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                fcm: token
            }),
        });


        console.log("res: ", res.ok);

        if (!res.ok) {
            throw new Error("Failed to save FCM token");
        }

        console.log("FCM token sent to backend successfully");
    } catch (error) {
        console.error("Error sending FCM token:", error);
    }
}