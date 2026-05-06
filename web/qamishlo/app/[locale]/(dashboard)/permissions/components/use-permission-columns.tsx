import { cn } from "@/lib/utils";
import { Permission } from "@/types/types";
import { ColumnDef } from "@tanstack/react-table";
import { useLocale, useTranslations } from "next-intl";
import React from "react";

export function usePermissionsColumns() {
    const lang = useLocale();
    const t = useTranslations("permissionsPage");
    const tPer = useTranslations("permissions")
    return React.useMemo<ColumnDef<Permission>[]>(() => [
        {
            id: "index",
            header: () => (
                <div className="w-8 px-8 text-right font-medium">
                    #
                </div>
            ),
            cell: ({ row }) => (
                <div className="w-8 px-8 text-right text-muted-foreground">
                    {row.index + 1}
                </div>
            ),
            size: 48,
            enableSorting: false,
        },
        {
            id: "permissions",
            accessorKey: "name",
            header: () => (
                <div className={cn("font-medium", lang === "ar" ? "text-right" : "text-left")}>
                    {t("title")}
                </div>
            ),
            cell: ({ cell }) => (
                <div className={cn(lang === "ar" ? "text-right" : "text-left")}>
                    {tPer(cell.getValue<string>())}
                </div>
            ),
        },
    ], [t, tPer, lang]);
}
