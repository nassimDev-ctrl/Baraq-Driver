"use client"

import { DataTable } from "@/components/data-table/data-table"
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar"
import { useDataTable } from "@/hooks/use-data-table"

import { City, Notifications } from "@/types/types"
import { useNotificationsFilter } from "../hooks/use-notifications-filter"
import { useNotificationsColumns } from "./notifications-columns"

interface NotificationsTableProps {
    data: Notifications[]
    // categories: Category[];
    allCities: City[]
}

export default function NotificationsTable({ data, allCities }: NotificationsTableProps) {
    const { filteredData } = useNotificationsFilter(data);
    const columns = useNotificationsColumns({ allCities })

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
        },
        getRowId: (row) => row.id,
    })

    return (
        <div className="data-table-container">
            <DataTable table={table}>
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    )
}