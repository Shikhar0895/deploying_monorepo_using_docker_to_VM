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
  .catch((e) => {
    console.error(e);
  });
