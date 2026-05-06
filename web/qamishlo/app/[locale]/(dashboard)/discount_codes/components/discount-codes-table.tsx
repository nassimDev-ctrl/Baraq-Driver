"use client";

import { getPaginationRowModel } from "@tanstack/react-table";
import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { DiscountCode, City } from "@/types/types";
import { useDiscountCodeFilter } from "../hooks/use-discount-codes-filter";
import { useDiscountCodeColumns } from "./use-discount-codes-columns";

interface DiscountCodesTableProps {
    data: DiscountCode[];
    // categories: Category[];
    allCities: City[]
}

export function DiscountCodesTable({ data, allCities }: DiscountCodesTableProps) {
    const { filteredData } = useDiscountCodeFilter(data);
    // categories
    const columns = useDiscountCodeColumns({ allCities });

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        getPaginationRowModel: getPaginationRowModel(),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10,
            },
            columnPinning: { right: ["actions"] },
        },
        getRowId: (row) => row._id,
    });

    return (
        <div className="data-table-container">
            <DataTable table={table}>
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    );
}
