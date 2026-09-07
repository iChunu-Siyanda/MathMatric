import {defineConfig} from "vitest/config";

export default defineConfig({
  test: {
    environment: "node",
    include: [
      "src/**/*.test.ts",
      "test/**/*.test.ts",
    ],
    exclude: ["lib/**", "node_modules/**"],
  },
});
