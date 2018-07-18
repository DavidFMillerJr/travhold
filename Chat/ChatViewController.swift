//
//  ChatViewController.swift
//  Chat
//
//  Created by Cindy Lin on 7/18/18.
//  Copyright © 2018 Cindy Lin. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    
    // Bubble Factory
    // Create two properties called outgoingBubble and incomingBubble, both of type JSQMessagesBubbleImage
    // Both properties are computed properties. This means that they don't have a fixed value,
    // but a computed value: the result of a function.
    // Both properties are lazy, which means that they're only initialized once -- when they're accessed.
    // When you access a lazy property for the first time, its value is intiailized ("created").
    // For every subsequent access, the value of the property isn't recreated, but returns the initial 
    // value.
    // In Swift, typical computed properties can't be lazy! Coded around that by creating a closure.
    // The closure's result is the value for the lazy property, effectively creating a lazy computed
    // property.
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = "1234"
        senderDisplayName = "Cindy"
        //Hides attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        //Set avatar sizes to 0, therefore hiding it
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        finishReceivingMessage()
    }
    
    // Returns an item from messages based on the index from indexPath.item, effectively running the
    // message data for a particular message by its index
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    // Returns the total number of messages, based on messages.count -- the amount of items in the array!
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    // Called by JSQMVC when it needs bubble image data
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble: incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    // Called when the label text is needed
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    // Called when the height of the top label is needed
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    // This function overrides a function on JSQMessagesViewController, the class you subclassed.
    // This enables you to override what happens when a user presses the Send button, effectively
    // creating your own implementation
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        //Create a reference to a new value, in Firebase, on the /chats node, using childByAutoId()
        //let ref = Constants.refs.databaseChats.childByAutoId()
        
        //You create a dictionary called message that contains all the information about the
        //to-be-send message
        //let messageDic = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        let array = text.components(separatedBy: ", ")
        
        if let message = JSQMessage(senderId: array[0], displayName: senderDisplayName, text: array[1])
        {
            messages.append(message)
        }
        //You set the reference to the value - you store the dictionary in the new created node
        //ref.setValue(message)
        
        //Tells JSQMVC you're done
        finishSendingMessage()
    }
}

