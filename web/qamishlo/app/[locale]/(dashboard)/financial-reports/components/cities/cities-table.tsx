"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { CityRevenue } from "@/types/types";
import { ReportsTableWrapper } from "../reports-table-wrapper";
import { useCityRevenueColumns } from "./cities-columns";

interface CityRevenueTableProps {
    data: CityRevenue[];
}

export default function CityRevenueTable({ data }: CityRevenueTableProps) {
    const columns = useCityRevenueColumns();

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
        getRowId: (row) => row._id || row.city
    });

    return (
        <ReportsTableWrapper
            titleKey="cities_title"
            data={data}
            mapExportData={(rows) =>
                rows.map((row) => ({
                    ["city"]: row.city,
                    ["total_trips"]: row.totalTrips,
                    ["total_revenue"]: row.totalRevenue,
                    ["avg_price"]: row.avgPrice,
                    ["app_share"]: row.totalCommission
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