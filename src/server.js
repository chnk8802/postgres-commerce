import "dotenv/config";
import app from "./app.js";
import pool from "./db/connection.js";

const PORT = process.env.PORT || 3000;

try {
  const result = await pool.query("SELECT NOW()");
  console.log("PostgreSQL connected:", result.rows[0]);
} catch (error) {
  console.error("Database connection failed:", error);
  process.exit(1);
}

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});