"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Statistics } from "@/types/types";
import { useTranslations } from "next-intl";
import {
    Area,
    AreaChart,
    Bar,
    BarChart,
    CartesianGrid,
    Cell,
    Line,
    LineChart,
    Pie,
    PieChart,
    ResponsiveContainer,
    Tooltip,
    XAxis,
    YAxis,
} from "recharts";

interface StatsProps {
    statistics: Statistics;
}

export default function Stats({ statistics }: StatsProps) {
    const t = useTranslations("stats");
    const tSYP = useTranslations("currency");
    // Trips per week (Bar Chart)
    const tripsPerWeekData = statistics.tripsPerWeek?.map((item) => ({
        name: `W${item._id.week}`,
        trips: item.count,
    }));

    // Trips per day (Line Chart)
    const tripsPerDayData = statistics.tripsPerDay?.map((item) => ({
        name: item.date,
        trips: item.count,
    }));

    // Clients per month (Area Chart)
    const clientsPerMonthData = statistics.clientsCountPerMonth?.map((item) => ({
        name: item.date,
        clients: item.count,
    }));

    // Driver Status (Pie Chart)
    const driverStatusData = statistics.driversStatus?.map((item) => ({
        name: item._id,
        value: item.count,
    }));

    const COLORS = ["#22c55e", "#facc15", "#ef4444", "#3b82f6"];

    return (
        <div className="py-6 md:px-6 space-y-6">
            {/* KPI Cards */}
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
                {/* Total Trips */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            {t("totalTrips")}
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{statistics.tripsCount}</div>
                    </CardContent>
                </Card>

                {/* Revenue (Missing from API) */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            {t("totalRevenue")}
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">
                            {statistics.netRevenue ?
                                <>
                                    {statistics.netRevenue.toLocaleString()}
                                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                                </>
                                : "N/A"}
                        </div>
                    </CardContent>
                </Card>

                {/* Active Drivers */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            {t("activeDrivers")}
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">
                            {statistics.activeDriversCount}
                        </div>
                    </CardContent>
                </Card>

                {/* Total Clients */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle className="text-sm font-medium text-muted-foreground">
                            {t("totalClients")}
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{statistics.clientsCount}</div>
                    </CardContent>
                </Card>
            </div>

            {/* Charts */}
            <div className="grid gap-6 lg:grid-cols-2">
                {/* Trips Per Week */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle>{t("tripsPerWeek")}</CardTitle>
                    </CardHeader>
                    <CardContent className="h-75">
                        <ResponsiveContainer width="100%" height="100%">
                            <BarChart data={tripsPerWeekData}>
                                <CartesianGrid strokeDasharray="3 3" />
                                <XAxis dataKey="name" />
                                <YAxis />
                                <Tooltip />
                                <Bar dataKey="trips" radius={[8, 8, 0, 0]} fill="#a064db" />
                            </BarChart>
                        </ResponsiveContainer>
                    </CardContent>
                </Card>

                {/* Trips Per Day */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle>{t("tripsPerDay")}</CardTitle>
                    </CardHeader>
                    <CardContent className="h-75">
                        <ResponsiveContainer width="100%" height="100%">
                            <LineChart data={tripsPerDayData}>
                                <CartesianGrid strokeDasharray="3 3" />
                                <XAxis dataKey="name" />
                                <YAxis />
                                <Tooltip />
                                <Line type="monotone" dataKey="trips" strokeWidth={3} />
                            </LineChart>
                        </ResponsiveContainer>
                    </CardContent>
                </Card>
            </div>

            <div className="grid gap-6 lg:grid-cols-2">
                {/* Driver Status */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle>{t("driverStatusDistribution")}</CardTitle>
                    </CardHeader>
                    <CardContent className="h-75">
                        <ResponsiveContainer width="100%" height="100%">
                            <PieChart>
                                <Tooltip />
                                <Pie
                                    data={driverStatusData}
                                    dataKey="value"
                                    nameKey="name"
                                    cx="50%"
                                    cy="50%"
                                    outerRadius={100}
                                    label
                                >
                                    {driverStatusData?.map((_, index) => (
                                        <Cell
                                            key={`cell-${index}`}
                                            fill={COLORS[index % COLORS.length]}
                                        />
                                    ))}
                                </Pie>
                            </PieChart>
                        </ResponsiveContainer>
                    </CardContent>
                </Card>

                {/* Clients Growth */}
                <Card className="rounded-2xl shadow-sm">
                    <CardHeader>
                        <CardTitle>{t("clientsPerMonth")}</CardTitle>
                    </CardHeader>
                    <CardContent className="h-75">
                        <ResponsiveContainer width="100%" height="100%">
                            <AreaChart data={clientsPerMonthData}>
                                <CartesianGrid strokeDasharray="3 3" />
                                <XAxis dataKey="name" />
                                <YAxis />
                                <Tooltip />
                                <Area type="monotone" dataKey="clients" strokeWidth={2} />
                            </AreaChart>
                        </ResponsiveContainer>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
}