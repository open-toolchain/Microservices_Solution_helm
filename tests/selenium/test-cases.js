var wd = require('wd');
require('colors');
var _ = require("lodash");
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
var url = process.env.APP_URL;

chai.use(chaiAsPromised);
chai.should();
chaiAsPromised.transferPromiseness = wd.transferPromiseness;

// http configuration, not needed for simple runs
wd.configureHttp( {
    timeout: 60000,
    retryDelay: 15000,
    retries: 5
});

var desired = JSON.parse(process.env.DESIRED || '{browserName: "chrome"}');
desired.name = 'MicroUI with ' + desired.browserName;
desired.tags = ['MicroUI'];

describe('MicroUI(' + desired.browserName + ')', function() {
    var browser;
    var allPassed = true;

    before(function(done) {
        browser = wd.promiseChainRemote();
        if(process.env.VERBOSE){
            // optional logging     
            browser.on('status', function(info) {
                console.log(info.cyan);
            });
            browser.on('command', function(meth, path, data) {
                console.log(' > ' + meth.yellow, path.grey, data || '');
            });            
        }
        browser
            .init(desired)
            .nodeify(done);
    });

    afterEach(function(done) {
        allPassed = allPassed && (this.currentTest.state === 'passed');  
        done();
    });

    after(function(done) {
        browser
            .quit()
            .nodeify(done);
    });

    it("Have correct title", function(done) {
        browser
            .get(url)
            .title()
            .should.become("Microservices Sample")
            .nodeify(done);
    });
});
