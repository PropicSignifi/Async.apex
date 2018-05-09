/**
 * MIT License
 *
 * Copyright (c) 2018 Click to Cloud Pty Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 **/
/**
 * Promise-like interface for Apex
 *
 * Dependencies:
 *     R.apex
 * */
public class Async implements Queueable, Database.AllowsCallouts {
    // Pending status
    public static final Status PENDING = new Status('Pending');

    // Fulfilled status
    public static final Status FULFILLED = new Status('Fulfilled');

    // Rejected status
    public static final Status REJECTED = new Status('Rejected');

    // wrapped executor
    private Executor mExecutor;

    // wrapped data
    private Object data;

    // status of promise
    private Status mStatus = PENDING;

    // registered success handlers
    private List<Func> successHandlers = new List<Func>();

    // registered error handlers
    private List<Func> errorHandlers = new List<Func>();

    /**
     * Construct Async from Executor
     *
     * @param executor Async Executor
     * */
    public Async(Async.Executor executor) {
        this.mExecutor = executor;
        this.mExecutor.setPromise(this);
    }

    /**
     * Construct Async from Func
     *
     * @param f The func object
     * */
    public Async(Func f) {
        this(new FuncExecutor(f));
    }

    // Construct Async from status and data
    private Async(Status mStatus, Object data) {
        this.mStatus = mStatus;
        this.data = data;
    }

    /**
     * Create a resolved Async
     *
     * @param val The wrapped value
     * */
    public static Async resolve(Object val) {
        if(val instanceof Async) {
            return (Async)val;
        }
        else {
            return new Async(FULFILLED, val);
        }
    }

    /**
     * Create a rejected Async
     *
     * @param error The wrapped error
     * */
    public static Async reject(Object error) {
        if(error instanceof Async) {
            return (Async)error;
        }
        else {
            return new Async(REJECTED, error);
        }
    }

    /**
     * Check if Async is pending
     *
     * @return Boolean
     * */
    public Boolean isPending() {
        return this.mStatus == PENDING;
    }

    /**
     * Check if Async is resolved
     *
     * @return Boolean
     * */
    public Boolean isResolved() {
        return this.mStatus == FULFILLED;
    }

    /**
     * Check if Async is rejected
     *
     * @return Boolean
     * */
    public Boolean isRejected() {
        return this.mStatus == REJECTED;
    }

    private void doResolve(Object data) {
        if(this.isPending()) {
            this.mStatus = FULFILLED;
            this.data = data;

            this.doChain();
        }
    }

    private void doReject(Object error) {
        if(this.isPending()) {
            this.mStatus = REJECTED;
            this.data = error;

            this.doChain();
        }
    }

    private void doChain() {
        if(this.isResolved()) {
            Async newPromise = null;
            while(!this.successHandlers.isEmpty()) {
                Func successHandler = this.successHandlers.remove(0);
                Object val = successHandler.run(this.data);
                if(val instanceof Async) {
                    newPromise = (Async)val;
                    break;
                }
                else {
                    this.data = val;
                }
            }

            if(newPromise != null) {
                for(Func successHandler : this.successHandlers) {
                    newPromise.then(successHandler);
                }

                for(Func errorHandler : this.errorHandlers) {
                    newPromise.error(errorHandler);
                }

                newPromise.fork();
            }
        }
        else if(this.isRejected()) {
            Async newPromise = null;
            while(!this.errorHandlers.isEmpty()) {
                Func errorHandler = this.errorHandlers.remove(0);
                Object val = errorHandler.run(this.data);
                if(val instanceof Async) {
                    newPromise = (Async)val;
                    break;
                }
                else {
                    this.data = val;
                }
            }

            if(newPromise != null) {
                for(Func successHandler : this.successHandlers) {
                    newPromise.then(successHandler);
                }

                for(Func errorHandler : this.errorHandlers) {
                    newPromise.error(errorHandler);
                }

                newPromise.fork();
            }
        }
    }

    /**
     * Execute the Async
     * */
    public void fork() {
        if(this.isPending()) {
            System.enqueueJob(this);
        }
        else {
            this.execute(null);
        }
    }

    /**
     * Callback for Queueable
     * */
    public void execute(QueueableContext context) {
        if(this.mExecutor != null) {
            try {
                this.mExecutor.run();
            }
            catch(Exception e) {
                this.doReject(e);
            }
        }
        else if(!this.isPending()){
            this.doChain();
        }
    }

    /**
     * Register success handler and error handler
     *
     * @param successHandler The success handler Func
     * @param errorHandler The error handler Func
     * @return Async
     * */
    public Async then(Func successHandler, Func errorHandler) {
        if(successHandler != null) {
            this.successHandlers.add(successHandler);
        }

        if(errorHandler != null) {
            this.errorHandlers.add(errorHandler);
        }

        return this;
    }

    /**
     * Register success handler
     *
     * @param successHandler The success handler Func
     * @return Async
     * */
    public Async then(Func successHandler) {
        return this.then(successHandler, null);
    }

    /**
     * Register error handler
     *
     * @param errorHandler The error handler Func
     * @return Async
     * */
    public Async error(Func errorHandler) {
        return this.then(null, errorHandler);
    }

    /**
     * Register the handler as both the success and error handler
     *
     * @param doneHandler The done handler Func
     * @return Async
     * */
    public Async done(Func doneHandler) {
        return this.then(doneHandler, doneHandler);
    }

    private class Status {
        private String value;

        public Status(String value) {
            this.value = value;
        }

        public override String toString() {
            return this.value;
        }

        public Boolean equals(Object other) {
            return other instanceof Status && ((Status)other).value == this.value;
        }

        public Integer hashCode() {
            return this.value.hashCode();
        }
    }

    /**
     * The Executor contains the async code logic in the Async
     * */
    public virtual class Executor extends Func {
        private Async p;

        public void setPromise(Async p) {
            this.p = p;
        }

        protected void resolve(Object data) {
            this.p.doResolve(data);
        }

        protected void reject(Object error) {
            this.p.doReject(error);
        }
    }

    private class FuncExecutor extends Executor {
        private Func f;

        public FuncExecutor(Func f) {
            this.f = f;
        }

        public override Object exec() {
            try {
                Object val = this.f.run();
                this.resolve(val);
            }
            catch(Exception e) {
                this.reject(e);
            }

            return null;
        }
    }
}
