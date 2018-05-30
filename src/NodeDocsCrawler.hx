import tink.semver.Version;

class NodeDocsCrawler {
    private var versionToCompare:Version;
    public var changes(get, null):Array<{ name:String, type:String, discription:String, added_in:String, isDeprecated:Bool }> = [];

    public function new(versionToCompare:Version) {
        this.versionToCompare = versionToCompare;
    }

    public function crawl(docs:DocsRootSchema) {
        this._crawl(docs.globals);
        this._crawl(docs.miscs);
        this._crawl(docs.modules);
        this._crawl(docs.classes);
        this._crawl(docs.methods);
    }

    function _crawl(docs:Array<DocsEntitySchema>) {
        for (item in docs) {
            var deprecated = false;

            var version = if(untyped item.introduced_in) {
                    item.introduced_in;
                } else if (untyped item.meta) {
                    // TODO: add changes
                    if (untyped item.meta.changes && item.meta.changes.length > 0) {
                        item.meta.changes[0].version;
                    } else if(untyped item.meta.deprecated) {
                        deprecated = true;
                        item.meta.deprecated[0];
                    } else if(untyped item.meta.added) {
                        item.meta.added[0];
                    } else {
                        null;
                    }
                } else {
                    null;
                };

            if (version != null) {
                if (Main.nodeVersionToSemVer(version) > this.versionToCompare) {
                    this.changes.push({
                        name: item.name,
                        type: item.type,
                        discription: item.desc,
                        added_in: version,
                        isDeprecated: deprecated,
                    });
                }
            }

            if (untyped item.miscs)
                this._crawl(item.miscs);

            if (untyped item.modules)
                this._crawl(item.modules);

            if (untyped item.classes)
                this._crawl(item.classes);
            
            if (untyped item.methods)
                this._crawl(item.methods);
        }
    }

    public function get_changes() {
        return this.changes;
    }
}


//TODO: define the entities better
typedef SharedDocschema = {
    introduced_in:String, // maybe should be SemVer
    miscs:Array<DocsEntitySchema>,
    modules:Array<DocsEntitySchema>,
    stability:Int,
    stabilityText:String,
    classes:Array<DocsEntitySchema>,
    methods:Array<DocsEntitySchema>,
}

typedef DocsRootSchema = {
    > SharedDocschema,
    source:String,
    desc:{}, // TODO: maybe persice or emit this
    globals :Array<DocsEntitySchema>,
}

typedef DocsEntitySchema = {
    > SharedDocschema,
    textRaw:String,
    name:String,
    desc:String,
    type:String, // maybe enum it
    displayName:String,
    meta: {
        added:Array<String>, // maybe Array<SemVar>
        deprecated:Array<String>, // maybe Array<SemVar>
        changes:Array<{
            version:String, // maybe semvar
            // pr-url:String, fix problem with that char
            description:String
        }>,
    }
}