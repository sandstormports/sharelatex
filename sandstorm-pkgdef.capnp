@0xb1ad881ac0baba9f;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "5vuv7v0w7gu20z72m78n83rx9qqtqpmtk32f39823wh967z226qh",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "ShareLaTeX"),

    appVersion = 8,  # Increment this for every release.

    appMarketingVersion = (defaultText = "0.1.4"),

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New ShareLaTeX Project"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/home/david/.nvm/v0.10.36/bin/node", packagePath = "usr/bin/node"),
      ( sourcePath="/usr/bin/niscud",  packagePath="usr/bin/mongod"),
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/host.conf", "etc/localtime", "etc/nsswitch.conf",
                      "etc/resolv.conf"
                      ]
      ),
      ( sourcePath = "/var/lib/texmf", packagePath="usr/local/lib/texmf")
    ]
  ),

  fileList = "sandstorm-files.list",

  alwaysInclude = ["web/public",
                   "usr/share/texmf-dist",
                   "document-updater/node_modules/redis-sharelatex/node_modules/coffee-script",
                   "web/node_modules/redis-sharelatex/node_modules/coffee-script",
                   "track-changes/node_modules/redis-sharelatex/node_modules/coffee-script",
                   "real-time/node_modules/redis-sharelatex/node_modules/coffee-script"],

  bridgeConfig = (
    viewInfo = (
       permissions = [(name = "read", title = (defaultText = "read"),
                       description = (defaultText = "allows viewing")),
                      (name = "write", title = (defaultText = "write"),
                       description = (defaultText = "allows editing"))],
       roles = [(title = (defaultText = "collaborator"),
                 permissions = [true, true],
                 verbPhrase = (defaultText = "can read and write"),
                 default = true),
                (title = (defaultText = "reader"),
                 permissions = [true, false],
                 verbPhrase = (defaultText = "can read"))]
    )
  )

);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "2999", "--", "/usr/bin/sh", "start.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "USER", value="sharelatex"),
    (key = "HOME", value="/var")
  ]
);
