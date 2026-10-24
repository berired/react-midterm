import { useState } from "react";
import { add, subtract } from "./calculator";

export default function App() {
  const [first, setFirst] = useState("");
  const [second, setSecond] = useState("");
  const [result, setResult] = useState(null);

  return (
    <main style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>Midterm Calculator</h1>
      <p>Student: David Xander Wagan</p>
      <p>Application Version: 1.1</p>
      <div>
        <label>
          First number:
          <input
            type="number"
            value={first}
            onChange={(event) => setFirst(event.target.value)}
          />
        </label>
      </div>
      <div>
        <label>
          Second number:
          <input
            type="number"
            value={second}
            onChange={(event) => setSecond(event.target.value)}
          />
        </label>
      </div>
      <button onClick={() => setResult(add(first, second))}>
        Add Numbers
      </button>
      <button onClick={() => setResult(subtract(first, second))}>
        Subtract Numbers
      </button>
      {result !== null && <h2>Result: {result}</h2>}
    </main>
  );
}
