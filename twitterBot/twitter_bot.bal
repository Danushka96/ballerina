//First Config twitter.toml with your own credetials
//run command
//ballerina run --config twitter.toml twitter_bot.bal
//
//client side command
//curl -d "My new tweet" -X POST localhost:9090 
import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint twitter:Client tweeter {
  clientId: config:getAsString("clientId"),
  clientSecret: config:getAsString("clientSecret"),
  accessToken: config:getAsString("accessToken"),
  accessTokenSecret: config:getAsString("accessTokenSecret"),
  clientConfig:{}  
};

@http:ServiceConfig {
  basePath: "/"
}
service<http:Service> hello bind {port:9090} {

  @http:ResourceConfig {
      path: "/",
      methods: ["POST"]
  }
  hi (endpoint caller, http:Request request) {
      http:Response res;
      string payload = untaint check request.getTextPayload();

      // transformation of request value on its way to Twitter
      if (!payload.contains("#ballerina")){payload=payload+" #ballerina";}

      twitter:Status st = check tweeter->tweet(payload);

      // transformation on the way out - generate a JSON and pass it back
      json myJson = {
          text: payload,
          id: st.id,
          agent: "ballerina"
      };

      // pass back JSON instead of text
      res.setPayload(myJson);

      _ = caller->respond(res);
  }
}