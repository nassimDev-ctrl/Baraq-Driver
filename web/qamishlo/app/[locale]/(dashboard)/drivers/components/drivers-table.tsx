"use client";

import { getPaginationRowModel } from "@tanstack/react-table";
import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { useDriversFilter } from "../hooks/userDriversFilter";
import { useDriversColumns } from "./drivers-columns";
import { City, Driver } from "@/types/types";

interface DriversTableProps {
    data: Driver[];
    cities: City[]
}

export function DriversTable({ data, cities }: DriversTableProps) {
    const { filteredData } = useDriversFilter(data);
    const columns = useDriversColumns({ cities });

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        getPaginationRowModel: getPaginationRowModel(),

        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            columnPinning: { right: ["actions"] },
            columnVisibility: {
                id: false,
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