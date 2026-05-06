import {
    parseAsArrayOf,
    parseAsInteger,
    parseAsString,
    useQueryState,
} from "nuqs"
import React from "react"
import { Role } from "@/types/types"

export const useRolesFilter = (data: Role[]) => {
    const [groups] = useQueryState(
        "groups",
        parseAsArrayOf(parseAsString).withDefault([])
    )

    const [date] = useQueryState(
        "createdAt",
        parseAsInteger
    )

    const isSameDay = (a: Date, b: Date) =>
        a.getFullYear() === b.getFullYear() &&
        a.getMonth() === b.getMonth() &&
        a.getDate() === b.getDate()

    const filteredData = React.useMemo(() => {
        if (!data) return []

        return data.filter((role) => {
            const matchesGroup =
                groups.length === 0 ||
                role.groups?.some((g) => groups.includes(g._id))

            const matchesDate =
                !date ||
                isSameDay(
                    new Date(date),
                    new Date(role.createdAt)
                )

            return matchesGroup && matchesDate
        })
    }, [data, groups, date])

    return { filteredData }
}