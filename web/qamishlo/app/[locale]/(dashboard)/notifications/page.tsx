import { Suspense } from "react"
import { Loader } from "@/components/loader"
import NotificationsTable from "./components/notifications-table"
import { getAllCities, getCarCategories, getNotifications } from "@/lib/data"
import { getTranslations } from "next-intl/server"
import NotifyDialog from "./components/notify-dialog"
import Unauthorized from "@/components/unauthorized"

export default async function NotificationsPage() {
    const [notifications, cities, categories, t] = await Promise.all([getNotifications(), getAllCities(), getCarCategories(), getTranslations("notificationPage")]);
    if (notifications.message === "Forbidden" || cities.message === "Forbidden" || categories.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-4">
            <div className="flex items-center justify-between mb-8">
                <h1 className="flex-1 h1-title">{t("title")}</h1>
                <NotifyDialog cities={cities} categories={categories} />
            </div>
            <Suspense fallback={<Loader />}>
                <NotificationsTable data={notifications} allCities={cities} />
            </Suspense>
        </main>
    )
}