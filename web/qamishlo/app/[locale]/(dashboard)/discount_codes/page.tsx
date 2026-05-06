import { Loader } from "@/components/loader";
import { getAllCities, getDiscountCodes } from "@/lib/data"
import { Suspense } from "react";
import { DiscountCodesTable } from "./components/discount-codes-table";
import { getTranslations } from "next-intl/server";
import CreateDiscountCode from "./components/create-discount-code";
import Unauthorized from "@/components/unauthorized";

export default async function DiscountCodePage() {
    const [discountCodes, t, cities] = await Promise.all([getDiscountCodes(), getTranslations("discountCodePage"), getAllCities()])
    if (discountCodes.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-4">
            <div className="flex items-center justify-between mb-8">
                <h1 className="flex-1 h1-title">{t("title")}</h1>
                {/* create code */}
                {/* categories={categories} */}
                <CreateDiscountCode cities={cities} />
            </div>
            <Suspense fallback={<Loader />}>
                {/* categories={categories} */}
                <DiscountCodesTable data={discountCodes} allCities={cities} />
            </Suspense>
        </main>
    )
}