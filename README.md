## ZFS Agent Install

1. Install Ruby
2. Run gem install newrelic_zfs
3. Run newrelic_zfs
4. Enter y to create a config file
5. Enter the path to where you want the file to be created (this path must already exist)
6. Enter your API key
7. Enter a name for the server/instance you are running

The agent will now be running and you should see data appearing in your New Relic account.
Lastly, you will probably want to daemonize the process and set it to run at startup, using whatever your prefered method is
