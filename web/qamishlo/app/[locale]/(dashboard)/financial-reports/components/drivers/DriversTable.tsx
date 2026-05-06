"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { DriverRevenue } from "@/types/types";
import { ReportsTableWrapper } from "../reports-table-wrapper";
import { useDriversColumns } from "./useDriversColumns";

interface DriversTableProps {
    data: DriverRevenue[];
}

export default function DriversTable({ data }: DriversTableProps) {
    const columns = useDriversColumns();

    const { table } = useDataTable({
        data,
        columns,
        pageCount: Math.ceil(data.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            sorting: [{ id: "totalRevenue", desc: true }]
        },
        getRowId: (row) => row._id
    });

    return (
        <ReportsTableWrapper
            titleKey="drivers_title"
            data={data}
            mapExportData={(rows) =>
                rows.map((row) => ({
                    ["driver"]: row.driverName,
                    ["total_trips"]: row.totalTrips,
                    ["total_revenue"]: row.totalRevenue,
                    ["app_share"]: row.totalCommission,
                    ["total_discount"]: row.totalDiscount,
                    ["rating"]: row.rating
                }))
            }
        >
            <div className="data-table-container">
                <DataTable table={table}>
                    <DataTableToolbar table={table} />
                </DataTable>
            </div>
        </ReportsTableWrapper>
    );
}