## Antelope Node Configurations
In an attempt to help node operators have a recommended configuration for creating/running their own nodes, we are now publishing the EOSUSA standard configurations we deploy throughout our organization for all our Antelope nodes.  While these are what we consider the recommended settings each environment and use case is unique ,its always encouraged to become more familiar with the configurations and options. 

EOSUSA also maintains a Google Spreadsheet with a break down of most common parameters with details about what each does and what Antelope version they were introcude/depricated in:  [NodeOS Config Matrix](https://docs.google.com/spreadsheets/d/1javR5ibcSuR58Bdhj3hz_rddO7MUfquqzLTmB3f8OTs/edit?usp=sharing)

All current configurations are for the latest version of Antelope (currently v5.x) and will be updated to the latest stable release as available.  You can find the latest version of the Antelope Leap software here: https://github.com/AntelopeIO/leap

## Node Types/Default Configurations
We primarily group our node types (and therefore configurations) into 4 primary groups:
- Common Settings (All Nodes)
- API/P2P Nodes: [api.config.ini](https://github.com/eosusa/antelope-config/blob/main/api.config.ini)
- State History Nodes: [ship.config.ini](https://github.com/eosusa/antelope-config/blob/main/ship.config.ini)
- Block Producer Nodes: [bp.config.ini](https://github.com/eosusa/antelope-config/blob/main/bp.config.ini)
  
There are many other types of nodes and some of node configurations have some extra features (P2P don't need API settings, but serve as API backups), but this generally fits what most our nodes do. Most other node types start from the api.config.ini template.  Again, these are our default recommended settings for getting started; there may be further changes/parameters needed depending on your specific use case.

## Node Start/Stop Scripts
There are many different ways to run the Antelope services on your server (such as systemd), but EOSUSA has implemented the process to manage the nodes manually via start/stop scripts (with logging out to a txt file). I believe the original came from a CryptoLions example, so credit to them for the base mechanics. :) As we maintain different binary versions (locally built), this assumes the nodeos binary is already availbale on the server (either in /bin/usr/ or other location) and the location of the binary is specified in the start.sh script.

- [start.sh](https://github.com/eosusa/antelope-config/blob/main/scripts/start.sh) - Copy to node data directory (/opt/WAXmainNet/ in our scripts; where config.ini lives), update BINPATH to appropriate location (as needed), and launch using start.sh and passing any additional nodeos parameters desired (such as --disable-replay-opts)
  - Stops previous nodeos instance running (assuming PID matches)
  - Assures server ulimits are updated as needed for nodeos
  - Launches nodeos using config.ini in same directory
  - Passes any extra parameters through to nodeos (such as --snapshot snapshot.bin)
  - Saves nodeos output to stderr.txt file in same directory
  - Saves PID of nodeos process (used for stop.sh script)
 
- [stop.sh](https://github.com/eosusa/antelope-config/blob/main/scripts/stop.sh) - Copy to node data directory
  - Stops previous nodeos instance running (assuming PID matches)
  - Compresses current stderr.txt log file into /logs/

## CPU Performance Settings
It is critical that your Antelope node has the processor configured for optimal performance mode to assure the processing (and therefore potential billing) of transactions on the node are accurate. Each processor can have it's own specific settings that can/should be modified, and since we run Intel i9 processors, the settings below are recommended for the Intel i9 (tested on 10th and 14th generations), but they could be different depending on your node's processor. We have found there are 3 main settings that are needed:
- Force the CPU power profile to "Performance" (```/usr/bin/cpupower frequency-set -g performance```)
- Disable CPU idle states (```/usr/bin/cpupower idle-set -D 11```)
- Disable CPU pstate (Intel) (```echo passive > /sys/devices/system/cpu/intel_pstate/status```)
  
As the CPU performance/idle settings get reset upon restart of the OS, it's recommended to add the commands to update them as a system service so they persist the reboot (Intel pstate is file-based/persistent). [cpuperf.sh](https://github.com/eosusa/antelope-config/blob/main/cpuperf/cpupower.sh) is available to create the service and update the settings as needed (run as root).

