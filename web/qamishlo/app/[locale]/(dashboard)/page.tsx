import { getStatistics } from '@/lib/data';
import { getTranslations } from 'next-intl/server';
import Stats from '../../../components/stats';

export default async function HomePage() {
    const [statistics, t] = await Promise.all([getStatistics(), getTranslations('HomePage')]);
    return (
        <>
            <main className="flex w-full mx-auto">
                <div className="w-full">
                    <h1 className="text-3xl md:text-7xl font-semibold mx-auto mb-4">{t("welcome")}</h1>
                    <Stats statistics={statistics} />
                </div>
            </main>
        </>
    )
}