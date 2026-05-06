import { Loader } from '@/components/loader';
import { getAllCities, getDriverTrips } from '@/lib/data';
import { Suspense } from 'react';
import FinishedTripsTable from '../../../trips/finished/components/finished-trips-table';
import { getTranslations } from 'next-intl/server';
import Unauthorized from '@/components/unauthorized';

export default async function DriverTripsPage({
    params,
}: {
    params: Promise<{ driver_id: string }>
}) {
    const { driver_id } = await params
    const [driverTrips, cities, t] = await Promise.all([getDriverTrips(driver_id), getAllCities(), getTranslations("driversPage.driver_trips")]);
    if (driverTrips.message === "Forbidden") return <Unauthorized />;
    return (
        <main className='space-y-8'>
            <h1 className=" h1-title">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <FinishedTripsTable data={driverTrips} cities={cities} />
            </Suspense>
        </main>
    )
}