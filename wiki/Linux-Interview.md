| Prev | Home | Next |
|---|---|---|
| [[Kubernetes]] | [[Home]] | [[Resume-STAR]] |

# Linux Interview Quick Notes

## CPU
- `top` → dynamic process view (Linux Task Manager). `htop` → color coded.
- `top -i` → only non-idle processes (find real hogs).
- `top -u <user>` → processes for a specific user.

## Memory usage of a process (Memory audit)
- `ps -o pid,rss,comm -p <pid>`:
```bash
# ps: process status
# -o: choose output columns
# rss: resident set size (RAM actually used)
# -p: by process ID
# comm: command name
ps -o pid,rss,comm -p 1234
```
- `args` shows full command (e.g., `python3 myscript.py`)
- `pmap <pid>` → memory map breakdown
- `smem` → detailed memory usage
- **glances** → all-in-one (CPU, RAM, Disk I/O, Network, Processes)

**Stack**: for temporary variables. Fails with StackOverflowError (deep recursion).

**Heap**: for dynamic allocations (sessions, images, caches). Risk of OutOfMemoryError.

**Garbage Collector**: frees unreachable heap memory.

**Swap Memory**: disk-backed “emergency RAM”; far slower than RAM.

## Java heap setting
```bash
java -Xms512m -Xmx2g -jar app.jar
```
- `-Xms` → starting heap; `-Xmx` → max heap.

## Troubleshooting Scenarios
- **High CPU, app slow** → GC thrashing. Check `jstat`, `top`. Solution: increase heap or tune GC.
- **High %util, high await** → swap/disk bottleneck. Check `iostat -x 1`. Fit in RAM or reduce heap.
- **App process missing** → OOM Killer. Check `dmesg -T | grep -i oom`. Reduce heap or add RAM.
- **StackOverflowError** → infinite recursion. Check app logs.
- **Gradual RAM climb** → heap leak. Watch `ps -o rss` and `pmap`.

## Disk
- `iostat` → disk I/O perf; `iostat -z` (hide zero-activity), `iostat -h` (human).
- Filesystem usage:
```bash
df -h    # disk usage per filesystem
du -h --max-depth=1 /var/log   # directory usage
```

**Hard link**: same inode; survives if original deleted. `ln file link`

**Soft link**: shortcut to another inode; breaks if target deleted. `ln -s file link`

If `ls -l` starts with `l` (e.g., `lrwxrwxrwx`) → soft link.

## Networking
- `strace -p <pid>` → inspect syscalls for “stuck” apps.

### Connection timed out
Means you are not reaching the server.
- Causes: Security Group, NACL, route table, server down, wrong IP.

### Connection refused
Means you reached the server, but nothing is listening.
- Causes: `sshd` not running, wrong port, firewall blocks.
- Check:
```bash
ss -tulnp | grep 22
systemctl status sshd
grep -i '^Port' /etc/ssh/sshd_config
journalctl -u sshd -n 20
```

## User & Root
- `sudo` → run a single command as root
- `sudo su -` → switch to root with login env (`/root`)
- `su - john` → switch with login env; `su john` → keep current env
- Manage users:
```bash
useradd -m john
passwd john
groupadd devops
usermod -aG devops john
visudo   # edit /etc/sudoers
```
Example sudoers rule:
```bash
john ALL=(ALL) /usr/bin/systemctl, /usr/bin/journalctl
sudo -l -U john
```

## nohup/background
```bash
nohup myscript.sh > output.log 2>&1 &
# nohup: ignore hangup
# > output.log: redirect stdout
# 2>&1: redirect stderr to stdout
# &: run in background
```

## Disk Mount
- Attach instance device `/dev/xvdf`
- Verify: `lsblk`
- Format (once): `mkfs -t ext4 /dev/xvdf`
- Create mount point: `mkdir /data`
- Mount: `mount /dev/xvdf /data`
- Persist after reboot (`/etc/fstab`) using UUID and `nofail`
- Permissions: `chown -R appuser:appuser /data`
- Get UUID: `blkid`

### Scenario: No space left on device but `/` is 60% used
- Check deleted open files: `lsof | grep deleted`
- Check inodes: `df -i` (inode exhaustion)
- Free inodes (example):
```bash
du --inodes -d 3 / | sort -nr | head
```

### Server in emergency mode due to fstab
- Use serial console or detach/mount elsewhere; fix `/etc/fstab` to use UUID + `nofail`

### App listens only on 127.0.0.1:8080
- Bind to `0.0.0.0:8080`
- Open firewall (iptables):
```bash
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
```
- Check SG/NACL/Routes (cloud)

### Production Outage checklist (timeouts on prod-app-01)
- Check service status and logs:
```bash
systemctl status <service>
journalctl -u <service> -n 100 --no-pager
```
- Storage checks: disk usage, permissions, inodes
- Networking: binding/ports, firewall rules, SG/NACL/Route tables
- Permissions/sudo: ensure app user can write where needed
- External dependencies: cloud/network/security config

## Load average high, CPU low
- Often I/O wait or locks; check `iostat -x 1 5`, `top -i`

