"use client"
import {
    SidebarGroup,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem
} from "@/components/ui/sidebar"
import { usePathname } from "@/i18n/navigation"
import { cn } from "@/lib/utils"
import { City01Icon, MentoringIcon, MoneyBag02Icon } from "@hugeicons/core-free-icons"
import { HugeiconsIcon, IconSvgElement } from '@hugeicons/react'
import type { LucideIcon } from "lucide-react"
import { ArrowLeftRight, BadgePercent, BellDot, CarTaxiFront, Earth, GridIcon, Home, LayoutGrid, MessageSquareWarning, Settings, ShieldCheck, TriangleAlert, UserCog, UserCog2, UserRound } from "lucide-react"
import { useTranslations } from "next-intl"
import { Link } from "@/i18n/navigation";

type NavIcon =
    | { type: "lucide"; icon: LucideIcon }
    | { type: "huge"; icon: IconSvgElement }

type NavItem = {
    title: string
    link: string
    icon: NavIcon
}

const navMain: NavItem[] = [
    { title: "home", icon: { type: "lucide", icon: Home }, link: "/" },

    { title: "trips", icon: { type: "lucide", icon: Earth }, link: "/trips" },
    { title: "drivers", icon: { type: "lucide", icon: CarTaxiFront }, link: "/drivers" },
    { title: "clients", icon: { type: "lucide", icon: UserRound }, link: "/clients" },

    { title: "categories", icon: { type: "lucide", icon: LayoutGrid }, link: "/categories" },
    { title: "cities", icon: { type: "huge", icon: City01Icon }, link: "/cities" },

    { title: "employees", icon: { type: "lucide", icon: UserCog2 }, link: "/employees" },

    { title: "emergencies", icon: { type: "lucide", icon: TriangleAlert }, link: "/emergencies" },
    { title: "report", icon: { type: "huge", icon: MoneyBag02Icon }, link: "/financial-reports" },
    { title: "discount_codes", icon: { type: "lucide", icon: BadgePercent }, link: "/discount_codes" },
    { title: "drivers_balance_history", icon: { type: "lucide", icon: ArrowLeftRight }, link: "/drivers_balance_history" },
    { title: "complaints", icon: { type: "lucide", icon: MessageSquareWarning }, link: "/complaints" },

    { title: "notifications", icon: { type: "lucide", icon: BellDot }, link: "/notifications" },

    { title: "roles", icon: { type: "lucide", icon: UserCog }, link: "/roles" },
    { title: "groups", icon: { type: "huge", icon: MentoringIcon }, link: "/groups" },
    { title: "permission", icon: { type: "lucide", icon: ShieldCheck }, link: "/permissions" },

    { title: "apps", icon: { type: "lucide", icon: GridIcon }, link: "/apps" },
    { title: "settings", icon: { type: "lucide", icon: Settings }, link: "/settings" },

]

export function NavMain() {
    const t = useTranslations("sidebar");
    const pathname = usePathname();
    return (
        <SidebarGroup>
            <SidebarMenu className="space-y-0.5">
                {navMain.map((item) => {
                    const isActive =
                        item.link &&
                        (item.link === "/"
                            ? pathname === "/"
                            : pathname === item.link || pathname.startsWith(item.link + "/"));
                    return (
                        <SidebarMenuItem key={item.title} >
                            <Link href={{ pathname: item.link }}>
                                <SidebarMenuButton
                                    tooltip={t(item.title)}
                                    className={cn(isActive && "bg-primary text-white")}
                                >
                                    {renderNavIcon(item.icon)}
                                    <span>{t(item.title)}</span>
                                </SidebarMenuButton>
                            </Link>
                        </SidebarMenuItem>
                    )
                })}
            </SidebarMenu>
        </SidebarGroup>
    )
}

function renderNavIcon(icon: NavIcon) {
    if (icon.type === "lucide") {
        const Icon = icon.icon
        return <Icon className="size-4 shrink-0" />
    }
    return (
        <HugeiconsIcon
            icon={icon.icon}
            size={18}
            className="shrink-0"
        />
    )
}