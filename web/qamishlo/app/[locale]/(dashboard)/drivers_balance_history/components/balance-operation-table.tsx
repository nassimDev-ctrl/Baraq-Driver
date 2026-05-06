"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { BalanceOperation } from "@/types/types";
import { useBalanceOperationsColumns } from "./balance-operations-columns";
import { useBalanceOperationsFilter } from "../hooks/use-drivers-balance-history-filter";

interface BalanceOperationsTableProps {
    data: BalanceOperation[];
}

export default function BalanceOperationsTable({
    data,
}: BalanceOperationsTableProps) {
    const { filteredData } = useBalanceOperationsFilter(data);

    const columns = useBalanceOperationsColumns();

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            sorting: [{ id: "createdAt", desc: true }],
            columnPinning: { right: ["actions"] },
            columnVisibility: {
                _id: false,
            },
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