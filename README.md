# JSVKit
This package contains a collection of various components, helper functions, extensions and classes for making
development a little bit faster.

## Observable
The observable type can store any type of value. It is possible to add listeners to the observable that will be notified when the value changes.
Note that it is very important to stop listening at some point, or memory leaks can occur.
The callback function (valueChanged) will also be called when the value changes. This function is used in the other Bound Components when calling .bind.

The JSVBound components are to be used together with an observable to bind the value to the component.

### Table View Cells
The table view cells are used as regular UITableViewCell's that you also bind an Observable to.

### Extensions
There are various extensions for Arrays, CGPoint, UIColor, Float, UIView and SCNVector3 (mostly linear algebra operations).

### Call stack
The call stack is a stack that contains Jobs. These jobs are executed on it's respective thread in the order they were added to the stack.
Jobs can run parallell to each other if the maximumCalls variable is set a value greater than one.
Since the jobs are executed asynchronously it is important that the caller calls jobWasFinished() after manually after each job has been
completed. If not, the stack will be stalled after having run a number of jobs corresponding to maximumCalls.

### Bit stream
BitStreamCodable is put together of BitStreamEncodable and BitStreamDecodable. These protocols can encode and decode values much
more efficiently than NSKeyedArchiver, which encodes the values to a much larger data size. This makes the BitStreamCodable protocol
good to use when sending data over the network in an efficient manner.

It is the users responsibility to encode and decode the data correctly, or else the code will throw errors.
When the data has been appended to the stream it is important to call packData() to get the raw data.

To use the BitStreamCodable, simply extend it for the class that should be encoded/decoded.

### Multipeer Session
A multipeer session uses the MultipeerConnectivity library and is a sandbox class that lets the user connect to one other peer at a time.

Call startLooking() after having set up the session. This will start looking for other peers nearby, as well as notifying other peers that the device is available. Call stopLooking to stop finding and notifying nearby peers.

When a nearby peer is detected it will call nearbyPeersChanged with the current nearby peers. This list can then be used to invite a peer to a
session by calling invite(). The caller of invite will become the master of the session. It is up to the user of Multipeer Session to decide what that means.

When a connection is established, the callback function connectedUserChanged will be called. Nil means that a disconnection occurred.
If there is a connected peer to the session it is possible to send data with sendData and sendResource. The callback function receivedData will
be called when receiving data from a connected peer.

It is possible to reset the session by calling resetSession. This sets up a new session with the same peerID as the last session, while throwing the old session completely.

### Multi-orientation view
Inherits from UIView. Allows a user to set up a view with constaints for landscape and portrait mode by adding constraints to its two lists.
The constraints will be automatically activated and deactivated when changing orientation.

### In app purchase client (IAPClient)
Sandbox class for making in app purchases.

### Audio Player
JSVAudioPlayer can store many different AVAudioPlayers and each of their sounds at any time by calling play().
JSVAudioPlayer is a singleton because there is no need to have multiple instances of it.

To be able to play a sound, first the sound urls have to be registered by extending JSVSound.Name in a similar way that notifications
are custom build in NotificationCenter.

The string should be the same name as the sound file, without the extension. The format of the sound file should be .m4a.
