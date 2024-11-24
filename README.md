# linPEVES
**Lin**ux **P**rivilege **E**scalation and **V**ulnerability **E**xploit **S**cript

We're making malware and changing lives for the worse


## Installing linPEVES
To download linPEVES, click the big green `Code` button, and then click "Download Zip".

Unzip the downloaded file and change directory into the `linPEVES/` directory where the `main.sh` file is located.
```
cd linPEVES/
```


## Running linPEVES
Running `./main.sh -h` will print the script's help information. It is reproduced below:
```
██╗           ██████╗ ███████╗██╗   ██╗███████╗███████╗
██║██╗        ██╔══██╗██╔════╝██║   ██║██╔════╝██╔════╝
██║╚═╝█████╗  ██████╔╝█████╗  ██║   ██║█████╗  ███████╗
██║██╗██╔══██╗██╔═══╝ ██╔══╝  ╚██╗ ██╔╝██╔══╝  ╚════██║
██║██║██║  ██║██║     ███████╗ ╚████╔╝ ███████╗███████║
╚═╝╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝  ╚═══╝  ╚══════╝╚══════╝


Usage: ./main.sh [-s|--scan <args>] || [-e|--exploit <args>] [-p|--prompt] [-v|--verbose] [-V|--version] [-l|--list] [-h|--help]
        -s, --scan: List of scans to run (no default)
        -e, --exploit: List of exploits to run (no default)
        -p, --prompt: Prompt user before exploit (false by default)
        -v, --verbose: Add verbosity to script (false by default)
        -l, --list: Lists all scans and their associated numerical indices
        -V, --version: Prints version
        -h, --help: Prints help
```


From there, you can decide which scans and exploits you want to run. To see the table of available scans and exploits, run `./main.sh --list`. The list is reproduced below:
```
- [ List of Scans and Exploits ] -

  # |             SCANS             |           EXPLOITS
----+-------------------------------+-------------------------------
  0 | cron-scan                     | cron-exploit
  1 | env-var-scan                  | env-var-exploit
  2 | path-scan                     | path-exploit
  3 | pkexec-scan                   | pkexec-exploit
  4 | readable-passwd-scan          | readable-passwd-exploit
  5 | readable-shadow-scan          | readable-shadow-exploit
  6 | shellshock-scan               | shellshock-exploit
  7 | sudo-scan                     | sudo-exploit
  8 | sudoers-scan                  | sudoers-exploit
  9 | systemctl-bin-scan            | systemctl-bin-exploit
 10 | writable-passwd-scan          | writable-passwd-exploit
 11 | writable-shadow-scan          | writable-shadow-exploit
```

You can run a scan/exploit by referencing their indices in the table. For example, if you wanted to run all scans but only exploit vulnerabilities 1 and 7, you would run the following command:
```
./main.sh -s {0..11} -e 1 7
```
