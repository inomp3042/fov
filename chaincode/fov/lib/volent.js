
'use strict';

const { Contract } = require('fabric-contract-api');
const crypto = require('crypto');

class Volenteer extends Contract {

    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        const volents = [
            {
                time: '6',
                date: '2019-01-01',
                service: 'HyoHostpital',
                certi: '34235432',
            },
            {
                time: '3',
                date: '2019-03-03',
                service: 'AAA',
                certi: '22334441',
            },
            {
                time: '8',
                date: '2020-01-03',
                service: 'Tasfa',
                certi: '44433322',
            },
        ];

        for (let i = 0; i < volents.length; i++) {
            volents[i].docType = 'volent';

            const key = this.createKey(ctx, 'VOLENT', volents[i]);
            await ctx.stub.putState(key, Buffer.from(JSON.stringify(volents[i])));
            console.info('Added <--> ', volents[i]);
        }
        console.info('============= END : Initialize Ledger ===========');
    }

    async queryVolent(ctx, volentNumber) {
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByPartialCompositeKey('string', ["VOLENT",volentNumber.toString('utf8')])) {
            if (!value)
                continue;
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }

    async createVolent(ctx, volentNumber, time, date, service, certi) {
        console.info('============= START : Create Volent ===========');

        const volent = {
            time,
            docType: 'volent',
            date,
            service,
            certi,
        };

        const key = this.createKey(ctx, "VOLENT", volent);
        await ctx.stub.putState(key, Buffer.from(JSON.stringify(volent)));
        console.info('============= END : Create Volent ===========');
    }

    async queryAllVolents(ctx) {
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByPartialCompositeKey('string', ["VOLENT"])) {
            if (!value)
                continue;
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }

/*    async changeCarOwner(ctx, carNumber, newOwner) {
        console.info('============= START : changeCarOwner ===========');

        const carAsBytes = await ctx.stub.getState(carNumber); // get the car from chaincode state
        if (!carAsBytes || carAsBytes.length === 0) {
            throw new Error(`${carNumber} does not exist`);
        }
        const car = JSON.parse(carAsBytes.toString());
        car.owner = newOwner;

        await ctx.stub.putState(carNumber, Buffer.from(JSON.stringify(car)));
        console.info('============= END : changeCarOwner ===========');
    }
*/
    createKey(ctx, number, data) {
        let hashValue = crypto.createHash('sha256').update(JSON.stringify(data)).digest('hex').toString('utf8');
        let certi = data.certi.toString('utf8');
        return ctx.stub.createCompositeKey('string', [number.toString('utf8'), certi, hashValue ]);
    }
}

module.exports = Volenteer;
