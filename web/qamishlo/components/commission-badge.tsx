import { getCommission } from "@/lib/data";
import UpdateCommissionRate from "./update-commission-rate";
import Unauthorized from "./unauthorized";
import UpdateMinTripPrice from "./update-min-trip-price";

export default async function CommissionsBadge() {
  const commission = await getCommission();

  if (commission.message === "Forbidden") return <Unauthorized />;
  return (
    <div className="flex items-center gap-4">
      <UpdateMinTripPrice
        commission={commission}
      />
      <UpdateCommissionRate
        commission={commission}
      />
    </div>
  );
}