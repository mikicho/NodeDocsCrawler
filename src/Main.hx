import tink.Cli;  // TODO: uyse tink_cli
// TODO: check that first arg lower than second one
// TODO: add tests
import tink.semver.Version;
import sys.io.File;

class Main {
    static function main() {
        var lowVersion = nodeVersionToSemVer(Sys.args()[0]);
        var highVersion = Std.parseInt(Sys.args()[1]); // TODO: remove parseint
        // TODO: solve this shit
        API.getDocsJson(highVersion).handle(function(o) switch o {
            case Success(body): 
            var json = haxe.Json.parse(body.toString());
            var crawler = new NodeDocsCrawler(lowVersion);
            crawler.crawl(json);
            createHTML(crawler.changes);
            case Failure(e): trace(e);
        });
    }

    public static function createHTML(changes:Array<{ name:String, type:String, discription:String, added_in:String, isDeprecated:Bool }>) {
        var html = "";
        
        for (change in changes) {
            html += '<h2>${change.name} - ${change.added_in}</h2>';
            html += change.discription;
        }

        File.saveContent("./bin/changes.html", html);
    }

    public static function nodeVersionToSemVer(version:String) {
        if (version.charAt(0) == "v") {
            version = version.substr(1);
        }

        var versionParts = version.split(".").map(function(versionPart) { return Std.parseInt(versionPart); });
        return new Version(versionParts[0], versionParts[1], versionParts[2]);
    }
}
