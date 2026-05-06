"use client"

import {
    Map,
    MapMarker,
    MapRoute,
    MarkerContent,
    MarkerTooltip,
} from "@/components/ui/map"

import { useEffect, useMemo, useState } from "react"

import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog"

import { DropdownMenuItem } from "@/components/ui/dropdown-menu"

import { useTranslations } from "next-intl"
import { getRoadRoute } from "@/lib/osrm"
import { FinishedTrips } from "@/types/types"

type Props = {
    trip: FinishedTrips
}

// -----------------------------
// helper
// -----------------------------
// const toTuple = (c: { lat: number; lng: number }): [number, number] => [
//     c.lng,
//     c.lat,
// ]

export function TripsMapDialog({ trip }: Props) {
    const t = useTranslations("tripMap")

    // -----------------------------
    // POINTS (keep original behavior)
    // -----------------------------
    const driverCoords = trip.driver?.driverLocation?.coordinates
    const clientCoords = trip.startLocation?.coordinates
    const destinationCoords = trip.destinationLocation?.coordinates

    const driver = useMemo(() => {
        return driverCoords
            ? { lng: driverCoords[0], lat: driverCoords[1] }
            : null
    }, [driverCoords])


    const client = useMemo(() => {
        return clientCoords
            ? { lng: clientCoords[0], lat: clientCoords[1] }
            : null
    }, [clientCoords])

    const destination = useMemo(() => {
        return destinationCoords
            ? { lng: destinationCoords[0], lat: destinationCoords[1] }
            : null
    }, [destinationCoords])

    // -----------------------------
    // ROUTES (ONLY 2 SEGMENTS)
    // -----------------------------
    const [route1, setRoute1] = useState<[number, number][]>([]) // 1 → 2
    const [route2, setRoute2] = useState<[number, number][]>([]) // 2 → 3
    const [loading, setLoading] = useState(false)

    useEffect(() => {
        const fetchRoutes = async () => {
            try {
                setLoading(true)

                // 🟣 1 → 2
                const r1 =
                    driver && client
                        ? await getRoadRoute([
                            [driver.lng, driver.lat],
                            [client.lng, client.lat],
                        ])
                        : []

                // 🟡 2 → 3
                const r2 =
                    client && destination
                        ? await getRoadRoute([
                            [client.lng, client.lat],
                            [destination.lng, destination.lat],
                        ])
                        : []

                setRoute1(r1)
                setRoute2(r2)
            } catch (err) {
                console.error("OSRM error:", err)
            } finally {
                setLoading(false)
            }
        }

        fetchRoutes()
    }, [driver, client, destination])

    // -----------------------------
    // CENTER (safe)
    // -----------------------------
    const center: [number, number] = useMemo(() => {
        if (client) return [client.lng, client.lat]
        if (driver) return [driver.lng, driver.lat]
        if (destination) return [destination.lng, destination.lat]
        return [0, 0]
    }, [client, driver, destination])

    const hasData = driver || client || destination

    return (
        <Dialog>
            <DialogTrigger asChild>
                <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
                    {t("viewRoute")}
                </DropdownMenuItem>
            </DialogTrigger>

            <DialogContent className="max-w-5xl w-full">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <div className="h-125 w-full">
                    {!hasData ? (
                        <div className="flex items-center justify-center h-full">
                            {t("noData")}
                        </div>
                    ) : loading ? (
                        <div className="flex items-center justify-center h-full">
                            {t("loading")}
                        </div>
                    ) : (
                        <Map center={center} zoom={12}>
                            {/* 🟣 1 → 2 */}
                            <MapRoute
                                coordinates={
                                    route1.length > 0
                                        ? route1
                                        : driver && client
                                            ? [
                                                [driver.lng, driver.lat],
                                                [client.lng, client.lat],
                                            ]
                                            : []
                                }
                                color="#a064db"
                                width={4}
                            />

                            {/* 🟡 2 → 3 */}
                            <MapRoute
                                coordinates={
                                    route2.length > 0
                                        ? route2
                                        : client && destination
                                            ? [
                                                [client.lng, client.lat],
                                                [
                                                    destination.lng,
                                                    destination.lat,
                                                ],
                                            ]
                                            : []
                                }
                                color="#ce9300"
                                width={4}
                            />

                            {/* 🔵 1 */}
                            {driver && (
                                <MapMarker longitude={driver.lng} latitude={driver.lat}>
                                    <MarkerContent>
                                        <div className="size-6 rounded-full bg-[#031d4e] text-white text-xs flex items-center justify-center">
                                            1
                                        </div>
                                    </MarkerContent>
                                    <MarkerTooltip>{t("driver")}</MarkerTooltip>
                                </MapMarker>
                            )}

                            {/* ⚫ 2 */}
                            {client && (
                                <MapMarker longitude={client.lng} latitude={client.lat}>
                                    <MarkerContent>
                                        <div className="size-6 rounded-full bg-gray-700 text-white text-xs flex items-center justify-center">
                                            2
                                        </div>
                                    </MarkerContent>
                                    <MarkerTooltip>{t("client")}</MarkerTooltip>
                                </MapMarker>
                            )}

                            {/* 🟢 3 */}
                            {destination && (
                                <MapMarker
                                    longitude={destination.lng}
                                    latitude={destination.lat}
                                >
                                    <MarkerContent>
                                        <div className="size-6 rounded-full bg-[#60b420] text-white text-xs flex items-center justify-center">
                                            3
                                        </div>
                                    </MarkerContent>
                                    <MarkerTooltip>{t("destination")}</MarkerTooltip>
                                </MapMarker>
                            )}
                        </Map>
                    )}
                </div>

                {/* LEGEND */}
                <div className="mt-6 space-y-2 text-sm">
                    <div className="flex items-center gap-2">
                        <span className="w-6 h-2 bg-[#a064db] rounded" />
                        {t("driverToClient")}
                    </div>

                    <div className="flex items-center gap-2">
                        <span className="w-6 h-2 bg-[#ce9300] rounded" />
                        {t("clientToDestination")}
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    )
}