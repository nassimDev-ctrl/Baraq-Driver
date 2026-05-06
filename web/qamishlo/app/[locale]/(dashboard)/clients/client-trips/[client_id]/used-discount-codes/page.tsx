import { Loader } from "@/components/loader";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { getClientUsedDiscountCodes } from "@/lib/data";
import { getTranslations } from "next-intl/server";
import { Suspense } from "react";
import UsedDiscountCodesTable from "./components/used-discount-codes-table";
import Unauthorized from "@/components/unauthorized";

export default async function ClientsUsedDiscountCodePage({
    params,
}: {
    params: Promise<{ client_id: string }>
}) {

    const { client_id } = await params;

    const [discountCodes, t] = await Promise.all([getClientUsedDiscountCodes(client_id), getTranslations("client_used_discount_codes")]);

    if (discountCodes.message === "Forbidden") return <Unauthorized />

    return (
        <main className="md:px-4 space-y-8">
            <h1 className="h1-title">
                {t("title")}
            </h1>
            <Tabs defaultValue="active" className="flex flex-col">
                <TabsList >
                    <TabsTrigger value="active">
                        {t("active")} ({discountCodes.remainingActiveDiscountCodes?.length ?? 0})
                    </TabsTrigger>
                    <TabsTrigger value="finished">
                        {t("finished")} ({discountCodes.finishedDiscountCodes?.length ?? 0})
                    </TabsTrigger>
                </TabsList>
                <Suspense fallback={<Loader />}>
                    <TabsContent value="active">
                        <UsedDiscountCodesTable
                            data={discountCodes.remainingActiveDiscountCodes}
                        />
                    </TabsContent>
                    <TabsContent value="finished">
                        <UsedDiscountCodesTable
                            data={discountCodes.finishedDiscountCodes}
                        />
                    </TabsContent>
                </Suspense>
            </Tabs>
        </main>
    );
}