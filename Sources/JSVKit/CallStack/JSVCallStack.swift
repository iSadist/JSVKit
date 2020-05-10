import Foundation

/// JSVCallStack
public class JSVCallStack {
    
    /// Initialize the call stack
    public init() {
    }

    fileprivate var nbrJobsRunning: Int = 0
    fileprivate var maximumCallsPrivate: Int = 1
    fileprivate var stack: [Job] = []
    
    /// The maximum number of calls that can be performed at the same time
    public var maximumCalls: Int {
        get {
            return maximumCallsPrivate
        }
        set {
            maximumCallsPrivate = newValue >= 1 ? newValue : 1
        }
    }

    func jobWasFinished() {
        nbrJobsRunning -= 1
        if !stack.isEmpty {
            let job = stack.removeFirst()
            
            nbrJobsRunning += 1
            job.queue.async {
                job.function()
            }
        }
    }
    
    /// Try to run a job right away or append it to the call stack and run it as soon as possible.
    /// - Parameters:
    ///   - method: The function that is going to be run. The provided completed function must be called when the method is done.
    ///   - queue: The DispatchQueue that the method should run on.
    public func addToStack(method: @escaping (() -> Void), queue: DispatchQueue) {
        if nbrJobsRunning < maximumCalls {
            nbrJobsRunning += 1
            queue.async {
                method()
            }
        } else {
            // Append the job to the stack
            let job = Job(function: method, queue: queue)
            stack.append(job)
        }
    }
}
