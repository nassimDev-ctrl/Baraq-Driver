"use client"

import * as React from "react"

import {
    Sidebar,
    SidebarContent,
    SidebarHeader,
    SidebarMenu,
    SidebarRail,
    SidebarSeparator
} from "@/components/ui/sidebar"
import { useTranslations } from "next-intl"
import waar_qamishlo_logo from "@/public/waar-qamishlo.png";
import Image from "next/image"
import { Link } from "@/i18n/navigation";
import { useParams } from "next/navigation"
import { NavMain } from "./nav-main";

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
    const params = useParams();
    const { locale } = params;
    const side = locale === "ar" ? "right" : "left";
    const t = useTranslations("project name");

    return (
        <Sidebar variant="floating" collapsible="icon" {...props} side={side} className="h-full **:data-[slot=sidebar-inner]:h-full">
            <SidebarHeader>
                <SidebarMenu>
                    <Link href={{ pathname: "/" }} className="flex items-center space-x-4">
                        <Image src={waar_qamishlo_logo} alt="waar_qamishlo_logo" width={40} height={40} className="mt-4 group-data-[state=collapsed]:mt-0" />
                        <span
                            className="flex-1 text-lg mx-auto font-semibold transition-all whitespace-nowrap group-data-[state=collapsed]:opacity-0 group-data-[state=collapsed]:w-0 group-data-[state=collapsed]:overflow-hidden">
                            {t("waar_qamishlo")}
                        </span>
                    </Link>
                </SidebarMenu>
                <SidebarSeparator className="mx-0" />
            </SidebarHeader >
            <SidebarContent className="hide-scrollbar">
                <NavMain />
            </SidebarContent>
            <SidebarRail />
        </Sidebar>
    )
}