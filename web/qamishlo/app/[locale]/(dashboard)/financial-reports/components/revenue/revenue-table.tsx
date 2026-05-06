"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { RevenueTrip } from "@/types/types";
import { useRevenueFilter } from "../../hooks/use-revenue-filter";
import { ReportsTableWrapper } from "../reports-table-wrapper";
import { useRevenueColumns } from "./use-revenue-columns";

interface RevenueTableProps {
    data: RevenueTrip[];
}

export default function RevenueTable({ data }: RevenueTableProps) {
    const columns = useRevenueColumns();

    const { filteredData } = useRevenueFilter(data);

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10,
            },
            sorting: [{ id: "tripId", desc: true }],
            columnVisibility: {
                tripId: false,
            },
        },
        getRowId: (row) => row._id,
    });


    return (
        <ReportsTableWrapper
            titleKey="revenue_title"
            data={filteredData}
            mapExportData={(rows) =>
                rows.map((row) => ({
                    TripID: row.tripId,
                    Date: new Date(row.date).toLocaleString(),
                    City: row.city,
                    Driver: row.driverName,
                    Price: row.price,
                    Discount: row.discount,
                    Total: row.totalPrice,
                    Commission: row.appCommission,
                    DriverShare: row.driverShare,
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