"use client";

import { useEffect } from "react";
import { listenToMessages } from "@/lib/listener";

export default function NotificationListener() {
    console.log("push notification listener initialized");
    useEffect(() => {
        listenToMessages();
    }, []);

    return null;
}