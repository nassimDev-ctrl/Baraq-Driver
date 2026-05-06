export type LatLng = {
    lat: number
    lng: number
}

export type LngLat = [number, number] // OSRM + Map format

// backend → OSRM / Map format
export const toLngLat = (c: LatLng): LngLat => [c.lng, c.lat]