import { getCarCategories } from "@/lib/data";
import { CategoryCard } from "./components/category-card";
import { Category } from "@/types/types";
import { CreateCategory } from "./components/create-category";
import { Suspense } from "react";
import { Loader } from "@/components/loader";
import { getTranslations } from "next-intl/server";
import Unauthorized from "@/components/unauthorized";
export default async function CategoriesPage() {
    const [categories, t] = await Promise.all([getCarCategories(), getTranslations("CategoryPage")])
    if (categories.message === "Forbidden") return <Unauthorized />;

    return (
        <main className="w-full space-y-8">
            <h1 className=" h1-title">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <div className="grid gap-4 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-4 mb-8">
                    {categories.map((category: Category) => (
                        <CategoryCard key={category._id} category={category} />
                    ))}
                    <CreateCategory />
                </div>
            </Suspense>
        </main>
    )
}