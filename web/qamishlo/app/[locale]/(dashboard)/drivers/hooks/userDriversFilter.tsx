import { Driver } from "@/types/types";
import { useLocale } from "next-intl";
import { parseAsArrayOf, parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useDriversFilter = (data: Driver[]) => {
    const locale = useLocale();
    const [name] = useQueryState("name", parseAsString.withDefault(""));
    const [car] = useQueryState("car", parseAsString.withDefault(""));
    const [city] = useQueryState("city",
        parseAsString.withDefault("")
    );
    const [status] = useQueryState(
        "status",
        parseAsArrayOf(parseAsString).withDefault([]),
    );
    const [gender] = useQueryState(
        "gender",
        parseAsString.withDefault("")
    )
    const [mobilePhone] = useQueryState(
        "mobilePhone",
        parseAsString.withDefault("")
    )
    // for phoneNUmber
    const normalizePhone = (value: string) =>
        value.replace(/\s+/g, "").replace("+", "");
    const filteredData = React.useMemo(() => {
        return data.filter((driver) => {
            const matchesName =
                name === "" ||
                `${driver.firstName} ${driver.lastName}`.toLowerCase().includes(name.toLowerCase());

            const matchesStatus =
                status.length === 0 || status.includes(driver.status);

            const matchesCity =
                city.length === 0 ||
                city.includes(driver.city._id);

            const matchesCar =
                car.length === 0 ||
                (driver.car && driver.car.category && (
                    locale === "ar" ? driver.car.category.nameAr.toLowerCase().includes(car.toLowerCase()) :
                        locale === "en" ? driver.car.category.nameEn.toLowerCase().includes(car.toLowerCase()) :
                            driver.car.category.nameKu.toLowerCase().includes(car.toLowerCase())
                ));

            const matchesGender =
                gender.length === 0 ||
                gender.includes(driver.gender);

            const matchesMobilePhone =
                mobilePhone === "" ||
                (driver.authUser.mobilePhone &&
                    normalizePhone(driver.authUser.mobilePhone).includes(
                        normalizePhone(mobilePhone)
                    )
                );

            return (
                matchesName &&
                matchesCar &&
                matchesStatus &&
                matchesCity &&
                matchesGender &&
                matchesMobilePhone
            );
        });
    }, [data, name, status, city, gender, mobilePhone, car, locale]);
    return { filteredData };
}