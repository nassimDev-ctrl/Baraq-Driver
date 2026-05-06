"use client";

import { AppDialog } from "./app-dialog";

export type AppRelease = {
    version: string;
    downloadLink: string;
    updatedAt: string;
};

export type AppsData = {
    client: AppRelease;
    driver: AppRelease;
};

interface Props {
    data: AppsData;
}

export default function AppsClient({ data }: Props) {

    return (
        <div className="p-6 grid md:grid-cols-2 gap-6 max-w-6xl mx-auto">
            <AppDialog type="client" data={data.client} />
            <AppDialog type="driver" data={data.driver} />
        </div>
    );
}