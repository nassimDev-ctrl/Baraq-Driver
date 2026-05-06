export type Languages = 'ar' | 'en' | 'kmr';
// --------------------------------------------------------------------------
// admin (employee) Type 
export interface Admin {
    _id: string;
    firstName: string;
    lastName: string;
    email: string;
    roles: Role[];
    createdAt: Date;
    isSuperAdmin: boolean;
}

// --------------------------------------------------------------------------
// Driver Type
export interface Car {
    carName: string;
    carImage: string;
    carPlateImage: string;
    carPlateNumber: string;
    carYearMade: number;
    category: Category;
}

export type DriverStatus = "active" | "rejected" | "waiting" | "change-sub-category"



export interface Driver {
    _id: string;
    id: string;
    firstName: string;
    lastName: string;
    gender: string;
    address: GeoPoint;
    city: City;
    isAvailable: boolean;
    balance: number;
    usedOverdraft: boolean;
    registrationStep: number;
    isRegistrationComplete: boolean;
    driverLocation: GeoPoint;
    status: string;
    rating: number;
    numberOfTrips: number;
    distancePassed: number;
    createdAt: string;
    updatedAt: string;
    authUser: AuthUser;
    profileImage: string;
    personalCardImageBack: string;
    personalCardImageFront: string;
    emergencyNumber?: string;
    isFrozen: boolean;
    frozenBy: [];
    isBlocked: boolean;
    car: Car;
}

// --------------------------------------------------------------------------
// roles Type 
export interface Role {
    _id: string;
    name: string;
    createdAt: Date;
    groups: Group[]
}

// --------------------------------------------------------------------------
// Groups Type
export interface Group {
    _id: string;
    name: string;
    permissions: Permission[];
    readOnly: boolean
}

// --------------------------------------------------------------------------
// Permissions Type 
export type Permissions =
    | "Create trip"
    | "Update Client"
    | "Delete Client"
    | "Get Client"
    | "Get All Clients"
    | "Get Single Client"

    | "Update Driver"
    | "Get Driver"
    | "Get All Drivers"
    | "Get Single Driver"
    | "Update Driver Car Category"
    | "Accept Driver Change Category"
    | "Accept Driver"
    | "Reject Driver"
    | "Delete Driver"

    | "Get Single User"
    | "Get All Users"
    | "Block User"
    | "Unblock User"
    | "Update Mobile Phone"

    | "Create Admin"
    | "Update Admin Roles"
    | "Delete Admin"
    | "Get Single Admin"
    // | "Get Admin Profile"
    | "Get All Admins"
    | "Reset Admin Password"

    | "Create Car Category"
    | "Update Car Category"
    | "Update Car Category Status"
    | "Delete Car Category"
    | "Get Single Car Category"
    | "Get All Car Categories"

    | "Get Client Discount Codes"

    | "Update Commission"
    | "Get Commission"

    | "Mark Complain As Read"
    | "Get All Complains"

    | "Create Discount Code"
    | "Update Discount Code"
    | "Delete Discount Code"
    | "Get Single Discount Code"
    | "Get All Discount Codes"

    | "Get All Cities"
    | "Get Single City"
    | "Update City Status"

    | "Get All Groups"
    | "Get Single Group"
    | "Update Group Permissions"
    | "Delete Group"
    | "Create Group"

    | "Create Notification"
    | "Delete Notification"
    | "Get Single Notification"
    | "Get All Notifications"

    | "Get All Permissions"
    | "Get Reports"
    | "Get Statistics"

    | "Get All Trips"
    | "Get Single Trip"

    | "Get All Emergencies"

    | "Get All Roles"
    | "Get Single Role"
    | "Update Role Groups"
    | "Delete Role"
    | "Create Role";

export interface Permission {
    _id: string;
    codename: string;
    name: string;
}

// --------------------------------------------------------------------------
export interface Statistics {
    tripsCount: number;
    activeDriversCount: number;
    clientsCount: number;

    tripsPerWeek: {
        _id: {
            year: number;
            week: number;
        };
        count: number;
    }[];

    tripsPerDay: {
        count: number;
        date: string; // YYYY-MM-DD
    }[];

    clientsCountPerMonth: {
        count: number;
        date: string; // YYYY-MM
    }[];

    clientsAvgIncreasePerMonth: {
        _id: null;
        averagePerMonth: number;
    }[];

    driversStatus: {
        _id: "waiting" | "active" | string;
        count: number;
    }[];

    netRevenue: number;
}

// --------------------------------------------------------------------------
// commission Type
export interface Commission {
    _id: string;
    commissionPercentage: number;
    createdAt: Date;
    minPriceOfTrip: number;
}

export interface City {
    _id: string;
    nameEn: string;
    nameAr: string;
    nameKu: string,
    status: boolean,
}

export interface Category {
    _id: string;
    nameAr: string;
    nameEn: string;
    nameKu: string;
    image: string;
    price: number;
    status: boolean;
}

// --------------------------------------------------------------------------
// Notifications Type
export interface Notifications {
    id: string;
    _id: string;
    titleAr: string;
    titleEn: string;
    titleKu: string;
    messageAr: string;
    messageEn: string;
    messageKu: string;
    cities: City[];
    client?: Client;
    driver?: Driver;
    createdAt: Date;
    usersType: "client" | "driver" | "All" | "specific";
}

// --------------------------------------------------------------------------
// BalanceOperation Type
type OperationType = "charge" | "withdraw";

export interface BalanceOperation {
    _id: string;
    balance: number;
    operation: OperationType;
    driverId: Driver;
    createdAt: string;
    updatedAt: string;
}

// --------------------------------------------------------------------------
// DiscountCode Type
export type DiscountCodeStatus = "active" | "finish";

export interface DiscountCode {
    maxTrips: number,
    numberOfUsers: number,
    minimum: number,
    _id: string;
    code: string;
    isVip: boolean;
    discountAmount: number;
    percentageDiscount: number;
    status: DiscountCodeStatus;
    categories: Category[];
    cities: City[];
    startAt: Date;
    expiredAt: Date;

    clientsUsedCount: number;
    remainingTrips: number;
}

// --------------------------------------------------------------------------
// Complaint Type
export interface Complaint {
    _id: string;
    note: string;
    mobilePhone: string;
    image: string;
    isRead: boolean;
    createdAt: Date;
}

// --------------------------------------------------------------------------
// Emergency Type
export type emergency_status = "started" | "completed" | "requested"

export interface Emergency {
    _id: string

    emergency: {
        location?: GeoPoint | null
        emergencyTime?: string | Date
        emergencyPathPolyline?: string | null
    }

    city: City;

    client: Client | null
    driver: Driver | null

    status: emergency_status

    emergencyPath?: LatLng[]
}

// --------------------------------------------------------------------------
// Gender Type
type gender = "male" | "female"

// AuthUser Type
interface AuthUser {
    _id: string
    mobilePhone: string;
    email?: string;
    roles: string[];
}

// --------------------------------------------------------------------------
// CLient Type
export interface Client {
    _id: string;
    firstName: string;
    lastName: string;
    gender: gender;
    city: City,
    authUser: AuthUser,
    userType: string;
    emergencyNumber: string;
    isBlocked: boolean,
    isFrozen: boolean,
    clientLocation: GeoPoint;
}

// --------------------------------------------------------------------------
// Trip Type
interface Trip {
    _id: string;
    client: Client;
    driver: Driver;
    waitingDuration: number;
    emergency: boolean;
    createdAt: Date;
    completedAt: Date;
    city: City;
}

export type finishedTripStatus = "completed" | "canceled" | "driver_accepted" | "driver_canceled" | "requested" | "searching" | "no_driver_available" | "started"

export interface FinishedTrips extends Trip {
    startedAt: Date;
    completedAt: Date;
    totalPrice: number;
    startLocation: GeoPoint;
    destinationLocation: GeoPoint;
    distance: number;
    paymentWay: string;
    price: number;
    notes: string;
    discountCode: string;
    durationInsideCar: number;
    waitingDuration: number;
    status: finishedTripStatus;
    startedCoords?: LatLng[];
    confirmedCoords?: LatLng[];
    emergencyCoords?: LatLng[];
}

export interface LatLng {
    lat: number;
    lng: number;
}

export interface GeoPoint {
    type: "Point";
    coordinates: [number, number]; // [longitude, latitude]
    address: string;
}

export type ongoingTripStatus = "waiting driver" | "On the way to the destination"

export interface OngoingTrip extends Trip {
    status: ongoingTripStatus;
}

export interface DashboardReport {
    totalTrips: number;
    grossRevenue: number;
    netRevenue: number;
    totalCommission: number;
    totalDiscount: number;
    avgTrip: number;
    avgGrossTrip: number;
    takeRate: number;
}

export interface RevenueTrip {
    _id: string;
    tripId: string;
    date: string;
    city?: string;
    driverName: string;
    paymentWay: string;

    price: number;
    totalPrice: number;
    discount: number;

    appCommission: number;
    driverShare: number;
}

export interface CashCollection {
    _id: string;
    driverName: string;
    totalTrips: number;
    totalCashCollected: number;
    totalCommission: number;
    submitted: number;
    difference: number;
}

export interface TripComparison {
    _id: string | null;
    tripType: string;
    totalTrips: number;
    totalRevenue: number;
    avgPrice: number;
    percentage: number;
}

export interface CityRevenue {
    _id: string | null;
    city: string;
    totalTrips: number;
    totalRevenue: number;
    avgPrice: number;
    totalCommission: number;
}

export interface DriverRevenue {
    _id: string;
    totalTrips: number;
    totalRevenue: number;
    totalCommission: number;
    totalDiscount: number;
    driverName: string;
    rating: number;
}
//* for reports only
export interface DashboardStats {
    totalTrips: number;
    grossRevenue: number;
    netRevenue: number;
    totalCommission: number;
    totalDiscount: number;
    avgTrip: number;
    avgGrossTrip: number;
    takeRate: number;
}