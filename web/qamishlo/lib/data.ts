"use server";
import { cookies } from "next/headers";
import { redirect } from "@/i18n/navigation";

const API_DOMAIN = process.env.API_DOMAIN!;

export const getCurrentAdmin = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    if (!token) redirect({
        href: "/login",
        locale: lang ?? "ar",
    });
    const url = `${API_DOMAIN}/admins/get-profile`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
        cache: "no-store",
    })
    if (response.status === 401 || response.status === 403) {
        redirect({
            href: "/login?session=expired",
            locale: lang ?? "ar",
        });
    }
    if (response.ok) {
        const data = await response.json()
        return data.admin;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getPermissions = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/permissions`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.permissions;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getGroups = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/groups/`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.groups;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getRoles = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/roles/`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.roles;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getStatistics = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/statistics`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.statistics;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getAdmins = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/admins/`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getCommission = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/commissions/get`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getAllCities = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/cities`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.cities;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getCarCategories = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/car-categories`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.carCategories;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getNotifications = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/notifications`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.notifications;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getDriversBalanceHistory = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/balance-operations`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.operations;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getDiscountCodes = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/discount-codes/`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.discountCodes;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getComplaints = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/complains/get-all`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getAllEmergencies = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/trips/get-all-emergencies`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getClients = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/clients`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.clients;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getDrivers = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/drivers`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.drivers;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getDriverBalanceOperations = async (id: string) => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/balance-operations/driver/${id}`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.operations;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getDriver = async (id: string) => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/drivers/get-single-driver/${id}`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.driver;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getCompletedTrips = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/trips/get-all-completed-trips`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getOngoingTrips = async () => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/trips/get-all-started-trips`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getClientTrips = async (id: string) => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/trips/get-all-client-trips/${id}`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getClientUsedDiscountCodes = async (id: string) => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/clients/get-client-discount-codes/${id}`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.discountCodes;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getDriverTrips = async (id: string) => {
    const lang = ((await cookies()).get("NEXT_LOCALE")?.value);
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/trips/get-all-driver-trips/${id}`
    const response = await fetch(url, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    })
    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
}

export const getRevenueReport = async () => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const response = await fetch(`${API_DOMAIN}/reports/revenue`, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "en",
        },
        cache: "no-store",
    });

    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
};

export const getCashCollection = async () => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const response = await fetch(`${API_DOMAIN}/reports/cash-collection`, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "en",
        },
        cache: "no-store",
    });

    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
};

export const getTripsByCity = async () => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const response = await fetch(`${API_DOMAIN}/reports/cities`, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "en",
        },
        cache: "no-store",
    });

    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
};

export const getTripComparison = async () => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const response = await fetch(`${API_DOMAIN}/reports/trip-comparison`, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "en",
        },
        cache: "no-store",
    });

    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
};

export const getDriversPerformance = async () => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const response = await fetch(`${API_DOMAIN}/reports/drivers-performance`, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "en",
        },
        cache: "no-store",
    });

    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
};

export const getDashboardStats = async () => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const response = await fetch(`${API_DOMAIN}/reports/dashboard`, {
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "en",
        },
        cache: "no-store",
    });

    if (response.ok) {
        const data = await response.json()
        return data.data;
    }
    else {
        return { status: false, message: response.statusText, data: [] }
    }
};

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