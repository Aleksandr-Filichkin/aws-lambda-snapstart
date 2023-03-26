package com.filichkin.blog.lambda.v2.handler;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.filichkin.blog.lambda.model.Book;
import com.filichkin.blog.lambda.storage.EnhancedClientBookStorage;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

import static com.filichkin.blog.lambda.storage.BookStorage.TABLE_NAME;


public class BookHandler implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private static final EnhancedRequestDispatcher ENHANCED_REQUEST_DISPATCHER = initDispatcher();

    static {
        ENHANCED_REQUEST_DISPATCHER.warmUp();
    }

    private static EnhancedRequestDispatcher initDispatcher() {
        DynamoDbEnhancedClient dynamoDbEnhancedClient = DynamoDbEnhancedClient.builder()
                .dynamoDbClient(DynamoDbClient.builder()
                        .region(Region.EU_WEST_1)
                        .build())
                .build();
        DynamoDbTable<Book> dynamoDbTable = dynamoDbEnhancedClient.table(TABLE_NAME, TableSchema.fromBean(Book.class));
        return new EnhancedRequestDispatcher(new EnhancedClientBookStorage(dynamoDbTable), new ObjectMapper());
    }

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent apiGatewayProxyRequestEvent, Context context) {
        return ENHANCED_REQUEST_DISPATCHER.dispatch(apiGatewayProxyRequestEvent);
    }
}
