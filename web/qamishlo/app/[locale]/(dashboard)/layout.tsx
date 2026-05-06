import AppBar from "@/components/app-bar";
import { AppSidebar } from "@/components/app-sidebar";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { TooltipProvider } from "@/components/ui/tooltip";
import { redirect } from "@/i18n/navigation";

import { getCurrentAdmin } from "@/lib/data";
import { getLocale } from "next-intl/server";

import { ReactNode } from "react";

export default async function DashboardLayout({ children }: { children: ReactNode }) {
    const admin = await getCurrentAdmin();
    const locale = await getLocale();
    if (admin.message === "Unauthorized") redirect({
        href: "/login",
        locale: locale
    });
    return (
        <main>
            <SidebarProvider>
                <TooltipProvider>
                    <AppSidebar />
                </TooltipProvider>
                <SidebarInset>
                    <div className="w-full px-4 min-h-screen bg-white">
                        <AppBar admin={admin} />
                        <div className="h-[calc(100%-90px)] bg-background rounded-xl p-4 my-4 shadow-xl overflow-x-auto">
                            {children}
                        </div>
                    </div>
                </SidebarInset>
            </SidebarProvider>
        </main>
    )
}