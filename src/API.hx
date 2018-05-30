import tink.http.Client.NodeSecureClient;
import tink.http.Request;
import tink.url.Host;
import tink.Url;
using tink.io.Source;
using StringTools;

class API {
    public static function getDocsJson(version:Int) {
        var jsonDocsPath = "/docs/latest-v{version}.x/api/all.json".replace("{version}", Std.string(version));
        var host = new Host("nodejs.org");

        var client = new NodeSecureClient();
        return client.request(new OutgoingRequest(new OutgoingRequestHeader(GET, host, jsonDocsPath), ''))
            .next(function(res) return res.body.all());
    }
}