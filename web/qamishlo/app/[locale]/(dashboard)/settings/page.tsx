import { getTranslations } from "next-intl/server";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { LanguageSwitcher } from "@/components/language-switcher";
import CommissionsBadge from "@/components/commission-badge";
import ChangePasswordCard from "./components/change-password-card";
import LogoutButton from "./components/logout-button";

export default async function SettingsPage() {
    const t = await getTranslations("settingsPage");

    return (
        <div className="max-w-4xl mx-auto py-10 space-y-8">

            <div>
                <h1 className="text-3xl font-bold">{t("title")}</h1>
                <p className="text-muted-foreground">{t("description")}</p>
            </div>

            {/* Language */}
            <Card>
                <CardHeader>
                    <CardTitle>{t("language.title")}</CardTitle>
                    <CardDescription>
                        {t("language.description")}
                    </CardDescription>
                </CardHeader>
                <CardContent className="flex justify-between items-center">
                    <span className="text-sm text-muted-foreground">
                        {t("language.switch")}
                    </span>
                    <LanguageSwitcher />
                </CardContent>
            </Card>

            {/* Commission */}
            <Card>
                <CardHeader>
                    <CardTitle>{t("commission.title")}</CardTitle>
                    <CardDescription>
                        {t("commission.description")}
                    </CardDescription>
                </CardHeader>
                <CardContent className="flex justify-between items-center">
                    <span className="text-sm text-muted-foreground">
                        {t("commission.commission")}
                    </span>
                    <CommissionsBadge />
                </CardContent>
            </Card>

            {/* Security */}
            <Card>
                <CardHeader>
                    <CardTitle>{t("security.title")}</CardTitle>
                    <CardDescription>
                        {t("security.description")}
                    </CardDescription>
                </CardHeader>
                <CardContent>
                    <ChangePasswordCard />
                </CardContent>
            </Card>

            <Separator />

            <div className="flex justify-end">
                <LogoutButton />
            </div>

        </div>
    );
}