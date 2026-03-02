# Start

```bash
#Terminal 1
./run-netboot.sh
#Terminal 2 (do after the above)
./run-dhcp-server.sh enx00e04c681bf1 enx00e04c613e75
```

# Setup to pull local images
- Go to http://localhost:3000/
- Select "Local Assets"
- Download all desired images
    - Example Ubuntu 22.04
        - ubuntu-netboot-22.04-amd64	22.04.5-be230164/initrd	
        - ubuntu-netboot-22.04-amd64	22.04.5-be230164/vmlinuz