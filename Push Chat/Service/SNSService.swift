//
//  SNSService.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/14.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation
import AWSSNS

class SNSService {
    
    private init() {}
    // set our singleton
    static let shared = SNSService()
    
    let topicArn = "arn topic url"
    
    // Remember, in our in-house application, all of this configuration is happening on the Server based php module. For Push-Chat, since we are also pushing messages from the app, we need this configuration inside the app.
    func configure() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "accessKey",
                                                               secretKey: "secretKey")
        
        let serviceConfiguration = AWSServiceConfiguration(region: .apNortheast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
    }
    
    // register for sending chats
    func register(){
        let arn = "arn url"
        
        guard let platformEndpointRequest = AWSSNSCreatePlatformEndpointInput() else { return }
        
        platformEndpointRequest.customUserData = User.current.username
        platformEndpointRequest.token = User.current.token
        platformEndpointRequest.platformApplicationArn = arn
        
        AWSSNS.default().createPlatformEndpoint(platformEndpointRequest).continue ({ (task) -> Any?
            in
            
            guard let endpoint = task.result?.endpointArn else { return nil }
            //print(endpoint)
            
            self.subscribe(to: endpoint)
            
            return nil
        })
    }
    
    // subscribe to an enpoint with a specific topic (topicArn)
    func subscribe(to endpoint: String) {
        guard let subscribeRequest = AWSSNSSubscribeInput() else { return }
        subscribeRequest.topicArn = topicArn
        subscribeRequest.protocols = "application"
        subscribeRequest.endpoint = endpoint
        
        AWSSNS.default().subscribe(subscribeRequest).continue ({ (task) -> Any?
            in
            
            print(task.error ?? "successfully subscribed")
            return nil
        })
    }
    
    func publish(_ message: Message) {
        guard let publishRequest = AWSSNSPublishInput() else { return }
        
        publishRequest.messageStructure = "json"
        
        // no badge handling here, they should normally be handled by a local database.
        let dict = ["default" : message.body,
                    "APNS_SANDBOX" : "{\"aps\" : {\"alert\" : {\"title\" : \"\(message.sender)\", \"body\" : \"\(message.body)\"}, \"sound\" : \"default\", \"category\" : \"\(NotificationCategoryID.reply.rawValue)\"} }"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            publishRequest.message = String(data: jsonData, encoding: .utf8)
            publishRequest.topicArn = topicArn
            
            AWSSNS.default().publish(publishRequest).continue({ (task) -> Any? in
                print(task.error ?? "published message")
                return nil
            })
        } catch {
            print(error)
        }
    }
    
}
