# NodeDocsCrawler

**This project is POC and not intended for a production usage yet!**

This tiny tool crawl over nodejs docs json file (i.e: `https://nodejs.org/docs/latest-v10.x/api/all.json`) and extract all the changes that happen between two versions.

## how to use:

1. Clone this repo.
2. build the project: `haxe build.hxml`
3. run it by: `node .\bin\NodeDocsCrawler.js [base version semvar] [upper version numer]`

For example:
```
node .\bin\NodeDocsCrawler.js 9.0.0 10 // Find all changes between 9.0.0 version to 10-latest
node .\bin\NodeDocsCrawler.js 8.2.0 9
node .\bin\NodeDocsCrawler.js 0.12.0 4
```

## Output
The result of the command is all the nodejs entities that has been added to nodejs between those versions:

![results](https://user-images.githubusercontent.com/11459632/40736348-7cdf65c2-6446-11e8-9ce1-da56fac8b58d.png)
