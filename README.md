Newrelic ZFS Plugin
===================

The newrelic_zfs_plugin is a plugin agent that allows the monitoring of ZFS pools using the Newrelic platform.  It returns the information exposed by the 'zpool list' command and provides some basic summary metrics.

The key feature is that it allows alerts to be sent when a pool is degraded or offline, or when a pool is running out of capacity

Installation
------------

1. Install Ruby
2. Run command 'gem install newrelic_zfs'

Usage
-----

The plugin needs configuring before it can be used:

1. Run command 'newrelic_zfs'
2. Enter y to create a config file
3. Enter the path to where you want the file to be created (this path must already exist)
4. Enter your API key
5. Enter a name for the server/instance you are running
6. The config file will have been created and the plugin will start running, reporting data to Newrelic (it might take a few minutes to appear in your Newrelic account)
7. To run the plugin in the future, simply run the command 'newrelic_zfs path/to/config.yml'

Lastly, you will probably want to daemonize the process and set it to run at startup, using whatever your preferred method is.
