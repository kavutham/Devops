# Linux Interview Quick Notes

## CPU

- top --> It provides a dynamic, scrolling view of your running processes, CPU usage, memory consumption, and system uptime. Think of it as the Linux version of Task Manager. htop --> colour coded

- top -i --> only non-idle process. Easier to see the resource hogs from 100s of process.

- top -u --> only process used by specific username



## Memory usage of a process from physical ram, (Memory audit)

- ps -o pid,rss,comm -p <pid> -->
```bash
```bash
```bash
ps- process status, -o only following outputs, rss- resident set size ( portion of RAM occupied by a process that is actually held in physical memory), -p to processID if you know already which one, comm - command displays the process name.
```
```
```

args -- shows full command like python3 myscript.py

pmap <pid> ' memory mapping - tells you exactly where that memory is going inside the process.

smem ' detailed memory usage



- **glances** --> All in one.It puts CPU, RAM, Disk I/O, Network, and Process lists all on one screen. (Usually needs sudo apt install glances).



**Stack** for: Temporary math, loop counters, short-lived variables that don't need to be shared.Deleted automatically when function ends. StackOverflowError (too many functions).

**Heap** for: Storing database records, user sessions, image data, or anything where you don't know the exact size until the app starts running. Stays until manually deleted or "collected." OutOfMemoryError (no room left).

**Garbage Collector** is a background janitor. It scans the Heap for data that is no longer "reachable" (nothing is using it) and deletes it to free up space.

**Swap Memory**: Swap is "Emergency RAM" located on your Hard Drive. When your 4GB of physical RAM is full, Linux moves "cold" (unused) data from the RAM to the Swap partition on the disk to make room for active tasks. Slower than RAM measure in milliseconds where RAM in nanoseconds.



## Java heap setting

```bash
```bash
```bash
java -Xms512m -Xmx2g -jar app.jar
```
```
```

- Xms --> starting heap size Xmx Max heap size.



## Troubleshooting Scenarios:

## **High CPU, app slow**	Garbage Collector is working too hard.
**Troubleshoot**: jstat (Java) or top shows 100% CPU while app is not processing any requests.
**Sol**: Increase Heap size.

## **High %util, high await**	Swap is being used; disk is bottlenecked. uour app needs 3GB, but only 2GB of RAM is free. It starts using Swap.
**Troubleshoot**: iostat -x 1
**Sol**: Reduce the Heap size to fit in physical RAM or shut down other background processes.

## **App process missing**	OOM Killer killed it for over-using RAM. App tried to use more RAM than the 4GB physical limit + Swap. To save the whole computer from crashing, the Linux Kernel picks a "victim" and kills it
**Troubleshoot**: dmesg -T grep -i oom (dmesg is command-line utility used to examine and control the kernel ring buffer. Basically check for hardware issue, boot debugging, system crashes)
**Sol**:  If you see "Out of memory: Kill process," you need to either limit the app's heap or add more RAM.

## **StackOverflowError**	Stack is full (likely infinite recursion).	App Logs

## **Gradual RAM climb**	Memory Leak in the Heap.	**ps -o rss** (watch over time) \&\& **pmap**





## Disk:

- iostat --> shows the input output write of disk and its performance.

- iostat -z --> hides disk with zero activity,

- iostat -h --> human friendly.

```bash
```bash
```bash
df - show disk 	usage
```
```
```

```bash
```bash
```bash
du - show directory space usage
```
```
```



- **Hard link** is the same file, using the same inode --> Link works even if original file is deleted. "**ln file link**"
Hardlink cannot be created for directories. Used for backups.


**Soft lin**k is a shortcut to another file, using a different inode. delete the original file, the soft link "breaks" To link or create shortcut.
## ln -s file link

If a file in ls -l starting with an l (e.g., lrwxrwxrwx), that is a Soft Link.



## Networking

- **strace -p <pid>** --> "X-ray" for apps. It shows every interaction the app has with the Linux Kernel in real-time (opening files, sending network packets, etc.). Use this when an app is "stuck" and you don't know why.



## Connection timed out

Means: You are NOT reaching the server at all

## Typical causes:

Security Group blocking

NACL blocking

Route table issue

Server down

Wrong IP



## Connection refused

**Means**: You reached the server, but nothing is listening on that port

## Typical causes:

* SSH service (sshd) not running
* SSH on different port
* Firewall (iptables/firewalld) rejecting

**Solution**: ss -tulnp | grep 22

If not listening,

Check for the sshd service running

- **Sol**: systemctl status sshd, \& check for port grep Port /etc/ssh/sshd\_config --> if not check for the logs

## journalctl -u sshd -n 20

journalctl is used to query and display logs from journald the logging service for system.

"I check sshd status to ensure the service is running; if not, I can see failure reasons in the journal logs.



## User \& Root

- sudo --> Runs single command as root

```bash
```bash
```bash
sudo su - Switches to root user, keeps current environment
```
```
```

- sudo su - --> Switch to root, load roots environment ' lands in /root

- useradd -m john --> -m create home directory

passwd john

groupadd devops

usermod -aG devops johb



su - john --switch with login env

- su john --> switch to user but use current env

- sudo su -john --> switch user as root.



vi /etc/sudoers

john ALL=(ALL) /usr/bin/systemctl,/usr/bin/journalctl -- Specific to certain commands

```bash
```bash
```bash
sudo -l -U john -- Check sudo rights
```
```
```



\- explain each what when to use why

create user and group add it to sudoers file



**ssh-keygen** is a tool to generate an authentication key pair for SSH.





**nohup myscript.sh > output.log 2>\&1** \&  (Executes a command in the background, detaching it from the current session and redirecting output to a log file.)

```bash
```bash
```bash
nohup ' ignores hangup (logout)
```
```
```

> output.log ' redirect stdout

2>\&1 ' redirect stderr to stdout (so all logs go to same file) 1 is stdout 2 is stderr

- \& at end --> runs in background



## Disk Mount

## Attach isntance shows as /dev/xvdf
## Verify the disk lsblk
- 3. Format only one time --> mkfs -t ext4 /dev/xvdf --> Dont format the wrong disk. (ext4 is a filesystem format widely used for reliabilty and performance.
- 4. create mount point directory --> mkdir /data (could be any directory, /mnt/app)
## Mount using mount /dev/xvdf /data
- 6. Persist after reboot vim /etc/fstab \&\& /dev/xvdf  /data  ext4  defaults,nofail  0  2 --> Ensure to use uuid instead of disk name as it can be changed after reboot.
## Give permission to user chown -R appuser:appuser /data



UUID is Unique ID of the disk usually a number check it using blkid



**Scneario**:



## Application is failing with No space left on device. But root / is only 60% used.

After checking df -h, I would check:

Open deleted files using lsof | grep deleted

Metadata (Inode) exhaustion using df -i



Inode stores file size, owner, permission, timestamps but not the filenames

each file consumes one inode. Generally 1 inode for 16kb thereby 6.5 million for 100GB partition.



Free Inode by deleting the files after finding them using du --inodes -d 3 / | sort -nr | head . Clean up old logs (/var/log), Temp file /tmp, misconfigured apps creating multiple small files.





## Server goes into emergency mode and no boot due to fstab.

**Ans**: Access the system first using serial console or detach the volume and mount somewhere else first as initial boot itself failed.

The system likely failed to mount the disk during boot due to incorrect device mapping or unavailable volume, causing emergency mode.

I would access via recovery/console, fix /etc/fstab using UUID and add nofail to prevent boot blocking, then reboot.

nofail means: If this mount fails during boot, dont stop the system from booting.





## App running in local ss -tunlp | grep port 8080 shows 127.0.0.1:8080, But app not listening from other server. What to check.

Check first the binding in server a.  is it listening to all interface 0.0.0.0:8080 (Fix first from local). Edit app or service config and restart systemctl restart service.

Check for iptables (kernel build in firewall) - Check for the drop rules for port 8080 and allow it. (iptables -A INPUT -p tcp --dport 8080 -j ACCEPT)

**INPUT**	Traffic entering the server for a local process.	Allowing a browser to access your web app on port 8080.

**OUTPUT**	Traffic leaving the server, started by a local process.	Letting your server download updates or connect to a database.

**FORWARD**	Traffic passing through the server to a different destination.	Using your server as a router or VPN gateway for other devices.

Check for security group and route table (external)



## Production Outage. The payment service on server prod-app-01 is down. Users report timeouts.

## Check for the service is running systemctl status service, Check for the logs
## Logs \& disk ' space, permissions, inodes
- 3. Networking ' binding, firewall, SG --> check for the port running, binding is there, iptables allow
## Permissions / sudo ' ensure app user can write
- 5. External check last ' cloud/network --> Check for SG, NACL, Route table.



## Load average is high but CPU usage is low. How do you explain and debug this?

High load but low CPU usually means blocked processes, e.g., I/O wait or locks, not CPU saturation.

## top -i

- **iostat -x 1 5** --> Checks for this when CPU and memory looks okay. Storage Disk could be sluggish have issue with input output write

- x --> Without it, you only get basic read/write speeds. With it, you get deep stats like latency and %util (how busy the drive is).

- 1 --> refresh each 1 second

- 5 --> stops after 5 reports



