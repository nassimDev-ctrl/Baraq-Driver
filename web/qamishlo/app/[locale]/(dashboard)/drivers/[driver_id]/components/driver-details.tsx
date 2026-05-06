import GoBackButton from "@/components/go-back-button"
import { Badge } from "@/components/ui/badge"
import { buttonVariants } from "@/components/ui/button"
import { Link } from "@/i18n/navigation"
import { BalanceOperation, Category, City, Driver } from "@/types/types"
import { Car, Hash, Mail, MapPin, MapPinHouse, Phone, Star, TriangleAlert, User, Wallet } from "lucide-react"
import { useLocale, useTranslations } from "next-intl"
import Image from "next/image"
import { Activity } from "react"
import { FinalDriverStatus } from "../../components/drivers-columns"
import { AddDriverBalanceDialog } from "./add-driver-balance"
import { DriverBalanceDialog } from "./driver-balance-records"
import UpdateDriverCategory from "./update-driver-category"
import { UpdateDriverStatus } from "./update-driver-status"
import UpdateDriver from "./update-driver-details"

const getFinalStatus = (driver: Driver): FinalDriverStatus => {
    if (driver.isBlocked) return "blocked";
    if (driver.isFrozen) return "frozen";
    return driver.status as FinalDriverStatus;
};

interface DriverDetailsProps {
    driver: Driver | undefined
    categories: Category[]
    balanceRecords: BalanceOperation[]
    cities: City[]
}

const API_DOMAIN = process.env.NEXT_PUBLIC_APP_API_DOMAIN!;

export default function DriverDetails({ driver, categories, balanceRecords, cities }: DriverDetailsProps) {
    // console.log(driver);
    const locale = useLocale();
    const t = useTranslations("driver_details");
    const tGen = useTranslations("gender");
    const tStatus = useTranslations("driversPage.driver_status");
    const tSP = useTranslations("currency")
    if (!driver) return null;
    const finalStatus = getFinalStatus(driver);
    const statusVariantMap: Record<
        FinalDriverStatus,
        "outline" | "secondary" | "destructive"
    > = {
        active: "outline",
        waiting: "secondary",
        "change-sub-category": "secondary",
        rejected: "destructive",
        frozen: "secondary",
        blocked: "destructive",
    };
    return (
        <div className="max-w-5xl mx-auto space-y-3 p-6">
            <GoBackButton link="../drivers" />
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold">{driver?.firstName} {driver?.lastName}</h1>
                    <div className="flex items-center gap-4 text-muted-foreground mt-1">
                        <span className="flex items-center gap-1">
                            <Phone className="size-4" />
                            {driver.authUser?.mobilePhone}
                        </span>
                        <span className="flex items-center gap-1">
                            <User className="size-4" />
                            {tGen(driver.gender)}
                        </span>
                        <Activity mode={driver?.authUser?.email ? "visible" : "hidden"}>
                            <span className="flex items-center gap-1">
                                <Mail className="size-4" />
                                {driver?.authUser?.email}
                            </span>
                        </Activity>
                        <Activity mode={driver?.emergencyNumber ? "visible" : "hidden"}>
                            <span className="flex items-center gap-1">
                                <TriangleAlert className="size-4" />
                                {driver.emergencyNumber}
                            </span>
                        </Activity>
                    </div>
                </div>
                {/* driver status */}
                <Badge
                    variant={statusVariantMap[finalStatus]}
                    className="h-7"
                >
                    {tStatus(finalStatus)}
                </Badge>
                {/* Status Dropdown */}
                <UpdateDriverStatus driver={driver} />
                {driver.frozenBy.length > 0 && (
                    <div className="border rounded-lg p-4 space-y-2 bg-muted/40">
                        <div className="flex items-center gap-2 text-sm text-muted-foreground">
                            <TriangleAlert className="size-4" />
                            {t("frozen_by")}
                        </div>
                        <div className="flex flex-wrap gap-2">
                            {driver.frozenBy.map((item, index) => (
                                <Badge key={index} variant="secondary">
                                    {item}
                                </Badge>
                            ))}
                        </div>
                    </div>
                )}
            </div>
            {/* Main Content */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Car Image */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="relative w-full aspect-square rounded-xl overflow-hidden border bg-muted h-44">
                        {driver.car?.carImage &&
                            <Image
                                src={`${API_DOMAIN}/${driver.car.carImage}`}
                                alt={`Driver-${driver?.firstName}-car`}
                                fill
                                className="object-cove"
                            />
                        }
                    </div>

                    <div className="relative w-full aspect-square rounded-xl overflow-hidden border bg-muted h-44">
                        <Image
                            src={`${API_DOMAIN}/${driver?.personalCardImageFront}`}
                            alt={`Driver-${driver?.firstName}-car-front`}
                            fill
                            className="object-cover"
                        />
                    </div>

                    <div className="relative w-full aspect-square rounded-xl overflow-hidden border bg-muted h-44">
                        <Image
                            src={`${API_DOMAIN}/${driver?.personalCardImageBack}`}
                            alt={`Driver-${driver?.firstName}-car-back`}
                            fill
                            className="object-cover"
                        />
                    </div>
                </div>

                {/* Driver Info */}
                <div className="space-y-4">
                    <div className="grid grid-cols-2 gap-4">
                        <InfoItem icon={Star} label={t("evaluation")} value={`${driver.rating ?? 0}/5`} />
                        <InfoItem icon={Car} label={t("car_category")} value={locale === "ar" ? driver.car?.category.nameAr : locale === "en" ? driver.car?.category.nameEn : driver.car?.category.nameKu} />
                        <InfoItem
                            icon={MapPin}
                            label={t("city")}
                            value={locale === "ar" ? driver.city?.nameAr : locale === "en" ? driver?.city.nameEn : driver?.city.nameKu}
                        />
                        <InfoItem
                            icon={MapPinHouse}
                            label={t("address")}
                            value={driver.address?.address ?? ""}
                        />
                        <InfoItem
                            icon={Car}
                            label={t("car")}
                            value={driver.car?.carName ?? ""}
                        />
                        <InfoItem
                            icon={Wallet}
                            label={t("balance")}
                            value={driver.balance ? `${driver.balance} ${tSP("SYP")}` : `0 ${tSP("SYP")}`}
                        />
                    </div>
                    <div className="grid grid-cols-2 gap-4 h-20">
                        <div className="border rounded-lg p-4 flex-1">
                            <p className=" flex items-center gap-2 text-sm text-muted-foreground">
                                <Hash className="size-4" />
                                {t("plate_number")}
                            </p>
                            <p className="font-medium">{driver.car?.carPlateNumber}</p>
                        </div>
                        <div className="relative rounded-xl overflow-hidden border bg-muted flex-1">
                            <Image
                                src={`${API_DOMAIN}/${driver.car?.carPlateImage}`}
                                unoptimized
                                alt={`Driver-${driver.firstName}-car-plate-number`}
                                fill
                                className="object-cover w-full h-full"
                            />
                        </div>
                    </div>
                </div>
                <div className="flex items-center gap-2 w-full">
                    <UpdateDriverCategory driverId={driver._id} currentCategoryId={driver.car?.category._id} categories={categories} />
                    <Link href={{ pathname: `../drivers/driver-trips/${driver._id}` }} className={buttonVariants({ variant: "outline" })}>   {t("driver_trips")}</Link>
                    <UpdateDriver driver={driver} cities={cities} />
                    <DriverBalanceDialog operations={balanceRecords} />
                    <AddDriverBalanceDialog driver={driver} />
                </div>
            </div>
        </div >
    )
}

function InfoItem({
    icon: Icon,
    label,
    value,
}: {
    icon: React.ElementType
    label: string
    value: string | number
}) {
    return (
        <div className="border rounded-lg p-4 space-y-1">
            <div className="flex items-center gap-2 text-muted-foreground text-sm">
                <Icon className="size-4" />
                {label}
            </div>
            <p className="font-semibold">{value}</p>
        </div>
    )
}
