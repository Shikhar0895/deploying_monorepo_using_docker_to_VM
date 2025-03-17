import express from "express";
import "dotenv/config";
import { prismaClient } from "@repo/db/client";
const app = express();

prismaClient
  .$connect()
  .then(() => {
    app.listen(process.env.PORT, () => {
      console.log(`
        DATABASE Connected
        app is listening on http://localhost:${process.env.PORT}`);
    });
  })
  .catch((e: any) => {
    console.error(e);
  });

app.get("/", (req, res) => {
  res.status(200).json({ message: "Welcome to your express http server" });
});
