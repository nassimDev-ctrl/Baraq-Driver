"use client";

import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Category } from "@/types/types";
import { useLocale, useTranslations } from "next-intl";

import { DeleteCategory } from "./delete-category";
import { UpdateCategory } from "./edit-category";
import Image from "next/image";
import UpdateCategoryStatus from "./update-category-status";

interface CategoryCardProps {
    category: Category;
}

const API_DOMAIN = process.env.NEXT_PUBLIC_APP_DOMAIN_FOR_IMAGES!;

export function CategoryCard({ category }: CategoryCardProps) {
    const locale = useLocale();
    const tCurrency = useTranslations("currency");
    const proxyUrl = `/api/image-proxy?url=${encodeURIComponent(API_DOMAIN + '/' + category.image)}`;
    return (
        <Card className="relative">
            <CardHeader className="flex flex-row items-center justify-between">
                <div className="flex items-center gap-2">
                    <Image
                        src={proxyUrl}
                        width={32}
                        height={32}
                        alt={locale === "ar" ? category.nameAr : locale === "en" ? category.nameEn : category.nameKu}
                        unoptimized
                        className="rounded-full bg-accent size-8"
                    />
                    {/* <img
                        src={proxyUrl}
                        alt={category.nameEn}
                        width={32}
                        height={32}
                        className="rounded-full bg-accent size-8"
                    /> */}
                    <h3 className="font-semibold">
                        {locale === "ar" ? category.nameAr : locale === "en" ? category.nameEn : category.nameKu}
                    </h3>
                </div>
                <p className="flex items-center gap-1 text-sm font-medium">
                    <span>{category.price}</span>
                    <span className="text-muted-foreground">
                        {tCurrency("SYP")}
                    </span>
                </p>
            </CardHeader>

            <CardContent className="flex justify-end gap-2 pt-0">
                <UpdateCategoryStatus id={category._id} status={category.status} />
                <UpdateCategory category={category} />
                <DeleteCategory id={category._id} />
            </CardContent>
        </Card>
    );
}