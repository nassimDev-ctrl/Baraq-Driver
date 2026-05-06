"use server";
import { redirect } from "@/i18n/navigation";
import { CreateAdminSchemaType, CreateCategorySchemaType, CreateDiscountCodeSchemaType, CreateNotificationPayload, loginFormSchemaType, PostNotificationSchemaType, UpdateCategorySchemaType, UpdateDiscountCodeType, UpdateDriverSchemaType } from "@/schemas/schemas";
import { revalidatePath } from "next/cache";
import { cookies, headers } from "next/headers";


const API_DOMAIN = process.env.API_DOMAIN;

export async function login(payload: loginFormSchemaType) {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    try {
        const response = await fetch(
            `${API_DOMAIN}/admins/login`,
            {
                method: "POST",
                headers: {
                    "Accept-Language": lang ?? "ar",
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(payload),
                cache: "no-store",
            }
        );

        const result = await response.json();

        if (!response.ok || !result.success) {
            return {
                status: false,
                message: result.message ?? "Login failed",
            };
        }

        (await cookies()).set("auth_token", result.data.token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === "production",
            sameSite: "lax",
            path: "/",
            maxAge: 60 * 60 * 24 * 7, // 7 days
        });

        return {
            status: true,
            user: result.data.admin,
        };
    } catch {
        return {
            status: false,
            message: "Network error",
        };
    }
}

export async function Logout() {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const c = await cookies();
    c.delete("auth_token");
    redirect({
        href: "/login",
        locale: lang ?? "ar",
    });
}

export const createNewGroup = async (name: string, permissions_ids: string[]) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/groups/create`;

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            name,
            permissions: permissions_ids,
        })
    });
    if (response.ok) {
        revalidatePath("/groups");
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const deleteGroup = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/groups/delete/${id}`;

    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath("/groups");
        return {
            status: true,
            message: response.statusText,
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateGroupPermissions = async (groupId: string, add: string[], remove: string[]) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/groups/update-permissions/${groupId}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            add,
            remove
        })
    });
    if (response.ok) {
        revalidatePath("/groups");
        return {
            status: true,
            message: response.statusText,
        };
    }
    else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const createNewRole = async (name: string, groups_ids: string[]) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/roles/create`;

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            name,
            groups: groups_ids
        })
    });

    if (response.ok) {
        revalidatePath("/roles");
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const deleteRole = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/roles/delete/${id}`;

    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath("/roles");
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateRoleGroups = async (roleId: string, add: string[], remove: string[]) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/roles/update-groups/${roleId}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            add,
            remove
        })
    });
    if (response.ok) {
        revalidatePath("/roles");
        return {
            status: true,
            message: response.statusText,
        };
    }
    else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const addAdmin = async (payload: CreateAdminSchemaType) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/admins/create`;

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            ...payload
        })
    });

    if (response.ok) {
        revalidatePath("/employees");
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateAdminRoles = async (adminId: string, add: string[], remove: string[]) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/admins/update-roles/${adminId}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            add,
            remove
        })
    });
    if (response.ok) {
        revalidatePath("/employees");
        return {
            status: true,
            message: response.statusText,
        };
    }
    else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const deleteAdmin = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/admins/delete/${id}`;

    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath("/employees");
        return {
            status: true,
            message: "Deleted Admin Successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateCommissionPercentage = async (id: string, commission: number) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const heads = await headers()
    const currentPath = heads.get("referer")
    const url = `${API_DOMAIN}/commissions/update-percentage/${id}`;
    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            commissionPercentage: commission
        })
    });

    if (response.ok) {
        revalidatePath(currentPath!);
        return {
            status: true,
            message: response.statusText
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateMinTripPrice = async (id: string, minPrice: number) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;
    const heads = await headers()
    const currentPath = heads.get("referer")
    const url = `${API_DOMAIN}/commissions/update-min-price/${id}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            minPriceOfTrip: minPrice
        }),
    });

    if (response.ok) {
        revalidatePath(currentPath!);
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
};

export const updateAdminPassword = async (newPassword: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/admins/reset-password`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            newPassword
        })
    });
    if (response.ok) {
        return {
            status: true,
            message: response.statusText,
        };
    }
    else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const toggleCityStatus = async (id: string, toggle: boolean) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/cities/update-status/${id}`;
    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            status: toggle
        })
    });
    if (response.ok) {
        revalidatePath("/gouvernorats");
        return {
            status: true,

            message: response.statusText,
        };
    }
    else {
        let error;
        try {
            error = await response.json();
        }
        catch {
            error = { message: response.statusText };
        }
        return {
            status: false,

            message: error.message ?? response.statusText,
        };
    }
}

export const addCity = async (payload: {
    nameEn: string;
    nameAr: string;
    nameKu: string;
}) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const url = `${API_DOMAIN}/cities/create`;

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify(payload),
    });

    if (response.ok) {
        revalidatePath("/cities");
        return {
            status: true,
            message: "City created successfully",
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }

        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
};

export const createCategory = async (payload: CreateCategorySchemaType) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;
    const url = `${API_DOMAIN}/car-categories/create`;

    const formData = new FormData();
    formData.append("nameAr", payload.nameAr);
    formData.append("nameEn", payload.nameEn);
    formData.append("nameKu", payload.nameKu);
    formData.append("price", payload.price.toString());
    formData.append("category_image", payload.category_image);

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
        body: formData,
    });

    if (response.ok) {
        const data = await response.json();
        console.log(data);
        revalidatePath("/categories");
        return {
            status: true,
            data,
            message: "Category created successfully",
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }

        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
};

export const updateCategory = async (id: string, payload: UpdateCategorySchemaType) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/car-categories/update/${id}`;

    const formData = new FormData();
    formData.append("nameAr", payload.nameAr);
    formData.append("nameEn", payload.nameEn);
    formData.append("nameKu", payload.nameKu);
    formData.append("price", payload.price.toString());
    if (payload.category_image !== undefined) {
        formData.append("category_image", payload.category_image);
    }

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
        body: formData,
    });

    if (response.ok) {
        revalidatePath(`/categories`);
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const deleteCategory = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/car-categories/delete/${id}`;

    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath("/categories");
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const postNotification = async (data: PostNotificationSchemaType) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;
    const url = `${API_DOMAIN}/notifications/create`;

    const payload = {
        titleAr: data.titleAr,
        titleEn: data.titleEn,
        titleKu: data.titleKu,
        messageAr: data.messageAr,
        messageEn: data.messageEn,
        messageKu: data.messageKu,
        usersType:
            data.target === "all"
                ? "All"
                : data.target === "clients"
                    ? "client"
                    : "driver",
        cities: !data.cities || data.cities.length === 0 ? "All" : data.cities,
        categories: data?.categories || [],
    } satisfies CreateNotificationPayload;

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify(payload),
    });

    if (response.ok) {
        const data = await response.json();
        revalidatePath("/notifications");
        return { status: true, data };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return { status: false, message: error.message ?? response.statusText };
    }
};

export const createDiscountCode = async (
    payload: CreateDiscountCodeSchemaType
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const url = `${API_DOMAIN}/discount-codes/create`;

    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify(payload),
    });

    if (response.ok) {
        revalidatePath("/discount_codes");

        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }

        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
};

export const deleteDiscountCode = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/discount-codes/delete/${id}`;

    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath("/discount_codes");
        return {
            status: true,
            message: "Deleted Admin Successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateDiscountCode = async (id: string, payload: UpdateDiscountCodeType) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/discount-codes/update/${id}`;

    const body = {
        ...payload
    }

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify(body)
    });

    if (response.ok) {
        revalidatePath("/discount_codes");
        return {
            status: true,
            message: "Updates Discount Code Successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const markComplainAsRead = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/complains/mark-as-read/${id}`;
    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });

    if (response.ok) {
        revalidatePath(`/complaints`);
        return {
            status: true,
            message: "Mark as read successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const deleteClient = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/clients/delete/${id}`;
    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    });
    console.log(response);
    if (response.ok) {
        revalidatePath("/clients");
        return {
            status: true,
            message: response.statusText
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

//* NOTE: this function is for blocking both clients and drivers
export const blockUser = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const heads = await headers()
    const currentPath = heads.get("referer")
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/auth-users/block-user/${id}`;

    const response = await fetch(url, {
        method: "GET",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath(currentPath!);
        return {
            status: true,
            message: "Blocked user Successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}
//* NOTE: this function is for un-blocking both clients and drivers
export const UnBlockUser = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const heads = await headers()
    const currentPath = heads.get("referer")
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/auth-users/unblock-user/${id}`;

    const response = await fetch(url, {
        method: "GET",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath(currentPath!);
        return {
            status: true,
            message: "unblocked User Successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}


// * Used for both client and driver because they both inherit from auth user
export const updateClientNumber = async (
    clientId: string,
    phoneNumber: string
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;
    const heads = await headers()
    const currentPath = heads.get("referer")

    const url = `${API_DOMAIN}/auth-users/update-mobile-phone/${clientId}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            mobilePhone: phoneNumber,
        }),
    });

    if (response.ok) {
        revalidatePath(currentPath!);
        return { status: true };
    }

    let error;

    try {
        error = await response.json();
    } catch {
        error = { message: response.statusText };
    }

    return {
        status: false,
        message: error.message ?? response.statusText,
    };
};

export const deleteDriver = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/drivers/delete-driver/${id}`;
    const response = await fetch(url, {
        method: "DELETE",
        headers: {
            Authorization: `Bearer ${token}`,
            "Accept-Language": lang ?? "ar",
        },
    });
    if (response.ok) {
        revalidatePath("drivers");
        return {
            status: true
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const acceptDriver = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/drivers/accept-driver/${id}`;
    const response = await fetch(url, {
        method: "GET",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });

    if (response.ok) {
        revalidatePath(`/drivers/${id}`);
        return {
            status: true,
            message: "Accept driver Code Successfully"
        }
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const rejectDriver = async (
    id: string,
    step: number,
    fieldToUpdate: string,
    message: string
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/drivers/reject-driver/${id}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            step,
            fieldToUpdate,
            message,
        }),
    });

    if (response.ok) {
        revalidatePath(`/drivers/${id}`);
        return {
            status: true,
            message: response.statusText,
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
};


export const acceptDriverChangeCategory = async (id: string) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/drivers/accept-change-category/${id}`;

    const response = await fetch(url, {
        method: "GET",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
    });

    if (response.ok) {
        revalidatePath(`/drivers/${id}`);
        return { status: true, message: response.statusText };
    }

    let error;
    try {
        error = await response.json();
    } catch {
        error = { message: response.statusText };
    }

    return {
        status: false,
        message: error.message ?? response.statusText,
    };
}

export const addDriverBalance = async (
    id: string,
    balance: number
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${API_DOMAIN}/balance-operations/charge-balance/${id}`;
    const response = await fetch(url, {
        method: "POST",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            balance,
        }),
    });

    if (response.ok) {
        revalidatePath(`/drivers/${id}`);
        return {
            status: true,
            message: "Balance added successfully",
        };
    } else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }

        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
};

export const updateDriverCategory = async (
    id: string,
    data: {
        categoryId: string;
    }
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const url = `${API_DOMAIN}/drivers/update-driver-car-category/${id}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            categoryId: data.categoryId,
        }),
    });

    if (response.ok) {
        revalidatePath(`/drivers/${id}`);
        return { status: true };
    }

    let error;
    try {
        error = await response.json();
    } catch {
        error = { message: response.statusText };
    }

    return {
        status: false,
        message: error.message ?? response.statusText,
    };
};

export const updateLanguage = async (lang: string) => {
    const token = (await cookies()).get("auth_token")?.value;
    const language = (await cookies()).get("NEXT_LOCALE")?.value;
    const url = `${API_DOMAIN}/admins/update-language`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": language ?? "ar",
        },
        body: JSON.stringify({
            language: lang === "kmr" ? "ku" : lang
        })
    });

    console.log(response.ok);
    if (response.ok) {
        revalidatePath("/");
        return {
            status: true,
            message: response.statusText,
        };
    }
    else {
        let error;
        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }
        return {
            status: false,
            message: error.message ?? response.statusText,
        };
    }
}

export const updateDriver = async (
    driverId: string,
    data: UpdateDriverSchemaType
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const url = `${API_DOMAIN}/drivers/update-driver-personal-info/${driverId}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            firstName: data.firstName,
            lastName: data.lastName,
            email: data.email,
            emergencyNumber: data.emergencyNumber,
            city: data.city,
            gender: data.gender,
        }),
    });

    if (response.ok) {
        revalidatePath(`/drivers/${driverId}`);
        return { status: true };
    }

    let error;

    try {
        error = await response.json();
    } catch {
        error = { message: response.statusText };
    }

    return {
        status: false,
        message: error.message ?? response.statusText,
    };
};

export const toggleSubCategoryStatus = async (id: string, toggle: boolean) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = ((await cookies()).get("auth_token")?.value)
    const url = `${process.env.API_DOMAIN}/car-categories/update-status/${id}`;
    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            status: toggle
        })
    });
    if (response.ok) {
        revalidatePath("/categories");
    }
    else {
        let error;
        try {
            error = await response.json();
        }
        catch {
            error = { message: response.statusText };
        }
        return {
            status: false,

            message: error.message ?? response.statusText,
        };
    }
}

export const updateAppVersion = async (
    type: "client" | "driver",
    payload: {
        version: string;
        downloadLink: string;
        googlePlayLink?: string;
        appStoreLink?: string;
    }
) => {
    const lang = (await cookies()).get("NEXT_LOCALE")?.value;
    const token = (await cookies()).get("auth_token")?.value;

    const url = `${process.env.API_DOMAIN}/versions/update-version/${type}`;

    const response = await fetch(url, {
        method: "PUT",
        headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
            "Accept-Language": lang ?? "ar",
        },
        body: JSON.stringify({
            type,
            version: payload.version,
            downloadLink: payload.downloadLink,
            googlePlayLink: payload.googlePlayLink,
            appStoreLink: payload.appStoreLink,
        }),
    });

    if (response.ok) {
        revalidatePath("/apps");

        return { status: true };
    } else {
        let error;

        try {
            error = await response.json();
        } catch {
            error = { message: response.statusText };
        }

        return {
            status: false,
            message: error.message ?? "Something went wrong",
        };
    }
};