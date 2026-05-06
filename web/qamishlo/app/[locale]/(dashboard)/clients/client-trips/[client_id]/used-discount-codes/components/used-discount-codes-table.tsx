"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { DiscountCode } from "@/types/types";
import { useDiscountCodesColumns } from "./use-used-discount-codes-columns";
import { useDiscountCodesFilter } from "../hooks/use-discount-codes-filter";
import { useLocale } from "next-intl";

interface DiscountCodesTableProps {
    data: DiscountCode[];
}

export default function UsedDiscountCodesTable({
    data,
}: DiscountCodesTableProps) {

    const { filteredData } = useDiscountCodesFilter(data);
    const columns = useDiscountCodesColumns();
    const locale = useLocale();

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),

        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10,
            },
            sorting: [{ id: "code", desc: false }],
        },

        getRowId: (row) => row._id,
    });

    return (
        <div className="data-table-container" dir={locale === "ar" ? "rtl" : "ltr"}>
            <DataTable table={table}>
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    );
}