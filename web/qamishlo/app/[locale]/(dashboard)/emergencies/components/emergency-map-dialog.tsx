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
import { Emergency, LatLng, GeoPoint } from "@/types/types"
import { getRoadRoute } from "@/lib/osrm"

type Props = {
    emergency: Emergency
}

const toLatLng = (p?: GeoPoint | null): LatLng | null => {
    if (!p?.coordinates) return null
    return {
        lng: p.coordinates[0],
        lat: p.coordinates[1],
    }
}

export function EmergencyMapDialog({ emergency }: Props) {
    const t = useTranslations("emergency_map")

    const client = useMemo(() => {
        return toLatLng(emergency.emergency.location ?? null)
    }, [emergency])

    const driver = useMemo(() => {
        const c = emergency.driver?.driverLocation?.coordinates
        if (!c) return null
        return { lng: c[0], lat: c[1] }
    }, [emergency])

    const [route, setRoute] = useState<LatLng[]>([])
    const [loading, setLoading] = useState(false)

    /**
     * Build route:
     * Priority:
     * 1. emergencyPath (if exists)
     * 2. OSRM fallback (client <-> driver)
     */
    useEffect(() => {
        const buildRoute = async () => {
            if (!client || !driver) {
                console.warn("Missing client or driver")
                return
            }

            setLoading(true)

            try {
                // 1. backend path
                if (emergency.emergencyPath?.length) {
                    setRoute(emergency.emergencyPath)
                    return
                }

                // 2. OSRM fallback
                const osrmRoute = await getRoadRoute([
                    [driver.lng, driver.lat],
                    [client.lng, client.lat],
                ])

                const normalized = osrmRoute.map((p: any) => ({
                    lng: Array.isArray(p) ? p[0] : p.lng,
                    lat: Array.isArray(p) ? p[1] : p.lat,
                }))

                setRoute(normalized)


                // if (!osrmRoute || osrmRoute.length === 0) {
                //     console.warn("OSRM returned empty route")
                //     setRoute([])
                //     return
                // }

                // setRoute(osrmRoute)
            } catch (err) {
                console.error("Route error:", err)
                setRoute([])
            } finally {
                setLoading(false)
            }
        }

        buildRoute()
    }, [client, driver, emergency])
    const center = client ?? driver ?? { lat: 0, lng: 0 }

    return (
        <Dialog>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
                <DialogTrigger asChild>
                    <span>{t("viewLocation")}</span>
                </DialogTrigger>
            </DropdownMenuItem>

            <DialogContent className="max-w-4xl w-full">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <div className="h-125 w-full">
                    {!client && !driver ? (
                        <div className="flex items-center justify-center h-full">
                            {t("noData")}
                        </div>
                    ) : loading ? (
                        <div className="flex items-center justify-center h-full">
                            {t("loading")}
                        </div>
                    ) : (
                        <Map center={[center.lng, center.lat]} zoom={13}>
                            {/* ROUTE */}
                            {route.length > 0 && (
                                <MapRoute
                                    coordinates={route.map((p) => [
                                        p.lng,
                                        p.lat,
                                    ])}
                                    color="#ce9300"
                                    width={4}
                                    opacity={0.9}
                                />
                            )}

                            {/* CLIENT (1) */}
                            {client && (
                                <MapMarker
                                    longitude={client.lng}
                                    latitude={client.lat}
                                >
                                    <MarkerContent>
                                        <div className="size-6 rounded-full bg-blue-600 text-white text-xs font-bold flex items-center justify-center">
                                            1
                                        </div>
                                    </MarkerContent>
                                    <MarkerTooltip>
                                        {t("client")}
                                    </MarkerTooltip>
                                </MapMarker>
                            )}

                            {/* DRIVER (2) */}
                            {driver && (
                                <MapMarker
                                    longitude={driver.lng}
                                    latitude={driver.lat}
                                >
                                    <MarkerContent>
                                        <div className="size-6 rounded-full bg-green-600 text-white text-xs font-bold flex items-center justify-center">
                                            2
                                        </div>
                                    </MarkerContent>
                                    <MarkerTooltip>
                                        {t("driver")}
                                    </MarkerTooltip>
                                </MapMarker>
                            )}

                            {/* EMERGENCY LOCATION (3) */}
                            {emergency.emergency.location && (
                                <MapMarker
                                    longitude={
                                        emergency.emergency.location
                                            .coordinates[0]
                                    }
                                    latitude={
                                        emergency.emergency.location
                                            .coordinates[1]
                                    }
                                >
                                    <MarkerContent>
                                        <div className="size-6 rounded-full bg-red-600 text-white text-xs font-bold flex items-center justify-center">
                                            3
                                        </div>
                                    </MarkerContent>
                                    <MarkerTooltip>
                                        {t("emergency")}
                                    </MarkerTooltip>
                                </MapMarker>
                            )}
                        </Map>
                    )}
                </div>

                {/* INFO */}
                <div className="mt-4 text-sm space-y-1">
                    {emergency.emergency.location?.address && (
                        <div>
                            <strong>{t("location")}:</strong>{" "}
                            {emergency.emergency.location.address}
                        </div>
                    )}

                    <div>
                        <strong>{t("time")}:</strong>{" "}
                        {new Date(
                            emergency.emergency.emergencyTime ?? ""
                        ).toLocaleString()}
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    )
}