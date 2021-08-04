import express from "express";
import cors from "cors";
import { createHaberdasherServer } from "./generated/service.twirp";
import { protobufClient } from "./client";
import { createGateway, FindHatRPC, Hat, ListHatRPC } from "./generated";

const server = createHaberdasherServer({
  async MakeHat(_, request): Promise<Hat> {
    return Hat.fromJson({
      name: "cup",
      inches: request.inches,
      color: "blue",
    });
  },
  async FindHat(_, request): Promise<FindHatRPC> {
    return request;
  },
  async ListHat(_, request): Promise<ListHatRPC> {
    return request;
  },
});

const app = express();
const gateway = createGateway();

app.use(cors());
app.use(gateway.twirpRewrite());
app.post(server.matchingPath(), server.httpHandler());

app.use(gateway.twirpRewrite());
app.post(server.matchingPath(), server.httpHandler());

app.listen(8000, async () => {
  const protobufResp = await protobufClient.MakeHat({
    inches: 1,
  });
  console.log("response from Protobuf client", protobufResp);
});
