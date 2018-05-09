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
@isTest
private class AsyncTest {
    @isTest
    private static void rejectTest() {
        Test.startTest();

        Async.reject(1)
            .then(fail, success)
            .fork();

        Test.stopTest();
    }

    @isTest
    private static void resolveTest() {
        Test.startTest();

        Async.resolve(1).
            then(assertEquals.apply(1)).
            fork();

        Test.stopTest();
    }

    @isTest
    private static void recoverTest() {
        Test.startTest();

        new Async(R.divide.apply(1, 0))
            .error((Func)R.always.run(new Async(new TestAsyncExecutor('a'))))
            .then(assertEquals.apply('a'))
            .fork();

        Test.stopTest();
    }

    @isTest
    private static void chainTest() {
        Test.startTest();

        new Async(R.add.apply(1, 1))
            .then(R.add.apply(1))
            .then(R.multiply.apply(2))
            .done(assertEquals.apply(6))
            .fork();

        Test.stopTest();
    }

    @isTest
    private static void errorTest() {
        Test.startTest();

        new Async(R.divide.apply(1, 0))
            .then(fail, success)
            .fork();

        Test.stopTest();
    }

    @isTest
    private static void funcInstanceTest() {
        Test.startTest();

        new Async(R.add.apply(1, 1))
            .then(assertEquals.apply(2))
            .fork();

        Test.stopTest();
    }

    @isTest
    private static void executorInstanceTest() {
        Test.startTest();

        new Async(new TestAsyncExecutor('test'))
            .then(assertEquals.apply('test'))
            .fork();

        Test.stopTest();
    }

    private static final Func assertEquals = new AssertEqualsFunc();
    private static final Func success = assertEquals.apply(true, true);
    private static final Func fail = assertEquals.apply(true, false);

    private class TestAsyncExecutor extends Async.Executor {
        private Object val;

        public TestAsyncExecutor(Object val) {
            this.val = val;
        }

        public override Object exec() {
            return this.val;
        }
    }

    private class AssertEqualsFunc extends Func {
        public AssertEqualsFunc() {
            super(2);
        }

        public override Object exec(Object a, Object b) {
            System.assertEquals(a, b);

            return null;
        }
    }
}
