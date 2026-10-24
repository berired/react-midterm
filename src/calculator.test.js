import { describe, expect, it } from "vitest";
import { add, subtract } from "./calculator";

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

describe("Calculator subtraction", () => {
  it("subtracts two positive numbers", () => {
    expect(subtract(10, 4)).toBe(6);
  });
  it("returns a negative result when the second number is larger", () => {
    expect(subtract(3, 8)).toBe(-5);
  });
  it("converts input strings to numbers", () => {
    expect(subtract("10", "5")).toBe(5);
  });
});
