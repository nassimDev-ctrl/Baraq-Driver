import { LanguageSwitcher } from "@/components/language-switcher";
import { SidebarTrigger } from "@/components/ui/sidebar";
import { cn } from "@/lib/utils";
import { LogOut } from "lucide-react";
import { getLocale } from "next-intl/server";
import { Suspense } from "react";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "./ui/dropdown-menu";
import { Admin } from "@/types/types";
import { Logout } from "@/lib/actions";

interface AppBarProps {
    admin: Admin
}

export default async function AppBar({ admin }: AppBarProps) {
    const locale = await getLocale();
    return (
        <header className="flex justify-between h-14 shrink-0 items-center gap-4 my-2 rounded-xl bg-background px-4 shadow-sm sticky top-2 z-10">
            <div>
                <SidebarTrigger className="cursor-pointer" />
                <Suspense>
                    <LanguageSwitcher />
                </Suspense>
            </div>
            <DropdownMenu>
                <DropdownMenuTrigger asChild>
                    <div className="flex items-center space-x-1.5 gap-2 bg-card py-0.5 px-1 rounded-lg shadow-sm hover:shadow-md transition-shadow duration-200">
                        <div className="flex flex-col overflow-hidden truncate">
                            <span className={cn("truncate font-semibold text-foreground text-sm",
                                locale === "ar" && "text-end")}>
                                {admin?.firstName} {admin?.lastName}
                            </span>
                            <span className="truncate text-xs text-muted-foreground">
                                {admin?.email}
                            </span>
                        </div>
                        <Avatar className="size-8">
                            <AvatarImage src={""} alt={admin?.firstName} />
                            <AvatarFallback>{admin?.firstName?.at(0)?.toLocaleUpperCase()}{admin?.lastName?.at(0)?.toLocaleUpperCase()}</AvatarFallback>
                        </Avatar>
                    </div>
                </DropdownMenuTrigger>
                <DropdownMenuContent
                    className="w-(--radix-dropdown-menu-trigger-width) min-w-56 rounded-lg"
                    side="bottom"
                    align={locale === "ar" ? "start" : "end"}
                    sideOffset={4}
                >
                    <DropdownMenuLabel className="p-0 font-normal">
                        <div className="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
                            <Avatar className="size-10">
                                <AvatarImage src={""} alt={admin?.firstName} />
                                <AvatarFallback>{admin?.firstName?.at(0)?.toLocaleUpperCase()}{admin?.lastName?.at(0)?.toLocaleUpperCase()}</AvatarFallback>
                            </Avatar>
                            <div className="grid flex-1 text-left text-sm leading-tight">
                                <span className="truncate font-medium">   {admin?.firstName} {admin?.lastName}</span>
                                <span className="truncate text-xs">{admin?.email}</span>
                            </div>
                        </div>
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={Logout}>
                        <LogOut />
                        {locale === "ar" ? "تسجيل الخروج" : locale === "en" ? "Logout" : "Derketin"}

                    </DropdownMenuItem>
                </DropdownMenuContent>
            </DropdownMenu>
        </header>
    )
}