import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";

import { MapPin } from "lucide-react";
import { getLocale, getTranslations } from 'next-intl/server';
import ToggleButton from "./toggle-button";
import { City } from "@/types/types";

export async function CityCard({ city }: { city: City }) {
    const [tStatus, locale] = await Promise.all([getTranslations("cities_status"), getLocale()])
    return (
        <Card className="relative">
            <CardHeader className="flex flex-row items-center justify-between px-4 pb-2">
                <div className="flex items-center gap-2">
                    <MapPin className="h-4 w-4 text-muted-foreground" />
                    <h3 className="font-semibold">{locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : city.nameKu}</h3>
                </div>
                <Badge variant={city.status ? "default" : "destructive"} className="truncate">{city.status ? tStatus("active") : tStatus("inactive")}</Badge>
            </CardHeader>
            <CardContent>
                <ToggleButton id={city._id} status={city.status} />
            </CardContent>
        </Card>
    )
}