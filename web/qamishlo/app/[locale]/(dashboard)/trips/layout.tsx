import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { getTranslations } from "next-intl/server";
import { Link } from "@/i18n/navigation";
import { ReactNode } from "react";
export default async function TripsLayout({ children, params }: { children: ReactNode, params: Promise<{ locale: string }> }) {
    const t = await getTranslations("tripsPage");
    return (
        <main className="flex flex-col w-full space-y-8">
            <h1 className="text-5xl mx-auto font-semibold ">{t("showTripsList")}</h1>
            <Tabs defaultValue="overview" className="grid mx-auto place-content-center">
                <TabsList className="w-full flex justify-center items-center rounded-md bg-muted p-1">
                    <Link href={{ pathname: `/trips/ongoing` }}>
                        <TabsTrigger value="ongoing">
                            {t("ongoingTrips")}
                        </TabsTrigger>
                    </Link>
                    <Link href={{ pathname: `/trips/finished` }}>
                        <TabsTrigger value="finished">
                            {t("finishedTrips")}
                        </TabsTrigger>
                    </Link>
                </TabsList>
            </Tabs>
            <section>
                {children}
            </section>
        </main>
    )
}