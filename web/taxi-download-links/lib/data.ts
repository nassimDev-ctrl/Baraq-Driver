"use server";

export const getDriverAppInfo = async () => {
    const API_DOMAIN =
        process.env.NEXT_PUBLIC_API_DOMAIN;

    try {
        const res = await fetch(`${API_DOMAIN}/versions/driver`, {
            method: "GET",
            cache: "no-store",
            headers: {
                "Content-Type": "application/json",
                "Accept-Language": "ar",
            },
        });

        const data = await res.json();
        if (!res.ok) {
            return {
                status: false,
                message: data.message || "Request failed",
                data: [],
            };
        }

        return data.version;
    } catch {
        return {
            status: false,
            message: "Network error",
            data: [],
        };
    }
};

export const getClientAppInfo = async () => {
    const API_DOMAIN =
        process.env.NEXT_PUBLIC_API_DOMAIN;

    try {
        const res = await fetch(`${API_DOMAIN}/versions/client`, {
            method: "GET",
            cache: "no-store",
            headers: {
                "Content-Type": "application/json",
                "Accept-Language": "ar",
            },
        });

        const data = await res.json();
        if (!res.ok) {
            return {
                status: false,
                message: data.message || "Request failed",
                data: [],
            };
        }

        return data.version;
    } catch {
        return {
            status: false,
            message: "Network error",
            data: [],
        };
    }
};