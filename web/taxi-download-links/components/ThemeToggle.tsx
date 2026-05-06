"use client";

import { useTheme } from "next-themes";
import { useState, useSyncExternalStore } from "react";
import { Moon, Sun } from "lucide-react";

function useMounted() {
  return useSyncExternalStore(
    () => () => {},
    () => true,
    () => false,
  );
}

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const mounted = useMounted();

  if (!mounted) {
    return (
      <button
        className="p-2 rounded-xl bg-white/5 border border-white/10"
        aria-label="Toggle theme"
      >
        <div className="w-5 h-5" />
      </button>
    );
  }

  const isDark = theme === "dark";

  return (
    <button
      onClick={() => setTheme(isDark ? "light" : "dark")}
      className="relative p-2 rounded-xl transition-all duration-300 hover:scale-110
        dark:bg-white/5 dark:border dark:border-white/10 dark:hover:bg-white/10
        bg-gray-100 border border-gray-200 hover:bg-gray-200"
      aria-label={isDark ? "Switch to light mode" : "Switch to dark mode"}
    >
      {isDark ? (
        <Sun size={20} className="text-amber-400" />
      ) : (
        <Moon size={20} className="text-slate-700" />
      )}
    </button>
  );
}
