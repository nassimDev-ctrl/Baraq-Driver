"use client";

import * as React from "react";
import { exportToExcel } from "@/lib/export-to-excel";
import { useTranslations } from "next-intl";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";

import { useQueryStates } from "nuqs";

interface Props<T> {
    titleKey: string;
    data: T[];
    children: React.ReactNode;
    mapExportData: (data: T[]) => unknown[];
}

export function ReportsTableWrapper<T>({
    titleKey,
    data,
    children,
    mapExportData,
}: Props<T>) {
    const t = useTranslations("financialReportsPage");

    // ✅ nuqs URL state (THIS is the source of truth)
    const [filters, setFilters] = useQueryStates({
        from: {
            defaultValue: null,
            parse: (v) => v ?? null,
        },
        to: {
            defaultValue: null,
            parse: (v) => v ?? null,
        },
    });

    const { from, to } = filters;

    // ✅ correct isFiltered (based on URL, not table)
    const isFiltered = Boolean(from || to);

    const handleDateChange = (key: "from" | "to", value: string) => {
        setFilters({
            [key]: value || null,
        });
    };

    const onReset = () => {
        setFilters({
            from: null,
            to: null,
        });
    };

    const handleExport = () => {
        const exportData = mapExportData(data);
        exportToExcel(exportData, titleKey);
    };

    return (
        <div className="space-y-4">
            {/* 🔹 Title */}
            <h2 className="text-xl font-semibold">
                {t(titleKey)}
            </h2>

            {/* 🔹 Filters + Export */}
            <div className="flex flex-wrap gap-2 items-center">

                <Input
                    type="date"
                    value={from ?? ""}
                    onChange={(e) => handleDateChange("from", e.target.value)}
                    className="w-45"
                />

                <Input
                    type="date"
                    value={to ?? ""}
                    onChange={(e) => handleDateChange("to", e.target.value)}
                    className="w-45"
                />

                <Button
                    onClick={handleExport}
                    className="bg-green-800 rounded-none"
                >
                    {t("export")}
                </Button>

                {/* ✅ RESET BUTTON */}
                {isFiltered && (
                    <Button
                        aria-label="Reset filters"
                        variant="outline"
                        size="sm"
                        className="border-dashed"
                        onClick={onReset}
                    >
                        <X className="w-4 h-4" />
                        {t("reset")}
                    </Button>
                )}

            </div>

            {/* 🔹 Table */}
            {children}
        </div>
    );
}