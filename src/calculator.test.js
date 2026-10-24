import { describe, expect, it } from "vitest";
import { add } from "./calculator";

describe("Calculator addition", () => {
  it("adds two positive numbers", () => {
    expect(add(2, 3)).toBe(5);
  });
  it("adds negative numbers", () => {
    expect(add(-2, -3)).toBe(-5);
  });
  it("converts input strings to numbers", () => {
    expect(add("10", "5")).toBe(15);
  });
});
