"use client"

import { DataTable } from "@/components/data-table/data-table"
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar"
import { useDataTable } from "@/hooks/use-data-table"
import { useRolesColumns } from "./roles-columns"
import { Group, Role } from "@/types/types"
import { useRolesFilter } from "../hooks/use-roles-filter"

interface RolesTableProps {
    groups: Group[]
    data: Role[]
}

export default function RolesTable({ data, groups }: RolesTableProps) {
    const { filteredData } = useRolesFilter(data)
    const columns = useRolesColumns({ all_groups: groups })

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
        },
        getRowId: (row) => row._id,
    })

    return (
        <div className="data-table-container">
            <DataTable table={table}>
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    )
}