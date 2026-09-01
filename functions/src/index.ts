import {onRequest} from "firebase-functions/https";

export const helloMathMatric = onRequest(
  (request, response) => {
    response.send("MathMatric backend is alive.");
  },
);
