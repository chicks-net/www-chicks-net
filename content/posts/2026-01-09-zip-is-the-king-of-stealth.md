+++
title = 'Zip is the King of Stealth File Formats'
date = 2026-01-08T22:25:35-08:00
draft = false
description = 'You are using it everyday without realizing it.'
# cover.image = '/posts/'
cover.hidden = true
keywords = ["zip","sqlite","stealth"]
tags = ["free-software", "database", "programming"]
# ShowToc = true
+++

## Zip Files are Everywhere

I grew up with [PKZIP](https://en.wikipedia.org/wiki/PKZIP). It was a huge
improvement over ARC files and other file formats that were supported on PCs in
the 80’s and 90’s.  Open source implementations of Zip have been available in
Linux since the early days.  In modern times, tools like
[7-Zip](https://en.wikipedia.org/wiki/7-Zip) provide a popular and friendly
interface into the contents of these files. Hopefully this history is already
familiar to you since I’m not going to focus on the usefulness of Zip to users,
but how often developers have turned to it.

Zip files are almost certainly already on your computer, they just don’t have a
.zip extension.  The Zip file format is being used by software developers so
they don’t have to reinvent the wheel of compression or putting multiple files
into one.  Many programming languages provide libraries for retrieving and
adding files to Zip files.  So, if you’re using any of the popular office
suites, your documents are probably Zip files in disguise.  If you’re a
developer in Java, Python, Android, or browsers then you’ve used Zip files that
did not have a .zip extension.  You probably had no idea that Zip was under the
hood.

## Formats that are Zip Files

I’ve tried to link to specs when I was able to find them. I’m sure this is an
incomplete list, but it is already so broad.  And in many cases, the Zip-based
format is the most widely used format for that application.

### Office & Document Formats

- **Microsoft Office XML**: [`.docx`](https://en.wikipedia.org/wiki/Office_Open_XML), [`.xlsx`](https://en.wikipedia.org/wiki/Office_Open_XML), [`.pptx`](https://en.wikipedia.org/wiki/Office_Open_XML), `.vsdx` (Visio)
- **OpenDocument**: [`.odt`](https://en.wikipedia.org/wiki/OpenDocument), `.ods`, [`.odp`](https://en.wikipedia.org/wiki/OpenDocument), [`.odg`](https://en.wikipedia.org/wiki/OpenDocument) (LibreOffice/OpenOffice)
- **Apple iWork**: `.pages`, `.numbers`, `.key` (Keynote)
- **EPUB ebooks**: [`.epub`](https://en.wikipedia.org/wiki/EPUB)

### Development & Application Files

- **Java archives**: [`.jar`](https://en.wikipedia.org/wiki/JAR_(file_format%29), `.war`, `.ear`
- **Android packages**: [`.apk`](https://en.wikipedia.org/wiki/Apk_(file_format%29#Package_contents)
- **Browser extensions**: [`.xpi`](https://en.wikipedia.org/wiki/List_of_file_formats#Native_executable) (Firefox), [`.crx`](https://en.wikipedia.org/wiki/List_of_archive_formats#Software_packaging_and_distribution) (Chrome - after header), [.maff](https://en.wikipedia.org/wiki/Mozilla_Archive_Format)
- **Python wheels**: [`.whl`](https://peps.python.org/pep-0427/)
- **Sublime Text packages**: [`.sublime-package`](https://www.sublimetext.com/docs/packages.html)

### Design & Graphics

- **Sketch**: [`.sketch`](https://developer.sketch.com/file-format/) (Mac design tool)
- **OpenRaster**: [`.ora`](https://en.wikipedia.org/wiki/OpenRaster) (GIMP, Krita)
- **Adobe InDesign packages**: `.indd` (when packaged)
- **KMZ**: [`.kmz`](https://developers.google.com/kml/documentation/kmzarchives) (Google Earth - compressed KML)

### 3D & Manufacturing

- **3D Manufacturing Format**: [`.3mf`](https://en.wikipedia.org/wiki/3D_Manufacturing_Format)
- **STL containers**: Some `.stl` variants
- **MakerBot**: [.thing](https://support.makerbot.com/s/article/File-Types)

### Label & Specialty Formats

- **Brother label files**: [`.lbx`](https://github.com/Alecto3-D/brother-p-touch-editor-format), `.pte` (P-touch Editor)
- **Mozilla Archive Format**: [.maff](https://en.wikipedia.org/wiki/Mozilla_Archive_Format)
- **OpenDocument templates**: [`.ott`](https://en.wikipedia.org/wiki/OpenDocument), [`.ots`](https://en.wikipedia.org/wiki/OpenDocument), [`.otp`](https://en.wikipedia.org/wiki/OpenDocument)

The long-tail of zip-based formats probably has hundreds of examples.

## Other Contenders for Stealth File Format Domination

Since it is the computer business we have to be clear on [our attitude toward standardization](https://wiki.c2.com/?AndrewTanenbaum):

> The nice thing about standards is that you have so many to choose from;
> furthermore, if you do not like any of them, you can just wait for next
> year's model.

So let's look at some of the other choices.

### SQLite

SQLite is an amazing database because of its [extremely thorough test
suite](https://sqlite.org/testing.html) and small footprint.  Relational
databases are handy ways to access and update your application’s data, so
SQLite is often embedded to provide the storage layer.  Again, it is a huge win
to avoid reinventing the wheel.  Examples of applications you are already using
that are using SQLite internally:

- **Browser data**: Chrome/Firefox history, cookies, bookmarks
- **Apple**: iMessage database, Photos library metadata, iOS backups
- **Application data**: Skype, Adobe Lightroom catalogs, many mobile apps

This also means that you can use SQLite-compatible tools to hack around in the
data layer of your applications. Go exploring.  I can’t wait to hear what you
build on this data that is far from what the developers envisioned.

Naturally there are a slew of database products built on this foundation.

#### Proprietary Products Built on SQLite

- [**SQLCipher**](https://www.zetetic.net/sqlcipher/) - Adds 256-bit AES encryption to SQLite. Has both open-source and commercial editions. Used by many commercial apps requiring encrypted local storage.
- [**Couchbase Lite**](https://www.couchbase.com/products/lite/) - Mobile/embedded NoSQL database that uses SQLite for storage underneath its document model. Syncs with Couchbase Server.
- [**ActorDB**](https://www.actordb.com/) - Commercial distributed SQL database that uses SQLite as the storage engine on each node with actor-model distribution on top.
- **Oracle Berkeley DB** - Oracle's embedded database has SQL API support built on SQLite components (though Berkeley DB itself predates this).

#### Distributed/Replicated SQLite

- [**Litestream**](https://litestream.io/) - Streaming replication to S3/Azure/GCS. Makes SQLite viable for production by continuously backing up to object storage.
- [**LiteFS**](https://fly.io/docs/litefs/) - Distributed filesystem for SQLite by Fly.io. Provides FUSE-based replication across nodes.
- [**rqlite**](https://rqlite.io/) - Distributed relational database using Raft consensus. SQLite on every node with automatic replication.
- [**dqlite**](https://dqlite.io/) - Canonical's distributed SQLite built on Raft. Used in LXD and other infrastructure projects.
- [**Turso**](https://turso.tech/) - libSQL-based (SQLite fork) edge database with global replication. Commercial service built on SQLite foundation.

#### Enhanced SQLite Variants

- [**libSQL**](https://github.com/tursodatabase/libsql) - Open-source SQLite fork by Turso/ChiselStrike. Adds features like WASM functions, encryption, virtual WAL interfaces.
- [**SQLite Cloud**](https://sqlitecloud.io/) - Commercial distributed SQLite service with client-server architecture.
- [**cr-sqlite**](https://github.com/vlcn-io/cr-sqlite) - CRDTs for SQLite, enabling multi-writer replication and local-first applications.

#### Application Frameworks

- [**Datasette**](https://datasette.io/) - Publishes SQLite databases as interactive websites/APIs. Great for data journalism and exploration.

The distributed variants (rqlite, dqlite, LiteFS) are particularly interesting
for production use on Linux servers where you want SQLite's simplicity with
multi-node reliability.

### HDF5 (Hierarchical Data Format)

Scientific computing's [universal container](https://en.wikipedia.org/wiki/Hierarchical_Data_Format):

- **MATLAB**: `.mat` files (version 7.3+)
- **Neuroimaging**: Various brain imaging formats
- **Climate/geospatial**: NetCDF-4
- Python's PyTables, various scientific data stores
- Tools: `h5dump`, HDFView

Not that stealthy and pretty niche, but worth a mention. It would be cool to
see this spread beyond its current niche.

### TAR (Tape Archive)

Beyond `.tar.gz`, it underlies:

- **Container images**: Docker/OCI layers
- **Package formats**: `.deb` (Debian packages contain tar archives)
- **Backups**: Time Machine uses tar variants
- The go-to for preserving Unix permissions/metadata

### RIFF (Resource Interchange File Format)

Microsoft's chunk-based format:

- **Audio**: `.wav`
- **Video**: `.avi`
- **Images**: `.webp`
- **MIDI**: Some variants

## Conclusion

I’m a big fan of sqlite and I’m so glad to see it has been adopted in so many
places, but based on my recollection and research, Zip is still the file format
to beat if your goal is world domination.

Let me know if I’ve missed any gems in the stealth file format landscape.  You
could even file a github issue or pull request if you see a gap that you’re
sure should be filled.
