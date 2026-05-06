import Unauthorized from "@/components/unauthorized";
import AppsClient from "./components/apps-client";
import {
    getClientAppInfo,
    getDriverAppInfo,
} from "@/lib/data";

export default async function AppsPage() {
    const [clientRes, driverRes] = await Promise.all([
        getClientAppInfo(),
        getDriverAppInfo(),
    ]);

    if (clientRes.message === "Forbidden" || driverRes === "Forbidden") return <Unauthorized />

    return (
        <AppsClient
            data={{
                client: clientRes,
                driver: driverRes,
            }}
        />
    );
}