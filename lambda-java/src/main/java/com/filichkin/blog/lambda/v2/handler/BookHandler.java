package com.filichkin.blog.lambda.v2.handler;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.KinesisEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class BookHandler implements RequestHandler<KinesisEvent, String> {

    /**
     * All clients should be static and initialized on init state, it dramatically reduces cold start, because use CPU burst of AWS Lambda.
     */

    private static final Logger LOGGER = LoggerFactory.getLogger(BookHandler.class);


    @Override
    public String handleRequest(KinesisEvent apiGatewayProxyRequestEvent, Context context) {
        LOGGER.info("1");
        LOGGER.info(apiGatewayProxyRequestEvent.getRecords().get(0).toString());
        return "test";
    }
}
