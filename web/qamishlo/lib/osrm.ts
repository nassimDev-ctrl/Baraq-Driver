const OSRM_DOMAIN =
    process.env.NEXT_PUBLIC_OSRM_DOMAIN ||
    "https://router.project-osrm.org/route/v1/driving"

type OSRMResponse = {
    routes?: {
        geometry?: {
            coordinates?: [number, number][]
        }
    }[]
}

/**
 * Get road route using OSRM
 */
export async function getRoadRoute(
    points: [number, number][]
): Promise<[number, number][]> {

    if (points.length < 2) return []

    const coords = points.map(p => p.join(",")).join(";")

    const res = await fetch(
        `${OSRM_DOMAIN}/${coords}?overview=full&geometries=geojson`,
        { cache: "no-store" }
    )

    if (!res.ok) {
        throw new Error(
            `OSRM routing failed (${res.status}): ${res.statusText}`
        )
    }

    const data: OSRMResponse = await res.json()

    const route = data?.routes?.[0]?.geometry?.coordinates

    if (!route) return []

    return route
}