/**
 * bms2json
 * 
 * a tool for converting .bms files into URG .jsons
 * 
 * programmed and designed by Rin, 2020
 */

const fs = require('fs');
const bms = require('./bms-js');

let filename = process.argv[2];
if (!filename) {
    console.log('usage: node bms2json.js <FILE.bms> [outputfile.json, defaults to "output.json"]');
    process.exit(0);
}

let fileString;
try {
    fileString = fs.readFileSync(filename);
} catch(e) {
    console.log('-- ERROR --')
    console.log(e)
    process.exit(1)
}

let output = {title: 'x', author: 'y', offset: 0, audio: 'FILL_THIS_IN.wav', bpms: [[0, 130]], notes: []};

let compileResult = bms.Compiler.compile(bms.Reader.read(fileString));
let chart = compileResult.chart;
let notes = bms.Notes.fromBMSChart(chart).all();
let info = bms.SongInfo.fromBMSChart(chart);
output.title = info.title;
output.author = info.artist;
output.bpms[0][1] = bms.Timing.fromBMSChart(chart).bpmAtBeat(0);

let anotes = notes.filter(e => e.column !== undefined);
const mapping = {
    'SC': 1,
    '1': 2,
    '2': 3,
    '3': 4,
    '4': 5,
    '5': 6,
    '6': 7,
    '7': 8
}

for (let i of anotes) {
    output.notes.push({beat: i.beat, note: mapping[i.column]});
}

fs.writeFileSync(process.argv[3] || 'output.json', JSON.stringify(output));
console.log('-- OK --')