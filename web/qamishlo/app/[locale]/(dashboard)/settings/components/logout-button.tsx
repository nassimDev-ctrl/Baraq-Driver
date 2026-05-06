"use client";

import { useTranslations } from "next-intl";
import { Button } from "@/components/ui/button";
import { LogOut } from "lucide-react";
import { Logout } from "@/lib/actions";

export default function LogoutButton() {
    const t = useTranslations("settingsPage.logout");

    const handleLogout = async () => {
        localStorage.removeItem("fcm_token");
        Logout();
    };

    return (
        <Button variant="destructive" onClick={handleLogout}>
            <LogOut className="w-4 h-4 me-2" />
            {t("button")}
        </Button>
    );
}