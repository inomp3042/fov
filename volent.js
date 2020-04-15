/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

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
            await ctx.stub.putState('Volent' + i, Buffer.from(JSON.stringify(volents[i])));
            console.info('Added <--> ', volents[i]);
        }
        console.info('============= END : Initialize Ledger ===========');
    }

    async queryVolent(ctx, volentNumber) {
        const volentAsBytes = await ctx.stub.getState(volentNumber); // get the car from chaincode state
        if (!volentAsBytes || volentAsBytes.length === 0) {
            throw new Error(`${volentNumber} does not exist`);
        }
        console.log(volentAsBytes.toString());
        return volentAsBytes.toString();
    }

    async createVolent(ctx, volentNumber, time, date, service, certi) {
        console.info('============= START : Create Car ===========');

        const volent = {
            time,
            docType: 'volent',
            date,
            service,
            certi,
        };

        await ctx.stub.putState(volentNumber, Buffer.from(JSON.stringify(volent)));
        console.info('============= END : Create Car ===========');
    }

    async queryAllVolents(ctx) {
        const startKey = 'CAR0';
        const endKey = 'CAR999';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
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
}

module.exports = FabCar;
