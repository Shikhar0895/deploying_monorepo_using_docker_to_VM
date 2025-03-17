import { WebSocket, WebSocketServer } from "ws";
import { prismaClient } from "@repo/db/client";
import "dotenv/config";
const wss = new WebSocketServer({
  port: process.env.PORT as number | undefined,
});

wss.on("connection", async function (socket) {
  await prismaClient
    .$connect()
    .then(() => console.log("DATABASE CONNECTED"))
    .then(() => {
      console.log(`WS server running on ws://localhost:${process.env.PORT}`);
      socket.on("message", (data) => {
        console.log(`Incoming message:${data}`);
        socket.send("Hey there");
      });
    })
    .catch((e: any) => {
      console.error(e);
    });
});
