import { Group } from "@/types/types";
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}


export const formatDate = (date: Date | string) =>
  new Date(date).toLocaleString("en-US", {
    // year: "numeric",
    // month: "short",
    // day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

export const formatDuration = (totalMinutes: number) => {
  if (!totalMinutes && totalMinutes !== 0) return "-";

  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;

  if (hours === 0) return `${minutes}m`;
  if (minutes === 0) return `${hours}h`;

  return `${hours}h ${minutes}m`;
};

export function formatCurrency(value: number) {
  return Number(value) ? value.toFixed(2) : 0.00;
}


// this function removes the groups we don't need in the dashboard
export const filterGroups = (groups: Group[]) => {
  const blockedNames = [
    "Drivers Manigment Group",
    "Auth User Group",
    "ClientGroup",
    "Frozen Client Group",
    "Driver Group",
    "Frozen Driver Group",
    "Client Group",
  ];

  const normalize = (str: string) =>
    str.toLowerCase().replace(/\s+/g, "").trim();

  const normalizedBlocked = blockedNames.map(normalize);

  return groups.filter((g) => {
    const name = normalize(g.name);
    return !normalizedBlocked.includes(name);
  });
};